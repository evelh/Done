using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;

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


        private void AddWidget()
        {
            WriteResponseJson(1);
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