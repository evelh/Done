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
        public long query_type_id;          // 查询类型（d_query_type:id）
        public long para_group_id;          // 查询条件分组id
        public int page_size;               // 每页大小
        public int page;                    // 页号
        public string order_by;             // 排序规则
        public List<Para> query_params;     // 查询条件及查询值
    }

    /// <summary>
    /// 小窗口钻取查询请求的查询条件及查询值
    /// </summary>
    public class QueryWidgetDrillParaDto
    {
        public long widget_id;              // 小窗口id
        public string group1;               // 分组条件1
        public string group2;               // 分组条件2
        public long query_type_id;          // 查询类型（d_query_type:id）
        public long para_group_id;          // 查询条件分组id
        public int page_size;               // 每页大小
        public int page;                    // 页号
        public string order_by;             // 排序规则
    }

    /// <summary>
    /// 查询条件id和值
    /// </summary>
    public class Para
    {
        public long id;             // 查询条件id
        public string value;        // 查询条件值（查询条件类型为数字或日期型时作为下限值）
        public string value2;       // 查询条件值2（查询条件类型为数字或日期型时作为上限值，其他类型不适用此值）
    }
}
