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
        private const int _pageSize = 15;     // 默认查询分页大小

        /// <summary>
        /// 获取一个搜索页面的查询语句
        /// </summary>
        /// <param name="userId">用户id</param>
        /// <param name="queryTypeId">搜索页面id</param>
        /// <param name="para">搜索条件</param>
        /// <param name="orderBy">排序信息（如 id asc）</param>
        /// <param name="page">查询页数</param>
        /// <param name="pagesize">分页每页个数</param>
        /// <returns>查询没有结果时，返回空字符串</returns>
        public string GetQuerySql(long userId, DicEnum.QUERY_TYPE queryTypeId, QueryParaDto para, string orderBy, int page = 1, int pagesize = _pageSize)
        {
            if (para == null || para.query_params == null)
                return "";
            d_query_type queryType = new d_query_type_dal().FindSignleBySql<d_query_type>($"SELECT * FROM d_query_type WHERE name='{para.query_page_name}'");
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

            int count = 0;
            string sql = new sys_query_type_user_dal().GetQuerySql((int)queryTypeId, userId, queryPara.ToString(), orderBy, out count);

            // 添加分页
            if (count == 0)
                return "";
            int totalPage = count / pagesize;
            if (count % pagesize != 0)
                ++totalPage;
            if (page <= 0)
                page = 1;
            if (page > totalPage)
                page = totalPage;
            int offset = (page - 1) * pagesize;
            sql = sql + $" LIMIT {offset},{pagesize}";

            return sql;
        }
    }
}
