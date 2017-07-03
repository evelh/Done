using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using System.Web;

namespace EMT.DoneNOW.WebAPI.Controllers
{
    public class OauthController : BaseController
    {
        /// <summary>
        /// 获取token和refresh token
        /// </summary>
        /// <param name="param"></param>
        /// <returns>token和refresh token值</returns>
        [AllowAnonymousAttribute]
        [HttpPost]
        [Route("auth/token")]
        public ApiResultDto GetToken([FromBody] UserAuthDto param)
        {
          
            TokenDto token;
            string userAgent = "";
            var ip = GetIPAddress();
           
            if (Request.Headers.Contains("User-Agent"))
            {
                var headers = Request.Headers.GetValues("User-Agent");

                var sb = new System.Text.StringBuilder();

                foreach (var header in headers)
                {
                    sb.Append(header);

                    // Re-add spaces stripped when user agent string was split up.
                    sb.Append(" ");
                }

                userAgent = sb.ToString().Trim();
            }
            var rslt = new AuthBLL().Login(param.name, param.password, userAgent, ip, out token);
            if (rslt == ERROR_CODE.SUCCESS)
                return ResultSuccess(token);
            return ResultError(rslt);
        }

        /// <summary>
        /// 使用refresh_token重新获取token和refresh token
        /// </summary>
        /// <param name="refresh_token">获取token时返回的refresh token值</param>
        /// <returns>token和refresh token值</returns>
        [AllowAnonymousAttribute]
        [HttpGet]
        [Route("auth/refresh_token")]
        public ApiResultDto GetRefreshToken(string refresh_token)
        {
            TokenDto token;
            var rslt = new AuthBLL().RefreshToken(refresh_token, out token);
            if (rslt)
                return ResultSuccess(token);
            return ResultError(ERROR_CODE.PARAMS_ERROR);
        }
        /// <summary>
        /// 获取用户IP地址
        /// </summary>
        /// <returns></returns>
        public  string GetIPAddress()
        {
            //HttpRequest request = HttpContext.Current.Request;

            //string result = request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            //if (string.IsNullOrEmpty(result)) { result = request.ServerVariables["REMOTE_ADDR"]; }
            //if (string.IsNullOrEmpty(result))
            //{ result = request.UserHostAddress; }
            //if (string.IsNullOrEmpty(result))
            //{ result = "0.0.0.0"; }
            string user_IP = string.Empty;
            if (System.Web.HttpContext.Current.Request.ServerVariables["HTTP_VIA"] != null)
            {
                if (System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
                {
                    user_IP = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
                }
                else
                {
                    user_IP = System.Web.HttpContext.Current.Request.UserHostAddress;
                }
            }
            else
            {
                user_IP = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
            }
            return user_IP;

          
        }
    }
}
