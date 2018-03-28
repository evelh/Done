using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class TicketCallResManage : BasePage
    {
        protected sdk_task thisTicket = null;
        protected sys_resource priRes = null;
        protected sdk_service_call_task thisTicketCall = null;
        protected List<sdk_service_call_task_resource> resList = null;
        protected List<sys_resource> resNameList = null;
        protected List<sdk_task_resource> ticketRes = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var callId = Request.QueryString["callId"];
                var ticketId = Request.QueryString["ticketId"];
                if(!string.IsNullOrEmpty(callId)&& !string.IsNullOrEmpty(ticketId))
                    thisTicketCall = new sdk_service_call_task_dal().GetSingTaskCall(long.Parse(callId),long.Parse(ticketId));
                if (thisTicketCall == null)
                {
                    Response.Write("<script>alert('未查询到相关信息，请重新打开');window.close();</script>");
                    return;
                }
                else
                {
                    thisTicket = new sdk_task_dal().FindNoDeleteById(thisTicketCall.task_id);
                    if (thisTicket != null)
                    {
                        ticketRes = new sdk_task_resource_dal().GetResByTaskId(thisTicket.id);
                        if (thisTicket.owner_resource_id != null)
                            priRes = new sys_resource_dal().FindNoDeleteById((long)thisTicket.owner_resource_id);
                        resNameList = new sys_resource_dal().GetResByTicket(thisTicket.id);
                    }
                    else
                    {
                        
                        Response.Write("<script>alert('工单已删除');window.close();</script>");
                        return;
                    }
                    resList = new sdk_service_call_task_resource_dal().GetTaskResList(thisTicketCall.id);
                    //resNameList
                }

            }
            catch (Exception msg)
            {
                Response.Write("<script>alert('"+msg.Message+"');window.close();</script>");
            }

        }
    }
}