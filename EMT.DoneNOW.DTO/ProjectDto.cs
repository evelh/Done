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
        public string resDepIds;                    // 员工角色关系表IDs
        public string contactIds;                  // 联系人Ids
    }
}
