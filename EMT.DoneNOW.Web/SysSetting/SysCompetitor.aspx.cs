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
    public partial class SysCompetitor :BasePage
    {
        private int id = 0;
        protected d_general compe = new d_general();
        protected CompetitorBLL smbll = new CompetitorBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);//获取id
            id = 10;
            if (!IsPostBack)
            {
                if (id > 0)//修改
                {
                    compe = new GeneralBLL().GetSingleGeneral(id);
                    if (compe == null)
                    {
                        Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else
                    {
                        this.Competitor_Name.Text = compe.name.ToString();
                        if (compe.remark != null && !string.IsNullOrEmpty(compe.remark.ToString()))
                        {
                            this.Competitor_Description.Text = compe.remark.ToString();
                        }
                    }
                }
            }

        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>alert('竞争对手添加成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                Response.Write("<script>alert('竞争对手添加失败！');window.close();self.opener.location.reload();</script>");
            }

        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                // Response.Redirect("SysMarket.aspx");
                Response.Write("<script>alert('竞争对手添加失败！');window.location.href = 'SysMarket.aspx';</script>");
            }
            else
            {
                Response.Write("<script>alert('竞争对手添加失败！');window.close();self.opener.location.reload();</script>");
            }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        private bool save_deal()
        {
            if (id > 0)//修改
            {
                compe = new GeneralBLL().GetSingleGeneral(id);
                if (compe == null)
                {
                    Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                }
            }
             compe.name = this.Competitor_Name.Text.Trim().ToString();
            if (!string.IsNullOrEmpty(this.Competitor_Name.Text.Trim().ToString()))
            {
                compe.remark = this.Competitor_Description.Text.Trim().ToString();
            }
            if (id > 0)
            {
                var result = smbll.UpdateCompetitor(compe, GetLoginUserId());
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
                var result = smbll.InsertCompetitor(compe, GetLoginUserId());
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