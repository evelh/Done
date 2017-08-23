using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Text.RegularExpressions;
using EMT.DoneNOW.BLL.CRM;

namespace EMT.DoneNOW.BLL.CRM
{
    public class InstalledProductBLL
    {
        private readonly crm_installed_product_dal _dal = new crm_installed_product_dal();

        /// <summary>
        /// 获取客户相关的列表字典项
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
           // dic.Add("classification", new d_account_classification_dal().GetDictionary());    // 分类类别
           // dic.Add("country", new DistrictBLL().GetCountryList());                          // 国家表
           // dic.Add("addressdistrict", new d_district_dal().GetDictionary());                 // 地址表（省市县区）
           // dic.Add("sys_resource", new sys_resource_dal().GetDictionary());                  // 客户经理
           // dic.Add("competition", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.COMPETITOR)));          // 竞争对手
           // dic.Add("market_segment", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.MARKET_SEGMENT)));    // 行业
           // //dic.Add("district", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("行政//区")));                // 行政区
           // dic.Add("territory", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.TERRITORY)));              // 销售区域
           // dic.Add("company_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.ACCOUNT_TYPE)));              // 客户类型
           // dic.Add("taxRegion", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.TAX_REGION)));              // 税区
           // dic.Add("sufix", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.NAME_SUFFIX)));              // 名字后缀
            dic.Add("installed_product_cate", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.INSTALLED_PRODUCT_CATE)));        // 配置项类型

            return dic;
        }




        /// <summary>
        /// 新增配置项
        /// </summary>
        /// <param name="param"></param>
        /// <param name="account_id"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        public bool ConfigurationItemAdd(ConfigurationItemAddDto param, long user_id)
        {


            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return false;

            // 必填项校验

          
            #region 1.保存配置项
            var installed_product_dal = new crm_installed_product_dal();
            crm_installed_product installed_product = new crm_installed_product()
            {
                id = installed_product_dal.GetNextIdCom(),
                product_id = param.product_id,
                cate_id = param.installed_product_cate_id,
                account_id = param.account_id,
                start_date = param.start_date,
                through_date = param.through_date,
                number_of_users = param.number_of_users,
                serial_number = param.serial_number,
                reference_number = param.reference_number,
                reference_name = param.reference_name,
                contract_id = param.contract_id==0?null:(long?) param.contract_id,
                location = param.location,
                contact_id = param.contact_id == 0 ? null : (long?)param.contact_id,
                vendor_id = param.vendor_id == 0 ? null : (long?)param.vendor_id,
                is_active = (sbyte)param.status,
                installed_resource_id = user.id,
                remark = param.notes,
                // installed_contact_id = param.contact_id, // todo -- 安装人与联系人
                
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                create_user_id = user.id,
                update_user_id = user.id,

                // Terms
                hourly_cost = param.terms.hourly_cost,
                daily_cost = param.terms.daily_cost,
                monthly_cost = param.terms.monthly_cost,
                setup_fee = param.terms.setup_fee,
                peruse_cost = param.terms.peruse_cost,
                accounting_link = param.terms.accounting_link,

            };   // 创建配置项对象
            installed_product_dal.Insert(installed_product);                            // 插入配置项
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                oper_object_id = installed_product.id,
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = installed_product_dal.AddValue(installed_product),
                remark = "新增配置项",
            });                       // 插入操作日志
            param.id = installed_product.id;

            var udf_configuration_items_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONFIGURATION_ITEMS);   // 查询自定义信息
            var udf_configuration_items = param.udf;
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.CONFIGURATION_ITEMS, user.id, installed_product.id, udf_configuration_items_list, udf_configuration_items, OPER_LOG_OBJ_CATE.CONFIGURAITEM);  // 保存自定义扩展信息

            #endregion

            #region 2.保存通知
            //var notify_email_dal = new com_notify_email_dal();
            //var notify_email = new com_notify_email()
            //{
            //    id = notify_email_dal.GetNextIdCom(),
            //    cate_id = (int)NOTIFY_CATE.CRM,
            //    event_id = 1,             // todo
            //    to_email = param.notice.contacts,                  // 接受人地址？？联系人地址   
            //    notify_tmpl_id = param.notice.notification_template,
            //    from_email = user.email,   // todo
            //    from_email_name = user.name,  // todo 
            //    subject = param.notice.subject,
            //    body_text = param.notice.additional_email_text,    // 附加信息？？
            //    is_html_format = 0,                                // 内容是否是html格式，0纯文本 1html
            //    create_user_id = user.id,
            //    update_user_id = user.id,
            //    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),

            //};
            //notify_email_dal.Insert(notify_email);
            //new sys_oper_log_dal().Insert(new sys_oper_log()
            //{
            //    user_cate = "用户",
            //    user_id = user.id,
            //    name = user.name,
            //    phone = user.mobile == null ? "" : user.mobile,
            //    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
            //    oper_object_id = notify_email.id,
            //    oper_type_id = (int)OPER_LOG_TYPE.ADD,
            //    oper_description = installed_product_dal.AddValue(notify_email),
            //    remark = "新增通知",
            //});  // 插入日志

            #endregion

            return true;
        }

        public bool EditConfigurationItem(ConfigurationItemAddDto param, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            var installed_product_dal = new crm_installed_product_dal();

            var old_installed_product = installed_product_dal.GetInstalledProduct(param.id);
            if (old_installed_product == null)
            {
                return false;
            }


            crm_installed_product installed_product = new crm_installed_product()
            {
                id = old_installed_product.id,
                product_id = param.product_id,
                cate_id = param.installed_product_cate_id,
                account_id = param.account_id,
                start_date = param.start_date,
                through_date = param.through_date,
                number_of_users = param.number_of_users,
                serial_number = param.serial_number,
                reference_number = param.reference_number,
                contract_id = param.contract_id == 0 ? null : (long?)param.contract_id,
                location = param.location,
                contact_id = param.contact_id == 0 ? null : (long?)param.contact_id,
                vendor_id = param.vendor_id == 0 ? null : (long?)param.vendor_id,
                is_active = (sbyte)param.status,
                installed_resource_id = user.id,
                // installed_contact_id = param.contact_id, // todo -- 安装人与联系人
                //create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                //create_user_id = user.id,
                update_user_id = user.id,
                remark = param.notes,

                // Terms
                hourly_cost = param.terms.hourly_cost,
                daily_cost = param.terms.daily_cost,
                monthly_cost = param.terms.monthly_cost,
                setup_fee = param.terms.setup_fee,
                peruse_cost = param.terms.peruse_cost,
                accounting_link = param.terms.accounting_link,
                
                #region 服务等信息等待合同创建后处理，其字段从源数据获取

                cost_product_id = old_installed_product.cost_product_id,
                create_time = old_installed_product.create_time,
                create_user_id = old_installed_product.create_user_id,
                delete_time = old_installed_product.delete_time,
                delete_user_id = old_installed_product.delete_user_id,
                entrytimestamp = old_installed_product.entrytimestamp,
                extension_adapter_disovery_data_id = old_installed_product.extension_adapter_disovery_data_id,
                followup_cost = old_installed_product.followup_cost,
                implementation_cost = old_installed_product.implementation_cost,
                installed_contact_id = old_installed_product.installed_contact_id,
                inventory_transfer_id = old_installed_product.inventory_transfer_id,
                is_swapped_out = old_installed_product.is_swapped_out,
                oid = old_installed_product.oid,
                parent_id = old_installed_product.parent_id,
                quote_item_id = old_installed_product.quote_item_id,
                reference_name = old_installed_product.reference_name,
                
                service_bundle_id = old_installed_product.service_bundle_id,
                service_id = old_installed_product.service_id,
                udf_group_id = old_installed_product.udf_group_id,


                #endregion

            };   // 创建配置项对象

            installed_product_dal.Update(installed_product);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONFIGURAITEM,
                oper_object_id = installed_product.id,
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = installed_product_dal.CompareValue(old_installed_product,installed_product),
                remark = "修改配置项相关信息",
            });                       // 插入操作日志





            return true;
        }


    }
}
