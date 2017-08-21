using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
     public  class LoseOpportunityDto
    {
        public crm_opportunity opportunity;     // 商机
        public com_notify_email notify;         // 通知
        public int notifyTempId;                // 通知模板
    }
}
