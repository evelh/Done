using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class AddTimeOffPolicy : BasePage
    {
        protected bool isAdd;
        protected tst_timeoff_policy policy;
        protected List<tst_timeoff_policy_item> policyItems;
        protected List<DictionaryEntryDto> periodList;
        private TimeOffPolicyBLL bll = new TimeOffPolicyBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            if (string.IsNullOrEmpty(id))
                isAdd = true;
            else
                isAdd = false;
            if (!IsPostBack)
            {
                periodList = new GeneralBLL().GetDicValues(GeneralTableEnum.TIME_OFF_PERIOD_TYPE);

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