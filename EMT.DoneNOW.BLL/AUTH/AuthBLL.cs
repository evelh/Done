using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.Tools;
using JWT;

namespace EMT.DoneNOW.BLL
{
    public class AuthBLL
    {
        private readonly sys_user_dal _dal = new sys_user_dal();
        private const int expire_time_mins = 60;//60 * 8;            // token过期时间(8小时)
        private const int expire_time_mins_refresh = 60 * 16;     // refreshtoken过期时间(16小时)
        private const int expire_time_secs= 60 * expire_time_mins;            // token过期时间(8小时)
        private const int expire_time_secs_refresh = 60 * expire_time_mins_refresh;     // refreshtoken过期时间(16小时)
        private const string secretKey = "GQDstcKsx0NHjPOuXOYg5MbeJ1XT0uFiwDVvVBrk";

        /// <summary>
        /// 生成token，创建缓存
        /// </summary>
        /// <param name="loginName">登录名，邮箱或手机号</param>
        /// <param name="password">登录密码</param>
        /// <param name="tokenDto"></param>
        /// <returns></returns>
        public ERROR_CODE Login(string loginName, string password, string userAgent,string ip, out TokenDto tokenDto)
        {
            tokenDto = null;
            StringBuilder where = new StringBuilder();
            string loginType = "";
            if (new RegexOp().IsEmail(loginName))
            {
                where.Append($" email='{loginName}' ");
                loginType = "email";
            }
            else if (new RegexOp().IsMobilePhone(loginName))
            {
                where.Append($" mobile_phone='{loginName}' ");
                loginType = "mobile_phone";
            }
            else
            {
                return ERROR_CODE.PARAMS_ERROR;
            }

            List<sys_user> user = _dal.FindListBySql($"SELECT * FROM sys_user WHERE {where.ToString()}");
            if (user.Count < 1)
                return ERROR_CODE.USER_NOT_FIND;
            if (!new Cryptographys().SHA1Encrypt(password).Equals(user[0].password))
            {
                // TODO: 输入错误密码处理
                return ERROR_CODE.PASSWORD_ERROR;
            }

           


            // TODO: user status判断

            // TODO: 读resource信息用以下注释
            sys_resource resource = new sys_resource();
            resource.id = user[0].id;
            resource.first_name = "A";
            resource.last_name = "a";
            /*
            // 根据user表信息进入租户数据库获取详细信息，以判断用户状态
            sys_resource resource = new sys_resource_dal().FindById(user[0].id);
            if (resource.is_locked == 1)
                return ERROR_CODE.LOCK;
            if (resource.active == 0)
                return ERROR_CODE.LOCK;
            // TODO: 更多校验及处理
            */
            var start = Math.Round((DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalSeconds);
            var exp = (long)(start + expire_time_secs);
            var random = new Random();
            TokenStructDto payload = new TokenStructDto
            {
                uid = resource.id,
                timestamp = (long)start,
                expire = exp,
                rand = random.Next(int.MaxValue)
            };    // 获取token
            var refreshexp = (long)(start + expire_time_secs_refresh);
            TokenStructDto refreshPayload = new TokenStructDto
            {
                uid = resource.id,
                timestamp = (long)start,
                expire = refreshexp,
                rand = random.Next(int.MaxValue)
            };   // 获取refreshtoken

            //JwtEncoder encoder = new JwtEncoder(new JWT.Algorithms.HMACSHA512Algorithm(), new JWT.Serializers.JsonNetSerializer(), new JwtBase64UrlEncoder());
            string token = EncodeToken(payload);
            string refreshToken = EncodeToken(refreshPayload);

            UserInfoDto userinfo = new UserInfoDto();
            userinfo.id = resource.id;
            userinfo.name = resource.last_name + resource.first_name;
            CachedInfoBLL.SetUserInfo(token, userinfo, expire_time_mins);
            CachedInfoBLL.SetToken(refreshToken, token, expire_time_mins_refresh);

            tokenDto = new TokenDto
            {
                token = token,
                refresh = refreshToken
            };


            #region 插入日志
            //1.判断token中用户数量
            if (_dal.IsBeyond(user[0].id))  //未超过登陆限制
            {
                sys_login_log login_log = new sys_login_log {
                    agent =userAgent,id= Convert.ToInt64(_dal.GetNextIdSys()),
                    ip =ip,login_time= DateTime.Now,name="",user_id=user[0].id};
                if (loginType.Equals("email"))
                {
                    login_log.email = loginName;
                }
                else if (loginType.Equals("mobile_phone"))
                {
                    login_log.mobile_phone = loginName; 
                }
                new sys_login_log_dal().Insert(login_log); //向sys_login_log表中插入日志

                sys_token token_log = new sys_token() {
                    expire_time = DateTime.Now.AddMinutes(expire_time_mins),
                    id = Convert.ToInt64(_dal.GetNextIdSys()),
                    user_id =user[0].id,
                      port=1,//端口1web 2APP 目前只有web，赋默认值1
                    //  product=user[0].cate_id,
                    token = token,
                    refresh_token=refreshToken
                };
                new sys_token_dal().Insert(token_log); //向sys_token表中插入日志

            }
            else  //超出登陆限制，返回登陆数量超出
            {
                return ERROR_CODE.USER_LIMITCOUNT;
            }




            #endregion

            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 登录（不使用token）
        /// </summary>
        /// <param name="loginName"></param>
        /// <param name="password">md5后的登录密码</param>
        /// <param name="ip"></param>
        /// <param name="agent"></param>
        /// <param name="userInfo"></param>
        /// <returns></returns>
        public ERROR_CODE Login(string loginName, string password, string ip, string agent, out sys_user userInfo)
        {
            userInfo = null;
            StringBuilder where = new StringBuilder();
            string loginType = "";
            // 判断登录类型是邮箱还是手机号
            if (new RegexOp().IsEmail(loginName))
            {
                where.Append($" email='{loginName}' ");
                loginType = "email";
            }
            else if (new RegexOp().IsMobilePhone(loginName))
            {
                where.Append($" mobile_phone='{loginName}' ");
                loginType = "mobile_phone";
            }
            else
            {
                return ERROR_CODE.PARAMS_ERROR;
            }

            List<sys_user> user = _dal.FindListBySql($"SELECT * FROM sys_user WHERE {where.ToString()}");
            if (user.Count < 1)
                return ERROR_CODE.USER_NOT_FIND;
            if (!new Cryptographys().SHA1Encrypt(password).Equals(user[0].password))    // 密码错误
            {
                return ERROR_CODE.PASSWORD_ERROR;
            }
            if (user[0].status_id != (int)DicEnum.USER_STATUS.NORMAL)       // 用户状态不可用
                return ERROR_CODE.USER_NOT_FIND;

            //向sys_login_log表中插入日志
            sys_login_log login_log = new sys_login_log
            {
                id = _dal.GetNextIdSys(),
                ip = ip,
                agent = agent,
                login_time = DateTime.Now,
                name = "",
                user_id = user[0].id
            };
            if (loginType.Equals("email"))
            {
                login_log.email = loginName;
            }
            else if (loginType.Equals("mobile_phone"))
            {
                login_log.mobile_phone = loginName;
            }
            new sys_login_log_dal().Insert(login_log); 

            userInfo = user[0];

            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 生成token
        /// </summary>
        /// <param name="refreshToken"></param>
        /// <param name="tokenDto"></param>
        /// <returns></returns>
        public bool RefreshToken(string refreshToken, out TokenDto tokenDto)
        {
            tokenDto = null;
            string token = CachedInfoBLL.GetToken(refreshToken);
            if (string.IsNullOrEmpty(token))
                return false;
            UserInfoDto info = CachedInfoBLL.GetUserInfo(token);
            if (info != null) // token未过期
            {
                tokenDto = new TokenDto
                {
                    token = token,
                    refresh = refreshToken
                };
                return true;
            }
            else  // token过期，refreshtoken未过期，重新生成
            {
                var tokeninfo = DecodeToken(refreshToken);
                if (tokeninfo == null)
                    return false;

                var start = Math.Round((DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalSeconds);
                var random = new Random();
                TokenStructDto newTokenInfo = new TokenStructDto
                {
                    uid = tokeninfo.uid,
                    timestamp = (long)start,
                    expire = (long)(start + expire_time_secs),
                    rand = random.Next(int.MaxValue)
                };
                TokenStructDto newRefreshTokenInfo = new TokenStructDto
                {
                    uid = tokeninfo.uid,
                    timestamp = (long)start,
                    expire = (long)(start + expire_time_secs_refresh),
                    rand = random.Next(int.MaxValue)
                };
                string newToken = EncodeToken(newTokenInfo);
                string newRefreshToken = EncodeToken(newRefreshTokenInfo);

                UserInfoDto userinfo = new UserInfoDto();
                userinfo.id = tokeninfo.uid;
                CachedInfoBLL.SetUserInfo(newToken, userinfo, expire_time_mins);
                CachedInfoBLL.SetToken(newRefreshToken, newToken, expire_time_mins_refresh);

                tokenDto = new TokenDto
                {
                    token = token,
                    refresh = refreshToken
                };
                return true;
            }
        }

        private string EncodeToken(TokenStructDto token)
        {
            JwtEncoder encoder = new JwtEncoder(new JWT.Algorithms.HMACSHA256Algorithm(), new JWT.Serializers.JsonNetSerializer(), new JwtBase64UrlEncoder());
            return encoder.Encode(token, secretKey);
        }

        private TokenStructDto DecodeToken(string token)
        {
            var jser = new JWT.Serializers.JsonNetSerializer();
            JwtDecoder decoder = new JwtDecoder(jser, new JWT.JwtValidator(jser, new JWT.UtcDateTimeProvider()), new JwtBase64UrlEncoder());
            return decoder.DecodeToObject<TokenStructDto>(token, secretKey, true);
        }
        
    }
}
