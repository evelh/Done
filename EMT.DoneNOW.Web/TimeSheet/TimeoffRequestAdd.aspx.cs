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
        protected string resourceName;
        protected void Page_Load(object sender, EventArgs e)
        {
            long resourceId;
            if (!string.IsNullOrEmpty(Request.QueryString["resourceId"]))
                resourceId = long.Parse(Request.QueryString["resourceId"]);
            else
                resourceId = LoginUserId;
            resourceName = new UserResourceBLL().GetResourceById(resourceId).name;

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

                new TimeOffPolicyBLL().AddTimeoffRequest(rqst, start, end, onlyWorkday, resourceId);
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
                Response.End();
            }
            else
            {
                timeoffSummary = new TimeOffPolicyBLL().GetResourceTimeoffTotal(resourceId, DateTime.Now.Year);
            }
        }
    }
}