using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;
using System.Text;
using System.Text.RegularExpressions;

namespace EMT.DoneNOW.Web.Invoice
{
    public partial class InvoicePreview : BasePage
    {
        protected crm_account account = null;   // 当前展示的客户的ID，默认集合第一个
        protected List<crm_account> accList = null;   // 传递过来的客户的集合
        protected sys_quote_tmpl invoice_temp = null;
        protected List<sys_quote_tmpl> invTempList = new sys_quote_tmpl_dal().GetInvoiceTemp();
        protected bool isInvoice = false;  // 判断是显示发票还是条目--去控制页面上一些东西的显示与否
        protected Dictionary<string, object> dic = new InvoiceBLL().GetField();
        protected List<InvoiceDeductionDto> paramList = null;
        protected List<InvoiceDeductionDto> billTOThisParamList = null;
        protected StringBuilder thisHtmlText = new StringBuilder();    // 需要替换到页面上的html文本
        protected string itemStartDatePara = "";
        protected string itemEndDatePara = "";
        protected string contractTypePara = "";
        protected string contractCatePara = "";
        protected string projectItemPara = "";
        protected string purchaseNo = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                purchaseNo = Request.QueryString["purchaseNo"];
                itemStartDatePara = Request.QueryString["stareDate"];
                itemEndDatePara = Request.QueryString["endDate"];
                contractTypePara = Request.QueryString["contract_type"];
                contractCatePara = Request.QueryString["contract_cate"];
                projectItemPara = Request.QueryString["itemDeal"];

                var invoice_temp_id = Request.QueryString["invoice_temp_id"];
                if (invTempList != null && invTempList.Count > 0)
                {
                    if (!string.IsNullOrEmpty(invoice_temp_id))
                    {
                        invoice_temp = new sys_quote_tmpl_dal().FindNoDeleteById(long.Parse(invoice_temp_id));
                    }
                    else
                    {
                        invoice_temp = invTempList[0];
                        // invoice_temp为客户默认发票
                    }
                }


                var accountIds = Request.QueryString["account_ids"];
                var account_id = Request.QueryString["account_id"];
                accList = new crm_account_dal().GetCompanyByIds(accountIds);
                if (accList != null && accList.Count > 0)
                {
                    if (!string.IsNullOrEmpty(account_id))
                    {
                        var thisAccount = new CompanyBLL().GetCompany(long.Parse(account_id));
                        account = accList.FirstOrDefault(_ => _.id == thisAccount.id);
                       
                    }
                    else
                    {
                        account = accList[0];
                    }
                    if (account == null)
                    {
                        Response.End();
                    }
                    var accDedIds = Request.QueryString["accDedIds"];
                    if (!string.IsNullOrEmpty(accDedIds))
                    {
                        var thisList = new crm_account_deduction_dal().GetInvDedDtoList($" and id in({accDedIds})");
                        paramList = thisList.Where(_ => _.account_id == account.id).ToList();
                        billTOThisParamList = thisList.Where(_ => _.bill_account_id == account.id && _.account_id != account.id).ToList();
                    }
                    else
                    {
                        paramList = new crm_account_deduction_dal().GetInvDedDtoList(" and account_id=" + account.id);
                        billTOThisParamList = new crm_account_deduction_dal().GetInvDedDtoList(" and account_id <> " + account.id + " and bill_account_id=" + account.id);
                    }
                    
                }
                else
                {
                    Response.End();
                }

                if (!IsPostBack)
                {
                    PageDataBind();
                }

                if (!string.IsNullOrEmpty(Request.QueryString["isInvoice"]))  // 代表是显示发票还是显示条目
                {
                    // thisInvoiceList
                    isInvoice = true;
                }
                else
                {

                }
                #region 拼接页眉
                thisHtmlText.Append("<div><table style='width: 100 %; border - collapse:collapse;'><tbody><tr>");
                thisHtmlText.Append(HttpUtility.HtmlDecode(GetHtmlHead(invoice_temp)).Replace("\"", "'"));
                thisHtmlText.Append("</tr></tbody></table></div>");

