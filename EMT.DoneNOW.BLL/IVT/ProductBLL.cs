﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Data.SqlClient;

namespace EMT.DoneNOW.BLL
{
    public class ProductBLL
    {
        private readonly ivt_product_dal _dal = new ivt_product_dal();
        private readonly ivt_product_vendor_dal _dal1 = new ivt_product_vendor_dal();
        ///通过id获取ivt_product产品对象
        public ivt_product GetProduct(long id)
        {
            return _dal.FindSignleBySql<ivt_product>($"select * from ivt_product where id={id} and delete_time = 0 ");
        }
        /// <summary>
        /// 获取物料代码名称
        /// </summary>
        /// <param name="cost_code_id"></param>
        /// <returns></returns>
        public string cost_code_name(long cost_code_id) {
            return new d_cost_code_dal().FindById(cost_code_id).name;
        }
        /// <summary>
        /// 获取产品供应商对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_product_vendor GetSingelVendor(long id)
        {
            return _dal1.FindSignleBySql<ivt_product_vendor>($"select * from ivt_product_vendor where id={id} and delete_time=0");
        }
        /// <summary>
        /// 获取供应商名称
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public string GetVendorName(long id)
        {
            return new crm_account_dal().FindSignleBySql<crm_account>($"select * from crm_account where id={id} and delete_time=0").name;
        }
        /// <summary>
        /// 通过产品id,返回供应商对象集合
        /// </summary>
        /// <param name="product_id"></param>
        /// <returns></returns>
        public List<ivt_product_vendor> GetVendorList(long product_id)
        {
            return _dal1.FindListBySql<ivt_product_vendor>($"select * from ivt_product_vendor where product_id={product_id} and delete_time=0").ToList();
        }
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();

            dic.Add("Item_Type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.INSTALLED_PRODUCT_CATE)));              // 默认自定义配置项
            dic.Add("Period_Type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE)));              // 周期类型
            return dic;
        }
        /// <summary>
        /// 新增产品和相关供应商信息
        /// </summary>
        /// <param name="product">产品</param>
        /// <param name="vendordata">供应商集合</param>
        /// <param name="udf">自定义字段值</param>
        /// <param name="user_id">操作用户</param>
        /// <returns></returns>
        public ERROR_CODE InsertProductAndVendor(ivt_product product, VendorData vendordata, List<UserDefinedFieldValue> udf, long user_id) {
            //产品
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            product.id = (int)(_dal.GetNextIdCom());

            product.create_time=product.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            product.create_user_id =product.update_user_id= user_id;
           
            //唯一性校验
            var propro = _dal.FindSignleBySql<ivt_product>($"select * from ivt_product where name='{ product.name}' and delete_time=0 ");
            if (propro != null) {
                return ERROR_CODE.EXIST;
            }

            _dal.Insert(product);            
                //更新日志
                var add_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT,
                    oper_object_id = product.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(product),
                    remark = "新增产品信息"
                };          // 创建日志
                new sys_oper_log_dal().Insert(add_log);       // 插入日志

                //供应商
                foreach (var ve in vendordata.VENDOR)
            {
                ivt_product_vendor veve = new ivt_product_vendor();
                if (ve.operate == 3) {
                    veve.id = (int)(_dal.GetNextIdCom());
                   veve.update_time= veve.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    veve.create_user_id = user_id;
                    veve.product_id = product.id;
                    veve.is_active = ve.is_active;
                    veve.is_default = ve.is_default;
                    veve.vendor_account_id = ve.vendor_account_id;
                    veve.vendor_cost = ve.vendor_cost;
                    veve.vendor_product_no = ve.vendor_product_no;
                    _dal1.Insert(veve);

                    var add_vendor_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT_VENDOR,
                        oper_object_id = veve.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal1.AddValue(veve),
                        remark = "新增供应商信息"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add_vendor_log);       // 插入日志
                }
            }


            #region 保存产品扩展信息          

