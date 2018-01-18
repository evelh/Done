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

namespace EMT.DoneNOW.Web.TimeSheet
{
    public partial class ReportView : BasePage
    {
        protected sdk_expense_report thisReport = null;  
        protected List<sdk_expense> expList = null;          // 选择的日期期间会有的费用
        protected List<sdk_expense> entertainList = null;    // 招待费用
        protected List<sdk_expense> noEntertainList = null;  // 非招待费用
        protected DateTime? chooseStartDate = null;          // 选择的日期
        protected List<DictionaryEntryDto> dateList = new List<DictionaryEntryDto>();  // 日期列表
        protected sys_resource creRes = null;
        protected sys_resource subRes = null;
        protected List<d_general> payTypeList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.PAYMENT_TYPE);
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var eid = Request.QueryString["id"];
                thisReport = new sdk_expense_report_dal().FindNoDeleteById(long.Parse(eid));
                if (thisReport != null)
                {
                    creRes = new sys_resource_dal().FindNoDeleteById(thisReport.create_user_id);
                    if (thisReport.submit_user_id != null)
                    {
                        subRes = new sys_resource_dal().FindNoDeleteById((long)thisReport.submit_user_id);
                    }
                     var chooseDateString = Request.QueryString["startDate"];
                    if (!string.IsNullOrEmpty(chooseDateString))
                    {
                        chooseStartDate = GetMonday(DateTime.Parse(chooseDateString));
                    }
                    var allExpList = new sdk_expense_dal().GetExpByReport(thisReport.id);
                    if(allExpList!=null&& allExpList.Count > 0)
                    {
                        if (chooseStartDate != null)
                        {
                            expList = allExpList.Where(_ => _.add_date >= chooseStartDate && _.add_date <= ((DateTime)chooseStartDate).AddDays(6)).ToList();
                        }
                    }
                    #region 完善日期下拉框信息
                    GetSelect();  // 获取日期下拉框
                    var choese = dateList.FirstOrDefault(_ => _.select==1);
                    if (choese == null)
                    {
                        dateList.Add(new DictionaryEntryDto() {select=1,show="选择日期",val="" });
                    }
                    else
                    {
                        dateList.Add(new DictionaryEntryDto() { show = "选择日期", val = "" });
                    }
                    dateList = dateList.OrderBy(_ => _.val).ToList();
                    #endregion

                    if(expList!=null&& expList.Count > 0)
                    {
                        var dccDal = new d_cost_code_dal();
                        // 获取到招待相关的费用
                        entertainList = expList.Where(_ =>
                        {
                            if (_.cost_code_id != null)
                            {
                                var thisCost = dccDal.FindNoDeleteById((long)_.cost_code_id);
                                if (thisCost != null && thisCost.expense_type_id == (int)DicEnum.EXPENSE_TYPE.ENTERTAINMENT_EXPENSES)
                                {
                                    return true;
                                }
                            }
                            return false;
                        }).ToList();
                        
                        if(entertainList!=null&& entertainList.Count > 0)
                        {
                            noEntertainList = expList.Where(_ => !entertainList.Any(el => el.id == _.id)).ToList();
                        }
                        else
                        {
                            noEntertainList = expList;
                        }
                    }

                }
                else
                {
                    Response.Write($"<script>alerl('未查询到相关报表，请刷新页面后重试！');window.close();</script>");
                }

            }
            catch (Exception msg)
            {
                Response.Write($"<script>alerl('{msg.Message}');</script>");
            }
            
        }


        /// <summary>
        /// 获取到选择的日期的周一的那一天
        /// </summary>
        protected DateTime GetMonday(DateTime chooseDate)
        {
            var thisWeekDay = (int)chooseDate.DayOfWeek;
            if (thisWeekDay == (int)DayOfWeek.Sunday)
            {
                return chooseDate.AddDays(-6);
            }
            else
            {
                return chooseDate.AddDays(1-thisWeekDay);
            }
        }
        /// <summary>
        ///  获取日期下拉框
        /// </summary>
        private void GetSelect()
        {
            var allExpList = new sdk_expense_dal().GetExpByReport(thisReport.id);
            if (allExpList != null && allExpList.Count > 0)
            {
                #region 获取日期下拉框
                var expMinDate = allExpList.Min(_ => _.add_date);
                expMinDate = GetMonday(expMinDate);
                var expMaxDate = allExpList.Max(_ => _.add_date);

                var weeks = GetDateDiffMonth(expMinDate, expMaxDate, "week");  // 获取到两个日期之间相差的周
                // 筛选可用的周
                for (int i = 0; i < weeks; i++)
                {
                    var thisWeekExpList = allExpList.Where(_=>_.add_date>= expMinDate.AddDays(i*7)&&_.add_date <= expMinDate.AddDays(i * 7+6)).ToList();
                    if(thisWeekExpList!=null && thisWeekExpList.Count > 0)
                    {
                        var thisDto = new DictionaryEntryDto()
                        {
                            val = expMinDate.AddDays(i * 7).ToString("yyyy-MM-dd"),
                            show = expMinDate.AddDays(i * 7).ToString("yyyy-MM-dd") + " - " + expMinDate.AddDays(i * 7 + 6).ToString("yyyy-MM-dd"),
                        };
                        if(chooseStartDate!=null&& chooseStartDate >= expMinDate.AddDays(i * 7) && chooseStartDate <= expMinDate.AddDays(i * 7 + 6))
                        {
                            thisDto.select = 1;
                        }
                        dateList.Add(thisDto);
                    }
                }

                #endregion
            }
        }
        /// <summary>
        /// 返回两个日期相差的年，月，日
        /// </summary>
        protected int GetDateDiffMonth(DateTime startDate, DateTime endDate, string dateType)
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
    }

   
}