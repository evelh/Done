using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// IndexAjax 的摘要说明
    /// </summary>
    public class IndexAjax : BaseAjax
    {
        protected IndexBLL indexBll = new IndexBLL();
        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "SearchHistoryManage":
                    SearchHistoryManage(context);
                    break;
                case "LoadSearchHistory":  // 加载查询历史
                    LoadSearchHistory(context);
                    break;
                case "ChangeNoticeNext":
                    ChangeNoticeNext(context);
                    break;
                case "ClearHistory":
                    ClearHistory(context);
                    break;
                case "LoadBrowerHistory":  // 加载浏览历史
                    LoadBrowerHistory(context);
                    break;
                case "BookMarkManage":
                    BookMarkManage(context);
                    break;
                case "LoadBook":
                    LoadBook(context);
                    break;
                case "DeleteChooseBook":
                    DeleteChooseBook(context);
                    break;
                case "DeleteAllBook":
                    DeleteAllBook(context);
                    break;
                case "LoadDispatch": // 加载调度工作室日历
                    LoadDispatch(context);
                    break;
                case "DeleteWorkTicket":
                    DeleteWorkTicket(context);
                    break;
                case "DeleteSingWorkTicket":    // 根据Id 删除列表信息
                    DeleteSingWorkTicket(context);
                    break;
                case "DeleteSingWorkTicketByTaskId":  // 根据工单ID 删除列表信息
                    DeleteSingWorkTicketByTaskId(context);
                    break;
                case "AddWorkList":
                    AddWorkList(context);
                    break;
                case "LoadMyTicketWorkList":
                    LoadMyTicketWorkList(context);
                    break;    
                case "LoadMyTaskWorkList":
                    LoadMyTaskWorkList(context);
                    break;
                case "ChangeWorkTaskSort":   // 工作列表拖拽
                    ChangeWorkTaskSort(context);
                    break;
                case "WorkListSortManage": // 工作列表拖拽
                    WorkListSortManage(context);
                    break;
                default:
                    break;
            }
        }
        /// <summary>
        /// 新增编辑快速查询记录
        /// </summary>
        public void SearchHistoryManage(HttpContext context)
        {
            var result = false;
            var id = context.Request.QueryString["id"];
            
            if (!string.IsNullOrEmpty(id))
            {
                var search = new DAL.sys_recent_search_dal().FindById(long.Parse(id));
                if (search != null)
                    result = new DispatchBLL().ManageSearch(search,LoginUserId);
            }
            else
            {
                var searchText = context.Request.QueryString["searchText"];
                var searchType = context.Request.QueryString["searchType"];
                var searchTypeName = context.Request.QueryString["searchTypeName"];
                var url = context.Request.QueryString["url"];
                var searchDto = new DTO.QuickSearchDto() {
                    Condition = searchText,
                    Name = searchTypeName,
                    SearchType = searchType
                };
                var conditions = new Tools.Serialize().SerializeJson(searchDto);
                var search = new DAL.sys_recent_search_dal().GetByCon(conditions,url);
                if (search != null)
                    result = new DispatchBLL().ManageSearch(search, LoginUserId);
                else
                {
                    search = new Core.sys_recent_search()
                    {
                        conditions = conditions,
                        url = url,
                        title = "",
                    };
                    result = new DispatchBLL().ManageSearch(search, LoginUserId);
                }
               

            }
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 获取查询历史信息
        /// </summary>
        public void LoadSearchHistory(HttpContext context)
        {
            var url = context.Request.QueryString["url"];
            var list = new DAL.sys_recent_search_dal().GetListByUpdate(url);
            if(list!=null&& list.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(list));

            }
        }
        /// <summary>
        /// 是否下次登陆继续通知
        /// </summary>
        public void ChangeNoticeNext(HttpContext context)
        {
            var result = false;
            var noticeId = context.Request.QueryString["id"];
            var isAlert = context.Request.QueryString["isAlert"] == "1";
            if(!string.IsNullOrEmpty(noticeId))
                result = new IndexBLL().ChangeNoticeNext(long.Parse(noticeId), LoginUserId, isAlert);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 清除浏览历史
        /// </summary>
        public void ClearHistory(HttpContext context)
        {
            var result = false;
            result = new IndexBLL().ClearHistory(LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 获取浏览历史
        /// </summary>
        public void LoadBrowerHistory(HttpContext context)
        {
            var hisList = new IndexBLL().GetHistoryList(LoginUserId);
            if(hisList!=null&& hisList.Count > 0)
            {
                if (hisList.Count >= 50)
                    hisList = hisList.Take(50).ToList();
                context.Response.Write(new Tools.Serialize().SerializeJson(hisList));
            }
        }
        /// <summary>
        /// 获取书签信息
        /// </summary>
        public void LoadBook(HttpContext context)
        {
            var bookList = new DAL.sys_bookmark_dal().GetBookList(LoginUserId);
            if (bookList != null && bookList.Count > 0)
            {
                if (bookList.Count >= 50)
                    bookList = bookList.Take(50).ToList();
                context.Response.Write(new Tools.Serialize().SerializeJson(bookList));
            }
        }

        /// <summary>
        /// 书签管理
        /// </summary>
        public void BookMarkManage(HttpContext context)
        {
            var url = context.Request.QueryString["url"];
            var title = context.Request.QueryString["title"];
            var result = new IndexBLL().BookMarkManage(url,title,LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 删除选中的书签
        /// </summary>
        public void DeleteChooseBook(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"];
            var result = new IndexBLL().DeleteBookByIds(ids,LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 删除全部书签
        /// </summary>
        public void DeleteAllBook(HttpContext context)
        {
            var result = new IndexBLL().DeleteAllBook(LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 加载调度日历
        /// </summary>
        public void LoadDispatch(HttpContext context)
        {
            var chooseDateString = context.Request.QueryString["chooseDate"];
            if (!string.IsNullOrEmpty(chooseDateString))
            {
                
                var chooseDate = DateTime.Parse(chooseDateString);
                var firstDay = indexBll.GetMonday(DateTime.Parse(chooseDate.ToString("yyyy-MM")+"-01"));
                int monthDays = DateTime.DaysInMonth(chooseDate.Year, chooseDate.Month);  // 当月的天数
                var lastDay = indexBll.GetSunDay(DateTime.Parse(chooseDate.ToString("yyyy-MM") + "-"+ monthDays.ToString("00")));
                var weekNums = indexBll.GetDateDiffMonth(firstDay, lastDay, "week");
                var disHtml = new System.Text.StringBuilder();
                for (int i = 0; i < weekNums; i++)
                {
                    var days = i * 7;
                    var thisMonthDay = firstDay.AddDays(days);
                    disHtml.Append("<tr>");
                    //for (int j = 0; j < 7; j++)
                    //{
                    //    var thisDay = thisMonthDay.AddDays(j);
                    //    disHtml.Append($"<td class='{indexBll.ReturnClassName(chooseDate,thisDay,LoginUserId)}'>{thisDay.Day}</td>");
                    //}
                    disHtml.Append(AddHtml(chooseDate, thisMonthDay));
                    disHtml.Append("</tr>");
                }
                context.Response.Write(new Tools.Serialize().SerializeJson(new {showToMonth= chooseDate.Year.ToString()+"年 "+ chooseDate.Month.ToString()+"月",lastMonth = chooseDate.AddMonths(-1).ToString("yyyy-MM")+"-01",nextMonth = chooseDate.AddMonths(1).ToString("yyyy-MM") + "-01",content = disHtml.ToString() }));
            }
        }
        /// <summary>
        /// 日历Html 代码↑
        /// </summary>
        public string AddHtml(DateTime chooseDate,DateTime thisMonDay)
        {
            string html = "";
            for (int i = 0; i < 7; i++)
            {
                html += $"<td class='{indexBll.ReturnClassName(chooseDate, thisMonDay.AddDays(i), LoginUserId)}' onclick=\"ToSingDispatch('{thisMonDay.AddDays(i).ToString("yyyy-MM-dd")}')\">{thisMonDay.AddDays(i).Day}</td>";
            }
            
            return html;
        }
        /// <summary>
        /// 删除工作列表的工单/任务
        /// </summary>
        public void DeleteWorkTicket(HttpContext context)
        {
            bool isTicket = !string.IsNullOrEmpty(context.Request.QueryString["isTicket"]);
            var result = indexBll.DeleteWorkTicket(LoginUserId,isTicket);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 删除指定的工作列表
        /// </summary>
        public void DeleteSingWorkTicket(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"];
            var result = false;
            if (!string.IsNullOrEmpty(ids))
                result = indexBll.DeleteSingWorkTicket(ids,LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 根据工单ID 删除指定的列表信息
        /// </summary>
        /// <param name="context"></param>
        public void DeleteSingWorkTicketByTaskId(HttpContext context)
        {
            var taskId = context.Request.QueryString["taskId"];
            var result = false;
            if (!string.IsNullOrEmpty(taskId))
                result = indexBll.DeleteSingWorkTicket(long.Parse(taskId), LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 添加到工作列表
        /// </summary>
        public void AddWorkList(HttpContext context)
        {
            var resIds = context.Request.QueryString["resIds"];
            var taskId = context.Request.QueryString["taskId"];
            var result = false;
            if (!string.IsNullOrEmpty(resIds) && !string.IsNullOrEmpty(taskId))
                result = indexBll.AddToManyWorkList(resIds,long.Parse(taskId),LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 展示我的工单工作列表
        /// </summary>
        public void LoadMyTicketWorkList(HttpContext context)
        {
            QueryCommonBLL bll = new QueryCommonBLL();
            var ticketResultPara = bll.GetResultParaSelect(LoginUserId, 264);// groupId
            QueryParaDto tickeQueryPara = new QueryParaDto();
            tickeQueryPara.query_params = new List<Para>();
            tickeQueryPara.query_params.Add(new Para() { id=3572,value=LoginUserId.ToString()});
            tickeQueryPara.query_type_id =  (int)QueryType.MyWorkListTicket;
            tickeQueryPara.para_group_id = 264;
            var ticketQueryResult = bll.GetResult(LoginUserId, tickeQueryPara);
            System.Text.StringBuilder thisHtml = new System.Text.StringBuilder();
            var thisWorkList = new DAL.sys_work_list_dal().GetByResId(LoginUserId);
            var isJiShi = "";  // 页面打开工单时，是否计时
            if (thisWorkList != null && thisWorkList.auto_start == 1)
                isJiShi = "JiShi";
            if (ticketQueryResult != null&& ticketQueryResult.result!=null)
            {
                var stDal = new DAL.sdk_task_dal();
                foreach (var rslt in ticketQueryResult.result)
                {
                    // DisabledState 不计时 添加此状态禁用
                    
                    if (ticketResultPara != null && ticketResultPara.Count > 0)
                    {
                        
                        var id = "";
                        var idPara = ticketResultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);
                        if (idPara != null)
                            id = rslt[idPara.name].ToString();
                        if (id == "")
                            continue;
                        var thisTicket = stDal.FindNoDeleteById(long.Parse(id));
                        if (thisTicket == null)
                            continue;
                        var isDisabled = "";
                        if (thisTicket.status_id == (int)DicEnum.TICKET_STATUS.DONE)
                            isDisabled = "DisabledState";
                        thisHtml.AppendFormat($"<div class='WorkListItem' data-task-id='{id}'><div class='Left'  onclick=\"PageNewOpenTicket('{id}','{isJiShi}')\"><div class='StopwatchContainer {id}ThisWatch'><div class='StopwatchTime {isDisabled}'>{(!string.IsNullOrEmpty(isDisabled)?"--:--:--":"00:00:00")}</div><div class='StopwatchButton Play {isDisabled}'></div><div class='StopwatchButton Record {isDisabled}'></div><div class='StopwatchButton Stop {isDisabled}'></div></div><div class='WorkListLineItemDetailsContainer'>");
                        //ticketResultPara = ticketResultPara.Where(_=>_.type!= (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID).Take(6).ToList();
                        foreach (var para in ticketResultPara)
                        {
                            if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID)
                                continue;
                            thisHtml.Append("<p>"+rslt[para.name]+"</p>");
                        }
                        thisHtml.AppendFormat("</div></div><div class='Right'><div class='WorkListItemButtons'><div class='WorkListClose Icon' onclick=\"NewOpenTicket('{0}')\"></div><div class='WorkListArrow Icon' onclick=\"RemoveWorkListTicket('{0}','1')\"></div></div><div class='Grip'></div></div></div>", id);
                    }
                   
                }
            }
            context.Response.Write(thisHtml.ToString());
        }
        /// <summary>
        /// 展示我的任务工作列表
        /// </summary>
        public void LoadMyTaskWorkList(HttpContext context)
        {
            QueryCommonBLL bll = new QueryCommonBLL();
            var taskResultPara = bll.GetResultParaSelect(LoginUserId, 265);
            QueryParaDto taskQueryPara = new QueryParaDto();
            taskQueryPara.query_params = new List<Para>();
            taskQueryPara.query_params.Add(new Para() { id = 3573, value = LoginUserId.ToString() });
            taskQueryPara.query_type_id = (int)QueryType.MyWorkListTask;
            taskQueryPara.para_group_id = 265;
            var taskQueryResult = bll.GetResult(LoginUserId, taskQueryPara);
            System.Text.StringBuilder thisHtml = new System.Text.StringBuilder();
            if (taskQueryResult != null&& taskQueryResult.result!=null)
            {
                foreach (var rslt in taskQueryResult.result)
                {
                    // DisabledState 不计时 添加此状态禁用
                   
                    var id = "";
                    if (taskResultPara != null && taskResultPara.Count > 0)
                    {
                        var idPara = taskResultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);
                        if (idPara != null)
                            id = rslt[idPara.name].ToString();
                        thisHtml.AppendFormat($"<div class='WorkListItem' data-task-id='{id}'><div class='Left'  onclick=\"PageNewOpenTask('{id}')\"><div class='WorkListLineItemDetailsContainer'>");
                        foreach (var para in taskResultPara)
                        {
                            if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID)
                                continue;
                            thisHtml.Append("<p>" + rslt[para.name] + "</p>");
                        }
                        thisHtml.AppendFormat("</div></div><div class='Right'><div class='WorkListItemButtons'><div class='WorkListClose Icon' onclick=\"NewOpenTask('{0}')\"></div><div class='WorkListArrow Icon' onclick=\"RemoveWorkListTicket('{0}','')\"></div></div><div class='Grip'></div></div></div>", id);
                    }
                   
                }
            }
            context.Response.Write(thisHtml.ToString());
        }
        /// <summary>
        /// 拖拽改变排序号
        /// </summary>
        public void ChangeWorkTaskSort(HttpContext context)
        {
            var result = false;
            var firstTaskId = context.Request.QueryString["firstTaskId"];
            var lastTaskId = context.Request.QueryString["lastTaskId"];
            if (!string.IsNullOrEmpty(firstTaskId) && !string.IsNullOrEmpty(lastTaskId))
                result = indexBll.ChangeWorkTaskSort(long.Parse(firstTaskId),long.Parse(lastTaskId),LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 拖拽更改序号
        /// </summary>
        public void WorkListSortManage(HttpContext context)
        {
            var result = false;
            var ids = context.Request.QueryString["taskIds"];
            var isTiket = !string.IsNullOrEmpty(context.Request.QueryString["isTicket"]);
            if (!string.IsNullOrEmpty(ids))
                result = indexBll.WorkListSortManage(LoginUserId,ids,isTiket);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
    }
}