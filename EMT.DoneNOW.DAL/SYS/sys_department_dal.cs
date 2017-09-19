using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_department_dal : BaseDAL<sys_department>
    {
        /// <summary>
        /// 查询出所有可用的部门
        /// </summary>
        /// <returns></returns>
        public List<sys_department> GetDepartment()
        {
            return FindListBySql<sys_department>("select * from sys_department where is_active =1 and delete_time = 0");
        }
    }

}
