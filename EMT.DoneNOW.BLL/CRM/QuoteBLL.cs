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
        public DataTable GetVar(int id)
        {
            string sql=@"select  (select name from crm_account where id=c.account_Id) as '[Contact: Company]', (case when is_active=1 then '已激活' else '未激活'end ) as '[联系人：激活的]', NULL as '[联系人：外部编号]', c.title as '[联系人：称呼]', c.first_name as '[联系人：名]', c.last_name as '[联系人：姓]', (select name from d_general where id=c.suffix_id) as '[联系人：后缀]', null as '[联系人：中间名]', c.name as '[联系人：姓名]', c.name as '[联系人：姓名（链接）]', c.name as '[联系人：链接]', c.ID as '[Contact: ID]', null as '[联系人：头衔]', l.address as '[联系人：地址]', l.additional_address as '[联系人：补充地址]', (select name from d_district where id=l.city_id) as '[联系人：城市]', (select name from d_district where id=l.province_id) as '[联系人：省]', l.postal_code as '[Contact: Post Code]', (select name from d_country where id=l.country_id) as '[联系人：国家]', c.email as '[联系人：邮件地址]', c.phone as '[联系人：电话]', null as '[联系人：电话分机]', c.alternate_phone as '[联系人：备用电话]', c.mobile_phone as '[联系人：移动电话]', c.fax as '[联系人：传真]', null as '[联系人：Client Access Portal用户姓名]', c.email2 as '[Contact: Alternate Email1]', null as '[Contact: Customer Contact]', null as '[Contact: Address]' from crm_contact c LEFT JOIN crm_location l on c.location_id = l.id where 1 = 1    and c.id in("+id+") and 1 = 1  order by  c.name";
            var list = _dal.ExecuteDataTable(sql);
            return list;
        }
    }
}
