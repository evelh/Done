using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;


namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class KnowledgebaseDetail : BasePage
    {
        protected sdk_kb_article thisArt = null;
        protected string cataString = "";
        protected d_general publish = null;
        protected sys_resource creater = null;
        protected sys_resource update = null;
        protected CompanyBLL comBLL = new CompanyBLL();
        protected DAL.sdk_task_dal dtDal = new DAL.sdk_task_dal();
        protected List<sdk_kb_article_ticket> ticList = null;
        protected List<com_attachment> thisNoteAtt = null;   // 这个的附件
        protected List<sdk_kb_article_comment> commList = null;
        protected DAL.sys_resource_dal srDal = new DAL.sys_resource_dal();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var artId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(artId))
                {
                    thisArt = new DAL.sdk_kb_article_dal().FindNoDeleteById(long.Parse(artId));
                }
                if (thisArt == null)
                {
                    Response.Write($"<script>alert('未查询到该知识库！');window.close();</script>");
                    return;
                }
                var dgDal = new DAL.d_general_dal();
                cataString = new KnowledgeBLL().GetCateString(thisArt.kb_category_id, cataString);
                if (!string.IsNullOrEmpty(cataString))
                    cataString = cataString.Substring(0, cataString.Length-1);
                publish = dgDal.FindNoDeleteById((long)thisArt.publish_to_type_id);
                creater = srDal.FindById(thisArt.create_user_id);
                update = srDal.FindById(thisArt.update_user_id);
                ticList = new DAL.sdk_kb_article_ticket_dal().GetArtTicket(thisArt.id);
                thisNoteAtt = new DAL.com_attachment_dal().GetAttListByOid(thisArt.id);
                commList = new DAL.sdk_kb_article_comment_dal().GetCommByArt(thisArt.id);

                var history = new sys_windows_history() {
                    title = "知识库文档:"+ thisArt.title,
                    url = Request.RawUrl,
                };
                new IndexBLL().BrowseHistory(history,LoginUserId);
            }
            catch (Exception msg)
            {
                Response.Write($"<script>alert('{msg.Message}');window.close();</script>");
            }
        }
    }
}