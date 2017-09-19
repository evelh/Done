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
        public bool ExistAccountName(string accountName,long account_id = 0)
        {
            string sql = $"SELECT COUNT(0) FROM crm_account WHERE name='{accountName}' and delete_time = 0 ";
            if (account_id != 0)
                sql += $" and id <> {account_id} ";
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
        /// 根据客户名称获取客户信息
        /// </summary>
        /// <param name="accountName">客户名称</param>
        /// <returns></returns>
        public crm_account GetAccountByName(string accountName)
        {           
            return FindSignleBySql<crm_account>($"select * from crm_account WHERE name='{accountName}' and delete_time = 0");
        }

        /// <summary>
        /// 根据客户ID去获取到所有的子公司信息
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<crm_account> GetSubsidiariesById(long account_id)
        {
            return FindListBySql<crm_account>($"select * from crm_account WHERE parent_id='{account_id}' and delete_time = 0");
        }
        /// <summary>
        /// 判断电话是否已经有客户在使用
        /// </summary>
        /// <param name="phone"></param>
        /// <returns></returns>
        public bool ExistAccountPhone(string phone,long id=0)
        {
            string sql = $"SELECT count(0) from crm_account where delete_time = 0 AND  phone = '{phone}' ";
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



        public List<crm_account> GetAccountByFindBack(long? id)
        {
            if (id == null)
                return FindListBySql("select id,name from crm_account where delete_time = 0");
            return FindListBySql($"select id,name from crm_account where delete_time = 0  and id <> {id}");
        }

        /// <summary>
        /// 获取所有未删除的公司
        /// </summary>
        /// <returns></returns>
        public List<crm_account> GetAllCompany()
        {
            return FindListBySql("select * from crm_account where delete_time = 0 ");
        }

        /// <summary>
        /// 根据多个id返回客户list
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        public List<crm_account> GetCompanyByIds(string ids)
        {
            return FindListBySql($"select * from crm_account where id in ({ids}) and delete_time = 0  ");
        }
        /// <summary>
        /// 获取没有父客户的客户
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        public List<crm_account> GetSubCompanys(long id=0)
        {
            if(id==0)
                return FindListBySql($"SELECT * from crm_account where id not in(SELECT a.id from crm_account a ,crm_account a2 where a.id = a2.parent_id) and id not in (SELECT id from crm_account where parent_id is not null) and delete_time=0");
            else
                return FindListBySql($"SELECT * from crm_account where id not in(SELECT a.id from crm_account a ,crm_account a2 where a.id = a2.parent_id) and id not in (SELECT id from crm_account where parent_id is not null) and delete_time=0 and id <> {id}");
        }

        public List<crm_account> GetMyCompany(long id)
        {
            return FindListBySql($"select * from crm_account where parent_id={id} and delete_time = 0 ");
        }
    }
}
