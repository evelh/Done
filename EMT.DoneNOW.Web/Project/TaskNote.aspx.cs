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

namespace EMT.DoneNOW.Web.Project
{
    public partial class TaskNote : BasePage
    {
        protected crm_account thisAccount = null;
        protected sdk_task thisTask = null;
        protected sdk_task thisTicket = null;
        protected ctt_contract thisContract = null;
        protected com_activity thisNote = null;
        protected crm_contact thisContact = null;
        protected bool isAdd = true;
        protected List<com_attachment> thisNoteAtt = null;   // 这个备注的附件
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected sys_resource thisUser = null;
        protected sys_resource thisAccManger;    // 客户经理
        protected d_general sys_email = new d_general_dal().FindNoDeleteById((int)DicEnum.SUPPORT_EMAIL.SYS_EMAIL);
        protected sys_resource task_creator = null;
        protected long object_id;      // 传进来的对象ID （项目,任务,阶段，合同，工单）
        protected bool isProject = false;   // 是否是项目
        protected bool isPhase = false;     // 是否是阶段
        protected bool isContract = false;  // 是否是合同
        protected bool isTicket = false;    // 是否是工单
        protected bool isHasIncident = false;  // 工单使用 ，工单是否关联事故 
        protected pro_project thisProject = null;
        protected bool isCall = false;      // 是否时服务预定  -- 为服务预定下的工单批量添加备注
        protected sdk_service_call thisCall = null;  // 服务预定
        protected List<sdk_task> callTicketList = null;  // 服务预定下的工单
        protected bool isMantStatus = false;   // 工单是否具有多个状态
        protected bool isManyAccount = false;
        protected bool isManyTitle = false;
        protected List<sys_form_tmpl> tmplList;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
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
                        
