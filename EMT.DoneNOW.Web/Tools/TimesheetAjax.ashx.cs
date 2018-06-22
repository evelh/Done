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
                case "submitCheck":
                    SubmitTimesheetCheck(context);
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
                case "getType":
                    GetWorkEntryType(context);
                    break;
                case "deleteWorkEntry":
                    DeleteWorkEntry(context);
                    break;
                case "SubmitManySheet":
                    SubmitManySheet(context);
                    break;
                //case "delete":
                //    DeleteTimesheet(context);
                //    break;
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
        /// 获取工时类型
        /// </summary>
        /// <param name="context"></param>
        private void GetWorkEntryType(HttpContext context)
        {
            long batchId = long.Parse(context.Request.QueryString["id"]);
            long id = 0;
            int type;
            bool rtn = new BLL.WorkEntryBLL().GetWorkEntryType(batchId, out type, out id);
            object[] data = new object[] { rtn, type, id };
            context.Response.Write(new Tools.Serialize().SerializeJson(data));
        }

        /// <summary>
        /// 获取工时表信息
        /// </summary>
        /// <param name="context"></param>
        private void GetTimesheetInfo(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            var weReport = new BLL.WorkEntryBLL().GetWorkEntryReportById(id);
            object[] data = new object[] { weReport.resource_id, weReport.start_date.Value.ToString("yyyy-MM-dd"), weReport.id };
            context.Response.Write(new Tools.Serialize().SerializeJson(data));
        }

        /// <summary>
        /// 提交工时表
        /// </summary>
        /// <param name="context"></param>
        private void SubmitTimesheet(HttpContext context)
        {
            DateTime start = DateTime.Parse(context.Request.QueryString["startDate"]);
            long resId = long.Parse(context.Request.QueryString["resId"]);
            var bll = new BLL.WorkEntryBLL();
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.SubmitWorkEntry(start, resId, LoginUserId)));
        }

        /// <summary>
        /// 工时表提交状态检查
        /// </summary>
        /// <param name="context"></param>
        private void SubmitTimesheetCheck(HttpContext context)
        {
            DateTime start = DateTime.Parse(context.Request.QueryString["startDate"]);
            long resId = long.Parse(context.Request.QueryString["resId"]);
            var bll = new BLL.WorkEntryBLL();
            int status = bll.SubmitWorkEntryCheck(start, resId);
            context.Response.Write(new Tools.Serialize().SerializeJson(status));
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
        /// 删除工时
        /// </summary>
        /// <param name="context"></param>
        private void DeleteWorkEntry(HttpContext context)
        {
            long batchId = long.Parse(context.Request.QueryString["id"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.WorkEntryBLL().DeleteWorkEntry(batchId, LoginUserId)));
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
        /// <summary>
        /// 批量提交工时表
        /// </summary>
        void SubmitManySheet(HttpContext context)
        {
           bool result = false;
            int temp = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["Array"]))
            {
                var arr = new Tools.Serialize().DeserializeJson<string[]>(context.Request.QueryString["Array"]);
                if(arr!=null&& arr.Length > 0)
                {
                    var bll = new BLL.WorkEntryBLL();
                    foreach (var thisArr in arr)
                    {
                        var thisSub = thisArr.Split('_');
                        if (thisSub.Length == 2)
                        {
                           if(!bll.SubmitWorkEntry(DateTime.Parse(thisSub[1]), long.Parse(thisSub[0]), LoginUserId))
                            {
                                temp++;
                            }
                        }
                    }
                }
            }
            if (temp == 0)
            {
                result = true;
            }
            WriteResponseJson(result);
        }
    }
}