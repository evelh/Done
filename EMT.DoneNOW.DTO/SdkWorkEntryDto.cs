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
    }
}
