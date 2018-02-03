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
    }
}
