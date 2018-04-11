using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// DispatchAjax 的摘要说明
    /// </summary>
    public class DispatchAjax : BaseAjax
    {
        protected BLL.DispatchBLL dBLL = new BLL.DispatchBLL();
        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "DeleteDispatch":
                    DeleteDispatch(context);
                    break;
                case "DeleteAppointment":
                    DeleteAppointment(context);
                    break;
                case "AddDispatch":
                    AddDispatch(context);
                    break;
                case "EditDispatch":
                    EditDispatch(context);
                    break;
                case "EditSearchViewDispatch":
                    EditSearchViewDispatch(context);
                    break;
                case "GetAppiont":
                    GetAppiont(context);
                    break;
                case "EditAppiont":
                    EditAppiont(context);
                    break;
                case "EditTodo":
                    EditTodo(context);
                    break;
                default:
                    break;

            }
        }

        /// <summary>
        /// 删除调度视图
        /// </summary>
        private void DeleteDispatch(HttpContext context)
        {
            var dId = context.Request.QueryString["id"];
            var result = false;
            if (!string.IsNullOrEmpty(dId))
                result = dBLL.DeleteDispatchView(long.Parse(dId),LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        
        /// <summary>
        /// 删除约会
        /// </summary>
        private void DeleteAppointment(HttpContext context)
        {
            var dId = context.Request.QueryString["id"];
            var result = false;
            if (!string.IsNullOrEmpty(dId))
                result = dBLL.DeleteAppointment(long.Parse(dId), LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }

        /// <summary>
        /// 新增调度视图
        /// </summary>
        private void AddDispatch(HttpContext context)
        {
            var sdv = new Core.sdk_dispatcher_view();
            sdv.workgroup_ids = context.Request.QueryString["workIds"];
            sdv.resource_ids = context.Request.QueryString["resIds"];
            sdv.show_unassigned = (sbyte)(!string.IsNullOrEmpty(context.Request.QueryString["isShowNoRes"])?1:0);
            sdv.show_canceled = (sbyte)(!string.IsNullOrEmpty(context.Request.QueryString["isShowCalls"]) ? 1 : 0);
            sdv.name = context.Request.QueryString["name"];
            var modeId = context.Request.QueryString["modeId"];
            if (!string.IsNullOrEmpty(modeId))
                sdv.mode_id = int.Parse(modeId);
            var result = false;
            result = dBLL.AddDispatchView(sdv,LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }

        private void EditDispatch(HttpContext context)
        {
            var id = context.Request.QueryString["id"];
            var result = false;
            if (!string.IsNullOrEmpty(id))
            {
                var thisSdv = new DAL.sdk_dispatcher_view_dal().FindNoDeleteById(long.Parse(id));
                if (thisSdv != null)
                {
                    thisSdv.name = context.Request.QueryString["name"];
                    result = dBLL.EditDispatchView(thisSdv,LoginUserId);
                }
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }

        private void EditSearchViewDispatch(HttpContext context)
        {
            var id = context.Request.QueryString["id"];
            var result = false;
            if (!string.IsNullOrEmpty(id))
            {
                var mode_id = context.Request.QueryString["modeId"];
                var thisSdv = new DAL.sdk_dispatcher_view_dal().FindNoDeleteById(long.Parse(id));
                if (thisSdv != null&&!string.IsNullOrEmpty(mode_id))
                {
                    thisSdv.resource_ids = context.Request.QueryString["resIds"];
                    thisSdv.workgroup_ids = context.Request.QueryString["workIds"];
                    thisSdv.mode_id = int.Parse(mode_id);
                    thisSdv.show_unassigned = (sbyte)(context.Request.QueryString["ckNoRes"]=="1"?1:0);
                    thisSdv.show_canceled = (sbyte)(context.Request.QueryString["ckShowCancel"] == "1" ? 1 : 0);
                    result = dBLL.EditDispatchView(thisSdv, LoginUserId);
                }
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }


        /// <summary>
        /// 获取约会信息
        /// </summary>
        private void GetAppiont(HttpContext context)
        {
            var appId = context.Request.QueryString["id"];
            if (!string.IsNullOrEmpty(appId))
            {
                var thisApp = new DAL.sdk_appointment_dal().FindNoDeleteById(long.Parse(appId));
                if (thisApp != null)
                {
                    var startDate = Tools.Date.DateHelper.ConvertStringToDateTime(thisApp.start_time);
                    var endDate = Tools.Date.DateHelper.ConvertStringToDateTime(thisApp.end_time);
                    var durHours = ((decimal)thisApp.end_time - (decimal)thisApp.start_time) / 1000 / 60 / 60;
                    context.Response.Write(new Tools.Serialize().SerializeJson(new {name=thisApp.name, description = thisApp.description, startDateString = startDate.ToString("yyyy-MM-dd"), startTimeString = startDate.ToString("HH:mm"), endDateString = endDate.ToString("yyyy-MM-dd"), endTimeString = endDate.ToString("HH:mm"), durHours = durHours.ToString("#0.00") }));
                }
            }
        }
        /// <summary>
        /// 编辑约会
        /// </summary>
        private void EditAppiont(HttpContext context)
        {
            var result = false;
            var id = context.Request.QueryString["id"];
            var startTime = context.Request.QueryString["startTime"];
            var durHours = context.Request.QueryString["durHours"];
            var resId = context.Request.QueryString["resId"];
            if (!string.IsNullOrEmpty(id) && !string.IsNullOrEmpty(startTime) && !string.IsNullOrEmpty(durHours) && !string.IsNullOrEmpty(resId))
                result = dBLL.EditAppointment(long.Parse(id), startTime,decimal.Parse(durHours),long.Parse(resId),LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 编辑待办
        /// </summary>
        private void EditTodo(HttpContext context)
        {
            var result = false;
            var id = context.Request.QueryString["id"];
            var startTime = context.Request.QueryString["startTime"];
            var durHours = context.Request.QueryString["durHours"];
            var resId = context.Request.QueryString["resId"];
            if (!string.IsNullOrEmpty(id) && !string.IsNullOrEmpty(startTime) && !string.IsNullOrEmpty(durHours) && !string.IsNullOrEmpty(resId))
                result = dBLL.EditTodo(long.Parse(id), startTime, decimal.Parse(durHours), long.Parse(resId), LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
    }
}