using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.TimeSheet
{
    public partial class MyTimeoffBalance : BasePage
    {
        protected long resourceId;
        protected long cateId;
        protected decimal balance;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["resId"]) || string.IsNullOrEmpty(Request.QueryString["cateId"]))
            {
                Response.End();
                return;
            }
            resourceId = long.Parse(Request.QueryString["resId"]);
            cateId = long.Parse(Request.QueryString["cateId"]);
            var summary = new BLL.TimeOffPolicyBLL().GetResourceTimeoffTotal(resourceId, DateTime.Now.Year);
            var blc = summary.Find(_ => _.task_id == cateId);
            if (blc == null)
                balance = 0;
            else
                balance = blc.current_balance;
        }
    }
}