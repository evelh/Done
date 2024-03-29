﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_role_dal : BaseDAL<sys_role>
    {
        /// <summary>
        /// 获取可用的业务角色列表
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<sys_role> GetList()
        {
            return FindListBySql($"SELECT * FROM sys_role WHERE is_active=1 AND delete_time=0");
        }
        /// <summary>
        /// 查询出未在合同的预付时间系数出现的角色
        /// </summary>
        public List<sys_role> GetContarctNoRate(long contract_id)
        {
            return FindListBySql($" SELECT * from sys_role where id not in(select c.role_id from ctt_contract_rate c where contract_id = {contract_id} and delete_time = 0 ) and delete_time = 0;");
        }
        /// <summary>
        /// 获取合同例外因素相关角色
        /// </summary>
        public List<sys_role> GetConExcRole(long contract_id)
        {
            return FindListBySql($"SELECT * from sys_role where id  in (SELECT role_id FROM ctt_contract_exclusion_role WHERE contract_id={contract_id} AND delete_time=0) and delete_time = 0 ");
        }
        /// <summary>
        /// 获取不在该合同例外因素内的角色
        /// </summary>
        public List<sys_role> GetNotConExcRole(long contract_id)
        {
            return FindListBySql($"SELECT * from sys_role where id not in (SELECT role_id FROM ctt_contract_exclusion_role WHERE contract_id={contract_id} AND delete_time=0) and delete_time = 0 ");
        }
        /// <summary>
        /// 获取员工角色表中 激活的队列角色
        /// </summary>
        public List<sys_role> GetRoleByResId(long resId)
        {
            return FindListBySql($"SELECT DISTINCT(sr.id), sr.* from sys_role sr INNER JOIN sys_resource_department srd on sr.id = srd.role_id INNER JOIN sys_department sd on sd.id = srd.department_id where sr.delete_time = 0 and srd.resource_id = {resId} and sr.is_active = 1 and sd.cate_id = {(int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE}");
        }
    }
}
