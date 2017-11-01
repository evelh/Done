
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class pro_project_team_role_dal : BaseDAL<pro_project_team_role>
    {
        /// <summary>
        /// 根据员工团队ID，获取项目团队角色
        /// </summary>
        public pro_project_team_role GetSinTeamRole(long team_id)
        {
            return FindSignleBySql<pro_project_team_role>($"SELECT * from pro_project_team_role where delete_time = 0 AND project_team_id = {team_id}");
        }
    }
}
