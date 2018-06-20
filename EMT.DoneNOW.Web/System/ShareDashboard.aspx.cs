using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class ShareDashboard : BasePage
    {
        protected long id;      // 仪表板id
        protected string name;  // 仪表板名称
        protected string seclvnames;    // 共享的安全等级名称
        protected string dptnames;      // 共享的部门名称
        protected string resnames;      // 共享的员工名称
        protected string seclvids;      // 共享的安全等级id
        protected string dptids;        // 共享的部门id
        protected string resids;        // 共享的员工id
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!long.TryParse(Request.QueryString["id"], out id))
            {
                Response.End();
                return;
            }

            var bll = new BLL.DashboardBLL();
            var ds = bll.GetDashboard(id);
            name = ds.name;
            if (IsPostBack)
            {
                string secs = Request.Form["secs"];
                string dpts = Request.Form["dpts"];
                string res = Request.Form["res"];

                bll.DashboardShareSetting(id, secs, dpts, res, LoginUserId);
            }
            var list = bll.GetDashboardPublishNames(id);
            if (list.Count == 6)
            {
                seclvnames = list[0];
                dptnames = list[2];
                resnames = list[4];
                seclvids = list[1];
                dptids = list[3];
                resids = list[5];
            }
        }
    }
}