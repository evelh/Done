using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_invoice_dal : BaseDAL<ctt_invoice>
    {
        /// <summary>
        /// 根据条件获取相对应发票
        /// </summary>
        public List<ctt_invoice> GetInvoiceList(string where ="")
        {
            return FindListBySql<ctt_invoice>($"SELECT * FROM ctt_invoice where delete_time = 0 "+ where);
        }
        /// <summary>
        /// 根据发票批次获取到相对应的发票
        /// </summary>
        public List<ctt_invoice> GetListByBatch(long batch)
        {
            return FindListBySql<ctt_invoice>($"SELECT * from ctt_invoice where delete_time = 0 and batch_id = {batch}");
        }
    }
}
