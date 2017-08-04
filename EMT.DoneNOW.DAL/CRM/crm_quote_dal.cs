using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_quote_dal : BaseDAL<crm_quote>
    {

        /// <summary>
        /// 取到报价信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public crm_quote GetQuote(long id)
        {
            return FindSignleBySql<crm_quote>($"select * from crm_quote where id = {id} and delete_time=0");
        }

        /// <summary>
        /// 根据商机获取到相关报价
        /// </summary>
        /// <param name="opportunity_id"></param>
        /// <returns></returns>
        public List<crm_quote> GetQuoteByOpportunityId(long opportunity_id)
        {
            return FindListBySql<crm_quote>($"select * from crm_quote where opportunity_id = {opportunity_id} and delete_time=0");
        }
        /// <summary>
        /// 通过传过来的条件进行报价的查询，不传递参数代表查询所有报价
        /// </summary>
        /// <param name="where">查询参数</param>
        /// <returns></returns>
        public List<crm_quote> GetQuoteByWhere(string where ="")
        {
            if(where!="")
                return FindListBySql<crm_quote>($"select * from crm_quote where delete_time=0 "+where);
            return FindListBySql<crm_quote>($"select * from crm_quote where  delete_time=0 ");
        }

    }
}
