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
        public bool DeleteActivity(long id, long userId, long secLevelId)
        {
            var act = dal.FindById(id);
            if (act.cate_id == (int)DicEnum.ACTIVITY_CATE.NOTE)
            {
                if (AuthBLL.GetUserNoteAuth(userId, secLevelId, id).CanDelete == false)
                    return false;
            }
            else if (act.cate_id == (int)DicEnum.ACTIVITY_CATE.TODO)
            {
                if (AuthBLL.GetUserTodoAuth(userId, secLevelId, id).CanDelete == false)
                    return false;
            }

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

        #region 查看客户/联系人/商机/销售订单活动列表
        /// <summary>
        /// 查看客户/联系人/商机/销售订单活动列表
        /// </summary>
        /// <param name="actTypeList"></param>
        /// <param name="objId"></param>
        /// <param name="objType"></param>
        /// <param name="order"></param>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        public string GetActivitiesHtml(List<string> actTypeList, long objId, string objType, string order, long userId, int secLevelId, List<AuthPermitDto> userPermit)
        {
            if (objType == null)
                return "";
            if (objType.Equals("account"))
                return GetAccountActivities(actTypeList, objId, order, userId, secLevelId, userPermit);
            if (objType.Equals("contact"))
                return GetContactActivities(actTypeList, objId, order, userId, secLevelId, userPermit);
            if (objType.Equals("opportunity"))
                return GetOppActivities(actTypeList, objId, order, userId, secLevelId, userPermit);
            if (objType.Equals("salesorder"))
                return GetSaleorderActivities(actTypeList, objId, order, userId, secLevelId, userPermit);

            return "";
        }
        #region 查看客户获取活动列表
        /// <summary>
        /// 查看客户获取活动列表
        /// </summary>
        /// <param name="actTypeList">活动类型</param>
        /// <param name="accountId">客户id</param>
        /// <param name="order">排序（1:时间从早到晚;否则:时间从晚到早</param>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        public string GetAccountActivities(List<string> actTypeList, long accountId, string order, long userId, int secLevelId, List<AuthPermitDto> userPermit)
        {
            if (actTypeList == null || accountId == 0 || userId == 0)
                return "";

            StringBuilder html = new StringBuilder();

            if (actTypeList.Exists(_ => "todo".Equals(_)))
                html.Append(GetAccountTodosHtml(accountId, order, userId, secLevelId, userPermit));

            string cate = "";
            if (actTypeList.Exists(_ => "crmnote".Equals(_)))
                cate += "2,";
            if (actTypeList.Exists(_ => "opportunity".Equals(_)))
                cate += "3,";
            if (actTypeList.Exists(_ => "sale".Equals(_)))
                cate += "4,";
            if (actTypeList.Exists(_ => "ticket".Equals(_)))
                cate += "5,";
            if (actTypeList.Exists(_ => "contract".Equals(_)))
                cate += "6,";
            if (actTypeList.Exists(_ => "project".Equals(_)))
                cate += "7,";
            if (cate.Equals(""))
                return html.ToString();
            cate = cate.Remove(cate.Length - 1, 1);    // 移除最后的,

            bool isAsc = false;
            if (!string.IsNullOrEmpty(order) && order.Equals("1"))
                isAsc = true;
            var actList = new v_activity_dal().GetActivities(accountId, cate);
            IOrderedEnumerable<v_activity> actList1;
            if (isAsc)
                actList1 = from a in actList where a.lv == 1 orderby a.act_date_1lv ascending select a;
            else
                actList1 = from a in actList where a.lv == 1 orderby a.act_date_1lv descending select a;

            foreach (var act in actList1)
            {
                if (act.cate == 2)    // 备注和附件
                {
                    if (act.act_cate != null && act.act_cate.Equals("act"))
                        html.Append(GetNoteHtml(actList, act, act.cate, userId, 1, secLevelId, userPermit));
                    else if (act.act_cate != null && act.act_cate.Equals("att"))
                        html.Append(GetAttachmentHtml(actList, act, act.cate, userId, 1, secLevelId, userPermit));
                    else    // 错误
                        return "";
                }
                else
                {
                    html.Append(GetObjectHtml(actList, act, userId, isAsc, secLevelId, userPermit));
                }
            }

            return html.ToString();
            
        }

        /// <summary>
        /// 获取最多三个待办的html
        /// </summary>
        /// <param name="accountId"></param>
        /// <param name="order"></param>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        private string GetAccountTodosHtml(long accountId, string order, long userId, int secLevelId, List<AuthPermitDto> userPermit)
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
                todoHtml.Append($"<div class='EntityFeedLevel1'><a style='cursor:pointer;'><img src='..{resource.avatar}' /></a>");
                todoHtml.Append($"<div class='PostContent'><a class='PostContentName'>{resource.name}</a>");
                if (resource.id != userId)
                    todoHtml.Append($"<a href='mailto:{resource.email}' class='SmallLink'>发送邮件</a>");
                todoHtml.Append($"<img src='../Images/todos.png' />");

                if (todo.contact_id != null)
                {
                    var contact = new crm_contact_dal().FindById((long)todo.contact_id);

                    if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_VIEW_CONTACT"))
                        todoHtml.Append($"<span>(联系人:<a class='PostContentName' onclick='ViewContact({todo.contact_id})'>{contact.name}</a>");
                    else
                        todoHtml.Append($"<span>(联系人:<a class='PostContentName'>{contact.name}</a>");

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

                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_FINISH"))
                    todoHtml.Append($"<a onclick='TodoComplete({todo.id})' class='CommentLink'>完成</a>");
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_EDIT"))
                    todoHtml.Append($"<a onclick='TodoEdit({todo.id})' class='CommentLink'>编辑</a>");
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_DELETE"))
                    todoHtml.Append($"<a onclick='ActDelete({todo.id})' class='CommentLink'>删除</a>");
                todoHtml.Append("</div></div></div>");

                todoHtml.Append("<hr class='activityTitlerighthr' />");
            }

            return todoHtml.ToString();
        }
        #endregion

        #region 查看联系人获取活动列表
        /// <summary>
        /// 查看联系人获取活动列表
        /// </summary>
        /// <param name="actTypeList"></param>
        /// <param name="contactId"></param>
        /// <param name="order"></param>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        public string GetContactActivities(List<string> actTypeList, long contactId, string order, long userId, int secLevelId, List<AuthPermitDto> userPermit)
        {
            if (actTypeList == null || contactId == 0 || userId == 0)
                return "";

            StringBuilder html = new StringBuilder();
            DateTime t1 = DateTime.Now;
            // 先加入最多3个待办
            if (actTypeList.Exists(_ => "todo".Equals(_)))
                html.Append(GetContactTodosHtml(contactId, order, userId, secLevelId, userPermit));

            string cate = "";
            if (actTypeList.Exists(_ => "crmnote".Equals(_)))
                cate += "2,";
            if (actTypeList.Exists(_ => "opportunity".Equals(_)))
                cate += "3,";
            if (actTypeList.Exists(_ => "sale".Equals(_)))
                cate += "4,";
            if (actTypeList.Exists(_ => "ticket".Equals(_)))
                cate += "5,";
            if (actTypeList.Exists(_ => "contract".Equals(_)))
                cate += "6,";
            if (actTypeList.Exists(_ => "project".Equals(_)))
                cate += "7,";
            if (cate.Equals(""))
                return html.ToString();
            cate = cate.Remove(cate.Length - 1, 1);    // 移除最后的,

            bool isAsc = false;
            if (!string.IsNullOrEmpty(order) && order.Equals("1"))
                isAsc = true;
            var actList = new v_activity_contact_dal().GetActivities(contactId, cate);
            IOrderedEnumerable<v_activity> actList1;
            if (isAsc)
                actList1 = from a in actList where a.lv == 1 orderby a.act_date_1lv ascending select a;
            else
                actList1 = from a in actList where a.lv == 1 orderby a.act_date_1lv descending select a;

            foreach (var act in actList1)
            {
                if (act.cate == 2)    // 备注和附件
                {
                    if (act.act_cate != null && act.act_cate.Equals("act"))
                        html.Append(GetNoteHtml(actList, act, act.cate, userId, 1, secLevelId, userPermit));
                    else if (act.act_cate != null && act.act_cate.Equals("att"))
                        html.Append(GetAttachmentHtml(actList, act, act.cate, userId, 1, secLevelId, userPermit));
                    else    // 错误
                        return "";
                }
                else
                {
                    html.Append(GetObjectHtml(actList, act, userId, isAsc, secLevelId, userPermit));
                }
            }
            return html.ToString();

        }

        /// <summary>
        /// 获取联系人代办信息
        /// </summary>
        /// <param name="contactId"></param>
        /// <param name="order"></param>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        private string GetContactTodosHtml(long contactId, string order, long userId, int secLevelId, List<AuthPermitDto> userPermit)
        {
            string sql = $"SELECT * FROM com_activity WHERE object_id={contactId} AND object_type_id={(int)DicEnum.OBJECT_TYPE.CONTACT} AND cate_id={(int)DicEnum.ACTIVITY_CATE.TODO} AND delete_time=0 ";
            if (order != null && order.Equals("1"))
                sql += " ORDER BY update_time ASC LIMIT 3";
            else
                sql += " ORDER BY update_time DESC LIMIT 3";
            var todoList = dal.FindListBySql(sql);

            StringBuilder todoHtml = new StringBuilder();
            foreach (var todo in todoList)
            {
                var resource = new sys_resource_dal().FindById((long)todo.resource_id);
                todoHtml.Append($"<div class='EntityFeedLevel1'><a style='cursor:pointer;'><img src='..{resource.avatar}' /></a>");
                todoHtml.Append($"<div class='PostContent'><a class='PostContentName'>{resource.name}</a>");
                if (resource.id != userId)
                    todoHtml.Append($"<a href='mailto:{resource.email}' class='SmallLink'>发送邮件</a>");
                todoHtml.Append($"<img src='../Images/todos.png' />");

                if (todo.contact_id != null)
                {
                    var contact = new crm_contact_dal().FindById((long)todo.contact_id);

                    if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_VIEW_CONTACT"))
                        todoHtml.Append($"<span>(联系人:<a class='PostContentName' onclick='ViewContact({todo.contact_id})'>{contact.name}</a>");
                    else
                        todoHtml.Append($"<span>(联系人:<a class='PostContentName'>{contact.name}</a>");
                    
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

                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_FINISH"))
                    todoHtml.Append($"<a onclick='TodoComplete({todo.id})' class='CommentLink'>完成</a>");
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_EDIT"))
                    todoHtml.Append($"<a onclick='TodoEdit({todo.id})' class='CommentLink'>编辑</a>");
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_DELETE"))
                    todoHtml.Append($"<a onclick='ActDelete({todo.id})' class='CommentLink'>删除</a>");
                todoHtml.Append("</div></div></div>");

                todoHtml.Append("<hr class='activityTitlerighthr' />");
            }

            return todoHtml.ToString();
        }

        #endregion

        #region 查看商机获取活动列表
        /// <summary>
        /// 查看商机获取活动列表
        /// </summary>
        /// <param name="actTypeList">活动类型</param>
        /// <param name="oppId">商机id</param>
        /// <param name="order">排序（1:时间从早到晚;否则:时间从晚到早</param>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        public string GetOppActivities(List<string> actTypeList, long oppId, string order, long userId, int secLevelId, List<AuthPermitDto> userPermit)
        {
            if (actTypeList == null || oppId == 0 || userId == 0)
                return "";

            StringBuilder html = new StringBuilder();

            if (actTypeList.Exists(_ => "todo".Equals(_)))
                html.Append(GetOppTodosHtml(oppId, order, userId, secLevelId, userPermit));

            string cate = "";
            if (actTypeList.Exists(_ => "crmnote".Equals(_)))
                cate += "2,";
            if (actTypeList.Exists(_ => "opportunity".Equals(_)))
                cate += "3,";
            if (actTypeList.Exists(_ => "sale".Equals(_)))
                cate += "4,";
            if (actTypeList.Exists(_ => "ticket".Equals(_)))
                cate += "5,";
            if (actTypeList.Exists(_ => "contract".Equals(_)))
                cate += "6,";
            if (actTypeList.Exists(_ => "project".Equals(_)))
                cate += "7,";
            if (cate.Equals(""))
                return html.ToString();
            cate = cate.Remove(cate.Length - 1, 1);    // 移除最后的,

            bool isAsc = false;
            if (!string.IsNullOrEmpty(order) && order.Equals("1"))
                isAsc = true;
            var actList = new v_activity_opportunity_dal().GetActivities(oppId, cate);
            IOrderedEnumerable<v_activity> actList1;
            if (isAsc)
                actList1 = from a in actList where a.lv == 1 orderby a.act_date_1lv ascending select a;
            else
                actList1 = from a in actList where a.lv == 1 orderby a.act_date_1lv descending select a;

            // 商机和销售订单一级备注和二级备注会有重复，获取二级备注，判断一级备注是否显示。有重复不显示一级备注
            var level2Ids = from a in actList where a.cate == 2 && a.lv == 2 select a.id;

            foreach (var act in actList1)
            {
                if (level2Ids.Contains(act.id))
                    continue;

                if (act.cate == 2)    // 备注和附件
                {
                    if (act.act_cate != null && act.act_cate.Equals("act"))
                        html.Append(GetNoteHtml(actList, act, act.cate, userId, 1, secLevelId, userPermit));
                    else if (act.act_cate != null && act.act_cate.Equals("att"))
                        html.Append(GetAttachmentHtml(actList, act, act.cate, userId, 1, secLevelId, userPermit));
                    else    // 错误
                        return "";
                }
                else
                {
                    html.Append(GetObjectHtml(actList, act, userId, isAsc, secLevelId, userPermit));
                }
            }

            return html.ToString();

        }

        /// <summary>
        /// 获取最多三个待办的html
        /// </summary>
        /// <param name="oppId"></param>
        /// <param name="order"></param>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        private string GetOppTodosHtml(long oppId, string order, long userId, int secLevelId, List<AuthPermitDto> userPermit)
        {
            string sql = $"SELECT * FROM com_activity WHERE opportunity_id={oppId} AND cate_id={(int)DicEnum.ACTIVITY_CATE.TODO} AND delete_time=0 ";
            if (order != null && order.Equals("1"))
                sql += " ORDER BY update_time ASC LIMIT 3";
            else
                sql += " ORDER BY update_time DESC LIMIT 3";
            var todoList = dal.FindListBySql(sql);

            StringBuilder todoHtml = new StringBuilder();
            foreach (var todo in todoList)
            {
                var resource = new sys_resource_dal().FindById((long)todo.resource_id);
                todoHtml.Append($"<div class='EntityFeedLevel1'><a style='cursor:pointer;'><img src='..{resource.avatar}' /></a>");
                todoHtml.Append($"<div class='PostContent'><a class='PostContentName'>{resource.name}</a>");
                if (resource.id != userId)
                    todoHtml.Append($"<a href='mailto:{resource.email}' class='SmallLink'>发送邮件</a>");
                todoHtml.Append($"<img src='../Images/todos.png' />");

                if (todo.contact_id != null)
                {
                    var contact = new crm_contact_dal().FindById((long)todo.contact_id);

                    if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_VIEW_CONTACT"))
                        todoHtml.Append($"<span>(联系人:<a class='PostContentName' onclick='ViewContact({todo.contact_id})'>{contact.name}</a>");
                    else
                        todoHtml.Append($"<span>(联系人:<a class='PostContentName'>{contact.name}</a>");
                    
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

                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_FINISH"))
                    todoHtml.Append($"<a onclick='TodoComplete({todo.id})' class='CommentLink'>完成</a>");
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_EDIT"))
                    todoHtml.Append($"<a onclick='TodoEdit({todo.id})' class='CommentLink'>编辑</a>");
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_DELETE"))
                    todoHtml.Append($"<a onclick='ActDelete({todo.id})' class='CommentLink'>删除</a>");
                todoHtml.Append("</div></div></div>");

                todoHtml.Append("<hr class='activityTitlerighthr' />");
            }

            return todoHtml.ToString();
        }
        #endregion

        #region 查看销售订单获取活动列表
        /// <summary>
        /// 查看销售订单获取活动列表
        /// </summary>
        /// <param name="actTypeList">活动类型</param>
        /// <param name="soId">销售订单id</param>
        /// <param name="order">排序（1:时间从早到晚;否则:时间从晚到早</param>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        public string GetSaleorderActivities(List<string> actTypeList, long soId, string order, long userId, int secLevelId, List<AuthPermitDto> userPermit)
        {
            if (actTypeList == null || soId == 0 || userId == 0)
                return "";

            StringBuilder html = new StringBuilder();

            if (actTypeList.Exists(_ => "todo".Equals(_)))
                html.Append(GetSalesOrderTodosHtml(soId, order, userId, secLevelId, userPermit));

            string cate = "";
            if (actTypeList.Exists(_ => "crmnote".Equals(_)))
                cate += "2,";
            if (actTypeList.Exists(_ => "opportunity".Equals(_)))
                cate += "3,";
            if (actTypeList.Exists(_ => "sale".Equals(_)))
                cate += "4,";
            if (actTypeList.Exists(_ => "ticket".Equals(_)))
                cate += "5,";
            if (actTypeList.Exists(_ => "contract".Equals(_)))
                cate += "6,";
            if (actTypeList.Exists(_ => "project".Equals(_)))
                cate += "7,";
            if (cate.Equals(""))
                return html.ToString();
            cate = cate.Remove(cate.Length - 1, 1);    // 移除最后的,

            bool isAsc = false;
            if (!string.IsNullOrEmpty(order) && order.Equals("1"))
                isAsc = true;
            var actList = new v_activity_sales_order_dal().GetActivities(soId, cate);
            IOrderedEnumerable<v_activity> actList1;
            if (isAsc)
                actList1 = from a in actList where a.lv == 1 orderby a.act_date_1lv ascending select a;
            else
                actList1 = from a in actList where a.lv == 1 orderby a.act_date_1lv descending select a;

            // 商机和销售订单一级备注和二级备注会有重复，获取二级备注，判断一级备注是否显示。有重复不显示一级备注
            var level2Ids = from a in actList where a.cate == 2 && a.lv == 2 select a.id;

            foreach (var act in actList1)
            {
                if (level2Ids.Contains(act.id))
                    continue;

                if (act.cate == 2)    // 备注和附件
                {
                    if (act.act_cate != null && act.act_cate.Equals("act"))
                        html.Append(GetNoteHtml(actList, act, act.cate, userId, 1, secLevelId, userPermit));
                    else if (act.act_cate != null && act.act_cate.Equals("att"))
                        html.Append(GetAttachmentHtml(actList, act, act.cate, userId, 1, secLevelId, userPermit));
                    else    // 错误
                        return "";
                }
                else
                {
                    html.Append(GetObjectHtml(actList, act, userId, isAsc, secLevelId, userPermit));
                }
            }

            return html.ToString();

        }

        /// <summary>
        /// 获取最多三个待办的html
        /// </summary>
        /// <param name="soId"></param>
        /// <param name="order"></param>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        private string GetSalesOrderTodosHtml(long soId, string order, long userId, int secLevelId, List<AuthPermitDto> userPermit)
        {
            string sql = $"SELECT * FROM com_activity WHERE object_id={soId} AND object_type_id={(int)DicEnum.OBJECT_TYPE.SALEORDER} AND cate_id={(int)DicEnum.ACTIVITY_CATE.TODO} AND delete_time=0 ";
            if (order != null && order.Equals("1"))
                sql += " ORDER BY update_time ASC LIMIT 3";
            else
                sql += " ORDER BY update_time DESC LIMIT 3";
            var todoList = dal.FindListBySql(sql);

            StringBuilder todoHtml = new StringBuilder();
            foreach (var todo in todoList)
            {
                var resource = new sys_resource_dal().FindById((long)todo.resource_id);
                todoHtml.Append($"<div class='EntityFeedLevel1'><a style='cursor:pointer;'><img src='..{resource.avatar}' /></a>");
                todoHtml.Append($"<div class='PostContent'><a class='PostContentName'>{resource.name}</a>");
                if (resource.id != userId)
                    todoHtml.Append($"<a href='mailto:{resource.email}' class='SmallLink'>发送邮件</a>");
                todoHtml.Append($"<img src='../Images/todos.png' />");

                if (todo.contact_id != null)
                {
                    var contact = new crm_contact_dal().FindById((long)todo.contact_id);

                    if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_VIEW_CONTACT"))
                        todoHtml.Append($"<span>(联系人:<a class='PostContentName' onclick='ViewContact({todo.contact_id})'>{contact.name}</a>");
                    else
                        todoHtml.Append($"<span>(联系人:<a class='PostContentName'>{contact.name}</a>");
                    
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

                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_FINISH"))
                    todoHtml.Append($"<a onclick='TodoComplete({todo.id})' class='CommentLink'>完成</a>");
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_EDIT"))
                    todoHtml.Append($"<a onclick='TodoEdit({todo.id})' class='CommentLink'>编辑</a>");
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS_DELETE"))
                    todoHtml.Append($"<a onclick='ActDelete({todo.id})' class='CommentLink'>删除</a>");
                todoHtml.Append("</div></div></div>");

                todoHtml.Append("<hr class='activityTitlerighthr' />");
            }

            return todoHtml.ToString();
        }
        #endregion

        /// <summary>
        /// 活动商机、销售订单等信息及其下的备注和附件信息
        /// </summary>
        /// <param name="actList"></param>
        /// <param name="obj"></param>
        /// <param name="userId"></param>
        /// <param name="isAsc"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        private string GetObjectHtml(List<v_activity> actList, v_activity obj, long userId, bool isAsc, int secLevelId, List<AuthPermitDto> userPermit)
        {
            long cate = obj.cate;
            int objType;
            int attObjType = 0;
            string logo;
            bool canView = false;   // 是否可以
            bool canAddNote = false;
            bool canAddAtt = false;
            if (cate == 3)
            {
                objType = (int)DicEnum.OBJECT_TYPE.OPPORTUNITY;
                logo = "contract.png";
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_OPPORTUNITY_VIEW_OPP"))
                    canView = true;
            }
            else if (cate == 4)
            {
                objType = (int)DicEnum.OBJECT_TYPE.SALEORDER;
                attObjType = (int)DicEnum.ATTACHMENT_OBJECT_TYPE.SALES_ORDER;
                logo = "salesorder.png";
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_SALES_ORDER_VIEW_SALEORDER"))
                    canView = true;
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_SALES_ORDER_ADD_NOTE"))
                    canAddNote = true;
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_SALES_ORDER_ADD_ATTACHMENT"))
                    canAddAtt = true;
            }
            else if (cate == 6)
            {
                objType = (int)DicEnum.OBJECT_TYPE.CONTRACT;
                logo = "contract.png";
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_CONTRACT_VIEW_CONTRACT"))
                    canView = true;
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_CONTRACT_ADD_NOTE"))
                    canAddNote = true;
            }
            else if (cate == 7)
            {
                objType = (int)DicEnum.OBJECT_TYPE.PROJECT;
                attObjType = (int)DicEnum.ATTACHMENT_OBJECT_TYPE.PROJECT;
                logo = "project.png";
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_PROJECT_VIEW_PROJECT"))
                    canView = true;
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_PROJECT_ADD_NOTE"))
                    canAddNote = true;
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_PROJECT_ADD_ATTACHMENT"))
                    canAddAtt = true;
            }
            else
                return "";

            //var obj = new v_activity_dal().FindById(objId);

            StringBuilder html = new StringBuilder();
            html.Append($"<div class='EntityFeedLevel1'><a style='float:left;cursor:pointer;'><img src='../Images/{logo}' /></a> ");
            if (cate == 3)
            {
                if (canView)
                    html.Append($"<div class='PostContent'><a class='PostContentName' onclick='ViewOpportunity({obj.id})'>{obj.pname}</a>");
                else
                    html.Append($"<div class='PostContent'><a class='PostContentName'>{obj.pname}</a>");
            }
            else if (cate == 4)
            {
                if (canView)
                    html.Append($"<div class='PostContent'><a class='PostContentName' onclick='ViewSalesOrder({obj.id})'>{obj.pname}</a>");
                else
                    html.Append($"<div class='PostContent'><a class='PostContentName'>{obj.pname}</a>");
            }
            else if (cate == 6)
            {
                if (canView)
                    html.Append($"<div class='PostContent'><a class='PostContentName' onclick='ViewContract({obj.id})'>{obj.pname}</a>");
                else
                    html.Append($"<div class='PostContent'><a class='PostContentName'>{obj.pname}</a>");
            }
            else
                html.Append($"<div class='PostContent'><a class='PostContentName'>{obj.pname}</a>");
            html.Append($"<div><span>{obj.act_desc}</span></div>");
            html.Append($"<div class='EntityDateTimeLinks'><span class='MostRecentPostedTime'>");
            html.Append($"{obj.act_date}</span>");
            if (cate == 4 || cate == 7)
            {
                if (canAddNote)
                    html.Append($"<a onclick='NoteAddNote({cate},1,{objType},{obj.id})' class='CommentLink'>添加备注</a>");
                if(canAddAtt)
                    html.Append($"<a onclick='NoteAddAttach({obj.id},{attObjType})' class='CommentLink'>添加附件</a>");
            }
            if (cate == 6 && canAddNote)
            {
                html.Append($"<a onclick='NoteAddNote({cate},1,{objType},{obj.id})' class='CommentLink'>添加备注</a>");
            }
            html.Append("</div></div></div>");

            IOrderedEnumerable<v_activity> actList1;    // 下级备注和附件
            actList1 = from act in actList where act.id_1lv == obj.id && act.lv == 2 orderby act.act_date_2lv ascending select act;

            //var actList = new v_activity_dal().GetActivities(obj.id, 2, isAsc);
            foreach (var act in actList1)
            {
                if (act.act_cate != null && act.act_cate.Equals("act"))
                    html.Append(GetNoteHtml(actList, act, cate, userId, 2, secLevelId, userPermit));
                else if (act.act_cate != null && act.act_cate.Equals("att"))
                    html.Append(GetAttachmentHtml(actList, act, cate, userId, 2, secLevelId, userPermit));
            }

            html.Append("<hr class='activityTitlerighthr' />");

            return html.ToString();
        }

        /// <summary>
        /// 生成一个备注及其下级的备注和附件的html
        /// </summary>
        /// <param name="actList"></param>
        /// <param name="note"></param>
        /// <param name="cate"></param>
        /// <param name="userId"></param>
        /// <param name="level"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        private string GetNoteHtml(List<v_activity> actList, v_activity note, long cate, long userId, int level, int secLevelId, List<AuthPermitDto> userPermit)
        {
            StringBuilder html = new StringBuilder();
            html.Append($"<div class='EntityFeedLevel{level}'><a style='float:left;cursor:pointer;'><img src='..{note.resource_avatar}' /></a> ");
            html.Append($"<div class='PostContent'><a class='PostContentName'>{note.resource_name}</a>");
            if (note.resource_id != userId && !string.IsNullOrEmpty(note.resource_email))
                html.Append($"<a href='mailto:{note.resource_email}' class='SmallLink'>发送邮件</a>");
            html.Append($"<img src='../Images/note.png' />");
            if (note.contact_id != null)
            {
                if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_NOTES_VIEW_CONTACT"))
                    html.Append($"<span>(联系人:<a class='PostContentName' onclick='ViewContact({note.contact_id})'>{note.contact_name}</a>");
                else
                    html.Append($"<span>(联系人:<a class='PostContentName'>{note.contact_name}</a>");
                if (!string.IsNullOrEmpty(note.contact_email))
                    html.Append($"<a href='mailto:{note.contact_email}' class='SmallLink'>发送邮件</a>");
                html.Append($")</span>");
            }
            html.Append($"<div><span>{note.act_desc}</span></div>");

            if (cate == 2 || cate == 3 || cate == 4)
            {
                html.Append($"<div><span style='color:gray;'>创建/修改人:&nbsp</span><a style='color:gray;'>{note.update_user_name}</a>");
                if (note.update_user_id != userId && !string.IsNullOrEmpty(note.update_user_email))
                    html.Append($"<a href='mailto:{note.update_user_email}' class='SmallLink'>发送邮件</a>");
                html.Append("</div>");
            }

            html.Append($"<div class='EntityDateTimeLinks'><span class='MostRecentPostedTime'>");
            html.Append($"{note.act_date}</span>");
            if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_NOTES_ADD_NOTE"))
                html.Append($"<a onclick='NoteAddNote({cate},{level},{(int)DicEnum.OBJECT_TYPE.NOTES},{note.id})' class='CommentLink'>添加备注</a>");
            if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_NOTES_ADD_ATTACHMENT"))
                html.Append($"<a onclick='NoteAddAttach({note.id},{(int)DicEnum.ATTACHMENT_OBJECT_TYPE.NOTES})' class='CommentLink'>添加附件</a>");
            if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_NOTES_EDIT"))
                html.Append($"<a onclick='NoteEdit({note.id})' class='CommentLink'>编辑</a>");
            if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_NOTES_DELETE"))
                html.Append($"<a onclick='ActDelete({note.id})' class='CommentLink'>删除</a>");
            html.Append("</div></div></div>");

            if (level == 3)
                return html.ToString();
            if (cate == 2 && level == 2)
                return html.ToString();

            IOrderedEnumerable<v_activity> actList1;    // 下级备注和附件
            if (level == 1)
                actList1 = from act in actList where act.id_1lv == note.id && act.lv == 2 orderby act.act_date_2lv ascending select act;
            else
                actList1 = from act in actList where note.id.ToString().Equals(act.id_2lv) && act.lv == 3 orderby act.act_date ascending select act;
            
            foreach (var act in actList1)
            {
                if (act.act_cate != null && act.act_cate.Equals("act"))
                    html.Append(GetNoteHtml(actList, act, cate, userId, level + 1, secLevelId, userPermit));
                else if (act.act_cate != null && act.act_cate.Equals("att"))
                    html.Append(GetAttachmentHtml(actList, act, cate, userId, level + 1, secLevelId, userPermit));
            }

            if (level == 1)
                html.Append("<hr class='activityTitlerighthr' />");

            return html.ToString();
        }

        /// <summary>
        /// 生成一个附件及其下级的备注和附件的html
        /// </summary>
        /// <param name="actList"></param>
        /// <param name="att"></param>
        /// <param name="cate"></param>
        /// <param name="userId"></param>
        /// <param name="level"></param>
        /// <param name="secLevelId"></param>
        /// <param name="userPermit"></param>
        /// <returns></returns>
        private string GetAttachmentHtml(List<v_activity> actList, v_activity att, long cate, long userId, int level, int secLevelId, List<AuthPermitDto> userPermit)
        {
            StringBuilder html = new StringBuilder();
            html.Append($"<div class='EntityFeedLevel{level}'><a style='float:left;cursor:pointer;'><img src='..{att.resource_avatar}' /></a> ");
            html.Append($"<div class='PostContent' style='width:auto;padding-right:10px;'><a class='PostContentName'>{att.resource_name}</a>");
            if (att.resource_id != userId && !string.IsNullOrEmpty(att.resource_email))
                html.Append($"<a href='mailto:{att.resource_email}' class='SmallLink'>发送邮件</a>");

            if (att.att_type_id == (int)DicEnum.ATTACHMENT_TYPE.URL)
                html.Append($"<a title='{att.att_filename}' onclick=\"OpenAttachment({att.id},1,'{att.att_filename}')\" ><img src='../Images/LiveLinksindex.png' /><span style='cursor:pointer; '>{att.act_name}</span></a>");
            else
                html.Append($"<a title='{att.att_filename}' onclick=\"OpenAttachment({att.id},0,'')\" ><img src='../Images/LiveLinksindex.png' /><span style='cursor:pointer; '>{att.act_name}</span></a>");

            html.Append($"<div class='EntityDateTimeLinks'><span class='MostRecentPostedTime'>");
            html.Append($"{att.act_date}</span>");

            if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_NOTES_ADD_NOTE"))
                html.Append($"<a onclick='NoteAddNote({cate},{level},{(int)DicEnum.OBJECT_TYPE.ATTACHMENT},{att.id})' class='CommentLink'>添加备注</a>");
            if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_NOTES_ADD_ATTACHMENT"))
                html.Append($"<a onclick='NoteAddAttach({att.id},{(int)DicEnum.ATTACHMENT_OBJECT_TYPE.ATTACHMENT})' class='CommentLink'>添加附件</a>");
            if (AuthBLL.CheckAuth(secLevelId, userPermit, "CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_NOTES_DELETE"))
                html.Append($"<a onclick='AttDelete({att.id})' class='CommentLink'>删除</a>");

            html.Append("</div></div>");
            if (att.att_type_id == (int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT)
            {
                var file = new AttachmentBLL().GetAttachment(att.id);
                if (file.content_type != null && file.content_type.ToLower().IndexOf("image") == 0)
                {
                    html.Append($"<a><img src='..{file.href}' style='width:50px;height:50px;' /></a>");
                }
            }
            html.Append("</div>");

            if (level == 3)
                return html.ToString();
            if (cate == 2 && level == 2)
                return html.ToString();

            IOrderedEnumerable<v_activity> actList1;    // 下级备注和附件
            if (level == 1)
                actList1 = from act in actList where act.id_1lv == att.id && act.lv == 2 orderby act.act_date_2lv ascending select act;
            else
                actList1 = from act in actList where att.id.ToString().Equals(act.id_2lv) && act.lv == 3 orderby act.act_date ascending select act;

            //var actList = new v_activity_dal().GetActivities(att.id, level + 1, null);
            foreach (var act in actList1)
            {
                if (act.act_cate != null && act.act_cate.Equals("act"))
                    html.Append(GetNoteHtml(actList, act, cate, userId, level + 1, secLevelId, userPermit));
                else if (act.act_cate != null && act.act_cate.Equals("att"))
                    html.Append(GetAttachmentHtml(actList, act, cate, userId, level + 1, secLevelId, userPermit));
            }

            if (level == 1)
                html.Append("<hr class='activityTitlerighthr' />");

            return html.ToString();
        }

        /// <summary>
        /// 活动页面快捷新增备注
        /// </summary>
        /// <param name="objId">客户id/联系人id/商机id/销售订单id</param>
        /// <param name="objType">account/contact/opportunity/salesorder</param>
        /// <param name="typeId"></param>
        /// <param name="desc"></param>
        /// <param name="userId"></param>
        public void FastAddNote(long objId, string objType, int typeId, string desc, long userId)
        {
            if (objId <= 0 || objType == null)
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
            note.status_id = null;

            if (objType.Equals("account"))
            {
                note.object_id = objId;
                note.object_type_id = (int)DicEnum.OBJECT_TYPE.CUSTOMER;
                note.account_id = objId;
            }
            else if (objType.Equals("contact"))
            {
                note.object_id = objId;
                note.object_type_id = (int)DicEnum.OBJECT_TYPE.CONTACT;
                var accountId = new ContactBLL().GetContact(objId).account_id;
                note.account_id = accountId;
                note.contact_id = objId;
            }
            else if (objType.Equals("opportunity"))
            {
                note.object_id = objId;
                note.object_type_id = (int)DicEnum.OBJECT_TYPE.OPPORTUNITY;
                var opp = new OpportunityBLL().GetOpportunityById(objId);
                note.account_id = opp.account_id;
                note.contact_id = opp.contact_id;
                note.opportunity_id = objId;
            }
            else if (objType.Equals("salesorder"))
            {
                note.object_id = objId;
                note.object_type_id = (int)DicEnum.OBJECT_TYPE.SALEORDER;
                note.sales_order_id = objId;
                var opp = new OpportunityBLL().GetOpportunityById(new SaleOrderBLL().GetSaleOrder(objId).opportunity_id);
                note.opportunity_id = opp.id;
                note.account_id = opp.account_id;
                note.contact_id = opp.contact_id;
            }

            dal.Insert(note);
            OperLogBLL.OperLogAdd<com_activity>(note, note.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "快捷新增备注");
        }
        
        /// <summary>
        /// 活动列表中快速添加备注
        /// </summary>
        /// <param name="objectTypeId">对象类型id</param>
        /// <param name="objectId">对象id</param>
        /// <param name="cate">对应v_activity视图cate</param>
        /// <param name="level">层级(最多三级，一级为备注或附件时最多两级)</param>
        /// <param name="desc"></param>
        /// <param name="isNotify"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool FastAddNote(int objectTypeId, long objectId, long cate,int level, string desc, bool isNotify, long userId)
        {
            var note = new com_activity();
            long parentId;
            int parentType;

            // 先获取新增备注的上级对象和对象类型
            if (level == 3 || (level == 2 && cate == 2))      // 已到最大级，实际上级为上级的上级
            {
                if (objectTypeId == (int)DicEnum.OBJECT_TYPE.NOTES)
                {
                    var curt = dal.FindById(objectId);
                    parentType = curt.object_type_id;
                    parentId = curt.object_id;
                }
                else if (objectTypeId == (int)DicEnum.OBJECT_TYPE.ATTACHMENT)
                {
                    var curt = new com_attachment_dal().FindById(objectId);
                    parentType = curt.object_type_id;
                    parentId = curt.object_id;

                    // 为附件时转换对象类型
                    if (parentType == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.ATTACHMENT)
                        parentType = (int)DicEnum.OBJECT_TYPE.ATTACHMENT;
                    else if (parentType == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.CONTRACT)
                        parentType = (int)DicEnum.OBJECT_TYPE.CONTRACT;
                    else if (parentType == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.NOTES)
                        parentType = (int)DicEnum.OBJECT_TYPE.NOTES;
                    else if (parentType == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.OPPORTUNITY)
                        parentType = (int)DicEnum.OBJECT_TYPE.OPPORTUNITY;
                    else if (parentType == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.SALES_ORDER)
                        parentType = (int)DicEnum.OBJECT_TYPE.SALEORDER;
                    else
                        return false;
                }
                else
                    return false;
            }
            else    // 未达到最大级，上级即为上级
            {
                parentType = objectTypeId;
                parentId = objectId;
            }


            // 根据不同对象类型填充不同数据
            note.object_id = parentId;
            note.object_type_id = parentType;
            if (parentType==(int)DicEnum.OBJECT_TYPE.NOTES)     // 上级为备注
            {
                var parentNote = dal.FindById(parentId);
                if (parentNote == null || parentNote.delete_time > 0)
                    return false;

                note.cate_id = parentNote.cate_id;
                note.account_id = parentNote.account_id;
                note.contact_id = parentNote.contact_id;
                note.parent_id = parentNote.id;
                note.action_type_id = (int)DicEnum.ACTIVITY_TYPE.GRAFFITI_RECORD;
                note.opportunity_id = parentNote.opportunity_id;
                note.ticket_id = parentNote.ticket_id;
                note.contract_id = parentNote.contract_id;
                note.resource_id = parentNote.resource_id;
            }
            else
            {
                note.parent_id = null;
                note.cate_id = (int)DicEnum.ACTIVITY_CATE.NOTE;
                note.action_type_id = (int)DicEnum.ACTIVITY_TYPE.GRAFFITI_RECORD;
                if (parentType == (int)DicEnum.OBJECT_TYPE.CUSTOMER)
                {
                    note.account_id = parentId;
                }
                else if (parentType == (int)DicEnum.OBJECT_TYPE.CONTACT)
                {
                    note.contact_id = parentId;
                    note.account_id = new ContactBLL().GetContact(parentId).account_id;
                }
                else if (parentType == (int)DicEnum.OBJECT_TYPE.OPPORTUNITY)
                {
                    note.opportunity_id = parentId;
                    var opp = new crm_opportunity_dal().FindById(parentId);
                    note.account_id = opp.account_id;
                    note.contact_id = opp.contact_id;
                }
                else if (parentType == (int)DicEnum.OBJECT_TYPE.SALEORDER)
                {
                    note.sales_order_id = parentId;
                    var opp = new crm_opportunity_dal().FindById(new crm_sales_order_dal().FindById(parentId).opportunity_id);
                    note.opportunity_id = opp.id;
                    note.account_id = opp.account_id;
                    note.contact_id = opp.contact_id;
                }
                else if (parentType == (int)DicEnum.OBJECT_TYPE.CONTRACT)
                {
                    note.cate_id = (int)DicEnum.ACTIVITY_CATE.CONTRACT_NOTE;
                    note.action_type_id = (int)DicEnum.ACTIVITY_TYPE.CONTRACT_NOTE;
                    var contract = new ContractBLL().GetContract(parentId);
                    note.contract_id = parentId;
                    if (contract.opportunity_id == null)
                    {
                        note.account_id = contract.account_id;
                    }
                    else
                    {
                        var opp = new crm_opportunity_dal().FindById((long)contract.opportunity_id);
                        note.account_id = opp.account_id;
                        note.contact_id = opp.contact_id;
                        note.opportunity_id = opp.id;
                    }
                }
                else if (parentType == (int)DicEnum.OBJECT_TYPE.PROJECT)
                {
                }
                else if (parentType == (int)DicEnum.OBJECT_TYPE.ATTACHMENT)     // 附件
                {
                    var att = new com_attachment_dal().FindById(parentId);
                    if (att.account_id == null)
                        return false;
                    note.account_id = att.account_id;

                    // 根据附件的对象类型获取到商机/合同等信息
                    if(att.object_type_id==(int)DicEnum.ATTACHMENT_OBJECT_TYPE.CONTRACT)
                    {
                        var contract = new ContractBLL().GetContract(att.object_id);
                        note.contract_id = att.object_id;
                        if (contract.opportunity_id != null)
                        {
                            var opp = new crm_opportunity_dal().FindById((long)contract.opportunity_id);
                            note.contact_id = opp.contact_id;
                            note.opportunity_id = opp.id;
                        }
                    }
                    else if (att.object_type_id == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.OPPORTUNITY)
                    {
                        var opp = new crm_opportunity_dal().FindById(att.object_id);
                        note.contact_id = opp.contact_id;
                        note.opportunity_id = opp.id;
                    }
                    else if (att.object_type_id == (int)DicEnum.ATTACHMENT_OBJECT_TYPE.SALES_ORDER)
                    {
                        note.sales_order_id = att.object_id;
                        var opp = new crm_opportunity_dal().FindById(new crm_sales_order_dal().FindById(att.object_id).opportunity_id);
                        note.opportunity_id = opp.id;
                        note.contact_id = opp.contact_id;
                    }
                }
                else
                    return false;
            }
            

            note.description = desc;
            note.status_id = null;
            note.start_date = Tools.Date.DateHelper.ToUniversalTimeStamp();
            note.end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now.AddMinutes(15));

            note.id = dal.GetNextIdCom();
            note.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            note.update_time = note.create_time;
            note.create_user_id = userId;
            note.update_user_id = userId;

            dal.Insert(note);
            OperLogBLL.OperLogAdd<com_activity>(note, note.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");
            return true;
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
            if (note.object_type_id==0)
            {
                addNote.object_id = (long)note.account_id;
                addNote.object_type_id = (int)DicEnum.OBJECT_TYPE.CUSTOMER;
            }
            else
            {
                addNote.object_id = note.object_id;
                addNote.object_type_id = note.object_type_id;
            }
            if (note.object_type_id == (int)DicEnum.OBJECT_TYPE.SALEORDER)
                addNote.sales_order_id = note.object_id;
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
            if (todo.object_type_id == 0)
            {
                addTodo.object_id = (long)todo.account_id;
                addTodo.object_type_id = (int)DicEnum.OBJECT_TYPE.CUSTOMER;
            }
            else
            {
                addTodo.object_id = todo.object_id;
                addTodo.object_type_id = todo.object_type_id;
            }
            if (todo.object_type_id == (int)DicEnum.OBJECT_TYPE.SALEORDER)
                addTodo.sales_order_id = todo.object_id;
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
            if (addTodo.object_type_id == (int)DicEnum.OBJECT_TYPE.SALEORDER)
                addTodo.sales_order_id = addTodo.object_id;
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
            if (editTodo.object_type_id == (int)DicEnum.OBJECT_TYPE.SALEORDER)
                editTodo.sales_order_id = editTodo.object_id;
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
