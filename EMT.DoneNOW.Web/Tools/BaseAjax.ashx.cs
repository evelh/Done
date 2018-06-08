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
        protected HttpRequest request;
        protected HttpResponse response;

        public void ProcessRequest(HttpContext ctx)
        {
            //userInfo = context.Session["dn_session_user_info"] as UserInfoDto;
            //if (userInfo == null)   // 用户未登录
            //{
            //    context.Response.Write(new Tools.Serialize().SerializeJson("{\"status\": '1', \"msg\": \"用户未登录！\"}"));
            //    context.Response.End();
            //    return;
            //}
            //userPermit = context.Session["dn_session_user_permits"] as List<AuthPermitDto>;

            string token = EMT.Tools.Common.GetCookie("Token", "DoneNOW");
            if (string.IsNullOrEmpty(token))
            {
                ctx.Response.Write(new Tools.Serialize().SerializeJson(new string[] { "status=1", "用户未登录" }));
                ctx.Response.End();
                return;
            }

            userInfo = AuthBLL.GetLoginUserInfo(token);
            if (userInfo == null)
            {
                ctx.Response.Write(new Tools.Serialize().SerializeJson(new string[] { "status=1", "用户未登录" }));
                ctx.Response.End();
                return;
            }
            userPermit = AuthBLL.GetLoginUserPermit(token);


            // 判断用户是否可以访问当前url
            if (!CheckUserAccess(ctx.Request.RawUrl))
            {
                ctx.Response.Write(new Tools.Serialize().SerializeJson(new string[] { "status=2", "没有权限操作" }));
                ctx.Response.End();
                return;
            }

            request = ctx.Request;
            response = ctx.Response;

            AjaxProcess(ctx);
        }

        /// <summary>
        /// 判断用户是否有权限访问当前url
        /// </summary>
        /// <returns></returns>
        private bool CheckUserAccess(string url)
        {
            //return true;
            return AuthBLL.CheckUrlAuth(userInfo.security_Level_id, userPermit, url);
        }

        public abstract void AjaxProcess(HttpContext context);

        /// <summary>
        /// json格式化数据到返回中
        /// </summary>
        /// <param name="msg"></param>
        protected void WriteResponseJson(object msg)
        {
            response.Write(new Tools.Serialize().SerializeJson(msg));
        }

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
            //return true;
            return AuthBLL.CheckAuth(userInfo.security_Level_id, userPermit, sn);
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