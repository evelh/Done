using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 小窗口实体
    /// </summary>
    public class WidgetEntityDto
    {
        public long id;
        public string name;
        public List<string> type;       // 实体对应的小窗口类型
    }
}
