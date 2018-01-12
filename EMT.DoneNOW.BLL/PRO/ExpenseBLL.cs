using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class ExpenseBLL
    {
        private sdk_expense_report_dal _dal = new sdk_expense_report_dal();
        /// <summary>
        /// 费用报表 管理（新增，编辑）
        /// </summary>
        public bool ReportManage(sdk_expense_report report,long user_id)
        {
            try
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                report.update_user_id = user_id;
                report.update_time = timeNow;
                if (report.id == 0)
                {
                    report.id = _dal.GetNextIdCom();
                    report.create_time = timeNow;
                    report.create_user_id = user_id;
                    _dal.Insert(report);
                    OperLogBLL.OperLogAdd<sdk_expense_report>(report, report.id, user_id, OPER_LOG_OBJ_CATE.SDK_EXPENSE_REPORT, "新增费用报表");
                }
                else
                {
                    var oldReport = _dal.FindNoDeleteById(report.id);
                    if (oldReport != null)
                    {

                    }
                }
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }
    }
}
