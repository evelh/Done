using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class pro_project_dal : BaseDAL<pro_project>
    {
        public pro_project GetProjectById(long id)
        {
            return FindSignleBySql<pro_project>($"select * from pro_project where id = {id} and delete_time = 0");
        }

        public List<pro_project> GetProjectList()
        {
            return FindListBySql<pro_project>($"select * from pro_project where  delete_time = 0");
        }
        /// <summary>
        /// 根据客户ID 获取到该客户的项目提案
        /// </summary>
        public List<pro_project> GetProjectListByAcc(long account_id)
        {
            return FindListBySql<pro_project>($"select * from pro_project where  delete_time = 0 and account_id = {account_id}");
        }
        /// <summary>
        /// 获取到项目模板
        /// </summary>\
        public List<pro_project> GetTempList()
        {
            return FindListBySql<pro_project>($"select * from pro_project where  delete_time = 0 and type_id = {(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.TEMP}");
        }
    }
}
