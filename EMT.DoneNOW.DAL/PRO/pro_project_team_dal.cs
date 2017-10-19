using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class pro_project_team_dal : BaseDAL<pro_project_team>
    {
        /// <summary>
        /// 根据项目ID 获取到项目的员工
        /// </summary>
        /// <returns></returns>
        public List<pro_project_team> GetResListBuProId(long project_id)
        {
            return FindListBySql<pro_project_team>($"SELECT * from pro_project_team where project_id = {project_id} and contact_id is NULL and resource_id IS not null and delete_time = 0;");
        }
        /// <summary>
        /// 根据项目ID 获取到项目的联系人
        /// </summary>
        public List<pro_project_team> GetConListBuProId(long project_id)
        {
            return FindListBySql<pro_project_team>($"SELECT * from pro_project_team where project_id = {project_id} and contact_id is not NULL and resource_id IS null and delete_time = 0;");
        }
    }
}
