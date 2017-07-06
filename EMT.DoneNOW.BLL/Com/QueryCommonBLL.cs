using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    public class QueryCommonBLL
    {
        private const int _pageSize = 20;     // 默认查询分页大小

        /// <summary>
        /// 获取一个搜索页面的查询语句
        /// </summary>
        /// <param name="userId">用户id</param>
        /// <param name="para">搜索条件</param>
        /// <param name="orderBy">排序信息（如 id asc）</param>
        /// <param name="page">查询页数</param>
        /// <param name="pageSize">分页每页个数</param>
        /// <returns>查询没有结果时，返回空字符串</returns>
        public string GetQuerySql(long userId, QueryParaDto para, string orderBy, int page = 1, int pageSize = _pageSize)
        {
            if (para == null || para.query_params == null)
                return "";
            d_query_type queryType = GetQueryType(para.query_page_name);
            if (queryType == null)
                return "";
            StringBuilder queryPara = new StringBuilder();
            queryPara.Append("{");

            // 组合查询条件
            d_query_para_dal paraDal = new d_query_para_dal();
            foreach (var p in para.query_params)
            {
                if (p.value == null && p.value2 == null)
                    continue;
                var param = paraDal.FindSignleBySql<d_query_para>($"SELECT * FROM d_query_para WHERE id={p.id} AND query_type_id={queryType.id}");
                if (param == null)
                    continue;
                if (param.query_type_id == (int)DicEnum.QUERY_PARA_TYPE.DATE
                    || param.query_type_id == (int)DicEnum.QUERY_PARA_TYPE.DATETIME
                    || param.query_type_id == (int)DicEnum.QUERY_PARA_TYPE.NUMBER)      // 数值和日期类型
                {
                    if (p.value != null)
                    {
                        queryPara.Append('"').Append(param.col_name).Append(">=").Append(p.value);
                        if (p.value2 != null)
                            queryPara.Append(" and ").Append(param.col_name).Append("<=").Append(p.value2).Append('"');
                        else
                            queryPara.Append('"');
                    }
                    else
                    {
                        queryPara.Append('"').Append(param.col_name).Append("<=").Append(p.value2).Append('"');
                    }
                }
                else
                {
                    if (p.value == null)
                        continue;
                    queryPara.Append('"').Append(param.col_name).Append("\":\"").Append(p.value).Append('"');
                }
                queryPara.Append(",");
            }

            // 移除最后条件末尾的,
            if (queryPara.Length > 1)
                queryPara = queryPara.Remove(queryPara.Length - 1, 1);

            queryPara.Append("}");

            int count = new sys_query_type_user_dal().GetQueryCount(queryType.id, userId, queryPara.ToString());
            if (count == 0)
                return "";
            string sql = new sys_query_type_user_dal().GetQuerySql(queryType.id, userId, queryPara.ToString(), orderBy);

            // 添加分页
            int totalPage = count / pageSize;
            if (count % pageSize != 0)
                ++totalPage;
            if (page <= 0)
                page = 1;
            if (page > totalPage)
                page = totalPage;
            int offset = (page - 1) * pageSize;
            sql = sql + $" LIMIT {offset},{pageSize}";

            return sql;
        }

        /// <summary>
        /// 获取查询条件信息
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="queryPageName">查询页面名称</param>
        /// <returns></returns>
        public List<QueryConditionParaDto> GetQueryPara(long userId, string queryPageName)
        {
            var result = new List<QueryConditionParaDto>();
            d_query_type queryType = GetQueryType(queryPageName);
            if (queryType == null)
                return result;

            sys_query_type_user queryUser = new sys_query_type_user_dal().FindSignleBySql<sys_query_type_user>($"SELECT * FROM sys_query_type_user WHERE user_id={userId} AND query_type_id={queryType.id}");
            if (queryUser == null)  // 用户未修改查询条件列，使用默认值
            {
                queryUser = new sys_query_type_user_dal().FindSignleBySql<sys_query_type_user>($"SELECT * FROM sys_query_type_user WHERE user_id is null AND query_type_id={queryType.id}");
            }

            // 获取查询条件列信息并按顺序填充
            var list = new d_query_para_dal().FindListBySql($"SELECT * FROM d_query_para WHERE id IN ({queryUser.query_para_ids}) AND query_type_id={queryType.id} AND is_visible=1");
            string[] ids = queryUser.query_para_ids.Split(',');
            for (int i = 0; i < ids.Length; ++i)
            {
                long id = long.Parse(ids[i]);
                var col = list.Find(c => c.id == id);
                if (col == null)
                    continue;

                QueryConditionParaDto para = new QueryConditionParaDto
                {
                    id = id,
                    data_type = col.data_type_id,
                    description = col.col_comment,
                };

                // 下拉框和多选下拉框，获取列表值
                if (col.data_type_id == (int)DicEnum.QUERY_PARA_TYPE.DROPDOWN
                    || col.data_type_id == (int)DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN)
                {
                    var dt = new d_query_para_dal().ExecuteDataTable(col.ref_sql);
                    if (dt != null)
                    {
                        para.values = new List<DictionaryEntryDto>();
                        foreach (System.Data.DataRow row in dt.Rows)
                        {
                            para.values.Add(new DictionaryEntryDto(row[0].ToString(), row[1].ToString()));
                        }
                    }
                }

                result.Add(para);
            }

            return result;
        }

        /// <summary>
        /// 获取查询结果列信息
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="queryPageName">查询页面名称</param>
        /// <returns></returns>
        public List<QueryResultParaDto> GetQueryResult(long userId, string queryPageName)
        {
            var result = new List<QueryResultParaDto>();
            d_query_type queryType = GetQueryType(queryPageName);
            if (queryType == null)
                return result;
            sys_query_type_user queryUser = new sys_query_type_user_dal().FindSignleBySql<sys_query_type_user>($"SELECT * FROM sys_query_type_user WHERE user_id={userId} AND query_type_id={queryType.id}");

            if (queryUser == null)  // 用户未修改查询结果列，使用默认值
            {
                queryUser = new sys_query_type_user_dal().FindSignleBySql<sys_query_type_user>($"SELECT * FROM sys_query_type_user WHERE user_id is null AND query_type_id={queryType.id}");
            }

            // 获取显示结果列信息并按顺序填充
            var list = new d_query_result_dal().FindListBySql($"SELECT * FROM d_query_result WHERE id IN ({queryUser.query_result_ids}) AND query_type_id={queryType.id} AND is_visible=1");
            string[] ids = queryUser.query_result_ids.Split(',');
            for(int i=0;i<ids.Length;++i)
            {
                long id = long.Parse(ids[i]);
                var col = list.Find(c => c.id == id);
                if (col == null)
                    continue;
                QueryResultParaDto para = new QueryResultParaDto
                {
                    id = id,
                    name = col.col_comment,
                    length = col.col_length,
                    type = col.display_type_id
                };
                result.Add(para);
            }

            return result;
        }

        /// <summary>
        /// 根据查询页面名称获取查询页面信息
        /// </summary>
        /// <param name="queryPageName"></param>
        /// <returns></returns>
        private d_query_type GetQueryType(string queryPageName)
        {
            if (queryPageName == null)
                return null;
            return new d_query_type_dal().FindSignleBySql<d_query_type>($"SELECT * FROM d_query_type WHERE name='{queryPageName}'");
        }
    }
}
