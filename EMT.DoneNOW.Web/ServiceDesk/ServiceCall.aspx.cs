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
    public partial class ServiceCall : BasePage
    {
        protected bool isAdd = true;
        protected bool isCop = false;
        protected sdk_service_call thisCall = null;
        protected List<sdk_service_call_task> taskSerList = null;
        protected string ticketIds = "";
        protected crm_account thisAccount = null;
        protected List<d_general> statusList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.SERVICE_CALL_STATUS);
        protected List<sys_notify_tmpl> tempList = new sys_notify_tmpl_dal().GetTempByEvent(((int)DicEnum.NOTIFY_EVENT.SERVICE_CALL_CREATED_EDITED).ToString());
        protected void Page_Load(object sender, EventArgs e)
        {
            var id = Request.QueryString["id"];
            var isCopy = Request.QueryString["copy"];
            if (!string.IsNullOrEmpty(id))
                thisCall = new sdk_service_call_dal().FindNoDeleteById(long.Parse(id));
            if (thisCall != null)
            {
                if (!string.IsNullOrEmpty(isCopy))
                    isCop = true;
                else
                    isAdd = false;
                thisAccount = new CompanyBLL().GetCompany(thisCall.account_id);
                taskSerList = new sdk_service_call_task_dal().GetTaskCall(thisCall.id);
                if(taskSerList!=null&& taskSerList.Count > 0)
                {
                    taskSerList.ForEach(_ => {
                        ticketIds += _.task_id.ToString() + ',';
                    });
                    if (!string.IsNullOrEmpty(ticketIds))
                        ticketIds = ticketIds.Substring(0, ticketIds.Length-1);
                }
                if (!isAdd)
                {
                    #region 记录浏览历史
                    var history = new sys_windows_history()
                    {
                        title = "服务预定:" + Tools.Date.DateHelper.ConvertStringToDateTime(thisCall.start_time).ToString("yyyy-MM-dd HH:mm")+"~"+ Tools.Date.DateHelper.ConvertStringToDateTime(thisCall.end_time).ToString("yyyy-MM-dd HH:mm")+thisAccount.name,
                        url = Request.RawUrl,
                    };
                    new IndexBLL().BrowseHistory(history, LoginUserId);
                    #endregion
                }
            }
                
            if (!IsPostBack)
            {

            }
            else
            {
                var param = GetParam();
                if (param != null)
                {
                    bool result = false;
                    if (isAdd)
                        result = new TicketBLL().AddServiceCall(param, LoginUserId);
                    else
                        result = new TicketBLL().EditServiceCall(param, LoginUserId);
                    ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');</script>");
                    var saveType = Request.Form["SaveType"];
                    if(saveType== "save_close")
                        ClientScript.RegisterStartupScript(this.GetType(), "关闭窗口", $"<script>window.close();</script>");
                    else if(saveType == "save_new")
                        ClientScript.RegisterStartupScript(this.GetType(), "跳转", $"<script>location.href='ServiceCall';</script>");
                    else if (saveType == "work_book")  // todo 跳转到生成工作说明书界面
                        ClientScript.RegisterStartupScript(this.GetType(), "关闭窗口", $"<script>window.close();</script>");
                    else
                        ClientScript.RegisterStartupScript(this.GetType(), "跳转到编辑页面", $"<script>location.href='ServiceCall?id={param.call.id.ToString()}';</script>");

                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示", $"<script>alert('必填项丢失，请重新填写！');</script>");
                }
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            if (param != null)
            {
                bool result = false;
                if (isAdd)
                    result = new TicketBLL().AddServiceCall(param,LoginUserId);
                else
                    result = new TicketBLL().EditServiceCall(param, LoginUserId); 
                ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');window.close();</script>");
            }
            else
                ClientScript.RegisterStartupScript(this.GetType(), "提示", $"<script>alert('必填项丢失，请重新填写！');</script>");
        }

        protected void save_new_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            if (param != null)
            {
                bool result = false;
                if (isAdd)
                    result = new TicketBLL().AddServiceCall(param, LoginUserId);
                else
                    result = new TicketBLL().EditServiceCall(param, LoginUserId);
                ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');location.href='ServiceCall?id={param.call.id.ToString()}';</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示", $"<script>alert('必填项丢失，请重新填写！');</script>");
            }
        }

        protected void work_book_Click(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// 获取页面参数
        /// </summary>
        private ServiceCallDto GetParam()
        {
            ServiceCallDto param = new ServiceCallDto();
            var call = AssembleModel<sdk_service_call>();
            var startTime = Request.Form["startTime"];
            var endTime = Request.Form["endTime"];
            if (string.IsNullOrEmpty(startTime) || string.IsNullOrEmpty(endTime))
                return null;
            call.start_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(startTime));
            call.end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(endTime));
            if (isAdd)
                param.call = call;
            else
            {
                thisCall.status_id =  call.status_id;
                thisCall.start_time = call.start_time;
                thisCall.end_time = call.end_time;
                param.call = thisCall;
            }
            var ticketIds = Request.Form["ChooseIds"];
            var AppTicketIdsHidden = Request.Form["AppTicketIdsHidden"];
            if (string.IsNullOrEmpty(ticketIds))
                ticketIds = AppTicketIdsHidden;
            else
            {
                if (!string.IsNullOrEmpty(AppTicketIdsHidden))
                    ticketIds += "," + AppTicketIdsHidden;
            }
            param.ticketIds = ticketIds;

            return param;
        }
    }
}