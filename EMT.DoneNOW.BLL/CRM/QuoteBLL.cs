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
            if (quote.account_id == 0 || string.IsNullOrEmpty(quote.name) || quote.contact_id == 0)
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;

            #region 1.保存报价
            quote.id = _dal.GetNextIdCom();
            quote.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote.create_user_id = user_id;
            quote.update_user_id = user_id;
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

            #region 3.保存商机
            if (quote.opportunity_id == 0)  // 代表用户未选择商机，此时自动创建商机
            {
                var opportunity = new crm_opportunity()
                {
                    id = _dal.GetNextIdCom(),
                    name = quote.name,
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
            }
            #endregion



            return ERROR_CODE.SUCCESS;
        }
    }
}
