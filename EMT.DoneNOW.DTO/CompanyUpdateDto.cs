using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class CompanyUpdateDto
    {
        public General_Update general_update;
        public Additional_Info additional_info;
        public Site_Configuration site_configuration;
        public Alerts alerts;


        public class General_Update
        {
            // 1.联系方式和地址信息
            public long id;
            public string company_name;        // 客户名称
            public sbyte is_active;            // 是否激活
            public string company_number;      // 客户编号
            public int country_id;             // 国家
            public int province_id;             // 省
            public int city_id;                // 市
            public int district_id;            // 区县
            public string address;             // 详细地址
            public string additional_address;  // 地址标签
            public string postal_code;         // 邮编
            public string phone;               // 电话
            public string alternate_phone1;    // 备用电话1
            public string alternate_phone2;    // 备用电话2
            public string fax;                 // 传真
            public string web_site;            // 官网
            public sbyte is_optout_survey;     // 是否拒绝问卷
            public int mileage;                // 全程距离
            public sbyte is_default;           // 是否是默认地址  1 是  0 不是


            // 2.管理信息
            public int company_type;           // 公司类型
            public Int32? classification;      // 分类类别
            public int account_manage;         // 客户经理
            public string account_team;        // 管理团队
            public int territory_name;         // 地域名称
            public int market_segment;         // 市场领域
            public int competitor;             // 竞争对手

            // 3.税收
            public bool tax_exempt;            // 是否免税
            public int tax_region;             // 税区域
            public string tax_id;              // 税编号

            // 4.父客户
            public long parent_company_name;    // 父客户名称

            public List<UserDefinedFieldValue> udf; // 客户自定义字段
        }

        public class Additional_Info
        {
            public string stock_symbol;              // 股票代码
            public string stock_market;              // 股票市场
            public string sic_code;                  // Sic代码
            public int asset_value;                  // 客户资产价值
            public string weibo_url;                 // 新浪微博地址
            public string wechat_mp_subscription;    // 微信订阅号
            public string wechat_mp_service;         // 微信服务号

        }

        public class Site_Configuration
        {
            public List<UserDefinedFieldValue> udf;   // 客户站点自定义字段

        }

        public class Alerts
        {
            public string Company_Detail_Alert;
            public string New_Ticket_Alert;
            public string Ticket_Detail_Alert;
        }

    }

}
