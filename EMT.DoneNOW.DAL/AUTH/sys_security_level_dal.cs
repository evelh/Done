using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_security_level_dal : BaseDAL<sys_security_level>
    {
        /// <summary>
        /// 获取所有激活可用的安全等级列表
        /// </summary>
        /// <returns></returns>
        public List<sys_security_level> GetSecLevelList()
        {
            return FindListBySql("SELECT * FROM sys_security_level WHERE is_active=1 AND delete_time=0");
        }
    }

}
