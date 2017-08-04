using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 查询条件页面页面信息
    /// </summary>
    public class PageQueryConditionNameDto
    {
        public string page_name;    // 页面名称
        public List<PageQuery> page_query;  // 查询页子查询页面名称

        public class PageQuery
        {
            public string query_name;
            public long typeId;
            public long groupId;
        }
    }
}
