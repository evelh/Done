using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class v_activity_ticket_dal : BaseDAL<v_activity_ticket>
    {
        /// <summary>
        /// 根据ticketId获取其备注、工时、附件等活动信息
        /// </summary>
        /// <param name="ticketId"></param>
        /// <returns></returns>
        public List<v_activity_ticket> GetTicketActByTicketId(long ticketId)
        {
            return FindListBySql($"select * from v_activity_ticket where ticket_id={ticketId}");
        }

        /// <summary>
        /// 根据ticketId和owner id列表获取其备注、工时、附件等活动信息
        /// </summary>
        /// <param name="ticketId"></param>
        /// <param name="userIds">按,分割的id列表</param>
        /// <returns></returns>
        public List<v_activity_ticket> GetTicketActByTicketId(long ticketId, string userIds)
        {
            return FindListBySql($"select * from v_activity_ticket where ticket_id={ticketId} and owner_reource_id in({userIds})");
        }

        /// <summary>
        /// 获取ticket活动中包含的owner列表
        /// </summary>
        /// <param name="ticketId"></param>
        /// <returns></returns>
        public List<sys_user> GetOwnerUsers(long ticketId)
        {
            return FindListBySql<sys_user>($"select id,name from sys_user where id in(select distinct(owner_reource_id) from v_activity_ticket where ticket_id={ticketId} and owner_reource_id is not null )");
        }
    }

}
