using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using System.IO;
using System.Text;

namespace EMT.DoneNOW.Web.Activity
{
    public partial class OpenAttachment : BasePage
    {
        protected string filePath = null;
        private AttachmentBLL bll = new AttachmentBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            long id = long.Parse(Request.QueryString["id"]);
            var att = bll.GetAttachment(id);
            if (att.type_id == (int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT)
            {
                FileStream fs = new FileStream(Server.MapPath(att.href), FileMode.Open);
                byte[] bytes = new byte[(int)fs.Length];
                fs.Read(bytes, 0, bytes.Length);
                fs.Close();

                Response.AddHeader("Content-Disposition", "attachment;  filename=" + HttpUtility.UrlEncode(att.filename, Encoding.UTF8));
                Response.ContentEncoding = Encoding.UTF8;
                Response.ContentType = "application/octet-stream";
                Response.BinaryWrite(bytes);
                Response.Buffer = true;
                Response.Flush();
            }
            else if (att.type_id == (int)DicEnum.ATTACHMENT_TYPE.URL)
            {
                Response.Redirect(att.filename);
            }
            else if (att.type_id == (int)DicEnum.ATTACHMENT_TYPE.FILE_LINK
                || att.type_id == (int)DicEnum.ATTACHMENT_TYPE.FOLDER_LINK)
            {
                filePath = att.filename;
            }
        }
    }
}