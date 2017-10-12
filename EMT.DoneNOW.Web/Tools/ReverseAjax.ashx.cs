using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ReverseAjax 的摘要说明 六个撤销审批的操作方法
    /// </summary>
    public class ReverseAjax : IHttpHandler, IRequiresSessionState
    {
        private readonly ReverseBLL rebll = new ReverseBLL();
        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var ids = context.Request.QueryString["ids"];
            switch (action)
            {
                case "CHARGES":
                    Revoke_CHARGES(context, Convert.ToString(ids)); break;
                case "Recurring_Services":
                    Revoke_Recurring_Services(context, Convert.ToString(ids)); break;
                case "Milestones":
                    Revoke_Milestones(context, Convert.ToString(ids)); break;
                case "Subscriptions":
                    Revoke_Subscriptions(context, Convert.ToString(ids)); break;
                case "UnPostAll":
                    UnPostAll(context,ids);
                    break;
                default: break;
            }
        }
        /// <summary>
        /// 撤销成本审批
        /// </summary>
        /// <param name="context"></param>
        /// <param name="ids"></param>
        public void Revoke_CHARGES(HttpContext context, string ids) {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                string re = string.Empty;
                var result = rebll.Revoke_CHARGES(res.id, ids,out re);
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
        /// <summary>
        /// 根据Ids撤销所有的审批
        /// </summary>
        public void UnPostAll(HttpContext context,string ids)
        {
            var res = context.Session["dn_session_user_info"];
            if (res != null)
            {
                var user = res as sys_user;
                var accDedList = new crm_account_deduction_dal().GetAccDeds(ids);
                if (accDedList != null && accDedList.Count > 0)
                {
                    var thisDicList = accDedList.GroupBy(_ => _.type_id).ToDictionary(_ => _.Key, _ => _.ToList());
                    foreach (var thisDic in thisDicList)
                    {
                        string thisIds = "";
                        foreach (var item in thisDic.Value)
                        {
                            thisIds += item.id.ToString() + ',';
                        }
                        if (string.IsNullOrEmpty(thisIds))
                        {
                            continue;
                        }
                        thisIds = thisIds.Substring(0, thisIds.Length-1);
                        switch (thisDic.Key)
                        {
                            case (int)ACCOUNT_DEDUCTION_TYPE.CHARGE:
                                Revoke_CHARGES(context,thisIds);
                                break;
                            case (int)ACCOUNT_DEDUCTION_TYPE.MILESTONES:  // 里程碑
                                Revoke_Milestones(context, thisIds);
                                break;
                            case (int)ACCOUNT_DEDUCTION_TYPE.SUBSCRIPTIONS:
                                Revoke_Subscriptions(context, thisIds);
                                break;
                            case (int)ACCOUNT_DEDUCTION_TYPE.SERVICE:
                                Revoke_Recurring_Services(context, thisIds);
                                break;
                            case (int)ACCOUNT_DEDUCTION_TYPE.SERVICE_ADJUST:
                                // Revoke_Recurring_Services(context, thisIds);
                                break;
                            case (int)ACCOUNT_DEDUCTION_TYPE.INITIAL_COST:
                                // Revoke_Recurring_Services(context, thisIds);
                                break;
                            default:
                                break;
                        }
                    }
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