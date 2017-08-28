using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class ActionType :BasePage
    {
        public long id;
        public ActionTypeBLL atbll = new ActionTypeBLL();
        public d_general action = new d_general();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (!IsPostBack) {
                this.View.DataTextField = "show";
                this.View.DataValueField = "val";
                this.View.DataSource = atbll.GetField().FirstOrDefault(_ => _.Key == "View").Value;
                this.View.DataBind();
                this.View.SelectedIndex = 0;
            }
            if (id > 0) {
                action=new GeneralBLL().GetSingleGeneral(id);
                if (action == null)
                {
                    Response.Write("<script>alert('获取市场相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                }
                else
                {
                    this.Name.Text = action.name.ToString();
                    this.View.SelectedValue = action.parent_id.ToString();
                    if (action.is_active > 0) {
                        this.Active.Checked = true;
                    }
                }
            }
        }


        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>alert('活动类型添加成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                Response.Write("<script>alert('活动类型添加失败！');window.close();self.opener.location.reload();</script>");
            }

        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>alert('活动类型添加失败！');window.location.href = 'ActionType.aspx';</script>");
            }
            else
            {
                Response.Write("<script>alert('活动类型添加失败！');window.close();self.opener.location.reload();</script>");
            }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        private bool save_deal() {
            action.name = this.Name.Text.Trim().ToString();
            action.parent_id = Convert.ToInt32(this.View.SelectedValue.ToString());
            if (this.Active.Checked)
            {
                action.is_active = 1;
            }
            else {
                action.is_active = 0;
            }
            if (id > 0) {//更新
                var result = atbll.UpdateActionType(action, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS) {
                    return true;
                }


            } else {//新增
                var result = atbll.InsertActionType(action, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS) {
                    return true;
                }
            }

            return false;

        }
    }
}