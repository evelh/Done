using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ServiceCallAjax 的摘要说明
    /// </summary>
    public class ServiceCallAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "CheckResInCall":
                    CheckResInCall(context);
                    break;
                case "GetCall":
                    GetCall(context);
                    break;
                case "EditCall":
                    EditCall(context);
                    break;
          
                default:
                    break;

            }
        }
        /// <summary>
        /// 判断员工是否在服务预定包含的任务的负责人中
        /// </summary>
        private void CheckResInCall(HttpContext context)
        {
            var resId = context.Request.QueryString["resId"];
            var callId = context.Request.QueryString["callId"];
            var result = false;
            if (!string.IsNullOrEmpty(resId) && !string.IsNullOrEmpty(callId))
                result = new DAL.sdk_service_call_dal().ResInCall(long.Parse(callId),long.Parse(resId));
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 获取服务预定相关信息
        /// </summary>
        private void GetCall(HttpContext context)
        {
            var callId = context.Request.QueryString["callId"];
            if (!string.IsNullOrEmpty(callId))
            {
                var thisCall = new DAL.sdk_service_call_dal().FindNoDeleteById(long.Parse(callId));
                if (thisCall != null)
                {
                    var thisACcount = new BLL.CompanyBLL().GetCompany(thisCall.account_id);
                    var startDate = Tools.Date.DateHelper.ConvertStringToDateTime(thisCall.start_time);
                    var endDate = Tools.Date.DateHelper.ConvertStringToDateTime(thisCall.end_time);
                    var durHours = ((decimal)thisCall.end_time - (decimal)thisCall.start_time) / 1000 / 60 / 60;
                    context.Response.Write(new Tools.Serialize().SerializeJson(new {id=thisCall.id,startDateString= startDate.ToString("yyyy-MM-dd"), startTimeString= startDate.ToString("HH:mm"), endDateString = endDate.ToString("yyyy-MM-dd"), endTimeString = endDate.ToString("HH:mm"), durHours = durHours.ToString("#0.00"),accountName = thisACcount!=null?thisACcount.name:"", description = thisCall.description }));
                }

            }
        }
        /// <summary>
        /// 调度服务预定
        /// </summary>
        private void EditCall(HttpContext context)
        {
            var callId = context.Request.QueryString["callId"];
            var startTime = context.Request.QueryString["startTime"];
            var durHours = context.Request.QueryString["durHours"];
            var resId = context.Request.QueryString["resId"];
            long? oldResId = null;
            long? roleId = null;
            if (!string.IsNullOrEmpty(context.Request.QueryString["oldResId"]))
                oldResId = long.Parse(context.Request.QueryString["oldResId"]);
            if (!string.IsNullOrEmpty(context.Request.QueryString["roleId"]))
                roleId = long.Parse(context.Request.QueryString["roleId"]);
            var result = false;
            if (!string.IsNullOrEmpty(callId) && !string.IsNullOrEmpty(startTime) && !string.IsNullOrEmpty(durHours) && !string.IsNullOrEmpty(resId))
                result = new BLL.DispatchBLL().EditServiceCall(long.Parse(callId), oldResId,long.Parse(resId),roleId,startTime,decimal.Parse(durHours),LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }


    }
}