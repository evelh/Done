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
    }
}