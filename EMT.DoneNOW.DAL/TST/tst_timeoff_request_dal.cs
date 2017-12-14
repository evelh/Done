
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class tst_timeoff_request_dal : BaseDAL<tst_timeoff_request>
    {
        /// <summary>
        /// 根据任务id 和员工id 获取相应数据
        /// </summary>
        public List<tst_timeoff_request> GetListByTaskAndRes(long task_id,long res_id)
        {
            // TIMEOFF_REQUEST_STATUS
            return FindListBySql<tst_timeoff_request>($"select * from tst_timeoff_request where status_id = {(int)DTO.DicEnum.TIMEOFF_REQUEST_STATUS.COMMIT} and task_id = {task_id} and create_user_id = {res_id}");
        }
    }
}
