using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class IndexBLL
    {
        /// <summary>
        /// 插入到通知关联员工表
        /// </summary>
        public void InsertNoticeRes(List<sys_notice> noticList,long userId)
        {
            if (noticList == null || noticList.Count == 0)
                return;
            var snrDal = new sys_notice_resource_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            foreach (var notice in noticList)
            {
                var thisNoticRes = snrDal.GetByResNotic(notice.id,userId);
                if (thisNoticRes != null)
                {
                    if (thisNoticRes.is_show == 1)
                    {
                        thisNoticRes.is_show = 0;
                        snrDal.Update(thisNoticRes);
                    }
                    continue;
                }
                thisNoticRes = new sys_notice_resource() {
                    id = snrDal.GetNextIdCom(),
                    notice_id = notice.id,
                    resource_id = userId,
                    is_show = 0,
                    first_show_time = timeNow,
                    status_changed_time = timeNow,
                };
                snrDal.Insert(thisNoticRes);
            }
        }
        /// <summary>
        /// 是否下次登陆继续通知
        /// </summary>
        public bool ChangeNoticeNext(long noticeId,long userId,bool isShow)
        {
            var snrDal = new sys_notice_resource_dal();
            var thisNoticRes = snrDal.GetByResNotic(noticeId, userId);
            if (thisNoticRes == null)
                return false;
            var show = (sbyte)(isShow ? 1 : 0);
            if(thisNoticRes.is_show!= show)
            {
                thisNoticRes.is_show = show;
                snrDal.Update(thisNoticRes);
            }
            return true;
        }
        /// <summary>
        /// 获取查询的数量
        /// </summary>
        public Dictionary<string,int> GetIndexSearchCount(long userId)
        {
            Dictionary<string, int> dic = new Dictionary<string, int>();
            var _dal = new sdk_task_dal();

            #region 服务台相关数量
            var actCount = _dal.GetTicketCount($"  and status_id <> {(int)DicEnum.TICKET_STATUS.DONE} and (owner_resource_id = {userId}||EXISTS(SELECT 1 from sdk_task_resource r where r.task_id = t.id and r.resource_id={userId}))");
            var overRecCount = _dal.GetTicketCount($"  and status_id <> {(int)DicEnum.TICKET_STATUS.DONE} and estimated_end_time<(unix_timestamp(now()) *1000) and (owner_resource_id = {userId}||EXISTS(SELECT 1 from sdk_task_resource r where r.task_id = t.id and r.resource_id={userId}))");
            var myRecCount = _dal.GetTicketCount($" and t.create_user_id = {userId}");
            //var completeRecCount = _dal.GetTicketCount(" and status_id = " + (int)DicEnum.TICKET_STATUS.DONE + $" and (owner_resource_id = {userId}||EXISTS(SELECT 1 from sdk_task_resource r where r.task_id = t.id and r.resource_id={userId}))");
            var myTaskTicketCount = _dal.GetCount($"select COUNT(1) from sdk_task t where delete_time = 0 and (t.owner_resource_id={userId} or EXISTS(select 1 from sdk_task_resource where delete_time=0 and task_id=t.id  and resource_id={userId})) ");
            var callCount = Convert.ToInt32(_dal.GetSingle($"select COUNT(1) from (select a.*, round((a.start_time-a.canceled_time)/1000/3600,2)dist_hours,(select z.priority_type_id from  sdk_service_call_task y,sdk_task z where  y.task_id=z.id and y.service_call_id=a.id limit 1)priority_type_id from sdk_service_call a where delete_time=0)t where 1=1     and EXISTS (select 1 from sdk_service_call_task y,sdk_service_call_task_resource z where z.delete_time=0 and y.delete_time=0 and  z.service_call_task_id=y.id and y.service_call_id=t.id and z.resource_id={userId}) order by  t.start_time desc"));
            dic.Add("activeTicket", actCount);
            dic.Add("overTicket", overRecCount);
            dic.Add("myTicket", myRecCount);
            //dic.Add("completeTicket", completeRecCount);
            dic.Add("myTaskTicket", myTaskTicketCount);
            dic.Add("myCall", callCount);
            #endregion

            #region CRM相关数量
            var myAccountCount = Convert.ToInt32(_dal.GetSingle(@"select count(1)  from crm_account a 
join crm_account_ext e on a.id = e.parent_id
where a.delete_time = 0
  and(
(a.type_id in(14, 18) and(
(select limit_type_value_id FROM v_user_limit where user_id = " + userId + @" and limit_Id = 51) = 970 or
(select limit_type_value_id FROM v_user_limit where user_id = " + userId + @" and limit_Id = 51) = 971 and(1 = 0 or a.resource_id = " + userId + @"  or exists(select 1 from crm_account_team where account_id = a.id and resource_id = " + userId+ @")  or exists(select 1 from sys_resource_territory where delete_time = 0 and territory_id = a.territory_id and resource_id = " + userId + @")) or
(select limit_type_value_id FROM v_user_limit where user_id = " + userId + @" and limit_Id = 51) = 972 and(1 = 0 or a.resource_id = " + userId + @"  or exists(select 1 from crm_account_team where account_id = a.id and resource_id = " + userId + @"))
 )) or
(a.type_id in(19, 20) and(
(select limit_type_value_id FROM v_user_limit where user_id = " + userId + @" and limit_Id = 52) = 977
)) OR
(a.type_id in(15, 16, 17) and(
(select limit_type_value_id FROM v_user_limit where user_id = " + userId + @" and limit_Id = 53) = 970 or
(select limit_type_value_id FROM v_user_limit where user_id = " + userId + @" and limit_Id = 53) = 971 and(1 = 0 or a.resource_id = " + userId + @"  or exists(select 1 from crm_account_team where account_id = a.id and resource_id = " + userId + @")  or exists(select 1 from sys_resource_territory where delete_time = 0 and territory_id = a.territory_id and resource_id = " + userId + @")) or
(select limit_type_value_id FROM v_user_limit where user_id = " + userId + @" and limit_Id = 53) = 972 and(1 = 0 or a.resource_id = " + userId + @"  or exists(select 1 from crm_account_team where account_id = a.id and resource_id = " + userId + @"))
))  
)  and a.resource_id in(" + userId + ")"));


            var myOpportunityCount = Convert.ToInt32(_dal.GetSingle(@"select count(1)  from crm_opportunity o
join crm_account a on o.account_id = a.id
left join (select * from crm_quote where delete_time=0 and is_primary_quote=1) q on o.id = q.opportunity_id where o.delete_time=0  and (
( a.type_id in(14,18) and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=970 or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=971 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")  or exists(select 1 from sys_resource_territory where delete_time=0 and territory_id=a.territory_id and resource_id=" + userId + @")) or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=972 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")) 
 )) or 
( a.type_id in(19,20) and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=52)=977  
)) OR 
( a.type_id in(15,16,17) and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=53)=970 or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=53)=971 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")  or exists(select 1 from sys_resource_territory where delete_time=0 and territory_id=a.territory_id and resource_id=" + userId + @")) or 
(select limit_type_value_id FROM v_user_limit where user_id =1 and limit_Id=53)=972 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")) 
))  
)  and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=57)=974 or
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=57)=975 and (1=0 or o.resource_id=" + userId + @" )
)        and o.resource_id in(" + userId + @") order by  o.name "));


            var mySaleCount = Convert.ToInt32(_dal.GetSingle(@"select count(1) FROM crm_sales_order s 
LEFT JOIN  crm_opportunity o
on o.id = s.opportunity_id 
left JOIN (select * from crm_quote where is_primary_quote=1 )q on o.id = q.opportunity_id 
left join crm_account a on q.account_id = a.id where s.delete_time=0  and (
( a.type_id in(14,18) and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=970 or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=971 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")  or exists(select " + userId + @" from sys_resource_territory where delete_time=0 and territory_id=a.territory_id and resource_id=" + userId + @")) or
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=972 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @"))
 )) or 
( a.type_id in(19,20) and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=52)=977 
)) OR 
( a.type_id in(15,16,17) and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=53)=970 or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=53)=971 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")  or exists(select 1 from sys_resource_territory where delete_time=0 and territory_id=a.territory_id and resource_id=" + userId + @")) or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=53)=972 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")) 
))  
)  and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=61)=974 or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=61)=975 and (1=0 or s.owner_resource_id=" + userId + @" )
)        and s.owner_resource_id in(" + userId + @")"));

            var myContactCount = Convert.ToInt32(_dal.GetSingle(@"select COUNT(1) from crm_contact c 
join crm_contact_ext e on c.id = e.parent_id 
join crm_account a on c.account_id = a.id 
  and (
( a.type_id in(14,18) and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=970 or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=971 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")  or exists(select 1 from sys_resource_territory where delete_time=0 and territory_id=a.territory_id and resource_id=" + userId + @")) or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=972 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @"))
 )) or 
