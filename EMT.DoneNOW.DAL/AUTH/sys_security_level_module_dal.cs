using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_security_level_module_dal : BaseDAL<sys_security_level_module>
    {
        /// <summary>
        /// 根据安全等级id获取其对应的模块
        /// </summary>
        /// <param name="secLevelId"></param>
        /// <returns></returns>
        public List<sys_security_level_module> GetModulesBySecLevelId(long secLevelId)
        {
            string sql = "SELECT * FROM sys_security_level_module WHERE security_level_id=" + secLevelId;
            return FindListBySql(sql);
        }
    }

}
