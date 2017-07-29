using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.Tools;
using EMT.DoneNOW.DAL;
using System.Text;
using System.Web.SessionState;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ContactAjax 的摘要说明
    /// </summary>
    public class ContactAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "delete":
                        var contact_id = context.Request.QueryString["id"];
                        DeleteContact(context,Convert.ToInt64(contact_id));
                        break;
                    default:
                        break;
                }
            }
            catch (Exception)
            {

                context.Response.End();
            }
        }

        /// <summary>
        /// 删除联系人的事件
        /// </summary>
        /// <param name="context"></param>
        /// <param name="contact_id"></param>
        public void DeleteContact(HttpContext context,long contact_id)
        {
            var res = context.Session["dn_session_user_info"];
            if (res != null)
            {
                var user = res as sys_user;
                var result = new ContactBLL().DeleteContact(contact_id, user.id);

                if (result)
                {
                    context.Response.Write("删除联系人成功！");
                }
                else
                {
                    context.Response.Write("删除联系人失败！");
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