using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.Core
{
    public class SoftDeleteCore
    {
        public Int64 delete_time { get; set; }
        public Int64 create_time { get; set; }
        public Int64 create_by_id { get; set; }
        public Int64 update_time { get; set; }
        public Int64 update_by_id { get; set; }
        public Int64 delete_by_id { get; set; }
    }
}
