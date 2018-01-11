using System;
using EMT.DoneNOW.BLL;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class RoleRate : BasePage
    {
        protected long rateId = 0;      // 角色费率id
        private long contractId = 0;  // 合同id
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string rid = Request.QueryString["id"];
                if (!long.TryParse(rid, out rateId))
                    rateId = 0;
                rid = Request.QueryString["contractId"];
                if (!long.TryParse(rid, out contractId))
                {
                    Response.Close();
                    return;
                }

                contract_id.Value = contractId.ToString();
                id.Value = rateId.ToString();

                var roleList = new ContractRateBLL().GetAvailableRoles(contractId);
                role_id.DataTextField = "name";
                role_id.DataValueField = "id";
                role_id.DataSource = roleList;
                role_id.DataBind();

                if (rateId > 0)
                    InitFieldEdit(roleList);
            }
        }

        // 编辑费率，初始化信息
        private void InitFieldEdit(List<sys_role> roleList)
        {
            var roleRate = new ContractRateBLL().GetRoleRate(rateId);
            role_id.SelectedValue = roleRate.role_id.ToString();
            role_rate.Text = roleList.Find(r => r.id == roleRate.role_id).hourly_rate.ToString();
            rate.Text = roleRate.rate.ToString();
        }

        // 修改选择角色
        protected void role_id_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var roleList = new ContractRateBLL().GetAvailableRoles(contractId);
                long roleId = long.Parse(role_id.SelectedValue);
                role_rate.Text = roleList.Find(r => r.id == roleId).hourly_rate.ToString();
                rate.Text = role_rate.Text;
            }
           
        }

        // 保存并关闭
        protected void SaveClose_Click(object sender, EventArgs e)
        {
            if (SaveRate())
            {
                Response.Write("<script>alert('添加费率成功！');window.close();self.opener.location.reload();</script>");
            }
        }

        // 保存并新建
        protected void SaveNew_Click(object sender, EventArgs e)
        {
            long contractId = long.Parse(contract_id.Value);
            if (SaveRate())
            {
                Response.Redirect("RoleRate.aspx?contractId=" + contractId);
            }
        }

        private bool SaveRate()
        {
            ctt_contract_rate roleRate = new ctt_contract_rate();
            long contractId = long.Parse(contract_id.Value);
            long rateId = long.Parse(id.Value);
            
            roleRate.id = rateId;
            roleRate.contract_id = contractId;
            roleRate.role_id = long.Parse(role_id.SelectedValue);
            decimal rateNum;
            if (!decimal.TryParse(rate.Text, out rateNum))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('费率格式错误，请重新填写');</script>");
                return false;
            }
            //if (rateId == 0)
            //{
                var isExRole = new ContractRateBLL().IsExistRole(contractId, roleRate.role_id, rateId);
                if (isExRole)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('角色已存在');</script>");
                    return false;
                }
            //}
            

            roleRate.rate = rateNum;
            new ContractRateBLL().CreateOrUpdateRate(roleRate, GetLoginUserId());

            return true;
        }
    }
}