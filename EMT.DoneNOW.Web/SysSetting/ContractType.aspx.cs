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
    public partial class ContractType : BasePage
    {
        public long id;
        private d_general contract = new d_general();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (id > 0)
            {
                contract = new GeneralBLL().GetSingleGeneral(id);
                if (contract == null)
                {
                    Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                }
                else
                {
                    this.Name.Text = contract.name.ToString();
                    if (contract.remark != null)
                        this.Description.Text = contract.remark.ToString();
                    if (contract.is_active > 0)
                    {
                        this.Active.Checked = true;
                    }
                    else
                    {
                        this.Active.Checked = false;
                    }
                    if (contract.is_active > 0)
                    {
                        this.Active.Checked = true;
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
                contract = new GeneralBLL().GetSingleGeneral(id);
                if (contract == null)
                {
                    Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                }
            }
            contract.name = this.Name.Text.Trim().ToString();
            contract.remark = this.Description.Text.Trim().ToString();
            if (this.Active.Checked)
            {
                contract.is_active = 1;
            }
            else {
                contract.is_active = 0;
            }
            if (id > 0)
            {
                //修改
                var result = new GeneralBLL().Update(contract, GetLoginUserId());
                if (result == ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('合同类别修改成功！');window.close();self.opener.location.reload();</script>");
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
                else {
                    Response.Write("<script>alert('合同类别修改失败！');window.close();self.opener.location.reload();</script>");
                }
            }
            else
            {
                //新增
                contract.general_table_id = (int)GeneralTableEnum.CONTRACT_CATE;
                var result = new GeneralBLL().Insert(contract, GetLoginUserId());
                if (result == ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('合同类别添加成功！');window.close();self.opener.location.reload();</script>");
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
                else {
                    Response.Write("<script>alert('合同添加失败！');window.close();self.opener.location.reload();</script>");
                }
            }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
    }
}