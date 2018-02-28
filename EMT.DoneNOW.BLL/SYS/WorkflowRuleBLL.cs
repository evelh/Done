using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    public class WorkflowRuleBLL
    {
        /// <summary>
        /// 获取工作流规则的各种定义信息
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<List<QueryConditionParaDto>> GetWorkflowFormByObject(DicEnum.WORKFLOW_OBJECT obj, long userId)
        {
            List<List<QueryConditionParaDto>> parasList = new List<List<QueryConditionParaDto>>();
            QueryCommonBLL queryBll = new QueryCommonBLL();
            var groupList = queryBll.GetQueryGroup((int)obj);
            List<string> types = new List<string> { "事件", "条件", "更新", "其他操作", "通知", "备注" };
            foreach (var tp in types)
            {
                if (groupList.Exists(_ => tp.Equals(_.name)))
                {
                    var grp = groupList.Find(_ => tp.Equals(_.name));
                    parasList.Add(queryBll.GetConditionParaVisiable(userId, grp.id));
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
            string sql = $"select id,data_type_id as data_type,default_value as defaultValue,col_comment as description,ref_sql,ref_url,operator_type_id,(select name from d_general where id=operator_type_id) as operatorName from d_query_para where query_para_group_id={grp.id} and is_visible=1 and operator_type_id is not null";
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
    }
}
