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


namespace EMT.DoneNOW.Web.TimeSheet
{
    public partial class RefuseReportReason : BasePage
    {
        protected sdk_expense_report thisReport = null;
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
                if (thisReport == null)
                {
                    Response.Write("<script>alert('报表已删除');window.close();</script>");
                    return;
                } 
                if(thisReport.status_id != (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.REJECTED)
                {
                    Response.Write("<script>alert('报表不是拒绝状态，无需查看');window.close();</script>");
                    return;
                }
                expList = new sdk_expense_dal().GetExpByReport(thisReport.id);

            }
            catch (Exception msg)
            {
                Response.Write($"<script>alert('{msg.Message}！');window.close();</script>");
            }
        }
    }
}