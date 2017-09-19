using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class ConfigurationItemAddDto
    {
        public long id;
        public long product_id;                      // 产品
        public int? installed_product_cate_id;         // 配置项类型
        public int installed_by;                    // 安装人
        public DateTime start_date;               // 安装日期 -- 默认为当天
        public DateTime through_date;        // 质保过期日期 -- 默认一年后的今天
        public string serial_number;                // 序列号
        public string reference_number;             // 参考号
        public string reference_name;              // 参考标题
        public decimal? number_of_users;                 // 用户数
        public int status;                          // 激活状态 1-0激活 0-未激活
        public long account_id;                     // 所属客户
        public long? contact_id;                     // 联系人
        public string location;                     // 区域-- 安装位置
        public int? contract_id;                        // 合同
        public int? service;               // 服务/服务包
        public bool reviewed_for_contract;          //        待确认
        public string materal_code;                 // 物料成本代码
        public int? vendor_id;                          // 供应商(类型为供应商的客户)
        public string manufacturer;                 // 制造商
        public string notes;                        // 备注
        public long? contract_cost_id;              // 合同成本ID
        public List<UserDefinedFieldValue> udf;     // 自定义配置项
        public Terms terms;
        public Notice notice;
    }

    public class Terms
    {
        public decimal hourly_cost;                // 每小时成本，保留两位小数
        public decimal monthly_cost;               // 月度成本，两位小数
        public decimal daily_cost;                 // 日成本，两位小数
        public decimal peruse_cost;              // 每次使用成本
        public decimal setup_fee;                  // 初始费用
        public string accounting_link;                // 客户链接  待确认
    }
    public class Notice
    {
        public string resources;                  // 员工
        public string contacts;                   // 联系人
        public string other_emails;               // 其他邮件地址
        public int notification_template;         // 通知模板
        public string subject;                    // 主题
        public string additional_email_text;      // 附加信息
    }
}
