using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using System.Data;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 通用查询功能
    /// </summary>
    public class QueryCommonBLL
    {
        private const int _pageSize = 20;     // 默认查询分页大小
        private const int _sqlExpireMins = 1 * 60;   // sql查询语句缓存时间

        /// <summary>
        /// 根据查询条件查询数据
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="para"></param>
        /// <returns></returns>
        public QueryResultDto GetQueryResult(long userId, QueryParaDto para)
        {
            QueryResultDto result = new QueryResultDto();
            int count = 0;

            string sql = GetQuerySql(userId, para, out count);      // 根据查询条件获取查询sql语句
            result.count = count;
            result.query_page_name = para.query_page_name;
            if (count == 0)     // 查询记录总数为0
                return result;

            // 计算分页信息
            if (para.page_size == 0)
                para.page_size = _pageSize;
            int totalPage = count / para.page_size;
            if (count % para.page_size != 0)
                ++totalPage;
            if (para.page <= 0)
                para.page = 1;
            if (para.page > totalPage)
                para.page = totalPage;
            int offset = (para.page - 1) * para.page_size;

            // 缓存查询sql语句
            CacheQuerySqlDto sqlCache = new CacheQuerySqlDto
            {
                query_page_name = para.query_page_name,
                count = count,
                page_size = para.page_size,
                page_count = totalPage,
                query_sql = sql
            };
            string queryId = userId + new Random().Next(1000, 9999).ToString();
            CachedInfoBLL.SetQuerySql(queryId, sqlCache, _sqlExpireMins);

            // 获取查询结果
            sql = sql + $" LIMIT {offset},{para.page_size}";
            var table = new sys_query_type_user_dal().ExecuteDataTable(sql);
            List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();
            foreach (DataRow row in table.Rows)
            {
                Dictionary<string, object> column = new Dictionary<string, object>();
                foreach (DataColumn col in table.Columns)
                {
                    column.Add(col.ColumnName, row[col.ColumnName]);
                }
                list.Add(column);
            }
            
            result.order_by = para.order_by;
            result.page = para.page;
            result.page_count = totalPage;
            result.page_size = para.page_size;
            result.query_id = queryId;
            result.result = list;

            return result;
        }

        /// <summary>
        /// 根据缓存的查询条件查询数据
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="queryId">缓存的查询索引</param>
        /// <param name="page"></param>
        /// <param name="orderBy"></param>
        /// <param name="pagesize"></param>
        /// <returns></returns>
        public QueryResultDto GetQueryResult(long userId, string queryId, int page, string orderBy, int pagesize=0)
        {
            // 获取缓存的查询信息
            CacheQuerySqlDto cacheSql = CachedInfoBLL.GetQuerySql(queryId);
            if (cacheSql == null)   // 参数错误或者缓存过期
                return null;
            if (cacheSql.count == 0)    // 缓存的查询结果记录数为0
                return new QueryResultDto { count = 0, query_page_name = cacheSql.query_page_name };

            QueryResultDto result = new QueryResultDto();
            // 获取查询语句
            string sql = cacheSql.query_sql;
            if (!string.IsNullOrEmpty(orderBy))     // 修改 order by
            {
                string orderBySqlString = " order by ";
                int index = sql.IndexOf(orderBySqlString);
                sql = sql.Substring(0, index + orderBySqlString.Length);
                sql += orderBy;
            }

            // 计算分页信息
            if (page < 1)
                page = 1;
            if (page > cacheSql.page_count)
                page = cacheSql.page_count;
            int offset;
            if (pagesize <= 0)
                pagesize = cacheSql.page_size;
            offset = (page - 1) * pagesize;

            sql += $" LIMIT {offset},{pagesize}";

            // 获取查询结果
            List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();
            try
            {
                var table = new sys_query_type_user_dal().ExecuteDataTable(sql);
                foreach (DataRow row in table.Rows)
                {
                    Dictionary<string, object> column = new Dictionary<string, object>();
                    foreach (DataColumn col in table.Columns)
                    {
                        column.Add(col.ColumnName, row[col.ColumnName]);
                    }
                    list.Add(column);
                }
            }
            catch
            {
                result.count = 0;
                result.query_page_name = cacheSql.query_page_name;
                return result;
            }

            cacheSql.query_sql = sql;
            CachedInfoBLL.SetQuerySql(queryId, cacheSql, _sqlExpireMins);   // 更新查询sql缓存
            
            result.count = cacheSql.count;
            result.order_by = orderBy;
            result.page = page;
            result.page_count = cacheSql.page_count;
            result.page_size = pagesize;
            result.query_id = queryId;
            result.result = list;

            return result;
        }

        /// <summary>
        /// 获取一个搜索页面的查询语句
        /// </summary>
        /// <param name="userId">用户id</param>
        /// <param name="para">搜索条件</param>
        /// <param name="count">查询结果总数</param>
        /// <returns>查询没有结果时，返回空字符串</returns>
        private string GetQuerySql(long userId, QueryParaDto para, out int count)
        {
            count = 0;
            string sqlPara = GetQueryPara(userId, para);
            if (sqlPara == "")
                return "";
            d_query_type queryType = GetQueryType(para.query_page_name);

            count = new sys_query_type_user_dal().GetQueryCount(queryType.id, userId, sqlPara);
            if (count == 0)
                return "";
            string sql = new sys_query_type_user_dal().GetQuerySql(queryType.id, userId, sqlPara, para.order_by);

            return sql;
        }

        /// <summary>
        /// 生成查询参数sql字符串
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="para"></param>
        /// <returns></returns>
        private string GetQueryPara(long userId, QueryParaDto para)
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

            return queryPara.ToString();
        }

        /// <summary>
        /// 获取查询条件信息
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="queryPageName">查询页面名称</param>
        /// <returns></returns>
        public List<QueryConditionParaDto> GetQueryConditionPara(long userId, string queryPageName)
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
        public List<QueryResultParaDto> GetQueryResultPara(long userId, string queryPageName)
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

        /*
        public List<DictionaryEntryDto> GetQueryResultParaSelect(long userId, string queryPageName)
        {
            List<DictionaryEntryDto> result = new List<DictionaryEntryDto>();
            d_query_type queryType = GetQueryType(queryPageName);

        }*/

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
