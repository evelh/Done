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
using System.Data;

namespace EMT.DoneNOW.BLL
{
    public class QuoteBLL
    {
        private readonly crm_quote_dal _dal = new crm_quote_dal();

        /// <summary>
        /// 获取报价相关字典表
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("payment_term", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_TERM)));        // 
            dic.Add("payment_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_TYPE)));        // 
            dic.Add("payment_ship_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_SHIP_TYPE)));        // 

            dic.Add("notify_tmpl", new sys_notify_tmpl_dal().GetDictionary());        // 添加商机时的通知模板

            dic.Add("country", new DistrictBLL().GetCountryList());                          // 国家表
            dic.Add("addressdistrict", new d_district_dal().GetDictionary());                       // 地址表（省市县区）

            dic.Add("taxRegion", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TAX_REGION)));              // 税区
            dic.Add("quote_tmpl", new sys_quote_tmpl_dal().GetQuoteTemp());




            return dic;
        }

        /// <summary>
        /// 插入报价
        /// </summary>
        /// <param name="quote"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Insert(crm_quote quote, long user_id)
        {
            if (quote.account_id == 0 || string.IsNullOrEmpty(quote.name) || (quote.contact_id == 0 && quote.opportunity_id == 0))
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;



            #region 3.保存商机
            if (quote.opportunity_id == 0)  // 代表用户未选择商机，此时自动创建商机
            {
                var opportunity = new crm_opportunity()
                {
                    id = _dal.GetNextIdCom(),
                    name = quote.name,
                    account_id = quote.account_id,
                    resource_id = user_id,
                    stage_id = (int)OPPORTUNITY_STAGE.NEW_CLUE,  // todo 取到商机阶段中的最小值
                    status_id = (int)OPPORTUNITY_STATUS.ACTIVE,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    projected_close_date = quote.projected_close_date,
                    use_quote = 1,
                    one_time_cost = 0,
                    one_time_revenue = 0,
                    monthly_cost = 0,
                    monthly_revenue = 0,
                    quarterly_cost = 0,
                    quarterly_revenue = 0,
                    semi_annual_cost = 0,
                    semi_annual_revenue = 0,
                    yearly_cost = 0,
                    yearly_revenue = 0,
                    ext1 = 0,
                    ext2 = 0,
                    ext3 = 0,
                    ext4 = 0,
                    ext5 = 0,
                    spread_value = 0,
                    // create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    create_user_id = user_id,
                    update_user_id = user_id,

                };
                new crm_opportunity_dal().Insert(opportunity);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
                    oper_object_id = opportunity.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(opportunity),
                    remark = "保存商机信息"
                });
                quote.opportunity_id = opportunity.id;
            }
            #endregion


            #region 1.保存报价
            quote.id = _dal.GetNextIdCom();
            quote.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote.create_user_id = user_id;
            quote.update_user_id = user_id;
            quote.payment_term_id = quote.payment_term_id == 0 ? null : quote.payment_term_id;
            quote.payment_type_id = quote.payment_type_id == 0 ? null : quote.payment_type_id;
            quote.shipping_type_id = quote.shipping_type_id == 0 ? null : quote.shipping_type_id;
            quote.tax_region_id = quote.tax_region_id == 0 ? null : quote.tax_region_id;
            quote.quote_tmpl_id = quote.quote_tmpl_id == 0 ? null : quote.quote_tmpl_id;
            _dal.Insert(quote);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE,
                oper_object_id = quote.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(quote),
                remark = "保存报价信息"
            });
            #endregion

            #region 2.保存通知
            #endregion





            return ERROR_CODE.SUCCESS;
        }

        public ERROR_CODE Update(crm_quote quote, long user_id)
        {
            if (quote.account_id == 0 || string.IsNullOrEmpty(quote.name) || (quote.contact_id == 0 && quote.opportunity_id == 0))
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            var old_quote = _dal.GetQuote(quote.id);

            //if (quote.opportunity_id == 0)  // 代表用户未选择商机，此时自动创建商机
            //{
            //    var opportunity = new crm_opportunity()
            //    {
            //        id = _dal.GetNextIdCom(),
            //        name = quote.name,
            //        resource_id = user_id,
            //        stage_id = (int)OPPORTUNITY_STAGE.NEW_CLUE,  // todo 取到商机阶段中的最小值
            //        status_id = (int)OPPORTUNITY_STATUS.ACTIVE,
            //        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        projected_close_date = quote.projected_close_date,
            //        use_quote = 1,
            //        one_time_cost = 0,
            //        one_time_revenue = 0,
            //        monthly_cost = 0,
            //        monthly_revenue = 0,
            //        quarterly_cost = 0,
            //        quarterly_revenue = 0,
            //        semi_annual_cost = 0,
            //        semi_annual_revenue = 0,
            //        yearly_cost = 0,
            //        yearly_revenue = 0,
            //        ext1 = 0,
            //        ext2 = 0,
            //        ext3 = 0,
            //        ext4 = 0,
            //        ext5 = 0,
            //        // create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        create_user_id = user_id,
            //        update_user_id = user_id,

            //    };
            //    new crm_opportunity_dal().Insert(opportunity);
            //    new sys_oper_log_dal().Insert(new sys_oper_log()
            //    {
            //        user_cate = "用户",
            //        user_id = (int)user.id,
            //        name = user.name,
            //        phone = user.mobile == null ? "" : user.mobile,
            //        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
            //        oper_object_id = opportunity.id,// 操作对象id
            //        oper_type_id = (int)OPER_LOG_TYPE.ADD,
            //        oper_description = _dal.AddValue(opportunity),
            //        remark = "保存商机信息"
            //    });
            //    quote.opportunity_id = opportunity.id;
            //}
            quote.account_id = old_quote.account_id;
            quote.oid = old_quote.oid;
            quote.opportunity_id = old_quote.opportunity_id;
            quote.payment_term_id = quote.payment_term_id == 0 ? null : quote.payment_term_id;
            quote.payment_type_id = quote.payment_type_id == 0 ? null : quote.payment_type_id;
            quote.shipping_type_id = quote.shipping_type_id == 0 ? null : quote.shipping_type_id;
            quote.tax_region_id = quote.tax_region_id == 0 ? null : quote.tax_region_id;
            quote.quote_tmpl_id = old_quote.quote_tmpl_id;
            quote.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote.update_user_id = user_id;
            _dal.Update(quote);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE,
                oper_object_id = quote.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old_quote, quote),
                remark = "修改报价信息"
            });
            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 删除报价
        /// </summary>
        /// <param name="quote_id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool DeleteQuote(long quote_id, long user_id)
        {
            // todo 报价如果关联了销售订单，则不可删除
          

            var quote = _dal.GetQuote(quote_id);
            if (quote != null)
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                if (user != null)
                {
                    quote.delete_user_id = user_id;
                    quote.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    _dal.Update(quote);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE,
                        oper_object_id = quote.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                        oper_description = _dal.AddValue(quote),
                        remark = "删除报价"
                    });

                    var quoteItemList = new crm_quote_item_dal().GetQuoteItems(" and quote_id = "+quote.id);   // 删除报价的同时，删除报价下的所有报价项
                    if(quoteItemList!=null&& quoteItemList.Count > 0)
                    {
                        var quoteItemBLL = new QuoteItemBLL();
                        quoteItemList.ForEach(_ => {
                            //_.delete_user_id = user_id;
                            //_.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            quoteItemBLL.DeleteQuoteItem(_.id,user.id);
                        });
                    }
                    return true;
                }
            }

            return false;
        }

        /// <summary>
        /// 获取到报价项
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public crm_quote GetQuote(long id)
        {
            return _dal.FindSignleBySql<crm_quote>($"select * from crm_quote WHERE id = {id} and delete_time = 0 ");
        }

        /// <summary>
        /// 丢失报价
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="quoteId"></param>
        /// <param name="reasonType">丢失原因类型</param>
        /// <param name="reasonDetail">丢失原因详情</param>
        /// <returns></returns>
        public string LossQuote(long userId, long quoteId, int reasonType, string reasonDetail)
        {
            DicEnum.SYS_CLOSE_OPPORTUNITY needReasonType;
            var type = new SysSettingBLL().GetValueById(SysSettingEnum.CRM_OPPORTUNITY_LOSS_REASON);
            int value = 0;
            if (!int.TryParse(type, out value))
                needReasonType = DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_NONE;
            else
                needReasonType = (DicEnum.SYS_CLOSE_OPPORTUNITY)value;

            // 更新商机状态为丢失
            var opporDal = new crm_opportunity_dal();
            var quote = _dal.FindById(quoteId);
            var oppor = opporDal.FindById(quote.opportunity_id);
            var oldOppor = opporDal.FindById(quote.opportunity_id);
            oppor.status_id = (int)DicEnum.OPPORTUNITY_STATUS.LOST;
            oppor.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            oppor.update_user_id = userId;
            if (needReasonType == SYS_CLOSE_OPPORTUNITY.NEED_TYPE_DETAIL)
                oppor.loss_reason = reasonDetail;
            if (needReasonType != SYS_CLOSE_OPPORTUNITY.NEED_NONE)
                oppor.loss_reason_type_id = reasonType;
            opporDal.Update(oppor);

            // 保存操作商机日志
            var user = UserInfoBLL.GetUserInfo(userId);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = userId,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
                oper_object_id = oppor.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = opporDal.CompareValue(oldOppor, oppor),
                remark = "修改商机信息"
            });

            // 新增通知信息
            var notify_email_dal = new com_notify_email_dal();
            var notify_email = new com_notify_email()
            {
                id = notify_email_dal.GetNextIdCom(),
                cate_id = (int)NOTIFY_CATE.CRM,
                event_id = 1,             // TODO:
                to_email = "",                  // TODO:  
                notify_tmpl_id = 1,    // TODO:
                from_email = user.email,   // todo
                from_email_name = user.name,  // todo 
                subject = "",       // TODO:
                body_text = "",    // TODO:
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
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
                oper_object_id = notify_email.id,
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = notify_email_dal.AddValue(notify_email),
                remark = "新增通知",
            });  // 插入日志

            return "";
		}
        /// <summary>
        /// 报价单绑定报价模板
        /// </summary>
        /// <param name="cq"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool UpdateQuoteTemp(crm_quote cq,long user_id) {
            var user = UserInfoBLL.GetUserInfo(user_id);
            cq.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            cq.update_user_id = user_id;
            if (_dal.Update(cq))
            { 
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user_id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE,

                    oper_object_id = cq.id,// 操作对象id

                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,

                    oper_description = _dal.AddValue(cq),
                    remark = "关联报价模板"
                });

            }
            return true;
        }
        /// <summary>
        /// 返回一个d_tax_region_cate对象
        /// </summary>
        /// <param name="aid"></param>
        /// <param name="bid"></param>
        /// <returns></returns>
        public d_tax_region_cate GetTaxRegion(int aid,int bid) {
            var data = new d_tax_region_cate_dal().FindSignleBySql<d_tax_region_cate>(@"select * from d_tax_region_cate  where tax_region_id="+aid+" and tax_cate_id="+bid+"");
            return data;
        }
        /// <summary>
        /// 返回d_tax_region_cate_tax的list数据集
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<d_tax_region_cate_tax> GetTaxRegiontax(int id)
        {
           
            var data = new d_tax_region_cate_tax_dal().FindListBySql<d_tax_region_cate_tax>(@"select * from d_tax_region_cate  where tax_region_cate_id="+id+"");

            return data;
        }

        /// <summary>
        /// 获取税收地区名称
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public string GetTaxName(int id) {
            string name =new d_general_dal().FindById(id).name;
            return name;
        }
        public DataTable GetVar(int cid,int aid)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("select * from ");
            sql.Append(@"(select  (select name from crm_account where id=c.account_Id) as '[Contact: Company]', (case when is_active=1 then '已激活' else '未激活'end ) as '[联系人：激活的]', NULL as '[联系人：外部编号]', c.title as '[联系人：称呼]', c.first_name as '[联系人：名]', c.last_name as '[联系人：姓]', (select name from d_general where id=c.suffix_id) as '[联系人：后缀]', null as '[联系人：中间名]', c.name as '[联系人：姓名]', c.name as '[联系人：姓名（链接）]', c.name as '[联系人：链接]', c.ID as '[Contact: ID]', null as '[联系人：头衔]', l.address as '[联系人：地址]', l.additional_address as '[联系人：补充地址]', (select name from d_district where id=l.city_id) as '[联系人：城市]', (select name from d_district where id=l.province_id) as '[联系人：省]', l.postal_code as '[Contact: Post Code]', (select name from d_country where id=l.country_id) as '[联系人：国家]', c.email as '[联系人：邮件地址]', c.phone as '[联系人：电话]', null as '[联系人：电话分机]', c.alternate_phone as '[联系人：备用电话]', c.mobile_phone as '[联系人：移动电话]', c.fax as '[联系人：传真]', null as '[联系人：Client Access Portal用户姓名]', c.email2 as '[Contact: Alternate Email1]', null as '[Contact: Customer Contact]', null as '[Contact: Address]' from crm_contact c LEFT JOIN crm_location l on c.location_id = l.id where 1 = 1    and c.id in("+cid+") and 1 = 1  order by  c.name) as aa,");
            sql.Append(@"(select s.col001 as '[Site Configuration: Building Security Code]',a.name as '[客户：名称]',s.col009 as '[Site Configuration: DNS - Password]',a.name as '[客户：名称（链接）]',s.col007 as '[Site Configuration: DNS - Provider]',a.name as '[客户：链接]',s.col008 as '[Site Configuration: DNS - Username]',a.oid as '[Company: ID]',s.col011 as '[Site Configuration: Email Certificates - Host Name]',a.no as '[客户：编号]',s.col010 as '[Site Configuration: Email Certificates - Provider]',(CASE WHEN a.is_active=1 THEN '激活' else '未激活'  END) as '[客户：激活的]',s.col002 as '[Site Configuration: ISP Provider Phone Number]',l.additional_address as '[客户：补充地址]',s.col003 as '[Site Configuration: Web Hosting - Contact]',null as '[客户：其他地址]',s.col004 as '[Site Configuration: Web Hosting - Primary Phone #]',l.city_name as '[客户：城市]',s.col006 as '[Site Configuration: Web Hosting - PW]',l.province_name as '[客户：省]',s.col005 as '[Site Configuration: Web Hosting - UN]',l.postal_code as '[Company: Post Code]',s.col012 as '[Site Configuration: WAN - Vendor]',(select country_name_display from d_country where id=l.country_id) as '[客户：国家]',s.col013 as '[Site Configuration: WAN - Static IP]',a.phone as '[客户：电话]',s.col014 as '[Site Configuration: WAN - Gateway]',a.alternate_phone1 as '[客户：备用电话1]',s.col015 as '[Site Configuration: WAN - Subnet Mask]',a.alternate_phone2 as '[客户：备用电话2]',s.col016 as '[Site Configuration: WAN - DNS - Primary]',a.fax as '[客户：传真]',s.col017 as '[Site Configuration: WAN - DNS - Secondary]',a.web_site as '[客户：网址]',s.col018 as '[Site Configuration: LAN - Domain]',(select name from d_general where  id=a.type_id) as '[客户：类型]',s.col019 as '[Site Configuration: LAN - IP Address]',(select icon_path from d_account_classification where id=a.classification_id) as '[Company: Classification Icon]',s.col020 as '[Site Configuration: LAN - Admin Password]',(select name from d_account_classification where id=a.classification_id) as '[Company: Classification Name]',s.col021 as '[Site Configuration: Domain Controller - OS]',u.name as '[Company: Account Manager]',s.col022 as '[Site Configuration: Domain Controller - Name]',u.title as '[Company: Account Manager Prefix]',s.col023 as '[Site Configuration: Domain Controller - IP]',u.first_name as '[Company: Account Manager First Name]',s.col024 as '[Site Configuration: Domain Controller - Roles]',u.last_name as '[Company: Account Manager Last Name]',(select name from d_general where id=u.suffix_id) as '[Company: Account Manager Suffix]',u.office_phone as '[Company: Account Manager Office Phone]',null as '[Company: Account Manager Office Phone Extension]',u.home_phone as '[Company: Account Manager Home Phone]',u.mobile_phone as '[Company: Account Manager Mobile Phone]',u.email as '[Company: Account Manager Email Address]',u.email1 as '[Company: Account Manager Email Address 1]',u.email2 as '[Company: Account Manager Email Address 2]',(select name from d_general where id =a.territory_id) as '[客户：地域]',(select name from d_general where id =a.market_segment_id) as '[客户：市场领域]',(select name from d_general where id =a.competitor_id) as '[客户：竞争对手]',(select name from crm_account where id=a.parent_id) as '[Company: Parent Company]',FROM_UNIXTIME( a.last_activity_time/1000,'%Y-%m-%d %H:%i:%s') as '[客户：最近活动日期]',null as '[Company: Account Team Members]',null as '[Company: Account Team Members (with Email Address)]',null as '[Company: Account Team Members (with Office Phone)]',null as '[Company: Account Team Members (with Office Phone and Email Address)]',null as '[Company: label time]',null as '[Company: Lead Source]',null as '[Company: Number of Employees]',null as '[Company: test001]',a.tax_identification as '[客户：税收编号]',l.address as '[客户：地址]',null as '[客户：其它地址信息]',null as '[Company: Currency]',null as '[Company: Currency Display Symbol]',null as '[Company: Currency Exchange Rate]' from crm_account a join crm_account_site_ext s on a.id=s.parent_id left join sys_resource u on a.resource_id=u.id LEFT JOIN (select cl.*,(select name from d_district where id=cl.province_id)province_name,(select name from d_district where id=cl.city_id)city_name from crm_location cl where is_default=1) l on a.id=l.account_id where a.delete_time=0    and a.id="+aid+" and 1=1  order by a.name) as bb");

            var list = _dal.ExecuteDataTable(sql.ToString());
            return list;
        }
    }
}
