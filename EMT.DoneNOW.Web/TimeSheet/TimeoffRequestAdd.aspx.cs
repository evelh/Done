using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.TimeSheet
{
    public partial class TimeoffRequestAdd : BasePage
    {
        protected List<v_timeoff_total> timeoffSummary;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                tst_timeoff_request rqst = AssembleModel<tst_timeoff_request>();
                bool onlyWorkday = false;
                if (string.IsNullOrEmpty(Request.Form["onlyWorkday"]) || Request.Form["onlyWorkday"].Equals("on"))
                    onlyWorkday = true;
                DateTime start = DateTime.Parse(Request.Form["startDate"]);
                DateTime end;
                if (string.IsNullOrEmpty(Request.Form["endDate"]))
                    end = new DateTime(start.Ticks);
                else
                    end = DateTime.Parse(Request.Form["endDate"]);

                new TimeOffPolicyBLL().AddTimeoffRequest(rqst, start, end, onlyWorkday, LoginUserId);
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
                Response.End();
            }
            else
            {
                timeoffSummary = new TimeOffPolicyBLL().GetResourceTimeoffTotal(LoginUserId, DateTime.Now.Year);
            }
        }
    }
}