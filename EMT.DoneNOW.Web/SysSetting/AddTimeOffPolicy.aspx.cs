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
    public partial class AddTimeOffPolicy : BasePage
    {
        protected bool isAdd;
        protected List<tst_timeoff_policy_item> policyItems;
        private TimeOffPolicyBLL bll = new TimeOffPolicyBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            if (!IsPostBack)
            {
                if (string.IsNullOrEmpty(id))
                {
                    policyItems = bll.GetPolicyItemByPolicyId(0);
                }
                else
                {
                    policyItems = bll.GetPolicyItemByPolicyId(long.Parse(id));
                }
            }
        }
    }
}