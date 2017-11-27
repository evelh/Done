using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// BaseAjax 的摘要说明
    /// </summary>
    public abstract class BaseAjax : IHttpHandler, IRequiresSessionState
    {
        private UserInfoDto userInfo;   // 登录用户信息
        private List<AuthPermitDto> userPermit;     // 用户单独的权限点信息
        public void ProcessRequest(HttpContext context)
        {
            userInfo = context.Session["dn_session_user_info"] as UserInfoDto;
            if (userInfo == null)   // 用户未登录
            {
                context.Response.Write(new Tools.Serialize().SerializeJson("{\"status\": '1', \"msg\": \"用户未登录！\"}"));
                context.Response.End();
                return;
            }
            userPermit = context.Session["dn_session_user_permits"] as List<AuthPermitDto>;

            // 判断用户是否可以访问当前url
            if (!CheckUserAccess(context.Request.RawUrl))
            {
                context.Response.Write(new Tools.Serialize().SerializeJson("{\"status\": '2', \"msg\": \"没有权限操作！\"}"));
                context.Response.End();
                return;
            }

            AjaxProcess(context);
        }

        /// <summary>
        /// 判断用户是否有权限访问当前url
        /// </summary>
        /// <returns></returns>
        private bool CheckUserAccess(string url)
        {
            return true;
            //return AuthBLL.CheckUrlAuth(userInfo.security_Level_id, userPermit, url);
        }

        public abstract void AjaxProcess(HttpContext context);

        /// <summary>
        /// 获取登录用户id
        /// </summary>
        protected long LoginUserId
        {
            get { return userInfo.id; }
        }

        /// <summary>
        /// 获取登录用户信息
        /// </summary>
        protected UserInfoDto LoginUser
        {
            get { return userInfo; }
        }

        /// <summary>
        /// 用户单独的权限
        /// </summary>
        protected List<AuthPermitDto> UserPermit
        {
            get { return userPermit; }
        }

        /// <summary>
        /// 判断是否有对应权限
        /// </summary>
        /// <param name="sn"></param>
        /// <returns></returns>
        protected bool CheckAuth(string sn)
        {
            return true;
            //return AuthBLL.CheckAuth(userInfo.security_Level_id, userPermit, sn);
        }

        /// <summary>
        /// 获取一个limit权限值
        /// </summary>
        /// <param name="limit"></param>
        /// <returns></returns>
        protected DicEnum.LIMIT_TYPE_VALUE GetLimitValue(AuthLimitEnum limit)
        {
            return AuthBLL.GetLimitValue(userInfo.security_Level_id, limit);
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