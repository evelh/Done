﻿using System;
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
        /// <summary>
        /// 获取本周的星期一
        /// </summary>
        public DateTime GetMonday(DateTime date)
        {
            if ((int)date.DayOfWeek != 1)
            {
                if ((int)date.DayOfWeek == 0)
                    date = date.AddDays(-6);
                else
                    date = date.AddDays(1 - (int)date.DayOfWeek);
            }
            return date;
        }
        /// <summary>
        /// 获取本周的周末
        /// </summary>
        public DateTime GetSunDay(DateTime date)
        {
            if (date.DayOfWeek != DayOfWeek.Sunday)
            {
                date = date.AddDays(7-(int)date.DayOfWeek);
            }
            return date;
        }

        /// <summary>
        /// 根据开始时间和结束时间计算两个时间相差的月，周，天数
        /// </summary>
        public int GetDateDiffMonth(DateTime startDate, DateTime endDate, string dateType)
        {
            int num = 0;
            TimeSpan ts1 = new TimeSpan(startDate.Ticks);
            TimeSpan ts2 = new TimeSpan(endDate.Ticks);
            TimeSpan ts = ts1.Subtract(ts2).Duration();
            num = ts.Days;
            switch (dateType)
            {
                case "day":
                    num = ts.Days;
                    break;
                case "week":
                    var week = num / 7;
                    if (num % 7 != 0)
                    {
                        num = week + 1;
                    }
                    else
                    {
                        num = week;
                    }
                    break;
                case "month":
                    num = (endDate.Year - startDate.Year) * 12 + (endDate.Month - startDate.Month + 1);
                    // + (endDate.Day >= startDate.Day ? 1 : 0)
                    break;
                default:
                    break;
            }
            return num;
        }
        /// <summary>
        /// 根据选择的日期获取相应类名，
        /// </summary>
        public string ReturnClassName(DateTime chooseDate,DateTime thisDay,long userId)
        {
            // 过期 Overlap
            // 有待办 预定~  Important
            // 今天 Today
            // 本月天数无信息 ""
            string className = "";
            if(thisDay.Year!= chooseDate.Year || thisDay.Month != chooseDate.Month)
                className += "Overlap ";
            if(thisDay.Year == DateTime.Now.Year&& thisDay.Month == DateTime.Now.Month && thisDay.Day == DateTime.Now.Day)
                className += "Today ";
            var dBll = new DispatchBLL();
            var appList = dBll.GetAppByResDate(userId, thisDay);
            if(appList!=null&& appList.Count > 0)
            {
                className += "Important";
                return className;
            }
            var todoList = new ActivityBLL().GetToListByResDate(userId, thisDay);
            if (todoList != null && todoList.Count > 0)
            {
                className += "Important";
                return className;
            }
            var callList = new TicketBLL().GetCallByResDate(userId, thisDay);
            if (callList != null && callList.Count > 0)
            {
                className += "Important";
                return className;
            }
            var timeList = new TimeOffPolicyBLL().GetTimeOffByResDate(userId, thisDay);
            if (timeList != null && timeList.Count > 0)
            {
                className += "Important";
                return className;
            }
            return className;
        }

        #region 工作列表相关
        /// <summary>
        /// 移除我的工单/任务 列表
        /// </summary>
        public bool DeleteWorkTicket(long userId, bool isTicket = true)
        {
            var swltDal = new sys_work_list_task_dal();
            var mtTaskList = swltDal.GetMyWorkList(userId,isTicket);
            if(mtTaskList!=null&& mtTaskList.Count > 0)
            {
                mtTaskList.ForEach(_ => {
                    swltDal.Delete(_);
                });
            }
            return true;
        }
        /// <summary>
        /// 删除指定的工作列表中的数据
        /// </summary>
        public bool DeleteSingWorkTicket(string ids,long userId)
        {
            if (!string.IsNullOrEmpty(ids))
            {
                var idArr = ids.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                var swltDal = new sys_work_list_task_dal();
                foreach (var thisId in idArr)
                {
                    var thisWorkTask = swltDal.FindById(long.Parse(thisId));
                    if (thisWorkTask != null)
                    {
                        swltDal.Delete(thisWorkTask);
                    }
                }
            }
            return true;
        }
        /// <summary>
        /// 根据任务Id 和登录用户获取相关列表信息并删除
        /// </summary>
        public bool DeleteSingWorkTicket(long taskId, long userId)
        {
            var swltDal = new sys_work_list_task_dal();
            var thisWorkTask = swltDal.GetByResTaskId(userId,taskId);
            if (thisWorkTask != null)
                swltDal.Delete(thisWorkTask);
            var nextList = swltDal.GetTaskListBySort(userId, thisWorkTask.sort_order);
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (nextList != null && nextList.Count > 0)
                nextList.ForEach(_ => {
                    _.update_time = timeNow;
                    _.sort_order = _.sort_order - 1;
                    swltDal.Update(_);
                });
            return true;
        }
        /// <summary>
        /// 我的工作列表排序号改变
        /// </summary>
        public bool WorkListSortManage(long userId,string ids,bool isTicket = true)
        {
            var swltDal = new sys_work_list_task_dal();
            var oldTaskList = swltDal.GetMyWorkList(userId,isTicket);
            var newTaskList = swltDal.GetTaskListByTaskIds(userId,ids);
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var idArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            if (oldTaskList != null&& newTaskList != null && oldTaskList.Count== newTaskList.Count&& idArr.Count()== newTaskList.Count)
            {
                for (int i = 0; i < oldTaskList.Count; i++)
                {
                    var thisWorkTask = newTaskList.FirstOrDefault(_ => _.task_id.ToString() == idArr[i]);
                    if (thisWorkTask == null)
                        continue;
                    if (thisWorkTask.sort_order == oldTaskList[i].sort_order)
                        continue;
                    thisWorkTask.sort_order = oldTaskList[i].sort_order;
                    thisWorkTask.update_time = timeNow;
                    swltDal.Update(thisWorkTask);
                }
            }
            return true;
        }
        /// <summary>
        /// 拖拽 - 更改排序号
        /// </summary>
        public void ChangeSort(sys_work_list_task firWorTas, sys_work_list_task lasWorTask,long userId)
        {
            var swltDal = new sys_work_list_task_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (firWorTas.sort_order> lasWorTask.sort_order)
            {
                var changeList = swltDal.FindListBySql($"SELECT * from sys_work_list_task where resource_id = {userId} and sort_order>={lasWorTask.sort_order} and sort_order<{firWorTas.sort_order}");
                if (changeList != null && changeList.Count > 0)
                {
                    changeList.ForEach(_ => {
                        _.update_time = timeNow;
                        _.sort_order = _.sort_order + 1;
                        swltDal.Update(_);
                    });
                    firWorTas.update_time = timeNow;
                    firWorTas.sort_order = lasWorTask.sort_order;
                    swltDal.Update(firWorTas);
                }
            }
            else
            {
                var changeList = swltDal.FindListBySql($"SELECT * from sys_work_list_task where resource_id = {userId} and sort_order>{firWorTas.sort_order} and sort_order<={lasWorTask.sort_order}");
                if(changeList!=null&& changeList.Count > 0)
                {
                    changeList.ForEach(_ => {
                        _.update_time = timeNow;
                        _.sort_order = _.sort_order - 1;
                        swltDal.Update(_);
                    });
                    firWorTas.update_time = timeNow;
                    firWorTas.sort_order = lasWorTask.sort_order;
                    swltDal.Update(firWorTas);
                }
            }
        }

        public bool ChangeWorkTaskSort(long firstTaskId,long lastTaskId,long userId)
        {
            if (firstTaskId == lastTaskId)
                return false;
            var swltDal = new sys_work_list_task_dal();
            var firWorTask = swltDal.GetByResTaskId(userId, firstTaskId);
            var lasWorTask = swltDal.GetByResTaskId(userId, lastTaskId);
            if (firWorTask == null || lasWorTask == null)
                return false;
            ChangeSort(firWorTask, lasWorTask,userId);
            return true;
        }

        /// <summary>
        /// 添加到我的工作列表
        /// </summary>
        public bool AddToWorkList(long taskId,long resId,long userId)
        {
            var swltDal = new sys_work_list_task_dal();
            var singWorkTask = swltDal.GetByResTaskId(resId, taskId);
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (singWorkTask == null)
            {
                singWorkTask = new sys_work_list_task() {
                    id = swltDal.GetNextIdCom(),
                    resource_id = resId,
                    task_id = taskId,
                    create_time = timeNow,
                    create_user_id = userId,
                    update_time = timeNow,
                    sort_order = swltDal.GetMaxSortOrder(userId)+1,
                };
                swltDal.Insert(singWorkTask);
            }
            return true;
        }
        /// <summary>
        /// 添加到多个员工的工作列表
        /// </summary>
        public bool AddToManyWorkList(string resIds,long taskId,long userId)
        {
            if (!string.IsNullOrEmpty(resIds))
            {
                var resArr = resIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                foreach (var resId in resArr)
                {
                    AddToWorkList(taskId,long.Parse(resId), userId);
                }
            }
            return true;
        }
        /// <summary>
        /// 工作清单管理
        /// </summary>
        public bool SysWorkSetting(bool sendMyWork,bool autoStart,long userId)
        {
            var swlDal = new sys_work_list_dal();
            var thisWork = swlDal.GetByResId(userId);
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var isAuto = (sbyte)(autoStart ? 1 : 0);
            var isKeep = (sbyte)(sendMyWork ? 1 : 0);
            if (thisWork != null)
            {
                if(thisWork.auto_start!= isAuto|| thisWork.keep_running!= isKeep)
                {
                    thisWork.auto_start = isAuto;
                    thisWork.keep_running = isKeep;
                    thisWork.update_time = timeNow;
                    thisWork.update_user_id = userId;
                    swlDal.Update(thisWork);
                }
            }
            else
            {
                thisWork = new sys_work_list()
                {
                    id = swlDal.GetNextIdCom(),
                    auto_start = isAuto,
                    create_time = timeNow,
                    create_user_id = userId,
                    keep_running = isKeep,
                    resource_id = userId,
                    update_time = timeNow,
                    update_user_id = userId,
                };
                swlDal.Insert(thisWork);
            }
            return true;
        }
        #endregion
    }
}
