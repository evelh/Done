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
        public List<pro_project_team> GetResListByProId(long project_id)
        {
            return FindListBySql<pro_project_team>($"SELECT * from pro_project_team where project_id = {project_id} and contact_id is NULL and resource_id IS not null and delete_time = 0;");
        }
        /// <summary>
        /// 根据项目ID 获取到项目的联系人
        /// </summary>
        public List<pro_project_team> GetConListByProId(long project_id)
        {
            return FindListBySql<pro_project_team>($"SELECT * from pro_project_team where project_id = {project_id} and contact_id is not NULL and resource_id IS null and delete_time = 0;");
        }
        /// <summary>
        /// 返回费率数量
        /// </summary>
        public List<pro_project_team> GetRateNum(long project_id)
        {
            return FindListBySql<pro_project_team>($"select x.* from pro_project_team_role x,pro_project_team y where x.delete_time=0 and y.delete_time=0 and x.project_team_id=y.id and y.project_id={project_id}");
        }
        /// <summary>
        /// 根据项目，员工，和角色，获取到团队成员信息
        /// </summary>
        public pro_project_team GetSinProByIdResRol(long project_id,long res_id,long role_id)
        {
            return FindSignleBySql<pro_project_team>($"SELECT ppt.* from pro_project_team  ppt INNER JOIN pro_project_team_role pptr on ppt.id = pptr.project_team_id where project_id = {project_id} and resource_id = {res_id} and pptr.role_id = {role_id} and ppt.delete_time = 0 AND pptr.delete_time = 0");
        }
    }
}
