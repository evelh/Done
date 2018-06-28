using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Text.RegularExpressions;



namespace EMT.DoneNOW.BLL
{
    public class SaleOrderBLL
    {
        private crm_sales_order_dal _dal = new crm_sales_order_dal();
        /// <summary>
        /// 获取到销售订单相关字典表
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("sales_order_status", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.SALES_ORDER_STATUS))); // 销售订单状态
            dic.Add("sys_resource", new sys_resource_dal().GetDictionary(true));  // 负责人
            dic.Add("country", new DistrictBLL().GetCountryList()); // 国家
            dic.Add("addressdistrict", new d_district_dal().GetDictionary());                 // 地址表（省市县区）

            dic.Add("opportunity_stage", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_STAGE)));          // 商机阶段
            dic.Add("oppportunity_status", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_STATUS)));          // 商机状态
            return dic;
        }

        /// <summary>
        /// 修改销售订单
        /// </summary>
        /// <param name="sale_order"></param>
        /// <param name="udfValue"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE EditSaleOrder(crm_sales_order sale_order, List<UserDefinedFieldValue> udfValue, long user_id)
        {
            if (sale_order.status_id == 0 || sale_order.contact_id == 0 || sale_order.owner_resource_id == 0)
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            if (sale_order.begin_date.ToString("yyyy-MM-dd") == "0001-01-01" || sale_order.end_date == null || ((DateTime)sale_order.end_date).ToString("yyyy-MM-dd") == "0001-01-01")
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            var user = UserInfoBLL.GetUserInfo(user_id);

            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;

            var old_sale_order = new crm_sales_order_dal().GetSingleSalesOrderByWhere($" and id= {sale_order.id}");

            sale_order.oid = old_sale_order.oid;
            sale_order.opportunity_id = old_sale_order.opportunity_id;
            sale_order.create_user_id = old_sale_order.create_user_id;
            sale_order.create_time = old_sale_order.create_time;
            sale_order.update_user_id = user.id;
            sale_order.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            _dal.Update(sale_order);

            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user_id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SALE_ORDER,
                oper_object_id = sale_order.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old_sale_order, sale_order),
                remark = "修改销售订单"
            });



            // 销售订单自定义

            var udf_sales_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.SALES);
            new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.SALES, udf_sales_list, sale_order.id, udfValue, user, OPER_LOG_OBJ_CATE.SALE_ORDER);


            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 更改销售订单的状态
        /// </summary>
        /// <returns></returns>
        public bool UpdateSaleOrderStatus(long sid, int status_id, long user_id)
        {
            var sale = _dal.GetSingleSale(sid);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (sale != null && user != null)
            {
                sale.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                sale.update_user_id = user.id;
                sale.status_id = status_id;

                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user_id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SALE_ORDER,
                    oper_object_id = sale.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.CompareValue(_dal.GetSingleSale(sid), sale),
                    remark = "修改销售订单状态"
                });
                _dal.Update(sale);
                return true;
            }

            return false;
        }

        /// <summary>
        /// 获取销售订单
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public crm_sales_order GetSaleOrder(long id)
        {
            return _dal.FindById(id);
        }
        /// <summary>
        /// 根据成本状态更改销售订单状态
        /// </summary>
        /// <param name="cost_id"></param>
        /// <param name="isDoneOrder">是否将销售订单完成</param>
        /// <returns></returns>
        public bool ChangeSaleOrderStatus(long cost_id, long user_id, out bool isDoneOrder)
        {
            isDoneOrder = false;
            var thisOrder = _dal.GetOrderByCostId(cost_id);
            var thisCost = new ctt_contract_cost_dal().FindNoDeleteById(cost_id);
            if (thisOrder != null && thisCost != null)
            {
                var proList = new ctt_contract_cost_product_dal().GetListBySale(thisOrder.id);
                var costList = new ctt_contract_cost_dal().GetListBySaleOrderId(thisOrder.id);
                var oldOrderStatus = thisOrder.status_id;
                if (proList != null && proList.Count > 0&& costList!=null&& costList.Count>0)
                {
                    if (costList.Any(_ => _.status_id == (int)DicEnum.COST_STATUS.PENDING_DELIVERY) && oldOrderStatus == (int)SALES_ORDER_STATUS.OPEN)
                    {
                        thisOrder.status_id = (int)SALES_ORDER_STATUS.IN_PROGRESS;

                    }
                    if (costList.Any(_ => _.status_id == (int)DicEnum.COST_STATUS.ALREADY_DELIVERED) && (oldOrderStatus == (int)SALES_ORDER_STATUS.OPEN || oldOrderStatus == (int)SALES_ORDER_STATUS.IN_PROGRESS))
                    {
                        thisOrder.status_id = (int)SALES_ORDER_STATUS.PARTIALLY_FULFILLED;
                    }

                    // 获取销售订单下的所有成本，所有成本下的所有成本产品 已配送的时候，进行提示 isDoneOrder = true


                    if (!proList.Any(_ => _.status_id != (int)CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION))
                    {
                        isDoneOrder = true;
                    }
                }
                // 如果销售订单下的产品部分已配送，且销售订单状态为“进行中”/“新建”，则将其状态置为“部分发货”
                if (oldOrderStatus != thisOrder.status_id)
                {
                    var oldOrder = _dal.FindNoDeleteById(thisOrder.id);
                    thisOrder.update_user_id = user_id;
                    thisOrder.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    _dal.Update(thisOrder);
                    OperLogBLL.OperLogUpdate<crm_sales_order>(thisOrder, oldOrder, thisOrder.id, user_id, OPER_LOG_OBJ_CATE.SALE_ORDER, "修改销售订单状态");

                }
                return true;

            }
            return false;
        }
        /// <summary>
        /// 通过成本完成销售订单
        /// </summary>
        public bool DoneSaleByCost(long costId, long user_id)
        {
            var thisSale = _dal.GetOrderByCostId(costId);
            if (thisSale == null)
            {
                return false;
            }
            if (thisSale.status_id != (int)DicEnum.SALES_ORDER_STATUS.FULFILLED)
            {
                var oldSale = _dal.FindNoDeleteById(thisSale.id);
                thisSale.status_id = (int)DicEnum.SALES_ORDER_STATUS.FULFILLED;
                thisSale.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisSale.update_user_id = user_id;
                _dal.Update(thisSale);
                OperLogBLL.OperLogUpdate<crm_sales_order>(thisSale, oldSale, thisSale.id, user_id, OPER_LOG_OBJ_CATE.SALE_ORDER, "修改销售订单状态");
            }


            return true;
        }


        /// <summary>
        /// 编辑销售订单
        /// </summary>
        public void EditSaleOrder(crm_sales_order sale, long userId)
        {
            var oldSale = GetSaleOrder(sale.id);
            if (oldSale == null)
                return;
            sale.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            sale.update_user_id = userId;
            _dal.Update(sale);
            OperLogBLL.OperLogUpdate<crm_sales_order>(sale, oldSale, sale.id, userId, OPER_LOG_OBJ_CATE.SALE_ORDER, "");
        }

        #region 销售目标设置
        /// <summary>
        /// 获取员工本年的销售目标
        /// </summary>
        public List<sys_resource_sales_quota> GetResYearQuota(long resourceId,int year)
        {
            return _dal.FindListBySql<sys_resource_sales_quota>($"SELECT * from sys_resource_sales_quota where  resource_id = {resourceId} and year = {year} and delete_time =0");
        }

        /// <summary>
        /// 获取员工某个月的销售目标
        /// </summary>
        public sys_resource_sales_quota GetResMonthQuota(long resourceId, int year,int month)
        {
            return _dal.FindSignleBySql<sys_resource_sales_quota>($"SELECT * from sys_resource_sales_quota where  resource_id = {resourceId} and year = {year} and month ={month} and delete_time =0");
        }

        /// <summary>
        /// 根据Id 获取相关设置
        /// </summary>
        public sys_resource_sales_quota GetQuotaById(long id) => new sys_resource_sales_quota_dal().FindNoDeleteById(id);
        /// <summary>
        /// 新增员工目标
        /// </summary>
        public bool AddResQuota(sys_resource_sales_quota quota,long userId)
        {
            sys_resource_sales_quota_dal srsqDal = new sys_resource_sales_quota_dal();
            sys_resource_sales_quota checkQuota = GetResMonthQuota(quota.resource_id,quota.year,quota.month);
            if (checkQuota != null)
                return false;
            quota.id = srsqDal.GetNextIdCom();
            quota.create_time = quota.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            quota.create_user_id = quota.update_user_id = userId;
            srsqDal.Insert(quota);
            return true;
        }
        /// <summary>
        /// 编辑员工目标
        /// </summary>
        public bool EditResQuota(sys_resource_sales_quota quota, long userId)
        {
            sys_resource_sales_quota_dal srsqDal = new sys_resource_sales_quota_dal();
            sys_resource_sales_quota oldQuota = GetQuotaById(quota.id);
            if (oldQuota == null)
                return false;
            quota.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            quota.update_user_id = userId;
            srsqDal.Update(quota);
            return true;
        }

        public bool DeleteQuota(long id,long userId)
        {
            var quota = GetQuotaById(id);
            if (quota == null)
                return false;
            new sys_resource_sales_quota_dal().SoftDelete(quota,userId);
            return true;
        }



        #endregion



    }
}
