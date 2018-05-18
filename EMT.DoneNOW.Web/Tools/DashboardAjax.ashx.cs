using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System.Text;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// DashboardAjax 的摘要说明
    /// </summary>
    public class DashboardAjax : BaseAjax
    {
        private DashboardBLL bll = new DashboardBLL();

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "GetInitailDashboard":
                    GetInitailDashboard();
                    break;
                case "GetDashboard":
                    GetDashborad();
                    break;
                case "GetWidgetInfo":
                    GetWidgetInfo();
                    break;
                case "DeleteWidget":
                    DeleteWidget();
                    break;
                case "DrillDetail":
                    WidgetDrill();
                    break;
                case "ChangeWidgetPosition":
                    ChangeWidgetPosition();
                    break;

                case "GetWidgetEntityList":
                    GetWidgetEntityList();
                    break;
                case "GetWidgetFilter":
                    GetWidgetFilterList();
                    break;
                case "GetWidgetReport":
                    GetWidgetReportOnList();
                    break;
                case "GetWidgetGroupby":
                    GetWidgetGroupbyList();
                    break;
                case "AddWidget":
                    AddWidget();
                    break;
                case "GetWidgetTypeList":
                    GetWidgetTypeList();
                    break;
                case "GetColorThemeList":
                    GetColorThemeList();
                    break;
                default:
                    WriteResponseJson("{\"code\": 1, \"msg\": \"参数错误！\"}");
                    break;
            }
        }

        /// <summary>
        /// 获取初始仪表板信息
        /// </summary>
        private void GetInitailDashboard()
        {
            var list = bll.GetUserDashboardList(LoginUserId);
            if (list.Count == 0)
            {
                WriteResponseJson(null);
                return;
            }
            else
            {
                var dsbd = bll.GetDashboardInfoById(long.Parse(list[0].val), LoginUserId);
                var rtn = new object[] { list, dsbd };
                WriteResponseJson(rtn);
                return;
            }
        }

        /// <summary>
        /// 获取一个仪表板信息
        /// </summary>
        private void GetDashborad()
        {
            long id = long.Parse(request.QueryString["id"]);
            var dsbd = bll.GetDashboardInfoById(id, LoginUserId);
            WriteResponseJson(dsbd);
        }

        /// <summary>
        /// 获取一个窗口详细信息
        /// </summary>
        private void GetWidgetInfo()
        {
            var id = long.Parse(request.QueryString["id"]);
            var info = bll.GetWidgetDetail(id, LoginUserId);
            WriteResponseJson(info);
        }

        /// <summary>
        /// 删除小窗口
        /// </summary>
        private void DeleteWidget()
        {
            var id = long.Parse(request.QueryString["id"]);
            WriteResponseJson(bll.DeleteWidget(id, LoginUserId));
        }

        /// <summary>
        /// 小窗口钻取
        /// </summary>
        private void WidgetDrill()
        {
            //var id = long.Parse(request.QueryString["id"]);
            //var val1 = request.QueryString["val1"];
            //var val2 = request.QueryString["val2"];
            //bll.WidgetDrill(id, val1, val2, LoginUserId);
            WriteResponseJson(true);
        }

        /// <summary>
        /// 修改小窗口位置
        /// </summary>
        private void ChangeWidgetPosition()
        {
            var change = request.QueryString["change"];
            var id = long.Parse(request.QueryString["id"]);
            if (string.IsNullOrEmpty(change))
            {
                WriteResponseJson(true);
                return;
            }
            WriteResponseJson(bll.UpdateWidgetPosition(id, change, LoginUserId));
        }

        /// <summary>
        /// 新增小窗口
        /// </summary>
        private void AddWidget()
        {
            sys_widget wgt = new sys_widget();
            List<sys_widget_guage> guages = null;
            long dsbdId = long.Parse(request.QueryString["dashboardId"]);
            if (request.Form["addWidgetType"] == "1")
            {
                wgt.dashboard_id = dsbdId;
                wgt.entity_id = int.Parse(request.Form["addWidgetEntity"]);
                wgt.type_id= int.Parse(request.Form["addWidgetTypeSelect"]);
                wgt.name = request.Form["addWidgetName"];
                wgt.description= request.Form["wgtDesc"];
                wgt.width = sbyte.Parse(request.Form["wgtSize"]);
                if (wgt.type_id == (int)DicEnum.WIDGET_TYPE.CHART)
                {
                    wgt.filter_json = GetFileterJson("", bll.GetWidgetFilterPara(wgt.entity_id, LoginUserId));
                    wgt.visual_type_id = int.Parse(request.Form["wgtVisualType"]);
                    wgt.report_on_id = long.Parse(request.Form["wgtReport1"]);
                    wgt.aggregation_type_id = int.Parse(request.Form["wgtReportType1"]);
                    if (!string.IsNullOrEmpty(request.Form["wgtReport2"]) && !string.IsNullOrEmpty(request.Form["wgtReportType2"]))
                    {
                        wgt.report_on_id2 = long.Parse(request.Form["wgtReport2"]);
                        wgt.aggregation_type_id2 = int.Parse(request.Form["wgtReportType2"]);
                    }
                    wgt.groupby_id = long.Parse(request.Form["wgtGroup1"]);
                    if (!string.IsNullOrEmpty(request.Form["wgtGroup2"]))
                    {
                        wgt.groupby_id2 = long.Parse(request.Form["wgtGroup2"]);
                    }
                    wgt.include_none = (sbyte)(GetCheckBoxValue("wgtShowBlank") ? 1 : 0);
                    wgt.display_type_id = int.Parse(request.Form["wgtShowType"]);
                    wgt.orderby_id = int.Parse(request.Form["wgtSortType"]);
                    wgt.display_other = (sbyte)(GetCheckBoxValue("wgtDisplayOth") ? 1 : 0);
                    wgt.show_axis_label = (sbyte)(GetCheckBoxValue("wgtShowAxis") ? 1 : 0);
                    wgt.show_trendline = (sbyte)(GetCheckBoxValue("wgtShowTrendline") ? 1 : 0);
                    wgt.show_legend = (sbyte)(GetCheckBoxValue("wgtShowTitle") ? 1 : 0);
                    wgt.show_total = (sbyte)(GetCheckBoxValue("wgtShowTotal") ? 1 : 0);
                }
                else if (wgt.type_id == (int)DicEnum.WIDGET_TYPE.GUAGE)
                {
                    wgt.visual_type_id = int.Parse(request.Form["wgtVisualType"]);
                    guages = new List<sys_widget_guage>();
                    sbyte order = 1;
                    var filterPara = bll.GetWidgetFilterPara(wgt.entity_id, LoginUserId);
                    for (int i = 1; i <= 6; i++)
                    {
                        if (string.IsNullOrEmpty(request.Form["wgtSub" + i + "Report1"]))
                            continue;
                        sys_widget_guage gg = new sys_widget_guage();
                        gg.report_on_id = long.Parse(request.Form["wgtSub" + i + "Report1"]);
                        gg.sort_order = order++;
                        gg.aggregation_type_id = int.Parse(request.Form["wgtSub" + i + "ReportType1"]);
                        gg.name = request.Form["wgtSub" + i + "Label"];
                        if (!string.IsNullOrEmpty(request.Form["wgtSub" + i + "BreakType"]))
                            gg.break_based_on = int.Parse(request.Form["wgtSub" + i + "BreakType"]);
                        gg.segments = sbyte.Parse(request.Form["wgtSub" + i + "BreakCnt"]);
                        string bp = request.Form["wgtSub" + i + "BP0"];
                        if (gg.segments.Value > 1)
                            bp += "," + request.Form["wgtSub" + i + "BP1"];
                        if (gg.segments.Value > 2)
                            bp += "," + request.Form["wgtSub" + i + "BP2"];
                        if (gg.segments.Value > 3)
                            bp += "," + request.Form["wgtSub" + i + "BP3"];
                        if (gg.segments.Value > 4)
                            bp += "," + request.Form["wgtSub" + i + "BP4"];
                        bp += "," + request.Form["wgtSub" + i + "BP" + gg.segments.Value];
                        gg.break_points = bp;
                        gg.filter_json = GetFileterJson("Sub" + i, filterPara);

                        guages.Add(gg);
                    }
                }
            }
            WriteResponseJson(bll.AddWidget(wgt, guages, LoginUserId));
        }
        /// <summary>
        /// 生成过滤条件json串
        /// </summary>
        /// <param name="sub"></param>
        /// <param name="paras"></param>
        /// <returns></returns>
        private string GetFileterJson(string sub, List<List<DTO.WidgetFilterPataDto>> paras)
        {
            StringBuilder json = new StringBuilder("[");
            var form = request.Form;

            for (int i = 1; i < 6; i++)
            {
                if (string.IsNullOrEmpty(form["wgt"+sub+"Filter" + i]))
                    continue;

                var paraFind = paras.Find(_ => _[0].description.Equals(form["wgt" + sub + "Filter" + i]));
                if (paraFind == null)
                    continue;

                var para = paraFind.Find(_ => _.operator_type_id.Equals(form["wgt" + sub + "Filter" + i + "Oper"]));
                if (para == null)
                    continue;

                // 根据不同的条件定义类型获取不同类型的值
                if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.DROPDOWN
                    || para.data_type == (int)DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN
                    || para.data_type == (int)DicEnum.QUERY_PARA_TYPE.SINGLE_LINE
                    || para.data_type == (int)DicEnum.QUERY_PARA_TYPE.NUMBER_EQUAL)
                {
                    json.Append("{\"col_name\":\"" + para.col_name + "\",\"operator\":\""
                        + para.operator_type_id + "\",\"value\":\"" + form["wgt" + sub + "Filter" + i + "Val1"] + "\"},");
                }
                else if (para.data_type == (int)DicEnum.QUERY_PARA_TYPE.CHANGED
                    || para.data_type == (int)DicEnum.QUERY_PARA_TYPE.NONE_INPUT)
                {
                    json.Append("{\"col_name\":\"" + para.col_name + "\",\"operator\":\""
                        + para.operator_type_id + "\",\"value\":\"1\"},");
                }
            }

            if (json.ToString().Equals("["))
                return null;

            json.Remove(json.Length - 1, 1);
            json.Append("]");
            return json.ToString();
        }
        /// <summary>
        /// 返回表单元素checkbox是否选中
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        private bool GetCheckBoxValue(string key)
        {
            if (string.IsNullOrEmpty(request.Form[key]))
                return false;
            if (request.Form[key] == "on")
                return true;
            return false;
        }

        /// <summary>
        /// 获取新增小窗口的实体类型
        /// </summary>
        private void GetWidgetEntityList()
        {
            WriteResponseJson(bll.GetAddWidgetEntityList(LoginUserId));
        }

        /// <summary>
        /// 获取小窗口的过滤条件参数
        /// </summary>
        private void GetWidgetFilterList()
        {
            var id = long.Parse(request.QueryString["id"]);
            WriteResponseJson(bll.GetWidgetFilterPara(id, LoginUserId));
        }

        /// <summary>
        /// 获取小窗口的统计字段参数
        /// </summary>
        private void GetWidgetReportOnList()
        {
            var id = long.Parse(request.QueryString["id"]);
            WriteResponseJson(bll.GetWidgetReportOnPara(id, LoginUserId));
        }

        /// <summary>
        /// 获取小窗口的分组条件参数
        /// </summary>
        private void GetWidgetGroupbyList()
        {
            var id = long.Parse(request.QueryString["id"]);
            WriteResponseJson(bll.GetWidgetGroupbyPara(id, LoginUserId));
        }

        /// <summary>
        /// 获取新增小窗口的类型
        /// </summary>
        private void GetWidgetTypeList()
        {
            WriteResponseJson(new GeneralBLL().GetDicValues(DTO.GeneralTableEnum.WIDGET_TYPE));
        }

        /// <summary>
        /// 获取可选的色系列表
        /// </summary>
        private void GetColorThemeList()
        {
            WriteResponseJson(bll.GetWidgetColorThemeList(LoginUserId));
        }
    }
}