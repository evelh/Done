using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.Tools;
using System.Reflection;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web
{
    public class BasePage : System.Web.UI.Page
    {
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
        }

        /// <summary>
        /// 页面异常捕获记录
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Error(object sender, EventArgs e)
        {
            Exception currentError = Server.GetLastError();

            new EMT.DoneNOW.BLL.ErrorLogBLL().AddLog(GetLoginUserId(), Request.Url.ToString(), currentError.Message, currentError.StackTrace);

            string errorMsg = "抱歉，系统发生错误！<br />";
            Response.Write(errorMsg);
            Server.ClearError();//清除异常(否则将引发全局的Application_Error事件)
        }

        public bool IsUserLogin()
        {
            sys_user user = new sys_user { id = 1, email = "liuhai_dsjt@shdsjt.cn", name="刘海", mobile_phone = "18217750743" };
            //sys_user user = new sys_user { id = 2, email = "zhufei_dsjt@shdsjt.cn", name = "朱飞", mobile_phone = "12" };
            Session["dn_session_user_info"] = user;
            if (Session["dn_session_user_info"] != null)
            {
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
            return false;
        }

        public long GetLoginUserId()
        {
            sys_user user = Session["dn_session_user_info"] as sys_user;
            return user.id;
        }

        #region 表单填充对象
        /// <summary>
        /// 根据当前请求上下文自动填充对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        protected T AssembleModel<T>()
        {
            System.Collections.Specialized.NameValueCollection valueCollection = HttpContext.Current.Request.Params;    // 请求上下文提交的参数
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