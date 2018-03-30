using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_kb_article_ticket_dal : BaseDAL<sdk_kb_article_ticket>
    {
        /// <summary>
        /// 获取知识库中的关联工单
        /// </summary>
        public List<sdk_kb_article_ticket> GetArtTicket(long artId)
        {
            return FindListBySql<sdk_kb_article_ticket>($"SELECT* from sdk_kb_article_ticket where delete_time = 0 and kb_article_id = {artId}");
        }
        /// <summary>
        /// 获取唯一的知识库关联工单
        /// </summary>
        public sdk_kb_article_ticket GetSing(long artId,long ticketId)
        {
            return FindSignleBySql<sdk_kb_article_ticket>($"SELECT* from sdk_kb_article_ticket where delete_time = 0 and kb_article_id = {artId} and task_id = {ticketId}");
        }
        // 
        // SELECT* from sdk_kb_article_ticket where delete_time = 0 and task_id = 1 and kb_article_id = 1
    }

}