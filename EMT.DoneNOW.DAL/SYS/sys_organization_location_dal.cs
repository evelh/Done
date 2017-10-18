using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_organization_location_dal : BaseDAL<sys_organization_location>
    {
        public List<sys_organization_location> GetLocList(string where = "")
        {
            return FindListBySql<sys_organization_location>($"select id,name from sys_organization_location where delete_time=0 "+where);
        }
    }

}