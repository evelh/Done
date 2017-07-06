using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 查询请求的查询条件及查询值
    /// </summary>
    public class QueryParaDto
    {
        public string query_page_name;      // 查询类型（d_query_type:name）
        public List<Para> query_params;     // 查询条件及查询值
    }

    public class Para
    {
        public long id;             // 查询条件id
        public string value;        // 查询条件值（查询条件类型为数字或日期型时作为下限值）
        public string value2;       // 查询条件值2（查询条件类型为数字或日期型时作为上限值，其他类型不适用此值）
    }
}
