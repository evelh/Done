using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_contact_group_dal : BaseDAL<crm_contact_group>
    {
        /// <summary>
        /// 根据名称获取联系人组
        /// </summary>
        public crm_contact_group GetGroupByName(string name)
        {
            return FindSignleBySql<crm_contact_group>(string.Format("SELECT * from crm_contact_group where delete_time = 0 and name='{0}'",name));
        }
        
    }
}
