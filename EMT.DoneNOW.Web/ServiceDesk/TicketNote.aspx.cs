using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using System.IO;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class TicketNote : BasePage
    {
        protected crm_account thisAccount = null;
        protected sdk_task thisTicket = null;
        protected ctt_contract thisContract = null;
        protected crm_contact thisContact = null;
        protected com_activity thisNote = null;
        protected bool isAdd = true;
        protected List<com_attachment> thisNoteAtt = null;   // 这个备注的附件
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected sys_resource thisUser = null;
        protected sys_resource thisAccManger;    // 客户经理
        protected d_general sys_email = new d_general_dal().FindNoDeleteById((int)DicEnum.SUPPORT_EMAIL.SYS_EMAIL);
        protected sys_resource ticket_creator = null;
        protected long object_id;      // 传进来的对象ID （项目或者任务）
        protected pro_project thisProject = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            thisUser = new sys_resource_dal().FindNoDeleteById(GetLoginUserId());
            var caDal = new com_activity_dal();
            var stDal = new sdk_task_dal();
            var ppDal = new pro_project_dal();
            var accDal = new crm_account_dal();
            var ccDal = new ctt_contract_dal();
            var id = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
            {
                thisNote = caDal.FindNoDeleteById(long.Parse(id));
                if (thisNote != null)
                {
                    isAdd = false;

                    thisNoteAtt = new com_attachment_dal().GetAttListByOid(thisNote.id);

                    thisTicket = stDal.FindNoDeleteById(thisNote.object_id);
                    if (thisTicket != null)
                    {
                        object_id = thisTicket.id;
                    }
                    else
                    {
                        thisProject = ppDal.FindNoDeleteById(thisNote.object_id);
                        if (thisProject != null)
                        {
                            object_id = thisProject.id;
                            thisAccount = accDal.FindNoDeleteById(thisProject.account_id);
                        }
                        else
                        {
                            thisContract = ccDal.FindNoDeleteById(thisNote.object_id);
                            if (thisContract != null)
                            {
                                object_id = thisContract.id;
                                thisAccount = accDal.FindNoDeleteById(thisContract.account_id);
                            }
                        }
                    }

                }
            }

            var ticketId = Request.QueryString["ticket_id"];
            if (!string.IsNullOrEmpty(ticketId))
            {
                thisTicket = stDal.FindNoDeleteById(long.Parse(ticketId));
            }
            if (thisTicket != null)
            {
                object_id = thisTicket.id;
                if (thisTicket.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE)
                {
                    // isPhase = true;
                }
                if (thisTicket.contact_id != null)
                {
                    thisContact = new crm_contact_dal().FindNoDeleteById((long)thisTicket.contact_id);
                }
                thisAccount = accDal.FindNoDeleteById(thisTicket.account_id);
                ticket_creator = new sys_resource_dal().FindNoDeleteById(thisTicket.create_user_id);
                if (!IsPostBack)
                {
                    //status_id.SelectedValue = thisTicket.status_id.ToString();
                }

                if (thisTicket.project_id != null)
                {
                    thisProject = ppDal.FindNoDeleteById((long)thisTicket.project_id);
                    if (thisProject != null&& thisAccount!=null)
                    {
                        thisAccount = accDal.FindNoDeleteById(thisProject.account_id);
                    }
                }
            }
            if (thisAccount == null)
            {
                Response.End();
            }
            else
            {
                if (thisAccount.resource_id != null)
                {
                    thisAccManger = new sys_resource_dal().FindNoDeleteById((long)thisAccount.resource_id);
                }
            }

            if (!IsPostBack)
            {
                publish_type_id.DataTextField = "name";
                publish_type_id.DataValueField = "id";
                var pushList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.NOTE_PUBLISH_TYPE);
                if (pushList != null && pushList.Count > 0)
                {
                    pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TICKET_NOTE).ToString()).ToList();
                }
                publish_type_id.DataSource = pushList;
                publish_type_id.DataBind();

                status_id.DataTextField = "show";
                status_id.DataValueField = "val";
                status_id.DataSource = dic.FirstOrDefault(_ => _.Key == "ticket_status").Value;
                status_id.DataBind();
                if (thisTicket != null)
                {
                    status_id.SelectedValue = thisTicket.status_id.ToString();
                }

                action_type_id.DataTextField = "name";
                action_type_id.DataValueField = "id";
                var actList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.ACTION_TYPE);
                actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();
                action_type_id.DataSource = actList;
                action_type_id.DataBind();


                if (thisNote != null)
                {
                    if (!IsPostBack)
                    {
                        if (thisNote.publish_type_id != null)
                        {
                            publish_type_id.SelectedValue = thisNote.publish_type_id.ToString();
                        }
                        action_type_id.SelectedValue = thisNote.action_type_id.ToString();
                    }
                }
                //else
                //{
                //    if (isContract)
                //    {
                //        publish_type_id.SelectedValue = ((int)DicEnum.NOTE_PUBLISH_TYPE.CONTRACT_INTERNA_USER).ToString();
                //    }
                //}

                var tempList = new sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.NONE);
                notify_id.DataTextField = "name";
                notify_id.DataValueField = "id";
                notify_id.DataSource = tempList;
                notify_id.DataBind();

            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {

        }

        protected void save_new_Click(object sender, EventArgs e)
        {

        }

        protected void save_modify_Click(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// 根据任务Id获取相关缓存文件(新增备注附件)
        /// </summary>
        private List<AddFileDto> GetSessAttList(long object_id)
        {

            var attList = Session[object_id + "_Att"] as List<AddFileDto>;
            if (attList != null && attList.Count > 0)
            {
                foreach (var thisAtt in attList)
                {
                    if (thisAtt.type_id == ((int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())
                    {
                        string saveFilename = "";

                        try
                        {
                            SavePic(thisAtt, out saveFilename);
                        }
                        catch (Exception msg)
                        {
                            continue;
                        }
                        thisAtt.fileSaveName = saveFilename;

                    }
                }
            }
            return attList;
        }



        private string SavePic(AddFileDto thisAttDto, out string saveFileName)
        {
            saveFileName = "";
            string fileExtension = Path.GetExtension(thisAttDto.old_filename).ToLower();    //取得文件的扩展名,并转换成小写
            string filepath = $"/Upload/Attachment/{DateTime.Now.ToString("yyyyMM")}/";
            if (Directory.Exists(Server.MapPath(filepath)) == false)    //如果不存在就创建文件夹
            {
                Directory.CreateDirectory(Server.MapPath(filepath));
            }
            string virpath = filepath + Guid.NewGuid().ToString() + fileExtension;//这是存到服务器上的虚拟路径
            string mappath = Server.MapPath(virpath);//转换成服务器上的物理路径
            //FileStream fs = new FileStream(oldPath, FileMode.Open, FileAccess.ReadWrite);
            File.WriteAllBytes(mappath, thisAttDto.files as Byte[]);
            //  fileForm.SaveAs(mappath);//保存图片
            //fs.Close();
            saveFileName = virpath;
            return "";
        }
    }
}