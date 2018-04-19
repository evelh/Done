using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class ResourceAssPolicyEdit : BasePage
    {
        protected List<tst_timeoff_policy> policyList;
        protected tst_timeoff_policy_resource plcAss = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            var bll = new TimeOffPolicyBLL();
            long id;
            long resId;
            if (!long.TryParse(Request.QueryString["resId"], out resId))
            {
                Response.End();
                return;
            }
            if (long.TryParse(Request.QueryString["id"], out id))
            {
                plcAss = new DAL.tst_timeoff_policy_resource_dal().FindById(id);
            }
            policyList = bll.GetPolicyList();

            if (IsPostBack)
            {
                DateTime effDate = DateTime.Parse(Request.Form["effDate"]);
                if (plcAss == null)
                {
                    long plcId = long.Parse(Request.Form["plc"]);
                    bll.AddEditTimeoffResource(0, resId, plcId, effDate, LoginUserId);
                }
                else
                {
                    if (effDate < plcAss.effective_date)
                    {
                        bll.AddEditTimeoffResource(plcAss.id, resId, plcAss.timeoff_policy_id, effDate, LoginUserId);
                    }
                }
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
                Response.End();
            }
        }
    }
}