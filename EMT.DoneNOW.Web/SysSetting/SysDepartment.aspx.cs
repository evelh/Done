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

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class SysDepartment :BasePage
    {
        private int id = 0;
        public sys_department sd = new sys_department();
        protected DataTable table = new DataTable();
        protected DataTable worktable = new DataTable();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            //id = 875;
            if (!IsPostBack) {
                DepartmentBLL sqbll = new DepartmentBLL();
                this.location.DataTextField = "value";
                this.location.DataValueField = "key";
                this.location.DataSource = sqbll.GetDownList();
                this.location.DataBind();
                this.location.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                if (id > 0)
                {//打开修改模式
                    sd = sqbll.GetOne(id);
                    this.department_name.Text = sd.name;
                    if (sd.no != null && !string.IsNullOrEmpty(sd.no.ToString())) {
                        this.department_no.Text = sd.no.ToString();
                    }
                    if (sd.description != null && !string.IsNullOrEmpty(sd.description.ToString())) {
                        this.Description.Text = sd.description.ToString();
                    }
                    if (sd.location_id != null && !string.IsNullOrEmpty(sd.location_id.ToString())) {
                        this.location.SelectedValue = sd.location_id.ToString();
                        this.location_name.Text =this.location.SelectedItem.Text.ToString();
                        //获取时区
                        //this.time_zone.Text =sqbll.GetTime_zone(Convert.ToInt32(sd.location_id.ToString()));
                    }
                    table = sqbll.resourcelist(id);
                    worktable = sqbll.worklist(id);
                }
            }
        }
        /// <summary>
        /// 保存数据前处理，收集数据
        /// </summary>
        public void save_deal() {
            sd.name = this.department_name.Text.Trim().ToString();
            if (Convert.ToInt32(this.location.SelectedValue.ToString()) > 0)
            {//若选择
                sd.location_id = Convert.ToInt32(this.location.SelectedValue.ToString());
            }
            if (!string.IsNullOrEmpty(this.department_no.Text.ToString()))
            {//若存在，保存编号(人工填写）
                sd.no = this.department_no.Text.Trim().ToString();
            }
            if (!string.IsNullOrEmpty(this.Description.Text.ToString()))
            {
                sd.description = this.Description.Text.Trim().ToString();
            }
        }
        /// <summary>
        /// 保存并关闭
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            save_deal();
            if (id > 0)
            {
                sd.id = id;
                var result = new DepartmentBLL().Update(sd, GetLoginUserId());
                if (result == ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('部门信息修改成功！');window.close();self.opener.location.reload();</script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
            }
            else {
                var result = new DepartmentBLL().Insert(sd, GetLoginUserId());
                //新增成功
                if (result == ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('部门信息保存成功！');window.close();self.opener.location.reload();</script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
            }          
        }
        /// <summary>
        /// 取消
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Cancle_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        protected void location_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (Convert.ToInt32(this.location.SelectedValue.ToString()) > 0)
            {
                this.location_name.Text = this.location.SelectedItem.Text.ToString();
                //获取时区
                //this.time_zone.Text = new DepartmentBLL().GetTime_zone(Convert.ToInt32(this.location.SelectedValue.ToString()));
            }
        }
    }
}