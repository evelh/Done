using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Project
{
    public partial class CompanyPolicy : BasePage
    {
        protected crm_account thisAccount = null;
        protected sdk_expense thisExpense = null;
        protected d_cost_code_rule thisRule = null;
        protected List<d_cost_code_rule> ruleList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var exp_id = Request.QueryString["exp_id"];
                if (!string.IsNullOrEmpty(exp_id))
                {
                    thisExpense = new sdk_expense_dal().FindNoDeleteById(long.Parse(exp_id));
                    if (thisExpense != null)
                    {
                        thisAccount = new CompanyBLL().GetCompany(thisExpense.account_id);
                    }
                   
                    long? accout_id = null;
                    if (thisAccount != null)
                    {
                        accout_id = thisAccount.id;
                    }
                    if (thisExpense.expense_cost_code_id != null)
                    {
                        var ruleList = new d_cost_code_rule_dal().GetRuleByCodeId((long)thisExpense.expense_cost_code_id);
                        if (ruleList!=null && ruleList.Count > 0)
                        {
                            thisRule = new TaskBLL().GetRule(ruleList, accout_id);
                        }
                    }
                    
                    
                }
                var account_id = Request.QueryString["account_id"];
                if (!string.IsNullOrEmpty(account_id))
                {
                    thisAccount = new CompanyBLL().GetCompany(long.Parse(account_id));
                }
                
                // 费用的cate 种类 在d_cost_code上，
                // 相关规则在d_cost_code_rule上
                // 放个iframe 使用通用查询

                if (thisAccount == null)
                {
                    Response.End();
                }
                else
                {
                    var url = "../Common/SearchBodyFrame?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.ACCOUNT_POLICY + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.ACCOUNT_POLICY+"&con1057="+thisAccount.id+"&con1056="+ LoginUserId;
                    var deaDep = new sys_resource_department_dal().GetDepByRes(LoginUserId);  // 员工的默认部门
                    if (deaDep != null)
                    {
                        url += "&con1058="+deaDep.id;
                    }
                    var cate_id = Request.QueryString["cate_id"];
                    if (!string.IsNullOrEmpty(cate_id))
                    {

                    }
                    AccountPolicy.Src = url;
                }
                
            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}