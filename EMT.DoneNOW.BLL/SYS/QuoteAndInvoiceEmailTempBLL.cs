using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 报价和发票的邮件模板处理
    /// </summary>
   public class QuoteAndInvoiceEmailTempBLL
    {
        private readonly sys_quote_email_tmpl_dal _dal = new sys_quote_email_tmpl_dal();
        /// <summary>
        /// 设置下拉框显示变量
        /// </summary>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetVariableField(int cate)
        {
            if (cate == 1)
            {
                //还没有配置
                return new sys_quote_tmpl_dal().GetDictionary((int)GeneralTableEnum.NOTIFICATION_TEMPLATE_CATE_DATE_GROUP, (int)NOTIFY_CATE.QUOTE_TEMPLATE_OTHERS);
            }
            else if (cate == 2)
            {
                return new sys_quote_tmpl_dal().GetDictionary((int)GeneralTableEnum.NOTIFICATION_TEMPLATE_CATE_DATE_GROUP, (int)NOTIFY_CATE.QUOTE_TEMPLATE_OTHERS);
            }
            else {
                return null;
            }            
        }
        /// <summary>
        /// 获取所有可显示变量
        /// </summary>
        /// <returns></returns>
        public List<string> GetAllVariable()
        {
            return new sys_quote_tmpl_dal().GetAllVariable();
        }
    }
}
