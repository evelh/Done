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
        protected string pageFrom = "";  // 默认为空 代表从首页进行新增费用报表，保存后会跳转到别的页面
        protected bool isCopy = false;   // 代表是否是赋值费用报表
        protected long copyId = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var copy = Request.QueryString["isCopy"];
                if (!string.IsNullOrEmpty(copy))
                {
                    isCopy = true;
                }

                var thisId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(thisId))
                {
                    thisReport = new sdk_expense_report_dal().FindNoDeleteById(long.Parse(thisId));
                    if (thisReport != null)
                    {
                        isAdd = isCopy;
                    }
                    if (isCopy)
                    {
                        copyId = thisReport.id;
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
                thisReport.status_id = (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.HAVE_IN_HAND;
            }
            else
            {
                thisReport = new sdk_expense_report_dal().FindNoDeleteById(thisReport.id);
            }
            thisReport.title = Request.Form["title"];
            var endDate = DateTime.Now;
            if (DateTime.TryParse(Request.Form["end_date"], out endDate))
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
                var result = new ExpenseBLL().ReportManage(thisReport,LoginUserId, isCopy, copyId);

                if (result)
                {
                    if (!string.IsNullOrEmpty(pageFrom))
                    {
                    
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');setTimeout(function () { window.close(); self.opener.location.reload();}, 1000);</script>");
                        
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "打开报表", "<script>window.open('../TimeSheet/ExpenseReportDetail.aspx?id=" + thisReport.id + "', '" + (int)OpenWindow.EXPENSE_REPORT_DETAIL + "', 'left=200,top=200,width=900,height=750,resizable=yes', false);</script>");
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');setTimeout(function () { window.close(); self.opener.location.reload();}, 1000);</script>");
                        // 
                    }
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