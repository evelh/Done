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
        public List<crm_contact> Find(ContactConditionDto condition, int pageNum, string orderby)
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
        /// 根据客户id查找到客户的所有联系人信息，按照姓名升序排列
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<crm_contact> GetContactByAccountId(long account_id)
        {
            string sql = $"select * from crm_contact where account_id={account_id}  and delete_time = 0 order by name ";
            return FindListBySql(sql);
        }
        /// <summary>
        /// 根据客户id和地址id获取到相对应的联系人信息
        /// </summary>
        /// <param name="account_id"></param>
        /// <param name="location_id"></param>
        /// <returns></returns>
        public List<crm_contact> GetContactByAccounAndLocationId(long account_id,long location_id)
        {
            string sql = $"select * from crm_contact where account_id={account_id} and location_id = {location_id}  and delete_time = 0";
            return FindListBySql(sql);
        }

  
    }
}
