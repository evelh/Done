using System;
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
            return FindListBySql($" SELECT * from sys_role where id not in(select c.role_id from ctt_contract_rate c where contract_id = 1389 and delete_time = 0 ) and delete_time = 0;");
        }
    }
}
