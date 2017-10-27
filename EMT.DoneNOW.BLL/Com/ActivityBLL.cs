using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    public class ActivityBLL
    {
        private readonly com_activity_dal dal = new com_activity_dal();

        /// <summary>
        /// 根据id查找
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public com_activity GetActivity(long id)
        {
            return dal.FindSignleBySql<com_activity>($"SELECT * FROM com_activity WHERE id={id} AND delete_time=0");
        }

        /// <summary>
        /// 删除活动
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteActivity(long id, long userId)
        {
            var act = dal.FindById(id);
            act.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            act.delete_user_id = userId;

            dal.Update(act);
            OperLogBLL.OperLogDelete<com_activity>(act, act.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "删除活动");

            return true;
        }

        /// <summary>
        /// 获取活动的下级备注id列表
        /// </summary>
        /// <param name="actId"></param>
        /// <param name="orderBy"></param>
        /// <returns></returns>
        public List<int> GetChildrenNote(long actId, string orderBy)
        {
            string sql = $"SELECT id FROM com_activity WHERE parent_id={actId} AND cate_id={(int)DicEnum.ACTIVITY_CATE.NOTE} AND delete_time=0 ";
            if (orderBy != null)
                sql += orderBy;
            return dal.FindListBySql<int>(sql);
        }

        #region 查看客户/联系人等获取活动列表
        /// <summary>
        /// 查看客户/联系人等获取活动列表
        /// </summary>
        /// <param name="actTypeList">活动类型</param>
        /// <param name="accountId">客户id</param>
        /// <param name="order">排序（1:时间从早到晚;否则:时间从晚到早</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public string GetActivities(List<string> actTypeList, long accountId, string order, long userId)
        {
            StringBuilder html = new StringBuilder();
            html.Append(GetTodosHtml(accountId, order, userId));
            return html.ToString();
        }

        /// <summary>
        /// 获取最多三个待办的html
        /// </summary>
        /// <param name="accountId"></param>
        /// <param name="order"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public string GetTodosHtml(long accountId, string order, long userId)
        {
            string sql = $"SELECT * FROM com_activity WHERE account_id={accountId} AND cate_id={(int)DicEnum.ACTIVITY_CATE.TODO} AND delete_time=0 ";
            if (order != null && order.Equals("1"))
                sql += " ORDER BY update_time ASC LIMIT 3";
            else
                sql += " ORDER BY update_time DESC LIMIT 3";
            var todoList = dal.FindListBySql(sql);

            StringBuilder todoHtml = new StringBuilder();
            foreach(var todo in todoList)
            {
                var resource = new sys_resource_dal().FindById((long)todo.resource_id);
                todoHtml.Append($"<div class='EntityFeedLevel1'><a href='#'><img src='..{resource.avatar}' /></a>");
                todoHtml.Append($"<div class='PostContent'><a href='#' class='PostContentName'>{resource.name}</a>");
                if (resource.id != userId)
                    todoHtml.Append($"<a href='mailto:{resource.email}' class='SmallLink'>发送邮件</a>");
                todoHtml.Append($"<img src='../Images/todos.png' />");

                if (todo.contact_id != null)
                {
                    var contact = new crm_contact_dal().FindById((long)todo.contact_id);
                    todoHtml.Append($"<span>(联系人:<a href='#' class='PostContentName'>{contact.name}</a>");
                    if (!string.IsNullOrEmpty(contact.email))
                        todoHtml.Append($"<a href='mailto:{contact.email}' class='SmallLink'>发送邮件</a>");
                    todoHtml.Append($")</span>");
                }

                todoHtml.Append($"<div><span>{new GeneralBLL().GetGeneralName(todo.action_type_id)}: {todo.description}</span></div>");

                var creator = new sys_resource_dal().FindById((long)todo.create_user_id);
                todoHtml.Append($"<div><span style='color:gray;'>创建人:&nbsp</span><a style='color:gray;' href='#'>{creator.name}</a>");
                if (todo.create_user_id != userId)
                    todoHtml.Append($"<a href='mailto:{creator.email}' class='SmallLink'>发送邮件</a>");
                todoHtml.Append("</div>");

                todoHtml.Append($"<div class='EntityDateTimeLinks'><span class='MostRecentPostedTime'>");
                var updateTime = Tools.Date.DateHelper.TimeStampToDateTime(todo.update_time);
                if (DateTime.Today.Year == updateTime.Year && DateTime.Today.Month == updateTime.Month && DateTime.Today.Day == updateTime.Day)
                    todoHtml.Append($"修改时间:&nbsp今天 {updateTime.ToString("hh:mm")}</span>");
                else
                    todoHtml.Append($"修改时间:&nbsp{updateTime.ToString("yyyy-MM-dd hh:mm")}</span>");
                todoHtml.Append($"<a href='#' class='CommentLink'>完成</a><a href='#' class='CommentLink'>编辑</a><a href='#' class='CommentLink'>删除</a>");
                todoHtml.Append("</div></div></div>");

                todoHtml.Append("<hr class='activityTitlerighthr' />");
            }

            return todoHtml.ToString();
        }

        /// <summary>
        /// 生成一个备注及其下级的备注和附件的html
        /// </summary>
        /// <param name="noteId"></param>
        /// <param name="userId"></param>
        /// <param name="level"></param>
        /// <param name="order"></param>
        /// <returns></returns>
        private string GetCRMNoteHtml(long noteId, long userId, int level, int order)
        {
            var note = dal.FindById(noteId);
            var resource = new sys_resource_dal().FindById((long)note.resource_id);
            string html = "";
            html += $"<div class='EntityFeedLevel{level}'><a href='#' style='float:left;'><img src='..{resource.avatar}' /></a> ";
            html += $"<div class='PostContent'><a href='#' class='PostContentName'>{resource.name}</a>";
            if (resource.id != userId)
                html += $"<a href='mailto:{resource.email}' class='SmallLink'>发送邮件</a>";
            html += $"<img src='../Images/note.png' />";
            if (note.contact_id!=null)
            {
                var contact = new crm_contact_dal().FindById((long)note.contact_id);
                html += $"<span>(联系人:<a href='#' class='PostContentName'>{contact.name}</a>";
                if (!string.IsNullOrEmpty(contact.email))
                    html += $"<a href='mailto:{contact.email}' class='SmallLink'>发送邮件</a>";
                html += $")</span>";
            }
            html += $"<div><span>{new GeneralBLL().GetGeneralName(note.action_type_id)}: {note.description}</span></div>";

            var creator = new sys_resource_dal().FindById((long)note.create_user_id);
            html += $"<div><span style='color:gray;'>创建人:&nbsp</span><a style='color:gray;' href='#'>{creator.name}</a>";
            if (note.create_user_id != userId)
                html += $"<a href='mailto:{creator.email}' class='SmallLink'>发送邮件</a>";
            html += "</div>";

            html += $"<div class='EntityDateTimeLinks'><span class='MostRecentPostedTime'>";
            var updateTime = Tools.Date.DateHelper.TimeStampToDateTime(note.update_time);
            if (DateTime.Today.Year == updateTime.Year && DateTime.Today.Month == updateTime.Month && DateTime.Today.Day == updateTime.Day)
                html += $"修改时间:&nbsp今天 {updateTime.ToString("hh:mm")}</span>";
            else
                html += $"修改时间:&nbsp{updateTime.ToString("yyyy-MM-dd hh:mm")}</span>";
            html += $"<a href='#' class='CommentLink'>添加备注</a><a href='#' class='CommentLink'>添加附件</a><a href='#' class='CommentLink'>编辑</a><a href='#' class='CommentLink'>删除</a>";
            html += "</div></div></div>";

            if (level == 3)     // 最多3级
                return html;

            // 添加子备注和附件 TODO: 附件
            string orderBy = " ORDER BY update_time DESC ";
            if ("1".Equals(order))
                orderBy = " ORDER BY update_time ASC ";
            var childIds = GetChildrenNote(note.id, orderBy);
            foreach(var child in childIds)
            {
                html += GetCRMNoteHtml(child, userId, level + 1, order);
            }

            if (level == 1)
                html += "<hr class='activityTitlerighthr' />";

            return html;
        }


        #endregion

        #region CRM备注/待办
        /// <summary>
        /// CRM备注/待办的活动类型
        /// </summary>
        /// <returns></returns>
        public List<d_general> GetCRMActionType()
        {
            return new d_general_dal().FindListBySql($"SELECT id,name FROM d_general WHERE general_table_id={(int)GeneralTableEnum.ACTION_TYPE} AND ext2 IS NULL AND delete_time=0");
        }

        /// <summary>
        /// 快捷新增备注(客户id，联系人id，商机id填一个)
        /// </summary>
        /// <param name="accountId"></param>
        /// <param name="contactId"></param>
        /// <param name="opportunityId"></param>
        /// <param name="typeId"></param>
        /// <param name="desc"></param>
        /// <param name="userId"></param>
        public void FastAddNote(long accountId, long contactId, long opportunityId, int typeId, string desc, long userId)
        {
            if (accountId == 0 && contactId == 0 && opportunityId == 0)
                return;

            com_activity note = new com_activity();
            note.id = dal.GetNextIdCom();
            note.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            note.create_user_id = userId;
            note.update_time = note.create_time;
            note.update_user_id = userId;
            note.cate_id = (int)DicEnum.ACTIVITY_CATE.NOTE;
            note.start_date = Tools.Date.DateHelper.ToUniversalTimeStamp();
            note.end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now.AddMinutes(15));
            note.action_type_id = typeId;
            note.resource_id = userId;
            note.description = desc;

            if (accountId != 0)
            {
                note.object_id = accountId;
                note.object_type_id = (int)DicEnum.OBJECT_TYPE.CUSTOMER;
                note.account_id = accountId;
            }
            // TODO: 联系人和商机

            dal.Insert(note);
            OperLogBLL.OperLogAdd<com_activity>(note, note.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "快捷新增备注");
        }

        /// <summary>
        /// 新增CRM备注
        /// </summary>
        /// <param name="note">备注</param>
        /// <param name="followTodo">跟进待办</param>
        /// <param name="userId"></param>
        public bool AddCRMNote(com_activity note, com_activity followTodo, long userId)
        {
            com_activity addNote = new com_activity();
            addNote.id = dal.GetNextIdCom();
            addNote.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            addNote.create_user_id = userId;
            addNote.update_time = addNote.create_time;
            addNote.update_user_id = userId;
            addNote.cate_id = (int)DicEnum.ACTIVITY_CATE.NOTE;
            addNote.action_type_id = note.action_type_id;
            addNote.parent_id = null;
            addNote.object_id = (long)note.account_id;
            addNote.object_type_id = (int)DicEnum.OBJECT_TYPE.CUSTOMER;
            addNote.account_id = note.account_id;
            addNote.contact_id = note.contact_id;
            addNote.resource_id = note.resource_id;
            addNote.contract_id = null;
            addNote.opportunity_id = note.opportunity_id;
            addNote.ticket_id = null;
            addNote.start_date = note.start_date;
            addNote.end_date = note.end_date;
            addNote.description = note.description == null ? "" : note.description;
            addNote.status_id = null;
            addNote.complete_time = null;
            addNote.complete_description = null;

            string desc = "";
            if (followTodo != null)
            {
                desc = $@"
跟进待办已创建
开始时间: {Tools.Date.DateHelper.TimeStampToDateTime(followTodo.start_date).ToString("yyyy-MM-dd HH:mm")}";
            }
            addNote.description += desc;

            dal.Insert(addNote);
            OperLogBLL.OperLogAdd<com_activity>(addNote, addNote.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");

            if (followTodo == null)
                return true;

            // 保存跟进待办
            com_activity todo = new com_activity();
            todo.id = dal.GetNextIdCom();
            todo.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            todo.create_user_id = userId;
            todo.update_time = todo.create_time;
            todo.update_user_id = userId;
            todo.cate_id = (int)DicEnum.ACTIVITY_CATE.TODO;
            todo.action_type_id = followTodo.action_type_id;
            todo.parent_id = null;
            todo.object_id = (long)note.account_id;
            todo.object_type_id = (int)DicEnum.OBJECT_TYPE.CUSTOMER;
            todo.account_id = note.account_id;
            todo.contact_id = note.contact_id;
            todo.resource_id = note.resource_id;
            todo.contract_id = null;
            todo.opportunity_id = note.opportunity_id;
            todo.ticket_id = null;
            todo.start_date = followTodo.start_date;
            todo.end_date = followTodo.end_date;
            todo.description = followTodo.description == null ? "" : followTodo.description;
            todo.status_id = (int)DicEnum.ACTIVITY_STATUS.NOT_COMPLETED;
            todo.complete_time = null;
            todo.complete_description = null;

            dal.Insert(todo);
            OperLogBLL.OperLogAdd<com_activity>(todo, todo.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "新增跟进待办");

            return true;
        }

        /// <summary>
        /// 编辑CRM备注
        /// </summary>
        /// <param name="note">备注</param>
        /// <param name="followTodo">跟进待办</param>
        /// <param name="userId"></param>
        public bool EditCRMNote(com_activity note, com_activity followTodo, long userId)
        {
            com_activity editNote = dal.FindById(note.id);
            com_activity oldNote = dal.FindById(note.id);
            
            editNote.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            editNote.update_user_id = userId;
            editNote.cate_id = (int)DicEnum.ACTIVITY_CATE.NOTE;
            editNote.action_type_id = note.action_type_id;
            editNote.parent_id = null;
            editNote.object_id = (long)note.account_id;
            editNote.object_type_id = (int)DicEnum.OBJECT_TYPE.CUSTOMER;
            editNote.account_id = note.account_id;
            editNote.contact_id = note.contact_id;
            editNote.resource_id = note.resource_id;
            editNote.contract_id = null;
            editNote.opportunity_id = note.opportunity_id;
            editNote.ticket_id = null;
            editNote.start_date = note.start_date;
            editNote.end_date = note.end_date;
            editNote.description = note.description == null ? "" : note.description;
            editNote.complete_time = null;
            editNote.complete_description = null;

            string desc = "";
            if (followTodo != null)
            {
                desc = $@"
跟进待办已创建
开始时间: {Tools.Date.DateHelper.TimeStampToDateTime(followTodo.start_date).ToString("yyyy-MM-dd HH:mm")}";
            }
            editNote.description += desc;

            dal.Update(editNote);
            OperLogBLL.OperLogUpdate<com_activity>(editNote, oldNote, editNote.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "编辑备注");

            if (followTodo == null)
                return true;

            // 保存跟进待办
            com_activity todo = new com_activity();
            todo.id = dal.GetNextIdCom();
            todo.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            todo.create_user_id = userId;
            todo.update_time = todo.create_time;
            todo.update_user_id = userId;
            todo.cate_id = (int)DicEnum.ACTIVITY_CATE.TODO;
            todo.action_type_id = followTodo.action_type_id;
            todo.parent_id = null;
            todo.object_id = (long)note.account_id;
            todo.object_type_id = (int)DicEnum.OBJECT_TYPE.CUSTOMER;
            todo.account_id = note.account_id;
            todo.contact_id = note.contact_id;
            todo.resource_id = note.resource_id;
            todo.contract_id = null;
            todo.opportunity_id = note.opportunity_id;
            todo.ticket_id = null;
            todo.start_date = followTodo.start_date;
            todo.end_date = followTodo.end_date;
            todo.description = followTodo.description == null ? "" : followTodo.description;
            todo.status_id = (int)DicEnum.ACTIVITY_STATUS.NOT_COMPLETED;
            todo.complete_time = null;
            todo.complete_description = null;

            dal.Insert(todo);
            OperLogBLL.OperLogAdd<com_activity>(todo, todo.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "新增跟进待办");

            return true;
        }

        /// <summary>
        /// 备注转为待办
        /// </summary>
        /// <param name="noteId"></param>
        /// <param name="userId"></param>
        public void NoteSetScheduled(long noteId, long userId)
        {
            var act = dal.FindById(noteId);
            var oldAct = dal.FindById(noteId);

            /* 类型改成待办，状态设置未完成 */
            act.cate_id = (int)DicEnum.ACTIVITY_CATE.TODO;
            act.status_id = (int)DicEnum.ACTIVITY_STATUS.NOT_COMPLETED;
            act.complete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            act.complete_description = "";

            act.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            act.update_user_id = userId;

            dal.Update(act);
            OperLogBLL.OperLogUpdate<com_activity>(act, oldAct, act.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "修改备注SetScheduled");
        }

        /// <summary>
        /// 新增待办
        /// </summary>
        /// <param name="todo"></param>
        /// <param name="userId"></param>
        public bool AddTodo(com_activity todo, long userId)
        {
            if (todo.status_id == null)     // 待办有状态
                return false;

            com_activity addTodo = new com_activity();
            addTodo.id = dal.GetNextIdCom();
            addTodo.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            addTodo.create_user_id = userId;
            addTodo.update_time = addTodo.create_time;
            addTodo.update_user_id = userId;
            if (todo.status_id == (int)DicEnum.ACTIVITY_STATUS.COMPLETED)
                addTodo.cate_id = (int)DicEnum.ACTIVITY_CATE.NOTE;
            else
                addTodo.cate_id = (int)DicEnum.ACTIVITY_CATE.TODO;
            addTodo.action_type_id = todo.action_type_id;
            addTodo.parent_id = null;
            addTodo.object_id = (long)todo.account_id;
            addTodo.object_type_id = (int)DicEnum.OBJECT_TYPE.CUSTOMER;
            addTodo.account_id = todo.account_id;
            addTodo.contact_id = todo.contact_id;
            addTodo.resource_id = todo.resource_id;
            addTodo.contract_id = todo.contract_id;
            addTodo.opportunity_id = todo.opportunity_id;
            addTodo.ticket_id = todo.ticket_id;
            addTodo.start_date = todo.start_date;
            addTodo.end_date = todo.end_date;
            addTodo.description = todo.description == null ? "" : todo.description;
            addTodo.status_id = todo.status_id;
            if (addTodo.status_id == (int)DicEnum.ACTIVITY_STATUS.COMPLETED)
            {
                addTodo.complete_time = todo.complete_time;
                addTodo.complete_description = todo.complete_description;
            }
            dal.Insert(addTodo);
            OperLogBLL.OperLogAdd<com_activity>(addTodo, addTodo.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "新增待办");

            return true;
        }

        /// <summary>
        /// 编辑待办
        /// </summary>
        /// <param name="todo"></param>
        /// <param name="userId"></param>
        public bool EditTodo(com_activity todo, long userId)
        {
            if (todo.status_id == null)     // 待办有状态
                return false;

            com_activity editTodo = dal.FindById(todo.id);
            com_activity oldTodo = dal.FindById(todo.id);
            editTodo.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            editTodo.update_user_id = userId;
            editTodo.cate_id = (int)DicEnum.ACTIVITY_CATE.TODO;
            editTodo.action_type_id = todo.action_type_id;
            editTodo.parent_id = null;
            editTodo.object_id = (long)todo.account_id;
            editTodo.object_type_id = (int)DicEnum.OBJECT_TYPE.CUSTOMER;
            editTodo.account_id = todo.account_id;
            editTodo.contact_id = todo.contact_id;
            editTodo.resource_id = todo.resource_id;
            editTodo.contract_id = todo.contract_id;
            editTodo.opportunity_id = todo.opportunity_id;
            editTodo.ticket_id = todo.ticket_id;
            editTodo.start_date = todo.start_date;
            editTodo.end_date = todo.end_date;
            editTodo.description = todo.description == null ? "" : todo.description;
            editTodo.status_id = todo.status_id;
            if (editTodo.status_id == (int)DicEnum.ACTIVITY_STATUS.COMPLETED)
            {
                editTodo.complete_time = todo.complete_time;
                editTodo.complete_description = todo.complete_description;
            }
            dal.Update(editTodo);
            OperLogBLL.OperLogUpdate<com_activity>(editTodo, oldTodo, editTodo.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "编辑待办");

            return true;
        }

        /// <summary>
        /// 设置待办完成
        /// </summary>
        /// <param name="todoId"></param>
        /// <param name="userId"></param>
        public void TodoSetCompleted(long todoId,long userId)
        {
            var act = dal.FindById(todoId);
            var oldAct = dal.FindById(todoId);

            /* 类型改成备注，状态设置已完成 */
            act.cate_id = (int)DicEnum.ACTIVITY_CATE.NOTE;
            act.status_id = (int)DicEnum.ACTIVITY_STATUS.COMPLETED;

            act.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            act.update_user_id = userId;

            dal.Update(act);
            OperLogBLL.OperLogUpdate<com_activity>(act, oldAct, act.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "修改待办状态完成");
        }

        /// <summary>
        /// 判断一个待办是否是备注
        /// </summary>
        /// <param name="todoId"></param>
        /// <returns></returns>
        public bool CheckIsNote(long todoId)
        {
            var act = dal.FindById(todoId);
            if (act != null && act.cate_id == (int)DicEnum.ACTIVITY_CATE.NOTE)
                return true;
            else
                return false;
        }
        #endregion
    }
}
