using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ApproveAndPostAjax 的摘要说明
    /// </summary>
    public class ApproveAndPostAjax : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var type = context.Request.QueryString["type"];
            var id = context.Request.QueryString["id"];
            switch (action)
            {
                case "init":Init(context, Convert.ToInt32(id), Convert.ToInt32(type));break;
                case "nobilling": NoBilling(context, Convert.ToInt32(id), Convert.ToInt32(type)); break;
                case "billing": Billing(context, Convert.ToInt32(id), Convert.ToInt32(type)); break;
                case "chargevali": ChargeBlock(context, Convert.ToInt32(id)); break;
                default: break;

            }
        }
        /// <summary>
        /// 恢复初始值
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        /// <param name="type"></param>
        public void Init(HttpContext context, int id, int type)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                if (aapbll.Restore_Initial(id, type, user.id))
                {
                    context.Response.Write("已经恢复初始值！");
                }
                else
                {
                    context.Response.Write("失败！");
                }
            }
        }
        public void NoBilling(HttpContext context, int id, int type)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                if (aapbll.NoBilling(id, type, user.id))
                {
                    context.Response.Write("设置为不可计费成功！");
                }
                else
                {
                    context.Response.Write("失败！");
                }
            }
        }
        public void Billing(HttpContext context, int id, int type)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                if (aapbll.Billing(id, type, user.id))
                {
                    context.Response.Write("设置为可计费成功！");
                }
                else
                {
                    context.Response.Write("失败！");
                }
            }
        }
        /// <summary>
        ///如果成本关联预付费合同，则需要从预付费中扣除费用。
        ///系统需要判断预付费是否足够，如果不够可以选择：
        ///取消、自动生成预付费、强制生成（不够的部分单独生成一个条目）
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void ChargeBlock(HttpContext context, int id) {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                if (aapbll.ChargeBlock(id))
                {
                    context.Response.Write("ok");
                }
                else
                {
                    context.Response.Write("error");
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