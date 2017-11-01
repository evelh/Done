using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using System.Text;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectClosingReport : BasePage
    {
        protected pro_project thisProject = null;
        protected DateTime chooseDate = DateTime.Now;   // 用户选择的日期
        protected DateTime showDate = DateTime.Now;
        protected bool isSeven = false;
        protected bool isShowDetai = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                    if (thisProject != null)
                    {
                        var chooseDateString = Request.QueryString["chooseDate"];
                        if (!string.IsNullOrEmpty(chooseDateString))
                        {
                            chooseDate = DateTime.Parse(chooseDateString);
                        }

                        var showDateString = Request.QueryString["showDate"];
                        if (!string.IsNullOrEmpty(showDateString))
                        {
                            showDate = DateTime.Parse(showDateString);
                        }

                        calendar.Text = GetTableByDate(showDate);

                        if (!string.IsNullOrEmpty(Request.QueryString["isSeven"]))
                        {
                            isSeven = true;
                        }
                        if (!string.IsNullOrEmpty(Request.QueryString["isShowDetai"]))
                        {
                            isShowDetai = true;
                        }

                    }
                }
            }
            catch (Exception msg)
            {

                Response.End();
            }
        }


        protected string GetTableByDate(DateTime showDate)
        {
            var firstDay  = new DateTime(showDate.Year, showDate.Month, 1);         // 本月的第一天
            var lastDay = firstDay.AddMonths(1).AddDays(-1);                        // 本月最后一天
            var firstWeek = int.Parse(firstDay.DayOfWeek.ToString("d"));            // 第一天是星期几  0 是星期天
            var lastWeek = int.Parse(lastDay.DayOfWeek.ToString("d"));              // 最后一天是星期几 
            var monthDays = DateTime.DaysInMonth(showDate.Year, showDate.Month);    // 本月有多少天
            var sum = monthDays + ((firstWeek - 1)<0?6: (firstWeek - 1)) + (7 - lastWeek );
            var WeekNum = sum / 7;
            if (sum % 7 != 0)
            {
                WeekNum += 1;
            }
            //  int days = DateTime.DaysInMonth(dtNow.Year ,dtNow.Month);
            StringBuilder showHtml = new StringBuilder();
            showHtml.Append($"<table id='outerTable' width='100 %' border='0' cellspacing='1' cellpadding='0' style='cursor: pointer; border-collapse: collapse; width: 220px; height:220px; border: 1 solid #d7d7d7;'><tbody><tr class='calHeader' style='height: 40px;'><td id = 'calMonth' width ='15%' align ='center'><img src = '../Images/left2.png'  onclick=\"ChooseNewDate('{firstDay.AddMonths(-1).ToString("yyyy-MM-dd")}')\"  /></td><td id = 'calMonth' colspan = '5' nowrap = '' width = '70%' align = 'center' >{showDate.Year+" "+showDate.Month}</td><td id = 'calMonth' width = '15%' align = 'center' ><img src = '../Images/right2.png' onclick = \"ChooseNewDate('{firstDay.AddMonths(1).ToString("yyyy-MM-dd")}')\" /></td></tr>");
            showHtml.Append("<tr><td align='center' colspan='7'><table id='ATGCal_table_myThing' width='100 %' border='0' cellspacing='0' cellpadding='0' style='border-collapse: collapse; cursor: pointer;'><tbody><tr><td id='calDayHead' align='center'>一</td><td id='calDayHead' align='center'>二</td><td id='calDayHead' align='center'>三</td><td id='calDayHead' align='center'>四</td><td id='calDayHead' align='center'>五</td><td id='calDayHead' align='center'>六</td><td id='calDayHead' align='center'>日</td></tr>");
            var thisDay = 1;
            for (int i = 0; i < WeekNum; i++)
            {
                showHtml.Append("<tr style='height: 29px;'>");
                if (i == 0)
                {
                    for(int j=0;j< ((firstWeek - 1) < 0 ? 6 : (firstWeek - 1)); j++)
                    {
                        showHtml.Append("<td width='20' height='20' id='calDay'>&nbsp;</td>");
                    }
                    for (int j = 0; j < ((firstWeek - 1) < 0 ? 1 : (7-firstWeek + 1)); j++)
                    {
                        showHtml.Append($"<td width='20' height='20' id='calDay' onclick=ChooseDate('{showDate.ToString("yyyy-MM-")+thisDay}')>{thisDay}</td>");
                        thisDay += 1;
                    }
                }
                else if(i==WeekNum-1)
                {
                    for (int j = 0; j < lastWeek ; j++)
                    {
                        showHtml.Append($"<td width='20' height='20' id='calDay' onclick=ChooseDate('{showDate.ToString("yyyy-MM-") + thisDay}')>{thisDay}</td>");
                        thisDay += 1;
                    }
                    for (int j = 0; j < 7 - lastWeek ; j++)
                    {
                        showHtml.Append($"<td width='20' height='20' id='calDay'>&nbsp;</td>");
                    }
                }
                else
                {
                    for (int j = 0; j < 7; j++)
                    {
                        showHtml.Append($"<td width='20' height='20' id='calDay' onclick=ChooseDate('{showDate.ToString("yyyy-MM-") + thisDay}')>{thisDay}</td>");
                        thisDay += 1;
                    }
                }
                showHtml.Append("</tr>");
            }


            showHtml.Append("</tbody></table></td></tr>");
            showHtml.Append("</tbody></table>");


            return showHtml.ToString();
        }

    }
}