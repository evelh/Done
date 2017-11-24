using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class sys_oper_log_dal : BaseDAL<sys_oper_log>
    {
        /// <summary>
        /// 根据对象id获取相关日志信息
        /// </summary>
        public List<sys_oper_log> GetLogByOId(long oid,string where="")
        {
            return FindListBySql<sys_oper_log>($"SELECT * from sys_oper_log where oper_object_id={oid}"+where);
        }
    }
}
