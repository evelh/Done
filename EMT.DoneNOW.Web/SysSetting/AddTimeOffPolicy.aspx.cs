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
                Session["TimeoffPolicyTier"] = null;
                Session["TimeoffAssRes"] = null;

                if (string.IsNullOrEmpty(id))
                {
                    policyItems = bll.GetPolicyItemByPolicyId(0);
                }
                else
                {
                    policy = bll.GetPolicyById(long.Parse(id));
                    policyItems = bll.GetPolicyItemByPolicyId(long.Parse(id));
                }
            }
            else
            {
                tst_timeoff_policy policy = new tst_timeoff_policy();
                policy.description = Request.Form["description"];
                policy.name = Request.Form["policyName"];
                if (!string.IsNullOrEmpty(Request.Form["active"]) && Request.Form["active"].Equals("on"))
                    policy.is_active = 1;
                else
                    policy.is_active = 0;
                if (!string.IsNullOrEmpty(Request.Form["setDft"]) && Request.Form["setDft"].Equals("on"))
                    policy.is_default = 1;
                else
                    policy.is_default = 0;

                var resAss = Session["TimeoffAssRes"] as TimeoffAssociateResourceDto;
                var policyTier = Session["TimeoffPolicyTier"] as TimeoffPolicyTierListDto;
                List<tst_timeoff_policy_item> plcItemList = new List<tst_timeoff_policy_item>();
                policyItems = bll.GetPolicyItemByPolicyId(0);
                foreach (var itm in policyItems)
                {
                    if (string.IsNullOrEmpty(Request.Form["periodType" + itm.cate_id]))
                        continue;
                    tst_timeoff_policy_item item = new tst_timeoff_policy_item();
                    if (Request.Form["periodType" + itm.cate_id].Equals("1"))
                        item.accrual_period_type_id = null;
                    else
                        item.accrual_period_type_id = int.Parse(Request.Form["period" + itm.cate_id]);
                    item.cate_id = itm.cate_id;
                    plcItemList.Add(item);
                }

                if (string.IsNullOrEmpty(id))
                    bll.AddPolicy(policy, resAss, plcItemList, policyTier, LoginUserId);
                else
                    bll.EditPolicy(policy, LoginUserId);

                Session["TimeoffPolicyTier"] = null;
                Session["TimeoffAssRes"] = null;

                string action = Request.Form["subAct"];
                if (action == "SaveClose")
                {
                    Response.Write("<script>window.close();self.opener.location.reload();</script>");
                    Response.End();
                }
                if (action == "SaveNew")
                {
                    Response.Write("<script>window.location.href='AddTimeOffPolicy.aspx';self.opener.location.reload();</script>");
                    Response.End();
                }
            }
        }
    }
}