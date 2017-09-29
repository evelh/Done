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
    public partial class ContractMilestone : BasePage
    {
        public long id;
        private d_general contract_milestone = new d_general();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (id > 0)
            {
                contract_milestone = new GeneralBLL().GetSingleGeneral(id);
                if (contract_milestone == null)
                {
                    Response.Write("<script>alert('获取相关信息失败，无法修改！');</script>");
                }
                else
                {
                    this.Name.Text = contract_milestone.name.ToString();
                    if (contract_milestone.is_active > 0)
                    {
                        this.Active.Checked = true;
                    }
                    else {
                        this.Active.Checked = false;
                    }
                }
            }
            else {
                this.Active.Checked = true;
            }
        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (id > 0)
            {
                contract_milestone = new GeneralBLL().GetSingleGeneral(id);
                if (contract_milestone == null)
                {
                    Response.Write("<script>alert('获取相关信息失败，无法修改！');</script>");
                }
            }
            contract_milestone.name = this.Name.Text.Trim().ToString();
            if(!string.IsNullOrEmpty(this.SortOrder.Text.Trim().ToString()))
            contract_milestone.sort_order =Convert.ToDecimal(this.SortOrder.Text.Trim().ToString());
            if (this.Active.Checked)
            {
                contract_milestone.is_active = 1;
            }
            if (id > 0)
            {
                //修改              

                if ((contract_milestone.sort_order != null && new GeneralBLL().update_sort_order(contract_milestone.id, contract_milestone.general_table_id, (Decimal)contract_milestone.sort_order)) || contract_milestone.sort_order == null)
                {
                    var result = new GeneralBLL().Update(contract_milestone, GetLoginUserId());
                    if (result == ERROR_CODE.SUCCESS)
                    {
                        Response.Write("<script>alert('里程碑状态修改成功！');window.close();self.opener.location.reload();</script>");
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
                else {
                    Response.Write("<script>alert('已经存在相同的排序号，请修改！');</script>");
                }
            }
            else
            {
                //新增
                contract_milestone.general_table_id = (int)GeneralTableEnum.CONTRACT_MILESTONE;
                if ((contract_milestone.sort_order != null && new GeneralBLL().sort_order(contract_milestone.general_table_id, (Decimal)contract_milestone.sort_order)) || contract_milestone.sort_order == null)
                {
                    var result = new GeneralBLL().Insert(contract_milestone, GetLoginUserId());
                    if (result == ERROR_CODE.SUCCESS)
                    {
                        Response.Write("<script>alert('里程碑状态添加成功！');window.close();self.opener.location.reload();</script>");
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
                else {
                    Response.Write("<script>alert('已经存在相同的排序号，请修改！');</script>");
                }
            }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
    }
}