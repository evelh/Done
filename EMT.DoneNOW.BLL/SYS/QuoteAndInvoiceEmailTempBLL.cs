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
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.PARAMS_ERROR;
            }
            tmpl.create_time = tmpl.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            tmpl.create_user_id = tmpl.update_user_id = user.id;
            _dal.Insert(tmpl);
            //日志
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_TEMP,
                oper_object_id = tmpl.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(tmpl),
                remark = "添加邮件模板"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 修改
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Update(sys_quote_email_tmpl tmpl, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.PARAMS_ERROR;
            }
            tmpl.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            tmpl.update_user_id = user.id;
            if (_dal.Update(tmpl)) {
                return ERROR_CODE.ERROR;
            }
            //日志
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_TEMP,
                oper_object_id = tmpl.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(_dal.FindNoDeleteById(tmpl.id), tmpl),
                remark = "修改邮件模板"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }
    }
}
