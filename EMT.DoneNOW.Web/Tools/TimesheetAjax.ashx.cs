using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// TimesheetAjax 的摘要说明
    /// </summary>
    public class TimesheetAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "approve":
                    ApproveTimesheet(context);
                    break;
                case "reject":
                    RejectTimesheet(context);
                    break;
                case "timesheetInfo":
                    GetTimesheetInfo(context);
                    break;
                case "submit":
                    SubmitTimesheet(context);
                    break;
                case "cancleSubmit":
                    CancleSubmitTimesheet(context);
                    break;
                case "getStatus":
                    GetTimesheetSubmitStatus(context);
                    break;
                case "delete":
                    DeleteTimesheet(context);
                    break;
                default:
                    break;
            }
        }

        /// <summary>
        /// 审批批准工时表
        /// </summary>
        /// <param name="context"></param>
        private void ApproveTimesheet(HttpContext context)
        {
            string ids = context.Request.QueryString["ids"];
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.WorkEntryBLL().ApproveWorkEntryReport(ids, LoginUserId)));
        }

        /// <summary>
        /// 审批拒绝工时表
        /// </summary>
        /// <param name="context"></param>
        private void RejectTimesheet(HttpContext context)
        {
            string ids = context.Request.QueryString["ids"];
            string reason = context.Request.QueryString["reason"];
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.WorkEntryBLL().RejectWorkEntryReport(ids, reason, LoginUserId)));
        }

        /// <summary>
        /// 查询工时表是否可以提交、取消提交
        /// </summary>
        /// <param name="context">1:可以提交;2:可以取消提交;0:其他</param>
        private void GetTimesheetSubmitStatus(HttpContext context)
        {
            DateTime start = DateTime.Parse(context.Request.QueryString["startDate"]);
            long resId = long.Parse(context.Request.QueryString["resId"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.WorkEntryBLL().GetTimesheetSubmitStatus(start, resId)));
        }

        /// <summary>
        /// 获取工时表信息
        /// </summary>
        /// <param name="context"></param>
        private void GetTimesheetInfo(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.WorkEntryBLL().GetWorkEntryReportById(id)));
        }

        /// <summary>
        /// 提交工时表
        /// </summary>
        /// <param name="context"></param>
        private void SubmitTimesheet(HttpContext context)
        {
            DateTime start = DateTime.Parse(context.Request.QueryString["startDate"]);
            long resId = long.Parse(context.Request.QueryString["resId"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.WorkEntryBLL().SubmitWorkEntry(start, resId, LoginUserId)));
        }

        /// <summary>
        /// 取消提交工时表
        /// </summary>
        /// <param name="context"></param>
        private void CancleSubmitTimesheet(HttpContext context)
        {
            DateTime start = DateTime.Parse(context.Request.QueryString["startDate"]);
            long resId = long.Parse(context.Request.QueryString["resId"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.WorkEntryBLL().CancleSubmitWorkEntry(start, resId, LoginUserId)));
        }

        /// <summary>
        /// 删除工时表
        /// </summary>
        /// <param name="context"></param>
        private void DeleteTimesheet(HttpContext context)
        {
            DateTime start = DateTime.Parse(context.Request.QueryString["startDate"]);
            long resId = long.Parse(context.Request.QueryString["resId"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.WorkEntryBLL().DeleteWorkEntryReport(start, resId, LoginUserId)));
        }
    }
}