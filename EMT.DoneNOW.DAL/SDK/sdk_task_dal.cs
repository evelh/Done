using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_dal : BaseDAL<sdk_task>
    {
        public List<sdk_task> GetProTask(long project_id)
        {
            return FindListBySql<sdk_task>($"select * from sdk_task where delete_time = 0 and project_id = {project_id}"); ;
        }
    }
}
