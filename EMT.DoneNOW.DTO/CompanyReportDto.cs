using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class CompanyReportDto
    {
        public crm_account crm_account;                 // 客户信息
        public List<crm_contact> crm_contact_list;      // 客户联系人信息
        public List<crm_account> subsidiaries_list;     // 客户的所有子公司
        public List<crm_opportunity> opportunity_history_list;// 商机历史
        public List<UserDefinedFieldValue> udf_list;    // 自定义字段
        public List<crm_installed_product> ins_pro_list;// 配置项
        public List<com_todo> todo_list;                // todo 待办列表
        public List<com_note> note_list;                // 备注信息
        public List<crm_opportunity> opportunity_list;  // 商机详情
    }
}
