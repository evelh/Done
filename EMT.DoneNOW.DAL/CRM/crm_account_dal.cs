using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.Tools;

namespace EMT.DoneNOW.DAL
{
    public class crm_account_dal : BaseDAL<crm_account>
    {
        /// <summary>
        /// 查找指定字段
        /// </summary>
        /// <returns></returns>
        private string CompanyListQueryString()
        {
            return " * ";
        }

        /// <summary>
        /// 根据条件查找
        /// </summary>
        /// <returns></returns>
        public List<crm_account> Find(CompanyConditionDto condition, int pageNum, string orderby)
        {
            if (!(string.IsNullOrEmpty(condition.last_activity_date_min) || Tools.Date.DateHelper.IsDatetimeFormat(condition.last_activity_date_min))
                || !(string.IsNullOrEmpty(condition.last_activity_date_max) || Tools.Date.DateHelper.IsDatetimeFormat(condition.last_activity_date_max)))
            {
                // 时间格式错误
                return null;
            }
            StringBuilder sql = new StringBuilder();
            sql.Append(" 1=1 ");
            if (!string.IsNullOrEmpty(condition.company_name))  // 客户名称
                sql.Append($" AND account_name LIKE '%{condition.company_name}%'");
            if (condition.company_type != null && condition.company_type != 0)  // 客户类型
                sql.Append($" AND cust_type={condition.company_type}");
            //if (condition.account_manager != null && condition.account_manager != 0)    // account_manager
            //    sql.Append($" AND cust_type={condition.account_manager}");    TODO: account_manager对应字段?
            if (condition.territory_name != null && condition.territory_name != 0)  // 所属地区地域
                sql.Append($" AND territory_id={condition.territory_name}");
            if (!string.IsNullOrEmpty(condition.phone))     // 客户电话
                sql.Append($" AND phone LIKE '%{condition.phone}%'");
            if (condition.classification != null && condition.classification != 0)  // 分类
                sql.Append($" AND classification_id={condition.classification}");
            if (!string.IsNullOrEmpty(condition.region_name))  // 地区
                sql.Append($" AND region ='{condition.region_name}'");
            if (!string.IsNullOrEmpty(condition.country))  // 国家
                sql.Append($" AND country LIKE '%{condition.country}%'");
            if (!string.IsNullOrEmpty(condition.last_activity_date_min))  // 最近活动时间大于
                sql.Append($" AND last_activity>{condition.last_activity_date_min}");
            if (!string.IsNullOrEmpty(condition.last_activity_date_max))  // 最近活动时间小于
                sql.Append($" AND last_activity<{condition.last_activity_date_max}");
            if (condition.market_segment != null && condition.market_segment != 0)  // 市场分类
                sql.Append($" AND market_segment_id={condition.market_segment}");
            if (!string.IsNullOrEmpty(condition.city))  // 城市
                sql.Append($" AND city LIKE '%{condition.city}%'");
            if (condition.competitor != null && condition.competitor != 0)  // 竞争对手
                sql.Append($" AND competition_id={condition.competitor}");
            /* TODO:
            if (condition.status != null && condition.status != 0)  // 
                sql.Append($" AND classification_id={condition.status}");
            if (condition.state != null && condition.state != 0)  // 
                sql.Append($" AND classification_id={condition.state}");
            */
            sql.Append(QueryStringDeleteFlag(" "));

            if (!string.IsNullOrEmpty(orderby))
                sql.Append($" ORDER BY {orderby}");
            
            return FindListPage(CompanyListQueryString(), sql.ToString(), pageNum);
        }

        /// <summary>
        /// 查找account_name记录是否已经存在
        /// </summary>
        /// <returns>true:已存在</returns>
        public bool ExistAccountName(string accountName)
        {
            string sql = $"SELECT COUNT(0) FROM crm_account WHERE account_name='{accountName}'";
            object obj = GetSingle(sql);
            int cnt = -1;
            if (int.TryParse(obj.ToString(), out cnt))
            {
                if (cnt > 0)
                    return true;
            }
            return false;
        }

