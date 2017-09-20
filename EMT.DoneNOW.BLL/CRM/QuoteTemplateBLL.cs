using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Text.RegularExpressions;


namespace EMT.DoneNOW.BLL
{
    public class QuoteTemplateBLL
    {
        private readonly sys_quote_tmpl_dal _dal = new sys_quote_tmpl_dal();
        #region 保存报价模板
        public ERROR_CODE Add(sys_quote_tmpl sqt, long user_id,out int id) {
            id=sqt.id = (int)(_dal.GetNextIdCom());
            sqt.update_user_id = sqt.create_user_id;
            sqt.create_time=sqt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            _dal.Insert(sqt);//把数据保存到数据库表
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;

            }
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_TEMP,     
                oper_object_id = sqt.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(sqt),
                remark = "新增报价模板"

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }
        #endregion

        #region 用于界面层下拉框的实现
        /// <summary>
        ///用于界面层下拉框的实现
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();

            dic.Add("DateFormat", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.DATE_DISPLAY_FORMAT)));              // 日期格式
            dic.Add("NumberFormat", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.NUMBER_DISPLAY_FORMAT)));              // 数字格式
            dic.Add("CurrencyPositivePattern", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.CURRENCY_POSITIVE_FORMAT )));              // 货币格式（正数）
            dic.Add("CurrencyNegativePattern", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.CURRENCY_NEGATIVE_FORMAT)));              // 货币格式（负数）
            dic.Add("Payment_terms", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_TERM)));              // 付款条件
            return dic;

        }
        #endregion
        /// <summary>
        /// 设置下拉框显示变量
        /// </summary>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetVariableField() {
            var list=_dal.GetDictionary((int)GeneralTableEnum.NOTIFICATION_TEMPLATE_CATE_DATE_GROUP, (int)NOTIFY_CATE.QUOTE_TEMPLATE_OTHERS);
            return list;
        }
        /// <summary>
        /// 设置body下拉框显示变量
        /// </summary>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetBodyVariableField()
        {
            var list = _dal.GetDictionary((int)GeneralTableEnum.NOTIFICATION_TEMPLATE_CATE_DATE_GROUP, (int)NOTIFY_CATE.QUOTE_TEMPLATE_BODY);
            return list;
        }

        /// <summary>
        /// 获取所有可显示变量
        /// </summary>
        /// <returns></returns>
        public List<string> GetAllVariable() {
            return _dal.GetAllVariable();
        }
        /// <summary>
        /// 获取对应
        /// </summary>
        /// <returns></returns>
        public List<string> GetVariable(int id)
        {
            return _dal.GetVariable(id);
        }
        #region 设为激活报价模板的逻辑处理

        public ERROR_CODE active_quote_template(long user_id, long id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.PARAMS_ERROR;
            }
            var temp=_dal.FindById(id);
            var old = temp;
            if (temp == null) {
                return ERROR_CODE.ERROR;
            }
            if (temp.is_active > 0) {
                return ERROR_CODE.ACTIVATION;
            }
            temp.is_active = 1;
            temp.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            temp.update_user_id = user_id;
            if (_dal.Update(temp) == false)
            {
                return ERROR_CODE.ERROR;
            }           
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_TEMP,
                oper_object_id = temp.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old,temp),
                remark = "修改报价模板"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }
        #endregion

        #region 设为失活活报价模板的逻辑处理

        public ERROR_CODE no_active_quote_template(long user_id, long id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.PARAMS_ERROR;
            }
            var sq = _dal.FindById(id);
            var old = sq;
            if (sq == null) {
                return ERROR_CODE.ERROR;
            }
            if (sq.is_active == 0) {
                return ERROR_CODE.NO_ACTIVATION;
            }
            sq.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            sq.update_user_id = user_id;
            if (_dal.Update(sq) == false)
            {
                return ERROR_CODE.ERROR;
            }
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_TEMP,
                oper_object_id = sq.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old,sq),
                remark = "修改报价模板"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }
        #endregion
        #region 设为默认报价模板的逻辑处理
        public ERROR_CODE default_quote_template(long user_id, long id) {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.PARAMS_ERROR;
            }
            var sq = _dal.FindById(id);
            var old = sq;
            if (sq == null)
            {
                return ERROR_CODE.ERROR;
            }
            if (sq.is_default == 1)
            {
                return ERROR_CODE.DEFAULT;
            }
            sys_quote_tmpl sqt = _dal.FindSignleBySql<sys_quote_tmpl>("select * from sys_quote_tmpl where is_default=1");
            if (sqt != null) {
                sqt.is_default = 0;
                sqt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                sqt.update_user_id = user_id;
                if (_dal.Update(sqt)==false) {
                    return ERROR_CODE.ERROR;
                }
            }
            sq.is_default = 1;
            sq.update_user_id = user_id;
            sq.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (_dal.Update(sq)==false) {
                return ERROR_CODE.ERROR;
            }
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_TEMP,
                oper_object_id = sq.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old,sq),
                remark = "修改报价模板"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }
        #endregion
        #region 报价模板删除的逻辑处理
        /// <summary>
        /// 报价模板的删除  
        /// </summary>
        /// 报价模板
        public ERROR_CODE quote_template_delete(long user_id,long id)
        {
            sys_quote_tmpl sqt = GetQuoteTemplate(id);
            if(sqt!=null) {
                if (sqt.is_system == 1 || sqt.is_custom == 1 || sqt.is_default == 1)
                {
                    return ERROR_CODE.ERROR;//以下模板不能删除：
                }
                else
                {
                    sqt.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    sqt.delete_user_id = id;
                    _dal.Update(sqt);


                    #region 添加日志
                    var user = UserInfoBLL.GetUserInfo(user_id);
                    if (user == null)
                    {
                        // 查询不到用户，用户丢失
                        return ERROR_CODE.USER_NOT_FIND;
                    }
                    var add_account_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = "",
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                       oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_TEMP,      
                        oper_object_id = sqt.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                        oper_description = _dal.AddValue(sqt),
                        remark = "删除报价模板"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add_account_log);       // 插入日志
                    #endregion
                    return ERROR_CODE.SUCCESS;
                }
            }
            return ERROR_CODE.ERROR;//获取数据失败，不能删除  
        }
        #endregion
        #region 返回一条记录
        /// <summary>
        /// 返回一条记录
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_quote_tmpl GetQuoteTemplate(long id)
        {
            string sql = $"select * from sys_quote_tmpl where id = {id} and delete_time = 0 ";
            return _dal.FindSignleBySql<sys_quote_tmpl>(sql);
        }
        #endregion
        /// <summary>
        /// 判断crm_quote表是否引用当前报价模板
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE is_quote(int id) {
            //var crm_quote = new crm_quote();
            string sql = $"select * from crm_quote where quote_tmpl_id = {id} and delete_time = 0";
            var crm_quote_dal = new crm_quote_dal();
            var templ=crm_quote_dal.FindSignleBySql<crm_quote>(sql);
            if (templ != null)
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        #region 报价模板编辑的更新保存操作
        public ERROR_CODE update(sys_quote_tmpl sqt, long user_id) {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;

            }
            var old = GetQuoteTemplate(sqt.id);
            sqt.update_user_id = user_id;
            sqt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
           if (!_dal.Update(sqt)) {
                return ERROR_CODE.ERROR;
            }

            //写个操作日志            
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_TEMP,//数据库缺少对应，报价模板
                oper_object_id = sqt.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old,sqt),
                remark = "更新报价模板"

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            return ERROR_CODE.SUCCESS;

        }
        #endregion
        public List<sys_quote_tmpl> GetAllTemplate()
        {
           // var list = _dal.FindListBySql("select id,name from sys_quote_tmpl");
            var list = _dal.FindAll().ToList<sys_quote_tmpl>();
            return list;
        }


        #region 复制一个报价模板
        public ERROR_CODE copy_quote_template(long user_id,ref long id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.PARAMS_ERROR;
            }
            var sq = _dal.FindById(id);
            if (sq == null)
            {
                return ERROR_CODE.ERROR;
            }
            sq.is_default = 0;
            id=sq.id= (int)(_dal.GetNextIdSys());
            sq.name = "(copy)" + sq.name;
            sq.create_time = sq.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            sq.create_user_id =sq.update_user_id=user_id;
            _dal.Insert(sq);
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_TEMP,
                oper_object_id = sq.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(sq),
                remark = "修改报价模板"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }
#endregion
        public sys_quote_tmpl GetSingelTemplate()
        {
            var syt = _dal.FindSignleBySql<sys_quote_tmpl>($"select * from sys_quote_tmpl where is_default=1");
            return syt;
        }
    }
}
