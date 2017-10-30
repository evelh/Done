using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_resource_department_dal : BaseDAL<sys_resource_department>
    {
        /// <summary>
        /// 根据员工ID和部门类型查找角色List
        /// </summary>
        /// <param name="resource_id"></param>
        /// <param name="where"></param>
        /// <returns></returns>
        public List<sys_resource_department> GetRolesBySource(long resource_id, DTO.DicEnum.DEPARTMENT_CATE cate)
        {
            return FindListBySql<sys_resource_department>($"select srd.* from sys_resource_department srd, sys_department sd WHERE srd.department_id = sd.id and sd.cate_id = {(int)cate} and srd.resource_id = {resource_id} ");
        }
        /// <summary>
        /// 根据员工和角色获取员工角色关系表
        /// </summary>
        public List<sys_resource_department> GetResDepByResAndRole(long resid,long role_id)
        {
            return FindListBySql<sys_resource_department>($"SELECT * FROM sys_resource_department WHERE resource_id = {resid} and role_id = {role_id} and is_active = 1");
        }

 
        
    }
}
