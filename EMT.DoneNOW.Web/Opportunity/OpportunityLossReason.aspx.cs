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
    public partial class OpportunityLossReason : BasePage
    {
        protected long id;
        private d_general lossreason = new d_general();
        private SysOpportunityBLL sobll = new SysOpportunityBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (id > 0)
            {
                lossreason = new GeneralBLL().GetSingleGeneral(id);
                if (lossreason == null)
                {
                    Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                }
                else
                {
                    this.Name.Text = lossreason.name.ToString();
                    if (lossreason.remark != null && !string.IsNullOrEmpty(lossreason.remark.ToString()))
                    {
                        this.Description.Text = lossreason.remark.ToString();
                    }
                    if (Convert.ToInt32(lossreason.is_active) > 0)
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
                Response.Write("<script>alert('丢失商机原因添加成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                Response.Write("<script>alert('丢失商机原因添加失败！');window.close();self.opener.location.reload();</script>");
            }

        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                // Response.Redirect("SysMarket.aspx");
                Response.Write("<script>alert('丢失商机原因添加失败！');window.location.href = 'OpportunityLossReason.aspx';</script>");
            }
            else
            {
                Response.Write("<script>alert('丢失商机原因添加失败！');window.close();self.opener.location.reload();</script>");
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
                lossreason = new GeneralBLL().GetSingleGeneral(id);
            }
            lossreason.name = this.Name.Text.Trim().ToString();
            if (!string.IsNullOrEmpty(this.Description.Text.Trim()))
            {
                lossreason.name = this.Description.Text.Trim().ToString();
            }
            if (this.Active.Checked)
            {
                lossreason.is_active = 1;
            }
            else
            {
                lossreason.is_active = 0;
            }

            if (id > 0)
            {
                //修改更新
                var result = sobll.UpdateWinORLossRe(lossreason, GetLoginUserId());
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
                var result = sobll.InsertLossRe(lossreason, GetLoginUserId());
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