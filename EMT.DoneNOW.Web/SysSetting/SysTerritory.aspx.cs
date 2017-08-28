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
    public partial class SysTerritory : BasePage
    {
        public int id = 0;
        protected d_general d = new d_general();
        protected SysTerritoryBLL stbll = new SysTerritoryBLL();
        public List<sys_resource> AccountList = new List<sys_resource>();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);//获取id
            id = 5;
            if (!IsPostBack) {
                //Region下拉框
                var dic = stbll.GetRegionDownList();
                this.Region.DataTextField = "show";
                this.Region.DataValueField = "val";
                this.Region.DataSource = dic.FirstOrDefault(_ => _.Key == "Region").Value;
                this.Region.DataBind();
                Region.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                //操作
                
            }
            if (id > 0)//修改
            {
                var a = new GeneralBLL().GetSingleGeneral(id);
                if (a == null)
                {
                    Response.Write("<script>alert('获取地域相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                }
                else
                {
                    this.Territory_Name.Text = a.name.ToString();
                    this.Region.SelectedValue = a.parent_id.ToString();
                    if (a.remark != null && !string.IsNullOrEmpty(a.remark.ToString()))
                    {
                        this.Territory_Description.Text = a.remark.ToString();
                    }
                }
                //获取地域所属员工
                AccountList = stbll.GetAccountList(id);
            }
            else
            {//新增

            }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
           
        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Redirect("SysTerritory.aspx");
            }
            else {
                Response.Write("<script>alert('地域添加失败！');window.close();self.opener.location.reload();</script>");
            }           
        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>alert('地域添加成功！');window.close();self.opener.location.reload();</script>");
            }
            else {
                Response.Write("<script>alert('地域添加失败！');window.close();self.opener.location.reload();</script>");
            }           
        }
        /// <summary>
        /// 数据保存处理
        /// </summary>
        private bool save_deal() {
            d.name = this.Territory_Name.Text.Trim().ToString();
            d.parent_id = Convert.ToInt32(this.Region.SelectedValue.ToString());
            if (!string.IsNullOrEmpty(this.Territory_Description.Text.Trim().ToString())) {
                d.remark= this.Territory_Description.Text.Trim().ToString();
            }
            var result= stbll.InsertTerritory(d, GetLoginUserId(),ref id);
            if (result == DTO.ERROR_CODE.SUCCESS) {
                return true;
            }
            if (result == DTO.ERROR_CODE.EXIST) {
                Response.Write("<script>alert('已经存在该名称地域');</script>");
            }
            return false;
        }
    }
}