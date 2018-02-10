using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    public class ServiceBLL
    {
        /// <summary>
        /// 获取ivt_service实体
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_service GetServiceById(long id)
        {
            return new ivt_service_dal().FindById(id);
        }

        /// <summary>
        /// 获取ivt_service_bundle实体
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_service_bundle GetServiceBundleById(long id)
        {
            return new ivt_service_bundle_dal().FindById(id);
        }

        /// <summary>
        /// 获取服务包包含的服务列表
        /// </summary>
        /// <param name="serviceBundleId"></param>
        /// <returns></returns>
        public List<ivt_service_bundle_service> GetServiceListByServiceBundleId(long serviceBundleId)
        {
            return new ivt_service_bundle_service_dal().FindListBySql($"SELECT * FROM ivt_service_bundle_service WHERE service_bundle_id={serviceBundleId}");
        }

        /// <summary>
        /// 服务新增
        /// </summary>
        /// <param name="ser"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddService(ivt_service ser, long userId)
        {
            ivt_service service = new ivt_service();
            ivt_service_dal dal = new ivt_service_dal();

            service.id = dal.GetNextIdCom();
            service.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            service.update_time = service.create_time;
            service.create_user_id = userId;
            service.update_user_id = userId;
            service.name = ser.name;
            service.description = ser.description;
            service.invoice_description = ser.invoice_description;
            service.sla_id = ser.sla_id;
            service.vendor_account_id = ser.vendor_account_id;
            service.period_type_id = ser.period_type_id;
            service.unit_cost = ser.unit_cost;
            service.unit_price = ser.unit_price;
            service.cost_code_id = ser.cost_code_id;
            service.is_active = ser.is_active;

            dal.Insert(service);
            OperLogBLL.OperLogAdd<ivt_service>(service, service.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.IVT_SERVICE, "新增服务");
            return true;
        }

        /// <summary>
        /// 服务编辑
        /// </summary>
        /// <param name="ser"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditService(ivt_service ser, long userId)
        {
            ivt_service_dal dal = new ivt_service_dal();
            ivt_service service = dal.FindById(ser.id);
            ivt_service serOld = dal.FindById(ser.id);

            service.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            service.update_user_id = userId;
            service.name = ser.name;
            service.description = ser.description;
            service.invoice_description = ser.invoice_description;
            service.sla_id = ser.sla_id;
            service.vendor_account_id = ser.vendor_account_id;
            service.period_type_id = ser.period_type_id;
            service.unit_cost = ser.unit_cost;
            service.unit_price = ser.unit_price;
            service.cost_code_id = ser.cost_code_id;
            service.is_active = ser.is_active;

            var desc = OperLogBLL.CompareValue<ivt_service>(serOld, service);
            if (!string.IsNullOrEmpty(desc))
            {
                dal.Update(service);
                OperLogBLL.OperLogUpdate(desc, service.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.IVT_SERVICE, "编辑服务");
            }

            return true;
        }

        /// <summary>
        /// 新增服务包相关
        /// </summary>
        public bool AddServiceBundle(ivt_service_bundle SerBun, long userId, string serIds)
        {
            try
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var isbDal = new ivt_service_bundle_dal();
                SerBun.id = isbDal.GetNextIdCom();
                SerBun.create_time = timeNow;
                SerBun.update_time = timeNow;
                SerBun.create_user_id = userId;
                SerBun.update_user_id = userId;
                isbDal.Insert(SerBun);
                OperLogBLL.OperLogAdd<ivt_service_bundle>(SerBun, SerBun.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.IVT_SERVICE_BUNDLE, "新增服务包");
                ServiceBundleManage(SerBun.id, serIds, userId);
            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 编辑服务包
        /// </summary>
        public bool EditServiceBundle(ivt_service_bundle SerBun, long userId, string serIds)
        {
            try
            {
                var isbDal = new ivt_service_bundle_dal();
                var oldSerBun = isbDal.FindNoDeleteById(SerBun.id);
                if (oldSerBun == null)
                    return false;
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                SerBun.update_time = timeNow;
                SerBun.update_user_id = userId;
                isbDal.Update(SerBun);
                OperLogBLL.OperLogUpdate<ivt_service_bundle>(SerBun, oldSerBun, SerBun.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.IVT_SERVICE_BUNDLE, "编辑服务包");
                ServiceBundleManage(SerBun.id, serIds, userId);
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 服务包的服务管理
        /// </summary>
        public void ServiceBundleManage(long serBunId, string serIds, long userId)
        {
            var isbsDal = new ivt_service_bundle_service_dal();
            var serList = GetServiceListByServiceBundleId(serBunId);
            var serIdArr = serIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            if (serList != null && serList.Count > 0)
            {
                foreach (var serId in serIdArr)
                {
                    var thisSer = serList.FirstOrDefault(_ => _.service_id.ToString() == serId);
                    if (thisSer != null)
                    {
                        serList.Remove(thisSer);
                    }
                    else
                    {
                        isbsDal.Insert(new ivt_service_bundle_service()
                        {
                            id = isbsDal.GetNextIdCom(),
                            service_bundle_id = serBunId,
                            service_id = long.Parse(serId),
                        });
                    }
                }
                if (serList.Count > 0)
                {
                    serList.ForEach(_ => {
                        isbsDal.Delete(_);
                    });
                }
            }
            else
            {
                foreach (var serId in serIdArr)
                {
                    isbsDal.Insert(new ivt_service_bundle_service()
                    {
                        id = isbsDal.GetNextIdCom(),
                        service_bundle_id = serBunId,
                        service_id = long.Parse(serId),
                    });
                }
            }
        }
        /// <summary>
        /// 删除服务包相关，不能删除时，返回所有不能删除相关对象数量
        /// </summary>
        public bool DeleteServiceBundle(long serviceId, long userId, ref string faileReason)
        {
            try
            {
                var isbDal = new ivt_service_bundle_dal();
                var thisSerBundle = isbDal.FindNoDeleteById(serviceId);
                if (thisSerBundle == null)
                    return true;
                var conSerList = new ctt_contract_service_dal().getContractByServiceId(thisSerBundle.id);
                if (conSerList != null && conSerList.Count > 0)
                    faileReason += $"{conSerList.Count} 合同\n";
                var quoteItemList = new crm_quote_item_dal().GetItemByObjId(thisSerBundle.id);
                if (quoteItemList != null && quoteItemList.Count > 0)
                    faileReason += $"{quoteItemList.Count} 报价项\n";
                var labourList = new sdk_work_entry_dal().GetListByService(thisSerBundle.id);
                if (labourList != null && labourList.Count > 0)
                    faileReason += $"{labourList.Count} 工时\n";
                var insProList = new crm_installed_product_dal().GetInsListBySerBunId(thisSerBundle.id);
                if (insProList != null && insProList.Count > 0)
                    faileReason += $"{insProList.Count} 配置项\n";
                if (!string.IsNullOrEmpty(faileReason))
                    return false;
                else
                {
                    var isbsDal = new ivt_service_bundle_service_dal();
                    var serList = GetServiceListByServiceBundleId(thisSerBundle.id);
                    if (serList != null && serList.Count > 0)
                    {
                        serList.ForEach(_ => {
                            isbsDal.Delete(_);
                        });
                    }
                    isbDal.SoftDelete(thisSerBundle, userId);
                    OperLogBLL.OperLogDelete<ivt_service_bundle>(thisSerBundle, thisSerBundle.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.IVT_SERVICE_BUNDLE, "删除服务包");
                }

            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// 删除服务相关，不能删除时，返回所有不能删除相关对象数量
        /// </summary>
        public bool DeleteService(long serviceId, long userId, ref string faileReason)
        {
            try
            {
                var isbDal = new ivt_service_dal();
                var thisSer = isbDal.FindNoDeleteById(serviceId);
                if (thisSer == null)
                    return true;
                var conSerList = new ctt_contract_service_dal().getContractByServiceId(thisSer.id);
                if (conSerList != null && conSerList.Count > 0)
                    faileReason += $"{conSerList.Count} 合同\n";
                var quoteItemList = new crm_quote_item_dal().GetItemByObjId(thisSer.id);
                if (quoteItemList != null && quoteItemList.Count > 0)
                    faileReason += $"{quoteItemList.Count} 报价项\n";
                var labourList = new sdk_work_entry_dal().GetListByService(thisSer.id);
                if (labourList != null && labourList.Count > 0)
                    faileReason += $"{labourList.Count} 工时\n";
                var insProList = new crm_installed_product_dal().GetInsListBySerId(thisSer.id);
                if (insProList != null && insProList.Count > 0)
                    faileReason += $"{insProList.Count} 配置项\n";
                if (!string.IsNullOrEmpty(faileReason))
                    return false;
                else
                {
                    isbDal.SoftDelete(thisSer, userId);
                    OperLogBLL.OperLogDelete<ivt_service>(thisSer, thisSer.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.IVT_SERVICE, "删除服务");
                }

            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 激活停用服务
        /// </summary>
        public bool ActiveService(long serviceId, bool isActive, long userId, ref string faileReason)
        {
            var isDal = new ivt_service_dal();
            var thisSer = isDal.FindNoDeleteById(serviceId);
            if (thisSer == null)
            {
                faileReason = "未查询到该服务信息";
                return false;
            }
            if (thisSer.is_active == (sbyte)(isActive ? 1 : 0))
            {
                faileReason = $"该服务已经是{(isActive ? "激活" : "停用")}状态！";
                return false;
            }
            thisSer.is_active = (sbyte)(isActive ? 1 : 0);
            thisSer.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisSer.update_user_id = userId;
            var oldSer = isDal.FindNoDeleteById(serviceId);
            isDal.Update(thisSer);
            OperLogBLL.OperLogUpdate<ivt_service>(thisSer, oldSer, thisSer.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.IVT_SERVICE, "编辑服务");
            return true;
        }
        /// <summary>
        /// 激活停用服务包
        /// </summary>
        public bool ActiveServiceBundle(long serviceId, bool isActive, long userId, ref string faileReason)
        {
            var isbDal = new ivt_service_bundle_dal();
            var thisSer = isbDal.FindNoDeleteById(serviceId);
            if (thisSer == null)
            {
                faileReason = "未查询到该服务包信息";
                return false;
            }
            if (thisSer.is_active == (sbyte)(isActive ? 1 : 0))
            {
                faileReason = $"该服务包已经是{(isActive ? "激活" : "停用")}状态！";
                return false;
            }
            thisSer.is_active = (sbyte)(isActive ? 1 : 0);
            thisSer.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisSer.update_user_id = userId;
            var oldSer = isbDal.FindNoDeleteById(serviceId);
            isbDal.Update(thisSer);
            OperLogBLL.OperLogUpdate<ivt_service_bundle>(thisSer, oldSer, thisSer.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.IVT_SERVICE_BUNDLE, "编辑服务包");
            return true;
        }
    }
}
