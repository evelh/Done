using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;


namespace EMT.DoneNOW.DTO
{
    public class TaskNoteDto
    {
        public com_activity taskNote;
        public sdk_task thisTask;
        public pro_project thisProjetc;
        public long object_id; 
        public int status_id;        // 任务状态
        public List<AddFileDto> filtList;
        public string attIds="";         // 这个备注的附件 ，修改时使用
        public long account_id;
        public sdk_task thisTicket; 

        public bool incloNoteDes = false;  // 通知邮件中是否包含备注详情
        public bool incloNoteAtt = false;  // 通知邮件中是否包含备注附件
        public bool toCrea = false;         // 任务创建人
        public bool toAccMan = false;       //  发送给客户经理
        public bool ccMe = false;                   // 抄送给我
        public bool fromSys = false;                 // 
        // 工单相关的通知
        public bool toAccTeam = false;    // 通知相关人
        public bool toPriRes = false;     // 通知相关人
        public bool toOtherRes = false;   // 通知相关人



        public string contact_ids;           // 发送联系人id  
        public string resIds;                    // 通知相关
        public string workGropIds;                 // 发送工作组id
        public string otherEmail;                // 通知相关
        public string subjects;                  // 通知相关
        public string AdditionalText;            // 通知相关
        public int notify_id;        // 通知模板  // 通知相关

        // 工单相关
        public bool isAddSol = false;      // 描述附加到本工单上
        public bool isAddAllSol = false;   // 描述附加到所有的相关事故上
        public bool isAddAllNote = false;  // 为所有相关事故更新状态，同时新增备注和相关附件
    }
}
