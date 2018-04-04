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
        protected long dateType = (int)DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW;
        protected List<sys_resource> resList = null;
        protected List<sys_workgroup> workList = null;
        protected bool isShowNoRes = false;
        protected bool isShowCanCall = false;
        protected DispatchBLL dBll = new DispatchBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var viewId = Request.QueryString["viewId"];
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
                    }
                }

                var resIds = Request.QueryString["resIds"];
                resIds = "1,491";   // 测试使用
                if (!string.IsNullOrEmpty(resIds))
                    resList = new DAL.sys_resource_dal().GetListByIds(resIds, false);
                var workIds = Request.QueryString["workIds"];
                if (!string.IsNullOrEmpty(workIds))
                    workList = new DAL.sys_workgroup_dal().GetList($" and id in({workIds})");
                var showNoRes = Request.QueryString["showNoRes"];
                if (!string.IsNullOrEmpty(showNoRes))
                    isShowNoRes = showNoRes == "1";
                var showCanCall = Request.QueryString["showCanCall"];
                if (!string.IsNullOrEmpty(showCanCall))
                    isShowCanCall = showCanCall == "1";
                var modeId = Request.QueryString["modeId"];
                if (!string.IsNullOrEmpty(modeId))
                    dateType = long.Parse(modeId);
                #region 获取用户相关
                var liUserHtml = new System.Text.StringBuilder();
                if (resList != null && resList.Count > 0)
                {
                    resList.ForEach(_ =>
                    {
                        liUserHtml.Append($"<li><div class='name'><a onclick='' style='font-size:10px;color: #376597;'>{_.name}</a></div><div class='icon'><img style = 'margin: 5px 0;' src='..{(!string.IsNullOrEmpty(_.avatar)?_.avatar:"/Images/pop.jpg")}' alt='' /></div></li>");
                    });
                }
                liUser.Text = liUserHtml.ToString();
                #endregion

                #region 获取时间相关
                var liTimeHtml = new System.Text.StringBuilder();
                var limitDays = 5;  // 页面上显示的天数
                switch (dateType)
                {
                    case (int)DTO.DicEnum.DISPATCHER_MODE.ONE_DAY_VIEW:
                        limitDays = 1;
                        break;
                    case (int)DTO.DicEnum.DISPATCHER_MODE.FIVE_DAY_WORK_VIEW:
                        chooseDate = GetMonday(chooseDate);
                        limitDays = 7;
                        break;
                    case (int)DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW_FROM_SELECTED_DAY:
                        limitDays = 7;
                        break;
                    default:
                        chooseDate = GetMonday(chooseDate);
                        break;
                }
                for (int i = 0; i < limitDays; i++)
                {
                    var thisDay = chooseDate.AddDays(i);
                    liTimeHtml.Append($"<li><div class='Days-1'><div class='Day-1-border1'></div><div class='Day-1-border2'></div><div class='Day-1-text3'><p>{GetDay((int)thisDay.DayOfWeek)} {thisDay.ToString("yyyy-MM-dd")}</p><p><a style = 'text-align: left'> 0.00 / 15.00 </a><a style='text-align: right'><span style = 'display: block;width: 50%;text-align: center;float: left;'>0%</span><span  style='display: block;width: 50%;text-align: center;float: left;'>15.55</span></a></p></div></div><div class='Days-2'></div>");
                    if (isShowNoRes)
                        liTimeHtml.Append($"<div class='Days-3'><div class='Days3-border1'></div><div class='Days3-text2'><p><a style = 'text-align: left' > 0.00 / 15.00 </a><a style='text-align: right'><span style = 'display: block;width: 50%;text-align: center;float: left;'> 0 % </span><span  style='display: block;width: 50%;text-align: center;float: left;'>1.55</span></a></p></div></div>");
                    liTimeHtml.Append($"</li>");
                }
                liTime.Text = liTimeHtml.ToString();
                #endregion

                #region 获取时间相关
                var liContentHtml = new System.Text.StringBuilder();
                if (resList != null && resList.Count > 0)
                {
                    foreach (var res in resList)
                    {
                        liContentHtml.Append("<ul class='R-ContainerUser'>");
                        for (int i = 0; i < limitDays; i++)
                        {
                            var thisDay = chooseDate.AddDays(i);
                            // float: left; display: block;
                            liContentHtml.Append("<li><div class='UserTime'><div class='UserTime-border1'></div><div class='UserTime-text2'><p><a>0.00/7.00</a><a><span style='width: 50%;text-align: center;'> 0 % </ span><span style='display: block;width: 50%;text-align: center;float: left;'>1.55</span></a></p></div></div><div class='UserContainer'>");
                            // 1 获取休假信息
                            // 2 获取约会信息
                            // 3 获取待办信息
                            // 4 获取服务预定信息

                            liContentHtml.Append(GetResDateApp(res.id, thisDay));  // 2 获取约会信息
                            liContentHtml.Append(GetResDateTodo(res.id, thisDay)); // 3 获取待办信息
                            liContentHtml.Append(GetResDateCall(res.id, thisDay)); // 4 获取服务预定信息
                            liContentHtml.Append("<p>08:00 AM</p>");
                            liContentHtml.Append($"</div></li>");
                        }
                        liContentHtml.Append("</ul>");
                    }
                }
                liTicket.Text = liContentHtml.ToString();
                #endregion

            }
            catch (Exception msg)
            {
                Response.Write("<script>alert('" + msg.Message + "');window.close();</script>");
            }
        }

        /// <summary>
        /// 获取到时星期几 
        /// </summary>
        protected string GetDay(int day)
        {
            var dayString = "";
            switch (day)
            {
                case 0:
                    dayString = "星期天";
                    break;
                case 1:
                    dayString = "星期一";
                    break;
                case 2:
                    dayString = "星期二";
                    break;
                case 3:
                    dayString = "星期三";
                    break;
                case 4:
                    dayString = "星期四";
                    break;
                case 5:
                    dayString = "星期五";
                    break;
                case 6:
                    dayString = "星期六";
                    break;
                default:
                    break;
            }
            return dayString;
        }
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
        /// 获取该员工在某一日期下的约会
        /// </summary>
        protected string GetResDateApp(long resId,DateTime date)
        {
            var thisList = dBll.GetAppByResDate(resId, date);
            string appHtml = "";
            if(thisList!=null&& thisList.Count > 0)
            {
                thisList.ForEach(_ => {
                    appHtml += $"<div class='hovertask hoverAppoint' data-val='{_.id.ToString()}'><p>{_.name}</p><p>{_.description}</p></div>";
                });
            }
            return appHtml;
        }
        /// <summary>
        /// 获取该员工在某一日期下的待办
        /// </summary>
        protected string GetResDateTodo(long resId, DateTime date)
        {
            var thisList = new ActivityBLL().GetToListByResDate(resId, date);
            string appHtml = "";
            if (thisList != null && thisList.Count > 0)
            {
                thisList.ForEach(_ => {
                    appHtml += $"<div class='hovertask hoverTodo'><p>{_.name}</p><p>{_.description}</p></div>";
                });
            }
            return appHtml;
        }

        /// <summary>
        /// 获取该员工在某一日期下的服务预定
        /// </summary>
        protected string GetResDateCall(long resId, DateTime date)
        {
            var thisList = new TicketBLL().GetCallByResDate(resId, date);
            string appHtml = "";
            var comBll = new CompanyBLL();
            if (thisList != null && thisList.Count > 0)
            {
                thisList.ForEach(_ => {
                    var thisAccount = comBll.GetCompany(_.account_id);
                    appHtml += $"<div class='hovertask hoverCall'><p>{(thisAccount!=null?thisAccount.name:"")}</p><p>{_.description}</p></div>";
                });
            }
            return appHtml;
        }
        // 
        
       
    }


}