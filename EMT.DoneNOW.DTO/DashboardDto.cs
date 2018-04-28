using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 仪表板模型
    /// </summary>
    public class DashboardDto
    {
        public long id;
        public string name;
        public int theme_id;
        public sbyte auto_place;
        public List<DashboardWidgetDto> widgetList = new List<DashboardWidgetDto>();
    }

    /// <summary>
    /// 仪表板内小窗口概要信息
    /// </summary>
    public class DashboardWidgetDto
    {
        public long widgetId;
        public int width;
    }
}
