using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.TimeSheet
{
    public partial class MyTimeSummary : BasePage
    {
        protected List<v_timeoff_total> timeoffSummary;
        protected List<DictionaryEntryDto> resList;
        protected List<sdk_work_entry_report> reportList;
        protected List<TimeoffInfoDto> timeoffList;
        protected long resourceId;
        protected int year;
        protected int startYear;
        protected void Page_Load(object sender, EventArgs e)
        {
            var weBll = new WorkEntryBLL();
            if (!long.TryParse(Request.QueryString["resId"], out resourceId))
                resourceId = LoginUserId;
            if (!int.TryParse(Request.QueryString["year"], out year))
                year = DateTime.Now.Year;
            resList = weBll.GetApproveResList(LoginUserId);
            var res = new UserResourceBLL().GetResourceById(resourceId);
            if (res.hire_date != null)
            {
                startYear = res.hire_date.Value.Year;
                if (year < startYear)
                    year = DateTime.Now.Year;
            }
            else
                startYear = DateTime.Now.Year;

            timeoffList = new TimeOffPolicyBLL().GetResourceTimeoffInfo(year, resourceId);
            reportList = weBll.GetTenWorkEntryReportList(resourceId);
            timeoffSummary = new TimeOffPolicyBLL().GetResourceTimeoffTotal(resourceId, year);
        }
    }
}