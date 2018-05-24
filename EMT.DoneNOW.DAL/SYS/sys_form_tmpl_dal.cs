using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_form_tmpl_dal : BaseDAL<sys_form_tmpl>
    {
        /// <summary>
        /// 根据快速代码获取模板
        /// </summary>
        public sys_form_tmpl GetByCode(string code)
        {
            return FindSignleBySql<sys_form_tmpl>($"SELECT * from sys_form_tmpl where speed_code = '{code}' and delete_time = 0");
        }
    }

}
