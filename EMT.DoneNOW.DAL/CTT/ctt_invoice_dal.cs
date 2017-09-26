using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_invoice_dal : BaseDAL<ctt_invoice>
    {
        public List<ctt_invoice> GetInvoiceList(string where ="")
        {
            return FindListBySql<ctt_invoice>($"SELECT * FROM ctt_invoice where delete_time = 0 "+ where);
        }
    }
}
