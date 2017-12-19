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
        private const int _sqlExpireMins = 1 * 60;   // sql查询语句缓存时间(分钟)


        #region 初始化获取页面信息
        /// <summary>
        /// 根据查询页面获取该查询页面内所有查询分组信息
        /// </summary>
        /// <param name="cateId"></param>
        /// <returns></returns>
        public List<d_query_para_group> GetQueryGroup(int cateId)
        {
            return new d_query_para_group_dal().GetListByCate(cateId);
        }
        #endregion

        #region 获取查询条件列查询结果列信息
        /// <summary>
        /// 获取全部查询条件信息
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupId"></param>
        /// <returns></returns>
        public List<QueryConditionParaDto> GetConditionParaAll(long userId, long groupId)
        {
            return GetConditionParaType(userId, groupId, 0);
        }

        /// <summary>
        /// 获取可见的查询条件信息
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupId"></param>
        /// <returns></returns>
        public List<QueryConditionParaDto> GetConditionParaVisiable(long userId, long groupId)
        {
            return GetConditionParaType(userId, groupId, 1);
        }

        /// <summary>
        /// 获取查询条件信息
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupId">查询条件组id</param>
        /// <param name="visiable">查询条件范围（1:可见的查询条件，0:全部）</param>
        /// <returns></returns>
        private List<QueryConditionParaDto> GetConditionParaType(long userId, long groupId, int visiable)
        {
            var result = new List<QueryConditionParaDto>();

            sys_query_type_user queryUser = new sys_query_type_user_dal().GetQueryTypeUser(userId, groupId);
            if (queryUser == null)  // 用户未修改查询结果列，使用默认值
            {
                queryUser = new sys_query_type_user_dal().GetQueryTypeUser(0, groupId);
            }
            if (queryUser == null)
                return result;

            if (string.IsNullOrEmpty(queryUser.query_para_ids))
                return result;

            // 获取查询条件列信息并按顺序填充
            List<d_query_para> list;
            if (visiable == 1)
                list = new d_query_para_dal().FindListBySql($"SELECT * FROM d_query_para WHERE id IN ({queryUser.query_para_ids}) AND query_para_group_id={groupId} AND is_visible=1");
            else
                list = new d_query_para_dal().FindListBySql($"SELECT * FROM d_query_para WHERE id IN ({queryUser.query_para_ids}) AND query_para_group_id={groupId}");
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
                    defaultValue = col.default_value,
                    description = col.col_comment,
                    ref_url = col.ref_url,
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
        /// 获取用户已选择的查询结果列信息
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupId">查询条件组id</param>
        /// <returns></returns>
        public List<QueryResultParaDto> GetResultParaSelect(long userId, long groupId)
        {
            var result = new List<QueryResultParaDto>();
            
            sys_query_type_user queryUser = new sys_query_type_user_dal().GetQueryTypeUser(userId, groupId);
            if (queryUser == null)  // 用户未修改查询结果列，使用默认值
            {
                queryUser = new sys_query_type_user_dal().GetQueryTypeUser(0, groupId);
            }
            if (queryUser == null)
                return result;

            // 获取显示结果列信息并按顺序填充
            var list = new d_query_result_dal().FindListBySql($"SELECT * FROM d_query_result WHERE id IN ({queryUser.query_result_ids}) AND query_type_id={queryUser.query_type_id}");
            string[] ids = queryUser.query_result_ids.Split(',');
            for (int i = 0; i < ids.Length; ++i)
            {
                long id = long.Parse(ids[i]);
                var col = list.Find(c => c.id == id);
                if (col == null)
                    continue;

                AuthUrlDto url = null;
                if (!string.IsNullOrEmpty(col.link_url))
                    url = GetAuthUrl(col.link_url);
                QueryResultParaDto para = new QueryResultParaDto
                {
                    id = id,
                    name = col.col_comment,
                    length = col.col_length,
                    type = col.display_type_id,
                    visible = col.is_visible,
                    url = url
                };
                result.Add(para);
            }

            return result;
        }

        private AuthUrlDto GetAuthUrl(string url)
        {
            AuthUrlDto dto = new AuthUrlDto();
            int index = url.IndexOf('?');
            if (index == -1)
            {
                dto.url = url;
                dto.parms = null;
            }
            else
            {
                dto.url = url.Substring(0, index);
                dto.parms = new List<UrlPara>();
                var prms = url.Substring(index + 1).Split('&');
                for (int i = 0; i <= prms.Length - 1; ++i)
                {
                    UrlPara prm = new UrlPara();
                    prm.value = null;
                    int valueIndex = prms[i].IndexOf('=');
                    if (valueIndex == -1)
                        prm.name = prms[i];
                    else
                    {
                        prm.name = prms[i].Substring(0, valueIndex);
                        if (valueIndex < prms[i].Length - 1)
                            prm.value = prms[i].Substring(valueIndex + 1);
                    }
                    dto.parms.Add(prm);
                }
            }

            return dto;
        }
        #endregion

        #region 组合查询语句、查询结果
        /// <summary>
        /// 根据查询条件查询数据
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="para"></param>
        /// <returns></returns>
        public QueryResultDto GetResult(long userId, QueryParaDto para)
        {
            QueryResultDto result = new QueryResultDto();
            int count = 0;

            string sql = GetSql(userId, para, out count);      // 根据查询条件获取查询sql语句
            result.count = count;
            result.query_type_id = para.query_type_id;
            result.para_group_id = para.para_group_id;
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
            /*
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
            */

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
            //result.query_id = queryId;
            result.query_id = "";
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
        public QueryResultDto GetResult(long userId, string queryId, int page, string orderBy, int pagesize = 0)
        {
            return null;
            /*
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
            */
        }

        /// <summary>
        /// 获取一个搜索页面的查询语句
        /// </summary>
        /// <param name="userId">用户id</param>
        /// <param name="para">搜索条件</param>
        /// <param name="count">查询结果总数</param>
        /// <returns>查询没有结果时，返回空字符串</returns>
        private string GetSql(long userId, QueryParaDto para, out int count)
        {
            count = 0;
            string sqlPara = GetPara(userId, para);
            if (sqlPara == "")
                return "";

            count = new sys_query_type_user_dal().GetQueryCount(para.para_group_id, para.query_type_id, userId, sqlPara);
            if (count == 0)
                return "";
            string sql = new sys_query_type_user_dal().GetQuerySql(para.para_group_id, para.query_type_id, userId, sqlPara, para.order_by);

            return sql;
        }

        /// <summary>
        /// 生成查询参数sql字符串
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="para"></param>
        /// <returns></returns>
        private string GetPara(long userId, QueryParaDto para)
        {
            if (para == null || para.query_params == null)
                return "";
            StringBuilder queryPara = new StringBuilder();
            queryPara.Append("'{");

            // 组合查询条件
            d_query_para_dal paraDal = new d_query_para_dal();
            foreach (var p in para.query_params)
            {
                if (p.value == null && p.value2 == null)
                    continue;
                var param = paraDal.FindSignleBySql<d_query_para>($"SELECT * FROM d_query_para WHERE id={p.id} AND query_type_id={para.query_type_id}");
                if (param == null)
                    continue;
                if (param.data_type_id == (int)DicEnum.QUERY_PARA_TYPE.DATE
                    || param.data_type_id == (int)DicEnum.QUERY_PARA_TYPE.DATETIME
                    || param.data_type_id == (int)DicEnum.QUERY_PARA_TYPE.NUMBER
                    || param.data_type_id == (int)DicEnum.QUERY_PARA_TYPE.TIMESPAN)      // 数值和日期类型
                {
                    if (param.data_type_id == (int)DicEnum.QUERY_PARA_TYPE.TIMESPAN)
                    {
                        DateTime t1 = DateTime.MinValue, t2 = DateTime.MinValue;
                        if ((p.value != null && !DateTime.TryParse(p.value, out t1))
                            || (p.value2 != null && !DateTime.TryParse(p.value2, out t2)))
                            continue;
                        if (p.value != null)
                            p.value = Tools.Date.DateHelper.ToUniversalTimeStamp(t1).ToString();
                        if (p.value2 != null)
                            p.value2 = Tools.Date.DateHelper.ToUniversalTimeStamp(t2).ToString();
                    }
                    queryPara.Append('"').Append(param.col_name).Append("\":");
                    if (p.value != null)
                    {
                        queryPara.Append('"').Append(param.col_name).Append(" >= '").Append(p.value).Append("'");
                        if (p.value2 != null)
                            queryPara.Append(" and ").Append(param.col_name).Append(" <= '").Append(p.value2).Append("'\"");
                        else
                            queryPara.Append('"');
                    }
                    else
                    {
                        queryPara.Append('"').Append(param.col_name).Append(" <= '").Append(p.value2).Append("'\"");
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
            if (queryPara.Length > 2)
                queryPara = queryPara.Remove(queryPara.Length - 1, 1);

            queryPara.Append("}'");

            return queryPara.ToString();
        }
        #endregion

        #region 修改查询结果列
        /// <summary>
        /// 获取用户已选择的结果显示列 （查询结果选择器用）
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupId">查询条件组id</param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetResultSelect(long userId, long groupId)
        {
            var list = GetResultParaSelect(userId, groupId);
            List<DictionaryEntryDto> result = new List<DictionaryEntryDto>();
            foreach (var qr in list)
            {
                if (qr.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                    || qr.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                    || qr.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                    continue;
                result.Add(new DictionaryEntryDto(qr.id.ToString(), qr.name));
            }

            return result;
        }

        /// <summary>
        /// 获取一个查询页面可选的所有结果显示列 （查询结果选择器用）
        /// </summary>
        /// <param name="queryTypeId"></param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetResultAll(long queryTypeId)
        {
            List<DictionaryEntryDto> result = new List<DictionaryEntryDto>();
            var queryResultList = GetResultParaAll(queryTypeId);
            foreach (var qr in queryResultList)
            {
                if (qr.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                    || qr.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                    || qr.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                    continue;
                result.Add(new DictionaryEntryDto(qr.id.ToString(), qr.name));
            }

            return result;
        }

        /// <summary>
        /// 修改用户所选的查询结果显示列
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupId">查询条件组id</param>
        /// <param name="ids">修改的查询结果显示列字符串（如：2,3,5）</param>
        public void EditResultSelect(long userId, long queryTypeId, long groupId, string ids)
        {
            if (string.IsNullOrEmpty(ids))
                return;

            // 检查输入参数是否合法
            var resultAll = GetResultAll(queryTypeId);
            string[] idArr = ids.Split(',');
            foreach (string id in idArr)
            {
                // 字符串中有非法内容，直接返回
                if (!resultAll.Exists(r => r.val.Equals(id)))
                    return;
            }

            // 向查询结果列添加不可见列
            string sql = $"SELECT * FROM d_query_result WHERE query_type_id={queryTypeId} AND display_type_id IN ({(int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID},{(int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP},{(int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE})";
            var paras = new d_query_result_dal().FindListBySql(sql);
            if (paras == null || paras.Count == 0)
                throw new Exception($"query_type_id:{queryTypeId}-数据库未添加d_query_result记录:id");
            foreach (var p in paras)
                ids += "," + p.id;

            var dal = new sys_query_type_user_dal();

            // 同时修改所有相同query_type_id的查询结果
            sql = $"UPDATE sys_query_type_user SET query_result_ids='{ids}' WHERE user_id={userId} AND query_type_id={queryTypeId}";
            dal.ExecuteSQL(sql);

            sys_query_type_user queryUser = dal.FindSignleBySql<sys_query_type_user>($"SELECT * FROM sys_query_type_user WHERE user_id={userId} AND query_para_group_id={groupId}");
            // 用户第一次修改，新增记录
            if (queryUser == null)
            {
                sys_query_type_user queryDefault = dal.FindSignleBySql<sys_query_type_user>($"SELECT * FROM sys_query_type_user WHERE user_id is null AND query_para_group_id={groupId}");
                queryUser = new sys_query_type_user
                {
                    id = dal.GetNextIdSys(),
                    query_para_ids = queryDefault.query_para_ids,
                    query_result_ids = ids,
                    query_type_id = queryTypeId,
                    query_para_group_id = groupId,
                    user_id = userId
                };
                dal.Insert(queryUser);
            }
            
        }
        #endregion

        /// <summary>
        /// 获取一个查询页面所有结果显示列信息
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="queryTypeId"></param>
        /// <returns></returns>
        public List<QueryResultParaDto> GetResultParaAll(long queryTypeId)
        {
            List<QueryResultParaDto> result = new List<QueryResultParaDto>();

            string sql = $"SELECT * FROM d_query_result WHERE query_type_id={queryTypeId} ORDER BY col_order ASC";
            var queryResultList = new d_query_result_dal().FindListBySql(sql);
            foreach (var qr in queryResultList)
            {
                result.Add(new QueryResultParaDto { id = qr.id, name = qr.col_comment, length = qr.col_length, type = qr.display_type_id });
            }

            return result;
        }


        /*
        public QueryResultDto getDataTest()
        {
            string sql = "select id as 客户id,name as 客户名称,(select name from d_general where  id=type_id) as 客户类型,no as 客户编号,name as 客户名称return from crm_account where delete_time=0";
            QueryResultDto result = new QueryResultDto();

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

            result.count = table.Rows.Count;
            result.query_page_name = "";
            result.order_by = "";
            result.page = 1;
            result.page_count = 1;
            result.page_size = 50;
            //result.query_id = queryId;
            result.query_id = "";
            result.result = list;

            return result;
        }
        */
        
        /*
        private static IList<d_query_type> list;
        /// <summary>
        /// 根据查询页面名称获取查询页面信息
        /// </summary>
        /// <param name="queryPageName"></param>
        /// <returns></returns>
        private d_query_type GetQueryType(string queryPageName)
        {
            if (string.IsNullOrEmpty(queryPageName))
                return null;
            if (list == null)
                list = new d_query_type_dal().FindAll();
            return list.FirstOrDefault(q => q.name.Equals(queryPageName));
        }
        */
    }
}
