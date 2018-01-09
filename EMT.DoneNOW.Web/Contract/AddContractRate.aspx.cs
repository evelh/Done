using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;


namespace EMT.DoneNOW.Web.Contract
{
    public partial class AddContractRate :BasePage
    {
        protected bool isAdd = true;
        protected ctt_contract_rate conRate = null;
        protected ctt_contract contract = null;
        protected List<sys_role> roleList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var contract_id = Request.QueryString["contract_id"];
                if (!string.IsNullOrEmpty(contract_id))
                {
                    contract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contract_id));
                    if (contract != null)
                    {
                        roleList = new sys_role_dal().GetContarctNoRate(contract.id);
                    }
                }

                var rate_id = Request.QueryString["rate_id"];
                if (!string.IsNullOrEmpty(rate_id))
                {
                    conRate = new ctt_contract_rate_dal().FindNoDeleteById(long.Parse(rate_id));
                    if (conRate!= null){
                        isAdd = false;
                        var thisRole = new sys_role_dal().FindNoDeleteById(conRate.role_id);
                        roleList.Add(thisRole);
                    }
                }

                if(roleList!=null&& roleList.Count > 0)
                {
                    role_id.DataTextField = "name";
                    role_id.DataValueField = "id";
                    role_id.DataSource = roleList;
                    role_id.DataBind();
                    role_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                    if (!isAdd)
                    {
                        role_id.SelectedValue = conRate.role_id.ToString();
                    }
                    
                }
                else
                {
                    Response.Write("<script>alert('在你可以添加更多的合同费率之前，请在系统中加入更多的角色。在你可以添加额外的合同费率之前，请在系统中加入额外的角色。');window.close();</script>");
                }
               

            }
            catch (Exception)
            {

                Response.End();
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            // CreateOrUpdateRate
            var param = GetParam();
            new ContractRateBLL().CreateOrUpdateRate(param,GetLoginUserId());
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();</script>");
            ClientScript.RegisterStartupScript(this.GetType(), "关闭窗口", "<script>window.close(); </script>");
        }

        protected void save_new_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            new ContractRateBLL().CreateOrUpdateRate(param, GetLoginUserId());
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();</script>");
            Response.Redirect("AddContractRate?contract_id="+contract.id);
        }

        protected ctt_contract_rate GetParam()
        {
            var param = AssembleModel<ctt_contract_rate>();
            param.contract_id = contract.id;
            if (Request.Form["defaultOrContractRate"] == "rbRoleRate")
            {// role_hourly_rate
                param.rate = decimal.Parse(Request.Form["role_hourly_rate"]);
            }
            else if (Request.Form["defaultOrContractRate"] == "rbContractRate")
            {
                param.rate = decimal.Parse(Request.Form["contract_hourly_rate"]);
            }
            else
            {
                param.rate = isAdd ? 0 : conRate.rate;
            }
            if (!isAdd)
            {
                conRate.block_hour_multiplier = param.block_hour_multiplier;
                conRate.role_id = param.role_id;
                conRate.rate = param.rate;
            }
            return param;
        }
    }
}