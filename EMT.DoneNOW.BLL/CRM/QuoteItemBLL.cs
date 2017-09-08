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

        // 计算出该报价下的所有一次姓报价项中包含税的报价项的折扣
        public decimal GetOneTimeMoneyTax(List<crm_quote_item> oneTimeList,crm_quote_item qItem)
        {

            // 按照金钱扣除的折扣转换成为百分比进行运算-- 暂时处理待测试
            // 折扣记录两种计费项。一个是一次性报价项当中含有税的，一个一次性报价项当中不含有税的
            // 折扣的计费项命名  为含税和不含税这两种
            // 计费项的名称命名为报价项的名称
            decimal totalMoney = 0;
            var AllTotalMoney = GetAllMoney(oneTimeList);
            var taxItem = oneTimeList.Where(_ => _.period_type_id != null).ToList();
            totalMoney = GetAllMoney(taxItem);
            if (qItem.discount_percent != null)
            {
                totalMoney = totalMoney * (decimal)qItem.discount_percent;
            }
            else
            {
                totalMoney = totalMoney * ((decimal)qItem.unit_discount / AllTotalMoney);
            }
            return totalMoney;
        }
        // 计算出该报价下的所有一次姓报价项中不包含税的报价项的折扣
        public decimal GetOneTimeMoney(List<crm_quote_item> oneTimeList, crm_quote_item qItem)
        {
            decimal totalMoney = 0;
            var AllTotalMoney = GetAllMoney(oneTimeList);
            var noTaxItem = oneTimeList.Where(_ => _.period_type_id == null).ToList();
             totalMoney = GetAllMoney(noTaxItem);
            if (qItem.discount_percent != null)
            {
                totalMoney = totalMoney * (decimal)qItem.discount_percent;
            }
            else
            {
                totalMoney = totalMoney * ((decimal)qItem.unit_discount / AllTotalMoney);
            }
            return totalMoney;
        }
        /// <summary>
        /// 获取到这个一次性报价的总价
        /// </summary>
        /// <param name="oneTimeList"></param>
        /// <returns></returns>
        public decimal GetAllMoney(List<crm_quote_item> oneTimeList)
        {
            decimal totalMoney = 0;
            if (oneTimeList != null && oneTimeList.Count > 0)
            {
                totalMoney = (decimal)oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);
            }
            return totalMoney;
        }

    }
}
