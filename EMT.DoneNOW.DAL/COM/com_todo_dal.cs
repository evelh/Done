using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class com_todo_dal : BaseDAL<com_todo>
    {
        /// <summary>
        /// 通过客户ID获取到所有待办信息，按照开始时间升序排列
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<com_todo> FindTodoByAccountId(long account_id)
        {
            // 查找指定的列
            string sql = $"SELECT g.name,t.start_date,t.end_date,t.resource_id from com_todo t ,d_general g where account_id = {account_id} and t.delete_time = 0 and t.action_type_id = g.id ORDER BY start_date";

            return FindListBySql($"SELECT * from com_todo where account_id = {account_id} and delete_time = 0 ORDER BY start_date");
        }
    }
}