                thisHtmlText.Append("<div><table style='width: 100 %; border - collapse:collapse;'><tbody><tr>");
                thisHtmlText.Append(HttpUtility.HtmlDecode(GetQuoteHead(invoice_temp)).Replace("\"", "'"));
                thisHtmlText.Append("</tr></tbody></table></div>");
                #endregion
                #region 拼接页面Body
                thisHtmlText.Append($"<div class='ReadOnlyGrid_Container'><div class='ReadOnlyGrid_Account'>{account.name}</div><table class='ReadOnlyGrid_Table' style='border-color: #ccc;'>");
                GetHtmlBody(invoice_temp);

                // thisHtmlText.Append("</table></div>");
                #endregion
                #region 拼接页脚
                thisHtmlText.Append("<div><table style='width: 100 %; border - collapse:collapse;'><tbody><tr>");
                thisHtmlText.Append(HttpUtility.HtmlDecode(GetQuoteFoot(invoice_temp)).Replace("\"", "'"));
                thisHtmlText.Append("</tr></tbody></table></div>");

                thisHtmlText.Append("<div><table style='width: 100 %; border - collapse:collapse;'><tbody><tr>");
                thisHtmlText.Append(HttpUtility.HtmlDecode(GetHtmlFoot(invoice_temp)).Replace("\"", "'"));
                thisHtmlText.Append("</tr></tbody></table></div>");
                #endregion


                // todo 通过模板  设定某些税相关不显示  暂时都显示


