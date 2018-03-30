using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System.IO;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class AddRepository : BasePage
    {
        protected List<KnowledgeCateDto> cateList = new KnowledgeBLL().GetKnowledgeCateList();
        protected bool isAdd = true;
        protected sdk_kb_article thisArt = null;
        protected List<d_general> pubList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.KB_PUBLISH_TO_TYPE);
        protected List<d_general> accClassList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.ACCOUNT_TYPE);
        protected List<d_general> accTerrList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TERRITORY);
        protected crm_account thisAccount = null;
        protected long objectId = -1;
        protected List<sdk_kb_article_ticket> kbTicketList = null;
        protected DAL.sdk_task_dal stDal = new DAL.sdk_task_dal();
        protected List<com_attachment> thisNoteAtt = null;   // 这个的附件
        protected void Page_Load(object sender, EventArgs e)
        {
            
            var artId = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(artId))
            {
                thisArt = new DAL.sdk_kb_article_dal().FindNoDeleteById(long.Parse(artId));
            }
            if (thisArt != null)
            {
                isAdd = false;
                if (thisArt.account_id != null)
                    thisAccount = new CompanyBLL().GetCompany((long)thisArt.account_id);
                objectId = thisArt.id;
                thisNoteAtt = new DAL.com_attachment_dal().GetAttListByOid(thisArt.id);
                kbTicketList = new DAL.sdk_kb_article_ticket_dal().GetArtTicket(thisArt.id);
            }
            if (!IsPostBack)
            {
            }
            else
            {
                var param = GetParam();
                var result = new KnowledgeBLL().KnowManage(param,LoginUserId);
                ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');</script>");
                var saveType = Request.Form["SaveType"];
                if (saveType == "SaveClose")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "跳转操作", $"<script>window.close();</script>");
                }
                else if (saveType == "Save")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "跳转操作", $"<script>location.href='AddRepository?id={param.thisArt.id}';</script>");
                }
            }
            
             
        }
        /// <summary>
        /// 获取相关参数
        /// </summary>
        public KnowledgeManageDto GetParam()
        {
            KnowledgeManageDto param = new KnowledgeManageDto();
            var pageArt = AssembleModel<sdk_kb_article>();
            var isActive = Request.Form["Active"];
            if(!string.IsNullOrEmpty(isActive)&& isActive.Equals("on"))
                pageArt.is_active = 1;
            else
                pageArt.is_active = 0;
            //var articleBody = Request.Form["articleBody"];
            //pageArt.article_body = articleBody;
            if (string.IsNullOrEmpty(pageArt.keywords))
                pageArt.keywords = "";
            if (string.IsNullOrEmpty(pageArt.error_code))
                pageArt.error_code = "";
            if (pageArt.publish_to_type_id == (int)DTO.DicEnum.KB_PUBLISH_TYPE.INTER_USER_ACCOUNT)
            {
                pageArt.classification_id = null;
                pageArt.territory_id = null;
            }
            else if(pageArt.publish_to_type_id == (int)DTO.DicEnum.KB_PUBLISH_TYPE.INTER_USER_CLASS)
            {
                pageArt.account_id = null;
                pageArt.territory_id = null;
            }
            else if (pageArt.publish_to_type_id == (int)DTO.DicEnum.KB_PUBLISH_TYPE.INTER_USER_TERR)
            {
                pageArt.classification_id = null;
                pageArt.account_id = null;
            }
            else
            {
                pageArt.classification_id = null;
                pageArt.account_id = null;
                pageArt.territory_id = null;
            }
            if (isAdd)
            {
                param.thisArt = pageArt;
            }
            else
            {
                thisArt.is_active = pageArt.is_active;
                thisArt.kb_category_id = pageArt.kb_category_id;
                thisArt.title = pageArt.title;
                thisArt.keywords = pageArt.keywords;
                thisArt.error_code = pageArt.error_code;
                thisArt.article_body = pageArt.article_body;
                thisArt.article_body_no_markup = pageArt.article_body_no_markup;
                thisArt.view_count = pageArt.view_count;
                thisArt.publish_to_type_id = pageArt.publish_to_type_id;
                thisArt.account_id = pageArt.account_id;
                thisArt.classification_id = pageArt.classification_id;
                thisArt.territory_id = pageArt.territory_id;
                param.thisArt = thisArt;
            }
            param.attIds = Request.Form["attIds"];
            param.filtList = GetSessAttList(objectId);
            param.ticketId = Request.Form["TicketIds"];
            return param;
        }


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

        protected String HumanReadableFilesize(double size)
        {
            String[] units = new String[] { "B", "KB", "MB", "GB", "TB", "PB" };
            double mod = 1024.0;
            int i = 0;
            while (size >= mod)
            {
                size /= mod;
                i++;
            }
            return Math.Round(size) + units[i];
        }

    }
}