using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_notify_rule_recipient_dal : BaseDAL<ctt_contract_notify_rule_recipient>
    {
        /// <summary>
        /// 根据规则Id获取相应接收人的信息
        /// </summary>
       public List<ctt_contract_notify_rule_recipient> GetByRuleId(long rule_id)
        {
            return FindListBySql<ctt_contract_notify_rule_recipient>($"SELECT * from ctt_contract_notify_rule_recipient  where contract_notify_rule_id = {rule_id} and delete_time = 0");
        }
    }
}
