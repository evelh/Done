using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System.Text;


namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class TransResource : BasePage
    {
        protected UserResourceBLL userBll = new UserResourceBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                List<sys_resource> allResList = userBll.GetAllSysResource();
                // 分类类别
                ddLeftRes.DataTextField = "name";
                ddLeftRes.DataValueField = "id";
                ddLeftRes.DataSource = allResList;
                ddLeftRes.DataBind();
                ddLeftRes.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

                ddRightRes.DataTextField = "name";
                ddRightRes.DataValueField = "id";
                ddRightRes.DataSource = allResList;
                ddRightRes.DataBind();
                ddRightRes.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });
            }

        }

        protected void ddLeftRes_SelectedIndexChanged(object sender, EventArgs e)
        {
            long resId = 0;
            if (long.TryParse(this.ddLeftRes.SelectedValue, out resId))
                liLeft.Text = GetDetailByRes(resId);
            else
                liLeft.Text = "";
        }

        protected void ddRightRes_SelectedIndexChanged(object sender, EventArgs e)
        {
            long resId = 0;
            if (long.TryParse(this.ddRightRes.SelectedValue, out resId))
                liRight.Text = GetDetailByRes(resId);
            else
                liRight.Text = "";
        }

        protected string GetDetailByRes(long resId)
        {
            StringBuilder html = new StringBuilder();
            sys_resource thisRes = userBll.GetResourceById(resId);
            if (thisRes == null)
                return "";
            // 
            html.Append("<div class='workspace'>");
            #region  用户信息
            html.Append($"<p align='left' style='padding-left: 10px;' class='FieldLabels'>{thisRes.name}<br />");

            if (!string.IsNullOrEmpty(thisRes.office_phone))
                html.Append($"<span style='font-weight:normal;'>办公电话: {thisRes.office_phone} </span ><br />");
            if (!string.IsNullOrEmpty(thisRes.home_phone))
                html.Append($"<span style='font-weight:normal;'>家庭电话: {thisRes.home_phone} </span ><br />");
            if (!string.IsNullOrEmpty(thisRes.email))
                html.Append($"<span style='font-weight:normal;'>邮箱: {thisRes.email} </span ><br />");
            html.Append("</p>");
            #endregion
            html.Append("<div style='padding-left: 10px;'><table cellspacing='0' cellpadding='4' border='0' class='FieldLabels'><tbody>");

            #region  客户信息
            html.Append("<tr><td align='left'>客户</td></tr>");
            List<crm_account> accList = new CompanyBLL().GetAccountBySql("SELECT id,name,phone from crm_account a where a.delete_time =0 and a.resource_id = "+ resId.ToString());
            if (accList != null && accList.Count > 0)
                accList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}-手机号 : &nbsp; {_.phone}</td></tr>");
                });
            #endregion

            #region  商机信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>商机</td></tr>");
            List<crm_opportunity> oppoList = new OpportunityBLL().GetOppoBySql($"SELECT id,name from crm_opportunity where delete_time =0 and resource_id = {resId.ToString()} and status_id not in ({(int)DicEnum.OPPORTUNITY_STATUS.LOST},{(int)DicEnum.OPPORTUNITY_STATUS.CLOSED},{(int)DicEnum.OPPORTUNITY_STATUS.IMPLEMENTED})");
            if (oppoList != null && oppoList.Count > 0)
                oppoList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });

            #endregion

            #region  待办信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>待办</td></tr>");
            List<com_activity> todoList = new ActivityBLL().GetToListBySql($"select id,name,description from com_activity where delete_time =0 and cate_id = {(int)DicEnum.ACTIVITY_CATE.TODO} and resource_id = {resId.ToString()} and status_id={(int)DicEnum.ACTIVITY_STATUS.NOT_COMPLETED}");
            if (todoList != null && todoList.Count > 0)
                todoList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.description}</td></tr>");
                });
            #endregion

            #region  活动信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>活动</td></tr>");
            List<com_activity> actList = new ActivityBLL().GetToListBySql($"select id,name,description from com_activity where delete_time =0 and cate_id <> {(int)DicEnum.ACTIVITY_CATE.TODO} and resource_id = {resId.ToString()} and status_id={(int)DicEnum.ACTIVITY_STATUS.NOT_COMPLETED}");
            if (actList != null && actList.Count > 0)
                actList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.description}</td></tr>");
                });
            #endregion
            html.Append("</tbody></table></div>");
            html.Append("</div>");

            return html.ToString();
        }

        protected void Trans_Click(object sender, EventArgs e)
        {
            bool result = false;
            long fromResId = 0; long toResId = 0;
            if (long.TryParse(this.ddRightRes.SelectedValue, out toResId) && long.TryParse(this.ddLeftRes.SelectedValue, out fromResId))
                result = userBll.TransResource(fromResId,toResId,LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');</script>");
            ddLeftRes_SelectedIndexChanged(sender,e);
            ddRightRes_SelectedIndexChanged(sender, e);
        }
    }
}