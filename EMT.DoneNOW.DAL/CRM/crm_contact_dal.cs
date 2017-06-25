using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class crm_contact_dal : BaseDAL<crm_contact>
    {
        /// <summary>
        /// 查找指定字段
        /// </summary>
        /// <returns></returns>
        private string ContactListQueryString()
        {
            return " * ";
        }

        /// <summary>
        /// 根据条件查找
        /// </summary>
        /// <param name="condition"></param>
        /// <param name="orderby"></param>
        /// <param name="pageNum"></param>
        /// <returns></returns>
        public List<crm_contact> Find(ContactCondition condition, int pageNum, string orderby)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append(" 1=1 ");
            if (!string.IsNullOrEmpty(condition.name))      // 姓名
                sql.Append($" AND name LIKE '%{condition.name}%' ");
            if (!string.IsNullOrEmpty(condition.phone))      // phone
                sql.Append($" AND phone LIKE '%{condition.phone}%' ");
            if (!string.IsNullOrEmpty(condition.email_address))      // email
                sql.Append($" AND email_address LIKE '%{condition.email_address}%' ");
            if (!string.IsNullOrEmpty(condition.company_name))      // 公司名称
                sql.Append($" AND account_id IN (SELECT id FROM crm_account WHERE account_name LIKE '%{condition.company_name}%') ");
            if (!string.IsNullOrEmpty(condition.parent_company_name))      // 母公司名称
                sql.Append($" AND account_id IN (SELECT id FROM crm_account WHERE parent_id IN (SELECT id FROM crm_account WHERE account_name LIKE '%{condition.parent_company_name}%')) ");
            if (condition.is_active != null)      // 状态
                sql.Append($" AND is_active='{condition.is_active}' ");

            sql.Append(QueryStringDeleteFlag(" "));

            if (!string.IsNullOrEmpty(orderby))
                sql.Append($" ORDER BY {orderby}");

            return FindListPage(ContactListQueryString(), sql.ToString(), pageNum);
        }

        /// <summary>
        /// 比较两个对象的属性，记录不同的属性及属性值
        /// </summary>
        /// <param name="oldObj"></param>
        /// <param name="newObj"></param>
        /// <returns></returns>
		public string UpdateDetail(crm_contact oldObj, crm_contact newObj)
        {
            if (oldObj == null || newObj == null)
                return null;
            List<ObjUpdateDto> list = new List<ObjUpdateDto>();
            if (!oldObj.id.Equals(newObj.id))
                list.Add(new ObjUpdateDto { field = "id", old_val = oldObj.id, new_val = newObj.id });
            if (!oldObj.external_id.Equals(newObj.external_id))
                list.Add(new ObjUpdateDto { field = "external_id", old_val = oldObj.external_id, new_val = newObj.external_id });
            if (!oldObj.cust_link.Equals(newObj.cust_link))
                list.Add(new ObjUpdateDto { field = "cust_link", old_val = oldObj.cust_link, new_val = newObj.cust_link });
            if (!oldObj.account_id.Equals(newObj.account_id))
                list.Add(new ObjUpdateDto { field = "account_id", old_val = oldObj.account_id, new_val = newObj.account_id });
            if (!oldObj.phone.Equals(newObj.phone))
                list.Add(new ObjUpdateDto { field = "phone", old_val = oldObj.phone, new_val = newObj.phone });
            if (!oldObj.fax.Equals(newObj.fax))
                list.Add(new ObjUpdateDto { field = "fax", old_val = oldObj.fax, new_val = newObj.fax });
            if (!oldObj.alternate_phone1.Equals(newObj.alternate_phone1))
                list.Add(new ObjUpdateDto { field = "alternate_phone1", old_val = oldObj.alternate_phone1, new_val = newObj.alternate_phone1 });
            if (!oldObj.alternate_phone2.Equals(newObj.alternate_phone2))
                list.Add(new ObjUpdateDto { field = "alternate_phone2", old_val = oldObj.alternate_phone2, new_val = newObj.alternate_phone2 });
            if (!oldObj.mobile_phone.Equals(newObj.mobile_phone))
                list.Add(new ObjUpdateDto { field = "mobile_phone", old_val = oldObj.mobile_phone, new_val = newObj.mobile_phone });
            if (!oldObj.title.Equals(newObj.title))
                list.Add(new ObjUpdateDto { field = "title", old_val = oldObj.title, new_val = newObj.title });
            if (!oldObj.extra_notes.Equals(newObj.extra_notes))
                list.Add(new ObjUpdateDto { field = "extra_notes", old_val = oldObj.extra_notes, new_val = newObj.extra_notes });
            if (!oldObj.room_number.Equals(newObj.room_number))
                list.Add(new ObjUpdateDto { field = "room_number", old_val = oldObj.room_number, new_val = newObj.room_number });
            if (!oldObj.name.Equals(newObj.name))
                list.Add(new ObjUpdateDto { field = "name", old_val = oldObj.name, new_val = newObj.name });
            if (!oldObj.email.Equals(newObj.email))
                list.Add(new ObjUpdateDto { field = "email", old_val = oldObj.email, new_val = newObj.email });
            if (!oldObj.wants_email.Equals(newObj.wants_email))
                list.Add(new ObjUpdateDto { field = "wants_email", old_val = oldObj.wants_email, new_val = newObj.wants_email });
            if (!oldObj.email_freq.Equals(newObj.email_freq))
                list.Add(new ObjUpdateDto { field = "email_freq", old_val = oldObj.email_freq, new_val = newObj.email_freq });
            if (!oldObj.is_active.Equals(newObj.is_active))
                list.Add(new ObjUpdateDto { field = "is_active", old_val = oldObj.is_active, new_val = newObj.is_active });
            if (!oldObj.is_web_user.Equals(newObj.is_web_user))
                list.Add(new ObjUpdateDto { field = "is_web_user", old_val = oldObj.is_web_user, new_val = newObj.is_web_user });
            if (!oldObj.ca_security_group_id.Equals(newObj.ca_security_group_id))
                list.Add(new ObjUpdateDto { field = "ca_security_group_id", old_val = oldObj.ca_security_group_id, new_val = newObj.ca_security_group_id });
            if (!oldObj.address1.Equals(newObj.address1))
                list.Add(new ObjUpdateDto { field = "address1", old_val = oldObj.address1, new_val = newObj.address1 });
            if (!oldObj.address2.Equals(newObj.address2))
                list.Add(new ObjUpdateDto { field = "address2", old_val = oldObj.address2, new_val = newObj.address2 });
            if (!oldObj.district_id.Equals(newObj.district_id))
                list.Add(new ObjUpdateDto { field = "district_id", old_val = oldObj.district_id, new_val = newObj.district_id });
            if (!oldObj.post_code.Equals(newObj.post_code))
                list.Add(new ObjUpdateDto { field = "post_code", old_val = oldObj.post_code, new_val = newObj.post_code });
            if (!oldObj.last_activity_time.Equals(newObj.last_activity_time))
                list.Add(new ObjUpdateDto { field = "last_activity_time", old_val = oldObj.last_activity_time, new_val = newObj.last_activity_time });
            if (!oldObj.date_format.Equals(newObj.date_format))
                list.Add(new ObjUpdateDto { field = "date_format", old_val = oldObj.date_format, new_val = newObj.date_format });
            if (!oldObj.time_format.Equals(newObj.time_format))
                list.Add(new ObjUpdateDto { field = "time_format", old_val = oldObj.time_format, new_val = newObj.time_format });
            if (!oldObj.number_format.Equals(newObj.number_format))
                list.Add(new ObjUpdateDto { field = "number_format", old_val = oldObj.number_format, new_val = newObj.number_format });
            if (!oldObj.is_primary_contact.Equals(newObj.is_primary_contact))
                list.Add(new ObjUpdateDto { field = "is_primary_contact", old_val = oldObj.is_primary_contact, new_val = newObj.is_primary_contact });
            if (!oldObj.bulk_email_optout_time.Equals(newObj.bulk_email_optout_time))
                list.Add(new ObjUpdateDto { field = "bulk_email_optout_time", old_val = oldObj.bulk_email_optout_time, new_val = newObj.bulk_email_optout_time });
            if (!oldObj.survey_optout_time.Equals(newObj.survey_optout_time))
                list.Add(new ObjUpdateDto { field = "survey_optout_time", old_val = oldObj.survey_optout_time, new_val = newObj.survey_optout_time });
            if (!oldObj.facebook_url.Equals(newObj.facebook_url))
                list.Add(new ObjUpdateDto { field = "facebook_url", old_val = oldObj.facebook_url, new_val = newObj.facebook_url });
            if (!oldObj.twitter_url.Equals(newObj.twitter_url))
                list.Add(new ObjUpdateDto { field = "twitter_url", old_val = oldObj.twitter_url, new_val = newObj.twitter_url });
            if (!oldObj.linkedin_url.Equals(newObj.linkedin_url))
                list.Add(new ObjUpdateDto { field = "linkedin_url", old_val = oldObj.linkedin_url, new_val = newObj.linkedin_url });
            if (!oldObj.qq.Equals(newObj.qq))
                list.Add(new ObjUpdateDto { field = "qq", old_val = oldObj.qq, new_val = newObj.qq });
            if (!oldObj.wechat.Equals(newObj.wechat))
                list.Add(new ObjUpdateDto { field = "wechat", old_val = oldObj.wechat, new_val = newObj.wechat });
            if (!oldObj.weibo_url.Equals(newObj.weibo_url))
                list.Add(new ObjUpdateDto { field = "weibo_url", old_val = oldObj.weibo_url, new_val = newObj.weibo_url });
            if (!oldObj.narrative_full_name.Equals(newObj.narrative_full_name))
                list.Add(new ObjUpdateDto { field = "narrative_full_name", old_val = oldObj.narrative_full_name, new_val = newObj.narrative_full_name });
            if (!oldObj.sorting_full_name.Equals(newObj.sorting_full_name))
                list.Add(new ObjUpdateDto { field = "sorting_full_name", old_val = oldObj.sorting_full_name, new_val = newObj.sorting_full_name });
            if (!oldObj.name_salutation_id.Equals(newObj.name_salutation_id))
                list.Add(new ObjUpdateDto { field = "name_salutation_id", old_val = oldObj.name_salutation_id, new_val = newObj.name_salutation_id });
            if (!oldObj.name_suffix_id.Equals(newObj.name_suffix_id))
                list.Add(new ObjUpdateDto { field = "name_suffix_id", old_val = oldObj.name_suffix_id, new_val = newObj.name_suffix_id });
            if (!oldObj.country_id.Equals(newObj.country_id))
                list.Add(new ObjUpdateDto { field = "country_id", old_val = oldObj.country_id, new_val = newObj.country_id });
            if (!oldObj.additional_address_information.Equals(newObj.additional_address_information))
                list.Add(new ObjUpdateDto { field = "additional_address_information", old_val = oldObj.additional_address_information, new_val = newObj.additional_address_information });
            if (!oldObj.phone_basic.Equals(newObj.phone_basic))
                list.Add(new ObjUpdateDto { field = "phone_basic", old_val = oldObj.phone_basic, new_val = newObj.phone_basic });
            if (!oldObj.alternate_phone1_basic.Equals(newObj.alternate_phone1_basic))
                list.Add(new ObjUpdateDto { field = "alternate_phone1_basic", old_val = oldObj.alternate_phone1_basic, new_val = newObj.alternate_phone1_basic });
            if (!oldObj.alternate_phone2_basic.Equals(newObj.alternate_phone2_basic))
                list.Add(new ObjUpdateDto { field = "alternate_phone2_basic", old_val = oldObj.alternate_phone2_basic, new_val = newObj.alternate_phone2_basic });
            if (!oldObj.cell_phone_basic.Equals(newObj.cell_phone_basic))
                list.Add(new ObjUpdateDto { field = "cell_phone_basic", old_val = oldObj.cell_phone_basic, new_val = newObj.cell_phone_basic });
            if (!oldObj.first_name.Equals(newObj.first_name))
                list.Add(new ObjUpdateDto { field = "first_name", old_val = oldObj.first_name, new_val = newObj.first_name });
            if (!oldObj.last_name.Equals(newObj.last_name))
                list.Add(new ObjUpdateDto { field = "last_name", old_val = oldObj.last_name, new_val = newObj.last_name });
            if (list.Count == 0)
                return "";
            return new Tools.Serialize().SerializeJson(list);
        }
    }
}
