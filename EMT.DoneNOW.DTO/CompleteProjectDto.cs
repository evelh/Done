using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class CompleteProjectDto
    {
        public pro_project project;
        public List<sdk_task> taskList;
        public List<SaveInsPro> insProList;
        public DateTime ProStartDate;            // 商机承诺履行时间
        public bool isUpdateOppDate = false;     // 
        public bool isUpdateOppStatus = false;   // 

        public string noResIds;             // 通知的员工的ID
        public string otherMail="";            // 其余通知邮件
        public long noTempId;               // 通知模板Id
        public string subject;
        public string appendText;           // 追加的文本
    }
    public class SaveInsPro
    {
        public long id;               // 成本ID
        public long product_id;       // 产品ID
        public DateTime? installOn;    // 安装日期
        public DateTime? warExpiration;// 质保过期日期
        public string serial_number;  // 序列号
    }
}
