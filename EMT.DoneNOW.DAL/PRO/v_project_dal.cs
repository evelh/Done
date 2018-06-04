
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class v_project_dal : BaseDAL<v_project>
    {
        public v_project GetById(long projectId)
        {
            return FindSignleBySql<v_project>("SELECT * from v_project where project_id = "+ projectId.ToString());
        }
    }
}
