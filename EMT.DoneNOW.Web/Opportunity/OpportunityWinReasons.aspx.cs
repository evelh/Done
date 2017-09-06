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
    public partial class OpportunityWinReasons :BasePage
    {
        protected long id;
        private d_general winreason = new d_general();
        private SysOpportunityBLL sobll = new SysOpportunityBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (id > 0) {
                winreason = new GeneralBLL().GetSingleGeneral(id);
                if (winreason == null)
                {
                    Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                }
                else
                {
                    this.Name.Text = winreason.name.ToString();
                    if (winreason.remark != null && !string.IsNullOrEmpty(winreason.remark.ToString()))
                    {
                        this.Description.Text = winreason.remark.ToString();
                    }
                    if (Convert.ToInt32(winreason.is_active)>0)
                    {
                        this.Active.Checked = true;
                    }
                }
            }
        }
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>alert('赢得商机原因添加成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                Response.Write("<script>alert('赢得商机原因添加失败！');window.close();self.opener.location.reload();</script>");
            }

        }
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        private bool save_deal()
        {
            if (id > 0)
            {
                winreason = new GeneralBLL().GetSingleGeneral(id);
            }
            winreason.name = this.Name.Text.Trim().ToString();
            if (!string.IsNullOrEmpty(this.Description.Text.Trim()))
            {
                winreason.name = this.Description.Text.Trim().ToString();
            }
            if (this.Active.Checked)
            {
                winreason.is_active = 1;
            }
            else {
                winreason.is_active = 0;
            }

            if (id > 0)
            {
                //修改更新
                var result = sobll.UpdateWinORLossRe(winreason, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
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
            }
            else
            {
                //新增
                var result = sobll.InsertWin(winreason, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
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
            }
            return false;
        }
    }
}