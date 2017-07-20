using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class CompanyAddDto
    {
        public General general;
        public Note note;
        public Todo todo;
        public Contact contact;
        public Site site;
        public Location location;

        public class General
        {
            public string company_name; // 客户名称

            public string phone;        // 电话
            public string email;        // Email
            public int? tax_region;        // 税区域
            public string tax_id;        // 税编号
            public bool? tax_exempt;        // 是否免税
            public string alternate_phone1;        // 备用电话1
            public string alternate_phone2;        // 备用电话2

            public string fax;                 // 传真
            public int? company_type;           // 公司类型
            public int? classification;         // 分类类别
            public long? account_manage;         // 客户经理
            public int? territory_name;         // 地域名称
            public int? market_segment;         // 市场领域
            public int? competitor;             // 竞争对手
            public int? parent_company_name;    // 父客户名称
            public string web_site;            // 官网
            public string company_number;        // 客户编号

            public List<UserDefinedFieldValue> udf;//  客户自定义字段

        }

        public class Contact
        {
            public string first_name;
            public string last_name;
            public string contact_name; // 联系人
            public int? sufix;           // 称谓
            public string title;        // 头衔
            public string mobile_phone;        // 移动电话
            public string email;
            public List<UserDefinedFieldValue> udf;  // 联系人自定义字段
        }
        public class Note
        {
            public int note_action_type;       // 活动类型
            public string note_start_time;   // 开始时间
            public string note_end_time;     // 结束时间
            public string note_description;    // 描述

        }

        public class Todo
        {
            public int todo_action_type;       // 活动类型
            public long assigned_to;      // 负责人的id
            public string todo_start_time;   // 开始时间
            public string todo_end_time;     // 结束时间
            public string todo_description;    // 描述
        }

        public class Site
        {
            public List<UserDefinedFieldValue> udf;
        }

        public class Location
        {
            public int country_id;             // 国家
            public int province_id;             // 省
            public int city_id;                // 市
            public int district_id;            // 区县
            public string address;             // 详细地址
            public string additional_address;  // 地址标签
            public int? is_default;             // 是否默认
            public string postal_code;         // 邮编
        }

    }
}
