using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_service_dal : BaseDAL<ctt_contract_service>
    {

        public List<ctt_contract_service> GetConSerList(long contract_id)
        {
            return FindListBySql<ctt_contract_service>($"SELECT * from ctt_contract_service where contract_id = {contract_id} and delete_time = 0");
        }

        public ctt_contract_service GetSinConSer(long service_id)
        {
            return FindSignleBySql<ctt_contract_service>($"SELECT * from ctt_contract_service where id = {service_id} and delete_time = 0");
        }
        /// <summary>
        /// 获取到相关的合同 
        /// </summary>
        public List<ctt_contract> getContractByServiceId(long serviceId)
        {
            return FindListBySql<ctt_contract>($"SELECT DISTINCT(cc.id) from ctt_contract_service ccs INNER JOIN ctt_contract cc on ccs.contract_id = cc.id where ccs.delete_time = 0 and cc.delete_time = 0 and ccs.object_id = {serviceId}");
        }
        /// <summary>
        /// 根据合同和服务ID 获取相应合同服务
        /// </summary>
        public ctt_contract_service GetServiceByConSerId(long contractId,long serviceId)
        {
            return FindSignleBySql<ctt_contract_service>($"SELECT * from ctt_contract_service  where delete_time = 0 and contract_id = {contractId} and object_id={serviceId}");
        }
    }

}
