using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 发票处理和生成发票向导共用
    /// </summary>
    public class InvoiceDealDto
    {
        
        // 页面参数    1 必填参数 2 可空参数
        public int process_action;            // 处理活动
        public int invoice_template_id;       // 发票模板  1
        public bool isInvoiceEmail=false;    // 是否启用发票邮件服务
        public int email_temp_id;            // 邮件信息模板
        public DateTime invoice_date;         // 发票日期  1
        public DateTime? date_range_from;     // 发票开始日期  2
        public DateTime? date_range_to;          // 发票结束日期  2
        public string purchase_order_no;     // 订单号    2 
        public string notes;                    // 发票备注 2
        public int? payment_term_id;          // 支付条款  2
        // 需要用到的参数
        public string ids;                  // 所有的处理的发票的id集合  1
        public List<UserDefinedFieldValue> udf; // 用户自定义

        public bool isShowPrint = false;  // 向导专用
        public bool isShowEmail = false;  // 向导专用
        public bool isQuickBooks = false;  // 向导专用

        public long account_id;    // 跳转预览界面使用

        public long invoice_batch;  // 这一批次生成的发票的批次ID
    }
}
