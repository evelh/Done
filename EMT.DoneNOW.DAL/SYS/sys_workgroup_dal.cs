
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_workgroup_dal : BaseDAL<sys_workgroup>
    {
        public List<sys_workgroup> GetList(string where = "")
        {
            return FindListBySql<sys_workgroup>($"SELECT * from sys_workgroup where delete_time = 0 " + where);
        }

        /// <summary>
        /// 根据工作组ID获取对应员工信息
        /// </summary>
        public List<sys_resource> GetResouListByWorkIds(string ids)
        {
            return FindListBySql<sys_resource>($" SELECT * from sys_resource where id in( SELECT resource_id from sys_workgroup_resouce where workgroup_id in({ids})) and delete_time = 0");
        }
    }
}
