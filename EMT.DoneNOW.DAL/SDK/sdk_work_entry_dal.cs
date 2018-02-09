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
        /// <summary>
        /// 获取未被审批提交的工时
        /// </summary>
        public List<sdk_work_entry> GetList(long task_id)
        {
            return FindListBySql<sdk_work_entry>($"SELECT * from sdk_work_entry where delete_time = 0 and task_id={task_id} and approve_and_post_date is null and approve_and_post_user_id is NULL");
        }
        /// <summary>
        /// 查询出本批次中未审批提交的工时
        /// </summary>
        public List<sdk_work_entry> GetBatchList(long batch_id)
        {
            return FindListBySql<sdk_work_entry>($"SELECT * from sdk_work_entry where delete_time = 0  and approve_and_post_date is null and approve_and_post_user_id is NULL and batch_id = {batch_id}");
        }

        /// <summary>
        /// 根据服务获取到相应的工时信息
        /// </summary>
        public List<sdk_work_entry> GetListByService(long serviceId)
        {
            return FindListBySql<sdk_work_entry>($"SELECT id from sdk_work_entry where service_id = {serviceId} and delete_time = 0");
        }


    }
}
