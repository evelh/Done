using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.Tools;
using System.Reflection;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    public class BasePage : System.Web.UI.Page
    {
        private UserInfoDto userInfo;   // 登录用户信息
        private List<AuthPermitDto> userPermit;     // 用户单独的权限点信息
        public BasePage()
        {
            this.Load += new EventHandler(BasePage_Load);
        }

        private void BasePage_Load(object sender, EventArgs e)
        {
            // 判断用户是否登录
            if (!IsUserLogin())
            {
                Response.Write("<script>parent.location.href='/login.aspx'</script>");
                Response.End();
            }

            // 判断用户是否可以访问当前url
            if (!CheckUserAccess())
            {
                Response.Write("<script>alert('您没有权限访问');window.close()</script>");
                Response.End();
            }
        }

        /// <summary>
        /// 页面异常捕获记录
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Error(object sender, EventArgs e)
        {
            Exception currentError = Server.GetLastError();

            new EMT.DoneNOW.BLL.ErrorLogBLL().AddLog(LoginUserId, Request.Url.ToString(), currentError.Message, currentError.StackTrace);

            string errorMsg = "抱歉，系统发生错误！<br />";
            Response.Write(errorMsg);
            Server.ClearError();//清除异常(否则将引发全局的Application_Error事件)
        }

        private bool IsUserLogin()
        {
            /*
            //sys_user user = new sys_user { id = 1, email = "liuhai_dsjt@shdsjt.cn", name="刘海", mobile_phone = "18217750743" };
            //sys_user user = new sys_user { id = 2, email = "zhufei_dsjt@shdsjt.cn", name = "朱飞", mobile_phone = "12" };
            //Session["dn_session_user_info"] = user;
            if (Session["dn_session_user_info"] != null)
            {
                userInfo = Session["dn_session_user_info"] as UserInfoDto;
                userPermit = Session["dn_session_user_permits"] as List<AuthPermitDto>;
                return true;
            }
            else
            {
                //检查Cookies
                string username = EMT.Tools.Common.GetCookie("UserName", "DoneNOW");
                string userpwd = EMT.Tools.Common.GetCookie("UserPwd", "DoneNOW");
                if (username != "" && userpwd != "")
                {
                    // TODO: 验证用户名密码
                    return false;
                }
            }
            */

            string token = EMT.Tools.Common.GetCookie("Token", "DoneNOW");
            if (string.IsNullOrEmpty(token))
                return false;

            userInfo = AuthBLL.GetLoginUserInfo(token);
            if (userInfo == null)
                return false;

            userPermit = AuthBLL.GetLoginUserPermit(token);

            return true;
        }

        /// <summary>
        /// 判断用户是否有权限访问当前url
        /// </summary>
        /// <returns></returns>
        private bool CheckUserAccess()
        {
            //return true;
            return AuthBLL.CheckUrlAuth(userInfo.security_Level_id, userPermit, Request.RawUrl);
        }

        /// <summary>
        /// 废弃，不再使用
        /// </summary>
        /// <returns></returns>
        public long GetLoginUserId()
        {
            return userInfo.id;
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

        #region 通用查询的相关权限
        /// <summary>
        /// 获取用户在指定搜索页的需要权限而没有权限的右键菜单
        /// </summary>
        /// <param name="queryType"></param>
        /// <returns></returns>
        protected List<string> GetSearchContextMenu(QueryType queryType)
        {
            return AuthBLL.GetSearchContextMenu(userInfo.security_Level_id, userPermit, queryType);
        }

        /// <summary>
        /// 判断用户在搜索页是否有新增按钮权限
        /// </summary>
        /// <param name="queryType"></param>
        /// <returns></returns>
        protected bool CheckAddAuth(QueryType queryType)
        {
            return AuthBLL.CheckAddAuth(userInfo.security_Level_id, userPermit, queryType);
        }
        #endregion

        #region 表单填充对象
        /// <summary>
        /// 根据当前请求上下文自动填充对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        protected T AssembleModel<T>()
        {
            System.Collections.Specialized.NameValueCollection valueCollection = HttpContext.Current.Request.Form;    // 请求上下文提交的参数
            PropertyInfo[] propertyInfoList = GetPropertyInfoArray(typeof(T));
            if (propertyInfoList == null)
                return default(T);

            object obj = Activator.CreateInstance(typeof(T), null); // 创建指定类型实例
            var propertyList = propertyInfoList.ToList();
            var fieldList = typeof(T).GetFields().ToList();
            //var test = typeof(T).GetNestedTypes();
            //foreach (var item in test)
            //{
            //    Type nestedType = typeof(T).GetNestedType(item.Name);
            //    if (nestedType != null)
            //    {
            //        fieldList.AddRange(nestedType.GetFields());
            //    }
            //}
            foreach (string key in valueCollection.Keys)    // 所有上下文的值
            {
                if (propertyList.Exists(p=>p.Name.ToLower().Equals(key.ToLower())))     // 属性
                {
                    var pro = propertyList.Find(p => p.Name.ToLower().Equals(key.ToLower()));
                    Type t = Nullable.GetUnderlyingType(pro.PropertyType) ?? pro.PropertyType;
                    object value = null;
                    if (valueCollection[key] == null || valueCollection[key].ToString().Equals(""))
                        value = default(T);
                    else
                        value = Convert.ChangeType(valueCollection[key], t);
                    //value = Convert.ChangeType(valueCollection[key],Nullable.GetUnderlyingType(pro.PropertyType)??pro.PropertyType);
                    pro.SetValue(obj, value, null);
                }
                else if (fieldList.Exists(p => p.Name.ToLower().Equals(key.ToLower()))) // 字段
                {
                    var fld = fieldList.Find(p => p.Name.ToLower().Equals(key.ToLower()));
                    Type t = Nullable.GetUnderlyingType(fld.FieldType) ?? fld.FieldType;
                    object value = null;
                    if (valueCollection[key] == null || valueCollection[key].ToString().Equals(""))
                        value = default(T);
                    else
                        value = Convert.ChangeType(valueCollection[key], t);
                    //Object value = Convert.ChangeType(valueCollection[key], Nullable.GetUnderlyingType(fld.FieldType) ?? fld.FieldType);
                    fld.SetValue(obj, value);
                }
            }
            return (T)obj;
        }

        /// <summary>
        /// 反射获取类的属性
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        private PropertyInfo[] GetPropertyInfoArray(Type type)
        {
            PropertyInfo[] props = null;
            try
            {
                object obj = Activator.CreateInstance(type);
                props = type.GetProperties(BindingFlags.Public | BindingFlags.Instance);
            }
            catch (Exception ex)
            {
            }
            return props;
        }
        #endregion
    }
}