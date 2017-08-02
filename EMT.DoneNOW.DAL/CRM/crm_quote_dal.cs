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

    }
}