                table.Text = thisHtmlText.ToString();
            }
            catch (Exception)
            {
                Response.End();
            }

        }


        /// <summary>
        /// 为页面的下拉框配置数据源
        /// </summary>
        protected void PageDataBind()
        {
            invoice_temp_id.DataValueField = "id";
            invoice_temp_id.DataTextField = "name";
            invoice_temp_id.DataSource = dic.FirstOrDefault(_ => _.Key == "invoice_tmpl").Value;
            invoice_temp_id.DataBind();
            invoice_temp_id.SelectedValue = invoice_temp.id.ToString();

            accoultList.DataValueField = "id";
            accoultList.DataTextField = "name";
            accoultList.DataSource = accList;
            accoultList.DataBind();
            accoultList.SelectedValue = account.id.ToString();

        }

        /// <summary>
        /// 根据模板替换头文件
        /// </summary>
        private string GetHtmlHead(sys_quote_tmpl temp)
        {
            if (!string.IsNullOrEmpty(temp.page_header_html)) //todo--quote_header_html或者page_header_html
            {
                return GetVarSub(temp.page_header_html);
            }

            return "";
        }
        private string GetQuoteHead(sys_quote_tmpl temp)
        {
            if (!string.IsNullOrEmpty(temp.quote_header_html)) //todo--quote_header_html或者page_header_html
            {
                return GetVarSub(temp.quote_header_html);
            }

            return "";
        }
        /// <summary>
        /// 根据模板替换页面内容(页面可能时发票，或者是条目)
        /// </summary>
        private void GetHtmlBody(sys_quote_tmpl temp)
        {
            if (!string.IsNullOrEmpty(temp.body_html))
            {
                int AddNum = 1;
                var quote_body = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.BODY>(temp.body_html.Replace("'", "\""));  // 
                if (quote_body.GRID_COLUMN != null && quote_body.GRID_COLUMN.Count > 0)
                {
                    var aa = quote_body.CUSTOMIZE_THE_ITEM_COLUMN;
                    #region  拼接TH
                    thisHtmlText.Append("<thead><tr>");
                    foreach (var item in quote_body.GRID_COLUMN)
                    {
                        if (item.Display == "yes")
                        {
                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableHeader'>{item.Column_label}</td>");
                        }
                    }
                    thisHtmlText.Append("</tr></thead>");
                    #endregion

                    thisHtmlText.Append("<tbody>");
                    #region  拼接表格内容
                    if (paramList != null && paramList.Count > 0)
                    {

                        foreach (var param_item in paramList)
                        {

                            var accDedItem = new crm_account_deduction_dal().FindNoDeleteById(param_item.id);
                            if (accDedItem == null)
                                continue;

                            var billable_hours = param_item.billable_hours == null ? "" : ((decimal)param_item.billable_hours).ToString();
                            if (param_item.contract_type_id == (long)DicEnum.CONTRACT_TYPE.SERVICE || param_item.contract_type_id == (long)DicEnum.CONTRACT_TYPE.FIXED_PRICE)
                            {
                                billable_hours = "合同已包";
                            }
                            else if (param_item.contract_type_id == (long)DicEnum.CONTRACT_TYPE.BLOCK_HOURS || param_item.contract_type_id == (long)DicEnum.CONTRACT_TYPE.RETAINER)
                            {
                                if (!string.IsNullOrEmpty(param_item.billable))
                                {
                                    billable_hours = "预支付";
                                }

                            }
                            thisHtmlText.Append("<tr>");
                            foreach (var column_item in quote_body.GRID_COLUMN)
                            {
                                if (column_item.Display == "yes")
                                {
                                    switch (column_item.Column_Content)
                                    {
                                        case "发票中显示序列号，从1开始":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{AddNum}</td>");
                                            AddNum++;
                                            break;
                                        case "条目创建日期":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.item_date}</td>");
                                            break;
                                        case "条目描述":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'><span class='xiabiao'>{returnTaxIndex(param_item.tax_category_id)} {ChangeDescription(quote_body.CUSTOMIZE_THE_ITEM_COLUMN, accDedItem)}</span></td>");
                                            break;
                                        case "类型":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.item_type}</td>");
                                            break;
                                        case "员工姓名":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.resource_name}</td>");
                                            break;
                                        case "计费时间":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{billable_hours}</td>");
                                            break;
                                        case "数量":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.quantity}</td>");
                                            break;
                                        case "费率/成本":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.rate}</td>");
                                            break;
                                        case "税率":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{accDedItem.effective_tax_rate}</td>");
                                            break;
                                        case "税":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{accDedItem.tax_category_name}</td>");
                                            break;
                                        case "计费总额":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.dollars}</td>");
                                            break;
                                        case "小时费率":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.hourly_rate}</td>");
                                            break;
                                        case "角色":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.role_name}</td>");
                                            break;
                                        case "工作类型":
                                            thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.work_type}</td>");
                                            break;
                                        default:
                                            break;
                                    }
                                }
                            }
                            thisHtmlText.Append("</tr>");
                        }
                    }
                    #endregion

                    // todo 总价以及相关汇总

                    thisHtmlText.Append("</tbody></table>");
                    thisHtmlText.Append($"<div class='ReadOnlyGrid_Subtotal'>{account.name}: ¥{GetTotalMoney(paramList).ToString("#0.00")}</div>");

                    thisHtmlText.Append("</div>");

                    #region 计费到这个客户的条目

                    if (billTOThisParamList != null && billTOThisParamList.Count > 0)
                    {

                        var dicBillToThis = billTOThisParamList.GroupBy(_ => _.account_id).ToDictionary(_ => _.Key, _ => _.ToList());
                        foreach (var billToThis in dicBillToThis)
                        {
                            var billToThisAccount = new CompanyBLL().GetCompany((long)billToThis.Key);
                            if (billToThisAccount == null)
                                continue;
                            thisHtmlText.Append($"<div class='ReadOnlyGrid_Container'><div class='ReadOnlyGrid_Account'>{billToThis.Key}</div><table class='ReadOnlyGrid_Table' style='border-color: #ccc;'>");

                            #region  拼接TH
                            thisHtmlText.Append("<thead><tr>");
                            foreach (var item in quote_body.GRID_COLUMN)
                            {
                                if (item.Display == "yes")
                                {
                                    thisHtmlText.Append($"<td class='ReadOnlyGrid_TableHeader'>{item.Column_label}</td>");
                                }
                            }
                            thisHtmlText.Append("</tr></thead>");
                            #endregion

                            #region 拼接表格内容
                            foreach (var param_item in billToThis.Value as List<InvoiceDeductionDto>)
                            {
                                thisHtmlText.Append("<tbody><tr>");
                                foreach (var column_item in quote_body.GRID_COLUMN)
                                {
                                    if (column_item.Display == "yes")
                                    {
                                        switch (column_item.Column_Content)
                                        {
                                            case "日期":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.item_date}</td>");
                                                break;
                                            case "条目描述":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{"没有描述"}</td>");
                                                break;
                                            case "类型":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.item_type}</td>");
                                                break;
                                            case "员工姓名":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.resource_name}</td>");
                                                break;
                                            case "计费时间":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.billable_hours}</td>");
                                                break;
                                            case "数量":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.quantity}</td>");
                                                break;
                                            case "费率/成本":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.rate}</td>");
                                                break;
                                            case "税率":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{"税率"}</td>");
                                                break;
                                            case "税":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{"税"}</td>");
                                                break;
                                            case "计费总额":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.dollars}</td>");
                                                break;
                                            case "小时费率":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.hourly_rate}</td>");
                                                break;
                                            case "角色":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.role_name}</td>");
                                                break;
                                            case "工作类型":
                                                thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.work_type}</td>");
                                                break;
                                            default:
                                                break;
                                        }
                                    }
                                }
                                thisHtmlText.Append("</tr></tbody>");
                            }
                            #endregion
                            thisHtmlText.Append($"</table><div class='ReadOnlyGrid_Subtotal'>{billToThisAccount.name}: ¥{GetTotalMoney(billToThis.Value).ToString("#0.00")}</div></div>");
                        }
                    }

                    #endregion

                    // 计算总共的价钱
                    var totalMoney = GetTotalMoney(paramList) + GetTotalMoney(billTOThisParamList);
                    var totalTax = GetTotalTaxMoney(paramList) + GetTotalTaxMoney(billTOThisParamList);
                    string totalTaxHtml = "";
                    if (totalTax != 0)
                    {
                        totalTaxHtml = $"<tr class='invoiceTotalsRow'><td class='invoiceTotalsNameCell'>税额汇总</td><td class='invoiceTotalsValueCell'>{totalTax.ToString("#0.00")}</td></tr>";
                    }
                    var noBillHours = GetBillHours(paramList, false) + GetBillHours(billTOThisParamList, false);// 不计费
                    var billHours = GetBillHours(paramList, true) + GetBillHours(billTOThisParamList, true); // 计费
                    var prepaidHours = GetPrepaidHours(paramList) + GetPrepaidHours(billTOThisParamList);     // 预付费
                    var taxCate = GetTaxCateHtml();  // 分税信息的展示



                    thisHtmlText.Append($"<div><table style = 'width:100%; padding-top:20px; border-collapse:collapse;' ><tbody><tr><td style = 'vertical-align:top;' ></td><td style = 'vertical-align:top;width:300px; '><table class='InvoiceTotalsBlock'><tbody><tr class='invoiceTotalsRow'><td class='invoiceTotalsNameCell'>不计费时间</td><td class='invoiceTotalsValueCell'>{noBillHours.ToString("#0.00")}</td></tr><tr class='invoiceTotalsRow'> <td class='invoiceTotalsNameCell'>预付费时间</td><td class='invoiceTotalsValueCell'>{prepaidHours.ToString("#0.00")}</td></tr><tr class='invoiceTotalsRow'> <td class='invoiceTotalsNameCell'>付费时间汇总</td><td class='invoiceTotalsValueCell'>{billHours.ToString("#0.00")}</td></tr>{totalTaxHtml}<tr class='invoiceTotalsRow'><td class='invoiceTotalsNameCell'>总额汇总</td><td class='invoiceTotalsValueCell'>{totalMoney.ToString("#0.00")}</td></tr><tr class='invoiceTotalsRow'><td class='invoiceGrandTotalNameCell'>总价</td><td class='invoiceGrandTotalValueCell'>{(totalMoney + totalTax).ToString("#0.00")}</td></tr>{taxCate}</tbody></table></td></tr></tbody></table></div>");

                    #region


                    #endregion
                }
            }
            else
            {
                thisHtmlText.Append("</table></div>");
            }
            return;
        }
        /// <summary>
        /// 根据模板替换页脚
        /// </summary>
        private string GetHtmlFoot(sys_quote_tmpl temp)
        {
            if (!string.IsNullOrEmpty(temp.page_footer_html)) //todo--quote_header_html或者page_header_html
            {
                return GetVarSub(temp.page_footer_html);
            }

            return "";
        }

        private string GetQuoteFoot(sys_quote_tmpl temp)
        {
            if (!string.IsNullOrEmpty(temp.quote_footer_html)) //todo--quote_header_html或者page_header_html
            {
                return GetVarSub(temp.quote_footer_html);
            }

            return "";
        }


        /// <summary>
        /// 将模板中的变量替换
        /// </summary>
        private string GetVarSub(string thisText)
        {
            var _dal = new ctt_invoice_dal();
            Regex reg = new Regex(@"\[(.+?)]");
            var account_param = "'{\"a:id\":\"" + account.id + "\"}'";
            StringBuilder sqlList = new StringBuilder();
            var accountSql = new sys_query_type_user_dal().GetQuerySql(900, 900, GetLoginUserId(), account_param, null);
            var jifeiSql = new sys_query_type_user_dal().GetQuerySql(920, 920, GetLoginUserId(), "'{\"a:account_id\":\"" + account.id + "\"}'", null);
            sqlList.Append($"select * from ({accountSql}) as account,({jifeiSql}) as jifei");
            
            if (!string.IsNullOrEmpty(sqlList.ToString()))
            {
                List<ctt_invoice> invoiceList = null;
                if (isInvoice && (!string.IsNullOrEmpty(Request.QueryString["invoice_batch_id"])))
                {
                    invoiceList = new ctt_invoice_dal().GetInvoiceList("and batch_id ="+ Request.QueryString["invoice_batch_id"]);
                }
                
                // dateTable 里面所拥有的数据实体待确定
                var varTable = _dal.ExecuteDataTable(sqlList.ToString());
                foreach (Match m in reg.Matches(thisText))
                {
                    string t = m.Groups[0].ToString();
                    if (varTable.Columns.Contains(t) && !string.IsNullOrEmpty(varTable.Rows[0][t].ToString()))
                    {
                        thisText = thisText.Replace(t, varTable.Rows[0][t].ToString());
                    }
                    if (!isInvoice)  // 不发票的情况，参数从页面传递
                    {
                        switch (t)
                        {
                            case "[发票：号码/编号]":
                                thisText = thisText.Replace(t, "预览");
                                break;
                            case "[发票：日期范围始于]":
                                thisText = thisText.Replace(t, itemStartDatePara);
                                break;
                            case "[发票：日期范围至]":
                                thisText = thisText.Replace(t, itemEndDatePara);
                                break;
                            case "[发票：订单号]":
                                if (!string.IsNullOrEmpty(purchaseNo))
                                {
                                    thisText = thisText.Replace(t, purchaseNo);
                                }
                                else
                                {
                                    thisText = thisText.Replace(t, "");
                                }
                                break;
                            default:
                                break;
                        }
                    }
                    else // 将发票信息展示
                    {
                        if(invoiceList!=null&& invoiceList.Count > 0)
                        {
                            var thisInvoice = invoiceList[0];

                            switch (t)
                            {
                                case "[发票：号码/编号]":
                                    thisText = thisText.Replace(t, thisInvoice.invoice_no);
                                    break;
                                case "[发票：日期范围始于]":
                                    thisText = thisText.Replace(t, thisInvoice.date_range_from == null?"":((DateTime)thisInvoice.date_range_from).ToString("yyyy-MM-dd"));
                                    break;
                                case "[发票：日期范围至]":
                                    thisText = thisText.Replace(t, thisInvoice.date_range_to == null ? "" : ((DateTime)thisInvoice.date_range_to).ToString("yyyy-MM-dd"));
                                    break;
                                case "[发票：订单号]":
                                    thisText = thisText.Replace(t, thisInvoice.purchase_order_no);
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                  
                }

            }


            return thisText;
        }

        /// <summary>
        /// 不同类型的描述，将会显示不同的描述
        /// </summary>
        /// <param name="thisText"></param>
        /// <param name="accded"></param>
        /// <returns></returns>
        private string ChangeDescription(List<QuoteTemplateAddDto.CUSTOMIZE_THE_ITEM_COLUMNITEM> thisText,crm_account_deduction accded)
        {
            if (thisText != null && thisText.Count > 0)
            {
                var thisTypeSet = thisText.FirstOrDefault(_ => _.Type_of_Quote_Item_ID == accded.type_id.ToString());
                if (thisTypeSet != null)
                {
                    return GetVarSub(thisTypeSet.Display_Format);
                }
            }
            return "";
        }

        /// <summary>
        /// 获取到指定集合的总价
        /// </summary>
        /// <returns></returns>
        private decimal GetTotalMoney(List<InvoiceDeductionDto> param)
        {
            decimal totalMoney = 0;

            totalMoney = param.Sum(_ => _.dollars == null ? 0 : (decimal)_.dollars);
            return totalMoney;
        }

        private decimal GetTotalTaxMoney(List<InvoiceDeductionDto> param)
        {
            decimal totalTax = 0;
            var _dal = new crm_account_deduction_dal();
            if (param != null && param.Count > 0)
            {
                foreach (var item in param)
                {
                    var thisAccDed = _dal.FindNoDeleteById(item.id);
                    if (item.tax_category_id != null && thisAccDed.tax_dollars != null)
                    {
                        totalTax += (decimal)(thisAccDed.tax_dollars);  // 根据条目的税额进行计算
                    }

                }
            }
            return totalTax;
        }

        /// <summary>
        /// 根据税种ID返回税种的下标位置
        /// </summary>
        /// <param name="tax_id"></param>
        /// <returns></returns>
        private string returnTaxIndex(long? param)
        {
            // var taxList = dic.FirstOrDefault(_ => _.Key == "quote_item_tax_cate").Value as List<DictionaryEntryDto>;
            List<long> tacCateList = paramList.Where(_ => _.tax_category_id != null).Select(_ => (long)_.tax_category_id).ToList();
            if (billTOThisParamList != null && billTOThisParamList.Count > 0)
            {
                tacCateList.AddRange(billTOThisParamList.Where(_ => _.tax_category_id != null).Select(_ => (long)_.tax_category_id).ToList());
            }
            if (tacCateList != null && tacCateList.Count > 0 && param != null)
            {
                // var tax = taxList.FirstOrDefault(_ => _.val == param.ToString());
                return (tacCateList.IndexOf((long)param) + 1).ToString();
            }
            return "";
        }


        /// <summary>
        /// 返回集合中计费/不计费的时间
        /// </summary>
        private decimal GetBillHours(List<InvoiceDeductionDto> param, bool isBillable)
        {
            decimal hours = 0;
            if (param != null && param.Count > 0)
            {
                foreach (var item in param)
                {
                    if (isBillable)// 判断是否计费
                    {
                        if (!string.IsNullOrEmpty(item.billable)) // 代表计费的 
                        {
                            hours += item.billable_hours == null ? 0 : (decimal)item.billable_hours;
                        }
                    }
                    else
                    {
                        if (string.IsNullOrEmpty(item.billable)) // 代表不计费的 
                        {
                            hours += item.billable_hours == null ? 0 : (decimal)item.billable_hours;
                        }
                    }

                }
            }

            return hours;
        }
        // billable 是否为空
        // block——id 不为kong
        private decimal GetPrepaidHours(List<InvoiceDeductionDto> param)
        {
            decimal hours = 0;
            if (param != null && param.Count > 0)
            {
                foreach (var item in param)
                {
                    if (item.contract_block_id != null) // 代表预付费的 
                    {
                        hours += item.billable_hours == null ? 0 : (decimal)item.billable_hours;
                    }
                }
            }
            return hours;
        }

        private string GetTaxCateHtml()
        {
            List<long> tacCateList = paramList.Where(_ => _.tax_category_id != null).Select(_ => (long)_.tax_category_id).ToList();  // 所有的税种信息
            List<long> taxRegionList = paramList.Where(_ => _.tax_region_id != null).Select(_ => (long)_.tax_region_id).ToList();    // 所有的税区信息

            var thisParamList = paramList;
            if (billTOThisParamList != null && billTOThisParamList.Count > 0)
            {
                thisParamList.AddRange(billTOThisParamList);
                tacCateList.AddRange(billTOThisParamList.Where(_ => _.tax_category_id != null).Select(_ => (long)_.tax_category_id).ToList());

            }
            StringBuilder taxCateHtml = new StringBuilder();
            if (tacCateList != null && tacCateList.Count > 0 && account.tax_region_id != null)
            {
                var _dal = new crm_account_deduction_dal();
                var taxCateDal = new d_tax_region_cate_dal();
                var taxCateTaxDal = new d_tax_region_cate_tax_dal();
                // 需要计算出分税在这个税种中的金额
                foreach (var taxCate in tacCateList)   // 循环税种
                {
                    // 该税区下的所有分税信息
                    var thisGeneralTaxCate = new d_general_dal().FindNoDeleteById(taxCate);
                    Dictionary<string, decimal> taxRegionTaxDic = new Dictionary<string, decimal>();
                    // 计算出这个税总共的税额'
                    var thisTaxAllMoney = paramList.Where(_ => _.tax_category_id == taxCate).Sum(_ =>
                    {
                        var thisAccDed = _dal.FindNoDeleteById(_.id);
                        if (thisAccDed != null && thisAccDed.tax_dollars != null)
                        { return (decimal)thisAccDed.tax_dollars; }
                        return 0;
                    });
                    if (thisTaxAllMoney == 0)  //金额为0 不显示？--todo待确认
                    {
                        continue;
                    }
                    taxCateHtml.Append($"<tr><td>{thisGeneralTaxCate.name}</td><td>{thisTaxAllMoney}</td></tr>");
                    var thisTaxCate = taxCateDal.GetSingleTax((long)account.tax_region_id, taxCate);
                    var taxCateList = taxCateTaxDal.GetTaxRegionCate(thisTaxCate.id);
                    foreach (var item in taxCateList)
                    {
                        var thisMoney = thisTaxAllMoney * (item.tax_rate / thisTaxCate.total_effective_tax_rate);
                        var thisName = item.tax_name;
                        if (thisMoney == 0)
                        {
                            continue;
                        }
                        taxCateHtml.Append($"<tr><td>{thisName}</td><td>{thisMoney}</td></tr>");
                    }
                }
            }
            return taxCateHtml.ToString();
        }
    }
}