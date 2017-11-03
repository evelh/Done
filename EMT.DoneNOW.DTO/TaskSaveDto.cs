using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class TaskSaveDto
    {
        public sdk_task task;                 // 操作的项目
        public List<UserDefinedFieldValue> udf;     // 自定义字段
        public string subject = "";             // 邮件发送相关--修改无此操作
        public string otherEmail;             // 邮件发送相关--修改无此操作
        public string resDepIds;                    // 员工角色关系表IDs
        public string contactIds;                   // 联系人Ids
        public Dictionary<long, int> predic = null; // 前驱任务相关信息

        public string NoToMe;
        public string NoToProlead;
        public string NoToContacts;
        public string NoToResIds;
        public string NoToDepIds;
        public string NoToToWorkIds;
        public string NoToOtherMail;

        public string NoCcMe;
        public string NoCcContactIds;
        public string NoCcResIds;
        public string NoCcDepIds;
        public string NoCcWorkIds;
        public string NoCcOtherMail;



        public string NoBccContractIds;
        public string NoBccResIds;
        public string NoBccDepIds;
        public string NoBccWorkIds;
        public string NoBccOtherMail;
    }
}
