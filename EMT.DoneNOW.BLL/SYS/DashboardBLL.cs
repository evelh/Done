using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    public class DashboardBLL
    {
        sys_dashboard_dal dal = new sys_dashboard_dal();
        sys_widget_dal wgtDal = new sys_widget_dal();

        #region 仪表板功能
        /// <summary>
        /// 获取用户显示的仪表板列表
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetUserDashboardList(long userId)
        {
            return dal.FindListBySql<DictionaryEntryDto>($"select dashboard_id as `val`,(select `name` from sys_dashboard where id=dashboard_id) as `show` from sys_dashboard_resource where resource_id={userId} and is_visible=1 and delete_time=0 order by sort_order asc");
        }

        /// <summary>
        /// 获取一个仪表板及其小窗口信息
        /// </summary>
        /// <param name="dsbdId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public DashboardDto GetDashboardInfoById(long dsbdId, long userId)
        {
            var dto = dal.FindSignleBySql<DashboardDto>($"select id,name,theme_id,widget_auto_place as auto_place from sys_dashboard where id={dsbdId} and (select count(0) from sys_dashboard_resource where resource_id={userId} and dashboard_id={dsbdId} and delete_time=0)=1 and delete_time=0");
            if (dto != null)
                dto.widgetList = GetWidgetListByDashboardId(dsbdId, userId);

            return dto;
        }
        #endregion


        #region 小窗口功能
        /// <summary>
        /// 获取小窗口实体
        /// </summary>
        /// <param name="widgetId"></param>
        /// <returns></returns>
        public sys_widget GetWidgetById(long widgetId)
        {
            return wgtDal.FindNoDeleteById(widgetId);
        }
        /// <summary>
        /// 获取一个仪表板的小窗口概要信息
        /// </summary>
        /// <param name="dsbdId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<DashboardWidgetDto> GetWidgetListByDashboardId(long dsbdId, long userId)
        {
            var list = wgtDal.FindListBySql<DashboardWidgetDto>($"select id as widgetId,width from sys_widget where dashboard_id={dsbdId} and delete_time=0 order by sort_order asc");
            return list;
        }

        /// <summary>
        /// 获取小窗口用于显示的详细信息
        /// </summary>
        /// <param name="widgetId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public DashboardWidgetInfoDto GetWidgetDetail(long widgetId, long userId)
        {
            var widget = wgtDal.FindNoDeleteById(widgetId);
            if (widget == null)
                return null;
            

            DashboardWidgetInfoDto dto = new DashboardWidgetInfoDto();
            dto.id = widget.id;
            dto.name = widget.name;
            dto.typeId = widget.type_id;

            var sql = wgtDal.GetWidgetSql(widget.id, widget.type_id, userId);
            if (string.IsNullOrEmpty(sql))
            {
                return dto;
            }
            var table = wgtDal.ExecuteDataTable(sql);
            List<List<object>> data = new List<List<object>>();
            foreach (System.Data.DataRow row in table.Rows)
            {
                List<object> dataRow = new List<object>();
                for (int i = 0; i < table.Columns.Count; i++)
                {
                    if (object.Equals(row[i], System.DBNull.Value))
                        dataRow.Add("");
                    else
                        dataRow.Add(row[i]);
                }
                data.Add(dataRow);
            }
            dto.totalCnt = data.Count;

            if (widget.type_id == (int)DicEnum.WIDGET_TYPE.CHART)
            {
                dto.visualType = widget.visual_type_id;
                if (widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.TABLE)
                {
                    dto.gridData = data;

                    if (widget.show_column_header == 1)
                    {
                        List<string> cols = new List<string>();
                        foreach (System.Data.DataColumn col in table.Columns)
                        {
                            cols.Add(col.ColumnName);
                        }
                        dto.gridHeader = cols;
                    }

                    return dto;
                }
                var g = from grp in data select grp[0];
                dto.group1 = g.Distinct().ToList();

                if (widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.BAR
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.STACKED_BAR
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.GROUPED_BAR)
                {
                    dto.isy = 1;
                }
                else if (widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.COLUMN
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.STACKED_COLUMN
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.GROUPED_COLUMN)
                {
                    dto.isx = 1;
                }

                dto.isStack = false;
                if (widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.STACKED_COLUMN
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.STACKED_BAR
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.STACKED_COLUMN_PERCENT
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.STACKED_BAR_PERCENT
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.STACKED_AREA)
                    dto.isStack = true;

                g = from grp in data select grp[1];
                if (widget.groupby_id2 != null)
                {
                    dto.group2 = g.Distinct().ToList();

                    g = from grp in data group grp by grp[0] into g1 select new { g1.Key };

                    dto.report1 = new List<object>();
                    foreach (var grp2 in dto.group2)
                    {
                        List<object> dt = new List<object>();
                        foreach (var grp1 in dto.group1)
                        {
                            var find = data.Find(row => row[0].Equals(grp1) && row[1].Equals(grp2));
                            if (find == null)
                                dt.Add("");
                            else
                                dt.Add(find[2]);
                        }
                        dto.report1.Add(dt);
                    }
                }
                else
                {
                    dto.report1 = g.ToList();
                    if (widget.report_on_id2 != null)
                    {
                        g = from grp in data select grp[2];
                        dto.report2 = g.ToList();

                    }
                }
            }
            else if (widget.type_id == (int)DicEnum.WIDGET_TYPE.GUAGE)
            {
                var guageList = GetGuageChildren(widget.id);
                if (widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.NEEDLE)
                    dto.guageType = 1;
                else if (widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.DOUGHNUT_GUAGE)
                    dto.guageType = 2;
                else if (widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.NUMBER)
                    dto.guageType = 3;

                var ggData = new List<List<object>>();
                foreach (var gg in guageList)
                {
                    var ggd = new List<object>();
                    var finddata = data.Find(_ => _[0].ToString().Equals(gg.sort_order.ToString()));
                    if (finddata == null)
                        continue;
                    ggd.Add(finddata[0]);
                    ggd.Add(finddata[1]);
                    ggd.Add(finddata[2]);
                    ggd.Add(gg.break_points.Split(','));
                    ggData.Add(ggd);
                }
                dto.guageList = ggData;
            }
            else if (widget.type_id == (int)DicEnum.WIDGET_TYPE.GRID)
            {
                dto.gridData = data;
                dto.totalCnt = wgtDal.GetWidgetDrillCount(widget.id, userId, null, null, null, null);
                if (widget.show_column_header == 1)
                {
                    List<string> cols = new List<string>();
                    foreach (System.Data.DataColumn col in table.Columns)
                    {
                        cols.Add(col.ColumnName);
                    }
                    dto.gridHeader = cols;
                }
            }

            return dto;
        }

        /// <summary>
        /// 获取进度小窗口的部件列表
        /// </summary>
        /// <param name="widgetId"></param>
        /// <returns></returns>
        public List<sys_widget_guage> GetGuageChildren(long widgetId)
        {
            return new sys_widget_guage_dal().FindListBySql($"select * from sys_widget_guage where widget_id={widgetId} and delete_time=0 order by sort_order asc");
        }

        /// <summary>
        /// 小窗口钻取
        /// </summary>
        /// <param name="widgetId"></param>
        /// <param name="val1"></param>
        /// <param name="val2"></param>
        /// <param name="orderby"></param>
        /// <param name="userId"></param>
        /// <param name="count"></param>
        /// <returns></returns>
        public string GetWidgetDrillSql(long widgetId, string val1, string val2, string orderby, long userId, out int count)
        {
            count = wgtDal.GetWidgetDrillCount(widgetId, userId, null, orderby, val1, val2);
            if (count == 0)
                return null;
            return wgtDal.GetWidgetDrillSql(widgetId, userId, null, orderby, val1, val2);
        }
        #endregion
    }
}
