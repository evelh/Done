using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class ExpenseDto
    {
        public sdk_expense thisExpense;            // 费用
        public sdk_expense_report thisExpReport;   // 费用报表
        public long? pay_type_id;                  // 支付方式ID
    }
}
