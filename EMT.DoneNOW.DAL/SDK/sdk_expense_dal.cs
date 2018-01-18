using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_expense_dal : BaseDAL<sdk_expense>
    {
        /// <summary>
        /// 根据项目Id 获取费用信息
        /// </summary>
        public List<sdk_expense> GetExpByProId(long project_id)
        {
            return FindListBySql<sdk_expense>($"SELECT * from sdk_expense where project_id = {project_id} and delete_time = 0");
        }
        /// <summary>
        /// 根据任务id获取相应费用信息
        /// </summary>
        public List<sdk_expense> GetExpByTaskId(long task_id)
        {
            return FindListBySql<sdk_expense>($"SELECT * from sdk_expense where task_id = {task_id} and delete_time = 0");
        }

        /// <summary>
        /// 获取到引用这个费用报表的费用
        /// </summary>
        public List<sdk_expense> GetExpByReport(long report_id)
        {
            return FindListBySql<sdk_expense>($"SELECT * from sdk_expense where expense_report_id = {report_id} and delete_time = 0");
        }
        /// <summary>
        /// 根据报表Id获取所有
        /// </summary>
        public List<sdk_expense> GetAppExp(long report_id)
        {
            return FindListBySql<sdk_expense>($"SELECT se.* from sdk_expense se  INNER JOIN sdk_task st on se.task_id = st.id INNER JOIN ctt_contract cc on st.contract_id = cc.id INNER JOIN sdk_expense_report ser on se.expense_report_id = ser.id where se.delete_time = 0 and cc.delete_time = 0 and st.delete_time = 0 and se.expense_report_id = {report_id} and cc.bill_post_type_id = {(int)DTO.DicEnum.BILL_POST_TYPE.ENTRY_APP_BILL} and ser.status_id = {(int)DTO.DicEnum.EXPENSE_REPORT_STATUS.PAYMENT_BEEN_APPROVED}");
        }
    }
}
