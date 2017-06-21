using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;

namespace EMT.DoneNOW.BLL
{
    public class CompanyBLL
    {
        private readonly crm_account_dal _dal = new crm_account_dal();
        
        /// <summary>
        /// 获取客户相关的列表字典项
        /// </summary>
        /// <returns></returns>
        public Dictionary<string,object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("company_type", new d_account_classification_dal().GetDictionary());    // 客户类型
            dic.Add("country", new d_country_dal().GetDictionary());                        // 国家表
            dic.Add("competition", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByRemark("competition")));          // 竞争对手
            dic.Add("market_segment", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByRemark("market_segment")));    // 行业
            dic.Add("district", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByRemark("district")));                // 行政区
            dic.Add("territory", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByRemark("territory")));              // 销售区域

            return dic;
        }

        /// <summary>
        /// 根据id查询客户
        /// </summary>
        /// <returns></returns>
        public crm_account GetCompany(long id)
        {
            return _dal.FindById(id);
        }

        /// <summary>
        /// 获取客户列表
        /// </summary>
        /// <returns></returns>
        public List<crm_account> GetList()
        {
            return _dal.FindAll() as List<crm_account>;
        }

        /// <summary>
        /// 新增客户
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Insert(JObject param)
        {
            crm_account account = param.SelectToken("account").ToObject<crm_account>();
            if (_dal.ExistAccountName(account.account_name))
                return ERROR_CODE.CRM_ACCOUNT_NAME_EXIST;

            crm_account_note note = param.SelectToken("note").ToObject<crm_account_note>();
            crm_account_todo todo = param.SelectToken("todo").ToObject<crm_account_todo>();
            
            account.id = _dal.GetNextId();
            account.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            account.create_user_id = CachedInfoBLL.GetUserInfo("").id;
            _dal.Insert(account);
            if (_dal.FindById(account.id) != null)
            {
                if (note != null)
                {
                    note.account_id = account.id;
                    new crm_account_note_dal().Insert(note);
                }
                if (todo != null)
                {
                    todo.account_id = account.id;
                    new crm_account_todo_dal().Insert(todo);
                }
                return ERROR_CODE.SUCCESS;
            }
            else
                return ERROR_CODE.CRM_ACCOUNT_NAME_EXIST;
        }

        /// <summary>
        /// 更新客户信息
        /// </summary>
        /// <returns></returns>
        public bool Update(crm_account account)
        {
            if (ExistCompany(account.account_name))
                return false;
            return _dal.Update(account);
        }

        /// <summary>
        /// 按条件查询客户列表
        /// </summary>
        /// <returns></returns>
        public List<crm_account> FindList(JObject jsondata)
        {
            CompanyConditionDto condition = jsondata.ToObject<CompanyConditionDto>();
            string orderby = ((JValue)(jsondata.SelectToken("orderby"))).Value.ToString();
            string page = ((JValue)(jsondata.SelectToken("page"))).Value.ToString();
            int pagenum;
            if (!int.TryParse(page, out pagenum))
                pagenum = 1;
            return _dal.Find(condition, pagenum, orderby);
        }

        /// <summary>
        /// 删除客户
        /// </summary>
        /// <returns></returns>
        public bool DeleteCompany(long id)
        {
            return _dal.SoftDelete(GetCompany(id));
        }

        /// <summary>
        /// 查询客户名是否存在
        /// </summary>
        /// <returns></returns>
        public bool ExistCompany(string accountName)
        {
            return _dal.ExistAccountName(accountName);
        }
    }
}
