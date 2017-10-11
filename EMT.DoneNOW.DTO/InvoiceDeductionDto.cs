using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class InvoiceDeductionDto
    {
        public long id;  // 条目ID
        public string type_icon;
        public long item_type;
        public string item_type_name;
        public DateTime item_date;
        public string item_name;
        public long? bill_account_id;     // 该条目的计费客户
        public string bill_account_name;
        public long? account_id;
        public string account_name;
        public long? parent_account_id;
        public long? account_manager_id;
        public long? territory;
        public string classification;
        public long? department_id;
        public string department_name;
        public string contract_name;
        public long? contract_type_id;
        public long? contract_cate_id;
        public long? contract_block_id;
        public string purchase_order_no;
        public long? project_id;
        public string project_name;
        public string work_type;   // 工作类型
        public long? role_id;
        public string role_name;
        public long? cost_code_id;
        public string cost_code_name;
        public long? resource_id;
        public string resource_name;
        public string billable;
        public decimal? rate;
        public decimal? hourly_rate;  // 小时费率
        public decimal? quantity;
        public decimal? billable_hours;
        public decimal? dollars;
        public long? tax_category_id;
        public string tax_category_name;
        public long? tax_region_id;
        public string bill_to_parent;
        public string bill_to_sub;
        public long? sub_cate_id;
        public long? invoice_id;
        public long? invoice_line_item_no;

        public string isSub;  // 是否时子公司条目（子公司条目可见不可选）
        

        





    }
}
