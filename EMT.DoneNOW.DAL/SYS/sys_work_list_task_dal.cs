
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_work_list_task_dal : BaseDAL<sys_work_list_task>
    {
        /// <summary>
        /// 获取到我的工单/任务列表
        /// </summary>
        public List<sys_work_list_task> GetMyWorkList(long userId,bool isTicket=true)
        {
            string where = "";
            if (isTicket)
                where = " and st.type_id in(1818, 1809)";
            else
                where = " and st.type_id in(1807, 1808, 1812)";
            where += " order by swlt.sort_order";
            return FindListBySql($"SELECT swlt.* from sys_work_list_task swlt INNER JOIN sdk_task st on swlt.task_id = st.id where  st.delete_time = 0  and swlt.resource_id="+ userId.ToString() + where);
        }
        /// <summary>
        /// 根据员工和任务Id 获取相应实例
        /// </summary>
        public sys_work_list_task GetByResTaskId(long resId,long taskId)
        {
            return FindSignleBySql<sys_work_list_task>($"SELECT * from sys_work_list_task where resource_id = {resId} and task_id = {taskId}");
        }
        /// <summary>
        /// 获取到我的工作列表的最大排序号
        /// </summary>
        public long GetMaxSortOrder(long userId)
        {
            return Convert.ToInt64(GetSingle($"SELECT MAX(sort_order) from sys_work_list_task where resource_id = {userId}"));
        }
        /// <summary>
        /// 获取序号比这个大的列表信息
        /// </summary>
        public List<sys_work_list_task> GetTaskListBySort(long userId,long sortOrder)
        {
            return FindListBySql($"SELECT * from sys_work_list_task where resource_id = {userId} and sort_order>{sortOrder}");
        }
    }
}
