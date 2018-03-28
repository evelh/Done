using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public  class TaskServiceCallDto
    {
        public sdk_service_call thisCall;
        public sdk_task thisTicket;
        public string resIds;
        public string callIds;
        public bool isAddCall=false;
        // 通知相关属性
        public string notiResIds;
        public string notiConIds;
        public string otherEmail;
        public long notiTempId;
        public string subject;
        public string appText;
        public bool sendBySys = false;
    }
}
