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
                cate_id = (int)param.installed_product_cate_id,
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
                vendor_id = param.vendor_id == 0 ? null : param.vendor_id,
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


            crm_installed_product installed_product = new crm_installed_product()
            {
                id = old_installed_product.id,
                product_id = param.product_id,
                cate_id = (int)param.installed_product_cate_id,
                account_id = param.account_id,
                start_date = param.start_date,
                through_date = param.through_date,
                number_of_users = param.number_of_users,
                serial_number = param.serial_number,
                reference_number = param.reference_number,
                reference_name = param.reference_name,
                contract_id = param.contract_id == 0 ? null : (long?)param.contract_id,
                location = param.location,
                contact_id = param.contact_id == 0 ? null : (long?)param.contact_id,
                vendor_id = param.vendor_id == 0 ? null : (long?)param.vendor_id,
                is_active = (sbyte)param.status,
                installed_resource_id = user.id,
                // installed_contact_id = param.contact_id, // todo -- 安装人与联系人
                //create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                //create_user_id = user.id,
                update_user_id = user.id,
                remark = param.notes,

                // Terms
                hourly_cost = param.terms.hourly_cost,
                daily_cost = param.terms.daily_cost,
                monthly_cost = param.terms.monthly_cost,
                setup_fee = param.terms.setup_fee,
                peruse_cost = param.terms.peruse_cost,
                accounting_link = param.terms.accounting_link,

                #region 服务等信息等待合同创建后处理，其字段从源数据获取

                cost_product_id = old_installed_product.cost_product_id,
                create_time = old_installed_product.create_time,
                create_user_id = old_installed_product.create_user_id,
                delete_time = old_installed_product.delete_time,
                delete_user_id = old_installed_product.delete_user_id,
                entrytimestamp = old_installed_product.entrytimestamp,
                extension_adapter_disovery_data_id = old_installed_product.extension_adapter_disovery_data_id,
                followup_cost = old_installed_product.followup_cost,
                implementation_cost = old_installed_product.implementation_cost,
                installed_contact_id = old_installed_product.installed_contact_id,
                inventory_transfer_id = old_installed_product.inventory_transfer_id,
                is_swapped_out = old_installed_product.is_swapped_out,
                oid = old_installed_product.oid,
                parent_id = old_installed_product.parent_id,
                quote_item_id = old_installed_product.quote_item_id,
                

                service_bundle_id = old_installed_product.service_bundle_id,
                service_id = old_installed_product.service_id,
                udf_group_id = old_installed_product.udf_group_id,


                #endregion

            };   // 创建配置项对象

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
        public void InsertSubPeriod(DateTime firstTime,DateTime lastTime,crm_subscription subscription, UserInfoDto user)
        {
            var periods = 1;   // 定义初始的期数为1 
            //var firstTime = subscription.effective_date; // 生效日期
            //var lastTime = subscription.expiration_date; // 结束日期
            // var period_type = subscription.period_type_id;
            var days = Math.Ceiling((lastTime - firstTime).TotalDays); // 获取到相差几天

            var months = (lastTime.Year - firstTime.Year) * 12 + (lastTime.Month - firstTime.Month) + (lastTime.Day >= firstTime.Day ? 1 : 0);
            decimal periodMonths = 1;
            decimal period = 1;
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
                    subPeriodList.ForEach(_=> {
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
                            NoDealSub.ForEach(_ => {
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
        public string ActivationInstalledProduct(long iProduct_id,long user_id,bool isActive)
        {


            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var dal = new crm_installed_product_dal();
            var iProduct = dal.GetInstalledProduct(iProduct_id);
            if (iProduct != null)
            {

                if (iProduct.is_active == (isActive?0:1))
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
                        remark = (isActive?"激活":"失活")+"配置项",
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
        public bool AvtiveManyIProduct(string ids,long user_id, bool isActive)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var dal = new crm_installed_product_dal();
            if (!string.IsNullOrEmpty(ids))
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                    ActivationInstalledProduct(long.Parse(id),user_id, isActive);
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
        public bool DeleteIProduct(long iProduct_id,long user_id)
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
        public bool DeleteIProducts(string ids,long user_id)
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
        public string ActiveSubsctiption(long sid,long user_id, int status_id)
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
        public bool ActiveSubsctiptions(string ids,long user_id, int status_id)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            if (!string.IsNullOrEmpty(ids)&&user!=null)
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
        public bool DeleteSubsctiption(long sid,long user_id)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var sDal = new crm_subscription_dal();
            var subscription = sDal.GetSubscription(sid);
            if (subscription != null&&user!=null)
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
        public bool DeleteSubsctiptions(string sids,long user_id)
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
        public bool RelieveInsProduct(long contract_id,long ipID,long user_id)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var insPro = _dal.FindNoDeleteById(ipID);
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
                    oper_description = _dal.CompareValue(_dal.FindNoDeleteById(insPro.id),insPro),
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
        public bool RelationInsProduct(long contract_id, long ipID, long user_id,long? service_id = null)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            var insPro = _dal.FindNoDeleteById(ipID);
            if (user != null && insPro != null)
            {
                // isServiceOrBag
                insPro.contract_id = contract_id;
                insPro.update_user_id = user.id;
                insPro.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                if (service_id != null)
                {
                    var isService = new OpportunityBLL().isServiceOrBag((long)service_id);
                    if (isService==1)
                    {
                        insPro.service_id = service_id;
                    }
                    else if(isService == 2)
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

    }
}
