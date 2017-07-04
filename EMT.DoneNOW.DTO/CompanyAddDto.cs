using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
     public class CompanyAddDto
    {
        public general _general;
        public note _note;
        public todo _todo;
        public contact _contact;
    }
    public class general
    {
        public object udf;// User-Defined Fields 用户自定义字段
        public string company_name; // 客户名称
        public string contact_name; // 联系人
        public string sufix;        // 称谓
        public string title;        // 头衔
        public string phone;        // 电话
        public string email;        // Email
        public int tax_region;        // 税区域
        public string tax_id;        // 税编号
        public bool tax_exempt;        // 是否免税
        public string alternate_phone1;        // 备用电话1
        public string alternate_phone2;        // 备用电话2
        public string mobile_phone;        // 移动电话
        public string fax;                 // 传真
        public int company_type;           // 公司类型
        public Int32? classification;      // 分类类别
        public int account_manage;         // 客户经理
        public int territory_name;         // 地域名称
        public int market_segment;         // 市场领域
        public int competitor;             // 竞争对手
        public int parent_company_name;    // 父客户名称
        public string web_site;            // 官网
        public string company_number;        // 客户编号


    }

    public class contact
    {
        public string alternate_email; // 备用email
        public string customs_contact; // 联系人类型
    }
    public class note
    {
        public int action_type;       // 活动类型
        public DateTime start_time;   // 开始时间
        public DateTime end_time;     // 结束时间
        public string description;    // 描述

    }

    public class todo
    {
        public int action_type;       // 活动类型
        public string assigned_to;    // 负责人
        public DateTime start_time;   // 开始时间
        public DateTime end_time;     // 结束时间
        public string description;    // 描述
    }
}
