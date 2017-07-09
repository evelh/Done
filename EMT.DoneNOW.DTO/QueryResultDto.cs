using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class QueryResultDto
    {
        public string query_page_name;      // 查询类型（d_query_type:name）
        public int count;                   // 查询结果总数
        public int page;                    // 页号
        public int page_size;               // 每页大小
        public int page_count;              // 总页数
        public string query_id;             // 查询条件索引
        public string order_by;             // 排序
        public List<Dictionary<string, object>> result;     // 查询结果
    }
}
