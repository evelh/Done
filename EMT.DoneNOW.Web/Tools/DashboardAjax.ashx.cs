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
                case "DrillDetail":
                    WidgetDrill();
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
    }
}