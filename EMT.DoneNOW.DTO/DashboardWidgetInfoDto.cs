using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 仪表盘小窗口模型
    /// </summary>
    public class DashboardWidgetInfoDto
    {
        public long id;             // 窗口id
        public string name;         // 窗口名称
        public int typeId;          // 窗口类型
        public int? visualType;     // 窗口显示类型
        public int totalCnt;        // 数据总数

        public sbyte isx;           // 图表是否是column
        public sbyte isy;           // 图表是否是bar
        public bool isStack;        // 图表是否是stack

        public sbyte colorScheme;   // 配色方案
        public object guageList;    // 进度指示类型的数据

        public object gridData;     // 表格数据
        public object gridHeader;   // 表格表头
        
        public List<object> group1;         // 第一个分组名列表
        public List<object> group2;         // 第二个分组名列表
        public List<object> report1;        // 第一个结果列表
        public List<object> report2;        // 第二个结果列表
        public List<string> columns;        // 结果列头
    }

    /// <summary>
    /// 进度指示类型小窗口信息
    /// </summary>
    public class DashboardWidgetGuageInfoDto : DashboardWidgetInfoDto
    {
    }
}
