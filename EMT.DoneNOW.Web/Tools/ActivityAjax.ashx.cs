using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// 活动处理（备注/待办等）
    /// </summary>
    public class ActivityAjax : BaseAjax
    {
        private ActivityBLL bll = new ActivityBLL();
        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "CheckTodo":
                        var id = context.Request.QueryString["id"];
                        CheckTodo(context, long.Parse(id));
                        break;
                    case "Delete":
                        id = context.Request.QueryString["id"];
                        DeleteActivity(context, long.Parse(id));
                        break;
                    case "TodoComplete":
                        id = context.Request.QueryString["id"];
                        TodoSetCompleted(context, long.Parse(id));
                        break;
                    case "NoteSetScheduled":
                        id = context.Request.QueryString["id"];
                        NoteSetScheduled(context, long.Parse(id));
                        break;
                    case "AddNote":
                        AddNote(context);
                        break;
                    case "GetActivities":
                        GetActivities(context);
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
        /// 快捷新增备注
        /// </summary>
        /// <param name="context"></param>
        private void AddNote(HttpContext context)
        {
            List<string> rtn = new List<string>();
            string account_id = context.Request.QueryString["objId"];
            string pageType = context.Request.QueryString["page"];
            string desc = context.Request.QueryString["desc"];
            string type = context.Request.QueryString["type"];
            if (string.IsNullOrEmpty(account_id) || string.IsNullOrEmpty(desc) || string.IsNullOrEmpty(type))
            {
                rtn.Add("0");
                context.Response.Write(new Tools.Serialize().SerializeJson(rtn));
                return;
            }
            bll.FastAddNote(long.Parse(account_id), pageType, int.Parse(type), desc, LoginUserId);
            rtn.Add("1");
            context.Response.Write(new Tools.Serialize().SerializeJson(rtn));
        }

        /// <summary>
        /// 查看客户/联系人等获取活动列表
        /// </summary>
        /// <param name="context"></param>
        private void GetActivities(HttpContext context)
        {
            var queryStr = context.Request.QueryString;
            string id = queryStr["id"];
            string type = queryStr["page"];
            string order = queryStr["order"];
            List<string> actTypeList = new List<string>();
            if (!string.IsNullOrEmpty(queryStr["todo"]) && queryStr["todo"].Equals("1"))
                actTypeList.Add("todo");
            if (!string.IsNullOrEmpty(queryStr["crmnote"]) && queryStr["crmnote"].Equals("1"))
                actTypeList.Add("crmnote");
            if (!string.IsNullOrEmpty(queryStr["opportunity"]) && queryStr["opportunity"].Equals("1"))
                actTypeList.Add("opportunity");
            if (!string.IsNullOrEmpty(queryStr["sale"]) && queryStr["sale"].Equals("1"))
                actTypeList.Add("sale");
            if (!string.IsNullOrEmpty(queryStr["ticket"]) && queryStr["ticket"].Equals("1"))
                actTypeList.Add("ticket");
            if (!string.IsNullOrEmpty(queryStr["contract"]) && queryStr["contract"].Equals("1"))
                actTypeList.Add("contract");
            if (!string.IsNullOrEmpty(queryStr["project"]) && queryStr["project"].Equals("1"))
                actTypeList.Add("project");

            context.Response.Write(new Tools.Serialize().SerializeJson(bll.GetActivitiesHtml(actTypeList, long.Parse(id), type, order, LoginUserId, LoginUser.security_Level_id, UserPermit)));
        }

        /// <summary>
        /// 判断一个待办是否是备注和是否有商机，显示不同的右键菜单
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void CheckTodo(HttpContext context, long id)
        {
            List<string> rtn = new List<string>();
            rtn.Add(bll.CheckIsNote(id) == true ? "1" : "0");
            var act = bll.GetActivity(id);
            if (act.opportunity_id == null)
                rtn.Add("0");
            else
                rtn.Add(act.opportunity_id.ToString());
            context.Response.Write(new Tools.Serialize().SerializeJson(rtn));
        }

        /// <summary>
        /// 删除活动
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void DeleteActivity(HttpContext context, long id)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.DeleteActivity(id, LoginUserId)));
        }

        /// <summary>
        /// 设置待办完成
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void TodoSetCompleted(HttpContext context, long id)
        {
            bll.TodoSetCompleted(id, LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(true));
        }

        /// <summary>
        /// 备注转为待办
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void NoteSetScheduled(HttpContext context, long id)
        {
            bll.NoteSetScheduled(id, LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(true));
        }

    }
}