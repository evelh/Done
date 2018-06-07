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

            var themeList = new GeneralBLL().GetGeneralList((int)GeneralTableEnum.DASHBOARD_COLOR_THEME);
            var idx = themeList.FindIndex(_ => _.id == dto.theme_id);
            if (idx != -1)
                dto.theme_id = idx;
            else
                dto.theme_id = 0;

            return dto;
        }

        /// <summary>
        /// 获取仪表板的设置信息
        /// </summary>
        /// <param name="dsbdId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public DashboardInfoDto GetDashboardInfo(long dsbdId, long userId)
        {
            var dto = dal.FindSignleBySql<DashboardInfoDto>($"select id,name,theme_id,widget_auto_place from sys_dashboard where id={dsbdId} and (select count(0) from sys_dashboard_resource where resource_id={userId} and dashboard_id={dsbdId} and delete_time=0)=1 and delete_time=0");

            var filterList = GetDashboardFilterPara();
            if (dto.filter_id != null)
            {
                var para = filterList.Find(_ => _.id == dto.filter_id.Value);
                if (para == null)
                    return null;

                if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.CALLBACK)
                {
                    if (dto.filter_default_value != null)
                    {
                        dto.filter_default_value_show = dal.FindSignleBySql<string>($"{para.ref_url_name_sel} in ({dto.filter_default_value})");
                    }
                    if (!string.IsNullOrEmpty(dto.limit_value))
                    {
                        dto.limit_value_show = dal.FindSignleBySql<string>($"{para.ref_url_name_sel} in ({dto.limit_value})");
                    }
                }
            }
            
            return dto;
        }

        /// <summary>
        /// 获取仪表板的过滤条件信息
        /// </summary>
        /// <returns></returns>
        public List<DashboardFilterPataDto> GetDashboardFilterPara()
        {
            string sql = $"select id,data_type_id as data_type,default_value as defaultValue,col_name,col_comment as description,ref_sql,ref_url,operator_type_id,ref_url_name_sel from d_query_para where query_type_id={(int)QueryType.DASHBOARD_FILTER} and is_visible=1 ";
            var paras = new d_query_para_dal().FindListBySql<DashboardFilterPataDto>(sql);

            foreach (var para in paras)
            {
                if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.DROPDOWN
                    || para.data_type == (int)DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN
                    || para.data_type == (int)DicEnum.QUERY_PARA_TYPE.DYNAMIC)
                {
                    var dt = new d_query_para_dal().ExecuteDataTable(para.ref_sql);
                    if (dt != null)
                    {
                        para.values = new List<DictionaryEntryDto>();
                        foreach (System.Data.DataRow row in dt.Rows)
                        {
                            para.values.Add(new DictionaryEntryDto(row[0].ToString(), row[1].ToString()));
                        }
                    }
                }
            }

            return paras;
        }

        /// <summary>
        /// 修改小窗口位置
        /// </summary>
        /// <param name="dsbdId"></param>
        /// <param name="change"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool UpdateWidgetPosition(long dsbdId, string change, long userId)
        {
            if (string.IsNullOrEmpty(change))
                return false;
            if (change[change.Length - 1] == ',')
                change = change.Remove(change.Length - 1);
            var pos = change.Split(',');
            var wgtList = GetWidgetListOrdered(dsbdId);
            if (pos.Length != wgtList.Count)
                return false;
            var before = pos.OrderBy(_ => int.Parse(_.Split('-')[0]));
            var positions = before.ToList();
            for (int order = 0; order < wgtList.Count; order++)
            {
                int sort = int.Parse(positions[order].Split('-')[1]);
                if (wgtList[order].sort_order != sort)
                { 
                    wgtList[order].sort_order = sort;
                    wgtDal.Update(wgtList[order]);
                }
            }
            //foreach (var po in pos)
            //{
            //    string[] p = po.Split('-');
            //    var find = wgtList.Find(_ => _.sort_order != null && _.sort_order.Value == int.Parse(p[0]));
            //    if (find == null)
            //        return false;
            //    if (find.sort_order.Value == int.Parse(p[1]))
            //        continue;

            //    find.sort_order = int.Parse(p[1]);
            //    wgtDal.Update(find);
            //}
            return true;
        }


        /// <summary>
        /// 获取仪表板可选的色系列表
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetWidgetColorThemeList(long userId)
        {
            //var list = new GeneralBLL().GetGeneralList((int)GeneralTableEnum.DASHBOARD_COLOR_THEME);
            //var themeList = from theme in list orderby theme.sort_order ascending select theme.name;
            //return themeList.ToList();
            var list = new GeneralBLL().GetDicValues(GeneralTableEnum.DASHBOARD_COLOR_THEME);
            return list;
        }

        /// <summary>
        /// 删除仪表板
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteDashboard(long id, long userId)
        {
            var dashboard = dal.FindNoDeleteById(id);
            if (dashboard == null)
                return false;

            dashboard.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            dashboard.delete_user_id = userId;
            dal.Update(dashboard);
            OperLogBLL.OperLogDelete<sys_dashboard>(dashboard, dashboard.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD, "删除仪表板");

            var pbDal = new sys_dashboard_publish_dal();
            var publish = dal.FindListBySql<sys_dashboard_publish>($"select * from sys_dashboard_publish where dashboard_id={id} and delete_time=0");
            foreach (var pb in publish)
            {
                pb.delete_time = dashboard.delete_time;
                pb.delete_user_id = userId;
                pbDal.Update(pb);
                OperLogBLL.OperLogDelete<sys_dashboard_publish>(pb, pb.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD_PUBLISH, "删除共享仪表板");
            }

            return true;
        }

        /// <summary>
        /// 新增编辑仪表板
        /// </summary>
        /// <param name="dashboard"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddEditDashboard(sys_dashboard dashboard, long userId)
        {
            dashboard.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            dashboard.update_user_id = userId;
            if (dashboard.id == 0)
            {
                dashboard.id = dal.GetNextIdCom();
                dashboard.create_time = dashboard.update_time;
                dashboard.create_user_id = userId;

                dal.Insert(dashboard);
                OperLogBLL.OperLogAdd<sys_dashboard>(dashboard, dashboard.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD, "新增仪表板");

                var duDal = new sys_dashboard_resource_dal();
                sys_dashboard_resource du = new sys_dashboard_resource();
                du.id = duDal.GetNextIdCom();
                du.dashboard_id = dashboard.id;
                du.resource_id = userId;
                du.is_visible = 1;
                du.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                du.update_user_id = userId;
                du.create_time = du.update_time;
                du.create_user_id = userId;
                var sort = duDal.FindSignleBySql<decimal?>($"select max(sort_order) from sys_dashboard_resource where resource_id={userId}");
                if (sort == null)
                    du.sort_order = 1;
                else
                    du.sort_order = sort.Value + 1;

                duDal.Insert(du);
                OperLogBLL.OperLogAdd<sys_dashboard_resource>(du, du.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD_USER, "新增用户仪表板");
            }
            else
            {
                var dold = dal.FindNoDeleteById(dashboard.id);
                if (dold == null)
                    return false;
                var desc = OperLogBLL.CompareValue<sys_dashboard>(dold, dashboard);
                if (!string.IsNullOrEmpty(desc))
                {
                    dal.Update(dashboard);
                    OperLogBLL.OperLogUpdate(desc, dashboard.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD, "编辑仪表板");
                }
            }
            return true;
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
        /// 获取一个仪表板的小窗口列表
        /// </summary>
        /// <param name="dsbdId"></param>
        /// <returns></returns>
        public List<sys_widget> GetWidgetListOrdered(long dsbdId)
        {
            return wgtDal.FindListBySql($"select * from sys_widget where dashboard_id={dsbdId} and delete_time=0 order by sort_order asc limit 12");
        }

        /// <summary>
        /// 获取一个仪表板的小窗口概要信息
        /// </summary>
        /// <param name="dsbdId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<DashboardWidgetDto> GetWidgetListByDashboardId(long dsbdId, long userId)
        {
            var list = wgtDal.FindListBySql<DashboardWidgetDto>($"select id as widgetId,width from sys_widget where dashboard_id={dsbdId} and delete_time=0 order by sort_order asc limit 12");
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
                    if (widget.type_id == (int)DicEnum.WIDGET_TYPE.GRID
                        && table.Columns[i].ColumnName == "id")
                        continue;

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
                dto.columns = new List<string>();
                for (int i = 0; i < table.Columns.Count; i++)
                {
                    dto.columns.Add(table.Columns[i].ColumnName);
                }
                var g = from grp in data select grp[0];
                dto.group1 = g.Distinct().ToList();

                if (widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.BAR
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.STACKED_BAR
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.GROUPED_BAR
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.STACKED_BAR_PERCENT)
                {
                    dto.isy = 1;
                }
                else if (widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.COLUMN
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.STACKED_COLUMN
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.GROUPED_COLUMN
                    || widget.visual_type_id == (int)DicEnum.WIDGET_CHART_VISUAL_TYPE.STACKED_COLUMN_PERCENT)
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
                dto.visualType = widget.visual_type_id;

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
                        if (col.ColumnName == "id")
                            continue;

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

        /// <summary>
        /// 删除小窗口
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteWidget(long id, long userId)
        {
            var wgt = wgtDal.FindNoDeleteById(id);
            if (wgt == null)
                return false;

            wgt.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            wgt.delete_user_id = userId;
            wgtDal.Update(wgt);
            OperLogBLL.OperLogDelete<sys_widget>(wgt, wgt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD_WIDGET, "删除小窗口");
            return true;
        }

        #endregion


        #region 新增小窗口及配置

        /// <summary>
        /// 新增小窗口
        /// </summary>
        /// <param name="widget"></param>
        /// <param name="guages"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public long AddWidget(sys_widget widget, List<sys_widget_guage> guages, long userId)
        {
            if (widget.dashboard_id == null || widget.dashboard_id.Value == 0)
                return 0;
            if (widget.type_id == (int)DicEnum.WIDGET_TYPE.GUAGE)
            {
                if (guages == null || guages.Count == 0)
                    return 0;
            }

            var list = GetWidgetListOrdered(widget.dashboard_id.Value);
            if (list.Count == 0)
                widget.sort_order = 0;
            else
                widget.sort_order = list[list.Count - 1].sort_order.Value + 1;

            widget.id = wgtDal.GetNextIdCom();
            widget.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            widget.create_time = widget.update_time;
            widget.create_user_id = userId;
            widget.update_user_id = userId;

            wgtDal.Insert(widget);
            OperLogBLL.OperLogAdd<sys_widget>(widget, widget.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD_WIDGET, "新增小窗口");

            if (widget.type_id == (int)DicEnum.WIDGET_TYPE.GUAGE)
            {
                sys_widget_guage_dal gDal = new sys_widget_guage_dal();
                foreach (var guage in guages)
                {
                    guage.id = gDal.GetNextIdCom();
                    guage.widget_id = widget.id;
                    guage.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    guage.create_time = widget.update_time;
                    guage.create_user_id = userId;
                    guage.update_user_id = userId;

                    gDal.Insert(guage);
                    OperLogBLL.OperLogAdd<sys_widget_guage>(guage, guage.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD_WIDGET_GUAGE, "新增小窗口部件");
                }
            }

            return widget.id;
        }

        public long UpdateWidget(sys_widget widget, List<sys_widget_guage> guages, long userId)
        {
            var wgtOld = wgtDal.FindById(widget.id);
            if (wgtOld == null)
                return 0;

            if (widget.type_id == (int)DicEnum.WIDGET_TYPE.GUAGE)
            {
                if (guages == null || guages.Count == 0)
                    return 0;
            }

            widget.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            widget.update_user_id = userId;

            var desc = OperLogBLL.CompareValue<sys_widget>(wgtOld, widget);
            if (!string.IsNullOrEmpty(desc))
            {
                wgtDal.Update(widget);
                OperLogBLL.OperLogUpdate(desc, widget.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD_WIDGET, "设置小窗口");
            }

            if (widget.type_id == (int)DicEnum.WIDGET_TYPE.GUAGE)
            {
                var guagesOld = GetGuageChildren(widget.id);

                //wgtDal.ExecuteSQL($"update sys_widget_guage set delete_time='{DateTime.Now}' and delete_user_id={userId}");
                sys_widget_guage_dal gDal = new sys_widget_guage_dal();
                foreach (var guage in guages)
                {
                    var gOld = guagesOld.Find(_ => _.id == guage.id);
                    if (gOld != null)
                    {
                        var gUpt = gDal.FindById(guage.id);
                        gUpt.sort_order = guage.sort_order;
                        gUpt.report_on_id = guage.report_on_id;
                        gUpt.aggregation_type_id = guage.aggregation_type_id;
                        gUpt.name = guage.name;
                        gUpt.break_based_on = guage.break_based_on;
                        gUpt.segments = guage.segments;
                        gUpt.break_points = guage.break_points;
                        gUpt.filter_json = guage.filter_json;

                        desc = OperLogBLL.CompareValue<sys_widget_guage>(gOld, gUpt);
                        if (!string.IsNullOrEmpty(desc))
                        {
                            gDal.Update(gUpt);
                            OperLogBLL.OperLogUpdate(desc, gUpt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD_WIDGET_GUAGE, "编辑小窗口部件");
                        }

                        guagesOld.Remove(gOld);
                    }
                    else
                    {
                        guage.id = gDal.GetNextIdCom();
                        guage.widget_id = widget.id;
                        guage.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        guage.create_time = widget.update_time;
                        guage.create_user_id = userId;
                        guage.update_user_id = userId;

                        gDal.Insert(guage);
                        OperLogBLL.OperLogAdd<sys_widget_guage>(guage, guage.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD_WIDGET_GUAGE, "新增小窗口部件");
                    }
                }

                foreach (var g in guagesOld)
                {
                    g.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    g.delete_user_id = userId;
                    gDal.Update(g);
                    OperLogBLL.OperLogDelete<sys_widget_guage>(g, g.id, userId, DicEnum.OPER_LOG_OBJ_CATE.DASHBOARD_WIDGET_GUAGE, "删除小窗口部件");
                }
            }

            return widget.id;
        }

        /// <summary>
        /// 获取新增小窗口的实体类型
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<WidgetEntityDto> GetAddWidgetEntityList(long userId)
        {
            var list = new List<WidgetEntityDto>();
            var ettList = new GeneralBLL().GetGeneralList((int)GeneralTableEnum.WIDGET_ENTITY);
            foreach (var ett in ettList)
            {
                WidgetEntityDto dto = new WidgetEntityDto();
                dto.id = ett.id;
                dto.name = ett.name;

                var types = ett.ext1.Split(',');
                dto.type = types.ToList();

                list.Add(dto);
            }

            return list;
        }

        /// <summary>
        /// 获取小窗口的过滤条件参数
        /// </summary>
        /// <param name="entityId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<List<WidgetFilterPataDto>> GetWidgetFilterPara(long entityId, long userId)
        {
            List<List<WidgetFilterPataDto>> parasList = new List<List<WidgetFilterPataDto>>();
            QueryCommonBLL queryBll = new QueryCommonBLL();
            var groupList = queryBll.GetQueryGroup((int)entityId);
            if (groupList.Count == 0)
                return parasList;
            var grp = groupList[0];
            string sql = $"select id,data_type_id as data_type,default_value as defaultValue,col_name,col_comment as description,ref_sql,ref_url,operator_type_id from d_query_para where query_para_group_id={grp.id} and is_visible=1 and operator_type_id is not null";
            var paras = new d_query_para_dal().FindListBySql<WidgetFilterPataDto>(sql);

            sql = $"select distinct(col_comment) from d_query_para where query_para_group_id={grp.id} and is_visible=1 and operator_type_id is not null  order by col_comment asc";
            var cdts = new d_query_para_dal().FindListBySql<string>(sql);
            foreach (var cdt in cdts)
            {
                List<WidgetFilterPataDto> newDtos = new List<WidgetFilterPataDto>();
                var dtos = (from prm in paras where cdt.Equals(prm.description) select prm).ToList();
                foreach (var dto in dtos)
                {
                    if (string.IsNullOrEmpty(dto.operator_type_id))
                        continue;

                    if (dto.data_type == (int)DicEnum.QUERY_PARA_TYPE.DROPDOWN
                    || dto.data_type == (int)DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN
                    || dto.data_type == (int)DicEnum.QUERY_PARA_TYPE.DYNAMIC)
                    {
                        var dt = new d_query_para_dal().ExecuteDataTable(dto.ref_sql);
                        if (dt != null)
                        {
                            dto.values = new List<DictionaryEntryDto>();
                            foreach (System.Data.DataRow row in dt.Rows)
                            {
                                dto.values.Add(new DictionaryEntryDto(row[0].ToString(), row[1].ToString()));
                            }
                        }
                    }

                    var opers = dto.operator_type_id.Split(',');
                    if (opers.Length == 1)
                    {
                        dto.operatorName = dal.FindSignleBySql<string>($"select name from d_general where id={long.Parse(dto.operator_type_id)}");
                        newDtos.Add(dto);
                    }
                    else
                    {
                        foreach (var oper in opers)
                        {
                            WidgetFilterPataDto newDto = new WidgetFilterPataDto
                            {
                                col_name = dto.col_name,
                                data_type = dto.data_type,
                                defaultValue = dto.defaultValue,
                                description = dto.description,
                                id = dto.id,
                                operatorName = dal.FindSignleBySql<string>($"select name from d_general where id={long.Parse(oper)}"),
                                operator_type_id = oper,
                                ref_sql = dto.ref_sql,
                                ref_url = dto.ref_url,
                                values = dto.values
                            };
                            newDtos.Add(newDto);
                        }
                    }
                }
                parasList.Add(newDtos);
            }

            return parasList;
        }

        /// <summary>
        /// 获取小窗口的分组条件参数
        /// </summary>
        /// <param name="entityId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetWidgetGroupbyPara(long entityId, long userId)
        {
            QueryCommonBLL queryBll = new QueryCommonBLL();
            var groupList = queryBll.GetQueryGroup((int)entityId);
            if (groupList.Count == 0)
                return new List<DictionaryEntryDto>();
            
            return dal.FindListBySql<DictionaryEntryDto>($"select id as `val`,col_comment as `show` from d_query_groupby where query_type_id={groupList[0].query_type_id} order by col_comment asc");
        }

        /// <summary>
        /// 获取小窗口的统计字段参数
        /// </summary>
        /// <param name="entityId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<List<WidgetReportOnParaDto>> GetWidgetReportOnPara(long entityId, long userId)
        {
            var result = new List<List<WidgetReportOnParaDto>>();
            QueryCommonBLL queryBll = new QueryCommonBLL();
            var groupList = queryBll.GetQueryGroup((int)entityId);
            if (groupList.Count == 0)
                return result;

            var all = dal.FindListBySql<WidgetReportOnParaDto>($"select id,col_comment as `name`,aggregation_type_id as agrId,(select `name` from d_general WHERE id=aggregation_type_id) as agrType from d_query_result WHERE query_type_id={groupList[0].query_type_id} and type_id=1 order by col_comment");
            var disRpt = from r in all group r by r.name into g select g;
            foreach (var name in disRpt)
            {
                var dto = new List<WidgetReportOnParaDto>();
                //dto.name = name.Key;
                //dto.id=name.First().id;
                var group = from r in all where r.name.Equals(name.Key) select r;
                foreach (var agr in group)
                {
                    dto.Add(new WidgetReportOnParaDto
                    {
                        id = agr.id,
                        name = name.Key,
                        agrId = agr.agrId,
                        agrType = agr.agrType
                    });
                }
                result.Add(dto);
            }

            return result;
        }

        /// <summary>
        /// 获取小窗口表格列参数
        /// </summary>
        /// <param name="entityId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetWidgetTableColumnPara(long entityId, long userId)
        {
            QueryCommonBLL queryBll = new QueryCommonBLL();
            var groupList = queryBll.GetQueryGroup((int)entityId);
            if (groupList.Count == 0)
                return new List<DictionaryEntryDto>();

            var all = dal.FindListBySql<DictionaryEntryDto>($"select id as `val`,col_comment as `show` from d_query_result WHERE query_type_id={groupList[0].query_type_id} and type_id=2 order by col_comment");

            return all;
        }

        /// <summary>
        /// 获取小窗口表格排序参数
        /// </summary>
        /// <param name="entityId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetWidgetTableSortPara(long entityId, long userId)
        {
            QueryCommonBLL queryBll = new QueryCommonBLL();
            var groupList = queryBll.GetQueryGroup((int)entityId);
            if (groupList.Count == 0)
                return new List<DictionaryEntryDto>();

            var all = dal.FindListBySql<DictionaryEntryDto>($"select id as `val`,col_comment as `show` from d_query_orderby WHERE query_type_id={groupList[0].query_type_id} order by col_comment");

            return all;
        }

        /// <summary>
        /// 动态日期范围的日期范围值
        /// </summary>
        /// <returns></returns>
        public object GetDynamicDatePara()
        {
            var gbll = new GeneralBLL();
            var start = gbll.GetDicValues(GeneralTableEnum.DYNAMIC_START_DATE_TYPE);
            var end = gbll.GetDicValues(GeneralTableEnum.DYNAMIC_END_DATE_TYPE);
            var rtn = new object[] { start, end };
            return rtn;
        }

        /// <summary>
        /// 获取小窗口仪表类型分段类型
        /// </summary>
        /// <param name="entityId"></param>
        /// <returns></returns>
        public List<string[]> GetBreakPoint(long entityId)
        {
            var list = dal.FindListBySql<d_general>($"select id,name,ext1 from d_general where general_table_id={(int)GeneralTableEnum.WIDGET_BREAK_BASE_ON} and parent_id={entityId} order by sort_order asc");
            if (list.Count == 0)
                return null;

            var rtn = new List<string[]>();
            foreach (var bk in list)
            {
                rtn.Add(new string[]
                {
                    bk.id.ToString(),
                    bk.name,
                    dal.FindSignleBySql<string>(bk.ext1)
                });
            }
            return rtn;
        }

        /// <summary>
        /// 获取系统小窗口列表
        /// </summary>
        /// <returns></returns>
        public List<string[]> GetSysWidgetList()
        {
            var list = wgtDal.FindListBySql("select id,entity_id,type_id,visual_type_id,name,description from sys_widget where dashboard_id is null and delete_time=0 order by sort_order asc");
            var rtn = new List<string[]>();
            foreach (var wgt in list)
            {
                rtn.Add(new string[]
                {
                    wgt.id.ToString(),
                    wgt.entity_id.ToString(),
                    wgt.type_id.ToString(),
                    wgt.visual_type_id==null?"":wgt.visual_type_id.Value.ToString(),
                    wgt.name,
                    wgt.description
                });
            }
            return rtn;
        }

        #endregion

    }
}
