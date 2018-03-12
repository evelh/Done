using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using System.Text;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class WorkflowRule : BasePage
    {
        protected WorkflowRuleDto wfEdit;
        protected List<List<WorkflowConditionParaDto>> conditionParams;
        private WorkflowRuleBLL bll = new WorkflowRuleBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    wfEdit = bll.GetWorkflowJson(long.Parse(Request.QueryString["id"]));
                    conditionParams = bll.GetWorkflowFormByObject((DicEnum.WORKFLOW_OBJECT)wfEdit.workflow_object_id, LoginUserId);
                }
            }
            else
            {
                if (string.IsNullOrEmpty(Request.Form["workflow_object_id"]))
                {
                    Response.Write("<script>alert('请选择对象！'); </script>");
                    return;
                }
                int workflowObj = int.Parse(Request.Form["workflow_object_id"]);
                var forminfo = bll.GetWorkflowFormByObject((DicEnum.WORKFLOW_OBJECT)workflowObj, LoginUserId);

                sys_workflow workflow = new sys_workflow();
                workflow.workflow_object_id = workflowObj;
                workflow.name = Request.Form["name"];
                workflow.description = Request.Form["description"];
                if (string.IsNullOrEmpty(Request.Form["active"]) || (!Request.Form["active"].Equals("on")))
                    workflow.is_active = 0;
                else
                    workflow.is_active = 1;
                if (string.IsNullOrEmpty(Request.Form["useDefTmpl"]) || (!Request.Form["useDefTmpl"].Equals("on")))
                    workflow.use_default_tmpl = 0;
                else
                    workflow.use_default_tmpl = 1;
                if (!string.IsNullOrEmpty(Request.Form["notifyTemp"]))
                    workflow.notify_tmpl_id = int.Parse(Request.Form["notifyTemp"]);
                workflow.notify_subject = Request.Form["notify_subject"];

                workflow.event_json = GetEventJson((DicEnum.WORKFLOW_OBJECT)workflowObj, forminfo[0]);
                workflow.condition_json = GetConditionJson((DicEnum.WORKFLOW_OBJECT)workflowObj, forminfo[1]);
                workflow.update_json = GetUpdateJson((DicEnum.WORKFLOW_OBJECT)workflowObj, forminfo[2]);

                if (string.IsNullOrEmpty(Request.QueryString["id"]))
                    bll.AddWorkflow(workflow, LoginUserId);

                if (Request.Form["action"] == "SaveNew")
                {
                    Response.Write("<script>alert('添加工作流规则成功！');self.opener.location.reload();window.location.href='WorkflowRule.aspx'</script>");
                }
                else
                {
                    Response.Write("<script>alert('添加工作流规则成功！');window.close();self.opener.location.reload();</script>");
                }
            }
        }

        /// <summary>
        /// 生成事件的json字符串
        /// </summary>
        /// <param name="workflowObj"></param>
        /// <param name="paras"></param>
        /// <returns></returns>
        private string GetEventJson(DicEnum.WORKFLOW_OBJECT workflowObj, List<WorkflowConditionParaDto> paras)
        {
            StringBuilder json = new StringBuilder("[");
            var formData = Request.Form;
            foreach (var para in paras)
            {
                if (string.IsNullOrEmpty(formData["ck" + para.id]) || (!formData["ck" + para.id].Equals("on")))
                    continue;   // 未选择此事件

                if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.DROPDOWN)
                {
                    if (string.IsNullOrEmpty(formData["slt" + para.id]))    // 未选择下拉框值
                        continue;
                    json.Append("{\"event\":\"" + para.col_name + "\",\"value\":\"" + formData["slt" + para.id] + "\"},");
                }
                else if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.DYNAMIC)
                {
                    if (string.IsNullOrEmpty(formData["slt" + para.id]) || string.IsNullOrEmpty(formData["ipt" + para.id]))    // 未选择下拉框值或未输入文本框值
                        continue;
                    json.Append("{\"event\":\"" + para.col_name + "\",\"value\":\"" + formData["ipt" + para.id] + "\",\"unit\":\"" + formData["slt" + para.id] + "\"},");
                }
                else if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.BOOLEAN)
                {
                    json.Append("{\"event\":\"" + para.col_name + "\",\"value\":\"1\"},");
                }
            }

            if (json.ToString().Equals("["))
                return null;

            json.Remove(json.Length - 1, 1);
            json.Append("]");
            return json.ToString();
        }

        /// <summary>
        /// 生成条件的json字符串
        /// </summary>
        /// <param name="workflowObj"></param>
        /// <param name="paras"></param>
        /// <returns></returns>
        private string GetConditionJson(DicEnum.WORKFLOW_OBJECT workflowObj, List<WorkflowConditionParaDto> paras)
        {
            StringBuilder json = new StringBuilder("[");
            var form = Request.Form;

            for (int i = 0; i < 5; i++)
            {
                if (string.IsNullOrEmpty(form["def1pro" + i]) || string.IsNullOrEmpty(form["def1oper" + i]))
                    continue;

                var para = paras.Find(_ => _.description.Equals(form["def1pro" + i]) && _.operator_type_id.Equals(form["def1oper" + i]));
                if (para == null)
                    continue;

                // 根据不同的条件定义类型获取不同类型的值
                if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.DROPDOWN)
                {
                    json.Append("{\"col_name\":\"" + para.col_name + "\",\"operator\":\"" 
                        + para.operator_type_id + "\",\"value\":\"" + form["def1val" + i + "0"] + "\"},");
                }
                else if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN)
                {
                    json.Append("{\"col_name\":\"" + para.col_name + "\",\"operator\":\""
                        + para.operator_type_id + "\",\"value\":\"" + form["def1val" + i + "2"] + "\"},");
                }
                else if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.SINGLE_LINE || para.data_type == (int)DicEnum.QUERY_PARA_TYPE.NUMBER)
                {
                    json.Append("{\"col_name\":\"" + para.col_name + "\",\"operator\":\""
                        + para.operator_type_id + "\",\"value\":\"" + form["def1val" + i + "1"] + "\"},");
                }
                else if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.CHANGED)
                {
                    json.Append("{\"col_name\":\"" + para.col_name + "\",\"operator\":\""
                        + para.operator_type_id + "\",\"value\":\"1\"},");
                }
            }

            if (json.ToString().Equals("["))
                return null;

            json.Remove(json.Length - 1, 1);
            json.Append("]");
            return json.ToString();
        }

        private string GetUpdateJson(DicEnum.WORKFLOW_OBJECT workflowObj, List<WorkflowConditionParaDto> paras)
        {
            StringBuilder json = new StringBuilder("[");
            var form = Request.Form;

            for (int i = 0; i < 5; i++)
            {
                if (string.IsNullOrEmpty(form["def2pro" + i]))
                    continue;

                var para = paras.Find(_ => form["def2pro" + i].Equals(_.id.ToString()));
                if (para == null)
                    continue;

                // 根据不同的条件定义类型获取不同类型的值
                if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.DROPDOWN)
                {
                    json.Append("{\"col_name\":\"" + para.col_name + "\",\"value\":\"" 
                        + form["def2val" + i + "0"] + "\"},");
                }
                else if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.DYNAMIC)
                {
                    json.Append("{\"col_name\":\"" + para.col_name + "\",\"value\":\"" 
                        + form["def2val" + i + "1"] + "\",\"refer\":\"" + form["def2val" + i + "0"] + "\"},");
                }
            }

            if (json.ToString().Equals("["))
                return null;

            json.Remove(json.Length - 1, 1);
            json.Append("]");
            return json.ToString();
        }


    }
}