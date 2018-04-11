using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;

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
                    case "GetNoteInfo":
                        var note_id = context.Request.QueryString["note_id"];
                        GetNoteInfo(context,long.Parse(note_id));
                        break;
                    case "GetNoteAtt":
                        var attNoteId = context.Request.QueryString["note_id"];
                        GetNoteAtt(context,long.Parse(attNoteId));
                        break;
                    case "IsTodo":
                        IsTodo(context);
                        break;
                    case "GetActivity":
                        GetActivity(context);
                        break;
                    case "GetActicityInfo":
                        GetActicityInfo(context);
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
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.DeleteActivity(id, LoginUserId, LoginUser.security_Level_id)));
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
        /// <summary>
        /// 返回备注的相关信息
        /// </summary>
        private void GetNoteInfo(HttpContext context, long note_id)
        {
            var thisNote = new com_activity_dal().FindNoDeleteById(note_id);
            if (thisNote != null)
            {
                var thisRes = new sys_resource_dal().FindNoDeleteById(thisNote.create_user_id);
                var thisNoteType = new d_general_dal().FindNoDeleteById(thisNote.action_type_id);
                context.Response.Write(new Tools.Serialize().SerializeJson(new {title = thisNote.name,createUser =thisRes!=null?thisRes.name:"",type= thisNoteType!=null?thisNoteType.name:"", createDate=Tools.Date.DateHelper.ConvertStringToDateTime(thisNote.create_time).ToString("yyyy-MM-dd"), description = thisNote.description}));
            }
        }

        /// <summary>
        /// 获取备注附件相关信息，在页面上显示
        /// </summary>
        private void GetNoteAtt(HttpContext context,long note_id)
        {
            var attList = new com_attachment_dal().GetAttListByOid(note_id);
            if (attList != null && attList.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(attList));
            }
        }
        /// <summary>
        /// 判断是否是 待办
        /// </summary>
        private void IsTodo(HttpContext context)
        {
            var result = "";
            var id = context.Request.QueryString["objetcId"];
            if(!string.IsNullOrEmpty(id))
            {
                var todo = new com_activity_dal().FindNoDeleteById(long.Parse(id));
                var call = new sdk_service_call_dal().FindNoDeleteById(long.Parse(id));
                if (todo != null)
                    result = "1";
                else if (call != null)
                    result = "2";
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 获取到相关信息
        /// </summary>
        private void GetActivity(HttpContext context)
        {
            var id = context.Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
            {
                var acti = new com_activity_dal().FindNoDeleteById(long.Parse(id));
                if(acti!=null)
                    context.Response.Write(new Tools.Serialize().SerializeJson(acti));
            }
        }

        private void GetActicityInfo(HttpContext context)
        {
            var id = context.Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
            {
                var acti = new com_activity_dal().FindNoDeleteById(long.Parse(id));
                if (acti != null)
                {
                    string accountName = "";
                    string actiType = "";
                    if (acti.account_id != null)
                    {
                        var thisAcc = new CompanyBLL().GetCompany((long)acti.account_id);
                        accountName = thisAcc != null ? thisAcc.name : "";
                    }
                    var thisDic = new d_general_dal().FindNoDeleteById(acti.action_type_id);
                    var startDate = Tools.Date.DateHelper.ConvertStringToDateTime(acti.start_date);
                    var endDate = Tools.Date.DateHelper.ConvertStringToDateTime(acti.end_date);
                    var durHours = ((decimal)acti.end_date - (decimal)acti.start_date) / 1000 / 60 / 60;
                    actiType = thisDic != null ? thisDic.name : "";
                    context.Response.Write(new Tools.Serialize().SerializeJson(new {accName = accountName, actiType = actiType, startDateString = startDate.ToString("yyyy-MM-dd"), startTimeString = startDate.ToString("HH:mm"), endDateString = endDate.ToString("yyyy-MM-dd"), endTimeString = endDate.ToString("HH:mm"), durHours = durHours.ToString("#0.00") }));
                }
                    
            }
        }
    }
}