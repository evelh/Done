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
        /// 获取邮件模板
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_quote_email_tmpl GetEmailTemp(long id) {
            return _dal.FindNoDeleteById(id);
        }
        /// <summary>
        /// 设置下拉框显示变量
        /// </summary>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetVariableField(int cate)
        {
            if (cate == 1)
            {
                //还没有配置10-13
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
        public List<string> GetAllVariable(int cate)
        {
            //还没有配置10-13
            if (cate == 1)
            {
                return new sys_quote_tmpl_dal().GetAllVariable();
            }
            else if (cate == 2)
            {
                return new sys_quote_tmpl_dal().GetAllVariable();
            }
            else {
                return null;
            }            
        }
        /// <summary>
        /// 新增
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Insert(sys_quote_email_tmpl tmpl,long user_id) {
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 修改
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Update(sys_quote_email_tmpl tmpl, long user_id)
        {
            return ERROR_CODE.SUCCESS;
        }
    }
}
