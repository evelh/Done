using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 工作流规则
    /// </summary>
    public class WorkflowRuleBLL
    {
        sys_workflow_dal dal = new sys_workflow_dal();
        /// <summary>
        /// 获取所有可用的工作流
        /// </summary>
        /// <returns></returns>
        public List<WorkflowRuleDto> GetAllWorkflow()
        {
            var srlz = new Tools.Serialize();
            var workflowList = dal.FindListBySql<WorkflowRuleDto>("select * from sys_workflow where delete_time=0 and is_active=1");
            foreach (var wf in workflowList)
            {
                if (!string.IsNullOrEmpty(wf.event_json))
                    wf.eventJson = srlz.DeserializeJson<List<dynamic>>(wf.event_json);
                if (!string.IsNullOrEmpty(wf.condition_json))
                    wf.conditionJson = srlz.DeserializeJson<List<dynamic>>(wf.condition_json);
                if (!string.IsNullOrEmpty(wf.update_json))
                    wf.updateJson = srlz.DeserializeJson<List<dynamic>>(wf.update_json);
                if (!string.IsNullOrEmpty(wf.email_send_from))
                    wf.emailJson = srlz.DeserializeJson<List<dynamic>>(wf.email_send_from);
            }

            return workflowList;
        }

        /// <summary>
        /// 获取一条工作流规则信息，并反序列化json
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public WorkflowRuleDto GetWorkflowJson(long id)
        {
            var srlz = new Tools.Serialize();
            var wf = dal.FindSignleBySql<WorkflowRuleDto>($"select * from sys_workflow where id={id} and delete_time=0 ");

            if (!string.IsNullOrEmpty(wf.event_json))
                wf.eventJson = srlz.DeserializeJson<List<dynamic>>(wf.event_json);
            if (!string.IsNullOrEmpty(wf.condition_json))
                wf.conditionJson = srlz.DeserializeJson<List<dynamic>>(wf.condition_json);
            if (!string.IsNullOrEmpty(wf.update_json))
                wf.updateJson = srlz.DeserializeJson<List<dynamic>>(wf.update_json);
            if (!string.IsNullOrEmpty(wf.email_send_from))
                wf.emailJson = srlz.DeserializeJson<List<dynamic>>(wf.email_send_from);

            return wf;
        }

        /// <summary>
        /// 获取工作流规则的各种定义信息
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<List<WorkflowConditionParaDto>> GetWorkflowFormByObject(DicEnum.WORKFLOW_OBJECT obj, long userId)
        {
            List<List<WorkflowConditionParaDto>> parasList = new List<List<WorkflowConditionParaDto>>();
            QueryCommonBLL queryBll = new QueryCommonBLL();
            var groupList = queryBll.GetQueryGroup((int)obj);
            List<string> types = new List<string> { "事件", "条件", "更新", "其他操作", "通知", "备注" };
            var queryParaDal = new DAL.d_query_para_dal();
            foreach (var tp in types)
            {
                if (groupList.Exists(_ => tp.Equals(_.name)))
                {
                    var grp = groupList.Find(_ => tp.Equals(_.name));
                    //parasList.Add(queryBll.GetConditionParaVisiable(userId, grp.id));

                    string sql = $"select id,data_type_id as data_type,default_value as defaultValue,col_name,col_comment as description,ref_sql,ref_url,operator_type_id from d_query_para where query_para_group_id={grp.id} and is_visible=1 ";
                    var paras = queryParaDal.FindListBySql<WorkflowConditionParaDto>(sql);
                    foreach (var dto in paras)
                    {
                        if (dto.data_type == (int)DicEnum.QUERY_PARA_TYPE.DROPDOWN
                        || dto.data_type == (int)DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN
                        || dto.data_type == (int)DicEnum.QUERY_PARA_TYPE.DYNAMIC)
                        {
                            var dt = queryParaDal.ExecuteDataTable(dto.ref_sql);
                            if (dt != null)
                            {
                                dto.values = new List<DictionaryEntryDto>();
                                foreach (System.Data.DataRow row in dt.Rows)
                                {
                                    dto.values.Add(new DictionaryEntryDto(row[0].ToString(), row[1].ToString()));
                                }
                            }
                        }
                    }

                    parasList.Add(paras);
                }
                else
                {
                    parasList.Add(null);
                }
            }
            return parasList;
        }
        
        /// <summary>
        /// 获取工作流规则的条件定义
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<List<WorkflowConditionParaDto>> GetWorkflowFormConditionByObject(DicEnum.WORKFLOW_OBJECT obj, long userId)
        {
            List<List<WorkflowConditionParaDto>> parasList = new List<List<WorkflowConditionParaDto>>();
            QueryCommonBLL queryBll = new QueryCommonBLL();
            var groupList = queryBll.GetQueryGroup((int)obj);
            var grp = groupList.Find(_ => "条件".Equals(_.name));
            string sql = $"select id,data_type_id as data_type,default_value as defaultValue,col_name,col_comment as description,ref_sql,ref_url,operator_type_id,(select name from d_general where id=operator_type_id) as operatorName from d_query_para where query_para_group_id={grp.id} and is_visible=1 and operator_type_id is not null";
            var paras = new DAL.d_query_para_dal().FindListBySql<WorkflowConditionParaDto>(sql);

            sql = $"select distinct(col_comment) from d_query_para where query_para_group_id={grp.id} and is_visible=1 and operator_type_id is not null";
            var cdts = new DAL.d_query_para_dal().FindListBySql<string>(sql);
            foreach (var cdt in cdts)
            {
                var dtos = (from prm in paras where cdt.Equals(prm.description) select prm).ToList();
                foreach (var dto in dtos)
                {
                    if (dto.data_type == (int)DicEnum.QUERY_PARA_TYPE.DROPDOWN
                    || dto.data_type == (int)DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN
                    || dto.data_type == (int)DicEnum.QUERY_PARA_TYPE.DYNAMIC)
                    {
                        var dt = new DAL.d_query_para_dal().ExecuteDataTable(dto.ref_sql);
                        if (dt != null)
                        {
                            dto.values = new List<DictionaryEntryDto>();
                            foreach (System.Data.DataRow row in dt.Rows)
                            {
                                dto.values.Add(new DictionaryEntryDto(row[0].ToString(), row[1].ToString()));
                            }
                        }
                    }
                }
                parasList.Add(dtos);
            }

            return parasList;
        }

        /// <summary>
        /// 新增工作流规则
        /// </summary>
        /// <param name="workflow"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddWorkflow(sys_workflow workflow, long userId)
        {
            workflow.id = dal.GetNextIdCom();
            workflow.create_user_id = userId;
            workflow.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            workflow.update_time = workflow.create_time;
            workflow.update_user_id = userId;
            dal.Insert(workflow);
            OperLogBLL.OperLogAdd<sys_workflow>(workflow, workflow.id, userId, DicEnum.OPER_LOG_OBJ_CATE.WORKFLOW_RULE, "新增工作流规则");
            return true;
        }

        /// <summary>
        /// 编辑工作流规则
        /// </summary>
        /// <param name="workflow"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditWorkflow(sys_workflow workflow, long userId)
        {
            sys_workflow wf = dal.FindById(workflow.id);
            sys_workflow wfOld = dal.FindById(workflow.id);

            if (wf.workflow_object_id != workflow.workflow_object_id)   // 编辑不能修改对象类型
                return false;

            wf.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            wf.update_user_id = userId;
            wf.name = workflow.name;
            wf.description = workflow.description;
            wf.is_active = workflow.is_active;
            wf.use_default_tmpl = workflow.use_default_tmpl;
            wf.notify_tmpl_id = workflow.notify_tmpl_id;
            wf.notify_subject = workflow.notify_subject;
            wf.event_json = workflow.event_json;
            wf.condition_json = workflow.condition_json;
            wf.update_json = workflow.update_json;

            string desc = OperLogBLL.CompareValue<sys_workflow>(wfOld, wf);
            if (!string.IsNullOrEmpty(desc))
            {
                dal.Update(wf);
                OperLogBLL.OperLogUpdate(desc, wf.id, userId, DicEnum.OPER_LOG_OBJ_CATE.WORKFLOW_RULE, "编辑工作流规则");
            }

            return true;
        }

        /// <summary>
        /// 删除工作流规则
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteWorkflow(long id, long userId)
        {
            sys_workflow wf = dal.FindById(id);
            wf.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            wf.delete_user_id = userId;
            dal.Update(wf);
            OperLogBLL.OperLogDelete<sys_workflow>(wf, wf.id, userId, DicEnum.OPER_LOG_OBJ_CATE.WORKFLOW_RULE, "删除工作流规则");
            return true;
        }

        /// <summary>
        /// 激活工作流规则
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool SetWorkflowActive(long id, long userId)
        {
            sys_workflow wf = dal.FindById(id);
            if (wf.is_active == 1)
                return true;

            sys_workflow wfOld = dal.FindById(id);
            wf.is_active = 1;
            wf.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            wf.update_user_id = userId;
            dal.Update(wf);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<sys_workflow>(wfOld, wf), id, userId, DicEnum.OPER_LOG_OBJ_CATE.WORKFLOW_RULE, "激活工作流规则");

            return true;
        }

        /// <summary>
        /// 停用工作流规则
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool SetWorkflowInactive(long id, long userId)
        {
            sys_workflow wf = dal.FindById(id);
            if (wf.is_active == 0)
                return true;

            sys_workflow wfOld = dal.FindById(id);
            wf.is_active = 0;
            wf.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            wf.update_user_id = userId;
            dal.Update(wf);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<sys_workflow>(wfOld, wf), id, userId, DicEnum.OPER_LOG_OBJ_CATE.WORKFLOW_RULE, "停用工作流规则");

            return true;
        }
    }
}
