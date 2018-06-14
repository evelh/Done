using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;


namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class CodeRuleManage : BasePage
    {
        protected bool isAdd = true;
        protected d_cost_code code;
        protected d_cost_code_rule codeRule;
        protected List<sys_department> depList = new DAL.sys_department_dal().GetDepartment();
        protected List<d_general> policyList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.EXPENSE_OVERDRAFT_POLICY);
        protected CostCodeBLL codeBll = new CostCodeBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                codeRule = codeBll.GetCodeRuleById(id);
            long codeId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["codeId"]) && long.TryParse(Request.QueryString["codeId"], out codeId))
                code = codeBll.GetCodeById(codeId);
            if (codeRule != null)
            {
                isAdd = false;
                code = codeBll.GetCodeById(codeRule.cost_code_id);
            }
            if (code == null)
            {
                Response.Write("<script>alert('未获取到物料代码信息！');window.close();</script>");
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var pageRule = AssembleModel<d_cost_code_rule>();
            pageRule.cost_code_id = code.id;
            if (!isAdd)
            {
                codeRule.department_id = pageRule.department_id;
                codeRule.resource_id = pageRule.resource_id;
                codeRule.account_ids = pageRule.account_ids;
                codeRule.overdraft_policy_id = pageRule.overdraft_policy_id;
                codeRule.max = pageRule.max;
            }
            bool result = false;
            if (isAdd)
                result = codeBll.AddCodeRule(pageRule,LoginUserId);
            else
                result = codeBll.EditCodeRule(codeRule, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");
        }
    }
}