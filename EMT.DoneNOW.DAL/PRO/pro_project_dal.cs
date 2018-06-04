using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

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
            return FindListBySql<pro_project>($"select * from pro_project where  delete_time = 0 and type_id = {(int)DTO.DicEnum.PROJECT_TYPE.TEMP} and status_id <> {(int)DTO.DicEnum.PROJECT_STATUS.DISABLE} ");
        }
        /// <summary>
        /// 根据ids去获取对应的项目的集合
        /// </summary>
        public List<pro_project> GetProListByIds(string ids)
        {
            return FindListBySql<pro_project>($"SELECT * from pro_project where delete_time = 0 and id in ({ids})");
        }
        public List<pro_project> GetProByNo(string no)
        {
            return FindListBySql<pro_project>($"SELECT * from pro_project where delete_time = 0 and no like '%{no}%'");
        }

        public List<pro_project> GetAccByRes(long rid, string showType, bool isShowCom,long account_id)
        {
            var show = "";
            if (showType == "showMe")
            {
                show = $" and (s.create_user_id = {rid} or str.resource_id = {rid} or s.owner_resource_id ={rid} )";
            }
            else if (showType == "showMeDep")
            {
                show = $" and ((s.create_user_id = {rid} or str.resource_id = {rid} or s.owner_resource_id ={rid} )or (s.create_user_id in(SELECT DISTINCT(resource_id) from sys_resource_department where is_active = 1 and department_id  in(SELECT department_id from sys_resource_department where resource_id = {rid})) or s.department_id in (SELECT department_id from sys_resource_department where resource_id = {rid}) or str.resource_id in (SELECT DISTINCT(resource_id) from sys_resource_department where is_active = 1 and department_id  in(SELECT department_id from sys_resource_department where resource_id = {rid})) or s.owner_resource_id in(SELECT DISTINCT(resource_id) from sys_resource_department where is_active = 1 and department_id  in(SELECT department_id from sys_resource_department where resource_id = {rid}))))";
            }

            string sql = $"SELECT DISTINCT(p.id),p.name FROM  crm_account a INNER JOIN  pro_project p on p.account_id = a.id INNER JOIN sdk_task s on s.project_id = p.id LEFT JOIN sdk_task_resource str on s.id = str.task_id where p.delete_time = 0 and s.delete_time = 0 and a.delete_time = 0 and s.type_id <> {(int)DicEnum.TASK_TYPE.PROJECT_PHASE} and  p.type_id not in({(int)DicEnum.PROJECT_TYPE.TEMP},{(int)DicEnum.PROJECT_TYPE.BENCHMARK}) and p.account_id = {account_id}";
            if (!isShowCom)
            {
                sql += $" and s.status_id <> {(int)DicEnum.TICKET_STATUS.DONE}";
            }
            sql += show;
            return FindListBySql<pro_project>(sql);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        public List<long> GetRes(string sql)
        {
            // SELECT DISTINCT owner_resource_id from pro_project where delete_time =0 and owner_resource_id is not NULL
            return FindListBySql<long>(sql);
        }

    }
}
