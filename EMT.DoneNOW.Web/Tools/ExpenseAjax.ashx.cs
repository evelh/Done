using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ExpenseAjax 的摘要说明
    /// </summary>
    public class ExpenseAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "DeleteExpenseReport":
                    DeleteExpenseReport(context);
                    break;
                case "Approval":
                    ApprovalReport(context);
                    break;
                case "Refuse":
                    RefuseReport(context);
                    break;
                case "Submit":
                    SubmitReport(context);
                    break;
                case "Paid":
                    PaidReport(context);
                    break;
                case "PaidAll":
                    PaidAllReport(context);
                    break;
                case "ReturnApproval":
                    ReturnApproval(context);
                    break;
                case "AllReturnApproval":
                    AllReturnApproval(context);
                    break;
                default:
                    break;
            }
        }
        /// <summary>
        /// 删除费用
        /// </summary>
        public void DeleteExpenseReport(HttpContext context)
        {
            var eid = context.Request.QueryString["report_id"];
            if (!string.IsNullOrEmpty(eid))
            {
                string reason = "";
                var result = new BLL.ExpenseBLL().DeleteReport(long.Parse(eid),LoginUserId,out reason);
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { result = result,reason = reason}));
            }
        }
        /// <summary>
        /// 审批费用报表
        /// </summary>
        public void ApprovalReport(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(ids))
            {
                var eBll = new BLL.ExpenseBLL();
                var idArr = ids.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                string faileReason = "";
                int failTimes = 0;
                foreach (var eId in idArr)
                {
                    string thisFailReason;
                    var result =  eBll.Approval(long.Parse(eId),LoginUserId,out thisFailReason);
                    if (!result)
                    {
                        failTimes++;
                        if (!string.IsNullOrEmpty(thisFailReason))
                        {
                            faileReason += thisFailReason + "\r";
                        }
                    }
                }
                context.Response.Write(new Tools.Serialize().SerializeJson(new {result= failTimes==0,reason= faileReason }));
            }
        }
        /// <summary>
        /// 拒绝费用报表
        /// </summary>
        public void RefuseReport(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"];
            var refReason = context.Request.QueryString["reason"];
            
            if (!string.IsNullOrEmpty(ids))
            {
                var eBll = new BLL.ExpenseBLL();
                var idArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                string faileReason = "";
                int failTimes = 0;
                foreach (var eId in idArr)
                {
                    string thisFailReason;
                    var result = eBll.ApprovalRefuse(long.Parse(eId), refReason, LoginUserId, out thisFailReason);
                    if (!result)
                    {
                        failTimes++;
                        if (!string.IsNullOrEmpty(thisFailReason))
                        {
                            faileReason += thisFailReason + "\r";
                        }
                    }
                }
                context.Response.Write(new Tools.Serialize().SerializeJson(new { result = failTimes == 0, reason = faileReason }));
            }
        }
        /// <summary>
        /// 审批费用报表
        /// </summary>
        public void SubmitReport(HttpContext context)
        {
            var eid = context.Request.QueryString["id"];
            if (!string.IsNullOrEmpty(eid))
            {
                string failReason = "";
                var result = new BLL.ExpenseBLL().SubmitReport(long.Parse(eid),LoginUserId,ref failReason);
                context.Response.Write(new Tools.Serialize().SerializeJson(new { result = result , reason = failReason }));
            }
        }
        /// <summary>
        /// 将报表标记为已支付
        /// </summary>
        public void PaidReport(HttpContext context)
        {
            var eid = context.Request.QueryString["id"];
            if (!string.IsNullOrEmpty(eid))
            {
                string failReason = "";
                var result = new BLL.ExpenseBLL().PaidReport(long.Parse(eid), LoginUserId, out failReason);
                context.Response.Write(new Tools.Serialize().SerializeJson(new { result = result, reason = failReason }));
            }
        }
        /// <summary>
        /// 将页面报表全部标记为已支付
        /// </summary>
        public void PaidAllReport(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(ids))
            {
                var idArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                var rBll = new BLL.ExpenseBLL();
                int faileTimes = 0;
                foreach (var eid in idArr)
                {
                    string faileReason;
                    var result = rBll.PaidReport(long.Parse(eid),LoginUserId,out faileReason);
                    if (!result)
                    {
                        faileTimes++;
                    }
                }
                context.Response.Write(faileTimes==0);
            }
        }

        /// <summary>
        /// 将已经支付的费用报表返回为审批状态
        /// </summary>
        public void ReturnApproval(HttpContext context)
        {
            var eid = context.Request.QueryString["id"];
            if (!string.IsNullOrEmpty(eid))
            {
                string failReason = "";
                var result = new BLL.ExpenseBLL().ReturnApproval(long.Parse(eid), LoginUserId, out failReason);
                context.Response.Write(new Tools.Serialize().SerializeJson(new { result = result, reason = failReason }));
            }
        }
        public void AllReturnApproval(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(ids))
            {
                var idArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                var rBll = new BLL.ExpenseBLL();
                int faileTimes = 0;
                foreach (var eid in idArr)
                {
                    string faileReason;
                    var result = rBll.ReturnApproval(long.Parse(eid), LoginUserId, out faileReason);
                    if (!result)
                    {
                        faileTimes++;
                    }
                }
                context.Response.Write(faileTimes==0);
            }
        }
    }
}