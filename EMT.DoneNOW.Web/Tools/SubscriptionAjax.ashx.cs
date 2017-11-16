using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// SubscriptionAjax 的摘要说明
    /// </summary>
    public class SubscriptionAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "activeSubscript":

                    var sid = context.Request.QueryString["sid"];
                    var status_id = context.Request.QueryString["status_id"];
                    ActiveSubscription(context, long.Parse(sid), int.Parse(status_id));
                    break;
                case "activeSubscripts":
                    var sids = context.Request.QueryString["sids"];
                    var thisStatuId = context.Request.QueryString["status_id"];
                    ActiveSubscriptions(context, sids, int.Parse(thisStatuId));
                    break;
                case "property":
                    var psid = context.Request.QueryString["sid"];
                    var propertyName = context.Request.QueryString["property"];
                    GetSubscriptionProperty(context, long.Parse(psid), propertyName);
                    break;
                case "deleteSubscriprion":
                    var dSid = context.Request.QueryString["sid"];
                    DeleteSubscription(context, long.Parse(dSid));
                    break;
                case "deleteSubscriprions":
                    var dSids = context.Request.QueryString["sids"];
                    DeleteSubscriptions(context, dSids);
                    break;
                default:
                    context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
                    break;
            }
        }


        public void ActiveSubscription(HttpContext context, long sid, int status_id)
        {

            var result = new InstalledProductBLL().ActiveSubsctiption(sid, LoginUserId, status_id);
            context.Response.Write(result);
        }
        public void ActiveSubscriptions(HttpContext context, string sids, int status_id)
        {

            var result = new InstalledProductBLL().ActiveSubsctiptions(sids, LoginUserId, status_id);
            context.Response.Write(result);
        }

        public void GetSubscriptionProperty(HttpContext context, long sid, string propertyName)
        {
            var sub = new crm_subscription_dal().GetSubscription(sid);
            if (sub != null)
            {
                context.Response.Write(BaseDAL<Core.crm_account>.GetObjectPropertyValue(sub, propertyName));
            }
        }

        public void DeleteSubscription(HttpContext context, long sid)
        {

            var result = new InstalledProductBLL().DeleteSubsctiption(sid, LoginUserId);
            context.Response.Write(result);
        }

        public void DeleteSubscriptions(HttpContext context, string sids)
        {

            var result = new InstalledProductBLL().DeleteSubsctiptions(sids, LoginUserId);
            context.Response.Write(result);
        }


    }
}