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
    public class CompanyBLL
    {
        private readonly crm_account_dal _dal = new crm_account_dal();

        /// <summary>
        /// 获取客户相关的列表字典项
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("company_type", new d_account_classification_dal().GetDictionary());    // 客户类型
            dic.Add("country", new d_country_dal().GetDictionary());                        // 国家表
            dic.Add("competition", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("竞争对手")));          // 竞争对手
            dic.Add("market_segment", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("行业")));    // 行业
            dic.Add("district", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("行政区")));                // 行政区
            dic.Add("territory", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("销售区")));              // 销售区域

            return dic;
        }

        /// <summary>
        /// 根据id查询客户
        /// </summary>
        /// <returns></returns>
        public crm_account GetCompany(long id)
        {
            return _dal.FindById(id);
        }

        /// <summary>
        /// 获取客户列表
        /// </summary>
        /// <returns></returns>
        public List<crm_account> GetList()
        {
            return _dal.FindAll() as List<crm_account>;
        }

        /// <summary>
        /// 新增客户
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Insert(CompanyAddDto param, string token)
        {
            if (string.IsNullOrEmpty(param.general.company_name) || string.IsNullOrEmpty(param.general.phone))  // 必填项校验
                return ERROR_CODE.PARAMS_ERROR;       // 返回参数丢失
            if (_dal.ExistAccountName(param.general.company_name))    // 唯一性校验
                return ERROR_CODE.CRM_ACCOUNT_NAME_EXIST;   // 返回客户名已存在
            // TODO  名称相似校验

            //var user = CachedInfoBLL.GetUserInfo(token);   // 根据token获取到用户信息
            // 测试用户
            var user = new UserInfoDto()
            {
                id = 1,
                email = "1zhufei@test.com",
                mobile = "10086",
                name = "zhufei_test",
                security_Level_id = 0
            };
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;           // 查询不到用户，用户丢失

            #region 1.保存客户
            crm_account _account = new crm_account()
            {
                id = _dal.GetNextIdCom(),
                account_id = _dal.GetNextIdCom(), // todo account_id 与 id 的区别 
                // external_id = "",   //   外部关联用ID【预留】  
                create_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                no = param.general.company_number,
                parent_id =param.general.parent_company_name,  // todo 上级客户， 传进来父客户id，不是名字？？？
                territory_id = param.general.territory_name,
                market_segment_id = param.general.market_segment,
                competitor_id = param.general.competitor,
                name = param.general.company_name,
                is_active = 1,                         // 0未激活 1 激活
                //is_taxable = param.general.tax_exempt ? 1 : 0,// 是否免税 0 否 1 是
                phone = param.general.phone,
                fax = param.general.fax,
                web_site = param.general.web_site,
                alternate_phone1 = param.general.alternate_phone1,
                alternate_phone2 = param.general.alternate_phone2,
                last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                type_id = param.general.company_type,
                classification_id = param.general.classification,
                tax_region_id = param.general.tax_region,
                tax_identification = param.general.tax_id,
                resource_id = param.general.account_manage,
            };  //  创建客户实体类
            _dal.Insert(_account);                         // 将客户实体插入到表中

            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                oper_object_id = _account.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(_account),
                remark = ""

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志
            #endregion


            #region 6.保存地址信息
            crm_location _location = new crm_location()
            {
                id = _dal.GetNextIdCom(),
                account_id = _account.id,
                address = param.location.address,
                district_id = param.location.district_id,
                city_id = param.location.city_id,
                provice_id = param.location.provice_id,
                postal_code = param.location.postal_code,
                country_id = param.location.country_id,
                additional_address = param.location.additional_address,
                is_default = 1,  // 是否默认
                create_user_id = user.id,
                update_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            };
            new crm_location_dal().Insert(_location);
            sys_oper_log add_location_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                oper_object_id = _location.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(_location),
                remark = ""
            };
            new sys_oper_log_dal().Insert(add_location_log);       // 插入日志
            #endregion

            #region 2.保存联系人
            // 联系人的姓和名只输入一个时，不创建联系人  
            // 联系人相关信息的修改不影响客户上相关字段 
            crm_contact _contact = null;
            if (!string.IsNullOrEmpty(param.contact.first_name)) // 联系人填写了姓
            {
                _contact = new crm_contact()
                {
                    id = _dal.GetNextIdCom(),
                    account_id = _account.id,
                    is_primary_contact = 1, // 主联系人 0不是 1是
                    create_user_id = user.id,
                    update_user_id = user.id,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    fax = _account.fax,
                    alternate_phone1 = _account.alternate_phone1,
                    alternate_phone2 = _account.alternate_phone2,
                    mobile_phone = param.contact.mobile_phone,
                    suffix_id = param.contact.sufix,
                    title = param.contact.title,
                    first_name = param.contact.first_name,
                    last_name = param.contact.last_name == null ? "" : param.contact.last_name,
                    name = param.contact.first_name + param.contact.last_name,
                    email = param.contact.email,
                   location_id = _location.id,
                };
                new crm_contact_dal().Insert(_contact);
                var add_contact_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = "",
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                    oper_object_id = _contact.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(_contact),
                    remark = ""
                };          // 创建日志
                new sys_oper_log_dal().Insert(add_contact_log);       // 插入日志
            }

            #endregion

            #region 3.保存客户扩展信息
            //new UserDefinedFieldsBLL().SaveUdfValue();
            var udf_account_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.COMPANY);  // 获取到所有关于客户的自定义字段
            var udf_general_list = param.general.udf;
            if (new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.COMPANY, _account.id, udf_account_list, udf_general_list)) // 保存自定义字段，保存成功，插入日志
            {
                var add_accout_udf_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = "",
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                    oper_object_id = _account.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(new Tools.Serialize().SerializeJson(udf_general_list)),
                    remark = ""

                };          // 创建日志
                new sys_oper_log_dal().Insert(add_accout_udf_log);       // 插入日志
            }
            #endregion

            #region 4.保存联系人扩展信息
            if (!string.IsNullOrEmpty(param.contact.first_name))  // 判断
            {
                var udf_contact_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTACT); // 联系人的自定义字段
                var udf_con_list = param.contact.udf;     // 传过来的联系人的自定义参数
                if (new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.CONTACT, _contact.id, udf_contact_list, udf_con_list))
                {
                    var add_contact_udf_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = "",
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                        oper_object_id = _contact.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(new Tools.Serialize().SerializeJson(udf_con_list)),
                        remark = ""

                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add_contact_udf_log);       // 插入日志
                }
            }
            #endregion

            #region 5.保存客户站点信息
            var udf_site_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.SITE);
            var udf_site = param.site.udf;
            if (new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.SITE, _account.id, udf_site_list, udf_site))
            {
                sys_oper_log add_site_udf_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = "",
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                    oper_object_id = _account.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(new Tools.Serialize().SerializeJson(udf_site)),
                    remark = ""

                };          // 创建日志
                new sys_oper_log_dal().Insert(add_site_udf_log);       // 插入日志
            }

            #endregion

         

            #region 7.保存记录信息
            if (param.note.action_type != 0)
            {
                if (param.note.end_time != null && param.note.start_time != null && !string.IsNullOrEmpty(param.note.description))
                {
                    // 进行非空校验之后，创建备注对象，并将日志插入表中 
                    com_note _note = new com_note()
                    {
                        id = _dal.GetNextIdCom(),
                        account_id = _account.id,
                        // contact_id = _contact == null ? 0 : _contact.id,
                        object_id = _account.id,
                        object_type_id = (int)OBJECT_TYPE.CUSTOMER,
                        action_type_id = param.note.action_type,
                        start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(param.note.start_time),
                        end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(param.note.end_time),
                        description = param.note.description,
                        create_user_id = user.id,
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_user_id = user.id,
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        delete_time = 0,
                    };
                    new com_note_dal().Insert(_note);
                    sys_oper_log add_note_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = "",
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                        oper_object_id = _note.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(_note),
                        remark = ""

                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add_note_log);       // 插入日志
                }

            }

            #endregion

            #region 8.保存待办信息
            if (param.todo.action_type != 0)
            {
                if (param.todo.assigned_to != 0 && param.todo.start_time != null && param.todo.end_time != null && !string.IsNullOrEmpty(param.todo.description))
                {
                    com_todo _todo = new com_todo()
                    {
                        id = _dal.GetNextIdCom(),
                        account_id = _account.id,
                        //contact_id = _contact == null ? 0 : _contact.id,
                        resource_id = user.id,  // 负责人 id
                        action_type_id = param.todo.action_type,
                        object_id = _account.id,
                        object_type_id = (int)OBJECT_TYPE.CUSTOMER,
                        start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(param.todo.start_time),
                        end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(param.todo.end_time),
                        description = param.todo.description,
                        create_user_id = user.id,
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_user_id = user.id,
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        delete_time = 0,
                    };
                    new com_todo_dal().Insert(_todo);
                    var add_todo_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = "",
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                        oper_object_id = _todo.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(_todo),
                        remark = ""
                    };
                    new sys_oper_log_dal().Insert(add_todo_log);
                }
            }
            #endregion




            // crm_account account = param.SelectToken("account").ToObject<crm_account>();
            //if (_dal.ExistAccountName(account.account_name))
            //    return ERROR_CODE.CRM_ACCOUNT_NAME_EXIST;

            //crm_contact contact = param.SelectToken("contact").ToObject<crm_contact>();
            //crm_account_note note = param.SelectToken("note").ToObject<crm_account_note>();
            //crm_account_todo todo = param.SelectToken("todo").ToObject<crm_account_todo>();

            //account.id = _dal.GetNextIdCom();
            //account.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //account.create_user_id = CachedInfoBLL.GetUserInfo(token).id;
            //account.update_time = account.create_time;
            //account.update_user_id = account.update_user_id;
            //_dal.Insert(account);

            //if (contact != null)    // 增加联系人
            //{
            //    contact.account_id = account.id;
            //    contact.id = _dal.GetNextIdCom();
            //    contact.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //    contact.create_user_id = account.create_user_id;
            //    contact.update_time = contact.create_time;
            //    contact.update_user_id = contact.create_user_id;
            //    // TODO: 主联系人设置
            //    new crm_contact_dal().Insert(contact);  // TODO:
            //}
            //// TODO: 客户和联系人自定义字段

            //// TODO: 日志
            //if (_dal.FindById(account.id) != null)
            //{
            //    if (note != null)
            //    {
            //        note.account_id = account.id;
            //        new crm_account_note_dal().Insert(note);    // TODO:
            //    }
            //    if (todo != null)
            //    {
            //        todo.account_id = account.id;
            //        new crm_account_todo_dal().Insert(todo);    // TODO:
            //    }
            //    return ERROR_CODE.SUCCESS;
            //}
            //else
            return ERROR_CODE.CRM_ACCOUNT_NAME_EXIST;
        }

        /// <summary>
        /// 更新客户信息
        /// </summary>
        /// <returns></returns>
        public bool Update(CompanyUpdateDto param, string token)
        {
            // Dictionary<bool,List<crm_contact>>
            // Dictionary<bool, List<crm_contact>> dic = new Dictionary<bool, List<crm_contact>>();
            // 对必填的字段进行非空验证
            if (string.IsNullOrEmpty(param.general_update.company_name) || string.IsNullOrEmpty(param.general_update.phone) || string.IsNullOrEmpty(param.general_update.address))
            {
                //dic.Add(false, null);
                //return dic;
                return false;
            }
            if (param.general_update.country_id == 0 || param.general_update.provice_id == 0 || param.general_update.city_id == 0 || param.general_update.company_type == 0 || param.general_update.account_manage == 0)
            {
                return false;
            }
            //var user = CachedInfoBLL.GetUserInfo(token);   // 根据token获取到用户信息
            var user = new UserInfoDto()
            {
                id = 1,
                email = "zhufei@test.com",
                mobile = "10086",
                name = "zhufei_test",
                security_Level_id = 0
            };

            #region 1.保存客户
            crm_account old_company_value  =GetCompany(param.general_update.id);
            // crm_account old_company_value = _dal.GetCompany(param.general_update.company_name); // 

            if (old_company_value == null) // 并发操作时已经将客户删除的情况
            {
                return false;
            }
            crm_account new_company_value = new crm_account()
            {
                id = old_company_value.id,
                account_id = old_company_value.account_id,
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                name = param.general_update.company_name,
                no = param.general_update.company_number,
                territory_id = param.general_update.territory_name,
                market_segment_id = param.general_update.market_segment,
                competitor_id = param.general_update.competitor,
                is_active = param.general_update.is_active,
                phone = param.general_update.phone,
                fax = param.general_update.fax,
                web_site = param.general_update.web_site,
                alternate_phone1 = param.general_update.alternate_phone1,
                alternate_phone2 = param.general_update.alternate_phone2,
                last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                parent_id = param.general_update.parent_company_name,
                type_id = param.general_update.company_type,
                classification_id = param.general_update.classification,
                tax_region_id = param.general_update.tax_region,
                tax_identification = param.general_update.tax_id,
                resource_id = param.general_update.account_manage,
                is_optout_survey = param.general_update.is_optout_survey,
                mileage = param.general_update.mileage,
                stock_symbol = param.additional_info.stock_symbol,
                stock_market = param.additional_info.stock_market,
                sic_code = param.additional_info.sic_code,
                asset_value = param.additional_info.asset_value,
                weibo_url = param.additional_info.weibo_url,
                wechat_mp_subscription = param.additional_info.wechat_mp_subscription,
                wechat_mp_service = param.additional_info.wechat_mp_service,
                create_user_id = old_company_value.create_user_id,
                create_time = old_company_value .create_time,
               
            };
            if (_dal.Update(new_company_value)) // 如果修改成功，则添加日志
            {
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                    oper_object_id = new_company_value.id,
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.CompareValue(old_company_value, new_company_value),
                    remark = "修改客户信息",
                });
            } // crm_account 更新数据结束

            #endregion
            #region 2.保存客户扩展信息 
            var udf_account_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.COMPANY);  // 获取到所有的自定义的字段信息
            if (udf_account_list != null && udf_account_list.Count > 0)   // 首先判断客户是否设置自定义字段
            {
                var udf_account = param.general_update.udf;  // 获取到客户传过来的自定义字段的值
                // UpdateUdfValue 中含有插入修改日志的操作，无需再插入日志
                new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.COMPANY, udf_account_list, new_company_value.id, udf_account, user.id, user.mobile);
            }
            #endregion
            #region 3.保存客户站点信息  TODO-TEST
            var udf_site_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.SITE);
            if (udf_site_list != null && udf_site_list.Count > 0)
            {
                var udf_site = param.site_configuration.udf;
                // UpdateUdfValue 中含有插入修改日志的操作，无需再插入日志
                new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.SITE, udf_site_list, new_company_value.id, udf_site, user.id, user.mobile);
            }

            #endregion
            #region 4.保存客户提醒信息
            var alert_site = new crm_account_alert_dal().FindByAccount(new_company_value.id);  // 从crm_account_alert表中获取到用户的所有提醒信息
            if (!string.IsNullOrEmpty(param.alerts.Company_Detail_Alert))
            {
                if (alert_site.Any(_ => _.alert_type_id == (int)ACCOUNT_ALERT_TYPE.COMPANY_DETAIL_ALERT)) // 存在，则更改，不存在，则插入
                {
                    var old_company_detail_alert = alert_site.FirstOrDefault(_ => _.alert_type_id == (int)ACCOUNT_ALERT_TYPE.COMPANY_DETAIL_ALERT); // 存在 ，获取到原有的提醒
                    crm_account_alert new_company_detail_alert = new crm_account_alert()                                                                // 创建新的提醒
                    {
                        account_id = new_company_value.id,
                        id = old_company_detail_alert.id,
                        alert_type_id = (int)ACCOUNT_ALERT_TYPE.COMPANY_DETAIL_ALERT,
                        alert_text = param.alerts.Company_Detail_Alert,
                        update_user_id = user.id,
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        create_time = old_company_detail_alert.create_time,
                        create_user_id = old_company_detail_alert.create_user_id,
                    };
                    if (new crm_account_alert_dal().Update(new_company_detail_alert))
                    {
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                            oper_object_id = new_company_detail_alert.id,
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.CompareValue(old_company_detail_alert, new_company_detail_alert),
                            remark = "修改客户信息提醒",
                        });
                    }
                }
                else
                {
                    crm_account_alert company_detail_alert = new crm_account_alert()                                                                // 创建新的提醒
                    {
                        account_id = new_company_value.id,
                        id = _dal.GetNextIdCom(),
                        alert_type_id = (int)ACCOUNT_ALERT_TYPE.COMPANY_DETAIL_ALERT,
                        alert_text = param.alerts.Company_Detail_Alert,
                        update_user_id = user.id,
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        create_user_id = user.id,
                        delete_time = 0,
                        delete_user_id = 0,
                    };
                    new crm_account_alert_dal().Insert(company_detail_alert);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                        oper_object_id = new_company_value.id,
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(company_detail_alert),
                        remark = "新增客户信息提醒",
                    });
                }
            }
            if (!string.IsNullOrEmpty(param.alerts.New_Ticket_Alert))
            {
                if (alert_site.Any(_ => _.alert_type_id == (int)ACCOUNT_ALERT_TYPE.NEW_TICKET_ALERT)) // 存在，则更改，不存在，则插入
                {
                    var old_new_ticket_alert = alert_site.FirstOrDefault(_ => _.alert_type_id == (int)ACCOUNT_ALERT_TYPE.NEW_TICKET_ALERT); // 存在 ，获取到原有的提醒
                    crm_account_alert new_new_ticket_alert = new crm_account_alert()                                                                // 创建新的提醒
                    {
                        account_id = new_company_value.id,
                        id = old_new_ticket_alert.id,
                        alert_type_id = (int)ACCOUNT_ALERT_TYPE.NEW_TICKET_ALERT,
                        alert_text = param.alerts.New_Ticket_Alert,
                        update_user_id = user.id,
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        create_time = old_new_ticket_alert.create_time,
                        create_user_id = old_new_ticket_alert.create_user_id,
                    };
                    if (new crm_account_alert_dal().Update(new_new_ticket_alert))
                    {
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                            oper_object_id = new_new_ticket_alert.id,
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.CompareValue(old_new_ticket_alert, new_new_ticket_alert),
                            remark = "修改工单新建提醒",
                        });
                    }
                }
                else
                {
                    crm_account_alert new_ticket_alert = new crm_account_alert()                                                                // 创建新的提醒
                    {
                        account_id = new_company_value.id,
                        id = _dal.GetNextIdCom(),
                        alert_type_id = (int)ACCOUNT_ALERT_TYPE.NEW_TICKET_ALERT,
                        alert_text = param.alerts.New_Ticket_Alert,
                        update_user_id = user.id,
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        create_user_id = user.id,
                        delete_time = 0,
                        delete_user_id = 0,
                    };
                    new crm_account_alert_dal().Insert(new_ticket_alert);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                        oper_object_id = new_ticket_alert.id,
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(new_ticket_alert),
                        remark = "新增工单新建提醒",
                    });
                }
            }
            if (!string.IsNullOrEmpty(param.alerts.Ticket_Detail_Alert))
            {
                if (alert_site.Any(_ => _.alert_type_id == (int)ACCOUNT_ALERT_TYPE.TICKET_DETAIL_ALERT)) // 存在，则更改，不存在，则插入
                {
                    var old_ticket_detail_alert = alert_site.FirstOrDefault(_ => _.alert_type_id == (int)ACCOUNT_ALERT_TYPE.TICKET_DETAIL_ALERT); // 存在 ，获取到原有的提醒
                    crm_account_alert new_ticket_detail_alert = new crm_account_alert()                                                                // 创建新的提醒
                    {
                        account_id = new_company_value.id,
                        id = old_ticket_detail_alert.id,
                        alert_type_id = (int)ACCOUNT_ALERT_TYPE.TICKET_DETAIL_ALERT,
                        alert_text = param.alerts.Ticket_Detail_Alert,
                        update_user_id = user.id,
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        create_time = old_ticket_detail_alert.create_time,
                        create_user_id = old_ticket_detail_alert.create_user_id,
                    };
                    if (new crm_account_alert_dal().Update(new_ticket_detail_alert))
                    {
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                            oper_object_id = new_ticket_detail_alert.id,
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.CompareValue(old_ticket_detail_alert, new_ticket_detail_alert),
                            remark = "修改工单信息提醒",
                        });
                    }
                }
                else
                {
                    crm_account_alert ticket_detail_alert = new crm_account_alert()                                                                // 创建新的提醒
                    {
                        account_id = new_company_value.id,
                        id = _dal.GetNextIdCom(),
                        alert_type_id = (int)ACCOUNT_ALERT_TYPE.TICKET_DETAIL_ALERT,
                        alert_text = param.alerts.Ticket_Detail_Alert,
                        update_user_id = user.id,
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        create_user_id = user.id,
                        delete_time = 0,
                        delete_user_id = 0,
                    };
                    new crm_account_alert_dal().Insert(ticket_detail_alert);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                        oper_object_id = ticket_detail_alert.id,
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(ticket_detail_alert),
                        remark = "新增工单信息提醒",
                    });
                }
            }
            #endregion



            #region 保存客户地址信息
            crm_location old_location = new crm_location_dal().GetLocationByAccountId(old_company_value.id);  // 根据客户id去获取到客户的地址，然后判断地址是否修改
            crm_location new_location = new crm_location()   
            {
                id=old_location.id,
                account_id = old_location.account_id,
                address = param.general_update.address,
                city_id = param.general_update.city_id,
                country_id = param.general_update.country_id,
                provice_id = param.general_update.provice_id,
                district_id = param.general_update.district_id,
                additional_address = param.general_update.additional_address,
                is_default = param.general_update.is_default ,
                create_user_id = old_location.create_user_id,
                create_time = old_location.create_time,
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                postal_code  = param.general_update.postal_code,
                cate_id = old_location.cate_id,
                delete_time = old_location.delete_time,
                delete_user_id = old_location.delete_user_id,
                location_label = old_location.location_label,
                town_id = old_location.town_id,
            };   // 生成新的地址的实体类
            
            if(new_location.is_default == (sbyte)1)   // 代表用户将这个地址设置为默认地址
            {
                new crm_location_dal().UpdateDefaultLocation(new_company_value.id,user); // 首先将原来的默认地址取消   是否插入日志
                new crm_location_dal().Update(new_location);             // 更改地址信息
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                    oper_object_id = new_location.id,
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.CompareValue(old_location, new_location),
                    remark = "修改客户地址",
                });    // 插入更改日志
            }
            else
            {
                new crm_location_dal().Update(new_location);             // 更改地址信息
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                    oper_object_id = new_location.id,
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.CompareValue(old_location, new_location),
                    remark = "修改客户地址",
                });    // 插入更改日志
            }
          
            #endregion
            if (new_location.Equals(old_location))      // 如果修改了地址，该地被其他联系人引用，则弹出窗口，提示用户会同步修改的联系人 TODO-- 如何提示
            {
                var contactAllList = new crm_contact_dal().GetContactByAccounAndLocationId(new_company_value.id,old_location.id);  // 这个客户所有的联系人
            }
            // 如果修改了电话和传真，则弹出窗口，显示联系人列表供用户用户选择是否同步替换。    TODO
            if ((!old_company_value.phone.Equals(new_company_value)) || (!old_company_value.fax.Equals(new_company_value.fax)))   // 电话和传真有一个有更改时
            {
                var contactList = new crm_contact_dal().GetContactByAccountId(new_company_value.id);    // 
            }




            // TODO: 是否可以修改客户名称 account_name，需要做检查

            //if (account.id == 0)
            //    return false;
            //var oldValue = GetCompany(account.id);
            ////var updateDetail = _dal.UpdateDetail(oldValue, account);
            ////if (updateDetail == null)
            ////    return false;
            ////if (updateDetail.Equals(""))     // 未做修改
            ////    return true;

            //account.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //account.update_user_id = CachedInfoBLL.GetUserInfo(token).id;

            //// TODO: 日志
            //return _dal.Update(account);
            return true;
        }

        /// <summary>
        /// 按条件查询客户列表
        /// </summary>
        /// <returns></returns>
        public List<crm_account> FindList(JObject jsondata)
        {
            CompanyConditionDto condition = jsondata.ToObject<CompanyConditionDto>();
            string orderby = ((JValue)(jsondata.SelectToken("orderby"))).Value.ToString();
            string page = ((JValue)(jsondata.SelectToken("page"))).Value.ToString();
            int pagenum;
            if (!int.TryParse(page, out pagenum))
                pagenum = 1;
            return _dal.Find(condition, pagenum, orderby);
        }

        /// <summary>
        /// 删除客户
        /// </summary>
        /// <returns></returns>
        public bool DeleteCompany(long id, string token)
        {

            // 1)	Company Detail客户信息：逻辑删除                    ✓
            // 2)	Outsource Management外部资源管理：逻辑删除
            // 3)	Outsource Networks外部网络：逻辑删除
            // 4)	Contacts联系人：逻辑删除                            ✓
            // 5)	Posted Billing Items：逻辑删除
            // 9)	Configuration Items配置项：逻辑删除
            // 18)	Products产品：逻辑删除
            // 20)	Services服务：逻辑删除
            // 21)	Inventory Transfer：逻辑删除

            //var user = CachedInfoBLL.GetUserInfo(token);   // 根据token获取到用户信息
            var user = new UserInfoDto()
            {
                id = 1,
                email = "zhufei@test.com",
                mobile = "10086",
                name = "zhufei_test",
                security_Level_id = 0
            };
            crm_account account = GetCompany(id);
            if (account == null)
                return false;

            #region  1.Company Detail客户信息：逻辑删除                   ✓
            account.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            account.delete_user_id = user.id;
            _dal.SoftDelete(account, user.id);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                oper_object_id = account.id,
                oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                oper_description = _dal.AddValue(account), // 删除时和新增时记录的字段相同。通过同一个方法进行处理
                remark = "删除客户信息",
            });
            #endregion

            #region  4.Contacts联系人：逻辑删除                     ✓
            var contact_list = new crm_contact_dal().GetContactByAccountId(account.id);
            if (contact_list != null && contact_list.Count > 0)
            {
                var contact_dal = new crm_contact_dal();
                foreach (var contact in contact_list)
                {
                    contact_dal.SoftDelete(contact, user.id);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                        oper_object_id = account.id,
                        oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                        oper_description = contact_dal.AddValue(contact), // 删除时和新增时记录的字段相同。通过同一个方法进行处理
                        remark = "删除联系人信息",
                    });
                }
            }
            #endregion

            // todo 其余的逻辑删除

            return true;


            //crm_account account = GetCompany(id);
            //account.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //account.delete_user_id = CachedInfoBLL.GetUserInfo(token).id;
            //// TODO: 日志
            //return _dal.SoftDelete(account);
        }

        /// <summary>
        /// 查询客户名是否存在
        /// </summary>
        /// <returns></returns>
        public bool ExistCompany(string accountName)
        {
            return _dal.ExistAccountName(accountName);
        }


        /// <summary>
        /// 删除地址信息
        /// </summary>
        /// <param name="location_id"></param>
        /// <returns></returns>
        public bool DeleteLocation(long location_id,long account_id,string token)
        {
            var user = CachedInfoBLL.GetUserInfo(token);   
            crm_location location = new crm_location_dal().FindById(location_id);
            if (location == null)
            {
                return false;
            }
            var contactList = new crm_contact_dal().GetContactByAccounAndLocationId(account_id,location.id);
            if (contactList!=null&&contactList.Count>0)
            {
                return false; // 此地址还在被联系人所使用，不可以被删除
            }
            new crm_location_dal().SoftDelete(location,user.id);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                oper_object_id = location.id,
                oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                oper_description = _dal.AddValue(location), // 删除时和新增时记录的字段相同。通过同一个方法进行处理
                remark = "删除地址信息",
            });
            return true;
        }


        /// <summary>
        ///   Test--公司名称去除掉冗余的字符
        /// </summary>
        /// <param name="companyName">公司名称</param>
        /// <returns></returns>
        public string CompanyNameDeal(string companyName)
        {
            var nameList = new List<string>() { "股份", "有限", "信息", "科技", "公司", "技术"   };  // 后缀名称处理   todo—— 前缀名称处理
            foreach (var item in nameList)
            {
                //Regex r = new Regex(item);
                //Match m = r.Match(companyName);
                if (companyName.Contains(item))
                {
                    companyName = companyName.Replace(item, "");
                }
            }
            return companyName;
        }
    }
}
