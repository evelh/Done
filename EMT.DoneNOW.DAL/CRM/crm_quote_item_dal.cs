using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_quote_item_dal : BaseDAL<crm_quote_item>
    {
        /// <summary>
        /// 获取到报价项
        /// </summary>
        /// <param name="id"></param>
        /// <param name="where"></param>
        /// <returns></returns>
        public crm_quote_item GetQuoteItem(long id,string where ="")
        {
            if (where == "")
                return FindSignleBySql<crm_quote_item>($"select * from crm_quote_item where id = {id} and delete_time = 0");
            else
                return FindSignleBySql<crm_quote_item>($"select * from crm_quote_item where id = {id} and delete_time = 0 "+where);
        }

        public List<crm_quote_item> GetQuoteItems(string where="")
        {
            if (where == "")
                return FindListBySql<crm_quote_item>($"select * from crm_quote_item where  delete_time = 0 ");
            else
                return FindListBySql<crm_quote_item>($"select * from crm_quote_item where  delete_time = 0 " + where);
        }
        /// <summary>
        /// 根据报价项id获取到该报价下的所有报价项
        /// </summary>
        /// <param name="item_id"></param>
        /// <returns></returns>
        public List<crm_quote_item> GetItemsByItemID(long item_id)
        {
            return FindListBySql<crm_quote_item>($"SELECT * from crm_quote_item where quote_id = (select quote_id from crm_quote_item where id={item_id} and delete_time = 0 )");
        }

        /// <summary>
        /// 根据报价ID获取改报价下的初始费用报价项
        /// </summary>
        public crm_quote_item GetStartItem(long quote_id)
        {
            return FindSignleBySql<crm_quote_item>($"SELECT * from crm_quote_item where quote_id = {quote_id} and type_id = {(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.START_COST} and delete_time = 0");
        }

    }
}
