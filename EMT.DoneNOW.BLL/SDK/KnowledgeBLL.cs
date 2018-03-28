using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class KnowledgeBLL
    {

        private sdk_kb_article_dal _dal = new sdk_kb_article_dal();

        public List<KnowledgeCateDto> GetKnowledgeCateList()
        {
            var knowledgeList = _dal.FindListBySql<KnowledgeCateDto>($"SELECT id,name,parent_id,(SELECT count(0) from sdk_kb_article WHERE kb_category_id=g.id AND delete_time=0) as articleCnt FROM d_general as g WHERE general_table_id={(int)GeneralTableEnum.KNOWLEDGE_BASE_CATE} and delete_time=0 ORDER BY id ASC;");

            List<KnowledgeCateDto> dtoList = new List<KnowledgeCateDto>();
            var list = from cate in knowledgeList where cate.parent_id == null select cate;
            dtoList.AddRange(list);

            foreach (var cate in dtoList)
            {
                cate.nodes = GetCateNodes(knowledgeList, cate.id);
            }

            return dtoList;
        }

        private List<KnowledgeCateDto> GetCateNodes(List<KnowledgeCateDto> allCates, long id)
        {
            var list = (from node in allCates where node.parent_id == id select node).ToList();
            if (list != null)
            {
                for(int i=0;i< list.Count;i++)
                {
                    list[i].nodes = GetCateNodes(allCates, list[i].id);
                }
            }
            return list;
        }
        /// <summary>
        /// 新增工单操作
        /// </summary>
        /// <param name="param"></param>
        /// <param name="userId"></param>
        /// <param name="faileReason"></param>
        /// <returns></returns>
        public bool AddTicket(TicketManageDto param, long userId, out string faileReason)
        {
            faileReason = "";
            try
            {
                //    var thisTicket = param.ticket;
                //    #region 1 新增工单
                //    if (thisTicket != null)
                //        InsertTicket(thisTicket, userId);
                //    else
                //        return false;
                //    #endregion

                //    #region 2 新增自定义信息
                //    var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);  // 获取合同的自定义字段信息
                //    new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.TICKETS, userId,
                //        thisTicket.id, udf_list, param.udfList, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK_INFORMATION);
                //    #endregion

                //    #region 3 工单其他负责人
                //    InsertTicket(param.resDepIds, userId);
                //#endregion
            }
            catch (Exception msg)
            {
                faileReason = msg.Message;
                return false;
            }
            return true;
        }
        public bool InsertTicket(sdk_task ticket, long user_id)
        {
            //var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //if (ticket.sla_id != null)
            //    ticket.sla_start_time = timeNow;
            //ticket.id = _dal.GetNextIdCom();
            //ticket.create_time = timeNow;
            //ticket.create_user_id = user_id;
            //ticket.update_time = timeNow;
            //ticket.update_user_id = user_id;
            //ticket.no = new TaskBLL().ReturnTaskNo();
            //_dal.Insert(ticket);
            //OperLogBLL.OperLogAdd<sdk_task>(ticket, ticket.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "新增工单");
            return true;
        }
    }
}
