using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.Tools;
using System.Reflection;

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

        public bool IsUserLogin()
        {
            if (Session["dn_session_user_info"] != null)
            {
                return true;
            }
            else
            {
                //检查Cookies
                string username = Common.GetCookie("UserName", "DoneNOW");
                string userpwd = Common.GetCookie("UserPwd", "DoneNOW");
                if (username != "" && userpwd != "")
                {
                    // TODO: 验证用户名密码
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// 根据NameValueCollection 自动装配
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
            foreach (string key in valueCollection.Keys)    // 所有上下文的值
            {
                foreach (var PropertyInfo in propertyInfoList)  // 所有实体属性
                {
                    if (key.ToLower() == PropertyInfo.Name.ToLower())
                    {
                        PropertyInfo.SetValue(obj, valueCollection[key], null); // 给对象赋值
                    }
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
    }
}