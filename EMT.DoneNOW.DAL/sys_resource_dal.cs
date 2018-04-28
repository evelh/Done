using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class sys_resource_dal : BaseDAL<sys_resource>
    {
        public List<DictionaryEntryDto> GetDictionary(bool isOnlyActive = false)
        {
            var all = this.FindAll().OrderBy(_ => _.id).ToList();
            if (isOnlyActive)
            {
                all = all.Where(_ => _.is_active == 1).ToList();
            }
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            foreach (var entry in all)
            {
                //if (entry.is_default == 1)
                //    list.Add(new DictionaryEntryDto(entry.country_name_display, entry.country_name_display, 1));
                //else
                if (entry.delete_time != 0)
                {
                    continue;
                }
                list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name));
            }

            return list;
        }
        /// <summary>
        /// 获取到所有的员工
        /// </summary>
        /// <returns></returns>
        public List<sys_resource> GetSourceList(bool isActive = true)
        {
           
            string where = " and is_active = 1";
            if (!isActive)
                where = "";
            return FindListBySql<sys_resource>("select * from sys_resource where  delete_time = 0 " + where);
        }

        public List<sys_resource> GetListByIds(string ids,bool isActive = true)
        {
            return FindListBySql<sys_resource>($"select * from sys_resource where {(isActive? " is_active = 1 and " : "")} delete_time = 0 and id in ({ids})");
        }

        /// 根据关系表ID 获取员工相关信息 
        public List<sys_resource> GetListByDepIds(string ids)
        {
            return FindListBySql<sys_resource>($"SELECT * from sys_resource where id in ( SELECT resource_id from sys_resource_department where id in ({ids})) and delete_time = 0 ");
        }
        /// <summary>
        /// 根据部门获取相应的员工ID
        /// </summary>
        public List<sys_resource> GetListByDepId(string ids)
        {
            return FindListBySql<sys_resource>($"SELECT * from sys_resource where id in ( SELECT resource_id from sys_resource_department where department_id in ({ids}) and delete_time = 0)");
        }
        /// <summary>
        /// 根据项目Id 获取团队中的成员信息
        /// </summary>
        public List<sys_resource> GetResByProTeam(long project_id)
        {
            return FindListBySql<sys_resource>($"SELECT sr.* from pro_project_team ppt  INNER JOIN pro_project pp on ppt.project_id = pp.id inner JOIN sys_resource sr on ppt.resource_id = sr.id where pp.id = 5102 and ppt.delete_time = 0 and pp.delete_time = 0 and sr.delete_time = 0");
        }
        /// <summary>
        /// 获取改合同通知规则内的员工信息
        /// </summary>
        public List<sys_resource> GetConRuleList(long rule_id)
        {
            return FindListBySql<sys_resource>($"SELECT id,name from sys_resource where id  in(SELECT person_id from ctt_contract_notify_rule_recipient where contract_notify_rule_id = {rule_id} and delete_time = 0) and delete_time = 0");
        }
        /// <summary>
        /// 获取不在此规则内的员工信息
        /// </summary>
        public List<sys_resource> GetNotInConRuleList(long rule_id)
        {
            return FindListBySql<sys_resource>($"SELECT id,name from sys_resource where id not in(SELECT person_id from ctt_contract_notify_rule_recipient where contract_notify_rule_id = {rule_id} and delete_time = 0) and delete_time = 0");
        }
        /// <summary>
        /// 获取任务（工单）相关员工
        /// </summary>
        public List<sys_resource> GetTaskRes(long task_id)
        {
            return FindListBySql<sys_resource>($"SELECT sr.* from sys_resource sr INNER JOIN sdk_task_resource  str on sr.id = str.resource_id where str.task_id = {task_id} and sr.delete_time = 0 and str.delete_time = 0 ");
        }
        /// <summary>
        /// 根据时间查找出员工是否在该时间内
        /// </summary>
        public sys_resource GetResByTime(long resId,long start,long end)
        {
            return FindSignleBySql<sys_resource>($"SELECT ssctr.resource_id, sr.name FROM sdk_service_call ssc  INNER JOIN sdk_service_call_task ssct on ssc.id = ssct.service_call_id INNER JOIN sdk_service_call_task_resource ssctr on ssctr.service_call_task_id = ssct.id INNER JOIN sys_resource sr on sr.id = ssctr.resource_id where ssc.delete_time = 0 and ssct.delete_time = 0 and ssctr.delete_time = 0 and ssctr.resource_id = {resId} and {start} < ssc.end_time and {end} > ssc.start_time");
        }
        /// <summary>
        /// 查询出服务预定的工单员工信息
        /// </summary>
        public List<sys_resource> GetResByCallTicketId(long callTicketId)
        {
            return FindListBySql<sys_resource>($"SELECT sr.id, sr.name from sdk_service_call_task_resource ssc INNER JOIN sys_resource sr on ssc.resource_id = sr.id where ssc.delete_time = 0 and sr.delete_time = 0 and ssc.service_call_task_id = {callTicketId}");
        }
        /// <summary>
        /// 获取工单的其他负责人信息
        /// </summary>
        public List<sys_resource> GetResByTicket(long ticketId)
        {
            return FindListBySql<sys_resource>($"SELECT sr.id,sr.name from sdk_task_resource str INNER JOIN sys_resource sr on str.resource_id = sr.id where str.delete_time =0 and sr.delete_time = 0 and str.task_id = {ticketId}");
        }

        

    }
}
