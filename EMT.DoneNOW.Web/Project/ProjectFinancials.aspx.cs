using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using System.Data;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectFinancials : BasePage
    {
        protected pro_project project;
        protected List<d_general> proStatusList = new GeneralBLL().GetGeneralByTable((int)GeneralTableEnum.PROJECT_STATUS);
        protected crm_account account;
        protected List<d_general> projectTypeList = new GeneralBLL().GetGeneralByTable((int)GeneralTableEnum.PROJECT_TYPE);
        protected ProjectBLL proBll = new ProjectBLL();
        protected DataTable expPro;    // 支出
        protected DataTable revPro;    // 收入
        protected DataTable profitPro; // 利润
        protected DataTable yuguPro;   // 预估
        protected List<sdk_task> taskLsit;
        protected DataTable taskTable;  // 任务
        protected DataTable chargeTable;  // 项目成本
        protected DataTable expenseTable; // 项目费用
        protected DataTable milepostTable; // 里程碑
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                project = proBll.GetPoject(id);

            if (project == null)
            {
                Response.Write("<script>alert('为获取到相关项目信息，请刷新页面后重试！');</script>"); return;
            }
            account = new CompanyBLL().GetCompany(project.account_id);
            // taskLsit = new DAL.sdk_task_dal().GetAllProTask(project.id);

            expPro = proBll.GetTableBySql(@"select hours_worked,labor_cost,cost_cost_billable+cost_cost_nonbillable,expense_cost_billable+expense_cost_nonbillable,
labor_cost+cost_cost_billable+cost_cost_nonbillable+expense_cost_billable+expense_cost_nonbillable
from v_project_complete_profit where project_id = "+ project.id.ToString());
            revPro = proBll.GetTableBySql(@"select hours_billed,labor_dollars,cost_dollars,expense_dollars,milestone_dollars,
labor_dollars+cost_dollars+expense_dollars+milestone_dollars
from v_project_complete_profit
 where project_id = " + project.id.ToString());
            profitPro = proBll.GetTableBySql(@"select labor_dollars-labor_cost,cost_dollars-cost_cost_billable-cost_cost_nonbillable,expense_dollars-expense_cost_billable-expense_cost_nonbillable,milestone_dollars,
labor_dollars+cost_dollars+expense_dollars+milestone_dollars -(labor_cost+cost_cost_billable+cost_cost_nonbillable+expense_cost_billable+expense_cost_nonbillable)
from v_project_complete_profit
 where project_id = " + project.id.ToString());
            yuguPro = proBll.GetTableBySql(@"select Labor_Revenue,Cost_Revenue,Labor_Revenue+Cost_Revenue
from v_project_complete_profit
 where project_id = " + project.id.ToString());
            taskTable = proBll.GetTableBySql($@"select if(sid is null ,'项目汇总',a.title) as 标题,if(sid is null ,'',a.status )as 状态,round(a.estimated_hours,2) as 预估时间,round(a.worked_hours,2) as 已工作时间,round(a.Billed_hours,2) as 已计费时间
,round(a.labor_dollars,2) as 工时收入,round(a.labor_cost,2) as 工时成本
from v_task_all a where 1=1    and a.project_id in({project.id.ToString()}) order by a.sort_order");
            chargeTable = proBll.GetTableBySql($@"select if(id is null,null,date_purchased),if(id is null,null,name), if(id is null,null,cost_code_name),if(id is null,null,purchase_order_no),if(id is null,'汇总：',Invoice_no),
round(cost,2),round(billable_amount,2),round(revenue,2)
from(
select id,date_purchased,name, (select name from d_cost_code where id=t.cost_code_id)	cost_code_name,purchase_order_no,
Invoice_no,sum(Quantity*Unit_Cost)cost, sum(if(is_billable=1,ifnull( extended_price,Quantity*Unit_Price),0 ))billable_amount,
sum(if(is_billable=1 and bill_Status=1 ,ifnull( extended_price,Quantity*Unit_Price),0 ))revenue
from ctt_contract_cost t  where project_id={project.id.ToString()} and delete_time=0
GROUP BY id with ROLLUP)t
");
            expenseTable = proBll.GetTableBySql($@"select if(id is null,null,Add_Date),if(id is null,null,resource_name), if(id is null,null,type_name),if(id is null,null,description),if(id is null,null,has_Receipt),if(id is null,'汇总：',is_billable),
round(amount,2),round(revenue,2)
from(
select id,Add_Date,(select name from sys_resource where id=t.create_user_id)resource_name, (select name from d_general where id=t.type_id)	type_name,description,
if(has_Receipt=1,'√','')has_Receipt,if(is_billable=1,'√','')is_billable,sum(Amount)Amount,sum( if(is_billable=1 and approve_and_post_date is not null ,amount,0 )  )revenue
from sdk_expense t  where project_id={project.id.ToString()} and delete_time=0
GROUP BY id with ROLLUP)t

");
            milepostTable = proBll.GetTableBySql($@"select if(id is null,null,due_date),if(id is null,'汇总：',name),round(dollars,2),round(revenue,2)
from(
select t.id,t.due_date,t.name,sum(dollars)dollars, sum(if(t.status_id= 1267,dollars,0 ))revenue
from ctt_contract_milestone t ,sdk_task a,sdk_task_milestone b 
where t.delete_time=0 and a.delete_time=0 and b.delete_time=0 and t.id=b.contract_milestone_id and b.task_id=a.id and a.project_id={project.id.ToString()}  
GROUP BY id with ROLLUP)t
");

        }
    }
}