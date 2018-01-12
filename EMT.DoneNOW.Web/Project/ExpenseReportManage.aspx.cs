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
    }
}