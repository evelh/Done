
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class tst_expense_report_log_dal : BaseDAL<tst_expense_report_log>
    {
        /// <summary>
        /// 根据报表ID去获取相应的记录
        /// </summary>
       public List<tst_expense_report_log> GetListByReportId(long reportId)
        {
            return FindListBySql<tst_expense_report_log>($"SELECT * from tst_expense_report_log WHERE expense_report_id = {reportId}");
        }
    }
}
