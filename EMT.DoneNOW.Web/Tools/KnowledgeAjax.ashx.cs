using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// KnowledgeAjax 的摘要说明
    /// </summary>
    public class KnowledgeAjax : BaseAjax
    {
        protected BLL.KnowledgeBLL bll = new BLL.KnowledgeBLL();
        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "SaveComment":
                    SaveComment(context);
                    break;
                case "DeleteComment":
                    DeleteComment(context);
                    break;
                case "DeleteArt":
                    DeleteArt(context);
                    break;
                case "KnowMenuManage":
                    KnowMenuManage(context);
                    break;
                case "DeleteKnowMenu":
                    DeleteKnowMenu(context);
                    break;
                default:
                    break;
            }
        }
        /// <summary>
        /// 保存评论
        /// </summary>
        public void SaveComment(HttpContext context)
        {
            var artId = context.Request.QueryString["artId"];
            var comment = context.Request.QueryString["comment"];
            var res = false;
            if (!string.IsNullOrEmpty(artId) && !string.IsNullOrEmpty(comment))
                res = bll.SaveComment(long.Parse(artId),comment,LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(res));
        }
        /// <summary>
        /// 删除评论
        /// </summary>
        public void DeleteComment(HttpContext context)
        {
            var artComId = context.Request.QueryString["artComId"];
            var res = false;
            if (!string.IsNullOrEmpty(artComId))
                res = bll.DeleteComment(long.Parse(artComId), LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(res));
        }

        /// <summary>
        /// 删除知识库
        /// </summary>
        public void DeleteArt(HttpContext context)
        {
            var artId = context.Request.QueryString["artId"];
            var res = false;
            if (!string.IsNullOrEmpty(artId))
                res = bll.DeleteKnow(long.Parse(artId), LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(res));
        }

        public void KnowMenuManage(HttpContext context)
        {
            var name = context.Request.QueryString["name"];
            var parentId = context.Request.QueryString["parentId"];
            var id = context.Request.QueryString["id"];
            var res = false;
            string faileReason = "";
            if(!string.IsNullOrEmpty(id))
                res = bll.EditKnowMenu(long.Parse(id), name, int.Parse(parentId), LoginUserId, ref faileReason);
            else
                res = bll.AddKnowMenu(name, int.Parse(parentId), LoginUserId, ref faileReason);
            context.Response.Write(new Tools.Serialize().SerializeJson(new { result = res, reason = faileReason }));
        }
        public void DeleteKnowMenu(HttpContext context)
        {
            var id = context.Request.QueryString["id"];
            var res = false;
            string faileReason = "";
            if (!string.IsNullOrEmpty(id) )
                res = bll.DeleteKnowMenu(long.Parse(id), LoginUserId, ref faileReason);
            context.Response.Write(new Tools.Serialize().SerializeJson(new { result = res, reason = faileReason }));
        }
    }
}