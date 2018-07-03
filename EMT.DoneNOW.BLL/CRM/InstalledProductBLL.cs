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
    public class InstalledProductBLL
    {
        private readonly crm_installed_product_dal _dal = new crm_installed_product_dal();

        /// <summary>
        /// 获取客户相关的列表字典项
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            // dic.Add("classification", new d_account_classification_dal().GetDictionary());    // 分类类别
            // dic.Add("country", new DistrictBLL().GetCountryList());                          // 国家表
            // dic.Add("addressdistrict", new d_district_dal().GetDictionary());                 // 地址表（省市县区）
            // dic.Add("sys_resource", new sys_resource_dal().GetDictionary());                  // 客户经理
            // dic.Add("competition", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.COMPETITOR)));          // 竞争对手
            // dic.Add("market_segment", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.MARKET_SEGMENT)));    // 行业
            // //dic.Add("district", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("行政//区")));                // 行政区
            // dic.Add("territory", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.TERRITORY)));              // 销售区域
            // dic.Add("company_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.ACCOUNT_TYPE)));              // 客户类型
            // dic.Add("taxRegion", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.TAX_REGION)));              // 税区
            // dic.Add("sufix", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)//GeneralTableEnum.NAME_SUFFIX)));              // 名字后缀
            dic.Add("installed_product_cate", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.INSTALLED_PRODUCT_CATE)));        // 配置项类型
            dic.Add("period_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE)));
            return dic;
        }
        /// <summary>
        /// 根据Id 获取配置项信息
        /// </summary>
        public crm_installed_product GetById(long id)
        {
            return _dal.FindNoDeleteById(id);
        }
        /// <summary>
        /// 返回有未审批订阅周期 的订阅
        /// </summary>
        public List<crm_subscription> ReturnSubIds(List<crm_subscription> subList)
        {
            List<crm_subscription> noAppSub = new List<crm_subscription>();
            if (subList != null && subList.Count > 0)
            {
                var cspDal = new crm_subscription_period_dal();
                foreach (var thisSub in subList)
                {
                    var perList = cspDal.GetSubPeriodByWhere($" and subscription_id = {thisSub.id}");
                    if (perList != null && perList.Count > 0 && perList.Any(_ => _.approve_and_post_date == null && _.approve_and_post_user_id == null))
                        noAppSub.Add(thisSub);
                }
            }
            return noAppSub;
        }

        /// <summary>
        /// 新增配置项
        /// </summary>
        /// <param name="param"></param>
        /// <param name="account_id"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        public bool ConfigurationItemAdd(ConfigurationItemAddDto param, long user_id)
        {


            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return false;

            // 必填项校验


            #region 1.保存配置项
            var installed_product_dal = new crm_installed_product_dal();
            crm_installed_product installed_product = new crm_installed_product()
            {
                id = installed_product_dal.GetNextIdCom(),
                product_id = param.product_id,
                cate_id = param.installed_product_cate_id,
                account_id = param.account_id,
                start_date = param.start_date,
                through_date = param.through_date,
                number_of_users = param.number_of_users,
                serial_number = param.serial_number,
                reference_number = param.reference_number,
                reference_name = param.reference_name,
                contract_id = param.contract_id == 0 ? null : param.contract_id,
                location = param.location,
                contact_id = param.contact_id == 0 ? null : param.contact_id,
                vendor_account_id = param.vendor_id == 0 ? null : param.vendor_id,
                is_active = (sbyte)param.status,
                installed_resource_id = user.id,
                remark = param.notes,
                contract_cost_id = param.contract_cost_id,
                // installed_contact_id = param.contact_id, // todo -- 安装人与联系人

                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                create_user_id = user.id,
                update_user_id = user.id,
                // Terms
                hourly_cost = param.terms.hourly_cost,
                daily_cost = param.terms.daily_cost,
                monthly_cost = param.terms.monthly_cost,
                setup_fee = param.terms.setup_fee,
                peruse_cost = param.terms.peruse_cost,
                accounting_link = param.terms.accounting_link,
                reviewed_for_contract = param.reviewByContract

            };   // 创建配置项对象

            if (param.service_id != null)
            {
                var ser = new ctt_contract_service_dal().FindNoDeleteById((long)param.service_id);
                if (ser != null)
                {
                    if (ser.object_type == 1)
                    {
                        installed_product.service_id = ser.object_id;
                    }
                    else if (ser.object_type == 2)
                    {
                        installed_product.service_bundle_id = ser.object_id;
                    }
                }
                else
                {

                }
            }
            installed_product_dal.Insert(installed_product);                            // 插入配置项
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONFIGURAITEM,
                oper_object_id = installed_product.id,
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = installed_product_dal.AddValue(installed_product),
                remark = "新增配置项",
            });                       // 插入操作日志
            param.id = installed_product.id;

            var udf_configuration_items_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONFIGURATION_ITEMS);   // 查询自定义信息
            var udf_configuration_items = param.udf;
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.CONFIGURATION_ITEMS, user.id, installed_product.id, udf_configuration_items_list, udf_configuration_items, OPER_LOG_OBJ_CATE.CONFIGURAITEM);  // 保存自定义扩展信息

            #endregion

            #region 2.保存通知
            //var notify_email_dal = new com_notify_email_dal();
            //var notify_email = new com_notify_email()
            //{
            //    id = notify_email_dal.GetNextIdCom(),
            //    cate_id = (int)NOTIFY_CATE.CRM,
            //    event_id = 1,             // todo
            //    to_email = param.notice.contacts,                  // 接受人地址？？联系人地址   
            //    notify_tmpl_id = param.notice.notification_template,
            //    from_email = user.email,   // todo
            //    from_email_name = user.name,  // todo 
            //    subject = param.notice.subject,
            //    body_text = param.notice.additional_email_text,    // 附加信息？？
            //    is_html_format = 0,                                // 内容是否是html格式，0纯文本 1html
            //    create_user_id = user.id,
            //    update_user_id = user.id,
            //    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),

            //};
            //notify_email_dal.Insert(notify_email);
            //new sys_oper_log_dal().Insert(new sys_oper_log()
            //{
            //    user_cate = "用户",
            //    user_id = user.id,
            //    name = user.name,
            //    phone = user.mobile == null ? "" : user.mobile,
            //    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
            //    oper_object_id = notify_email.id,
            //    oper_type_id = (int)OPER_LOG_TYPE.ADD,
            //    oper_description = installed_product_dal.AddValue(notify_email),
            //    remark = "新增通知",
            //});  // 插入日志

            #endregion
            #region 更新客户最后活动时间
            if (installed_product.account_id != null)
            {
                crm_account thisAccount = new CompanyBLL().GetCompany((long)installed_product.account_id);
                if (thisAccount != null) { thisAccount.last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now); new CompanyBLL().EditAccount(thisAccount, user_id); }
            }
            #endregion
            return true;
        }

        public bool EditConfigurationItem(ConfigurationItemAddDto param, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            var installed_product_dal = new crm_installed_product_dal();

            var old_installed_product = installed_product_dal.GetInstalledProduct(param.id);
            if (old_installed_product == null)
            {
                return false;
            }
            #region 页面参数
            var installed_product = installed_product_dal.GetInstalledProduct(param.id);
            installed_product.product_id = param.product_id;
            installed_product.cate_id = param.installed_product_cate_id;
            installed_product.account_id = param.account_id;
            installed_product.start_date = param.start_date;
            installed_product.through_date = param.through_date;
            installed_product.number_of_users = param.number_of_users;
            installed_product.serial_number = param.serial_number;
            installed_product.reference_number = param.reference_number;
            installed_product.reference_name = param.reference_name;
            installed_product.contract_id = param.contract_id == 0 ? null : (long?)param.contract_id;
            installed_product.location = param.location;
            installed_product.contact_id = param.contact_id == 0 ? null : (long?)param.contact_id;
            installed_product.vendor_account_id = param.vendor_id == 0 ? null : (long?)param.vendor_id;
            installed_product.is_active = (sbyte)param.status;
            installed_product.installed_resource_id = user.id;
            installed_product.reviewed_for_contract = param.reviewByContract;
            // installed_contact_id = param.contact_id, // todo -- 安装人与联系人
            installed_product.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            installed_product.update_user_id = user.id;
            installed_product.remark = param.notes;
            //service_id = param.service_id,
            // Terms
            installed_product.hourly_cost = param.terms.hourly_cost;
            installed_product.daily_cost = param.terms.daily_cost;
            installed_product.monthly_cost = param.terms.monthly_cost;
            installed_product.setup_fee = param.terms.setup_fee;
            installed_product.peruse_cost = param.terms.peruse_cost;
            installed_product.accounting_link = param.terms.accounting_link;

            #endregion
            // 创建配置项对象
            if (param.service_id != null)
            {
                var ser = new ctt_contract_service_dal().FindNoDeleteById((long)param.service_id);
                if (ser != null)
                {
                    if (ser.object_type == 1)
                    {
                        installed_product.service_id = ser.object_id;
                        installed_product.service_bundle_id = null;
                    }
                    else if (ser.object_type == 2)
                    {
                        installed_product.service_bundle_id = ser.object_id;
                        installed_product.service_id = null;
                    }
                    else
                    {
                        installed_product.service_bundle_id = null;
                        installed_product.service_id = null;
                    }
                }
            }
            else
            {
                installed_product.service_bundle_id = null;
                installed_product.service_id = null;
            }
            installed_product_dal.Update(installed_product);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONFIGURAITEM,
                oper_object_id = installed_product.id,
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = installed_product_dal.CompareValue(old_installed_product, installed_product),
                remark = "修改配置项相关信息",
            });                       // 插入操作日志

            var udf_configuration_items_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONFIGURATION_ITEMS);   // 查询自定义信息
            var udf_configuration_items = param.udf;
            new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.CONFIGURATION_ITEMS, udf_configuration_items_list, installed_product.id, udf_configuration_items, user, OPER_LOG_OBJ_CATE.CONFIGURAITEM);  // 保存自定义扩展信息



            return true;
        }

        /// <summary>
        /// 新增订阅
        /// </summary>
        /// <param name="subscription"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE SubscriptiomInsert(crm_subscription subscription, long user_id)
        {
            if (string.IsNullOrEmpty(subscription.name))
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            if (subscription.period_type_id == 0)
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            #region 插入订阅相关信息
            subscription.id = _dal.GetNextIdCom();
            subscription.create_user_id = user.id;
            subscription.update_user_id = user.id;
            subscription.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            subscription.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

            new crm_subscription_dal().Insert(subscription);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SUBSCRIPTION,
                oper_object_id = subscription.id,
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(subscription),
                remark = "新增订阅",
            });
            #endregion

            #region 插入订阅分期信息

            InsertSubPeriod(subscription.effective_date, subscription.expiration_date, subscription, user);

            #endregion

            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 根据订阅的开始时间和结束时间  循环插入分期订阅
        /// </summary>
        /// <param name="firstTime"></param>
        /// <param name="lastTime"></param>
        /// <param name="subscription"></param>
        /// <param name="user"></param>
        public void InsertSubPeriod(DateTime firstTime, DateTime lastTime, crm_subscription subscription, UserInfoDto user)
        {
            var periods = 1;   // 定义初始的期数为1 
            //var firstTime = subscription.effective_date; // 生效日期
            //var lastTime = subscription.expiration_date; // 结束日期
            // var period_type = subscription.period_type_id;
            var days = Math.Ceiling((lastTime - firstTime).TotalDays); // 获取到相差几天

            var months = (lastTime.Year - firstTime.Year) * 12 + (lastTime.Month - firstTime.Month) + (lastTime.Day >= firstTime.Day ? 1 : 0);
            decimal periodMonths = 1;
            decimal period = 1;
            decimal dayMoney = subscription.period_price;  // 
            switch (subscription.period_type_id)
            {
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                    periods = Convert.ToInt32(Math.Ceiling(days / 180));
                    periodMonths = 6;
                    break;
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                    periods = Convert.ToInt32(Math.Ceiling(days / 30));
                    periodMonths = 1;
                    break;
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                    periods = Convert.ToInt32(Math.Ceiling(days / 90));
                    periodMonths = 3;
                    break;
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                    periods = Convert.ToInt32(Math.Ceiling(days / 365));
                    periodMonths = 12;
                    break;
                default:
                    break;
            }
            period = Math.Ceiling(months / periodMonths);
            var sub_period_dal = new crm_subscription_period_dal();
            for (int i = 0; i < period; i++)
            {
                crm_subscription_period sub_period = new crm_subscription_period()
                {
                    id = sub_period_dal.GetNextIdCom(),
                    subscription_id = subscription.id,
                    period_date = firstTime,
                    period_price = subscription.period_price,

                };
                if (i == period - 1)
                {
                    var diffDays = GetDiffDay(firstTime, subscription.expiration_date);
                    switch (subscription.period_type_id)
                    {
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                            var halfYearDay = GetDiffDay(firstTime, firstTime.AddMonths(6));
                            sub_period.period_price = (sub_period.period_price / halfYearDay) * diffDays;
                            break;
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                            var monthDay = GetDiffDay(firstTime, firstTime.AddMonths(1));
                            sub_period.period_price = (sub_period.period_price / monthDay) * diffDays;
                            break;
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                            var quarterDay = GetDiffDay(firstTime, firstTime.AddMonths(3));
                            sub_period.period_price = (sub_period.period_price / quarterDay) * diffDays;
                            break;
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                            var yearDay = GetDiffDay(firstTime, firstTime.AddYears(1));
                            sub_period.period_price = (sub_period.period_price / yearDay) * diffDays;
                            break;
                        default:
                            break;
                    }
                }
                sub_period_dal.Insert(sub_period);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SUBSCRIPTION,
                    oper_object_id = sub_period.id,
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(sub_period),
                    remark = "新增分期订阅",
                });
                firstTime = firstTime.AddMonths((int)periodMonths);

            }

        }
        /// <summary>
        /// 获取两个时间相差天数
        /// </summary>
        public int GetDiffDay(DateTime startDate, DateTime endDate)
        {
            TimeSpan ts1 = new TimeSpan(startDate.Ticks);
            TimeSpan ts2 = new TimeSpan(endDate.Ticks);
            var diffDays = ts1.Subtract(ts2).Duration().Days + 1;
            return diffDays;
        }

        /// <summary>
        /// 编辑订阅
        /// </summary>
        /// <param name="subscription"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE SubscriptiomEdit(crm_subscription subscription, long user_id)
        {
            if (string.IsNullOrEmpty(subscription.name))
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            if (subscription.period_cost == null || subscription.period_type_id == 0)
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;

            var old_subscription = new crm_subscription_dal().GetSubscription(subscription.id);
            var old_last_time = old_subscription.expiration_date;  // 获取到旧的过期时间
            var new_last_time = subscription.expiration_date;      // 获取到新设定的过期时间
            subscription.oid = old_subscription.oid;
            subscription.create_time = old_subscription.create_time;
            subscription.create_user_id = old_subscription.create_user_id;
            subscription.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            subscription.update_user_id = user.id;

            new crm_subscription_dal().Update(subscription);

            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SUBSCRIPTION,
                oper_object_id = subscription.id,
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old_subscription, subscription),
                remark = "修改订阅相关信息",
            });


            var subPeriodList = new crm_subscription_period_dal().GetSubPeriodByWhere($" and subscription_id = {subscription.id}");


            // 生效日期改变，代表分期订阅均未
            if (!old_subscription.effective_date.ToString("yyyy-MM-dd").Equals(subscription.effective_date.ToString("yyyy-MM-dd")))
            {
                if (subPeriodList != null && subPeriodList.Count > 0)
                {
                    subPeriodList.ForEach(_ =>
                    {
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONFIGURAITEM,
                            oper_object_id = _.id,
                            oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                            oper_description = new crm_installed_product_dal().AddValue(_),
                            remark = "删除分期订阅",
                        });
                        new crm_subscription_period_dal().Delete(_);
                    });
                }
                InsertSubPeriod(subscription.effective_date, subscription.expiration_date, subscription, user);
            }
            else
            {
                if (!old_last_time.ToString("yyyy-MM-dd").Equals(new_last_time.ToString("yyyy-MM-dd")))
                {

                    // 暂时这样处理：修改时周期类型不可更改，根据最后的时间去新增或者删除，或者更改这些分期订阅
                    // 修改时的订阅分期管理-- todo 

                    if (subPeriodList != null && subPeriodList.Count > 0)
                    {
                        //  先写点逻辑吧QAQ
                        //  首先后获取到所有的分期订阅 -- 
                        //  已经审核过的订阅暂不处理
                        //  获取到未审核的分期订阅去删除掉
                        //  根据新的到期时间去创建新的订阅
                        //  那么问题来了，如果是最后一期订阅？？

                        var NoDealSub = subPeriodList.Where(_ => _.approve_and_post_user_id == null && _.approve_and_post_date == null).ToList(); // 获取到还未处理的订阅

                        var periodMonths = 0;
                        switch (subscription.period_type_id)
                        {
                            case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                                periodMonths = 6;
                                break;
                            case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                                periodMonths = 1;
                                break;
                            case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                                periodMonths = 3;
                                break;
                            case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                                periodMonths = 12;
                                break;
                            default:
                                break;
                        }
                        //  获取到最后的生效时间
                        var dealSub = subPeriodList.Where(_ => _.approve_and_post_user_id != null && _.approve_and_post_date != null).ToList();
                        if (dealSub != null && dealSub.Count > 0)
                        {
                            old_last_time = dealSub.Max(_ => _.period_date);
                        }

                        // 删除未执行的分期订阅
                        if (NoDealSub != null && NoDealSub.Count > 0)
                        {
                            NoDealSub.ForEach(_ =>
                            {
                                new sys_oper_log_dal().Insert(new sys_oper_log()
                                {
                                    user_cate = "用户",
                                    user_id = user.id,
                                    name = user.name,
                                    phone = user.mobile == null ? "" : user.mobile,
                                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONFIGURAITEM,
                                    oper_object_id = _.id,
                                    oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                                    oper_description = new crm_installed_product_dal().AddValue(_),
                                    remark = "删除分期订阅",
                                });
                                new crm_subscription_period_dal().Delete(_);
                            });
                        }

                        if (old_last_time < new_last_time)
                        {
                            old_last_time = old_last_time.AddMonths(periodMonths);
                            if (new_last_time < old_last_time) // 代表结束时间在最后一期分期订阅的范围之内,暂不处理吧QAQ --todo
                            {

                            }
                            else
                            {
                                InsertSubPeriod(old_last_time, new_last_time, subscription, user);
                            }
                        }
                        else
                        {
                            InsertSubPeriod(old_last_time, new_last_time, subscription, user);
                        }

                    }

                }
            }







            return ERROR_CODE.SUCCESS;
        }



        /// <summary>
        /// 激活/失活当前的配置项
        /// </summary>
        /// <param name="iProduct_id"></param>
        /// <param name="user_id"></param>
        /// <param name="isActive"></param>
        /// <returns></returns>
        public string ActivationInstalledProduct(long iProduct_id, long user_id, bool isActive)
        {


            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var dal = new crm_installed_product_dal();
            var iProduct = dal.GetInstalledProduct(iProduct_id);
            if (iProduct != null)
            {

                if (iProduct.is_active == (isActive ? 0 : 1))
                {
                    iProduct.is_active = (sbyte)(isActive ? 1 : 0);
                    iProduct.update_user_id = user.id;
                    iProduct.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONFIGURAITEM,
                        oper_object_id = iProduct.id,
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = dal.CompareValue(new crm_installed_product_dal().GetInstalledProduct(iProduct_id), iProduct),
                        remark = (isActive ? "激活" : "停用") + "配置项",
                    });
                    dal.Update(iProduct);
                    return "ok";
                }
                else
                {
                    return "no";
                }
            }
            return "";
        }

        /// <summary>
        /// 批量激活/失活配置项
        /// </summary>
        /// <param name="ids"></param>
        /// <param name="user_id"></param>
        /// <param name="isActive"></param>
        /// <returns></returns>
        public bool AvtiveManyIProduct(string ids, long user_id, bool isActive)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var dal = new crm_installed_product_dal();
            if (!string.IsNullOrEmpty(ids))
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                    ActivationInstalledProduct(long.Parse(id), user_id, isActive);
                }
                return true;
            }
            return false;
        }
        /// <summary>
        /// 删除配置项
        /// </summary>
        /// <param name="iProduct_id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool DeleteIProduct(long iProduct_id, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            var IProduct = new crm_installed_product_dal().GetInstalledProduct(iProduct_id);
            if (IProduct != null)
            {
                IProduct.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                IProduct.delete_user_id = user.id;

                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONFIGURAITEM,
                    oper_object_id = IProduct.id,
                    oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                    oper_description = new crm_installed_product_dal().CompareValue(new crm_installed_product_dal().GetInstalledProduct(iProduct_id), IProduct),
                    remark = "删除配置项",
                });
                new crm_installed_product_dal().Update(IProduct);

                return true;
            }

            return false;
        }
        /// <summary>
        /// 批量删除配置项
        /// </summary>
        /// <param name="ids"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool DeleteIProducts(string ids, long user_id)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var dal = new crm_installed_product_dal();
            if (!string.IsNullOrEmpty(ids))
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                    DeleteIProduct(long.Parse(id), user_id);
                }
                return true;
            }
            return false;
        }
        /// <summary>
        /// 激活/失活 订阅
        /// </summary>
        /// <param name="sid"></param>
        /// <param name="user_id"></param>
        /// <param name="isActive"></param>
        /// <returns></returns>
        public string ActiveSubsctiption(long sid, long user_id, int status_id)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var dal = new crm_subscription_dal();
            var subscription = dal.GetSubscription(sid);
            if (subscription != null)
            {
                if (subscription.status_id != status_id)
                {
                    subscription.status_id = status_id;
                    subscription.update_user_id = user.id;
                    subscription.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONFIGURAITEM,
                        oper_object_id = subscription.id,
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = dal.CompareValue(dal.GetSubscription(sid), subscription),
                        remark = "更改订阅状态",
                    });
                    dal.Update(subscription);
                    return "ok";
                }
                else
                {
                    return "Already";
                }
            }
            return "error";
        }
        /// <summary>
        /// 批量激活/失活 订阅
        /// </summary>
        /// <param name="ids"></param>
        /// <param name="user_id"></param>
        /// <param name="isActive"></param>
        /// <returns></returns>
        public bool ActiveSubsctiptions(string ids, long user_id, int status_id)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            if (!string.IsNullOrEmpty(ids) && user != null)
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                    ActiveSubsctiption(long.Parse(id), user_id, status_id);
                }
                return true;
            }
            return false;
        }

        /// <summary>
        /// 删除订阅
        /// </summary>
        /// <param name="sid"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool DeleteSubsctiption(long sid, long user_id)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var sDal = new crm_subscription_dal();
            var subscription = sDal.GetSubscription(sid);
            if (subscription != null && user != null)
            {
                //subsctiption.delete_user_id = user.id;
                //subsctiption.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                sDal.SoftDelete(subscription, user.id);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SUBSCRIPTION,
                    oper_object_id = subscription.id,
                    oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                    oper_description = sDal.AddValue(subscription),
                    remark = "删除订阅",
                });
            }

            return false;
        }

        /// <summary>
        /// 批量删除订阅
        /// </summary>
        /// <param name="sids"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool DeleteSubsctiptions(string sids, long user_id)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            if (!string.IsNullOrEmpty(sids))
            {
                try
                {
                    var idList = sids.Split(',');
                    foreach (var id in idList)
                    {
                        DeleteSubsctiption(long.Parse(id), user_id);
                    }
                    return true;
                }
                catch (Exception)
                {

                    return false;
                }

            }
            return false;
        }

        /// <summary>
        /// 解除配置项与合同的绑定
        /// </summary>
        /// <param name="contract_id"></param>
        /// <param name="ipID"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool RelieveInsProduct(long contract_id, long ip_id, long user_id)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var insPro = _dal.FindNoDeleteById(ip_id);
            if (user != null && insPro != null)
            {
                insPro.contract_id = null;
                insPro.service_id = null;
                insPro.service_bundle_id = null;
                insPro.update_user_id = user.id;
                insPro.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONFIGURAITEM,
                    oper_object_id = insPro.id,
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.CompareValue(_dal.FindNoDeleteById(insPro.id), insPro),
                    remark = "解除配置项与合同的绑定",
                });
                _dal.Update(insPro);
                return true;
            }
            return false;
        }
        /// <summary>
        /// 将配置项绑定到合同
        /// </summary>
        /// <param name="contract_id"></param>
        /// <param name="ipID"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool RelationInsProduct(long contract_id, long ip_id, long user_id, long? service_id = null)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var insPro = _dal.FindNoDeleteById(ip_id);
            if (user != null && insPro != null)
            {
                // isServiceOrBag
                insPro.contract_id = contract_id;
                insPro.update_user_id = user.id;
                insPro.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                if (service_id != null)
                {
                    var isService = new OpportunityBLL().isServiceOrBag((long)service_id);
                    if (isService == 1)
                    {
                        insPro.service_id = service_id;
                    }
                    else if (isService == 2)
                    {
                        insPro.service_bundle_id = service_id;
                    }
                }
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONFIGURAITEM,
                    oper_object_id = insPro.id,
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.CompareValue(_dal.FindNoDeleteById(insPro.id), insPro),
                    remark = "关联当前合同",
                });
                _dal.Update(insPro);
                return true;
            }

            return false;
        }

        /// <summary>
        /// 通过报价生成配置项
        /// </summary>
        public bool AddInsProByQuote(QuoteConfigItemDto param, long user_id)
        {
            var cipDal = new crm_installed_product_dal();
            var cqiDal = new crm_quote_item_dal();
            var ipDal = new ivt_product_dal();
            var ipvDal = new ivt_product_vendor_dal();
            var csDal = new crm_subscription_dal();
            var quote = new crm_quote_dal().FindNoDeleteById(param.quote_id);
            if (quote == null)
            {
                return false;
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (param.insProList != null && param.insProList.Count > 0)
            {
                foreach (var insPro in param.insProList)
                {
                    #region  产品转配置项相关
                    var thisItem = cqiDal.FindNoDeleteById(insPro.itemId);
                    if (thisItem == null)
                    {
                        continue;
                    }
                    var thisProduct = ipDal.FindNoDeleteById((long)thisItem.object_id);
                    if (thisProduct == null)
                    {
                        continue;
                    }
                    var defaultVendor = ipvDal.GetDefault(thisProduct.id);


                    crm_installed_product installed_product = new crm_installed_product()
                    {
                        id = cipDal.GetNextIdCom(),
                        product_id = (long)thisItem.object_id,
                        cate_id = thisProduct.installed_product_cate_id,
                        account_id = quote.account_id,
                        start_date = insPro.insDate,
                        through_date = insPro.expDate,
                        number_of_users = null,
                        serial_number = insPro.serNumber,
                        reference_number = insPro.refNumber,
                        reference_name = insPro.refName,
                        contract_id = null,
                        location = null,
                        contact_id = null,
                        vendor_account_id = defaultVendor == null ? null : defaultVendor.vendor_account_id,
                        is_active = 1,
                        installed_resource_id = user_id,
                        remark = "从报价项中生成",
                        quote_item_id = insPro.itemId,
                        // installed_contact_id = param.contact_id, // todo -- 安装人与联系人

                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        create_user_id = user_id,
                        update_user_id = user_id,


                    };   // 创建配置项对象
                    cipDal.Insert(installed_product);                            // 插入配置项

                    OperLogBLL.OperLogAdd<crm_installed_product>(installed_product, installed_product.id, user_id, OPER_LOG_OBJ_CATE.CONFIGURAITEM, "新增配置项");

                    var udf_configuration_items_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONFIGURATION_ITEMS);   // 查询自定义信息
                    new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.CONFIGURATION_ITEMS, user_id, installed_product.id, udf_configuration_items_list, null, OPER_LOG_OBJ_CATE.CONFIGURAITEM);  // 保存自定义扩展信息
                    #endregion

                    if (param.insProSubList != null && param.insProSubList.Count > 0)
                    {
                        var thisSub = param.insProSubList.FirstOrDefault(_ => _.insProId == insPro.pageProId);
                        if (thisSub != null)
                        {
                            var sub = new crm_subscription()
                            {
                                id = csDal.GetNextIdCom(),
                                name = thisSub.subName,
                                description = thisSub.subDes,
                                period_type_id = thisSub.perType,
                                effective_date = thisSub.effDate,
                                expiration_date = thisSub.expDate,
                                period_price = thisSub.sunPerPrice,
                                cost_code_id = thisProduct.cost_code_id,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                create_user_id = user_id,
                                update_user_id = user_id,
                                installed_product_id = installed_product.id,
                                status_id = 1,
                                period_cost = thisProduct.unit_cost,
                            };

                            var periods = 1;   // 定义初始的期数为1 
                            var firstTime = sub.effective_date; // 生效日期
                            var lastTime = sub.expiration_date; // 结束日期
                            var period_type = sub.period_type_id;
                            var days = Math.Ceiling((lastTime - firstTime).TotalDays); // 获取到相差几天

                            var months = (lastTime.Year - firstTime.Year) * 12 + (lastTime.Month - firstTime.Month) + (lastTime.Day >= firstTime.Day ? 1 : 0);
                            decimal periodMonths = 1;
                            decimal period = 1;
                            switch (sub.period_type_id)
                            {
                                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                                    periods = Convert.ToInt32(Math.Ceiling(days / 180));
                                    periodMonths = 6;
                                    break;
                                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                                    periods = Convert.ToInt32(Math.Ceiling(days / 30));
                                    periodMonths = 1;
                                    break;
                                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                                    periods = Convert.ToInt32(Math.Ceiling(days / 90));
                                    periodMonths = 3;
                                    break;
                                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                                    periods = Convert.ToInt32(Math.Ceiling(days / 365));
                                    periodMonths = 12;
                                    break;
                                default:
                                    break;
                            }
                            period = Math.Ceiling(months / periodMonths);
                            sub.total_price = sub.period_price * period;
                            sub.total_cost = sub.period_cost * period;
                            csDal.Insert(sub);
                            OperLogBLL.OperLogAdd<crm_subscription>(sub, sub.id, user_id, OPER_LOG_OBJ_CATE.SUBSCRIPTION, "新增订阅");
                            InsertSubPeriod(sub.effective_date, sub.expiration_date, sub, user);
                        }
                    }
                }
            }
            if (param.insChargeList != null && param.insChargeList.Count > 0)
            {
                foreach (var insPro in param.insChargeList)
                {
                    var thisItem = cqiDal.FindNoDeleteById(insPro.itemId);
                    if (thisItem == null)
                    {
                        continue;
                    }
                    ivt_product thisProduct = null;
                    ivt_product_vendor defaultVendor = null;
                    if (insPro.productId != null)
                    {
                        thisProduct = ipDal.FindNoDeleteById((long)insPro.productId);
                        if (thisProduct == null)
                        {
                            continue;
                        }
                        defaultVendor = ipvDal.GetDefault(thisProduct.id);
                    }
                    if (thisProduct == null)
                    {
                        continue;
                    }
                    crm_installed_product installed_product = new crm_installed_product()
                    {
                        id = cipDal.GetNextIdCom(),
                        product_id = thisProduct.id,
                        cate_id = thisProduct.installed_product_cate_id,
                        account_id = quote.account_id,
                        start_date = insPro.insDate,
                        through_date = insPro.warExpDate,
                        number_of_users = null,
                        serial_number = insPro.serNumber,
                        reference_number = insPro.refNumber,
                        reference_name = insPro.refName,
                        contract_id = null,
                        location = null,
                        contact_id = null,
                        vendor_account_id = defaultVendor == null ? null : defaultVendor.vendor_account_id,
                        is_active = 1,
                        installed_resource_id = user_id,
                        remark = "从报价项中生成",
                        quote_item_id = insPro.itemId,
                        // installed_contact_id = param.contact_id, // todo -- 安装人与联系人

                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        create_user_id = user_id,
                        update_user_id = user_id,


                    };   // 创建配置项对象
                    cipDal.Insert(installed_product);                            // 插入配置项

                    OperLogBLL.OperLogAdd<crm_installed_product>(installed_product, installed_product.id, user_id, OPER_LOG_OBJ_CATE.CONFIGURAITEM, "新增配置项");
                }
            }

            return true;
        }
        /// <summary>
        /// 获取到合同下的对应服务的已绑定配置项数量
        /// </summary>
        public int GetExistInsServiceCount(long contractId, long serviceId)
        {
            return Convert.ToInt32(_dal.GetSingle($"SELECT COUNT(*) from crm_installed_product where delete_time = 0 and contract_id = {contractId} and (service_id = {serviceId} or service_bundle_id = {serviceId})"));
            //
        }
        /// <summary>
        /// 设置父配置项
        /// </summary>
        public bool SetAsParent(long thisId, long parentId, long userId)
        {
            var parInsPro = _dal.FindNoDeleteById(parentId);
            var thisInsPro = _dal.FindNoDeleteById(thisId);
            if (thisInsPro == null || parInsPro == null)
                return false;
            var oldThisPro = _dal.FindNoDeleteById(thisId);
            if (thisInsPro.parent_id != parentId)
            {
                thisInsPro.parent_id = parentId;
                thisInsPro.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisInsPro.update_user_id = userId;
                _dal.Update(thisInsPro);
                OperLogBLL.OperLogUpdate<crm_installed_product>(thisInsPro, oldThisPro, thisId, userId, OPER_LOG_OBJ_CATE.CONFIGURAITEM, "");
            }
            return true;
        }
        /// <summary>
        /// 取消父配置项设置
        /// </summary>
        public bool RemoveParent(long thisId, long userId)
        {
            var thisPro = _dal.FindNoDeleteById(thisId);
            if (thisPro == null || thisPro.parent_id == null)
                return false;
            var oldPro = _dal.FindNoDeleteById(thisId);
            thisPro.parent_id = null;
            thisPro.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisPro.update_user_id = userId;
            _dal.Update(thisPro);
            OperLogBLL.OperLogUpdate<crm_installed_product>(thisPro, oldPro, thisId, userId, OPER_LOG_OBJ_CATE.CONFIGURAITEM, "");
            return true;
        }
        /// <summary>
        /// 配置项替换
        /// </summary>
        public bool SwapConfigItem(SwapConfigItemDto param, long userId)
        {
            var outInsPro = _dal.FindNoDeleteById(param.outSwapId);
            var thisUser = new sys_resource_dal().FindNoDeleteById(userId);
            if (outInsPro == null)
                return false;
            var ipDal = new ivt_product_dal();
            ivt_product oldProduct = ipDal.FindById(outInsPro.product_id);
            if (oldProduct == null)
                return false;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var oldOutInsPro = _dal.FindNoDeleteById(param.outSwapId);
            outInsPro.is_active = 0;
            outInsPro.is_swapped_out = 1;
            outInsPro.contract_id = null;
            outInsPro.remark += $"此配置项由{thisUser.name}于{DateTime.Now.Year}年{DateTime.Now.Month}月{DateTime.Now.Day}日换出";
            outInsPro.update_time = timeNow;
            outInsPro.update_user_id = userId;
            #region 新增配置项
            crm_installed_product newConfigItem = null;
            string newWareName = string.Empty;
            if (param.inWareProId != null)
            {
                var iwpDal = new ivt_warehouse_product_dal();
                var wareProduct = iwpDal.FindNoDeleteById((long)param.inWareProId);
               
                ivt_warehouse_product_sn sn = null;

                if (param.inWareProSnId != null)
                    sn = new ivt_warehouse_product_sn_dal().FindNoDeleteById((long)param.inWareProSnId);
                if (wareProduct != null)
                {
                    ivt_product inProduct = ipDal.FindNoDeleteById(wareProduct.product_id);
                    if(wareProduct.warehouse_id!=null)
                    {
                        ivt_warehouse ware = new ivt_warehouse_dal().FindNoDeleteById((long)wareProduct.warehouse_id);
                        if (ware != null)
                            newWareName = ware.name;
                    }
                    
                    newConfigItem = new crm_installed_product()
                    {
                        id = _dal.GetNextIdCom(),
                        product_id = wareProduct.product_id,
                        is_active = 1,
                        installed_resource_id = userId,
                        start_date = DateTime.Now,
                        through_date = DateTime.Now.AddYears(1),
                        remark = oldOutInsPro.remark + $"此配置项由{thisUser.name}于{DateTime.Now.Year}年{DateTime.Now.Month}月{DateTime.Now.Day}日创建，用来替换配置项" + oldProduct.name,
                        account_id = outInsPro.account_id,
                        contact_id = outInsPro.contact_id,
                        location = outInsPro.location,
                        contract_id = outInsPro.contract_id,
                        service_id = outInsPro.service_id,
                        service_bundle_id = outInsPro.service_bundle_id,
                        vendor_account_id = null,
                        hourly_cost = outInsPro.hourly_cost,
                        daily_cost = outInsPro.daily_cost,
                        monthly_cost = outInsPro.monthly_cost,
                        setup_fee = outInsPro.setup_fee,
                        peruse_cost = outInsPro.peruse_cost,
                        accounting_link = outInsPro.accounting_link,
                        cate_id = outInsPro.cate_id,
                        create_time = timeNow,
                        update_time = timeNow,
                        create_user_id = userId,
                        update_user_id = userId,
                        reviewed_for_contract = (sbyte)(outInsPro.contract_id == null ? 0 : 1),
                    };
                    if (sn != null)
                        newConfigItem.serial_number = sn.sn;
                    _dal.Insert(newConfigItem);
                    OperLogBLL.OperLogAdd<crm_installed_product>(newConfigItem, newConfigItem.id, userId, OPER_LOG_OBJ_CATE.CONFIGURAITEM, "");
                    outInsPro.remark += ",它被替换为配置项" + (inProduct != null ? inProduct.name : "");
                    ChangeSubInsProId(outInsPro.id, newConfigItem.id, userId);
                }
            }
            #endregion
            _dal.Update(outInsPro);
            OperLogBLL.OperLogUpdate<crm_installed_product>(outInsPro, oldOutInsPro, outInsPro.id, userId, OPER_LOG_OBJ_CATE.CONFIGURAITEM, "");

            #region 工单处理
            ConfigTicketDeal(outInsPro, newConfigItem, newWareName, param.ticketList,userId);
            #endregion

            #region 库存处理
            ConfigItemTransfer(param, outInsPro, userId);
            #endregion

            #region 通知
            #endregion



            return true;
        }
        /// <summary>
        /// 更换未审批提交的订阅 的配置项
        /// </summary>
        public void ChangeSubInsProId(long oldInsProId, long newInsProId, long userId)
        {
            crm_subscription_dal csDal = new crm_subscription_dal();
            var newInsPro = _dal.FindNoDeleteById(newInsProId);
            if (newInsPro == null)
                return;
            var thisSubAllList = csDal.GetSubByInsProId(oldInsProId);
            if (thisSubAllList != null && thisSubAllList.Count > 0)
            {
                var subList = ReturnSubIds(thisSubAllList);
                if (subList != null && subList.Count > 0)
                {
                    var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    subList.ForEach(_ =>
                    {
                        var oldSub = csDal.FindNoDeleteById(_.id);
                        if (oldSub != null)
                        {
                            _.update_time = timeNow;
                            _.update_user_id = userId;
                            _.installed_product_id = newInsProId;
                            csDal.Update(_);
                            OperLogBLL.OperLogUpdate<crm_subscription>(_, oldSub, _.id, userId, OPER_LOG_OBJ_CATE.SUBSCRIPTION, "");
                        }
                    });
                }
            }
        }
        /// <summary>
        /// 配置项的工单处理
        /// </summary>
        public void ConfigTicketDeal(crm_installed_product oldInsPro, crm_installed_product newInsPro,string newWareName, Dictionary<long, string> ticketDic, long userId)
        {
            if (ticketDic != null && ticketDic.Count > 0)
            {
                sdk_task_dal stDal = new sdk_task_dal();
                ivt_product_dal ipDal = new ivt_product_dal();
                com_activity_dal actDal = new com_activity_dal();
                TicketBLL ticBll = new TicketBLL();
                var oldProduct = ipDal.FindById(oldInsPro.product_id);
                foreach (var thisTicket in ticketDic)
                {
                    sdk_task ticket = stDal.FindNoDeleteById(thisTicket.Key);
                    if (ticket == null|| thisTicket.Value == "nothing")
                        continue;
                    else if (thisTicket.Value == "asgin")
                    {
                        if (newInsPro != null)
                        {
                            var newProduct = ipDal.FindById(newInsPro.product_id);
                            ticket.installed_product_id = newInsPro.id;
                            ticBll.EditTicket(ticket, userId);
                            com_activity note = new com_activity()
                            {
                                id = _dal.GetNextIdCom(),
                                cate_id = (int)DicEnum.ACTIVITY_CATE.TICKET_NOTE,
                                action_type_id = (int)ACTIVITY_TYPE.TASK_INFO,
                                object_id = ticket.id,
                                object_type_id = (int)OBJECT_TYPE.TICKETS,
                                account_id = ticket.account_id,
                                contact_id = ticket.contact_id,
                                name = "配置项换出"+(oldProduct!=null? oldProduct.name:""),
                                description = $"换出配置项:{(oldProduct != null ? oldProduct.name : "")}/r序列号：{oldInsPro.serial_number}/r参考号：{oldInsPro.reference_number}/r参考名：{oldInsPro.reference_name}/r/r换入配置项：{(newProduct != null ? newProduct.name : "")}/r库存地点：{newWareName},序列号:{newInsPro.serial_number}",
                                publish_type_id = (int)NOTE_PUBLISH_TYPE.TICKET_ALL_USER,
                                ticket_id = ticket.id,
                                create_user_id = 0,
                                update_user_id = 0,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                is_system_generate = 1,
                            };
                            actDal.Insert(note);
                            OperLogBLL.OperLogAdd<com_activity>(note, note.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY,  "");
                        }
                    }
                    else if (thisTicket.Value == "complete")
                    {
                        ticket.status_id = (int)DicEnum.TICKET_STATUS.DONE;
                        ticBll.EditTicket(ticket, userId);
                        com_activity note = new com_activity()
                        {
                            id = _dal.GetNextIdCom(),
                            cate_id = (int)DicEnum.ACTIVITY_CATE.TICKET_NOTE,
                            action_type_id = (int)ACTIVITY_TYPE.TASK_INFO,
                            object_id = ticket.id,
                            object_type_id = (int)OBJECT_TYPE.TICKETS,
                            account_id = ticket.account_id,
                            contact_id = ticket.contact_id,
                            name = "配置项换出" + (oldProduct != null ? oldProduct.name : ""),
                            description = $"换出配置项:{(oldProduct != null ? oldProduct.name : "")}/r序列号：{oldInsPro.serial_number}/r参考号：{oldInsPro.reference_number}/r参考名：{oldInsPro.reference_name}",
                            publish_type_id = (int)NOTE_PUBLISH_TYPE.TICKET_ALL_USER,
                            ticket_id = ticket.id,
                            create_user_id = 0,
                            update_user_id = 0,
                            create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            is_system_generate = 1,
                        };
                        actDal.Insert(note);
                        OperLogBLL.OperLogAdd<com_activity>(note, note.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, "");
                    }
                }
            }
        }

        /// <summary>
        /// 替换配置项的库存管理
        /// </summary>
        public void ConfigItemTransfer(SwapConfigItemDto param,crm_installed_product insPro,long userId)
        {
            try
            {
                if (param.CkToWarehouse)
                {
                    crm_account thisAccount = new CompanyBLL().GetCompany((long)insPro.account_id);
                    ivt_transfer_dal itDal = new ivt_transfer_dal();
                    ivt_transfer_sn_dal itsDal = new ivt_transfer_sn_dal();
                    ivt_warehouse_dal iwDal = new ivt_warehouse_dal();
                    ivt_warehouse_product_dal iwpDal = new ivt_warehouse_product_dal();
                    ivt_warehouse_product_sn_dal iwpsDal = new ivt_warehouse_product_sn_dal();
                    var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    ivt_warehouse wareHouse = new ivt_warehouse();
                    ivt_warehouse_product warePro = null;
                    ivt_warehouse_product_sn wareProSn = null;


                    if (param.isExist)
                    {
                        warePro = iwpDal.FindNoDeleteById((long)param.existWareProId);
                        if (warePro != null)
                        {
                            wareHouse = iwDal.FindNoDeleteById((long)warePro.warehouse_id);
                            ivt_transfer existTrans = new ivt_transfer()
                            {
                                id = itDal.GetNextIdCom(),
                                create_time = timeNow,
                                update_time = timeNow,
                                create_user_id = userId,
                                update_user_id = userId,
                                type_id = (int)DicEnum.INVENTORY_TRANSFER_TYPE.TICKETS,
                                from_warehouse_id = wareHouse.id,
                                notes = "转给客户："+ thisAccount.name,
                                quantity = 1,
                                to_account_id = insPro.account_id,
                                product_id = warePro.product_id,
                            };
                            itDal.Insert(existTrans);


                            //if (param.existWareProSnId != null)
                            //    wareProSn = iwpsDal.FindNoDeleteById((long)param.existWareProSnId);
                            if (!string.IsNullOrEmpty(param.existWareProSn))
                                wareProSn = iwpsDal.GetSnByWareAndSn(warePro.id, param.existWareProSn);
                            
                            warePro.quantity += 1;
                            warePro.update_time = timeNow;
                            warePro.update_user_id = userId;
                            iwpDal.Update(warePro);
                            if (wareProSn == null)
                            {
                                wareProSn = new ivt_warehouse_product_sn()
                                {
                                    id = iwpsDal.GetNextIdCom(),
                                    create_time = timeNow,
                                    update_time = timeNow,
                                    create_user_id = userId,
                                    update_user_id = userId,
                                    sn = param.existWareProSn,
                                    warehouse_product_id = warePro.id,
                                };
                                iwpsDal.Insert(wareProSn);
                            }
                            if (wareProSn != null)
                            {

                                ivt_transfer_sn existTransSn = new ivt_transfer_sn()
                                {
                                    id = itsDal.GetNextIdCom(),
                                    create_time = timeNow,
                                    update_time = timeNow,
                                    create_user_id = userId,
                                    update_user_id = userId,
                                    sn = wareProSn.sn,
                                    transfer_id = existTrans.id,
                                };
                                itsDal.Insert(existTransSn);
                            }

                        }
                    }
                    else if (param.isNew)
                    {
                        wareHouse = iwDal.FindNoDeleteById(param.newWareId);
                        warePro = new ivt_warehouse_product() {
                            id = iwpDal.GetNextIdCom(),
                            create_time = timeNow,
                            update_time = timeNow,
                            create_user_id = userId,
                            update_user_id = userId,
                            product_id = insPro.product_id,
                            warehouse_id = param.newWareId,
                            reference_number = param.newRefNumber,
                            bin = param.newBin,
                            quantity = (int)param.newQuan,
                            quantity_maximum = param.newMax,
                            quantity_minimum = param.newMin,
                        };
                        iwpDal.Insert(warePro);

                        if (!string.IsNullOrEmpty(param.newSerNum))
                        {
                            var newWareProSn = iwpsDal.GetSnByWareAndSn(warePro.id, param.newSerNum);
                            if (newWareProSn == null)
                            {
                                newWareProSn = new ivt_warehouse_product_sn() {
                                    id = iwpsDal.GetNextIdCom(),
                                    create_time = timeNow,
                                    update_time = timeNow,
                                    create_user_id = userId,
                                    update_user_id = userId,
                                    sn = param.newSerNum,
                                    warehouse_product_id = warePro.id,
                                };
                                iwpsDal.Insert(newWareProSn);
                            }
                        }
                    }
                    else
                        return;
                    if (wareHouse == null)
                        return;
                    ivt_transfer trans = new ivt_transfer()
                    {
                        id = itDal.GetNextIdCom(),
                        create_time = timeNow,
                        update_time = timeNow,
                        create_user_id = userId,
                        update_user_id = userId,
                        type_id = (int)DicEnum.INVENTORY_TRANSFER_TYPE.TICKETS,
                        to_warehouse_id = wareHouse.id,
                        notes = "转入",
                        quantity = 1,
                        to_account_id  =insPro.account_id,
                        product_id = insPro.product_id,
                    };
                    itDal.Insert(trans);
                    if (wareProSn != null)
                    {
                        ivt_transfer_sn transSn = new ivt_transfer_sn()
                        {
                            id = itsDal.GetNextIdCom(),
                            create_time = timeNow,
                            update_time = timeNow,
                            create_user_id = userId,
                            update_user_id = userId,
                            sn = wareProSn.sn,
                            transfer_id = trans.id,
                        };
                        itsDal.Insert(transSn);
                    }

                    // 减少库存
                    if (param.inWareProId != null)
                    {
                        var inWarePro = iwpDal.FindNoDeleteById((long)param.inWareProId);
                        if (inWarePro != null&& inWarePro.quantity>0)
                        {
                            inWarePro.quantity -= 1;
                            inWarePro.update_time = timeNow;
                            inWarePro.update_user_id = userId;
                            iwpDal.Update(inWarePro);

                            if (param.inWareProSnId != null)
                            {
                                var inWareProSn = iwpsDal.FindNoDeleteById((long)param.inWareProSnId);
                                if (inWareProSn != null)
                                {
                                    iwpsDal.SoftDelete(inWareProSn,userId);
                                }
                            }

                        }
                    }
                        


                }
            }
            catch (Exception msg)
            {
                
            }
            
        }
        /// <summary>
        /// 设置配置项是否需要合同审核
        /// </summary>
        public bool ReviewInsPro(string insProIds,bool isReview,long userId)
        {
            if (string.IsNullOrEmpty(insProIds))
                return false;
            var idArr = insProIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
            foreach (var insProId in idArr)
            {
                var thisInsPro = _dal.FindNoDeleteById(long.Parse(insProId));
                if (thisInsPro == null)
                    continue;
                if (thisInsPro.contract_id != null)
                    isReview = true;
                sbyte isView = (sbyte)(isReview ? 1 : 0);
                if (thisInsPro.contract_id != null && !isReview)
                    continue;
                if (thisInsPro.reviewed_for_contract != isView)
                {
                    var oldInsPro = _dal.FindNoDeleteById(thisInsPro.id);
                    thisInsPro.reviewed_for_contract = isView;
                    thisInsPro.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisInsPro.update_user_id = userId;
                    _dal.Update(thisInsPro);
                    OperLogBLL.OperLogUpdate<crm_installed_product>(thisInsPro, oldInsPro, thisInsPro.id, userId, OPER_LOG_OBJ_CATE.CONFIGURAITEM, "");
                }
            }
            return true;
        }

        /// <summary>
        /// 编辑配置项
        /// </summary>
        public void EditInsPro(crm_installed_product insPro, long userId)
        {
            var oldInsPro = _dal.FindNoDeleteById(insPro.id);
            if (oldInsPro == null)
                return;
            insPro.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            insPro.update_user_id = userId;
            _dal.Update(insPro);
            OperLogBLL.OperLogUpdate<crm_installed_product>(insPro, oldInsPro, insPro.id, userId, OPER_LOG_OBJ_CATE.CONFIGURAITEM, "");
        }

    }
}
