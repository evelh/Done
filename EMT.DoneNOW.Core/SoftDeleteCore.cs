using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.Core
{
    public class SoftDeleteCore
    {
        public Int64 create_time { get; set; }
        public Int64 update_time { get; set; }
        public Int64 delete_time { get; set; }
        public Int64 create_user_id { get; set; }
        public Int64 update_user_id { get; set; }
        public Int64 delete_user_id { get; set; }
    }
}
