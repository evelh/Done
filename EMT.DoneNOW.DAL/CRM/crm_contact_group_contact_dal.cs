using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{

    public class crm_contact_group_contact_dal : BaseDAL<crm_contact_group_contact>
    {
        /// <summary>
        /// 获取指定联系人组下的指定客户的联系人信息
        /// </summary>
        public List<crm_contact_group_contact> GetAccountGroupContact(long groupId, long accountId)
        {
            return FindListBySql($@"SELECT ccgc.* from crm_contact_group_contact ccgc
INNER JOIN crm_contact_group ccg
on ccgc.contact_group_id = ccg.id
INNER JOIN crm_contact cc
on ccgc.contact_id = cc.id
where ccgc.delete_time = 0 and ccg.delete_time = 0 and cc.delete_time = 0 and ccg.id = {groupId} and cc.account_id = {accountId}");
        }
        /// <summary>
        /// 根据联系人组 和联系人Id 获取组内联系人信息
        /// </summary>
        public crm_contact_group_contact GetByGroupContact(long groupId,long contactId)
        {
            return FindSignleBySql<crm_contact_group_contact>($"SELECT * from crm_contact_group_contact where delete_time =0 and contact_group_id ={groupId} and contact_id = {contactId}");
        }
    }
}
