using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class SysMarket :BasePage
    {
        private int id = 0;
        protected d_general mark = new d_general();
        protected SysMarketBLL smbll = new SysMarketBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);//获取id
            if (!IsPostBack) {
                if (id > 0)//修改
                {
                    mark= new GeneralBLL().GetSingleGeneral(id);
                    if (mark == null)
                    {
                        Response.Write("<script>alert('获取市场相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else
                    {
                        this.Market_Name.Text = mark.name.ToString();
                        if (mark.remark != null && !string.IsNullOrEmpty(mark.remark.ToString()))
                        {
                            this.Market_Description.Text = mark.remark.ToString();
                        }
                    }
                }
                else
                {//新增

                }
            }

        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>alert('市场添加成功！');window.close();self.opener.location.reload();</script>");
            }
            else {
                Response.Write("<script>alert('市场添加失败！');window.close();self.opener.location.reload();</script>");
            }
           
        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
               // Response.Redirect("SysMarket.aspx");
                Response.Write("<script>alert('市场添加失败！');window.location.href = 'SysMarket.aspx';</script>");
            }
            else
            {
                Response.Write("<script>alert('市场添加失败！');window.close();self.opener.location.reload();</script>");
            }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        private bool save_deal()
        {
            mark.name = this.Market_Name.Text.Trim().ToString();
            if (!string.IsNullOrEmpty(this.Market_Description.Text.Trim().ToString()))
            {
                mark.remark = this.Market_Description.Text.Trim().ToString();
            }
            if (id > 0)
            {
                var result = smbll.UpdateMarket(mark, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    return true;
                }
            }
            else {
                var result = smbll.InsertMarket(mark, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    return true;
                }
            }
            return false;
        }
    }
}