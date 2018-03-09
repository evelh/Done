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
        /// <summary>
        /// 根据部门id和员工id获取相应关系
        /// </summary>
        public sys_resource_department GetSinByDepIdResId(long department_id,long res_id)
        {
            return FindSignleBySql<sys_resource_department>($"SELECT * from sys_resource_department where department_id = {department_id} and resource_id = {res_id} and is_active = 1");
        }
        /// <summary>
        /// 根据id集合获取相关信息
        /// </summary>
        public List<sys_resource_department> GetListByIds(string ids)
        {
            return FindListBySql<sys_resource_department>($"SELECT * from sys_resource_department where is_active = 1 and id in({ids})");
        }
        public sys_department GetDepByRes(long res_id)
        {
            return FindSignleBySql<sys_department>($"SELECT * from sys_department where id in ( select department_id from sys_resource_department where resource_id = {res_id} and is_default = 1 )  and delete_time = 0");
        }
        /// <summary>
        /// 根据部门和员工获取相应信息
        /// </summary>
        public List<sys_resource_department> GetResRoleList(long department_id, long res_id)
        {
            return FindListBySql<sys_resource_department>($"SELECT * from sys_resource_department where department_id = {department_id} and resource_id = {res_id} and is_active = 1");
        }
        /// <summary>
        /// 获取到默认的员工队列信息
        /// </summary>
        public sys_resource_department GetDefault(long res_id)
        {
            return FindSignleBySql<sys_resource_department>($"SELECT * from sys_resource_department where  resource_id = {res_id} and is_active = 1 and is_default = 1");
        }
    }
}
