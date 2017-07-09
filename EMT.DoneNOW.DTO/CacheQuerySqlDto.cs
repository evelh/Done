using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 缓存查询语句sql
    /// </summary>
    public class CacheQuerySqlDto
    {
        public string query_page_name;      // 查询类型（d_query_type:name）
        public int count;                   // 查询结果总数
        public int page_size;               // 每页大小
        public int page_count;              // 总页数
        public string query_sql;            // 查询语句sql
    }
}
