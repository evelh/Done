using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_service_bundle_dal : BaseDAL<ivt_service_bundle>
    {
        /// <summary>
        /// 获取到单个的服务包信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_service_bundle GetSinSerBun(long id)
        {
            return FindSignleBySql<ivt_service_bundle>($"select * from ivt_service_bundle where id = {id} and delete_time = 0") ;

        }
        /// <summary>
        /// 获取到引用此合同的定期服务合同
        /// </summary>
        public object GetServiceContractCount(long serviceId)
        {
            return GetSingle($"SELECT COUNT(DISTINCT(cc.id))  from ctt_contract_service ccs INNER JOIN ctt_contract cc on ccs.contract_id = cc.id where cc.type_id = {(int)DTO.DicEnum.CONTRACT_TYPE.SERVICE} and ccs.delete_time = 0 and cc.delete_time = 0 and ccs.object_id = {serviceId}");
        }
    }
}
