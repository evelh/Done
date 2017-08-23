using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_service_dal : BaseDAL<ivt_service>
    {

        public List<ivt_service> GetServiceList(string where ="")
        {
            if (where != "")
            {
                return FindListBySql<ivt_service>($"select * from ivt_service where delete_time = 0 "+where );
            }

            return FindListBySql<ivt_service>($"select * from ivt_service where delete_time = 0");

        }
    }
}
