using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class SysRolesAdd : BasePage
    {
        protected int id;
        public sys_role role = new sys_role();
        private SysRoleInfoBLL rolebll = new SysRoleInfoBLL();
        protected DataTable table = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);//获取角色id
            if(id>0)
            table = rolebll.resourcelist(id);
            if (!IsPostBack) {
                var dic = new SysRoleInfoBLL().GetField();
                this.Tax_cate.DataTextField = "show";
                this.Tax_cate.DataValueField = "val";
                this.Tax_cate.DataSource = dic.FirstOrDefault(_ => _.Key == "Tax_cate").Value;
                this.Tax_cate.DataBind();
                Tax_cate.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                if (id > 0)//修改
                {
                    role = new SysRoleInfoBLL().GetOneData(id);
                    this.Role_Name.Text = role.name.ToString();
                    if (Convert.ToInt32(role.is_active.ToString()) > 0) {
                        this.Active.Checked = true;
                    }
                    if (role.description != null && !string.IsNullOrEmpty(role.description.ToString()))
                    {
                        this.Role_Description.Text = role.description.ToString();
                    }
                    if (role.tax_cate_id != null && !string.IsNullOrEmpty(role.tax_cate_id.ToString()))
                    {
                        this.Tax_cate.SelectedValue = role.tax_cate_id.ToString();
                    }
                    this.Hourly_Billing_Rate.Text = role.hourly_rate.ToString();
                    this.Block_Hour_Multiplier.Text = role.hourly_factor.ToString();
                    if (role.is_excluded > 0) {
                        this.Excluded.Checked = true;
                    }                   
                }
            }
        }
        protected void SaveRole_Click(object sender, EventArgs e)
        {
            role.name = this.Role_Name.Text.Trim().ToString();
            if (this.Active.Checked)
            {
                role.is_active = 1;
            }
            else
            {
                role.is_active = 0;
            }
            if (!string.IsNullOrEmpty(this.Role_Description.Text.ToString()))
            {
                role.description = this.Role_Description.Text.Trim().ToString();
            }
            role.hourly_factor = Convert.ToDecimal(this.Block_Hour_Multiplier.Text.Trim().ToString());
            role.hourly_rate = Convert.ToDecimal(this.Hourly_Billing_Rate.Text.Trim().ToString());
            if (Convert.ToInt32(this.Tax_cate.SelectedValue.ToString()) > 0)
            {
                role.tax_cate_id = Convert.ToInt32(this.Tax_cate.SelectedValue.ToString());
            }
            if (this.Excluded.Checked)
            {
                role.is_excluded = 1;
            }
            else
            {
                role.is_excluded = 0;
            }
            if (id > 0)
            {
                role.id = id;
                var result = new SysRoleInfoBLL().Update(role, GetLoginUserId());
                if (result == ERROR_CODE.ERROR) {
                    Response.Write("<script>alert('修改失败！');</script>");
                }
                else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    Response.Write("<script>alert('角色修改成功！');window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                } else if(result==ERROR_CODE.EXIST){
                    Response.Write("<script>alert('已经存在相同名称的角色！');</script>");
                }
            }
            else {                
                var result = new SysRoleInfoBLL().Insert(role, GetLoginUserId());
                if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    Response.Write("<script>alert('角色添加成功！');window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
                else if (result == ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称的角色！');</script>");
                }
            }
            //Response.Write("<script>alert('角色添加成功！');window.close();self.opener.location.reload();</script>");
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
    }
}