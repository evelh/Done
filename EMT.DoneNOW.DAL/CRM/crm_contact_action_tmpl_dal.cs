
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_contact_action_tmpl_dal : BaseDAL<crm_contact_action_tmpl>
    {
        /// <summary>
        /// 根据名称获取活动模板
        /// </summary>
        public crm_contact_action_tmpl GetTempByName(string name)
        {
            return FindSignleBySql<crm_contact_action_tmpl>($"SELECT * from crm_contact_action_tmpl where name='{name}' and delete_time = 0");
        }

    }
}
