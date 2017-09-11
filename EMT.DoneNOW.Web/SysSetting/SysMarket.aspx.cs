using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
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
        protected GeneralBLL smbll = new GeneralBLL();
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
            }

        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>alert('市场添加成功！');window.close();self.opener.location.reload();</script>");
            }
        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>alert('市场添加成功！');window.location.href = 'SysMarket.aspx';</script>");
            }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        private bool save_deal()
        {
            if (id > 0) {
                mark = new GeneralBLL().GetSingleGeneral(id);
            }
            mark.name = this.Market_Name.Text.Trim().ToString();
            if (!string.IsNullOrEmpty(this.Market_Description.Text.Trim().ToString()))
            {
                mark.remark = this.Market_Description.Text.Trim().ToString();
            }
            if (id > 0)
            {
                var result = smbll.Update(mark, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    return true;
                }
                if (result == DTO.ERROR_CODE.USER_NOT_FIND) {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
            }
            else {
                mark.general_table_id = (int)GeneralTableEnum.MARKET_SEGMENT;
                var result = smbll.Insert(mark, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    return true;
                }
                else if (result == DTO.ERROR_CODE.USER_NOT_FIND)
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
                else {
                    return false;
                }
            }
            return false;
        }
    }
}