            var udf_contact_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.PRODUCTS); // 产品的自定义字段
            var udf_con_list = udf;                                       // 传过来的产品
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.PRODUCTS, user_id,product.id, udf_contact_list, udf_con_list, OPER_LOG_OBJ_CATE.PRODUCT); // 保存成功即插入日志
            #endregion

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 修改更新产品和相关供应商信息
        /// </summary>
        /// <param name="product">产品</param>
        /// <param name="vendordata">供应商集合</param>
        /// <param name="udf">自定义字段值</param>
        /// <param name="user_id">操作用户</param>
        /// <returns></returns>
        public ERROR_CODE UpdateProductAndVendor(ivt_product product, VendorData vendordata, List<UserDefinedFieldValue> udf, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            //产品更新
            product.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            product.update_user_id = user_id;

            //唯一性校验
            var propro = _dal.FindSignleBySql<ivt_product>($"select * from ivt_product where name='{product.name}' and delete_time=0 ");
            ivt_product oldpropro = _dal.FindSignleBySql<ivt_product>($"select * from ivt_product where id='{product.id}' and delete_time=0 ");
            if (propro != null&&product.id!=propro.id)
            {
                return ERROR_CODE.EXIST;
            }
            //更新日志
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT,
                oper_object_id = product.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(oldpropro,product),
                remark = "修改产品信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            if (!_dal.Update(product))
            {
                return ERROR_CODE.ERROR;
            }
            //供应商更新
            foreach (var ve in vendordata.VENDOR)
            {
                ivt_product_vendor veve = new ivt_product_vendor();
                //删除
                if (ve.operate == 1) {
                    var de = _dal1.FindById(ve.id);
                    if (de != null) {
                        de.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        de.delete_user_id = user_id;
                        _dal1.Update(de);
                        var add_vendor_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name =user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT_VENDOR,
                            oper_object_id = veve.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                            oper_description =_dal1.AddValue(veve),
                            remark = "删除供应商信息"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_vendor_log);       // 插入日志
                    }

                }

                //更新
                if (ve.operate == 2) {
                    veve = _dal1.FindById(ve.id);
                    if (veve != null) {
                        veve.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        veve.update_user_id = user_id;
                        veve.product_id = product.id;
                        veve.is_active = ve.is_active;
                        veve.is_default = ve.is_default;
                        veve.vendor_account_id = ve.vendor_account_id;
                        veve.vendor_cost = ve.vendor_cost;
                        veve.vendor_product_no = ve.vendor_product_no;
                        var oldve = GetSingelVendor(veve.id);
                        _dal1.Update(veve);
                        var add_vendor_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name =user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT_VENDOR,
                            oper_object_id = veve.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal1.CompareValue(oldve,veve),
                            remark = "修改供应商信息"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_vendor_log);       // 插入日志
                    }
                }

                //新增
                if (ve.operate == 3) {
                    veve.id = (int)(_dal.GetNextIdCom());
                    veve.update_time = veve.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    veve.create_user_id = user_id;
                    veve.product_id = product.id;
                    veve.is_active = ve.is_active;
                    veve.is_default = ve.is_default;
                    veve.vendor_account_id = ve.vendor_account_id;
                    veve.vendor_cost = ve.vendor_cost;
                    veve.vendor_product_no = ve.vendor_product_no;
                    _dal1.Insert(veve);
                    var add_vendor_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name =user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT_VENDOR,
                        oper_object_id = veve.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal1.AddValue(veve),
                        remark = "新增供应商信息"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add_vendor_log);       // 插入日志
                }

            }

            var udfBll = new UserDefinedFieldsBLL();
            var udf_contact_list = udfBll.GetUdf(DicEnum.UDF_CATE.PRODUCTS); // 产品的自定义字段
            udfBll.UpdateUdfValue(UDF_CATE.PRODUCTS, udf_contact_list, product.id, udf, new UserInfoDto { id = user.id, name = user.name }, OPER_LOG_OBJ_CATE.PRODUCT);

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 不存在该产品的仓库名称和id
        /// </summary>
        /// <returns></returns>
        public Dictionary<long, string> GetWarehouseDownList(long product_id)
        {
            Dictionary<long, string> dic = new Dictionary<long, string>();
            return new ivt_warehouse_dal().FindListBySql<ivt_warehouse>($"select distinct a.* from ivt_warehouse a,ivt_warehouse_product b where a.delete_time=0 and b.delete_time=0 and a.id=b.warehouse_id and b.product_id={product_id}").ToDictionary(d => d.id, d => d.name);
        }
        /// <summary>
        /// 获取存在该产品的仓库名称和id
        /// </summary>
        /// <param name="product_id"></param>
        /// <returns></returns>
        public Dictionary<long, string> GetNoWarehouseDownList(long product_id)
        {
            Dictionary<long, string> dic = new Dictionary<long, string>();
            return new ivt_warehouse_dal().FindListBySql<ivt_warehouse>($"select distinct a.* from ivt_warehouse a,ivt_warehouse_product b where a.delete_time=0 and b.delete_time=0 and a.id=b.warehouse_id and b.product_id!='{product_id}'").ToDictionary(d => d.id, d => d.name);
        }
        public ivt_warehouse Getwarehouse(long id) {
            return new ivt_warehouse_dal().FindSignleBySql<ivt_warehouse>($"select * from ivt_warehouse where id={id} and delete_time=0");
        }

        //public ivt_warehouse GetWarehouse(long id) {
        //    return new ivt_warehouse_dal().FindSignleBySql<ivt_warehouse>($"select * from ivt_warehouse where id={id} and delete_time=0");
        //}
        /// <summary>
        /// 通过id获取一个ivt_warehouse_product对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_warehouse_product Getwarehouse_product(long id) {
            return new ivt_warehouse_product_dal().FindSignleBySql<ivt_warehouse_product>($"select * from ivt_warehouse_product where id={id} and delete_time=0");
        }
        /// <summary>
        /// 通过产品id和仓库id获取产品库存信息
        /// </summary>
        /// <param name="product_id"></param>
        /// <param name="warehouse_id"></param>
        /// <returns></returns>
        public ivt_warehouse_product Getwarehouse_product(long product_id, long warehouse_id) {
            return new ivt_warehouse_product_dal().FindSignleBySql<ivt_warehouse_product>($"select * from ivt_warehouse_product where product_id={product_id} and warehouse_id={warehouse_id} and delete_time=0");
        }
        
        /// <summary>
        ///新增产品库存信息
        /// </summary>
        /// <param name="stock"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE InsertProductStock(ivt_warehouse_product stock,long user_id) {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            //唯一性校验
            ivt_warehouse_product_dal kk = new ivt_warehouse_product_dal();
           var re= kk.FindSignleBySql<ivt_warehouse_product>($"select * from ivt_warehouse_product where product_id={stock.product_id} and warehouse_id={stock.warehouse_id} and delete_time=0");
            if (re != null) {
                return ERROR_CODE.EXIST;
            }
            stock.id= (int)(_dal.GetNextIdCom());
            stock.create_time = stock.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            stock.create_user_id = stock.update_user_id = user_id;
            kk.Insert(stock);
            //操作日志
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name =user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.WAREHOUSE_PRODUCT,//
                oper_object_id = stock.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(stock),
                remark = "新增产品库存信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 修改产品供应商信息
        /// </summary>
        /// <param name="stock"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE UpdateProductStock(ivt_warehouse_product stock, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            stock.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            stock.update_user_id = user.id;
            var old = Getwarehouse_product(stock.id);
            if (!(new ivt_warehouse_product_dal().Update(stock))) {
                return ERROR_CODE.ERROR;
            }
            //操作日志
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name =user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.WAREHOUSE_PRODUCT,//
                oper_object_id = stock.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = new ivt_warehouse_product_dal().CompareValue(old,stock),
                remark = "修改产品库存信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }
        public ERROR_CODE DeleteInventory(long id,long user_id) {           
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            ivt_warehouse_product_dal inv_dal = new ivt_warehouse_product_dal();
            var inv = inv_dal.FindNoDeleteById(id);
            if (inv == null) {
                return ERROR_CODE.ERROR;
            }
            inv.delete_user_id = user_id;
            inv.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (!inv_dal.Update(inv)) {
                return ERROR_CODE.ERROR;
            }
            //操作日志
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.WAREHOUSE_PRODUCT,//
                oper_object_id = inv.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                oper_description = _dal.AddValue(inv),
                remark = "删除产品库存信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 产品删除
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ERROR_CODE DeleteProduct(long id,long user_id, out string returnvalue) {
            returnvalue = string.Empty;
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            StringBuilder result = new StringBuilder();
            result.Append("产品不能被删除，因为它被以下对象引用\n");
            var opportunitylist = new crm_opportunity_dal().FindListBySql($"select * from crm_opportunity where primary_product_id={id} and delete_time=0");
            var installed_productlist = new crm_installed_product_dal().FindListBySql($"select * from crm_installed_product where product_id={id} and delete_time=0");
            var warehouse_productlist = new ivt_warehouse_product_dal().FindListBySql($"select * from ivt_warehouse_product where product_id={id} and delete_time=0");
            var contract_costlist = new ctt_contract_cost_dal().FindListBySql($"select * from ctt_contract_cost where product_id={id} and delete_time=0");
            int n = 1;
            if (opportunitylist.Count > 0) {
                result.Append($"{opportunitylist.Count} 商机\n");
                //foreach (var op in opportunitylist) {

                //    result.Append("N"+(n++)+"   "+op.id + "\n");
                //}
            }
            if (installed_productlist.Count > 0)
            {
                result.Append($"{installed_productlist.Count} 配置项\n");
                //foreach (var op in installed_productlist)
                //{
                //    result.Append("N" + (n++) + "  " + op.id + "\n");
                //}
            }
            if (warehouse_productlist.Count > 0)
            {
                result.Append($"{warehouse_productlist.Count} 库存\n");
                //foreach (var op in warehouse_productlist)
                //{
                //    result.Append("N" + (n++) + "  " + op.id + "\n");
                //}
            }
            if (contract_costlist.Count > 0)
            {
                result.Append($"{contract_costlist.Count} 工单\n");
                //foreach (var op in contract_costlist)
                //{
                //    result.Append("N" + (n++) + "  " + op.id + "\n");
                //}
            }
            if (contract_costlist.Count > 0 || warehouse_productlist.Count > 0 || installed_productlist.Count > 0 || opportunitylist.Count > 0) {
                returnvalue = result.ToString();
                return ERROR_CODE.EXIST;
            }            
            var product_del = _dal.FindSignleBySql<ivt_product>($"select * from ivt_product where id={id} and delete_time=0");
            if (product_del == null) {
                return ERROR_CODE.ERROR;
            }
            product_del.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            product_del.delete_user_id = user.id;
            if (!_dal.Update(product_del)) {
                return ERROR_CODE.ERROR;
            }
            //操作日志
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT,//
                oper_object_id = product_del.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                oper_description = _dal.AddValue(product_del),
                remark = "删除产品信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志


            var del = _dal.FindSignleBySql<ivt_product>($"select * from ivt_product where id={id} and delete_time=0");

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 获取产品的成本（根据系统设置相关）
        /// </summary>
        /// <param name="ipId"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public decimal? GetProCost(long ipId,long user_id)
        {
            decimal? thisCost = null;
            var thisPro = _dal.FindNoDeleteById(ipId);
            if (thisPro != null)
            {
                if (thisPro.unit_cost != null)
                {
                    thisCost = (decimal)thisPro.unit_cost;
                }
                var onHandNum = _dal.GetProOnHand(thisPro.id);
                if (onHandNum != null && (Convert.ToInt32(onHandNum)) > 0)  // 可用数要大于0
                {
                    var thisSysSet = new SysSettingBLL().GetSetById(DTO.SysSettingEnum.INVENTORY_ACCOUNTING_METHOD);
                    if (thisSysSet != null)
                    {
                        var iopDal = new ivt_order_product_dal();
                        if (thisSysSet.setting_value == ((int)INVENTORY_ACCOUNTING_METHOD.AVERAGE_COST).ToString())
                        {
                            var avgCosr = iopDal.GetAvgByPro(thisPro.id);
                            if (avgCosr != null)
                            {
                                thisCost = (decimal)avgCosr;
                            }
                        }
                        else if (thisSysSet.setting_value == ((int)INVENTORY_ACCOUNTING_METHOD.FIFO).ToString())
                        {
                            var firCosr = iopDal.GetFirstByPro(thisPro.id);
                            if (firCosr != null)
                            {
                                thisCost = (decimal)firCosr;
                            }
                        }
                        else if (thisSysSet.setting_value == ((int)INVENTORY_ACCOUNTING_METHOD.LIFO).ToString())
                        {
                            var lasCosr = iopDal.GetLastByPro(thisPro.id);
                            if (lasCosr != null)
                            {
                                thisCost = (decimal)lasCosr;
                            }
                        }
                    }
                }
                else
                {
                    return thisCost;
                }



            }

            return thisCost;
        }

        #region  产品类别管理
        public List<ProductCateDto> GetProductCateList()
        {
            var topCateList = _dal.FindListBySql<ProductCateDto>($"SELECT id,name,parent_id,(SELECT count(0) from ivt_product WHERE cate_id=g.id AND delete_time=0) as productCnt FROM d_general as g WHERE general_table_id={(int)GeneralTableEnum.PRODUCT_CATE} and parent_id is null and delete_time=0 ORDER BY id ASC;");
            List<ProductCateDto> dtoList = new List<ProductCateDto>();
            if(topCateList!=null&& topCateList.Count > 0)
            {
                foreach (var cate in topCateList)
                {
                    cate.nodes = AddSubNode(cate.id);
                    dtoList.Add(cate);
                }
            }
            

                return dtoList;
        }
        private List<ProductCateDto> AddSubNode(long parentId)
        {
            var subList = _dal.FindListBySql<ProductCateDto>($"SELECT id,name,parent_id,(SELECT count(0) from ivt_product WHERE cate_id=g.id AND delete_time=0) as productCnt FROM d_general as g WHERE general_table_id={(int)GeneralTableEnum.PRODUCT_CATE} and parent_id={parentId} and delete_time=0 ORDER BY id ASC;");
            if (subList != null && subList.Count > 0)
            {
                foreach (var sub in subList)
                {
                    sub.nodes = AddSubNode(sub.id);
                }
            }
            return subList;
        }

        public bool DeleteProductCate(long cateId,long userId)
        {
            d_general_dal dgDal = new d_general_dal();
            var proList = _dal.FindListBySql<ivt_product>($"SELECT * from ivt_product where delete_time = 0 and cate_id =" + cateId.ToString());
            if (proList != null && proList.Count > 0)
            {
                proList.ForEach(_ => {
                    _.cate_id = null;
                    EditProduct(_, userId);
                });
            }
            var childCateList = dgDal.GetGeneralByParentId(cateId);
            if(childCateList!=null&& childCateList.Count > 0)
            {
                GeneralBLL genBll = new GeneralBLL();
                childCateList.ForEach(_=> {
                    genBll.Delete(_.id,userId,(long)GeneralTableEnum.PRODUCT_CATE);
                });
                
            }
            return true;
        }
             

        #endregion

        public bool EditProduct(ivt_product product,long userId)
        {
            var oldProduct = _dal.FindNoDeleteById(product.id);
            if (oldProduct == null)
                return false;
            product.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            product.update_user_id = userId;
            _dal.Update(product);
            OperLogBLL.OperLogUpdate<ivt_product>(product,oldProduct,product.id,userId, OPER_LOG_OBJ_CATE.PRODUCT, "");
            return true;
        }
    }
}
