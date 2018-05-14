
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_work_list_dal : BaseDAL<sys_work_list>
    {
        /// <summary>
        /// 根据员工Id 获取员工的工作清单
        /// </summary>
        public sys_work_list GetByResId(long resId)
        {
            return FindSignleBySql<sys_work_list>($"SELECT * from sys_work_list where resource_id = {resId} and delete_time = 0");
        }
    }
}
