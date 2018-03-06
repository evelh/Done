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
        /// <summary>
        /// 根据报价ID 获取到该报价下的所有报价项
        /// </summary>
        public List<crm_quote_item> GetAllQuoteItem(long quote_id,string where="")
        {
            string sql = $"SELECT * from crm_quote_item where quote_id = {quote_id} and delete_time = 0 "+where;
            return FindListBySql<crm_quote_item>(sql);
        }
        /// <summary>
        /// 根据报价项对象ID 获取相关报价项信息
        /// </summary>
        public List<crm_quote_item> GetItemByObjId(long objectId, string where = "")
        {
            string sql = $"SELECT * from crm_quote_item where object_id = {objectId} and delete_time = 0 " + where;
            return FindListBySql<crm_quote_item>(sql);
        }

        /// <summary>
        /// 获取到生成配置项的报价项(根据类型)  isExist 为not 代表未关联的配置项的报价项  为“” 代表关联配置项的报价项
        /// </summary>
        public List<crm_quote_item> GetConfigItem(long quote_id,long type_id,string isExist="")
        {
            return FindListBySql<crm_quote_item>($"SELECT cqi.* FROM crm_quote_item  cqi where {isExist}  EXISTS(SELECT 1 from crm_installed_product cip where cip.quote_item_id = cqi.id and cip.delete_time = 0) and  cqi.quote_id = {quote_id} and cqi.type_id = {type_id} and cqi.delete_time = 0");
        }

        /// <summary>
        /// 根据类型获取相应的报价项
        /// </summary>
        public List<crm_quote_item> GetItemByType(long quote_id,long type_id)
        {
            return FindListBySql<crm_quote_item>($"SELECT * from crm_quote_item where delete_time = 0 and quote_id = {quote_id} and type_id = {type_id}");
        }
        /// <summary>
        /// 获取多次 同一个报价项
        /// </summary>
        public List<crm_quote_item> GetItemByNum(long quote_item_id, long num)
        {
            return FindListBySql<crm_quote_item>($"select * from crm_quote_item a,(select 1 from d_general limit {num})b where id={quote_item_id} and delete_time = 0");
        }



    }
}
