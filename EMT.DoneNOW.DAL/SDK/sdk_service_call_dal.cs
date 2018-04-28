
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_service_call_dal : BaseDAL<sdk_service_call>
    {
        // 
        public List<sdk_service_call> GetCallByAccount(long accountId)
        {
            return FindListBySql<sdk_service_call>($"SELECT * from sdk_service_call where account_id = {accountId} and delete_time = 0");
        }
        /// <summary>
        /// 判断员工是否在服务预定包含的任务的负责人中
        /// </summary>
        public bool ResInCall(long callId,long resId)
        {
            var res = GetSingle($"SELECT COUNT(1) from sdk_service_call_task ssct INNER JOIN sdk_task st on ssct.task_id = st.id INNER JOIN sdk_task_resource str on str.task_id = st.id where ssct.delete_time = 0 and st.delete_time = 0 and str.delete_time = 0  and ssct.id={callId} and (str.resource_id = {resId} or st.owner_resource_id = {resId})");
            // and ssct.service_call_id = {callId} and st.type_id in({(int)DTO.DicEnum.TASK_TYPE.PROJECT_TASK}, {(int)DTO.DicEnum.TASK_TYPE.PROJECT_ISSUE}, {(int)DTO.DicEnum.TASK_TYPE.PROJECT_PHASE})
            return Convert.ToInt32(res) > 0;
        }
        /// <summary>
        /// 获取未完成的服务预定 - 根据负责人
        /// </summary>
        public List<sdk_service_call> GetNoComCall(long userId)
        {
            return FindListBySql($"SELECT ssc.* from sdk_service_call  ssc JOIN sdk_service_call_task ssct on ssct.service_call_id = ssc.id JOIN sdk_service_call_task_resource ssctr on ssctr.service_call_task_id = ssct.id where ssc.status_id = {(int)DTO.DicEnum.SERVICE_CALL_STATUS.NEW} and ssctr.resource_id = {userId} and ssc.delete_time = 0 and ssct.delete_time = 0 and ssctr.delete_time = 0");
        }
    }
}
