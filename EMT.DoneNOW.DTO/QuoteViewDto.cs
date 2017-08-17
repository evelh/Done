using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
   public class QuoteViewDto
    {
        public string product_name { get; set; }
        public int cycle_id { get; set; }
        public crm_quote_item item { get; set; }
    }
}
