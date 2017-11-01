using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System.Text;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectSearchImg : BasePage
    {
        protected int showYearNum = 1;  // 页面上展示的日期范围（时间范围过长时-采用开始时间一年内）
        protected double DayWidth = 25; // 一天在页面上占的宽度 
        protected DateTime start_date;
        protected DateTime end_date;

        protected List<pro_project> proList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            var ids = Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(ids))
            {
                proList = new pro_project_dal().GetProListByIds(ids);
                if (proList != null && proList.Count > 0)
                {
                    start_date = (DateTime)proList.Min(_ => _.start_date);
                    end_date = (DateTime)proList.Max(_ => _.end_date);
                    if (GetDateDiffMonth(start_date, end_date, "month") > 12)
                    {
                        end_date = start_date.AddYears(showYearNum).AddDays(-1);
                    }
                    else if(GetDateDiffMonth(start_date, end_date, "month") <= 2)
                    {
                        end_date = end_date.AddMonths(1).AddDays(-1);  // 时间太少，增加宽度
                    }
                    // 页面上展示多少月份
                    var monthNum = GetDateDiffMonth(start_date, end_date, "month");
                    #region 日期展示说明
                    // 1.计算出具体显示多少月份，最多显示 showYearNum*12 的月份--循环添加
                    // 2.开始月份和结束月份可能不是整月，显示部分 --特殊处理
                    // 3.展示具体的天，周，月信息
                    #endregion

                    StringBuilder headInfo = new StringBuilder();
                  
                  
                    var dateType = Request.QueryString["dateType"];
                    switch (dateType)
                    {
                        case "day":
                            for (int i = 0; i < monthNum; i++)
                            {
                                headInfo.Append($"<div class='Gantt_dateMonthYear Gantt_titleFont Gantt_divTableHeader Gantt_header Gantt_date'>");
                                if ((i == 0 || i == monthNum - 1)) // 开始和结束时间以及特殊情况的处理
                                {
                                    if (i == 0)
                                    {
                                        var monthDayNum = RetuenMonthDay(start_date);  // 开始日期的月份的总天数
                                        var surplusDays = (monthDayNum - start_date.Day + 1);  // 开始结束时间 --剩余天数
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{start_date.Year.ToString() + '.' + start_date.Month.ToString()}</div>");
                                        int s;
                                        for (s = start_date.Day; s <= monthDayNum; s++)
                                        {
                                            headInfo.Append($"<div class='Gantt_divTableColumn Gantt_header Gantt_date'>{s}</div>");
                                        }
                                    }
                                    else if (i == monthNum - 1)
                                    {
                                        var monthDayNum = RetuenMonthDay(end_date);  // 开始日期的月份的总天数
                                        var surplusDays = end_date.Day;  // 开始结束时间
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{end_date.Year.ToString() + '.' + end_date.Month.ToString()}</div>");
                                        for (int s = 1; s <= surplusDays; s++)
                                        {
                                            headInfo.Append($"<div class='Gantt_divTableColumn Gantt_header Gantt_date'>{s}</div>");
                                        }
                                    }

                                }
                                else
                                {
                                    var monthDayNum = RetuenMonthDay(start_date.AddMonths(i));  // 开始日期的月份的总天数
                                    var thisMonthWidth = monthDayNum * DayWidth;
                                    headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{start_date.AddMonths(i).Year.ToString() + '.' + start_date.AddMonths(i).Month.ToString()}</div>");
                                    for (int s = 1; s <= monthDayNum; s++)
                                    {
                                        headInfo.Append($"<div class='Gantt_divTableColumn Gantt_header Gantt_date'>{s}</div>");
                                    }
                                }
                                headInfo.Append("</div>");
                            }
                            break;
                        case "week":
                            DayWidth = 10;
                            headInfo.Append($"<table border='0' cellspacing='0' cellpadding='0'><tbody><tr valign='top'><td><div class='grid TimelineGridHeader'><table border = '0' cellspacing='0' cellpadding='0'><tbody><tr height = '0'></tr></ tbody><thead> ");
                            // 添加月
                            headInfo.Append("<tr valign='middle' align='center'>");
                            for (int i = 0; i < monthNum; i++)
                            {
                                if ((i == 0 || i == monthNum - 1)) // 开始和结束时间以及特殊情况的处理
                                {
                                    if (i == 0)
                                    {
                                        var monthDayNum = RetuenMonthDay(start_date);  // 开始日期的月份的总天数
                                        var surplusDays = (monthDayNum - start_date.Day + 1);  // 开始结束时间 --剩余天数
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<td colspan='{surplusDays}' class='TextUppercase'>{start_date.Year+"."+ start_date.Month}</ td>");
                                    }
                                    else if (i == monthNum - 1)
                                    {
                                        var monthDayNum = RetuenMonthDay(end_date);  // 开始日期的月份的总天数
                                        var surplusDays = end_date.Day;  // 开始结束时间
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<td colspan='{end_date.Day}' class='TextUppercase'>{end_date.Year.ToString() + '.' + end_date.Month.ToString()}</ td>");
                                    }

                                }
                                else
                                {
                                    var monthDayNum = RetuenMonthDay(start_date.AddMonths(i));  // 开始日期的月份的总天数
                                    var thisMonthWidth = monthDayNum * DayWidth;
                                    headInfo.Append($"<td colspan='{monthDayNum}' class='TextUppercase'>{start_date.AddMonths(i).Year.ToString() + '.' + start_date.AddMonths(i).Month.ToString()}</ td>");

                                }
                            }
                            headInfo.Append("</tr>");

                            // 添加周
                            headInfo.Append("<tr valign='middle' align='center'>");
                            var weekNum = GetDateDiffMonth(start_date, end_date, "week");
                            for(int s = 0; s < weekNum; s++)
                            {
                                if (s != (weekNum - 1))
                                {
                                    headInfo.Append($"<td colspan='7'><div class='TimelineSecondaryHeader' style='width: 49px;'>{start_date.AddDays(s * 7).Day}-{start_date.AddDays((s + 1) * 7-1).Day}</div></td>");
                                }
                                else
                                {
                                    headInfo.Append($"<td colspan='7'><div class='TimelineSecondaryHeader' style='width: 49px;'>{start_date.AddDays(s * 7).Day}-{end_date.Day}</div></td>");
                                }
                                
                            }
                            headInfo.Append("</tr>");
                            headInfo.Append("</thead></table></div></td></tr></tbody></table> ");
                            break;
                        case "month":
                            DayWidth = 5;
                            for (int i = 0; i < monthNum; i++)
                            {
                                headInfo.Append($"<div class='Gantt_dateMonthYear Gantt_titleFont Gantt_divTableHeader Gantt_header Gantt_date'>");
                                if ((i == 0 || i == monthNum - 1)) // 开始和结束时间以及特殊情况的处理
                                {
                                    if (i == 0)
                                    {
                                        var monthDayNum = RetuenMonthDay(start_date);  // 开始日期的月份的总天数
                                        var surplusDays = (monthDayNum - start_date.Day + 1);  // 开始结束时间 --剩余天数
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{start_date.Year.ToString() + '.' + start_date.Month.ToString()}</div>");
                                    }
                                    else if (i == monthNum - 1)
                                    {
                                        var monthDayNum = RetuenMonthDay(end_date);  // 开始日期的月份的总天数
                                        var surplusDays = end_date.Day;  // 开始结束时间
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{end_date.Year.ToString() + '.' + end_date.Month.ToString()}</div>");
                                    }

                                }
                                else
                                {
                                    var monthDayNum = RetuenMonthDay(start_date.AddMonths(i));  // 开始日期的月份的总天数
                                    var thisMonthWidth = monthDayNum * DayWidth;
                                    headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{start_date.AddMonths(i).Year.ToString() + '.' + start_date.AddMonths(i).Month.ToString()}</div>");
                                }
                                headInfo.Append("</div>");
                            }
                            break;
                        default:
                            break;
                    }
                    headText.Text = headInfo.ToString();

                    // bodyText

                    StringBuilder bodyInfo = new StringBuilder();
                    bodyInfo.Append($"<div id='Gantt_gridContainer' style='background: url(../Images / monthlyGridContainer.png;) left top; border-right: 1px solid rgb(242, 242, 242); width: 2296px;'>");
                    foreach (var pro in proList)
                    {
                        var proTypeClass = "";
                        switch (pro.type_id)
                        {
                            case (int)DTO.DicEnum.PROJECT_TYPE.IN_PROJECT:
                                proTypeClass = "InternalProjects";
                                break;
                            case (int)DTO.DicEnum.PROJECT_TYPE.ACCOUNT_PROJECT:
                                proTypeClass = "ClientProjects"; 
                                break;
                            case (int)DTO.DicEnum.PROJECT_TYPE.PROJECT_DAY:
                                proTypeClass = "Proposals"; 
                                break;
                            default:
                                break;
                        }
                        var diffDays = GetDateDiffMonth(start_date, (DateTime)pro.start_date, "day"); // 开始时间距离最开始时间距离
                        
                        var proDays = GetDateDiffMonth((DateTime)pro.start_date, (DateTime)pro.end_date, "day"); // 项目持续的时间
                        proDays += 1;
                        bodyInfo.Append($"<div class='Gantt_divTableRow'><div class='{proTypeClass}' style='width: {proDays* DayWidth}px; left:{diffDays*DayWidth}px;'><div style = 'width: 0%;'></div></div></div>");
                    }
                    bodyInfo.Append($"</div>");
                    bodyText.Text = bodyInfo.ToString();
                }
            }
        }
        /// <summary>
        /// 根据开始时间和结束时间计算两个时间相差的月，周，天数
        /// </summary>
        protected int GetDateDiffMonth(DateTime startDate,DateTime endDate,string dateType)
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
                   num= (endDate.Year - startDate.Year) * 12 + (endDate.Month - startDate.Month+1) ;
                    // + (endDate.Day >= startDate.Day ? 1 : 0)
                    break;
                default:
                    break;
            }
            return num;
        }
        /// <summary>
        /// 返回这个月的天数
        /// </summary>
        protected double RetuenMonthDay(DateTime date)
        {
            double dayNum = 0;
            switch (date.Month)
            {
                case 1:
                case 3:
                case 5:
                case 7:
                case 8:
                case 10:
                case 12:
                    dayNum = 31;
                    break;
                case 4:
                case 6:
                case 9:
                case 11:
                    dayNum = 30;
                    break;
                case 2:
                    var year = date.Year;
                    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
                    {
                        dayNum = 28;
                    }
                    else
                    {
                        dayNum = 29;
                    }
                    break;
                default:
                    break;
            }
            return dayNum;
        }
    }
}