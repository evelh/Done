using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class d_sla_dal : BaseDAL<d_sla>
    {
        public List<d_sla> GetList()
        {
            return FindListBySql("SELECT * FROM d_sla WHERE delete_time=0");
        }
    }

}
