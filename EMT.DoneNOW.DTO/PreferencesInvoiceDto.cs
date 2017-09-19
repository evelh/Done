using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class PreferencesInvoiceDto
    {
        public crm_account_reference accRef;      // 发票模板设置
        public int is_tax_exempt;                // 是否免税
        public int? tax_region_id;                // 税区
        public string tax_identification;         // 税号
        public bool enable_email_invoice;         // 可以发送发票
    }
}
