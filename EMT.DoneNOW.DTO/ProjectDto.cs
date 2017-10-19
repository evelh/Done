using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class ProjectDto
    {
        public pro_project project;                // 操作的项目
        public List<UserDefinedFieldValue> udf;    // 自定义字段
        public com_notify_email notify;            // 邮件发送相关--修改无此操作
        public long resource_daily_hours;          // 每天工作小时数
        public string resouIds;                    // 员工Ids
        public string contactIds;                  // 联系人Ids
        public long noti_temp_id;                  // 通知模板
    }
}
