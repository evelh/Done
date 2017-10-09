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
    public partial class OpportunityLeadSource :BasePage
    {
        protected long id;
        private d_general leadsource = new d_general();
        private GeneralBLL sobll = new GeneralBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (!IsPostBack)
            {
                if (id > 0)
                {
                    leadsource = new GeneralBLL().GetSingleGeneral(id);
                    if (leadsource == null)
                    {
                        Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else
                    {
                        this.Name.Text = leadsource.name.ToString();
                        if (leadsource.remark != null && !string.IsNullOrEmpty(leadsource.remark.ToString()))
                        {
                            this.Description.Text = leadsource.remark.ToString();
                        }
                        if (leadsource.code != null && !string.IsNullOrEmpty(leadsource.code.ToString()))
                        {
                            this.Number.Text = leadsource.code.ToString();
                        }
                    }
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
                Response.Write("<script>window.location.href = 'OpportunityLeadSource.aspx';</script>");
            }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();</script>");
        }
        private bool save_deal()
        {
            if (id > 0)
            {
                leadsource = new GeneralBLL().GetSingleGeneral(id);
            }
            leadsource.name = this.Name.Text.Trim().ToString();
            if (!string.IsNullOrEmpty(this.Description.Text.Trim()))
            {
                leadsource.remark = this.Description.Text.Trim().ToString();
            }
            if(!string.IsNullOrEmpty(this.Number.Text.Trim().ToString()))
            leadsource.sort_order =Convert.ToDecimal( this.Number.Text.Trim().ToString());
            if (id > 0)
            {
                //修改更新
                if ((leadsource.sort_order != null && sobll.update_sort_order(leadsource.id, leadsource.general_table_id, (Decimal)leadsource.sort_order)) || leadsource.sort_order == null)
                {
                    var result = sobll.Update(leadsource, GetLoginUserId());
                    if (result == DTO.ERROR_CODE.SUCCESS)
                    {
                        Response.Write("<script>alert('商机来源修改成功！');</script>");
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
                else {
                    Response.Write("<script>alert('已经存在的商机来源中包含该序列号，请修改！');</script>");
                }
                   
            }
            else
            {

                //新增
                leadsource.general_table_id = (int)GeneralTableEnum.OPPORTUNITY_SOURCE;
                if (leadsource.sort_order == null || (leadsource.sort_order != null && sobll.sort_order(leadsource.general_table_id, (Decimal)leadsource.sort_order)))
                {
                    var result = sobll.Insert(leadsource, GetLoginUserId());
                    if (result == DTO.ERROR_CODE.SUCCESS)
                    {
                        Response.Write("<script>alert('商机来源添加成功！');</script>");
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
                else {
                    Response.Write("<script>alert('已经存在的商机来源中包含该序列号，请修改！');</script>");
                }                    
            }
            return false;
        }
    }
}