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

            // 测试

            var user = new UserInfoDto()
            {
                id = 1,email="1zhufei@test.com",mobile="10086",name="zhufei_test",
                security_Level_id=0
            };
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;           // 查询不到用户，用户丢失

            #region 1.保存客户
            crm_account _account = new crm_account()
            {
                id = _dal.GetNextIdCom(),
                external_id = "",   //   外部关联用ID【预留】  
                create_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                no = param.general.company_number,
                parent_id = param.general.parent_company_name,  // todo 上级客户， 传进来父客户id，不是名字？？？
                territory_id = param.general.territory_name,
                market_segment_id = param.general.market_segment,
                competitor_id = param.general.competitor,
                name = param.general.company_name,
                is_active = 1,    // 0未激活 1 激活
                //is_costed_client = 1,  // 是否是计费客户 0否 1是
                //is_taxable = param.general.tax_exempt ? 1 : 0,// 是否免税 0 否 1 是
                //is_block_account = 0,  //  是否已预定计费时段* 0否 1是【预留】
                //curr_block_balance = 0,  // 当前时段*【预留】
                //mileage = 0,   //  todo 客户里程
                //location_id = 0, // 地址1 ？ todo
                phone = param.general.phone,
                fax = param.general.fax,
                web_site = param.general.web_site,
                alternate_phone1 = param.general.alternate_phone1,
                alternate_phone2 = param.general.alternate_phone2,
                //stock_symbol="", // 股本简称
                //stock_market="", // 股票市场
                //sic_code = "",   // 股票代码
                //asset_value=0,  //  市值
                last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                type_id = param.general.company_type,
                // opportunity_value = 0, // 当前商机汇总值
                // block_purchase_total = 0,  //  预定时段采购总额，时长
                // block_deduction_total = 0, //  扣除
                classification_id = param.general.classification,
                // use_parent_account_contracts = (sbyte)0, // 是否使用母公司合同

                tax_region_id = param.general.tax_region,
                tax_identification = param.general.tax_id,
                resource_id = param.general.account_manage,
                // location_id = 0,
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
                   // location_id = _account.location_id,
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
                    //其余字段暂定  todo
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
                        delete_time = 0 ,
                       // name = "",
                       // priority = 0,  // todo 
                        
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
                        //status_id = 0,  // 激活状态 0 未激活 1 激活
                        //classification_id = param._general.classification,
                        action_type_id = param.todo.action_type,
                        object_id = (int)OBJECT_TYPE.CUSTOMER,
                        start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(param.todo.start_time),
                        end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(param.todo.end_time),
                        description = param.todo.description,
                        //priority = 0,// 优先级
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
        public bool Update(crm_account account, string token)
        {
            // TODO: 是否可以修改客户名称 account_name，需要做检查

            if (account.id == 0)
                return false;
            var oldValue = GetCompany(account.id);
            //var updateDetail = _dal.UpdateDetail(oldValue, account);
            //if (updateDetail == null)
            //    return false;
            //if (updateDetail.Equals(""))     // 未做修改
            //    return true;

            account.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            account.update_user_id = CachedInfoBLL.GetUserInfo(token).id;

            // TODO: 日志
            return _dal.Update(account);
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
            crm_account account = GetCompany(id);
            account.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            account.delete_user_id = CachedInfoBLL.GetUserInfo(token).id;
            // TODO: 日志
            return _dal.SoftDelete(account);
        }

        /// <summary>
        /// 查询客户名是否存在
        /// </summary>
        /// <returns></returns>
        public bool ExistCompany(string accountName)
        {
            return _dal.ExistAccountName(accountName);
        }
    }
}
