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
    public class QuoteItemBLL
    {
        private crm_quote_item_dal _dal = new crm_quote_item_dal();

        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("quote_item_period_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE)));        // 
            dic.Add("quote_item_tax_cate", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_TAX_CATE)));        // 
            dic.Add("quote_item_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_TYPE)));        // 
            dic.Add("quote_group_by", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_GROUP_BY)));


            return dic;

        }
        /// <summary>
        /// 新增报价项
        /// </summary>
        /// <param name="quote_item"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Insert(crm_quote_item quote_item, long user_id)
        {
            if (quote_item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT)
            {
                if (quote_item.unit_price == null || quote_item.unit_cost == null || quote_item.quantity == null || quote_item.unit_discount == null)
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
                if (string.IsNullOrEmpty(quote_item.name))
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }
            else
            {
                if (string.IsNullOrEmpty(quote_item.name))
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
                if(quote_item.discount_percent==null&& quote_item.unit_discount == null)
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }
            
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            quote_item.id = _dal.GetNextIdCom();
            quote_item.tax_cate_id = quote_item.tax_cate_id == 0 ? null : quote_item.tax_cate_id;
            quote_item.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote_item.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote_item.create_user_id = user_id;
            quote_item.update_user_id = user_id;

            _dal.Insert(quote_item);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_ITEM,
                oper_object_id = quote_item.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(quote_item),
                remark = "保存报价项信息"
            });
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 编辑报价项
        /// </summary>
        /// <param name="quote_item"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Update(crm_quote_item quote_item, long user_id)
        {
            if (quote_item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT)
            {
                if (quote_item.unit_price == null || quote_item.unit_cost == null || quote_item.quantity == null || quote_item.unit_discount == null)
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
                if (string.IsNullOrEmpty(quote_item.name))
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }
            else
            {
                if (string.IsNullOrEmpty(quote_item.name))
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
                if (quote_item.discount_percent == null && quote_item.unit_discount == null)
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            var old_quote_item = _dal.GetQuoteItem(quote_item.id);
            quote_item.oid = old_quote_item.oid;
            quote_item.update_user_id = user_id;
            quote_item.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote_item.tax_cate_id = quote_item.tax_cate_id == 0 ? null : quote_item.tax_cate_id;
            _dal.Update(quote_item);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_ITEM,
                oper_object_id = quote_item.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old_quote_item, quote_item),
                remark = "编辑报价项信息"
            });
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 删除报价项
        /// </summary>
        /// <param name="quote_item_id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool DeleteQuoteItem(long quote_item_id, long user_id)
        {
            // todo 报价如果关联了销售订单，则不可删除报价项  -- 验证 
            var quote_item = _dal.GetQuoteItem(quote_item_id);
            if (quote_item != null)
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                if (user != null)
                {
                    quote_item.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    quote_item.delete_user_id = user_id;
                    _dal.Update(quote_item);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_ITEM,
                        oper_object_id = quote_item.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                        oper_description = _dal.AddValue(quote_item),
                        remark = "删除报价项"
                    });
                    return true;
                }
            }

            return false;
        }
        public List<crm_quote_item> GetAllQuoteItem(long id) {
            string sql = " and quote_id="+id+" ";
            var list = _dal.GetQuoteItems(sql);
            return list;
        }


    }
}
