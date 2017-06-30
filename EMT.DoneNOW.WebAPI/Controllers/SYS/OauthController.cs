using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.WebAPI.Controllers
{
    public class OauthController : BaseController
    {
        /// <summary>
        /// 获取token和refresh token
        /// </summary>
        /// <param name="name">登录名（用户手机号或邮箱）</param>
        /// <param name="password">密码（用户密码的md5值）</param>
        /// <returns>token和refresh token值</returns>
        [AllowAnonymousAttribute]
        [HttpGet]
        [Route("auth/token")]
        public ApiResultDto GetToken(string name, string password)
        {
            TokenDto token;
            string userAgent = "";
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
            var rslt = new AuthBLL().Login(name, password, userAgent, out token);
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
    }
}
