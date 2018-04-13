using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class DispatcherWorkshopView : BasePage
    {
        protected List<sdk_dispatcher_view> viewList = new DispatchBLL().GetDisViewList();  // 视图列表
        protected sdk_dispatcher_view chooseView;     // 代表选择的视图
        protected DateTime chooseDate = DateTime.Now;
        protected DateTime showDate = DateTime.Now;
        protected long dateType = (int)DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW;
        protected List<sys_resource> resList = null;
        protected string resIds;
        protected List<sys_workgroup> workList = null;
        protected string workIds;
        protected bool isShowNoRes = false;
        protected bool isShowCanCall = false;
        protected DispatchBLL dBll = new DispatchBLL();
        protected TicketBLL ticketBll = new TicketBLL();
        protected CompanyBLL acccBll = new CompanyBLL();
        protected List<d_general> timeRequestStatus = new DAL.d_general_dal().GetGeneralByTableId((long)DTO.GeneralTableEnum.TIMEOFF_REQUEST_STATUS);
        protected List<d_general> priorityList = new DAL.d_general_dal().GetGeneralByTableId((long)DTO.GeneralTableEnum.TASK_PRIORITY_TYPE);   // 工单优先级集合
        protected List<d_general> ticStaList = new DAL.d_general_dal().GetGeneralByTableId((long)DTO.GeneralTableEnum.TICKET_STATUS);          // 工单状态集合
        protected List<d_general> todiAction = new DAL.d_general_dal().GetGeneralByTableId((long)DTO.GeneralTableEnum.ACTION_TYPE);
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var viewId = Request.QueryString["viewId"];
                // viewId = "17700";
                if (!string.IsNullOrEmpty(viewId))
                {
                    chooseView = new DAL.sdk_dispatcher_view_dal().FindNoDeleteById(long.Parse(viewId));
                    if (chooseView != null)
                    {
                        dateType = chooseView.mode_id;
                        if (!string.IsNullOrEmpty(chooseView.resource_ids))
                            resList = new DAL.sys_resource_dal().GetListByIds(chooseView.resource_ids, false);
                        if (!string.IsNullOrEmpty(chooseView.workgroup_ids))
                            workList = new DAL.sys_workgroup_dal().GetList($" and id in({chooseView.workgroup_ids})");
                        resIds = chooseView.resource_ids;
                        workIds = chooseView.workgroup_ids;
                        if (chooseView.show_unassigned == 1)
                            isShowNoRes = true;
                        if (chooseView.show_canceled == 1)
                            isShowCanCall = true;
                    }
                }
                if (!string.IsNullOrEmpty(Request.QueryString["resIds"]))
                    resIds = Request.QueryString["resIds"];
                if (!string.IsNullOrEmpty(resIds))
                    resList = new DAL.sys_resource_dal().GetListByIds(resIds, false);
                if (!string.IsNullOrEmpty(Request.QueryString["workIds"]))
                    workIds = Request.QueryString["workIds"];
                if (!string.IsNullOrEmpty(workIds))
                    workList = new DAL.sys_workgroup_dal().GetList($" and id in({workIds})");
                if (!string.IsNullOrEmpty(Request.QueryString["showNoRes"]))
                    isShowNoRes = Request.QueryString["showNoRes"] == "1";
                if (!string.IsNullOrEmpty(Request.QueryString["showCanCall"]))
                    isShowCanCall = Request.QueryString["showCanCall"] == "1";
                if (!string.IsNullOrEmpty(Request.QueryString["modeId"]))
                    dateType = long.Parse(Request.QueryString["modeId"]);
                var chooseDateString = Request.QueryString["chooseDate"];
                //  chooseDateString = "2018-04-03";
                if (!string.IsNullOrEmpty(chooseDateString))
                    chooseDate = DateTime.Parse(chooseDateString);

                // 记录员工的每天使用时间
                Dictionary<string, Dictionary<string, decimal>> userTimeDic = new Dictionary<string, Dictionary<string, decimal>>();

                var limitDays = 5;  // 页面上显示的天数
                switch (dateType)
                {
                    case (int)DTO.DicEnum.DISPATCHER_MODE.ONE_DAY_VIEW:
                        showDate = chooseDate;
                        limitDays = 1;
                        break;
                    case (int)DTO.DicEnum.DISPATCHER_MODE.FIVE_DAY_WORK_VIEW:
                        showDate = GetMonday(chooseDate);
                        limitDays = 7;
                        break;
                    case (int)DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW_FROM_SELECTED_DAY:
                        showDate = chooseDate;
                        limitDays = 7;
                        break;
                    default:
                        showDate = GetMonday(chooseDate);
                        break;
                }
                if (limitDays != 1)
                {
                    #region 获取用户相关
                    var liUserHtml = new System.Text.StringBuilder();
                    if (isShowNoRes)
                        liUserHtml.Append($"<li><div class='name'><a onclick='' style='font-size:10px;color: #376597;'></a></div><div class='icon'></div></li>");
                    if (resList != null && resList.Count > 0)
                    {
                        resList.ForEach(_ =>
                        {
                            liUserHtml.Append($"<li><div class='name'><a onclick='' style='font-size:10px;color: #376597;'>{_.name}</a></div><div class='icon'><img style = 'margin: 5px 0;' src='..{(!string.IsNullOrEmpty(_.avatar) ? _.avatar : "/Images/pop.jpg")}' alt='' /></div></li>");
                        });
                    }
                    liUser.Text = liUserHtml.ToString();

                    var liGroupHtml = new System.Text.StringBuilder();
                    if (workList != null && workList.Count > 0)
                    {
                        foreach (var thisWork in workList)
                        {
                            var thisResList = new DAL.sys_workgroup_dal().GetResouListByWorkIds(thisWork.id.ToString());
                            if (thisResList != null && thisResList.Count > 0)
                            {
                                liGroupHtml.Append($"<div class='ContainerDays'><div class='Days-3'>{thisWork.name}</div></div>");
                                liGroupHtml.Append("<ul class='ContainerUser'>");
                                foreach (var thisRes in thisResList)
                                {
                                    liGroupHtml.Append($"<li><div class='name'><a onclick='' style='font-size:10px;color: #376597;'>{thisRes.name}</a></div><div class='icon'><img style = 'margin: 5px 0;' src='..{(!string.IsNullOrEmpty(thisRes.avatar) ? thisRes.avatar : "/Images/pop.jpg")}' alt='' /></div></li>");
                                }
                                liGroupHtml.Append("</ul>");
                            }
                        }
                    }
                    liGroup.Text = liGroupHtml.ToString();
                    #endregion

                    #region 获取时间内容相关
                    var liContentHtml = new System.Text.StringBuilder();
                    if (isShowNoRes)
                    {

                        liContentHtml.Append("<ul class='R-ContainerUser'>");
                        for (int i = 0; i < limitDays; i++)
                        {
                            var thisDay = showDate.AddDays(i);
                            decimal callHours;
                            var callHtml = GetNoResDateCall(thisDay, out callHours);
                            var allUserHours = callHours;
                            var allRemainHours = 0;
                            var userHtml = $"<li><div class='UserTime'><div class='UserTime-border1' style='background-color:{(((allRemainHours - allUserHours) > 0 ? "#FF4863" : "#8cc73f"))};'></div><div class='UserTime-text2'><p><a>{allUserHours.ToString("#0.00")}/{allRemainHours.ToString("#0.00")}</a><a><span style='width: 50%;text-align: center;'> {(allUserHours * 100 / (allRemainHours == 0 ? 1 : allRemainHours)).ToString("#0.00")}% </span><span style='width: 50%;text-align: right;'>{(allRemainHours - allUserHours).ToString("#0.00")}</span></a></p></div></div><div class='UserContainer' data-date='" + thisDay.ToString("yyyy-MM-dd") + "'>";
                            liContentHtml.Append(userHtml + callHtml);
                            liContentHtml.Append("<p></p>");                       // 最后的时间
                            liContentHtml.Append($"</div></li>");
                        }
                        liContentHtml.Append("</ul>");

                    }
                    if (resList != null && resList.Count > 0)
                    {
                        foreach (var res in resList)
                        {
                            liContentHtml.Append("<ul class='R-ContainerUser'>");
                            for (int i = 0; i < limitDays; i++)
                            {
                                var thisDay = showDate.AddDays(i);
                                var thisKey = res.id.ToString() + res.name + "_" + (thisDay.ToString("yyyy-MM-dd"));
                                if (!userTimeDic.Any(_ => _.Key == thisKey))
                                    userTimeDic.Add(thisKey, new Dictionary<string, decimal>());
                                // todo 获取员工的可用时间，剩余时间
                                decimal timeHours;
                                decimal appiontHours;
                                decimal todoHours;
                                decimal callHours;

                                var timeHtml = GetResDateTime(res.id, thisDay, out timeHours);
                                var appHtml = GetResDateApp(res.id, thisDay, out appiontHours);
                                var todoHtml = GetResDateTodo(res.id, thisDay, out todoHours);
                                var callHtml = GetResDateCall(res.id, thisDay, out callHours);
                                var allUserHours = appiontHours + todoHours + callHours;
                                var allRemainHours = ((thisDay.DayOfWeek == DayOfWeek.Sunday || thisDay.DayOfWeek == DayOfWeek.Saturday) ? 0 : 8) - timeHours;
                                var userHtml = $"<li><div class='UserTime'><div class='UserTime-border1' style='background-color:{(((allRemainHours - allUserHours) > 0 ? "#FF4863" : "#8cc73f"))};'></div><div class='UserTime-text2'><p><a>{allUserHours.ToString("#0.00")}/{allRemainHours.ToString("#0.00")}</a><a><span style='width: 50%;text-align: center;'> {(allUserHours * 100 / (allRemainHours == 0 ? 1 : allRemainHours)).ToString("#0.00")}% </span><span style='width: 50%;text-align: right;'>{(allRemainHours - allUserHours).ToString("#0.00")}</span></a></p></div></div><div class='UserContainer' data-date='{thisDay.ToString("yyyy-MM-dd")}' data-res='{res.id.ToString()}'>";
                                liContentHtml.Append(userHtml + timeHtml + appHtml + todoHtml + callHtml);
                                liContentHtml.Append("<p></p>");                       // 最后的时间
                                liContentHtml.Append($"</div></li>");

                                if (!userTimeDic[thisKey].ContainsKey("UserHours"))
                                    userTimeDic[thisKey].Add("UserHours", allUserHours);
                                // userTimeDic[thisKey]["UserHours"] += ;

                                if (!userTimeDic[thisKey].ContainsKey("RemainHours"))
                                    userTimeDic[thisKey].Add("RemainHours", allRemainHours);
                                // userTimeDic[thisKey]["RemainHours"] += allRemainHours;
                            }
                            liContentHtml.Append("</ul>");
                        }
                    }

                    if (workList != null && workList.Count > 0)
                    {

                        foreach (var thisWork in workList)
                        {
                            var workTotalHtml = new System.Text.StringBuilder();
                            var workContentHtml = new System.Text.StringBuilder();
                            var thisResList = new DAL.sys_workgroup_dal().GetResouListByWorkIds(thisWork.id.ToString());
                            if (thisResList != null && thisResList.Count > 0)
                            {
                                workTotalHtml.Append("<ul class='R-ContainerDays'>");
                                foreach (var res in thisResList)
                                {
                                    workContentHtml.Append("<ul class='R-ContainerUser'>");
                                    for (int i = 0; i < limitDays; i++)
                                    {
                                        var thisDay = showDate.AddDays(i);
                                        var thisKey = res.id.ToString() + res.name + "_" + (thisDay.ToString("yyyy-MM-dd"));
                                        if (!userTimeDic.Any(_ => _.Key == thisKey))
                                            userTimeDic.Add(thisKey, new Dictionary<string, decimal>());
                                        decimal timeHours;
                                        decimal appiontHours;
                                        decimal todoHours;
                                        decimal callHours;

                                        var timeHtml = GetResDateTime(res.id, thisDay, out timeHours);
                                        var appHtml = GetResDateApp(res.id, thisDay, out appiontHours);
                                        var todoHtml = GetResDateTodo(res.id, thisDay, out todoHours);
                                        var callHtml = GetResDateCall(res.id, thisDay, out callHours);
                                        var allUserHours = appiontHours + todoHours + callHours;
                                        var allRemainHours = ((thisDay.DayOfWeek == DayOfWeek.Sunday || thisDay.DayOfWeek == DayOfWeek.Saturday) ? 0 : 8) - timeHours;
                                        var userHtml = $"<li><div class='UserTime'><div class='UserTime-border1' style='background-color:{(((allRemainHours - allUserHours) > 0 ? "#FF4863" : "#8cc73f"))};'></div><div class='UserTime-text2'><p><a>{allUserHours.ToString("#0.00")}/{allRemainHours.ToString("#0.00")}</a><a><span style='width: 50%;text-align: center;'> {(allUserHours * 100 / (allRemainHours == 0 ? 1 : allRemainHours)).ToString("#0.00")}% </span><span style='width: 50%;text-align: right;'>{(allRemainHours - allUserHours).ToString("#0.00")}</span></a></p></div></div><div class='UserContainer' data-date='{ thisDay.ToString("yyyy-MM-dd") }' data-res='{res.id.ToString()}'>";
                                        workContentHtml.Append(userHtml + timeHtml + appHtml + todoHtml + callHtml);
                                        workContentHtml.Append("<p></p>");                       // 最后的时间
                                        workContentHtml.Append($"</div></li>");

                                        if (!userTimeDic[thisKey].ContainsKey("UserHours"))
                                            userTimeDic[thisKey].Add("UserHours", allUserHours);
                                        // userTimeDic[thisKey]["UserHours"] += ;

                                        if (!userTimeDic[thisKey].ContainsKey("RemainHours"))
                                            userTimeDic[thisKey].Add("RemainHours", allRemainHours);
                                        // userTimeDic[thisKey]["RemainHours"] += allRemainHours;
                                    }
                                    workContentHtml.Append("</ul>");
                                }
                                for (int i = 0; i < limitDays; i++)
                                {
                                    var thisDay = showDate.AddDays(i);
                                    var personalTotalDic = userTimeDic.Where(_ => _.Key.Contains(thisDay.ToString("yyyy-MM-dd")) && thisResList.Any(r => _.Key.Contains(r.id.ToString() + r.name))).ToDictionary(_ => _.Key, _ => _.Value);
                                    decimal totalPerosonUserHours = 0;
                                    decimal totalPerosonRemainHours = 0;
                                    foreach (var total in personalTotalDic)
                                    {
                                        totalPerosonUserHours += total.Value["UserHours"];
                                        totalPerosonRemainHours += total.Value["RemainHours"];
                                    }
                                    workTotalHtml.Append($"<li><div class='Days-3'><div class='Days3-border1'></div><div class='Days3-text2'><p><a style ='text-align: left'>{totalPerosonUserHours.ToString("#0.00")} / {totalPerosonRemainHours.ToString("#0.00")} </a><a style='text-align: right'><span style = 'display: block;width: 50%;text-align: center;float: left;'>{(totalPerosonUserHours * 100 / (totalPerosonRemainHours != 0 ? totalPerosonRemainHours : 1)).ToString("#0.00")}%</span> <span style='display: block;width: 50%;text-align: center;float: left;'>{(totalPerosonRemainHours - totalPerosonUserHours).ToString("#0.00")}</span></a></p></div></div></li>");
                                }
                                workTotalHtml.Append("</ul>");
                                liContentHtml.Append(workTotalHtml.ToString() + workContentHtml.ToString());
                            }
                        }
                    }
                    liTicket.Text = liContentHtml.ToString();
                    #endregion

                    #region 获取时间相关
                    var liTimeHtml = new System.Text.StringBuilder();

                    for (int i = 0; i < limitDays; i++)
                    {
                        var thisDay = showDate.AddDays(i);
                        var personalTotalDic = new Dictionary<string, Dictionary<string, decimal>>();    // 只包含个人的，工作组中没有的个人信息汇总
                        if (resList != null && resList.Count > 0)
                        {
                            personalTotalDic = userTimeDic.Where(_ => _.Key.Contains(thisDay.ToString("yyyy-MM-dd")) && resList.Any(r => _.Key.Contains(r.id.ToString() + r.name))).ToDictionary(_ => _.Key, _ => _.Value);
                        }
                        decimal totalPerosonUserHours = 0;
                        decimal totalPerosonRemainHours = 0;
                        foreach (var total in personalTotalDic)
                        {
                            totalPerosonUserHours += total.Value["UserHours"];
                            totalPerosonRemainHours += total.Value["RemainHours"];
                        }
                        var totalDic = userTimeDic.Where(_ => _.Key.Contains(thisDay.ToString("yyyy-MM-dd"))).ToDictionary(_ => _.Key, _ => _.Value);
                        decimal totalUserHours = 0;
                        decimal totalRemainHours = 0;
                        foreach (var total in totalDic)
                        {
                            totalUserHours += total.Value["UserHours"];
                            totalRemainHours += total.Value["RemainHours"];
                        }
                        var backTotalColor = "#FF4863";  // 红
                        var diffTotalTime = totalRemainHours - totalUserHours;
                        if (totalUserHours >= totalRemainHours)
                            backTotalColor = "#8cc73f";  // 黄
                        else if (diffTotalTime > 0 && diffTotalTime < totalRemainHours)
                            backTotalColor = "#FFF799";  // 绿

                        var backColor = "#FF4863";
                        var diffTime = totalPerosonRemainHours - totalPerosonUserHours;
                        if (totalPerosonUserHours >= totalPerosonRemainHours)
                            backColor = "#8cc73f";
                        else if (diffTime > 0 && diffTime < totalPerosonRemainHours)
                            backColor = "#FFF799";
                        liTimeHtml.Append($"<li><div class='Days-1'><div class='Day-1-border1' style='background-color:{backTotalColor};'></div><div class='Day-1-border2'></div><div class='Day-1-text3'><p>{weekArr[(int)thisDay.DayOfWeek]} {thisDay.ToString("yyyy-MM-dd")}</p><p><a style = 'text-align: left'> {totalUserHours.ToString("#0.00")} / {totalRemainHours.ToString("#0.00")} </a><a style='text-align: right'><span style = 'display: block;width: 50%;text-align: center;float: left;'>{(totalUserHours * 100 / (totalRemainHours != 0 ? totalRemainHours : 1)).ToString("#0.00")}</span><span  style='display: block;width: 50%;text-align: center;float: left;'>{(totalRemainHours - totalUserHours).ToString("#0.00")}</span></a></p></div></div><div class='Days-2'></div>");
                        liTimeHtml.Append($"<div class='Days-3'><div class='Days3-border1'  style='background-color:{backColor};'></div><div class='Days3-text2'><p><a style = 'text-align: left' > {totalPerosonUserHours.ToString("#0.00")} / {totalPerosonRemainHours.ToString("#0.00")} </a><a style='text-align: right'><span style = 'display: block;width: 50%;text-align: center;float: left;'>{(totalPerosonUserHours * 100 / (totalPerosonRemainHours != 0 ? totalPerosonRemainHours : 1)).ToString("#0.00")}%</span><span  style='display: block;width: 50%;text-align: center;float: left;'>{(totalPerosonRemainHours - totalPerosonUserHours).ToString("#0.00")}</span></a></p></div></div>");
                        liTimeHtml.Append($"</li>");
                    }
                    liTime.Text = liTimeHtml.ToString();
                    #endregion
                }
                else
                {
                    #region 用户和工作组的展示
                    var singContentHtml = new System.Text.StringBuilder();
                    if (isShowNoRes)
                    {
                        var thisDay = chooseDate;
                        decimal callHours;
                        var callHtml  = GetNoResDateCall(thisDay, out callHours,true);
                        var allRemainHours = ((thisDay.DayOfWeek == DayOfWeek.Sunday || thisDay.DayOfWeek == DayOfWeek.Saturday) ? 0 : 8) ;
                        singContentHtml.Append($"<ul class='HouverTask'><li style='min-height:27px;margin-bottom: 1px;height:auto;border-width: 0px;'><div class='border'></div><div class='Hover-t'></div></li><li data-res='' data-date='{chooseDate.ToString("yyyy-MM-dd HH:mm")}'><div class='border'></div><div class='TaskConter'><div class='t1'>{callHtml}</div><div class='t2'></div></div></li>");
                        for (int i = 0; i < 23; i++)
                        {
                            singContentHtml.Append($"<li {(i >= 7 && i <= 18 ? "style = 'background-color:white;'" : "")} data-res='' data-date='{chooseDate.AddHours(i).ToString("yyyy-MM-dd HH:mm")}'><div class='border'></div><div class='TaskConter'><div class='t1'></div><div class='t2'></div></div></li>");
                        }
                        singContentHtml.Append("</ul>");
                    }
                    if (resList != null && resList.Count > 0)
                    {
                        foreach (var res in resList)
                        {
                            var thisDay = chooseDate;
                            var thisKey = res.id.ToString() + res.name + "_" + (chooseDate.ToString("yyyy-MM-dd"));
                            if (!userTimeDic.Any(_ => _.Key == thisKey))
                                userTimeDic.Add(thisKey, new Dictionary<string, decimal>());
                            // todo 获取员工的可用时间，剩余时间
                            decimal timeHours;
                            decimal appiontHours;
                            decimal todoHours;
                            decimal callHours;

                            var timeHtml = GetResDateTime(res.id, thisDay, out timeHours);  // 休假单独显示
                            var appHtml = GetResSingDateApp(res.id, thisDay, out appiontHours);
                            var todoHtml = GetResSingDateTodo(res.id, thisDay, out todoHours);
                            var callHtml = GetSingResDateCall(res.id, thisDay, out callHours);
                            var allUserHours = appiontHours + todoHours + callHours;
                            var allRemainHours = ((thisDay.DayOfWeek == DayOfWeek.Sunday || thisDay.DayOfWeek == DayOfWeek.Saturday) ? 0 : 8) - timeHours;
                            singContentHtml.Append($"<ul class='HouverTask'><li style='min-height:27px;margin-bottom: 1px;height:auto;border-width: 0px;'><div class='border'></div><div class='Hover-t'>{timeHtml}</div></li><li data-res='{res.id.ToString()}' data-date='{chooseDate.ToString("yyyy-MM-dd HH:mm")}'><div class='border'></div><div class='TaskConter'><div class='t1'>{appHtml + todoHtml + callHtml}</div><div class='t2'></div></div></li>"); 
                           for (int i = 0; i< 23; i++)
                            {
                                singContentHtml.Append($"<li {(i>=7&&i<=18? "style = 'background-color:white;'" : "")} data-res='{res.id.ToString()}' data-date='{chooseDate.AddHours(i+1).ToString("yyyy-MM-dd HH:mm")}'><div class='border'></div><div class='TaskConter'><div class='t1'></div><div class='t2'></div></div></li>");
                            }
                            singContentHtml.Append("</ul>");
                        
                            //singContentHtml.Append( appHtml + todoHtml + callHtml);
                            //if (string.IsNullOrEmpty(appHtml) && string.IsNullOrEmpty(todoHtml) && string.IsNullOrEmpty(callHtml))
                                //singContentHtml.Append("<div class='HouverTaskItem' style='margin-top:0px; height: 0.1px;'></div>");

                            if (!userTimeDic[thisKey].ContainsKey("UserHours"))
                                userTimeDic[thisKey].Add("UserHours", allUserHours);
                            // userTimeDic[thisKey]["UserHours"] += ;

                            if (!userTimeDic[thisKey].ContainsKey("RemainHours"))
                                userTimeDic[thisKey].Add("RemainHours", allRemainHours);
                        }
                       

                    }
                    if (workList != null && workList.Count > 0)
                    {
                        foreach (var thisWork in workList)
                        {
                            var thisResList = new DAL.sys_workgroup_dal().GetResouListByWorkIds(thisWork.id.ToString());
                            if (thisResList != null && thisResList.Count > 0)
                            {
                                foreach (var res in thisResList)
                                {
                                    var thisDay = chooseDate;
                                    var thisKey = res.id.ToString() + res.name + "_" + (chooseDate.ToString("yyyy-MM-dd"));
                                    if (!userTimeDic.Any(_ => _.Key == thisKey))
                                        userTimeDic.Add(thisKey, new Dictionary<string, decimal>());
                                    // todo 获取员工的可用时间，剩余时间
                                    decimal timeHours;
                                    decimal appiontHours;
                                    decimal todoHours;
                                    decimal callHours;

                                    var timeHtml = GetResDateTime(res.id, thisDay, out timeHours);  // 休假单独显示
                                    var appHtml = GetResSingDateApp(res.id, thisDay, out appiontHours);
                                    var todoHtml = GetResSingDateTodo(res.id, thisDay, out todoHours);
                                    var callHtml = GetSingResDateCall(res.id, thisDay, out callHours);
                                    var allUserHours = appiontHours + todoHours + callHours;
                                    var allRemainHours = ((thisDay.DayOfWeek == DayOfWeek.Sunday || thisDay.DayOfWeek == DayOfWeek.Saturday) ? 0 : 8) - timeHours;
                                    singContentHtml.Append($"<ul class='HouverTask'><li style='min-height:27px;margin-bottom: 1px;height:auto;border-width: 0px;'><div class='border'></div><div class='Hover-t'>{timeHtml}</div></li><li data-res='{res.id.ToString()}' data-date='{chooseDate.ToString("yyyy-MM-dd HH:mm")}'><div class='border'></div><div class='TaskConter'><div class='t1'>{appHtml + todoHtml + callHtml}</div><div class='t2'></div></div></li>");
                                    for (int i = 0; i < 23; i++)
                                    {
                                        singContentHtml.Append($"<li {(i>=7&&i<=18? "style='background-color:white;'" : "")} data-res='{res.id.ToString()}' data-date='{chooseDate.AddHours(i+1).ToString("yyyy-MM-dd HH:mm")}'><div class='border'></div><div class='TaskConter'><div class='t1'></div><div class='t2'></div></div></li>");
                                    }
                                    singContentHtml.Append("</ul>");
                                    //singContentHtml.Append(appHtml + todoHtml + callHtml);

                                    if (!userTimeDic[thisKey].ContainsKey("UserHours"))
                                        userTimeDic[thisKey].Add("UserHours", allUserHours);
                                    // userTimeDic[thisKey]["UserHours"] += ;

                                    if (!userTimeDic[thisKey].ContainsKey("RemainHours"))
                                        userTimeDic[thisKey].Add("RemainHours", allRemainHours);
                                }
                            }
                        }
                    }
                    liSingUserContent.Text =  singContentHtml.ToString();
                    #endregion

                    #region 用户标题
                    var singTitleHtml = new System.Text.StringBuilder();
                    singTitleHtml.Append("<div class='DaysList'>");
                    if (resList != null && resList.Count > 0)
                        singTitleHtml.Append($"<div class='Days-2'><div class='border'></div>个人</div>");
                    if (workList != null && workList.Count > 0)
                    {
                        foreach (var work in workList)
                        {
                            singTitleHtml.Append($"<div class='Days-2'><div class='border'></div>{work.name}</div>");
                        }
                    }
                    singTitleHtml.Append("</div>");
                    singTitleHtml.Append("<ul class='ContainerTop-User'>");
                    var groupNum = 0;
                    if(isShowNoRes)
                        singTitleHtml.Append($"<li data-Group='Group{groupNum}'><div class='border'></div>无负责人</li>");
                    if (resList != null && resList.Count > 0)
                    {
                        foreach (var res in resList)
                        {
                            singTitleHtml.Append($"<li data-Group='Group{groupNum}'><div class='border'></div>{res.name}</li>");
                        }
                    }
                    if (workList != null && workList.Count > 0)
                    {
                        foreach (var thisWork in workList)
                        {
                            groupNum++;
                            var thisResList = new DAL.sys_workgroup_dal().GetResouListByWorkIds(thisWork.id.ToString());
                            if (thisResList != null && thisResList.Count > 0)
                            {
                                foreach (var res in thisResList)
                                {
                                    singTitleHtml.Append($"<li data-Group='Group{groupNum}'><div class='border'></div>{res.name}</li>");
                                }
                            }
                        }
                    }
                    singTitleHtml.Append("</ul>");

                    liSingUserShow.Text = singTitleHtml.ToString();
                    #endregion
                }
            }
            catch (Exception msg)
            {
                Response.Write("<script>alert('" + msg.Message + "');window.close();</script>");
            }
        }
        protected string[] weekArr = new string[] { "星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };

        /// <summary>
        /// 获取本周的星期一
        /// </summary>
        protected DateTime GetMonday(DateTime date)
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
        /// 获取该员工在某一日期下的休假
        /// </summary>
        protected string GetResDateTime(long resId, DateTime date, out decimal useHours)
        {
            useHours = 0;
            var thisList = new TimeOffPolicyBLL().GetTimeOffByResDate(resId, date);
            string timeHtml = "";
            if (thisList != null && thisList.Count > 0)
            {
                foreach (var _ in thisList)
                {
                    timeHtml += $"<div class='hovertask hoverTime' data-val='{_.id.ToString()}' data-date='{date.ToString("yyyy-MM-dd")}'><p></p><p>{_.request_hours.ToString("#0.00")} 小时</p><div class='HiddenToolTip'><p>{(_.request_date == null ? "" : ((DateTime)_.request_date).ToString("yyyy-MM-dd"))}</p><p>休假{timeRequestStatus.First(t => t.id == _.status_id).name}</p></div></div>";
                    useHours += _.request_hours;
                }
            }
            return timeHtml;
        }
        /// <summary>
        /// 获取该员工在某一日期下的约会
        /// </summary>
        protected string GetResDateApp(long resId, DateTime date, out decimal appiontHours)
        {
            appiontHours = 0;
            date = DateTime.Parse(date.ToString("yyyy-MM-dd") + " 00:00:00");
            var thisList = dBll.GetAppByResDate(resId, date);
            string appHtml = "";
            if (thisList != null && thisList.Count > 0)
            {
                foreach (var _ in thisList)
                {
                    appHtml += $"<div class='hovertask hoverAppoint stockstask' data-val='{_.id.ToString()}' data-date='{date.ToString("yyyy-MM-dd")}' data-res='{resId}' data-type='AppiontDiv'><p>{_.name}</p><p>{_.description}</p><div class='HiddenToolTip'><p>{Tools.Date.DateHelper.ConvertStringToDateTime(_.start_time).ToString("yyyy-MM-dd")}-{Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time).ToString("yyyy-MM-dd")}</p><p>{_.name}</p><p>{_.description}</p></div></div>";
                    var endDate = Tools.Date.DateHelper.ToUniversalTimeStamp(date.AddDays(1));
                    var thisTimeStamp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
                    if (endDate < _.end_time)
                        _.end_time = endDate;
                    if (_.start_time < thisTimeStamp)
                        _.start_time = thisTimeStamp;
                    decimal hours = 0;
                    if (_.end_time != _.start_time)
                        hours = ((decimal)_.end_time - (decimal)_.start_time) / 1000 / 60 / 60;
                    appiontHours += hours;
                }
            }
            return appHtml;
        }
        protected string GetResSingDateApp(long resId, DateTime date, out decimal appiontHours)
        {
            appiontHours = 0;
            date = DateTime.Parse(date.ToString("yyyy-MM-dd") + " 00:00:00");
            var thisList = dBll.GetAppByResDate(resId, date);
            string appHtml = "";
            if (thisList != null && thisList.Count > 0)
            {
                foreach (var _ in thisList)
                {
                    appHtml += $"<div class='HouverTaskItem' style='margin-top:{(ReturnDiffTime(_.start_time, date) * 30.5)}px'><div class='UserContainer' data-date='{date.ToString("yyyy-MM-dd")}' data-res='{resId}' ><div class='hovertask hoverAppoint stockstask' data-val='{_.id.ToString()}' data-date='{date.ToString("yyyy-MM-dd")}' data-res='{resId}' data-type='AppiontDiv'  style='height:{(ReturnDiffHeight(_.start_time, _.end_time, date) * 30.5)}px;'><p>{_.name}</p><p>{_.description}</p><div class='HiddenToolTip'><p>{Tools.Date.DateHelper.ConvertStringToDateTime(_.start_time).ToString("yyyy-MM-dd")}-{Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time).ToString("yyyy-MM-dd")}</p><p>{_.name}</p><p>{_.description}</p></div></div></div></div>";
                    var endDate = Tools.Date.DateHelper.ToUniversalTimeStamp(date.AddDays(1));
                    var thisTimeStamp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
                    if (endDate < _.end_time)
                        _.end_time = endDate;
                    if (_.start_time < thisTimeStamp)
                        _.start_time = thisTimeStamp;
                    decimal hours = 0;
                    if (_.end_time != _.start_time)
                        hours = ((decimal)_.end_time - (decimal)_.start_time) / 1000 / 60 / 60;
                    appiontHours += hours;
                }
            }
            return appHtml;
        }

        /// <summary>
        /// 获取该员工在某一日期下的待办
        /// </summary>
        protected string GetResDateTodo(long resId, DateTime date, out decimal todoHours)
        {
            todoHours = 0;
            date = DateTime.Parse(date.ToString("yyyy-MM-dd") + " 00:00:00");
            var thisList = new ActivityBLL().GetToListByResDate(resId, date);
            string appHtml = "";
            if (thisList != null && thisList.Count > 0)
            {
                foreach (var _ in thisList)
                {
                    crm_account thisAccount = null;
                    if (_.account_id != null)
                        thisAccount = acccBll.GetCompany((long)_.account_id);
                    var thisAct = todiAction.FirstOrDefault(t => t.id == _.action_type_id);
                    appHtml += $"<div class='hovertask hoverTodo stockstask' data-val='{_.id.ToString()}' data-date='{date.ToString("yyyy-MM-dd")}' data-res='{resId}' data-type='ToDoDiv'><p>{(thisAccount != null ? thisAccount.name : "")}</p><p>{_.description}</p><div class='HiddenToolTip'>{(thisAccount == null ? "" : "<p>" + thisAccount.name + "</p>")}<p>{Tools.Date.DateHelper.ConvertStringToDateTime(_.start_date).ToString("yyyy-MM-dd")}-{Tools.Date.DateHelper.ConvertStringToDateTime(_.end_date).ToString("yyyy-MM-dd")}</p><p>{(thisAct != null ? thisAct.name : "")}</p><p>{_.description}</p></div></div>";
                    var endDate = Tools.Date.DateHelper.ToUniversalTimeStamp(date.AddDays(1));// Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time);
                    var thisTimeStamp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
                    if (endDate < _.end_date)
                        _.end_date = endDate;
                    if (_.start_date < thisTimeStamp)
                        _.start_date = thisTimeStamp;
                    decimal hours = 0;
                    if (_.end_date != _.start_date)
                        hours = ((decimal)_.end_date - (decimal)_.start_date) / 1000 / 60 / 60;
                    todoHours += hours;
                }
            }
            return appHtml;
        }

        protected string GetResSingDateTodo(long resId, DateTime date, out decimal todoHours)
        {
            todoHours = 0;
            date = DateTime.Parse(date.ToString("yyyy-MM-dd") + " 00:00:00");
            var thisList = new ActivityBLL().GetToListByResDate(resId, date);
            string appHtml = "";
            if (thisList != null && thisList.Count > 0)
            {
                foreach (var _ in thisList)
                {
                    crm_account thisAccount = null;
                    if (_.account_id != null)
                        thisAccount = acccBll.GetCompany((long)_.account_id);
                    var thisAct = todiAction.FirstOrDefault(t => t.id == _.action_type_id);
                    appHtml += $"<div class='HouverTaskItem' style='margin-top:{(ReturnDiffTime(_.start_date, date) * 30.5)}px'><div class='UserContainer' data-date='{date.ToString("yyyy-MM-dd")}' data-res='{resId}'><div class='hovertask hoverTodo stockstask' data-val='{_.id.ToString()}' data-date='{date.ToString("yyyy-MM-dd")}' data-res='{resId}' data-type='ToDoDiv'  style='height:{(ReturnDiffHeight(_.start_date, _.end_date, date) * 30.5)}px;'><p>{(thisAccount != null ? thisAccount.name : "")}</p><p>{_.description}</p><div class='HiddenToolTip'>{(thisAccount == null ? "" : "<p>" + thisAccount.name + "</p>")}<p>{Tools.Date.DateHelper.ConvertStringToDateTime(_.start_date).ToString("yyyy-MM-dd")}-{Tools.Date.DateHelper.ConvertStringToDateTime(_.end_date).ToString("yyyy-MM-dd")}</p><p>{(thisAct != null ? thisAct.name : "")}</p><p>{_.description}</p></div></div></div></div>";
                    var endDate = Tools.Date.DateHelper.ToUniversalTimeStamp(date.AddDays(1));// Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time);
                    var thisTimeStamp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
                    if (endDate < _.end_date)
                        _.end_date = endDate;
                    if (_.start_date < thisTimeStamp)
                        _.start_date = thisTimeStamp;
                    decimal hours = 0;
                    if (_.end_date != _.start_date)
                        hours = ((decimal)_.end_date - (decimal)_.start_date) / 1000 / 60 / 60;
                    todoHours += hours;
                }
            }
            return appHtml;
        }

        /// <summary>
        /// 获取该员工在某一日期下的服务预定
        /// </summary>
        protected string GetResDateCall(long resId, DateTime date, out decimal callHours)
        {
            callHours = 0;
            date = DateTime.Parse(date.ToString("yyyy-MM-dd") + " 00:00:00");
            var thisList = new TicketBLL().GetCallByResDate(resId, date);
            string appHtml = "";
            if (thisList != null && thisList.Count > 0)
            {
                foreach (var _ in thisList)
                {
                    if ((!isShowCanCall) && _.status_id == (int)DTO.DicEnum.SERVICE_CALL_STATUS.CANCEL)
                        continue;
                    var thisAccount = acccBll.GetCompany(_.account_id);
                    appHtml += $"<div class='hovertask hoverCall {(_.status_id != (int)DTO.DicEnum.SERVICE_CALL_STATUS.DONE ? "stockstask" : "")}' data-val='{_.id.ToString()}' data-date='{date.ToString("yyyy-MM-dd")}'  data-res='{resId}' data-type='CallDiv'><p>{(thisAccount != null ? thisAccount.name : "")}</p><p>{_.description}</p><div class='HiddenToolTip'><p>客户名称：{(thisAccount != null ? thisAccount.name : "")}</p><p>客户电话：{(thisAccount != null ? thisAccount.phone : "")}</p><p>起止日期：{Tools.Date.DateHelper.ConvertStringToDateTime(_.start_time).ToString("yyyy-MM-dd")}-{Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time).ToString("yyyy-MM-dd")}</p>{GetTicketToolTip(_.id)}</div></div>";
                    var endDate = Tools.Date.DateHelper.ToUniversalTimeStamp(date.AddDays(1));// Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time);
                    var thisTimeStamp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
                    if (endDate < _.end_time)
                        _.end_time = endDate;
                    if (_.start_time < thisTimeStamp)
                        _.start_time = thisTimeStamp;
                    decimal hours = 0;
                    if (_.end_time != _.start_time)
                        hours = ((decimal)_.end_time - (decimal)_.start_time) / 1000 / 60 / 60;
                    callHours += hours;
                }
            }
            return appHtml;
        }

        protected string GetSingResDateCall(long resId, DateTime date, out decimal callHours)
        {
            callHours = 0;
            date = DateTime.Parse(date.ToString("yyyy-MM-dd") + " 00:00:00");
            var thisList = new TicketBLL().GetCallByResDate(resId, date);
            string appHtml = "";
            if (thisList != null && thisList.Count > 0)
            {
                foreach (var _ in thisList)
                {
                    if ((!isShowCanCall) && _.status_id == (int)DTO.DicEnum.SERVICE_CALL_STATUS.CANCEL)
                        continue;
                    var thisAccount = acccBll.GetCompany(_.account_id);
                    appHtml += $"<div class='HouverTaskItem' style='margin-top:{(ReturnDiffTime(_.start_time, date) *30.5)}px'><div class='UserContainer' data-date='{date.ToString("yyyy-MM-dd")}' data-res='{resId}'><div class='hovertask hoverCall {(_.status_id != (int)DTO.DicEnum.SERVICE_CALL_STATUS.DONE ? "stockstask" : "")}' data-val='{_.id.ToString()}' data-date='{date.ToString("yyyy-MM-dd")}'  data-res='{resId}' data-type='CallDiv' style='height:{(ReturnDiffHeight(_.start_time,_.end_time, date) *30.5)}px;'><p>{(thisAccount != null ? thisAccount.name : "")}</p><p>{_.description}</p><div class='HiddenToolTip'><p>客户名称：{(thisAccount != null ? thisAccount.name : "")}</p><p>客户电话：{(thisAccount != null ? thisAccount.phone : "")}</p><p>起止日期：{Tools.Date.DateHelper.ConvertStringToDateTime(_.start_time).ToString("yyyy-MM-dd")}-{Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time).ToString("yyyy-MM-dd")}</p>{GetTicketToolTip(_.id)}</div></div></div></div> ";
                    var endDate = Tools.Date.DateHelper.ToUniversalTimeStamp(date.AddDays(1));// Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time);
                    var thisTimeStamp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
                    if (endDate < _.end_time)
                        _.end_time = endDate;
                    if (_.start_time < thisTimeStamp)
                        _.start_time = thisTimeStamp;
                    decimal hours = 0;
                    if (_.end_time != _.start_time)
                        hours = ((decimal)_.end_time - (decimal)_.start_time) / 1000 / 60 / 60;
                    callHours += hours;
                }
            }
            return appHtml;
        }



        protected string GetTicketToolTip(long serId)
        {
            string toolTipHtml = "";
            var ticketList = new DAL.sdk_task_dal().GetTciketByCall(serId);
            if (ticketList != null && ticketList.Count > 0)
            {
                toolTipHtml += "<br />";
                var conDal = new DAL.crm_contact_dal();
                foreach (var ticket in ticketList)
                {
                    toolTipHtml += $"<p>工单编号：{ticket.no}</p>";
                    toolTipHtml += $"<p>工单标题：{ticket.title}</p>";
                    if (ticket.contact_id != null)
                    {
                        var thisContact = conDal.FindNoDeleteById((long)ticket.contact_id);
                        if (thisContact != null)
                            toolTipHtml += $"<p>联系人姓名：{thisContact.name}</p><p>联系人电话：{thisContact.phone}</p>";
                    }
                    toolTipHtml += $"<p>负责人:{ticketBll.GetResName(ticket.id)}</p>";
                    toolTipHtml += $"<p>工单状态：{ticStaList.First(_ => _.id == ticket.status_id).name}</p>";
                    if(ticket.priority_type_id!=null)
                        toolTipHtml += $"<p>工单优先级：{priorityList.First(_ => _.id == ticket.priority_type_id).name}</p>";
                    toolTipHtml += $"<p>工单描述：{ticket.description}</p>";
                }


            }
            return toolTipHtml;
        }
        /// <summary>
        /// 没有负责人的服务预定
        /// </summary>
        protected string GetNoResDateCall(DateTime date, out decimal callHours, bool isSingel = false)
        {
            callHours = 0;
            date = DateTime.Parse(date.ToString("yyyy-MM-dd") + " 00:00:00");
            var thisList = new TicketBLL().GetNoResCallByDate(date);
            string appHtml = "";
            if (thisList != null && thisList.Count > 0)
            {
                foreach (var _ in thisList)
                {
                    if (isSingel)
                        appHtml += $"<div class='HouverTaskItem' style='margin-top:{(ReturnDiffTime(_.start_time, date) * 30.5)}px;position: relative;'><div class='UserContainer' data-date='{date.ToString("yyyy-MM-dd")}' data-res=''>";
                    var thisAccount = acccBll.GetCompany(_.account_id);
                    appHtml += $"<div class='hovertask hoverCall' data-val='{_.id.ToString()}' data-date='{date.ToString("yyyy-MM-dd")}' {(isSingel? "style='height: "+ (ReturnDiffHeight(_.start_time, _.end_time, date) * 30.5) + "px;'":"")}><p>{(thisAccount != null ? thisAccount.name : "")}</p><p>{_.description}</p><div class='HiddenToolTip'><p>客户名称：{(thisAccount != null ? thisAccount.name : "")}</p><p>客户电话：{(thisAccount != null ? thisAccount.phone : "")}</p><p>起止日期：{Tools.Date.DateHelper.ConvertStringToDateTime(_.start_time).ToString("yyyy-MM-dd")}-{Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time).ToString("yyyy-MM-dd")}</p>{GetTicketToolTip(_.id)}</div></div>";
                    if (isSingel)
                        appHtml += "</div></div>";
                    var endDate = Tools.Date.DateHelper.ToUniversalTimeStamp(date.AddDays(1));// Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time);
                    var thisTimeStamp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
                    if (endDate < _.end_time)
                        _.end_time = endDate;
                    if (_.start_time < thisTimeStamp)
                        _.start_time = thisTimeStamp;
                    decimal hours = 0;
                    if (_.end_time != _.start_time)
                        hours = ((decimal)_.end_time - (decimal)_.start_time) / 1000 / 60 / 60;
                    callHours += hours;
                }
            }
            return appHtml;

        }
        /// <summary>
        /// 只显示一天时，员工的页面
        /// </summary>
        protected string GetSingResDateCall(long resId, DateTime chooseDate)
        {
            var date = DateTime.Parse(chooseDate.ToString("yyyy-MM-dd") + " 00:00:00");
            var thisResHtml = new System.Text.StringBuilder();
            thisResHtml.Append("<div>");
            var thisCallList = new TicketBLL().GetCallByResDate(resId, date);
            if (thisCallList != null && thisCallList.Count > 0)
            {
                foreach (var _ in thisCallList)
                {
                    if ((!isShowCanCall) && _.status_id == (int)DTO.DicEnum.SERVICE_CALL_STATUS.CANCEL)
                        continue;
                    var thisAccount = acccBll.GetCompany(_.account_id);
                    thisResHtml.Append($"<div class='hovertask hoverCall {(_.status_id != (int)DTO.DicEnum.SERVICE_CALL_STATUS.DONE ? "stockstask" : "")}' data-val='{_.id.ToString()}' data-date='{date.ToString("yyyy-MM-dd")}'  data-res='{resId}' data-type='CallDiv'><p>{(thisAccount != null ? thisAccount.name : "")}</p><p>{_.description}</p><div class='HiddenToolTip'><p>客户名称：{(thisAccount != null ? thisAccount.name : "")}</p><p>客户电话：{(thisAccount != null ? thisAccount.phone : "")}</p><p>起止日期：{Tools.Date.DateHelper.ConvertStringToDateTime(_.start_time).ToString("yyyy-MM-dd")}-{Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time).ToString("yyyy-MM-dd")}</p>{GetTicketToolTip(_.id)}</div></div>");
                    var endDate = Tools.Date.DateHelper.ToUniversalTimeStamp(date.AddDays(1));// Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time);
                    var thisTimeStamp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
                    if (endDate < _.end_time)
                        _.end_time = endDate;
                    if (_.start_time < thisTimeStamp)
                        _.start_time = thisTimeStamp;
                    decimal hours = 0;
                    if (_.end_time != _.start_time)
                        hours = ((decimal)_.end_time - (decimal)_.start_time) / 1000 / 60 / 60;
                    // callHours += hours;
                }
            }
            thisResHtml.Append("</div>");
            return thisResHtml.ToString();
        }

        /// <summary>
        /// 获取临近的半刻钟的时间
        /// </summary>
        protected DateTime ReturnNearDate(DateTime date,bool isStart = true)
        {
            if(date.Minute>=0&& date.Minute < 30)
            {
                if (isStart)
                    return date.AddMinutes( date.Minute-30);
                else 
                    return date.AddMinutes( 30 - date.Minute);
            }
            else
            {
                if (isStart)
                    return date.AddMinutes(date.Minute - 60);
                else
                    return date.AddMinutes(60 - date.Minute);
            }
        }
        /// <summary>
        /// 返回开始时间相差多少个半小时
        /// </summary>
        protected int ReturnDiffTime(long startDate,DateTime date)
        {
            var dateTemp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
            if (startDate <= dateTemp)
                return 0;
            var diff = startDate - dateTemp;
            return (int)((diff)/1000/60/30);
        }
        protected int ReturnDiffHeight(long startDate,long endDate, DateTime date)
        {
            var dateTemp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
            var tomTemp = Tools.Date.DateHelper.ToUniversalTimeStamp(date.AddDays(1));
            if (startDate < dateTemp)
                startDate = dateTemp;
            else if(endDate> tomTemp)
                endDate = tomTemp;
            if (startDate == endDate)
                return 1;
            var diff = endDate - startDate;
            return (int)Math.Ceiling((((decimal)diff) / 1000 / 60 / 30));
        }

    }


}