        /// <summary>
        /// 比较两个对象的属性，记录不同的属性及属性值
        /// </summary>
        /// <param name="oldObj"></param>
        /// <param name="newObj"></param>
        /// <returns></returns>
		public string UpdateDetail(crm_account oldObj, crm_account newObj)
        {
            if (oldObj == null || newObj == null)
                return null;
            List<ObjUpdateDto> list = new List<ObjUpdateDto>();
            if (!Object.Equals(oldObj.id, newObj.id))
                list.Add(new ObjUpdateDto { field = "id", old_val = oldObj.id, new_val = newObj.id });
            if (!Object.Equals(oldObj.external_id, newObj.external_id))
                list.Add(new ObjUpdateDto { field = "external_id", old_val = oldObj.external_id, new_val = newObj.external_id });
            if (!Object.Equals(oldObj.parent_id, newObj.parent_id))
                list.Add(new ObjUpdateDto { field = "parent_id", old_val = oldObj.parent_id, new_val = newObj.parent_id });
            if (!Object.Equals(oldObj.territory_id, newObj.territory_id))
                list.Add(new ObjUpdateDto { field = "territory_id", old_val = oldObj.territory_id, new_val = newObj.territory_id });
            if (!Object.Equals(oldObj.market_segment_id, newObj.market_segment_id))
                list.Add(new ObjUpdateDto { field = "market_segment_id", old_val = oldObj.market_segment_id, new_val = newObj.market_segment_id });
            if (!Object.Equals(oldObj.competitor_id, newObj.competitor_id))
                list.Add(new ObjUpdateDto { field = "competitor_id", old_val = oldObj.competitor_id, new_val = newObj.competitor_id });
            if (!Object.Equals(oldObj.account_name, newObj.account_name))
                list.Add(new ObjUpdateDto { field = "account_name", old_val = oldObj.account_name, new_val = newObj.account_name });
            if (!Object.Equals(oldObj.is_active, newObj.is_active))
                list.Add(new ObjUpdateDto { field = "is_active", old_val = oldObj.is_active, new_val = newObj.is_active });
            if (!Object.Equals(oldObj.is_costed_client, newObj.is_costed_client))
                list.Add(new ObjUpdateDto { field = "is_costed_client", old_val = oldObj.is_costed_client, new_val = newObj.is_costed_client });
            if (!Object.Equals(oldObj.is_taxable, newObj.is_taxable))
                list.Add(new ObjUpdateDto { field = "is_taxable", old_val = oldObj.is_taxable, new_val = newObj.is_taxable });
            if (!Object.Equals(oldObj.is_block_account, newObj.is_block_account))
                list.Add(new ObjUpdateDto { field = "is_block_account", old_val = oldObj.is_block_account, new_val = newObj.is_block_account });
            if (!Object.Equals(oldObj.curr_block_balance, newObj.curr_block_balance))
                list.Add(new ObjUpdateDto { field = "curr_block_balance", old_val = oldObj.curr_block_balance, new_val = newObj.curr_block_balance });
            if (!Object.Equals(oldObj.mileage, newObj.mileage))
                list.Add(new ObjUpdateDto { field = "mileage", old_val = oldObj.mileage, new_val = newObj.mileage });
            if (!Object.Equals(oldObj.address1, newObj.address1))
                list.Add(new ObjUpdateDto { field = "address1", old_val = oldObj.address1, new_val = newObj.address1 });
            if (!Object.Equals(oldObj.address2, newObj.address2))
                list.Add(new ObjUpdateDto { field = "address2", old_val = oldObj.address2, new_val = newObj.address2 });
            if (!Object.Equals(oldObj.district_id, newObj.district_id))
                list.Add(new ObjUpdateDto { field = "district_id", old_val = oldObj.district_id, new_val = newObj.district_id });
            if (!Object.Equals(oldObj.postal_code, newObj.postal_code))
                list.Add(new ObjUpdateDto { field = "postal_code", old_val = oldObj.postal_code, new_val = newObj.postal_code });
            if (!Object.Equals(oldObj.phone, newObj.phone))
                list.Add(new ObjUpdateDto { field = "phone", old_val = oldObj.phone, new_val = newObj.phone });
            if (!Object.Equals(oldObj.fax, newObj.fax))
                list.Add(new ObjUpdateDto { field = "fax", old_val = oldObj.fax, new_val = newObj.fax });
            if (!Object.Equals(oldObj.web_site, newObj.web_site))
                list.Add(new ObjUpdateDto { field = "web_site", old_val = oldObj.web_site, new_val = newObj.web_site });
            if (!Object.Equals(oldObj.alternate_phone1, newObj.alternate_phone1))
                list.Add(new ObjUpdateDto { field = "alternate_phone1", old_val = oldObj.alternate_phone1, new_val = newObj.alternate_phone1 });
            if (!Object.Equals(oldObj.alternate_phone2, newObj.alternate_phone2))
                list.Add(new ObjUpdateDto { field = "alternate_phone2", old_val = oldObj.alternate_phone2, new_val = newObj.alternate_phone2 });
            if (!Object.Equals(oldObj.stock_symbol, newObj.stock_symbol))
                list.Add(new ObjUpdateDto { field = "stock_symbol", old_val = oldObj.stock_symbol, new_val = newObj.stock_symbol });
            if (!Object.Equals(oldObj.stock_market, newObj.stock_market))
                list.Add(new ObjUpdateDto { field = "stock_market", old_val = oldObj.stock_market, new_val = newObj.stock_market });
            if (!Object.Equals(oldObj.sic_code, newObj.sic_code))
                list.Add(new ObjUpdateDto { field = "sic_code", old_val = oldObj.sic_code, new_val = newObj.sic_code });
            if (!Object.Equals(oldObj.asset_value, newObj.asset_value))
                list.Add(new ObjUpdateDto { field = "asset_value", old_val = oldObj.asset_value, new_val = newObj.asset_value });
            if (!Object.Equals(oldObj.last_activity_time, newObj.last_activity_time))
                list.Add(new ObjUpdateDto { field = "last_activity_time", old_val = oldObj.last_activity_time, new_val = newObj.last_activity_time });
            if (!Object.Equals(oldObj.account_type_id, newObj.account_type_id))
                list.Add(new ObjUpdateDto { field = "account_type_id", old_val = oldObj.account_type_id, new_val = newObj.account_type_id });
            if (!Object.Equals(oldObj.opportunity_value, newObj.opportunity_value))
                list.Add(new ObjUpdateDto { field = "opportunity_value", old_val = oldObj.opportunity_value, new_val = newObj.opportunity_value });
            if (!Object.Equals(oldObj.block_purchase_total, newObj.block_purchase_total))
                list.Add(new ObjUpdateDto { field = "block_purchase_total", old_val = oldObj.block_purchase_total, new_val = newObj.block_purchase_total });
            if (!Object.Equals(oldObj.block_deduction_total, newObj.block_deduction_total))
                list.Add(new ObjUpdateDto { field = "block_deduction_total", old_val = oldObj.block_deduction_total, new_val = newObj.block_deduction_total });
            if (!Object.Equals(oldObj.account_classification_id, newObj.account_classification_id))
                list.Add(new ObjUpdateDto { field = "account_classification_id", old_val = oldObj.account_classification_id, new_val = newObj.account_classification_id });
            if (!Object.Equals(oldObj.extacct_customer_id, newObj.extacct_customer_id))
                list.Add(new ObjUpdateDto { field = "extacct_customer_id", old_val = oldObj.extacct_customer_id, new_val = newObj.extacct_customer_id });
            if (!Object.Equals(oldObj.use_parent_account_contracts, newObj.use_parent_account_contracts))
                list.Add(new ObjUpdateDto { field = "use_parent_account_contracts", old_val = oldObj.use_parent_account_contracts, new_val = newObj.use_parent_account_contracts });
            if (!Object.Equals(oldObj.attention, newObj.attention))
                list.Add(new ObjUpdateDto { field = "attention", old_val = oldObj.attention, new_val = newObj.attention });
            if (!Object.Equals(oldObj.survey_optout_time, newObj.survey_optout_time))
                list.Add(new ObjUpdateDto { field = "survey_optout_time", old_val = oldObj.survey_optout_time, new_val = newObj.survey_optout_time });
            if (!Object.Equals(oldObj.facebook_url, newObj.facebook_url))
                list.Add(new ObjUpdateDto { field = "facebook_url", old_val = oldObj.facebook_url, new_val = newObj.facebook_url });
            if (!Object.Equals(oldObj.twitter_url, newObj.twitter_url))
                list.Add(new ObjUpdateDto { field = "twitter_url", old_val = oldObj.twitter_url, new_val = newObj.twitter_url });
            if (!Object.Equals(oldObj.linkedin_url, newObj.linkedin_url))
                list.Add(new ObjUpdateDto { field = "linkedin_url", old_val = oldObj.linkedin_url, new_val = newObj.linkedin_url });
            if (!Object.Equals(oldObj.weibo_url, newObj.weibo_url))
                list.Add(new ObjUpdateDto { field = "weibo_url", old_val = oldObj.weibo_url, new_val = newObj.weibo_url });
            if (!Object.Equals(oldObj.wechat_mp_subscription, newObj.wechat_mp_subscription))
                list.Add(new ObjUpdateDto { field = "wechat_mp_subscription", old_val = oldObj.wechat_mp_subscription, new_val = newObj.wechat_mp_subscription });
            if (!Object.Equals(oldObj.wechat_mp_service, newObj.wechat_mp_service))
                list.Add(new ObjUpdateDto { field = "wechat_mp_service", old_val = oldObj.wechat_mp_service, new_val = newObj.wechat_mp_service });
            if (!Object.Equals(oldObj.phone_basic, newObj.phone_basic))
                list.Add(new ObjUpdateDto { field = "phone_basic", old_val = oldObj.phone_basic, new_val = newObj.phone_basic });
            if (!Object.Equals(oldObj.country_id, newObj.country_id))
                list.Add(new ObjUpdateDto { field = "country_id", old_val = oldObj.country_id, new_val = newObj.country_id });
            if (!Object.Equals(oldObj.additional_address_information, newObj.additional_address_information))
                list.Add(new ObjUpdateDto { field = "additional_address_information", old_val = oldObj.additional_address_information, new_val = newObj.additional_address_information });
            if (!Object.Equals(oldObj.tax_region_id, newObj.tax_region_id))
                list.Add(new ObjUpdateDto { field = "tax_region_id", old_val = oldObj.tax_region_id, new_val = newObj.tax_region_id });
            if (!Object.Equals(oldObj.tax_identification, newObj.tax_identification))
                list.Add(new ObjUpdateDto { field = "tax_identification", old_val = oldObj.tax_identification, new_val = newObj.tax_identification });
            if (!Object.Equals(oldObj.alternate_phone1_basic, newObj.alternate_phone1_basic))
                list.Add(new ObjUpdateDto { field = "alternate_phone1_basic", old_val = oldObj.alternate_phone1_basic, new_val = newObj.alternate_phone1_basic });
            if (!Object.Equals(oldObj.alternate_phone2_basic, newObj.alternate_phone2_basic))
                list.Add(new ObjUpdateDto { field = "alternate_phone2_basic", old_val = oldObj.alternate_phone2_basic, new_val = newObj.alternate_phone2_basic });
            if (list.Count == 0)
                return "";
            return new Tools.Serialize().SerializeJson(list);
        }
    }
}
