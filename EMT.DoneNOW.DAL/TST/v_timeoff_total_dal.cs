using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class v_timeoff_total_dal : BaseDAL<v_timeoff_total>
    {
        public List<v_timeoff_total> GetResourceTimeoffTotal(long resourceId, int year)
        {
            return FindListBySql($"select * from v_timeoff_total where resource_id={resourceId} and calendar_year={year}");
        }
    }

}
