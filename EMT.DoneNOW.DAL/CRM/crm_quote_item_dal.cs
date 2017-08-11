﻿using System;
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
    }
}