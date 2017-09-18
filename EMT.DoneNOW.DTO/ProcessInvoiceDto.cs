using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class ProcessInvoiceDto
    {
        
        // 页面参数
        public int process_action;            // 处理活动
        public int invoice_template_id;       // 发票模板
        public bool isInvoiceEmail=false;    // 是否启用发票邮件服务
        public int email_temp_id;            // 邮件信息模板
        public DateTime invoice_date;         // 发票日期
        public DateTime? date_range_from;     // 发票开始日期
        public DateTime? date_range_to;          // 发票结束日期
        public string purchase_order_number;     // 订单号
        public string notes;                    // 发票备注
        public int? payment_term_id;          // 支付条款
        // 需要用到的参数
        public string ids;                  // 所有的处理的发票的id集合
        //public long account_id;             // 当前客户

    }
}
