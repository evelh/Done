using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 搜索页面结果显示列的列信息
    /// </summary>
    public class QueryResultParaDto
    {
        public long id;         // 显示结果列id d_query_result id
        public string name;     // 列显示名称 d_query_result col_comment
        public int length;      // 列长度 d_query_result col_length
        public int type;        // 列数据显示类型 d_query_result display_type_id
        public int visible;     // 是否可见
        public AuthUrlDto url;  // 链接 link_url
    }
}
