using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
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
        public GeneralBLL atbll = new GeneralBLL();
        public d_general action = new d_general();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (!IsPostBack) {
                this.View.DataTextField = "show";
                this.View.DataValueField = "val";
                this.View.DataSource = atbll.GetCalendarField().FirstOrDefault(_ => _.Key == "View").Value;
                this.View.DataBind();
                this.View.SelectedIndex = 0;
                if (id > 0)
                {
                    action = new GeneralBLL().GetSingleGeneral(id);
                    if (action == null)
                    {
                        Response.Write("<script>alert('获取市场相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else
                    {
                        this.Name.Text = action.name.ToString();
                        this.View.SelectedValue = action.parent_id.ToString();
                        if (action.is_active > 0)
                        {
                            this.Active.Checked = true;
                        }
                        else
                        {
                            this.Active.Checked = true;
                        }
                    }
                }
                else {
                    this.Active.Checked = true;
                }
            }
            
        }


        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
            }
        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>window.location.href = 'ActionType.aspx';</script>");
            }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        private bool save_deal() {
            if (id > 0)
            {
                action = new GeneralBLL().GetSingleGeneral(id);
                if (action == null)
                {
                    Response.Write("<script>alert('获取市场相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                }
            }
            action.name = this.Name.Text.Trim().ToString();
            action.parent_id = Convert.ToInt32(this.View.SelectedValue.ToString());
            action.general_table_id = (int)GeneralTableEnum.ACTION_TYPE;
            if (this.Active.Checked)
            {
                action.is_active = 1;
            }
            else {
                action.is_active = 0;
            }
            if (id > 0) {//更新
                var result = atbll.Update(action, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('活动类型修改成功！');</script>");
                    return true;
                }
                else if (result == DTO.ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
                else {
                    Response.Write("<script>alert('活动类型修改失败！');</script>");
                }

            } else {//新增
                var result = atbll.Insert(action, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('活动类型添加成功！');</script>");
                    return true;
                }
                else if (result == DTO.ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
                else {
                    Response.Write("<script>alert('活动类型添加失败！');</script>");
                }
            }

            return false;

        }
    }
}