( a.type_id in(19,20) and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=52)=977  
)) OR 
( a.type_id in(15,16,17) and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=53)=970 or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=53)=971 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")  or exists(select 1 from sys_resource_territory where delete_time=0 and territory_id=a.territory_id and resource_id=" + userId + @")) or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=53)=972 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")) 
))  
)            and (a.resource_id =" + userId + ")"));

            var myQuoteCount = Convert.ToInt32(_dal.GetSingle(@"select count(1) from crm_quote q
JOIN crm_opportunity o on q.opportunity_id=o.id
join crm_account a on o.account_id = a.id
LEFT JOIN (select quote_id,sum(unit_price*quantity) total_revenue from crm_quote_item GROUP BY quote_id)i on q.id=i.quote_id where q.delete_time=0  and (
( a.type_id in(14,18) and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=970 or
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=971 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")  or exists(select 1 from sys_resource_territory where delete_time=0 and territory_id=a.territory_id and resource_id=" + userId + @")) or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=51)=972 and  (1=0 or a.resource_id=1  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")) 
 )) or 
( a.type_id in(19,20) and (
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=52)=977  
)) OR 
( a.type_id in(15,16,17) and (-- 领导者、潜在客户、终止合作权限53
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=53)=970 or 
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=53)=971 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")  or exists(select 1 from sys_resource_territory where delete_time=0 and territory_id=a.territory_id and resource_id=" + userId + @")) or
(select limit_type_value_id FROM v_user_limit where user_id =" + userId + @" and limit_Id=53)=972 and  (1=0 or a.resource_id=" + userId + @"  or exists(select 1 from crm_account_team where account_id=a.id and resource_id=" + userId + @")) 
))  
)  and (
(select limit_type_value_id FROM v_user_limit where user_id =1 and limit_Id=57)=974 or 
(select limit_type_value_id FROM v_user_limit where user_id =1 and limit_Id=57)=975 and (1=0 or o.resource_id=" + userId + @" )
)        and o.resource_id in(" + userId + @")"));
            var myNoteCount = Convert.ToInt32(_dal.GetSingle($"select COUNT(1) from com_activity t join crm_account a on t.account_id = a.id where t.delete_time = 0  and cate_id in(31)  and t.resource_id in({userId})"));
            var myTodoCount = Convert.ToInt32(_dal.GetSingle($"select count(1) from com_activity t where t.delete_time = 0 and(t.cate_id in(30) or t.cate_id in(31) and t.status_id is not null) and t.resource_id in({userId}) "));
            dic.Add("MyAccount", myAccountCount);
            dic.Add("MyOpportunity", myOpportunityCount);
            dic.Add("MySale", mySaleCount);
            dic.Add("MyContact", myContactCount);
            dic.Add("MyQuote", myQuoteCount);
            dic.Add("MyNote", myNoteCount);
            dic.Add("MyTodo", myTodoCount);
            #endregion

            #region 工时表相关数量
            var requestCount = Convert.ToInt32(_dal.GetSingle($"select COUNT(1) from tst_timeoff_request t where delete_time=0 and t.resource_id in({userId}) and  status_id={(int)DicEnum.TIMEOFF_REQUEST_STATUS.COMMIT}"));
            dic.Add("RequestCount", myTodoCount);
            #endregion

            #region 等待我审批相关数量
            var waitLabourCount = Convert.ToInt32(_dal.GetSingle($"select count(1) from sdk_work_entry_report t join sys_resource r on t.resource_id=r.id where t.delete_time=0 and t.status_id={(int)DicEnum.WORK_ENTRY_REPORT_STATUS.WAITING_FOR_APPROVAL}  "));
            var waitRequestCount = Convert.ToInt32(_dal.GetSingle($"select COUNT(1) from tst_timeoff_request t join sys_resource r on t.resource_id=r.id where t.delete_time=0 and t.status_id={(int)DicEnum.TIMEOFF_REQUEST_STATUS.COMMIT}"));
            var waitExpenseCount = Convert.ToInt32(_dal.GetSingle($"select count(1)  from sdk_expense_report t where t.delete_time=0  and t.status_id={(int)DicEnum.EXPENSE_REPORT_STATUS.WAITING_FOR_APPROVAL}"));
            var waitChangeCount = Convert.ToInt32(_dal.GetSingle($"select COUNT(1) from sdk_task t where   t.type_id in(1809) and t.delete_time = 0 and  t.ticket_type_id=129    and exists(select 1 from sdk_task_other_person where task_id=t.id and delete_time=0 and approve_status_id ={(int)DicEnum.CHANGE_APPROVE_STATUS_PERSON.WAIT}) and exists(select 1 from sdk_task_other_person where task_id=t.id and delete_time=0 and resource_id ={userId} ) "));
            dic.Add("waitLabour", waitLabourCount);
            dic.Add("waitRequest", waitRequestCount);
            dic.Add("waitExpense", waitExpenseCount);
            dic.Add("waitChange", waitChangeCount);
            #endregion

            #region 其他相关数量

            #endregion
            return dic;
        }
        /// <summary>
        /// 浏览历史管理
        /// </summary>
        public void BrowseHistory(sys_windows_history history,long userId)
        {
            var swhDal = new sys_windows_history_dal();
            var oldHis = swhDal.GetByUrl(history.url,userId);
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var tt = Tools.Date.DateHelper.ToUniversalTimeStamp();
            if (oldHis != null)
            {
                oldHis.create_time = timeNow;
                oldHis.create_user_id = userId;
                swhDal.Update(oldHis);
            }
            else
            {
                history.id = swhDal.GetNextIdCom();
                history.create_time = timeNow;
                history.create_user_id = userId;
                swhDal.Insert(history);
                // todo 删除50之后的数据
                swhDal.DeletFifty();
            }
        }
        /// <summary>
        /// 清除所有的浏览历史
        /// </summary>
        public bool ClearHistory(long? userId)
        {
            var swhDal = new sys_windows_history_dal();
            var allList = swhDal.GetHisList(userId);
            if(allList!=null&& allList.Count > 0)
            {
                allList.ForEach(_ => {
                    swhDal.Delete(_);
                });
            }
            return true;
        }
        /// <summary>
        /// 获取历史列表
        /// </summary>
        public List<sys_windows_history> GetHistoryList(long? userId = null)
        {
            return new sys_windows_history_dal().GetHisList(userId);
        }
        /// <summary>
        /// 书签
        /// </summary>
        public bool BookMarkManage(string url,string title,long userId)
        {
            var sbDal = new sys_bookmark_dal();
            var oldBook = sbDal.GetSingBook(url,userId);
            if (oldBook == null)
            {
                oldBook = new sys_bookmark();
                oldBook.id = sbDal.GetNextIdCom();
                oldBook.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                oldBook.create_user_id = userId;
                oldBook.url = url;
                oldBook.title = title;
                sbDal.Insert(oldBook);
            }
            else
                return sbDal.DeleteBook(oldBook.id.ToString(), userId);
            return true;
        }
        /// <summary>
        /// 获取书签信息
        /// </summary>
        public sys_bookmark GetSingBook(string url,long userId)
        {
            return new sys_bookmark_dal().GetSingBook(url, userId);
        }
        /// <summary>
        /// 根据Ids 删除相关书签
        /// </summary>
        public bool DeleteBookByIds(string ids,long userId)
        {
            var sbDal = new sys_bookmark_dal();
            return sbDal.DeleteBook(ids, userId);
        }
        /// <summary>
        /// 删除该用户下的所有书签
        /// </summary>
        public bool DeleteAllBook(long userId)
        {
            var sbDal = new sys_bookmark_dal();
            return sbDal.DeleteBook(userId);
        }
    }
}
