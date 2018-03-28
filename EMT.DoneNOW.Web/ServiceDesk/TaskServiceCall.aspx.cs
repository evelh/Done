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
    public partial class TaskServiceCall : BasePage
    {
        protected bool isAdd=true;
        protected sdk_service_call thisCall = null;
        protected sdk_service_call_task thisCallTask = null;
        protected sdk_task thisTicket = null;
        protected crm_account thisAccount = null;
        protected List<sys_resource> resList = null;   // 工单的负责人列表
        protected List<sdk_service_call_task_resource> serResList = null;  // 这个工单在这个服务预定上的相关员工
        protected List<sdk_service_call> accCallList = null;
        protected List<CallDto> pageCallList = null;   // 新增时在页面上展示的相关 属性
        protected List<d_general> statusList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.SERVICE_CALL_STATUS);
        protected sys_resource accMan = null;
        protected sys_resource callCreater = null;
        protected crm_contact ticketCon = null;
        protected List<sys_notify_tmpl> tempList = new sys_notify_tmpl_dal().GetTempByEvent(((int)DicEnum.NOTIFY_EVENT.SERVICE_CALL_CREATED_EDITED).ToString());
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var callId = Request.QueryString["callId"];
                var tickeTId = Request.QueryString["ticketId"];
                if (!string.IsNullOrEmpty(callId))
                    thisCall = new sdk_service_call_dal().FindNoDeleteById(long.Parse(callId));
                if (!string.IsNullOrEmpty(tickeTId))
                    thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(tickeTId));
                if (thisTicket != null)
                {
                    thisAccount = new CompanyBLL().GetCompany(thisTicket.account_id);
                    if (thisTicket.contact_id != null)
                        ticketCon = new crm_contact_dal().FindNoDeleteById((long)thisTicket.contact_id);
                    resList = new List<sys_resource>();
                    var srDal = new sys_resource_dal();
                    if (thisTicket.owner_resource_id != null)
                    {
                        var priRes = srDal.FindNoDeleteById((long)thisTicket.owner_resource_id);
                        if (priRes != null)
                            resList.Add(priRes);
                    }
                    var other = srDal.GetResByTicket(thisTicket.id);
                    if (other != null && other.Count > 0)
                        resList.AddRange(other);
                }
                if (thisCall != null&&thisTicket!=null)
                {
                    thisCallTask = new sdk_service_call_task_dal().GetSingTaskCall(thisCall.id,thisTicket.id);
                    thisAccount = new CompanyBLL().GetCompany(thisCall.account_id);
                }
                var callTaskId = Request.Form["id"];
                if (!string.IsNullOrEmpty(callTaskId))
                    thisCallTask = new sdk_service_call_task_dal().FindNoDeleteById(long.Parse(callTaskId));
                if (thisCallTask != null)
                {
                    isAdd = false;
                    serResList = new sdk_service_call_task_resource_dal().GetTaskResList(thisCallTask.id);
                    callCreater = new sys_resource_dal().FindNoDeleteById(thisCallTask.id);
                }
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                if (thisAccount != null)
                {
                    if (thisAccount.resource_id != null)
                        accMan = new sys_resource_dal().FindNoDeleteById((long)thisAccount.resource_id);
                    accCallList = new sdk_service_call_dal().GetCallByAccount(thisAccount.id);
                    if(accCallList!=null&& accCallList.Count > 0)
                    {
                        pageCallList = (from a in accCallList
                                        join b in statusList on a.status_id equals b.id
                                       select new CallDto {id = a.id,startDate = EMT.Tools.Date.DateHelper.ConvertStringToDateTime(a.start_time).ToString("yyyy-MM-dd HH:mm"), endDate = EMT.Tools.Date.DateHelper.ConvertStringToDateTime(a.end_time).ToString("yyyy-MM-dd HH:mm"),statusId = a.status_id,statusName=b.name , isLimtThri=(timeNow-a.start_time)>(2592000000) }).ToList();
                        // 2592000000 = 30 * 24 * 60 * 60 * 1000  30天的毫秒数
                    }
                }
                else
                {
                    Response.Write($"<script>alert('为获取到相关客户信息，请重新打开!');window.close();</script>");
                    return;
                }
                    
            }
            catch (Exception msg)
            {
                Response.Write($"<script>alert('{msg.Message}!');window.close();</script>");
            }
        }
        
        
        /// <summary>
        /// 获取相关参数
        /// </summary>
        public TaskServiceCallDto GetParam()
        {
            TaskServiceCallDto param = new TaskServiceCallDto();

            var ckNewCall = Request.Form["ckNewCall"];
            if (!string.IsNullOrEmpty(ckNewCall) && ckNewCall == "on")
                param.isAddCall = true;
            var pageCall = AssembleModel<sdk_service_call>();
            var startTime = Request.Form["startDate"];
            var endTime = Request.Form["endDate"];
            if (!string.IsNullOrEmpty(startTime) && !string.IsNullOrEmpty(endTime))
            {
                pageCall.start_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(startTime));
                pageCall.end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(endTime));
            }
            pageCall.account_id = thisAccount.id;
            if (isAdd)
            {
                if (param.isAddCall)
                {
                    param.thisCall = pageCall;
                }
            }
            else
            {
                thisCall.start_time = pageCall.start_time;
                thisCall.end_time = pageCall.end_time;
                thisCall.description = pageCall.description;
                thisCall.status_id = pageCall.status_id;
                param.thisCall = thisCall;
            }
            param.thisTicket = thisTicket;
            param.resIds = Request.Form["resIds"];
            param.callIds = Request.Form["callIds"];
            #region 通知相关
            // notiResIds
            string resIds = "";
            string conIds = "";
            if (ckAccMan.Checked && accMan != null)
                resIds += accMan.id.ToString() + ',';
            if (CCMe.Checked)
                resIds += LoginUserId + ',';
            if (CkPriRes.Checked && thisTicket.owner_resource_id != null)
                resIds += thisTicket.owner_resource_id.ToString() + ',';
            if(CKcreate.Checked&&callCreater!=null)
                resIds += callCreater.id.ToString() + ',';
            if (CKTicketCon.Checked && ticketCon != null)
                conIds += ticketCon.id.ToString() + ',';
            var other = new sys_resource_dal().GetResByTicket(thisTicket.id);
            if (CkTicketOther.Checked && other != null && other.Count > 0)
                other.ForEach(_ => {
                    resIds += _.id.ToString() + ',';
                });
            var notifyResIds = Request.Form["notifyResIds"];
            if (!string.IsNullOrEmpty(notifyResIds))
            {
                if (!string.IsNullOrEmpty(resIds))
                    resIds += notifyResIds + ",";
                else
                    resIds = notifyResIds;
            }
            var notifyConIds = Request.Form["notifyConIds"];
            if (!string.IsNullOrEmpty(notifyConIds))
            {
                if (!string.IsNullOrEmpty(conIds))
                    conIds += notifyConIds + ",";
                else
                    conIds = notifyConIds;
            }
            if (Cksys.Checked)
                param.sendBySys = true;
            var notify_id = Request.Form["notify_id"];
            if (!string.IsNullOrEmpty(notify_id))
                param.notiTempId = long.Parse(notify_id);
            param.subject = Request.Form["subjects"];
            param.otherEmail = Request.Form["otherEmail"];
            param.appText = Request.Form["AdditionalText"];
            // sendBySys
            #endregion

            return param;
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            if (param != null)
            {
                bool result = false;
                if (isAdd)
                    result = new TicketBLL().TaskCallAdd(param, LoginUserId);
                else
                    result = new TicketBLL().TaskCallEdit(param, LoginUserId);
                ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');window.close();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示", $"<script>alert('必填项丢失，请重新填写！');</script>");
            }
        }

        protected void save_new_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            if (param != null)
            {
                bool result = false;
                if (isAdd)
                    result = new TicketBLL().TaskCallAdd(param, LoginUserId);
                else
                    result = new TicketBLL().TaskCallEdit(param, LoginUserId);
                ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');location.href='TaskServiceCall?ticketId={thisTicket.id.ToString()}';</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示", $"<script>alert('必填项丢失，请重新填写！');</script>");
            }
        }
    }

    public class CallDto
    {
        public long id;
        public string startDate;
        public string endDate;
        public long resourceId;
        public long resourceName;
        public long statusId;
        public string statusName;
        public bool isLimtThri;   // 距离今天是否超过30天
    }
}