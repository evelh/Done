using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using System.IO;

namespace EMT.DoneNOW.Web.Project
{
    public partial class AddTaskAttach : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    type_id.DataTextField = "show";
                    type_id.DataValueField = "val";
                    type_id.DataSource = new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.ATTACHMENT_TYPE));
                    type_id.DataBind();

                }
            }
            catch (Exception msg)
            {
                Response.End();
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            SaveSession();
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>window.close();window.opener.ReloadSession();</script>");
        }
        private void SaveSession()
        {
            var type_id = Request.Form["type_id"];
            var name = Request.Form["name"];
            var file = Request.Files["attFile"];
            var attLink = Request.Form["attLink"];
            if (!string.IsNullOrEmpty(type_id) && !string.IsNullOrEmpty(name))
            {
           
                var objectId = Request.QueryString["object_id"];
                if (!string.IsNullOrEmpty(objectId))
                {
                    var thisDto = new AddFileDto();
                    if (type_id == ((int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())
                    {
                        if (file != null && file.ContentLength < (10 << 20))
                        {
                            //FileStream fs = new FileStream(Request.Form["old_file_path"], FileMode.Open, FileAccess.Read);
                        
                            thisDto.type_id = type_id;
                            thisDto.old_filename = file.FileName;
                            thisDto.new_filename = name;
                            thisDto.conType = file.ContentType;
                            thisDto.Size = file.ContentLength;
                            // thisDto.files = file;
                            Stream fileDataStream = file.InputStream;
                            byte[] buffur = new byte[file.ContentLength];
                            fileDataStream.Read(buffur, 0, file.ContentLength);
                            //fs.Read(buffur, 0, (int)fs.Length);
                            //thisDto.old_file_path = Request.Form["old_file_path"];
                            //fs.Close();
                            thisDto.files = buffur;
                        }
                        
                    }
                    else
                    {
                        thisDto.type_id = type_id;
                        thisDto.old_filename = attLink;
                        thisDto.new_filename = name;
                        thisDto.files = attLink;
                    }


                   
                    
                    var sesNum = Session[objectId + "_Att"] as List<AddFileDto>;
                    if (sesNum != null && sesNum.Count > 0)
                    {
                        sesNum.Add(thisDto);
                        Session[objectId + "_Att"] = sesNum;
                    }
                    else
                    {

                        Session[objectId + "_Att"] = new List<AddFileDto>() { thisDto };
                        // 需要存四个属性，类型，原文件名，新文件名，类型，文件流

                    }
                }
            }
           
        }

        protected void save_new_Click(object sender, EventArgs e)
        {
            SaveSession();
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>location.href='AddTaskAttach?object_id="+Request.QueryString["object_id"] +"';window.opener.ReloadSession();</script>");
        }
    }
  
}