                        thisTask = stDal.FindNoDeleteById(thisNote.object_id);
                        if (thisTask != null)
                        {
                            object_id = thisTask.id;
                            if (thisTask.type_id == (int)DicEnum.TASK_TYPE.SERVICE_DESK_TICKET)
                            {
                                isTicket = true;
                                thisTask = null;
                                thisTicket = stDal.FindNoDeleteById(thisNote.object_id);
                            }
                        }
                        else
                        {
                            thisProject = ppDal.FindNoDeleteById(thisNote.object_id);
                            if (thisProject != null)
                            {
                                isProject = true;
                                object_id = thisProject.id;
                                thisAccount = accDal.FindNoDeleteById(thisProject.account_id);
                            }
                            else
                            {
                                thisContract = ccDal.FindNoDeleteById(thisNote.object_id);
                                if (thisContract != null)
                                {
                                    isContract = true;
                                    object_id = thisContract.id;
                                    thisAccount = accDal.FindNoDeleteById(thisContract.account_id);
                                }
                            }
                        }

                    }
                }
                var taskId = Request.QueryString["task_id"];
                var project_id = Request.QueryString["project_id"];
                var contract_id = Request.QueryString["contract_id"];
                var ticket_id = Request.QueryString["ticket_id"];
                var call_id = Request.QueryString["call_id"];
                if (!string.IsNullOrEmpty(taskId))
                {
                    thisTask = stDal.FindNoDeleteById(long.Parse(taskId));
                }
                else if (!string.IsNullOrEmpty(project_id))
                {
                    thisProject = ppDal.FindNoDeleteById(long.Parse(project_id));
                    if (thisProject != null)
                    {
                        isProject = true;
                        object_id = thisProject.id;
                        thisAccount = accDal.FindNoDeleteById(thisProject.account_id);
                    }
                }
                else if (!string.IsNullOrEmpty(contract_id))
                {
                    thisContract = ccDal.FindNoDeleteById(long.Parse(contract_id));
                    if (thisContract != null)
                    {
                        object_id = thisContract.id;
                        thisAccount = accDal.FindNoDeleteById(thisContract.account_id);
                        isContract = true;
                    }
                }
                else if (!string.IsNullOrEmpty(ticket_id))
                {
                    thisTicket = stDal.FindNoDeleteById(long.Parse(ticket_id));
                }
                else if (!string.IsNullOrEmpty(call_id))
                {
                    thisCall = new sdk_service_call_dal().FindNoDeleteById(long.Parse(call_id));
                    if (thisCall != null)
                    {
                        isCall = true;
                        thisAccount = new CompanyBLL().GetCompany(thisCall.account_id);
                        callTicketList = stDal.GetTciketByCall(thisCall.id);
                        if(callTicketList!=null&& callTicketList.Count > 0)
                        {
                            thisTask = callTicketList[0];
                            if (callTicketList.Any(_ => _.id != thisTask.id && _.status_id != thisTask.status_id))
                                isMantStatus = true;
                            if (callTicketList.Any(_ => _.id != thisTask.id && _.account_id != thisTask.account_id))
                                isManyAccount = true;
                            if (callTicketList.Any(_ => _.id != thisTask.id && _.title != thisTask.title))
                                isManyTitle = true;
                        }
                        else
                        {
                            Response.Write("<script>alert('服务预定下暂无工单！');window.close();</script>");
                            return;
                        }
                    }
                }


                if (thisTask != null)
                {
                    thisAccount = accDal.FindNoDeleteById(thisTask.account_id);
                    object_id = thisTask.id;
                    if (thisTask.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE)
                    {
                        isPhase = true;
                    }
                    task_creator = new sys_resource_dal().FindNoDeleteById(thisTask.create_user_id);
                    if (thisTask.project_id != null)
                    {
                        thisProject = ppDal.FindNoDeleteById((long)thisTask.project_id);
                        if (thisProject != null)
                        {
                            thisAccount = accDal.FindNoDeleteById(thisProject.account_id);
                        }
                    }
                }
                if (thisTicket != null)
                {
                    isTicket = true;
                    object_id = thisTicket.id;
                    task_creator = new sys_resource_dal().FindNoDeleteById(thisTicket.create_user_id);
                    thisAccount = accDal.FindNoDeleteById(thisTicket.account_id);
                    if (thisTicket.contact_id != null)
                    {
                        thisContact = new crm_contact_dal().FindNoDeleteById((long)thisTicket.contact_id);
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
                        if (isProject)
                            pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.PROJECT_NOTE).ToString()).ToList();
                        else if (isContract)
                            pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.CONTRACT_NOTE).ToString()).ToList();
                        else if (isTicket)
                            pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();
                        else
                            pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();
                    }
                    publish_type_id.DataSource = pushList;
                    publish_type_id.DataBind();

                    status_id.DataTextField = "show";
                    status_id.DataValueField = "val";
                    var statusList = dic.FirstOrDefault(_ => _.Key == "ticket_status").Value as List<DictionaryEntryDto>;
                    if (isMantStatus)
                        statusList.Add(new DictionaryEntryDto() {val="0",show="多个值，保持不变" });
                    status_id.DataSource = statusList;
                    status_id.DataBind();
                    if (isMantStatus)
                        status_id.SelectedValue = "0";
                    else if (thisTask != null)
                        status_id.SelectedValue = thisTask.status_id.ToString();
                    else if (thisTicket != null)
                        status_id.SelectedValue = thisTicket.status_id.ToString();
                    action_type_id.DataTextField = "name";
                    action_type_id.DataValueField = "id";
                    var actList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.ACTION_TYPE);
                    if (actList != null && actList.Count > 0)
                    {
                        if (isProject)
                            actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.PROJECT_NOTE).ToString()).ToList();
                        else if (isContract)
                            actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.CONTRACT_NOTE).ToString()).ToList();
                        else if (isTicket)
                            actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();
                        else
                            actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();
                    }
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
                            isAnnounce.Checked = thisNote.announce == 1;
                        }
                    }
                    else
                    {
                        if (isContract)
                        {
                            publish_type_id.SelectedValue = ((int)DicEnum.NOTE_PUBLISH_TYPE.CONTRACT_INTERNA_USER).ToString();
                        }
                    }

                    var tempList = new sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.NONE);
                    notify_id.DataTextField = "name";
                    notify_id.DataValueField = "id";
                    notify_id.DataSource = tempList;
                    notify_id.DataBind();

                }

                if(isProject)
                    tmplList = new FormTemplateBLL().GetTmplByType((int)DicEnum.FORM_TMPL_TYPE.PROJECT_NOTE, LoginUserId);
                else if(isTicket&&thisTicket!=null)
                    tmplList = new FormTemplateBLL().GetTmplByType((int)DicEnum.FORM_TMPL_TYPE.TICKET_NOTE, LoginUserId);
                else if(thisTask!=null)
                    tmplList = new FormTemplateBLL().GetTmplByType((int)DicEnum.FORM_TMPL_TYPE.TASK_NOTE, LoginUserId);
            }
            catch (Exception msg)
            {
                Response.Write(msg);
                Response.End();
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var result = false;
            if (isAdd)
            {
                if (isCall)
                    result = new TaskBLL().AddCallTaskNote(param, LoginUserId); 
                else
                    result = new TaskBLL().AddTaskNote(param, LoginUserId);
            }
            else
                result =  new TaskBLL().EditTaskNote(param, GetLoginUserId());
           
            // 操作完成，清除session暂存
            Session.Remove(object_id + "_Att");
            //if (result)
            //{
            var func = Request.QueryString["noFunc"];
            if (!string.IsNullOrEmpty(func))
                ClientScript.RegisterStartupScript(this.GetType(), "父窗口事件", $"<script>self.opener.location.{func}();</script>");
            else
                ClientScript.RegisterStartupScript(this.GetType(), "父窗口事件", "<script>self.opener.location.reload();</script>");
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>window.close();</script>");



        }

        private TaskNoteDto GetParam()
        {
            TaskNoteDto param = new TaskNoteDto();
            var pageTaskNote = AssembleModel<com_activity>();
            pageTaskNote.account_id = thisAccount.id;
            if (thisProject != null)
            {
                pageTaskNote.resource_id = thisProject.owner_resource_id;
                pageTaskNote.contract_id = thisProject.contract_id;
            }
            else if (thisContract != null)
            {
                //    pageTaskNote.resource_id = thisContract.res;
                pageTaskNote.contract_id = thisContract.id;
            }else if (thisCall != null)
            {
                param.thisCall = thisCall;
            }


            if (isProject)
                pageTaskNote.announce = (sbyte)(isAnnounce.Checked ? 1 : 0);
            if (isAdd)
            {

            }
            else
            {
                param.attIds = Request.Form["attIds"];
                thisNote.action_type_id = pageTaskNote.action_type_id;
                thisNote.publish_type_id = pageTaskNote.publish_type_id;
                thisNote.name = pageTaskNote.name;
                thisNote.description = pageTaskNote.description;
                if (isProject)
                    thisNote.announce = pageTaskNote.announce;
            }
            var status_id = Request.Form["status_id"];
            if (!string.IsNullOrEmpty(status_id))
            {
                param.status_id = int.Parse(status_id);
            }
            param.incloNoteDes = CKIncluDes.Checked;
            param.incloNoteAtt = CKIncloAtt.Checked;
            param.toCrea = CKcreate.Checked;
            param.toAccMan = CKaccMan.Checked;
            param.ccMe = CCMe.Checked;
            param.fromSys = Cksys.Checked;
            param.thisTask = thisTask;
            param.thisProjetc = thisProject;
            param.thisTicket = thisTicket;
            param.object_id = object_id;
            param.filtList = GetSessAttList(object_id);
            if (!string.IsNullOrEmpty(Request.Form["CkAccTeam"]))
            {
                param.toAccTeam = true;
            }
            if (!string.IsNullOrEmpty(Request.Form["CkPriRes"]))
            {
                param.toPriRes = true;
            }
            if (!string.IsNullOrEmpty(Request.Form["CkOtherRes"]))
            {
                param.toOtherRes = true;
            }
            if (!string.IsNullOrEmpty(Request.Form["AppResol"]))
            {
                param.isAddSol = true;
            }
            if (isAdd)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["CkAddAll"]))
                {
                    param.isAddAllNote = true;
                }
                if (!string.IsNullOrEmpty(Request.QueryString["AppAllResol"]))
                {
                    param.isAddAllSol = true;
                }
            }
           
            if (thisTask != null)
            {
                pageTaskNote.cate_id = (int)DicEnum.ACTIVITY_CATE.TASK_NOTE;
                pageTaskNote.object_type_id = (int)DicEnum.OBJECT_TYPE.TASK;
            }
            else if (thisProject != null)
            {
                pageTaskNote.cate_id = (int)DicEnum.ACTIVITY_CATE.PROJECT_NOTE;
                pageTaskNote.object_type_id = (int)DicEnum.OBJECT_TYPE.PROJECT;
            }
            else if (thisContract != null)
            {
                pageTaskNote.cate_id = (int)DicEnum.ACTIVITY_CATE.CONTRACT_NOTE;
                pageTaskNote.object_type_id = (int)DicEnum.OBJECT_TYPE.CONTRACT;
            }
            else if (thisTicket != null)
            {
                pageTaskNote.cate_id = (int)DicEnum.ACTIVITY_CATE.TICKET_NOTE;
                pageTaskNote.object_type_id = (int)DicEnum.OBJECT_TYPE.TICKETS;
            }

            if (isAdd)
            {
                param.taskNote = pageTaskNote;
            }
            else
            {
                param.taskNote = thisNote;

            }
            
            
            param.otherEmail = Request.Form["otherEmail"];
            param.subjects = Request.Form["subjects"];
            param.AdditionalText = Request.Form["AdditionalText"];
            if (!string.IsNullOrEmpty(Request.Form["notify_id"]))
            {
                param.notify_id = int.Parse(Request.Form["notify_id"]);
            }
            param.account_id = thisAccount.id;
            return param;
        }

        /// <summary>
        /// 根据任务Id获取相关缓存文件(新增备注附件)
        /// </summary>
        private List<AddFileDto> GetSessAttList(long task_id)
        {
            
            var attList = Session[task_id + "_Att"] as List<AddFileDto>;
            if(attList!=null&& attList.Count > 0)
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

        protected void save_new_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var result = false;
            if (isAdd)
            {
                if (isCall)
                    result = new TaskBLL().AddCallTaskNote(param, LoginUserId);
                else
                    result = new TaskBLL().AddTaskNote(param, LoginUserId);
            }
            else
                result = new TaskBLL().EditTaskNote(param, GetLoginUserId());
            Session.Remove(object_id + "_Att");
            if (thisTicket != null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "页面跳转", $"<script>location.href='../Project/TaskNote?ticket_id={thisTicket.id.ToString()}';self.opener.location.reload();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>window.close();self.opener.location.reload();</script>");
            }
        }

        protected void save_modify_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var result = false;
            if (isAdd)
            {
                result = new TaskBLL().AddTaskNote(param, GetLoginUserId());
            }
            else
            {
                result = new TaskBLL().EditTaskNote(param, GetLoginUserId());
            }
            Session.Remove(object_id + "_Att");
            if (thisTicket != null)
            {
                // todo 跳转到 前进/修改页面
                ClientScript.RegisterStartupScript(this.GetType(), "页面跳转", $"<script>window.close();self.opener.location.reload();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>window.close();self.opener.location.reload();</script>");
            }
        }
    }
}