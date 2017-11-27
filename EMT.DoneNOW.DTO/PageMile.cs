using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 页面里程碑实体类
    /// </summary>
    public class PageMile
    {
        public long id;
        public string type;    // 合同里程碑 或者阶段里程碑
        public string name;
        public string status;
        public long status_id;      // 状态
        public decimal amount;
        public DateTime dueDate;
        public string isAss;   // 是否关联
    }
}
