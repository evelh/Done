using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class QuoteCloseDto
    {
        public crm_quote quote;
        public bool isCreateInvoice;            // 是否创建发票
        public crm_opportunity opportunity;    // 该报价关联的商机

        public Dictionary<long, string> dic;
        public long? project_id = null;
        public long? saleOrderId = null;
    }
}
