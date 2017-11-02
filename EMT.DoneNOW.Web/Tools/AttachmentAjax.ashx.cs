using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System.Text;
using System.IO;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// AttachmentAjax 的摘要说明
    /// </summary>
    public class AttachmentAjax : IHttpHandler, IRequiresSessionState
    {
        private AttachmentBLL bll = new AttachmentBLL();
        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "DeleteAttachment":
                        DeleteAttachment(context);
                        break;
                    case "OpenAttachment":
                        OpenAttachment(context);
                        break;
                    default:
                        break;
                }
            }
            catch (Exception)
            {
                context.Response.Write("{\"code\": 'error', \"msg\": \"参数错误！\"}");
            }
        }
        
        /// <summary>
        /// 删除附件
        /// </summary>
        /// <param name="context"></param>
        private void DeleteAttachment(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            bll.DeleteAttachment(id, (context.Session["dn_session_user_info"] as sys_user).id);
            context.Response.Write(new Tools.Serialize().SerializeJson(true));
        }

        /// <summary>
        /// 打开附件
        /// </summary>
        /// <param name="context"></param>
        private void OpenAttachment(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            var att = bll.GetAttachment(id);
            if (att.type_id==(int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT)
            {
                FileStream fs = new FileStream(context.Server.MapPath(att.href), FileMode.Open);
                byte[] bytes = new byte[(int)fs.Length];
                fs.Read(bytes, 0, bytes.Length);
                fs.Close();

                context.Response.AddHeader("Content-Disposition", "attachment;  filename=" + HttpUtility.UrlEncode(att.filename, Encoding.UTF8));
                context.Response.ContentEncoding = Encoding.UTF8;
                context.Response.ContentType = "application/octet-stream";
                context.Response.BinaryWrite(bytes);
                context.Response.Buffer = true;
                context.Response.Flush();
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