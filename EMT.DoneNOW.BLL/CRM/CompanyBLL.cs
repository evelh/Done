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
using EMT.DoneNOW.BLL.CRM;


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
            dic.Add("classification", new d_account_classification_dal().GetDictionary());    // 分类类别
            dic.Add("country", new DistrictBLL().GetCountryList());                          // 国家表
            dic.Add("addressdistrict", new d_district_dal().GetDictionary());                 // 地址表（省市县区）
            dic.Add("sys_resource", new sys_resource_dal().GetDictionary());                  // 客户经理
            dic.Add("competition", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.COMPETITOR)));          // 竞争对手
            dic.Add("market_segment", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.MARKET_SEGMENT)));    // 行业
            //dic.Add("district", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("行政区")));                // 行政区
            dic.Add("territory", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TERRITORY)));              // 销售区域
            dic.Add("company_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.ACCOUNT_TYPE)));              // 客户类型
            dic.Add("taxRegion", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TAX_REGION)));              // 税区
            dic.Add("sufix", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.NAME_SUFFIX)));              // 名字后缀
            dic.Add("action_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.ACTION_TYPE)));        // 活动类型

            return dic;
        }

        /// <summary>
        /// 根据id查询客户
        /// </summary>
        /// <returns></returns>
        public crm_account GetCompany(long id)
        {
            string sql = $"select * from crm_account where id = {id} and delete_time = 0 ";
            return _dal.FindSignleBySql<crm_account>(sql);
        }
        /// <summary>
        /// 根据商机ID 或者客户ID去获取客户信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public crm_account GetCompanyByOpportunityOrId(long id)
        {
            return _dal.FindSignleBySql<crm_account>($"SELECT a.* FROM crm_account a LEFT JOIN crm_opportunity o on a.id = o.account_id where(a.id = {id} AND a.delete_time = 0) or(o.account_id = {id} and o.delete_time = 0)");
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
        /// 查找带回取到所有客户，修改的时候去掉自己
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<crm_account> GetAccountByFindBack(long? id)
        {
            return _dal.GetAccountByFindBack(id);
        }
        
        /// <summary>
        /// 新增客户
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Insert(CompanyAddDto param, long user_id)
        {
            if (string.IsNullOrEmpty(param.general.company_name) || string.IsNullOrEmpty(param.general.phone) || string.IsNullOrEmpty(param.location.address))                     // string必填项校验
                return ERROR_CODE.PARAMS_ERROR;             // 返回参数丢失
            if (param.location.country_id == 0 || param.location.province_id == 0 || param.location.city_id == 0)
                return ERROR_CODE.PARAMS_ERROR;             // int 必填项校验
            if (_dal.ExistAccountName(param.general.company_name.Trim()))    // 客户名称与客户电话的唯一性校验
                return ERROR_CODE.CRM_ACCOUNT_NAME_EXIST;   // 返回客户名已存在   
            if (_dal.ExistAccountPhone(param.general.phone))
                return ERROR_CODE.PHONE_OCCUPY;              // 返回电话被占用
            if (!string.IsNullOrEmpty(param.contact.mobile_phone))     // 移动电话不为空时，进行唯一性校验
            {
               if( new crm_contact_dal().ExistContactMobilePhone(param.contact.mobile_phone))       // 移动电话唯一校验
                {
                    return ERROR_CODE.MOBILE_PHONE_OCCUPY;           // 返回错误
                }
            }


            // TODO  名称相似校验
            //var compareAccountName = CompareCompanyName(CompanyNameDeal(param.general.company_name.Trim()), _dal.FindAll().ToList());    // 处理后的名字超过两个字相同（不包括两个字）即视为相似名称
            //if (compareAccountName != null && compareAccountName.Count > 0)
            //    return ERROR_CODE.ERROR;

            var user = UserInfoBLL.GetUserInfo(user_id);

            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;           // 查询不到用户，用户丢失

            #region 1.保存客户
            crm_account _account = new crm_account()
            {
                id = _dal.GetNextIdCom(),
                // account_id = _dal.GetNextIdCom(), // todo account_id 与 id 的区别 
                // external_id = "",   //   外部关联用ID【预留】  
                create_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                no = param.general.company_number,
               // parent_id = param.general.parent_company_name,
                territory_id = param.general.territory_name,
                market_segment_id = param.general.market_segment == 0 ? null : param.general.market_segment,
                competitor_id = param.general.competitor == 0 ? null : param.general.competitor,
                name = param.general.company_name.Trim(),
                is_active = 1,                         // 0未激活 1 激活
                //is_taxable = param.general.tax_exempt ? 1 : 0,// 是否免税 0 否 1 是
                is_optout_survey=0,            // 是否拒绝问卷调查 0 否 1 是
                phone = param.general.phone,
                fax = param.general.fax,
                web_site = param.general.web_site,
                alternate_phone1 = param.general.alternate_phone1,
                alternate_phone2 = param.general.alternate_phone2,
                last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                type_id = param.general.company_type == 0 ? null : param.general.company_type,
                classification_id = param.general.classification == 0 ? null : param.general.classification,
                tax_region_id = param.general.tax_region == 0 ? null : param.general.tax_region,
                tax_identification = param.general.tax_id,
                resource_id = param.general.account_manage == null ? 1 : (long)param.general.account_manage,
            };  //  创建客户实体类

            if (!string.IsNullOrEmpty(param.general.parent_company_name))
            {
                _account.parent_id = Convert.ToInt64(param.general.parent_company_name);
            }
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
                remark = "保存客户信息"

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
                province_id = param.location.province_id,
                postal_code = param.location.postal_code,
                country_id = param.location.country_id,
                additional_address = param.location.additional_address == null ? "" : param.location.additional_address,
                is_default = 1,  // 是否默认
                create_user_id = user.id,
                update_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            };
            new LocationBLL().Insert(_location, user_id);


            //new crm_location_dal().Insert(_location);
            //sys_oper_log add_location_log = new sys_oper_log()
            //{
            //    user_cate = "用户",
            //    user_id = user.id,
            //    name = "",
            //    phone = user.mobile == null ? "" : user.mobile,
            //    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
            //    oper_object_id = _location.id,// 操作对象id
            //    oper_type_id = (int)OPER_LOG_TYPE.ADD,
            //    oper_description = _dal.AddValue(_location),
            //    remark = "保存地址信息"
            //};
            //new sys_oper_log_dal().Insert(add_location_log);       // 插入日志
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
                    is_primary_contact = 1,   // 主联系人 0不是 1是
                    create_user_id = user.id,
                    update_user_id = user.id,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    fax = _account.fax,
                    alternate_phone = _account.alternate_phone1,
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


                var insertContactParam = new ContactAddAndUpdateDto()
                {
                    company_name = _account.name,
                    contact = _contact,
                    //location = _location,  // 可能出现不添加联系人的情乱，地址单独插入
                    udf = param.contact.udf
                };  // 调用联系人新增的方法去新增联系人
                new ContactBLL().Insert(insertContactParam, user.id);



                //new crm_contact_dal().Insert(_contact);
                //var add_contact_log = new sys_oper_log()
                //{
                //    user_cate = "用户",
                //    user_id = user.id,
                //    name = user.name,
                //    phone = user.mobile == null ? "" : user.mobile,
                //    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                //    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                //    oper_object_id = _contact.id,// 操作对象id
                //    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                //    oper_description = _dal.AddValue(_contact),
                //    remark = "保存联系人信息"
                //};          // 创建日志
                //new sys_oper_log_dal().Insert(add_contact_log);       // 插入日志
            }

            #endregion

            #region 3.保存客户扩展信息
            //new UserDefinedFieldsBLL().SaveUdfValue();
            var udf_account_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.COMPANY);  // 获取到所有关于客户的自定义字段
            var udf_general_list = param.general.udf;
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.COMPANY, user.id, _account.id, udf_account_list, udf_general_list, OPER_LOG_OBJ_CATE.CUSTOMER_EXTENSION_INFORMATION); // 保存自定义字段，保存成功，插入日志
            //{
            //    var add_accout_udf_log = new sys_oper_log()
            //    {
            //        user_cate = "用户",
            //        user_id = user.id,
            //        name = "",
            //        phone = user.mobile == null ? "" : user.mobile,
            //        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER_EXTENSION_INFORMATION,
            //        oper_object_id = _account.id,// 操作对象id
            //        oper_type_id = (int)OPER_LOG_TYPE.ADD,
            //        oper_description = new Tools.Serialize().SerializeJson(udf_general_list),
            //        remark = "保存客户扩展信息"

            //    };          // 创建日志
            //    new sys_oper_log_dal().Insert(add_accout_udf_log);       // 插入日志
            //}
            #endregion

            #region 4.保存联系人扩展信息
            if (!string.IsNullOrEmpty(param.contact.first_name))  // 判断
            {
                var udf_contact_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTACT); // 联系人的自定义字段
                var udf_con_list = param.contact.udf;     // 传过来的联系人的自定义参数
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.CONTACT, user.id, _contact.id, udf_contact_list, udf_con_list, OPER_LOG_OBJ_CATE.CONTACTS_EXTENSION_INFORMATION);

            }
            #endregion

            #region 5.保存客户站点的扩展信息
            var udf_site_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.SITE);
            var udf_site = param.site.udf;
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.SITE, user.id, _account.id, udf_site_list, udf_site, OPER_LOG_OBJ_CATE.CUSTOMER_SITE);



            #endregion



            #region 7.保存备注信息
            if (param.note.note_action_type != 0)
            {
                if (param.note.note_end_time != null && param.note.note_start_time != null && !string.IsNullOrEmpty(param.note.note_description))
                {
                    com_activity note_activity = new com_activity()
                    {
                        id = _dal.GetNextIdCom(),
                        cate_id = (int)ACTIVITY_CATE.NOTE,
                        account_id = _account.id,
                        // contact_id = null,
                        // resource_id = null,
                        object_id = _account.id,
                        object_type_id = (int)OBJECT_TYPE.CUSTOMER, // todo 待确认
                        action_type_id = param.note.note_action_type,
                        start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(Convert.ToDateTime(param.note.note_start_time)),
                        end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(Convert.ToDateTime(param.note.note_end_time)),
                        description = param.note.note_description,
                        // contract_id = null,
                        // opportunity_id = null,
                        // ticket_id = null,
                        // status_id = null,
                        // complete_time = null,
                        // complete_description = null,
                        // parent_id = null,
                        create_user_id = user.id,
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_user_id = user.id,
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        delete_time = 0,
                    };
                    new com_activity_dal().Insert(note_activity);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                        oper_object_id = note_activity.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(note_activity),
                        remark = "保存备注信息"

                    });          // 创建日志);


                    // 进行非空校验之后，创建备注对象，并将日志插入表中 
                    //com_note _note = new com_note()
                    //{
                    //    id = _dal.GetNextIdCom(),
                    //    account_id = _account.id,
                    //    // contact_id = _contact == null ? 0 : _contact.id,
                    //    object_id = _account.id,
                    //    object_type_id = (int)OBJECT_TYPE.CUSTOMER,
                    //    action_type_id = param.note.note_action_type,
                    //    start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(Convert.ToDateTime(param.note.note_start_time)),
                    //    end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(Convert.ToDateTime(param.note.note_end_time)),
                    //    description = param.note.note_description,
                    //    create_user_id = user.id,
                    //    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    //    update_user_id = user.id,
                    //    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    //    delete_time = 0,
                    //};
                    //new com_note_dal().Insert(_note);
                    //sys_oper_log add_note_log = new sys_oper_log()
                    //{
                    //    user_cate = "用户",
                    //    user_id = user.id,
                    //    name = user.name,
                    //    phone = user.mobile == null ? "" : user.mobile,
                    //    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    //    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                    //    oper_object_id = _note.id,// 操作对象id
                    //    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    //    oper_description = _dal.AddValue(_note),
                    //    remark = "保存记录信息"

                    //};          // 创建日志
                    //new sys_oper_log_dal().Insert(add_note_log);       // 插入日志
                }

            }

            #endregion

            #region 8.保存待办信息
            if (param.todo.todo_action_type != 0)
            {
                if (param.todo.assigned_to != 0 && param.todo.todo_start_time != null && param.todo.todo_end_time != null && !string.IsNullOrEmpty(param.todo.todo_description))
                {
                    com_activity todo_activity = new com_activity()
                    {
                        id = _dal.GetNextIdCom(),
                        cate_id = (int)ACTIVITY_CATE.TODO,
                        account_id = _account.id,
                        // contact_id = null,
                        resource_id = param.todo.assigned_to,
                        object_id = _account.id,
                        object_type_id = (int)OBJECT_TYPE.CUSTOMER, // todo 待确认
                        action_type_id = param.todo.todo_action_type,
                        start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(Convert.ToDateTime(param.note.note_start_time)),
                        end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(Convert.ToDateTime(param.note.note_end_time)),
                        description = param.todo.todo_description,
                        // contract_id = null,
                        // opportunity_id = null,
                        // ticket_id = null,
                        // status_id = null,
                        // complete_time = null,
                        // complete_description = null,
                        // parent_id = null,
                        create_user_id = user.id,
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_user_id = user.id,
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        delete_time = 0,
                    };
                    new com_activity_dal().Insert(todo_activity);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                        oper_object_id = todo_activity.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(todo_activity),
                        remark = "保存备注信息"

                    });



                    //com_todo _todo = new com_todo()
                    //{
                    //    id = _dal.GetNextIdCom(),
                    //    account_id = _account.id,
                    //    //contact_id = _contact == null ? 0 : _contact.id,
                    //    resource_id = user.id,  // 负责人 id
                    //    action_type_id = param.todo.todo_action_type,
                    //    object_id = _account.id,
                    //    object_type_id = (int)OBJECT_TYPE.CUSTOMER,
                    //    start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(Convert.ToDateTime(param.todo.todo_start_time)),
                    //    end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(Convert.ToDateTime(param.todo.todo_end_time)),
                    //    description = param.todo.todo_description,
                    //    create_user_id = user.id,
                    //    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    //    update_user_id = user.id,
                    //    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    //    delete_time = 0,
                    //};
                    //new com_todo_dal().Insert(_todo);
                    //var add_todo_log = new sys_oper_log()
                    //{
                    //    user_cate = "用户",
                    //    user_id = user.id,
                    //    name = user.name,
                    //    phone = user.mobile == null ? "" : user.mobile,
                    //    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    //    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                    //    oper_object_id = _todo.id,// 操作对象id
                    //    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    //    oper_description = _dal.AddValue(_todo),
                    //    remark = "保存待办信息"
                    //};
                    //new sys_oper_log_dal().Insert(add_todo_log);
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
            return ERROR_CODE.SUCCESS;
        }
        
        public List<crm_account> CheckCompanyName(string companyName)
        {
            return CompareCompanyName(CompanyNameDeal(companyName), _dal.GetAllCompany());    // 处理后的名字超过两个字相同（不包括两个字）即视为相似名称

        }
        /// <summary>
        /// 更新客户信息
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Update(CompanyUpdateDto param, long user_id, out string updateLocationContact,out string updateFaxPhoneContact)
        {
            updateFaxPhoneContact = "";
            updateLocationContact = "";
            // 对必填的字段进行非空验证
            if (string.IsNullOrEmpty(param.general_update.company_name) || string.IsNullOrEmpty(param.general_update.phone) || string.IsNullOrEmpty(param.general_update.address))
            {
             
                //dic.Add(false, null);
                //return dic;
                return ERROR_CODE.PARAMS_ERROR;
            }
            if (param.general_update.country_id == 0 || param.general_update.province_id == 0 || param.general_update.city_id == 0 || param.general_update.companyType == 0 || param.general_update.accountManger == 0)
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            if (_dal.ExistAccountName(param.general_update.company_name.Trim(), param.general_update.id))    // 客户名称与客户电话的唯一性校验
                return ERROR_CODE.CRM_ACCOUNT_NAME_EXIST;   // 返回客户名已存在   
            if (_dal.ExistAccountPhone(param.general_update.phone, param.general_update.id))    // 客户电话的唯一性校验 todo - 修改时 客户名称的唯一校验 
                return ERROR_CODE.PHONE_OCCUPY;   //  查找到重复信息，返回电话名称被占用


            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;           // 查询不到用户，用户丢失

            #region 1.保存客户
            crm_account old_company_value = GetCompany(param.general_update.id);
            // crm_account old_company_value = _dal.GetCompany(param.general_update.company_name); // 

            if (old_company_value == null) // 并发操作时已经将客户删除的情况
            {
                return ERROR_CODE.ERROR;        // 客户丢失返回错误
            }
            crm_account new_company_value = new crm_account()
            {
                id = old_company_value.id,
                oid = old_company_value.oid,
              
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                name = param.general_update.company_name,
                no = param.general_update.companyNumber,
                territory_id = param.general_update.territoryName == 0 ? null : param.general_update.territoryName,
                market_segment_id = param.general_update.marketSegment == 0 ? null : param.general_update.marketSegment,
                competitor_id = param.general_update.competitor == 0 ? null : param.general_update.competitor,
                is_active = param.general_update.is_active,
                phone = param.general_update.phone,
                fax = param.general_update.fax,
                web_site = param.general_update.webSite,
                alternate_phone1 = param.general_update.alternatePhone1,
                alternate_phone2 = param.general_update.alternatePhone2,
                last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                type_id = param.general_update.companyType,
                classification_id = param.general_update.classification == 0 ? null : param.general_update.classification,
                tax_region_id = param.general_update.taxRegion == 0 ? null : param.general_update.taxRegion,
                tax_identification = param.general_update.taxId,
                resource_id = param.general_update.accountManger,
                is_optout_survey = param.general_update.is_optout_survey,
                mileage = param.general_update.mileage,
                stock_symbol = param.additional_info.stock_symbol,
                stock_market = param.additional_info.stock_market,
                sic_code = param.additional_info.sic_code,
                weibo_url = param.additional_info.weibo_url,
                wechat_mp_subscription = param.additional_info.wechat_mp_subscription,
                wechat_mp_service = param.additional_info.wechat_mp_service,
                create_user_id = old_company_value.create_user_id,
                create_time = old_company_value.create_time,
                //parent_id =  == null ? null : param.general_update.parent_company_name,
                // asset_value = param.additional_info.asset_value == "" ? null: Convert.ToDecimal(param.additional_info.asset_value),

                #region 有没有必要写的字段？ 
                alternate_phone1_basic = old_company_value.alternate_phone1_basic,
                alternate_phone2_basic = old_company_value.alternate_phone2_basic,
                attention = old_company_value.attention,
                block_deduction_total = old_company_value.block_deduction_total,
                block_purchase_total = old_company_value.block_purchase_total,
                curr_block_balance = old_company_value.curr_block_balance,
                delete_time = old_company_value.delete_time,
                delete_user_id = old_company_value.delete_user_id,
                external_id = old_company_value.external_id,
                facebook_url = old_company_value.facebook_url,
                is_block_account = old_company_value.is_block_account,
                is_costed_client = old_company_value.is_costed_client,
                is_tax_exempt = old_company_value.is_tax_exempt,
                linkedin_url = old_company_value.linkedin_url,
                opportunity_value = old_company_value.opportunity_value,
                phone_basic = old_company_value.phone_basic,
                surrvey_rating = old_company_value.surrvey_rating,
                survey_optout_time = old_company_value.survey_optout_time,
                twitter_url = old_company_value.twitter_url,
                use_parent_account_contracts = old_company_value.use_parent_account_contracts,
                #endregion

            };
            if (!string.IsNullOrEmpty(param.general_update.parent_company_name))
            {
                new_company_value.parent_id = Convert.ToInt64(new_company_value);
            }

            if (!string.IsNullOrEmpty(param.additional_info.asset_value))
            {

                new_company_value.asset_value = Convert.ToDecimal(param.additional_info.asset_value);
            }



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
                if (udf_account != null && udf_account.Count > 0)   // todo 用户未填写自定义信息为null，是否算更改插日志
                {
                    new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.COMPANY, udf_account_list, new_company_value.id, udf_account, user, DicEnum.OPER_LOG_OBJ_CATE.CUSTOMER_EXTENSION_INFORMATION);
                }

            }
            #endregion

            #region 3.保存客户站点信息  TODO-TEST
            var udf_site_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.SITE);
            if (udf_site_list != null && udf_site_list.Count > 0)
            {
                var udf_site = param.site_configuration.udf;
                // UpdateUdfValue 中含有插入修改日志的操作，无需再插入日志
                new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.SITE, udf_site_list, new_company_value.id, udf_site, user, DicEnum.OPER_LOG_OBJ_CATE.CUSTOMER_SITE);
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
                id = old_location.id,
                account_id = old_location.account_id,
                address = param.general_update.address,
                city_id = param.general_update.city_id,
                country_id = param.general_update.country_id,
                province_id = param.general_update.province_id,
                district_id = param.general_update.district_id,
                additional_address = param.general_update.additionalAddress,
                is_default = old_location.is_default,
                create_user_id = old_location.create_user_id,
                create_time = old_location.create_time,
                update_user_id = old_location.update_user_id,
                update_time = old_location.update_time,
                //update_user_id = user.id,
                //update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                postal_code = param.general_update.postal_code,
                cate_id = old_location.cate_id,
                delete_time = old_location.delete_time,
                delete_user_id = old_location.delete_user_id,
                location_label = old_location.location_label,
                town_id = old_location.town_id,
            };   // 生成新的地址的实体类
            new LocationBLL().Update(new_location, user_id);

            #region 备用代码
            //if (!old_location.Equals(new_location))   // 代表用户更改了地址
            //{
            //    new_location.update_user_id = user.id;
            //    new_location.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //    // 修改客户显示默认地址，默认地址不能主动移除
            //    // new crm_location_dal().UpdateDefaultLocation(new_company_value.id, user); // 首先将原来的默认地址取消  操作日志在方法内插入
            //    new crm_location_dal().Update(new_location);             // 更改地址信息
            //    new sys_oper_log_dal().Insert(new sys_oper_log()
            //    {
            //        user_cate = "用户",
            //        user_id = user.id,
            //        name = user.name,
            //        phone = user.mobile == null ? "" : user.mobile,
            //        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
            //        oper_object_id = new_location.id,
            //        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
            //        oper_description = _dal.CompareValue(old_location, new_location),
            //        remark = "修改客户地址",
            //    });    // 插入更改日志
            //}
            //else
            //{
            //    new crm_location_dal().Update(new_location);             // 更改地址信息
            //    new sys_oper_log_dal().Insert(new sys_oper_log()
            //    {
            //        user_cate = "用户",
            //        user_id = user.id,
            //        name = user.name,
            //        phone = user.mobile == null ? "" : user.mobile,
            //        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
            //        oper_object_id = new_location.id,
            //        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
            //        oper_description = _dal.CompareValue(old_location, new_location),
            //        remark = "修改客户地址",
            //    });    // 插入更改日志
            //}
            #endregion

            #endregion


            #region TODO 修改地址或者电话，传真的时候对页面的反馈
            if (!new_location.Equals(old_location))      // 如果修改了地址，该地被其他联系人引用，则弹出窗口，提示用户会同步修改的联系人 TODO-- 如何提示
            {
                var contactAllList = new crm_contact_dal().GetContactByAccounAndLocationId(new_company_value.id, old_location.id);  // 这个客户所有的联系人
                //updateLocationContact = contactAllList.Select(_ => _.id).ToList().ToString();
                if (contactAllList != null && contactAllList.Count > 0)
                {
                    foreach (var item in contactAllList)
                    {
                        updateLocationContact += item.id.ToString()+",";
                    }                 
                }
            }
            // 如果修改了电话和传真，则弹出窗口，显示联系人列表供用户用户选择是否同步替换。    TODO
            old_company_value.fax = string.IsNullOrEmpty(old_company_value.fax) ? "" : old_company_value.fax;
            new_company_value.fax = string.IsNullOrEmpty(new_company_value.fax) ? "" : new_company_value.fax;
            if ((!old_company_value.phone.Equals(new_company_value.phone)) || (!old_company_value.fax.Equals(new_company_value.fax)))   // 电话和传真有一个有更改时
            {
                var contactList = new crm_contact_dal().GetContactByAccountId(new_company_value.id);    // 获取到所有的这个客户的联系人
                if (contactList != null && contactList.Count > 0)
                {
                    //  updateFaxPhoneContact
                    foreach (var item in contactList)
                    {
                        updateFaxPhoneContact += item.id.ToString() + ",";
                    }
                }

            }
            if (updateLocationContact != "")
                updateLocationContact = updateLocationContact.Substring(0, updateLocationContact.Length - 1);
            if (updateFaxPhoneContact != "")
                updateFaxPhoneContact = updateFaxPhoneContact.Substring(0, updateFaxPhoneContact.Length-1);
            #endregion


            return ERROR_CODE.SUCCESS;
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
        public bool DeleteCompany(long id, long user_id)
        {

            // 1)	Company Detail客户信息：逻辑删除                    ✓
            // 4)	Contacts联系人：逻辑删除                            ✓
            // 9)	Configuration Items配置项：逻辑删除

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
            // var contact_list = new crm_contact_dal().FindByAccountId(account.id);     // 获取到客户对应的联系人信息
            var contact_list = new crm_contact_dal().GetContactByAccountId(account.id);  // 获取到客户对应的联系人信息
            var contact_dal = new crm_contact_dal();
            if (contact_list != null && contact_list.Count > 0)
            {
                foreach (var contact in contact_list)                                    // 循环联系人，全部逻辑删除
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
                        oper_object_id = contact.id,
                        oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                        oper_description = contact_dal.AddValue(contact), // 删除时和新增时记录的字段相同。通过同一个方法进行处理
                        remark = "删除联系人信息",
                    });
                }
            }
            #endregion


            #region 9.配置项逻辑删除
            var installedProductList = new crm_installed_product_dal().GetInstalledProductByAccountId(account.id);
            if (installedProductList != null && installedProductList.Count > 0)
            {
                var installed_product_dal = new crm_installed_product_dal();
                foreach (var installed_product in installedProductList)
                {
                    if (installed_product_dal.SoftDelete(installed_product, user.id))
                    {
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                            oper_object_id = installed_product.id,
                            oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                            oper_description = _dal.AddValue(installed_product), // 删除时和新增时记录的字段相同。通过同一个方法进行处理
                            remark = "删除配置项信息",
                        });
                    }
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
        public bool DeleteLocation(long location_id, long account_id, string token)
        {
            var user = CachedInfoBLL.GetUserInfo(token);
            crm_location location = new crm_location_dal().FindById(location_id);
            if (location == null)
            {
                return false;
            }
            var contactList = new crm_contact_dal().GetContactByAccounAndLocationId(account_id, location.id);
            if (contactList != null && contactList.Count > 0)
            {
                return false; // 此地址还在被联系人所使用，不可以被删除
            }
            new crm_location_dal().SoftDelete(location, user.id);
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
            // var nameList = new List<string>() { "股份", "有限", "信息", "科技", "公司", "技术", "责任", "集团", "贸易", "工贸", "工程", "网络", "实业", "营业部", "事业部", "办事处", "分公司", "管理" };  // 后缀名称处理   todo—— 前缀名称处理
            // 客户：名称后缀
            var List = new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.NAME_SUFFIX));
            var nameList = List.Select(_ => _.show);
            var areaList = new List<string> { "北京", "上海", "广州", "深圳", "杭州" };

            foreach (var item in nameList)
            {
                //Regex r = new Regex(item);
                //Match m = r.Match(companyName);
                if (companyName.Contains(item))
                {
                    companyName = companyName.Replace(item, "");
                }
            }  // 后缀名称处理

            foreach (var item in areaList)
            {
                if (companyName.Contains(item))
                {
                    companyName = companyName.Replace(item, "");
                }
            }  // 前缀名称处理

            return companyName;
        }
        /// <summary>
        /// Test--公司名称相似校验
        /// </summary>
        /// <param name="newCompanyName"></param>
        /// <param name="allCompanyName"></param>
        /// <returns></returns>
        public List<crm_account> CompareCompanyName(string newCompanyName, List<crm_account> allCompanyName)
        {
            List<crm_account> similar_names = new List<crm_account>();
            if (allCompanyName != null && allCompanyName.Count > 0)
            {
                //int nameCount = 0;

                for (int i = 0; i < newCompanyName.Length - 1; i++)
                {
                    var subName = newCompanyName.Substring(i, 2); // 截取判断的相似字段
                    var containSubName = allCompanyName.Where(_ => _.name.Contains(subName)).ToList();   // 获取含有相对应字段的公司名称
                    if (containSubName != null && containSubName.Count > 0)
                    {
                        similar_names.AddRange(containSubName);                       // 如果查询到，将公司名称批量添加进相似公司名称里面
                        containSubName.ForEach(_ => allCompanyName.Remove(_));         // 并且将相似的公司名称从集合中移除，以免重复添加
                    }
                }
            }
            return similar_names;
        }

        /// <summary>
        /// 新增配置项
        /// </summary>
        /// <param name="param"></param>
        /// <param name="account_id"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        public bool ConfigurationItemAdd(ConfigurationItemAddDto param, long account_id, string token)
        {

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
                return false;

            // 必填项校验


            #region 1.保存配置项
            var installed_product_dal = new crm_installed_product_dal();
            crm_installed_product installed_product = new crm_installed_product()
            {
                id = installed_product_dal.GetNextIdCom(),
                product_id = installed_product_dal.GetNextIdCom(),
                account_id = account_id,
                start_date = param.installed_on == null ? DateTime.Now : param.installed_on,
                through_date = param.warranty_expiration == null ? DateTime.Now.AddYears(1) : param.warranty_expiration,
                number_of_users = param.number_of_users,
                serial_number = param.serial_number,
                reference_number = param.reference_number,
                contract_id = param.contract,
                location = param.location,
                contact_id = param.contact_id,
                vendor_id = param.vendor,
                is_active = (sbyte)param.status,
                installed_resource_id = user.id,
                installed_contact_id = param.contact_id, // todo -- 安装人与联系人
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                create_user_id = user.id,
                update_user_id = user.id,

                // Terms
                hourly_cost = param.terms.hourly_cost,
                daily_cost = param.terms.daily_cost,
                monthly_cost = param.terms.monthly_cost,
                setup_fee = param.terms.setup_fee,
                peruse_cost = param.terms.per_user_cost,

            };   // 创建配置项对象
            installed_product_dal.Insert(installed_product);                            // 插入配置项
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                oper_object_id = installed_product.id,
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = installed_product_dal.AddValue(installed_product),
                remark = "新增配置项",
            });                       // 插入操作日志
            var udf_configuration_items_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONFIGURATION_ITEMS);   // 查询自定义信息
            var udf_configuration_items = param.udf;
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.CONFIGURATION_ITEMS, user.id, account_id, udf_configuration_items_list, udf_configuration_items, OPER_LOG_OBJ_CATE.CUSTOMER);  // 保存自定义扩展信息

            #endregion

            #region 2.保存通知
            var notify_email_dal = new com_notify_email_dal();
            var notify_email = new com_notify_email()
            {
                id = 1,
                cate_id = (int)NOTIFY_CATE.CRM,
                event_id = 1,             // todo
                to_email = param.notice.contacts,                  // 接受人地址？？联系人地址   
                notify_tmpl_id = param.notice.notification_template,
                from_email = user.email,   // todo
                from_email_name = user.name,  // todo 
                subject = param.notice.subject,
                body_text = param.notice.additional_email_text,    // 附加信息？？
                is_html_format = 0,                                // 内容是否是html格式，0纯文本 1html
                create_user_id = user.id,
                update_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),

            };
            notify_email_dal.Insert(notify_email);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                oper_object_id = notify_email.id,
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = installed_product_dal.AddValue(notify_email),
                remark = "新增通知",
            });  // 插入日志

            #endregion

            return true;
        }

        /// <summary>
        /// 显示客户报告内容
        /// </summary>
        /// <param name="account_id"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        public CompanyReportDto AccountReport(long account_id, string token)
        {
            CompanyReportDto com_report = new CompanyReportDto();
            com_report.crm_account = _dal.FindById(account_id);
            if (com_report.crm_account == null)
                return null;               // 查询不到客户信息，直接返回null
            com_report.crm_contact_list = new crm_contact_dal().GetContactByAccountId(account_id);
            com_report.subsidiaries_list = _dal.GetSubsidiariesById(account_id);
            com_report.opportunity_history_list = new crm_opportunity_dal().FindOpHistoryByAccountId(account_id);   // 商机历史
            com_report.udf_list = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.COMPANY, account_id, new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.COMPANY));  // todo 返回id 和value，不是name和value
            com_report.ins_pro_list = new crm_installed_product_dal().FindByAccountId(account_id);
            com_report.todo_list = null;    // todo 
            com_report.note_list = new com_note_dal().FindNoteByAccountId(account_id);
            com_report.opportunity_list = new crm_opportunity_dal().FindByAccountId(account_id);   // 商机详情 List??? 

            return com_report;
        }
        /// <summary>
        /// 客户概述
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public crm_account AccountSummary(long account_id)
        {
            return _dal.FindById(account_id);
        }


    }
}
