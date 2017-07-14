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
            foreach (string key in valueCollection.Keys)    // 所有上下文的值
            {
                if (propertyList.Exists(p=>p.Name.ToLower().Equals(key.ToLower())))     // 属性
                {
                    propertyList.Find(p => p.Name.ToLower().Equals(key.ToLower())).SetValue(obj, valueCollection[key], null);
                }
                else if (fieldList.Exists(p => p.Name.ToLower().Equals(key.ToLower()))) // 字段
                {
                    fieldList.Find(p => p.Name.ToLower().Equals(key.ToLower())).SetValue(obj, valueCollection[key]);
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