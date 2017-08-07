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

        public List<crm_contact> GetContactByStatus(long account_id,int is_active)
        {
            string sql = $"SELECT * FROM crm_contact WHERE account_id='{account_id}' and delete_time = 0  ";
            string where = "";
            switch (is_active)
            {
                case 0:
                    where += " and is_active = 0 ";
                    break;
                case 1:
                    where += " and is_active = 1 ";
                    break;
                default:
                    break;
            }

            return FindListBySql(sql+where);
        }

        /// <summary>
        /// 根据客户ID去获取到这个客户的主要联系人
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public crm_contact GetPrimaryContactByAccountId(long account_id)
        {
            string sql = $"select * from crm_contact where account_id = {account_id} and is_primary_contact = 1 AND delete_time = 0";
            return FindSignleBySql<crm_contact>(sql);
        }

        /// <summary>
        /// 通过联系人姓名和客户ID获取联系人信息,修改操作验证时排除自己
        /// </summary>
        /// <param name="account_id"></param>
        /// <param name="contact_name"></param>
        /// <returns></returns>
        public List<crm_contact> GetContactByName(long account_id,string contact_name ,long contact_id = 0 )
        {
            string sql = $"select * from crm_contact where account_id = {account_id} and name = '{contact_name}' and delete_time = 0";
            if (contact_id != 0)
                sql += $" and id <> '{contact_id}' ";
            return FindListBySql(sql);
        }

        /// <summary>
        /// 验证手机是否已经被别的联系人使用,修改操作验证时排除自己
        /// </summary>
        /// <param name="mobile_phone"></param>
        /// <returns></returns>
        public List<crm_contact> GetContactByPhone(string mobile_phone,long contact_id = 0)
        {
            string sql = $"select * from crm_contact where mobile_phone = '{mobile_phone}' and delete_time = 0";
            if (contact_id != 0)
                sql += $" and id <> '{contact_id}' ";
            return FindListBySql(sql);
        }

        /// <summary>
        /// 通过联系人的引用的地址去获取到所有引用这个地址的联系人
        /// </summary>
        /// <param name="location_id"></param>
        /// <returns></returns>
        public List<crm_contact> GetContectByLocation(long location_id)
        {
            string sql = $"select * from crm_contact where location_id = {location_id} and delete_time = 0";
            return FindListBySql(sql);
        }

        /// <summary>
        /// 通过多个id去获取相对应的联系人信息
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        public List<crm_contact> GetContactByIds(string ids)
        {
            return FindListBySql($"select * from crm_contact where id in ({ids}) and delete_time = 0 ");
        }
        public bool ExistContactMobilePhone(string mobile, long id = 0)
        {
            string sql = $"SELECT count(0) from crm_contact where delete_time = 0 AND  mobile_phone = '{mobile}' ";
            if (id != 0)
                sql += $" and id <> {id}";
            object obj = GetSingle(sql);
            int cnt = -1;
            if (int.TryParse(obj.ToString(), out cnt))
            {
                if (cnt > 0)
                    return true;
            }
            return false;
        }
    }
}
