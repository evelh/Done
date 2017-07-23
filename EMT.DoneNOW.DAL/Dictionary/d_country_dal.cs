using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class d_country_dal : BaseDAL<d_country>
    {
        /// <summary>
        /// 获取可用的国家列表
        /// </summary>
        /// <returns></returns>
        public List<d_country> GetCountryListActive()
        {
            var list = FindListBySql("SELECT * FROM d_country WHERE is_active=1");
            return list;
        }
    }
}
