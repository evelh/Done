using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web
{
    public partial class AcceptOfferWidget : BasePage
    {
        protected string wgtName;
        protected string resName;
        private DashboardBLL bll = new DashboardBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long widgetId = long.Parse(Request.QueryString["wgtid"]);
            long resId = long.Parse(Request.QueryString["resid"]);

            wgtName = bll.GetWidgetById(widgetId).name;
            resName = new UserResourceBLL().GetUserById(resId).name;

            if (!IsPostBack)
            {
                new DAL.sys_notice_resource_dal().FirstReadNotice(long.Parse(Request.QueryString["ntid"]), LoginUserId);

                var dsList = bll.GetWidgetMoveDashboard(widgetId, LoginUserId);
                dashboardList.DataSource = dsList;
                dashboardList.DataTextField = "show";
                dashboardList.DataValueField = "val";
                dashboardList.DataBind();
            }
        }

        /// <summary>
        /// 接收
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_Click(object sender, EventArgs e)
        {
            long ntid = long.Parse(Request.QueryString["ntid"]);
            if (string.IsNullOrEmpty(dashboardList.SelectedValue))
            {
                Response.Write("<script>alert('请选择一个仪表板！');</script>");
                return;
            }
            long dsid = long.Parse(dashboardList.SelectedValue);
            var rslt = bll.AcceptShareWidget(long.Parse(Request.QueryString["wgtid"]), dsid, ntid, LoginUserId);
            if (string.IsNullOrEmpty(rslt))
            {
                Response.Write("<script>alert('接收成功！');window.parent.CancelDialog('" + Request.QueryString["Nav"] + "');</script>");
                return;
            }
            else
            {
                Response.Write("<script>alert('" + rslt + "');</script>");
                return;
            }
        }

        /// <summary>
        /// 拒绝
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void decline_Click(object sender, EventArgs e)
        {
            long ntid = long.Parse(Request.QueryString["ntid"]);
            bll.DeclineShareWidget(ntid, LoginUserId);
            Response.Write("<script>window.parent.CancelDialog('" + Request.QueryString["Nav"] + "');</script>");
        }
    }
}