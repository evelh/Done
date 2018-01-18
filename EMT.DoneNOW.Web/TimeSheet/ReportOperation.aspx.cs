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

namespace EMT.DoneNOW.Web
{
    public partial class ReportOperation : BasePage
    {
        protected sdk_expense_report thisReport = null;
        protected sys_resource subRes = null;
        protected List<sdk_expense> expList = null;       // 报表下的费用
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var thisId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(thisId))
                {
                    thisReport = new sdk_expense_report_dal().FindNoDeleteById(long.Parse(thisId));
                }
                if(thisReport==null)
                {
                    Response.Write("<script>alert('报表已删除');window.close();</script>");
                }
                else if (thisReport.status_id != (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.WAITING_FOR_APPROVAL)
                {
                    Response.Write("<script>alert('报表的状态必须是待审批！');window.close();</script>");
                }
                else
                {
                    if (thisReport.submit_user_id != null)
                    {
                        subRes = new sys_resource_dal().FindNoDeleteById((long)thisReport.submit_user_id);
                    }
                    expList = new sdk_expense_dal().GetExpByReport(thisReport.id);

                }
            }
            catch (Exception msg)
            {
                Response.Write($"<script>alert('{msg.Message}！');window.close();</script>");
            }
            
        }

        protected void Approval_Click(object sender, EventArgs e)
        {
            var notifyIds = Request.Form["notiIds"];
            string faileReason = "";
            var result = new ExpenseBLL().Approval(thisReport.id,LoginUserId,out faileReason, notifyIds);
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！"+ faileReason + "');window.close();self.opener.location.reload();</script>");
            }
        }

        protected void Refuse_Click(object sender, EventArgs e)
        {
            var notifyIds = Request.Form["notiIds"];
            var refuseReason = Request.Form["rejection_reason"];
            string chooseExpIds = Request.Form["refIds"];  // 页面上选择的拒绝的费用信息
            string faileReason = "";
            var result = new ExpenseBLL().ApprovalRefuse(thisReport.id, refuseReason, LoginUserId, out faileReason, notifyIds, chooseExpIds, true);
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！" + faileReason + "');window.close();self.opener.location.reload();</script>");
            }
        }
    }
}