
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_form_tmpl_ticket_checklist_dal : BaseDAL<sys_form_tmpl_ticket_checklist>
    {
        /// <summary>
        /// 根据工单 Id 获取相应检查单
        /// </summary>
        public List<sys_form_tmpl_ticket_checklist> GetCheckByTicket(long ticketId)
        {
            return FindListBySql<sys_form_tmpl_ticket_checklist>($"SELECT * from sys_form_tmpl_ticket_checklist where form_tmpl_ticket_id = {ticketId} and delete_time = 0");
        }
    }
}
