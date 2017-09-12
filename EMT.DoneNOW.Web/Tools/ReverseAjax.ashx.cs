using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ReverseAjax 的摘要说明 六个撤销审批的操作方法
    /// </summary>
    public class ReverseAjax : IHttpHandler
    {
        private readonly ReverseBLL rebll = new ReverseBLL();
        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var ids = context.Request.QueryString["ids"];
            switch (action)
            {
                case "Expense":                   
                    Revoke_Expense(context, Convert.ToString(ids)); break;
                case "Recurring_Services":
                    Revoke_Recurring_Services(context, Convert.ToString(ids)); break;
                case "Milestones":
                    Revoke_Milestones(context, Convert.ToString(ids)); break;
                case "Subscriptions":
                    Revoke_Subscriptions(context, Convert.ToString(ids)); break;
                default: break;
            }
        }
        /// <summary>
        /// 撤销成本审批
        /// </summary>
        /// <param name="context"></param>
        /// <param name="ids"></param>
        public void Revoke_Expense(HttpContext context, string ids) {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                string re = string.Empty;
                var result = rebll.Revoke_Expense(res.id, ids,out re);
                switch (result) {
                    case DTO.ERROR_CODE.SUCCESS: context.Response.Write("撤销审批成功！");break;
                    case DTO.ERROR_CODE.EXIST: context.Response.Write(re); break;

                    default: context.Response.Write("撤销审批失败！"); break;
                }
            }
        }
        /// <summary>
        /// 撤销定期服务审批
        /// </summary>
        /// <param name="context"></param>
        /// <param name="ids"></param>
        public void Revoke_Recurring_Services(HttpContext context, string ids)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                string re = string.Empty;
                var result = rebll.Revoke_Recurring_Services(res.id, ids,out re);
                switch (result)
                {
                    case DTO.ERROR_CODE.SUCCESS: context.Response.Write("撤销审批成功！"); break;
                    case DTO.ERROR_CODE.EXIST: context.Response.Write(re); break;
                    default: context.Response.Write("撤销审批失败！"); break;
                }
            }
        }
        /// <summary>
        /// 撤销里程碑审批
        /// </summary>
        /// <param name="context"></param>
        /// <param name="ids"></param>
        public void Revoke_Milestones(HttpContext context, string ids)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                string re = string.Empty;
                var result = rebll.Revoke_Milestones(res.id, ids,out re);
                switch (result)
                {
                    case DTO.ERROR_CODE.SUCCESS: context.Response.Write("撤销审批成功！"); break;
                    case DTO.ERROR_CODE.EXIST: context.Response.Write(re); break;
                    default: context.Response.Write("撤销审批失败！"); break;
                }
            }
        }
        /// <summary>
        /// 撤销订阅审批
        /// </summary>
        /// <param name="context"></param>
        /// <param name="ids"></param>
        public void Revoke_Subscriptions(HttpContext context, string ids)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                string re = string.Empty;
                var result = rebll.Revoke_Subscriptions(res.id, ids,out re);
                switch (result)
                {
                    case DTO.ERROR_CODE.SUCCESS: context.Response.Write("撤销审批成功！"); break;
                    case DTO.ERROR_CODE.EXIST: context.Response.Write(re); break;
                    default: context.Response.Write("撤销审批失败！"); break;
                }
            }
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}