using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using Newtonsoft.Json.Linq;

namespace EMT.DoneNOW.DAL
{
    public class crm_account_dal : BaseDAL<crm_account>
    {
        /// <summary>
        /// 根据id查找
        /// </summary>
        /// <returns></returns>
        public crm_account FindById(long id)
        {
            return FindSignleBySql<crm_account>("SELECT * FROM crm_account WHERE id=" + id);
        }

        /// <summary>
        /// 根据条件查找
        /// </summary>
        /// <returns></returns>
        public List<crm_account> Find(JObject jsondata)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("");
            
            return null;
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
    }
}
