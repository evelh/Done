using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// WorkflowRuleAjax 的摘要说明
    /// </summary>
    public class WorkflowRuleAjax : BaseAjax
    {
        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "getRuleFormInfo":
                    GetObjectRuleInfo(context);
                    break;
                case "getRuleFormConditonInfo":
                    GetObjectRuleConditionInfo(context);
                    break;
                default:
                    break;
            }
        }

        /// <summary>
        /// 获取工作流表单的定义信息
        /// </summary>
        /// <param name="context"></param>
        private void GetObjectRuleInfo(HttpContext context)
        {
            int objId = int.Parse(context.Request.QueryString["objId"]);
            var forminfo = new WorkflowRuleBLL().GetWorkflowFormByObject((DTO.DicEnum.WORKFLOW_OBJECT)objId, LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(forminfo));
        }

        /// <summary>
        /// 获取工作流表单的条件定义信息
        /// </summary>
        /// <param name="context"></param>
        private void GetObjectRuleConditionInfo(HttpContext context)
        {
            int objId = int.Parse(context.Request.QueryString["objId"]);
            var forminfo = new WorkflowRuleBLL().GetWorkflowFormConditionByObject((DTO.DicEnum.WORKFLOW_OBJECT)objId, LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(forminfo));
        }
    }
}