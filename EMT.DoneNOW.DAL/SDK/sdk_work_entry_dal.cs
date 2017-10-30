using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_work_entry_dal : BaseDAL<sdk_work_entry>
    {
        public List<sdk_work_entry> GetByTaskId(long taskID)
        {
            return FindListBySql<sdk_work_entry>($"SELECT * from sdk_work_entry  where delete_time = 0 and task_id= {taskID}");
        }
    }
}
