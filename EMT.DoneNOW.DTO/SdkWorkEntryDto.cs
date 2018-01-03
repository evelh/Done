using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class SdkWorkEntryDto
    {
        public sdk_work_entry workEntry;
        public sdk_work_record wordRecord;
        public decimal remain_hours=0;   // task使用，不一样则修改task
        public int status_id;          // task使用，不一样则修改task
        public int notify_id;        // 通知模板  // 通知相关
        public string contact_ids;               // 通知相关
        public string resIds;                    // 通知相关
        public string workGropIds;                // 通知相关

        public string otherEmail;                // 通知相关
        public string subjects;                  // 通知相关
        public string AdditionalText;            // 通知相关
        public bool CCMe = false;
        public bool ToTaskRes;
        public bool ToProLead;
        public bool ToTaskLead;
        public bool ToTab;
        public int ToResId;


        public List<PageEntryDto> pagEntDtoList;
    }

    public class PageEntryDto
    {
        public long id;                  // 相关ID 负数是新增的
        public DateTime time;            // 工时时间 
        public decimal workHours;        // 工作时长
        public string sumNote;          // 说明
        public string ineNote;          // 内部说明
        public long? endDate;      // 结束时间
        public long? startDate;    // 开始时间
        public decimal offset;         // 偏移量
        public decimal? billHours;     // 计费时长

    }
}
