﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;
using System.Text;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// OpportunityAjax 的摘要说明
    /// </summary>
    public class OpportunityAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "delete":
                        var opportunity_id = context.Request.QueryString["id"];
                        DeleteOpportunity(context, long.Parse(opportunity_id));
                        break;
                    case "formTemplate":
                        var formTemp_id = context.Request.QueryString["id"];
                        GetFormTemplate(context, Convert.ToInt64(formTemp_id));
                        break;
                    case "property":
                        var id = context.Request.QueryString["id"];
                        var propertyName = context.Request.QueryString["property"];
                        GetOpportunityProperty(context, id, propertyName);
                        break;
                    case "returnMoney":
                        var oid = context.Request.QueryString["id"];
                        GetQuoteItemMoney(context, long.Parse(oid));
                        break;
                    case "GetAccOpp":
                        var oppAcccountId = context.Request.QueryString["account_id"];
                        GetAccOpp(context, long.Parse(oppAcccountId));
                        break;
                    case "GetOppByStatus":
                        var sAccId = context.Request.QueryString["account_id"];
                        GetOppByStatus(context,long.Parse(sAccId));
                        break;
                    case "GetPorUdfByOpp":
                        var ppId = context.Request.QueryString["oppo_id"];
                        GetPorUdfByOpp(context,long.Parse(ppId));
                        break;
                    default:
                        break;
                }
            }
            catch (Exception e)
            {
                context.Response.Write(e.Message);
                context.Response.End();

            }
        }
        /// <summary>
        /// 删除商机处理
        /// </summary>
        /// <param name="context"></param>
        /// <param name="opportunity_id"></param>
        public void DeleteOpportunity(HttpContext context, long opportunity_id)
        {
            if (AuthBLL.GetUserOppAuth(LoginUserId, LoginUser.security_Level_id, opportunity_id).CanDelete == false)
            {
                return;
            }

            var result = new OpportunityBLL().DeleteOpportunity(opportunity_id, LoginUserId);
            if (result)
            {
                context.Response.Write("删除商机成功！");
            }
            else
            {
                context.Response.Write("删除商机失败！");
            }


        }
        /// <summary>
        /// 根据商机模板填充商机内容
        /// </summary>
        /// <param name="context"></param>
        /// <param name="formTemp_id"></param>
        public void GetFormTemplate(HttpContext context, long formTemp_id)
        {
            var formTemplate = new FormTemplateBLL().GetOpportunityTmpl((int)formTemp_id);
            if (formTemplate != null)
            {
                var json = new Tools.Serialize().SerializeJson(formTemplate);
                if (formTemplate.account_id != null)
                {
                    var companyName = new CompanyBLL().GetCompany((long)formTemplate.account_id);                   
                    if (companyName != null)
                    {
                        json = json.Substring(0, json.Length - 1);
                        json += ",\"ParentComoanyName\":\"" + companyName.name + "\"}";
                    }
                }
                context.Response.Write(json);
            }
        }


        private void GetOpportunityProperty(HttpContext context, string opportunity_id, string propertyName)
        {
            var opportunity = new DAL.crm_opportunity_dal().GetOpportunityById(long.Parse(opportunity_id));
            if (opportunity != null)
            {
                var value = DAL.BaseDAL<crm_opportunity>.GetObjectPropertyValue(opportunity, propertyName);
                context.Response.Write(value);
            }
        }

        /// <summary>
        /// 商机计算
        /// </summary>
        private void GetQuoteItemMoney(HttpContext context, long oid)
        {
            var oppo = new crm_opportunity_dal().FindNoDeleteById(oid);
            if (oppo != null)
            {
                // 将一次性，按月，季度，赋值之后 ， 需要将配送的金额和折扣的金额 存储之后计算
                var priQuote = new crm_quote_dal().GetPriQuote(oid);
                if (priQuote != null)
                {
                    decimal oneTimeRevenue = 0;
                    decimal oneTimeCost =  0;
                    decimal monthRevenue = 0;
                    decimal monthCost =  0;
                    decimal quarterRevenue =  0;
                    decimal quarterCost =  0;
                    decimal halfRevenue =  0;
                    decimal halfCost =  0;
                    decimal yearRevenue =  0;
                    decimal yearCost =  0;
                    decimal shipRevenue = 0;
                    decimal shipCost = 0;
                    decimal discount = 0;

                    var itemList = new crm_quote_item_dal().GetAllQuoteItem(priQuote.id);
                    if (itemList != null && itemList.Count > 0)
                    {
                        var thisItem = itemList.Where(_ => _.type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && _.optional != 1 && _.type_id != (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT).ToList();

                        var shipList = itemList.Where(_ => _.type_id == (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && _.optional == 0).ToList(); // 配送类型的报价项
                        var thisOneTimeList = itemList.Where(_ => _.period_type_id == (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME && _.optional == 0 && _.type_id != (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && _.type_id != (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES).ToList();
                        var discountQIList = itemList.Where(_ => _.type_id == (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && _.optional == 0).ToList();
                        if (shipList != null && shipList.Count > 0)
                        {
                            var totalPrice = shipList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);
                            shipRevenue = (decimal)totalPrice;
                            var totalCost = shipList.Sum(_ => (_.unit_cost != null && _.quantity != null) ? _.unit_cost * _.quantity : 0);
                            shipCost = (decimal)totalCost;
                        }
                        if (discountQIList != null && discountQIList.Count > 0)
                        {
                            var totalPrice = (discountQIList.Where(_ => _.discount_percent == null).ToList().Sum(_ => (_.unit_discount != null && _.quantity != null) ? _.unit_discount * _.quantity : 0) + (thisOneTimeList != null && thisOneTimeList.Count > 0 ? discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_ => thisOneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0) * _.discount_percent * 100 / 100) : 0));
                            discount = (decimal)totalPrice;
                        }


                        if (thisItem != null && thisItem.Count > 0)
                        {
                            var oneTimeList = thisItem.Where(_ => _.period_type_id == (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME).ToList();
                            var monthList = thisItem.Where(_ => _.period_type_id == (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH).ToList();
                            var quarterList = thisItem.Where(_ => _.period_type_id == (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER).ToList();
                            var halfList = thisItem.Where(_ => _.period_type_id == (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR).ToList();
                            var yearList = thisItem.Where(_ => _.period_type_id == (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR).ToList();
                            if (oneTimeList != null && oneTimeList.Count > 0)
                            {
                                oneTimeRevenue = (decimal)oneTimeList.Sum(_ => (_.unit_price != null && _.quantity != null) ? (((_.unit_price ?? 0) - (_.unit_discount ?? 0)) * _.quantity) : 0);
                                oneTimeCost = (decimal)oneTimeList.Sum(_ => (_.unit_cost != null && _.quantity != null) ? (_.unit_cost * _.quantity) : 0);
                            }
                            if (monthList != null && monthList.Count > 0)
                            {
                                monthRevenue = (decimal)monthList.Sum(_ => (_.unit_price != null && _.quantity != null) ? (((_.unit_price ?? 0) - (_.unit_discount ?? 0)) * _.quantity) : 0);
                                monthCost = (decimal)monthList.Sum(_ => (_.unit_cost != null && _.quantity != null) ? (_.unit_cost * _.quantity) : 0);
                            }
                            if (quarterList != null && quarterList.Count > 0)
                            {
                                quarterRevenue = (decimal)quarterList.Sum(_ => (_.unit_price != null && _.quantity != null) ? (((_.unit_price ?? 0) - (_.unit_discount ?? 0)) * _.quantity) : 0);
                                quarterCost = (decimal)quarterList.Sum(_ => (_.unit_cost != null && _.quantity != null) ? (_.unit_cost * _.quantity) : 0);
                            }
                            if (halfList != null && halfList.Count > 0)
                            {
                                halfRevenue = (decimal)halfList.Sum(_ => (_.unit_price != null && _.quantity != null) ? (((_.unit_price ?? 0) - (_.unit_discount ?? 0)) * _.quantity) : 0);
                                halfCost = (decimal)halfList.Sum(_ => (_.unit_cost != null && _.quantity != null) ? (_.unit_cost * _.quantity) : 0);
                            }
                            if (yearList != null && yearList.Count > 0)
                            {
                                yearRevenue = (decimal)yearList.Sum(_ => (_.unit_price != null && _.quantity != null) ? (((_.unit_price ?? 0) - (_.unit_discount ?? 0)) * _.quantity) : 0);
                                yearCost = (decimal)yearList.Sum(_ => (_.unit_cost != null && _.quantity != null) ? (_.unit_cost * _.quantity) : 0);
                            }
                        }
                    }
                    context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { oneTimeRevenue = oneTimeRevenue, oneTimeCost = oneTimeCost, monthRevenue = monthRevenue, monthCost = monthCost, quarterRevenue = quarterRevenue, quarterCost = quarterCost, halfRevenue = halfRevenue, halfCost = halfCost, yearRevenue = yearRevenue, yearCost = yearCost, shipRevenue = shipRevenue, shipCost = shipCost, discount = discount }));
                }
            }


            // quoteItemList.Where(_ => _.type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && _.optional != 1&&_.type_id != (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT).ToList();
        }

        public void GetAccOpp(HttpContext context, long account_id)
        {
            var oppList = new crm_opportunity_dal().FindOpHistoryByAccountId(account_id);
            if (oppList != null && oppList.Count > 0)
            {
                StringBuilder op = new StringBuilder();
                op.Append("<option value='0'>   </option>");
                oppList.ForEach(_ => op.Append($"<option value='{_.id}'>{_.name}</option>"));
                context.Response.Write(op.ToString());
            }
        }
        /// <summary>
        /// 根据状态，对商机进行分类
        /// </summary>
        public void GetOppByStatus(HttpContext context, long account_id)
        {
            var oppList = new crm_opportunity_dal().FindOpHistoryByAccountId(account_id);
            if (oppList != null && oppList.Count > 0)
            {
                StringBuilder op = new StringBuilder();
                op.Append("<option value=''>   </option>");
                var activeOPList = oppList.Where(_ => _.status_id == (int)DTO.DicEnum.OPPORTUNITY_STATUS.ACTIVE).ToList();
                var noActiveOPList = oppList.Where(_ => _.status_id != (int)DTO.DicEnum.OPPORTUNITY_STATUS.ACTIVE).ToList();
                if(activeOPList!=null&& activeOPList.Count > 0)
                {
                    foreach (var thisOp in activeOPList)
                    {
                        op.Append($"<option value='{thisOp.id}'>{thisOp.name}</option>");
                    }
                }
                if (noActiveOPList != null && noActiveOPList.Count > 0)
                {
                    op.Append("<option value=''>-------</option>");
                    foreach (var thisOp in noActiveOPList)
                    {
                        op.Append($"<option value='{thisOp.id}'>{thisOp.name}</option>");
                    }
                }
                context.Response.Write(op.ToString());

            }
        }
        /// <summary>
        /// 根据商机获取相应项目的值
        /// </summary>
        public void GetPorUdfByOpp(HttpContext context,long oppo_id)
        {
            var thisOpp = new crm_opportunity_dal().FindNoDeleteById(oppo_id);
            if (thisOpp != null)
            {
                var projectUdfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.PROJECTS);

                var oppoUdfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.OPPORTUNITY);
                var oppoValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.OPPORTUNITY, thisOpp.id, oppoUdfList);

                if(projectUdfList!=null&& projectUdfList.Count > 0)
                {
                    StringBuilder udfHtml = new StringBuilder();
                    var sufDal = new sys_udf_field_dal();
                    foreach (var thisProUdf in projectUdfList)
                    {
                        var thisSysProFile = sufDal.FindNoDeleteById(thisProUdf.id);
                        if (thisSysProFile != null && thisSysProFile.crm_to_project_udf_id != null)
                        {
                            var thisSysOppFile = sufDal.FindNoDeleteById((long)thisSysProFile.crm_to_project_udf_id);
                            var oppoValue = oppoValueList.FirstOrDefault(_ => _.id == thisSysProFile.crm_to_project_udf_id);
                            if (oppoValue != null&& thisSysOppFile!=null && !string.IsNullOrEmpty(oppoValue.value.ToString()))
                            {
                                udfHtml.Append($"<tr height='21'><td id ='txtBlack8'>{thisSysProFile.col_comment}</td><td> {thisSysOppFile.col_comment} </td><td>{oppoValue.value.ToString()}<input type='hidden' name='{thisProUdf.id.ToString()}' id='{thisProUdf.id.ToString()}' value='{oppoValue.value.ToString()}' /></ td></ tr>");
                            }
                        }
                    }

                    context.Response.Write(udfHtml.ToString());
                }
            }
            
        }
    }
}