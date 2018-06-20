using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// InvoiceAjax 的摘要说明
    /// </summary>
    public class InvoiceAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "GetAccDedItem":
                    GetAccDedItem(context);
                    break;
                case "GetItemType":
                    GetItemType(context);
                    break;
            }
        }
        /// <summary>
        /// 获取条目详情
        /// </summary>
        void GetAccDedItem(HttpContext context)
        {
            long id = 0;
            if(!string.IsNullOrEmpty(context.Request.QueryString["id"])&&long.TryParse(context.Request.QueryString["id"],out id))
            {
                var accDed = new DAL.crm_account_deduction_dal().FindNoDeleteById(id);
                if (accDed != null)
                {
                    WriteResponseJson(accDed);
                }
            }
        }
        /// <summary>
        /// 获取待审批条目的类型
        /// </summary>
        void GetItemType(HttpContext context)
        {
            long id = 0;
            string itemType = string.Empty;
            string contract_id = "";string task_id = "";
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
            {
                var cost = new DAL.ctt_contract_cost_dal().FindNoDeleteById(id);
                var entry = new DAL.sdk_work_entry_dal().FindNoDeleteById(id);
                var service = new DAL.ctt_contract_service_dal().FindNoDeleteById(id);
                var milestone = new DAL.ctt_contract_milestone_dal().FindNoDeleteById(id);
                var expense = new DAL.sdk_expense_dal().FindNoDeleteById(id);
                var subscription = new DAL.crm_subscription_dal().FindNoDeleteById(id);

                if (cost != null)
                {
                    itemType = "cost"; contract_id = cost.contract_id.ToString(); task_id = cost.task_id.ToString();
                }
                else if (entry != null)
                {
                    itemType = "entry"; contract_id = entry.contract_id.ToString();
                }
                else if (service != null)
                {
                    itemType = "service"; contract_id = service.contract_id.ToString();
                }
                else if (milestone != null)
                {
                    itemType = "milestone"; contract_id = milestone.contract_id.ToString();
                }
                else if (expense != null)
                {
                    itemType = "expense"; 
                }
                else if (subscription != null)
                {
                    itemType = "subscription";
                }

                WriteResponseJson(new {itemType= itemType, contract_id = contract_id, task_id= task_id });

            }
        }
       
    }
}