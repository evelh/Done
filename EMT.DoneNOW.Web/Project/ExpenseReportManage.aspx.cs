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

namespace EMT.DoneNOW.Web.Project
{
    public partial class ExpenseReportManage : BasePage
    {
        protected bool isAdd = true;
        protected sdk_expense_report thisReport = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var thisId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(thisId))
                {
                    thisReport = new sdk_expense_report_dal().FindNoDeleteById(long.Parse(thisId));
                    if (thisReport != null)
                    {
                        isAdd = false;
                    }
                }
            }
            catch (Exception msg)
            {
                Response.Write($"<script>alert('{msg.Message}');window.close();</script>");
            }

        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (isAdd)
            {
                thisReport = new sdk_expense_report();
            }
            else
            {
                thisReport = new sdk_expense_report_dal().FindNoDeleteById(thisReport.id);
            }
            thisReport.title = Request.Form["title"];
            var endDate = DateTime.Now;
            if (DateTime.TryParse(Request.Form["endDate"], out endDate))
            {
                thisReport.end_date = endDate;
                var cash_advance_amount = Request.Form["cash_advance_amount"];
                if (!string.IsNullOrEmpty(cash_advance_amount))
                {
                    thisReport.cash_advance_amount = decimal.Parse(cash_advance_amount);
                }
                else
                {
                    thisReport.cash_advance_amount = null;
                }
                var result = new ExpenseBLL().ReportManage(thisReport,LoginUserId); ;

                if (result)
                {

                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！');</script>");
                }

            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('周期结束日期格式不正确！');</script>");
            }
        }
    }
}