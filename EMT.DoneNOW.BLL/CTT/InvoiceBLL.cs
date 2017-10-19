using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Text.RegularExpressions;

namespace EMT.DoneNOW.BLL
{
    public class InvoiceBLL
    {
        private readonly ctt_invoice_dal _dal = new ctt_invoice_dal();

        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("invoice_tmpl", new sys_quote_tmpl_dal().GetInvoiceTemp());  // 发票模板
            dic.Add("taxRegion", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TAX_REGION)));
            dic.Add("email_temp", new sys_quote_email_tmpl_dal().GetEmailTemlList());
            dic.Add("department", new sys_department_dal().GetDepartment());
            dic.Add("contract_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.CONTRACT_TYPE)));
            dic.Add("contract_cate", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.CONTRACT_CATE)));
            dic.Add("account_deduction_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.ACCOUNT_DEDUCTION_TYPE)));
            dic.Add("payment_term", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_TERM)));
            dic.Add("quote_item_tax_cate", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_TAX_CATE)));
            return dic;// PAYMENT_TERM
        }

        /// <summary>
        /// 发票处理/生成发票向导--针对多个发票处理
        /// </summary>
        /// <returns></returns>
        public bool ProcessInvoice(InvoiceDealDto param, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);

            var temp = new sys_quote_tmpl_dal().FindNoDeleteById(param.invoice_template_id);
            if (user == null || temp == null)
                return false;
            //  var arr = param.ids.Split(new char[]{','}, StringSplitOptions.RemoveEmptyEntries);
            //if (arr != null && arr.Count() > 0)
            if(!string.IsNullOrEmpty(param.ids))
            {
                var invoiceBatch = _dal.GetNextIdInvBat();
                param.invoice_batch = invoiceBatch;
                var cadDal = new crm_account_deduction_dal();
                var cidDal = new ctt_invoice_detail_dal();
                var comBLL = new CompanyBLL();
                var thisAccList = cadDal.GetAccDeds(param.ids);
                var thisAccDtoList = cadDal.GetInvDedDtoList($" and id in({param.ids})");

                var dicList = thisAccList.GroupBy(_ => _.account_id).ToDictionary(_ => _.Key, _ => _.ToList());

                if (dicList != null && dicList.Count > 0)
                {
                    foreach (var item in dicList)
                    {
                        var account = comBLL.GetCompany(item.Key);

                        var noPurOrderList = item.Value.Where(_ => string.IsNullOrEmpty(_.purchase_order_no)).ToList(); // 代表无
                        var purchOrderList = item.Value.Where(_ => !string.IsNullOrEmpty(_.purchase_order_no)).ToList();
                        if (noPurOrderList != null && noPurOrderList.Count > 0)
                        {
                            #region 没有销售订单的条目，计费到这个客户的和这个客户的条目
                            var thisNoPurOrdList = thisAccDtoList.Where(_ => string.IsNullOrEmpty(_.purchase_order_no) && _.account_id == item.Key && _.bill_account_id == item.Key).ToList();
                            var billToThisNoPurOrdList = thisAccDtoList.Where(_ => string.IsNullOrEmpty(_.purchase_order_no) && _.account_id != item.Key && _.bill_account_id == item.Key).ToList();
                            var totalHtml = ReturnTotalHtml(thisNoPurOrdList, billToThisNoPurOrdList, account);
                            StringBuilder thisIds = new StringBuilder();
                            if(thisNoPurOrdList!=null&& thisNoPurOrdList.Count > 0)
                            {
                                thisNoPurOrdList.ForEach(_ => thisIds.Append(_.id.ToString() + ","));
                            }
                            if (billToThisNoPurOrdList != null && billToThisNoPurOrdList.Count > 0)
                            {
                                billToThisNoPurOrdList.ForEach(_ => thisIds.Append(_.id.ToString() + ","));
                            }
                            var stringIds = thisIds.ToString();
                            if (!string.IsNullOrEmpty(stringIds))
                            {
                                stringIds = stringIds.Substring(0, stringIds.Length-1);
                                param.thisIds = stringIds;
                            }
                            #endregion

                            if (account.resource_id == null) // 客户的客户经理在发票中是必填项，没有客户经理暂时不创建发票
                            {
                                continue;
                            }
                            var invoiceNo= _dal.GetNextIdInvNo().ToString();
                            param.invoiceNo = invoiceNo;
                            var invocie = new ctt_invoice()
                            {
                                id = _dal.GetNextIdCom(),
                                batch_id = invoiceBatch,
                                account_id = account.id,
                                owner_resource_id = (long)account.resource_id,
                                invoice_no = invoiceNo,
                                invoice_date = param.invoice_date,
                                total = item.Value.Sum(_ => _.extended_price == null ? 0 : _.extended_price),
                                tax_value = item.Value.Sum(_ => _.tax_dollars == null ? 0 : _.tax_dollars),
                                date_range_from = param.date_range_from,
                                date_range_to = param.date_range_to,
                                payment_term_id = param.payment_term_id,
                                purchase_order_no = "",
                                invoice_template_id = param.invoice_template_id,
                                page_header_html =  GetVarSub(temp.page_header_html, user, account, param),
                                page_footer_html = GetVarSub(temp.page_footer_html, user, account, param),
                                invoice_header_html = GetVarSub(temp.quote_header_html, user, account, param),
                                invoice_body_html = RetuenBody(thisNoPurOrdList, billToThisNoPurOrdList, temp,account), 
                                invoice_footer_html = totalHtml+GetVarSub(temp.quote_footer_html, user, account, param),
                                invoice_appendix_html = "", // 模板里面没有todo
                                tax_region_name = account.tax_region_id == null ? "" : new GeneralBLL().GetGeneralName((int)account.tax_region_id),
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                create_user_id = user.id,
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_user_id = user.id,
                            };
                            _dal.Insert(invocie);
                            new sys_oper_log_dal().Insert(new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.INVOCIE,
                                oper_object_id = invocie.id,// 操作对象id
                                oper_type_id = (int)DicEnum.OPER_LOG_TYPE.ADD,
                                oper_description = _dal.AddValue(invocie),
                                remark = "保存发票"
                            });
                            var udf_contract_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);
                            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.COMPANY, user.id, invocie.id, udf_contract_list, param.udf, OPER_LOG_OBJ_CATE.CONTRACT_EXTENSION);
                            var invDetail = new ctt_invoice_detail()
                            {
                                invoice_id = invocie.id,
                                //is_emailed = (sbyte)(param.isInvoiceEmail?1:0),    
                            };
                            cidDal.Insert(invDetail);
                            new sys_oper_log_dal().Insert(new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.INVOCIE_DETAIL,
                                oper_object_id = invDetail.invoice_id,// 操作对象id
                                oper_type_id = (int)DicEnum.OPER_LOG_TYPE.ADD,
                                oper_description = _dal.AddValue(invDetail),
                                remark = "保存发票详情"
                            });
                            int invoice_line = 1;
                           if(thisNoPurOrdList!=null&& thisNoPurOrdList.Count > 0)
                            {
                                foreach (var thisDto in thisNoPurOrdList)
                                {
                                   var thisacc_ded = cadDal.FindNoDeleteById(thisDto.id);
                                    thisacc_ded.invoice_id = invocie.id;
                                    thisacc_ded.invoice_line_item_no = invoice_line;
                                    invoice_line += 1;
                                    new sys_oper_log_dal().Insert(new sys_oper_log()
                                    {
                                        user_cate = "用户",
                                        user_id = user.id,
                                        name = user.name,
                                        phone = user.mobile == null ? "" : user.mobile,
                                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,
                                        oper_object_id = thisacc_ded.id,// 操作对象id
                                        oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                                        oper_description = _dal.CompareValue(cadDal.FindNoDeleteById(thisacc_ded.id), thisacc_ded),
                                        remark = ""
                                    });
                                    cadDal.Update(thisacc_ded);
                                }
                            }
                            if (billToThisNoPurOrdList != null && billToThisNoPurOrdList.Count > 0)
                            {
                                foreach (var thisDto in billToThisNoPurOrdList)
                                {
                                    var thisacc_ded = cadDal.FindNoDeleteById(thisDto.id);
                                    thisacc_ded.invoice_id = invocie.id;
                                    thisacc_ded.invoice_line_item_no = invoice_line;
                                    invoice_line += 1;
                                    new sys_oper_log_dal().Insert(new sys_oper_log()
                                    {
                                        user_cate = "用户",
                                        user_id = user.id,
                                        name = user.name,
                                        phone = user.mobile == null ? "" : user.mobile,
                                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,
                                        oper_object_id = thisacc_ded.id,// 操作对象id
                                        oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                                        oper_description = _dal.CompareValue(cadDal.FindNoDeleteById(thisacc_ded.id), thisacc_ded),
                                        remark = ""
                                    });
                                    cadDal.Update(thisacc_ded);
                                }
                            }

                        }
                        if (purchOrderList != null && purchOrderList.Count > 0)
                        {
                            var poDic = purchOrderList.GroupBy(_ => _.purchase_order_no).ToDictionary(_ => _.Key, _ => _.ToList());
                            if (poDic != null && poDic.Count > 0)
                            {
                                foreach (var po in poDic)
                                {
                                    var thisPurOrdList = thisAccDtoList.Where(_ => !string.IsNullOrEmpty(_.purchase_order_no) && _.account_id == item.Key && _.bill_account_id == item.Key).ToList();
                                    var billToThisPurOrdList = thisAccDtoList.Where(_ =>!string.IsNullOrEmpty(_.purchase_order_no) && _.account_id != item.Key && _.bill_account_id == item.Key).ToList();

                                    var totalHtml = ReturnTotalHtml(thisPurOrdList, billToThisPurOrdList, account);
                                    StringBuilder thisIds = new StringBuilder();
                                    if (thisPurOrdList != null && thisPurOrdList.Count > 0)
                                    {
                                        thisPurOrdList.ForEach(_ => thisIds.Append(_.id.ToString() + ","));
                                    }
                                    if (billToThisPurOrdList != null && billToThisPurOrdList.Count > 0)
                                    {
                                        billToThisPurOrdList.ForEach(_ => thisIds.Append(_.id.ToString() + ","));
                                    }
                                    var stringIds = thisIds.ToString();
                                    if (!string.IsNullOrEmpty(stringIds))
                                    {
                                        stringIds = stringIds.Substring(0, stringIds.Length - 1);
                                        param.thisIds = stringIds;
                                    }
                                    var invoiceNo = _dal.GetNextIdInvNo().ToString();
                                    param.invoiceNo = invoiceNo;
                                    var invocie = new ctt_invoice()
                                    {
                                        id = _dal.GetNextIdCom(),
                                        batch_id = invoiceBatch,
                                        account_id = account.id,
                                        owner_resource_id = (long)account.resource_id,
                                        invoice_no = invoiceNo,
                                        invoice_date = param.invoice_date,
                                        total = item.Value.Sum(_ => _.extended_price == null ? 0 : _.extended_price),
                                        tax_value = item.Value.Sum(_ => _.tax_dollars == null ? 0 : _.tax_dollars),
                                        date_range_from = param.date_range_from,
                                        date_range_to = param.date_range_to,
                                        payment_term_id = param.payment_term_id,
                                        purchase_order_no = po.Key,
                                        invoice_template_id = param.invoice_template_id,
                                        page_header_html = GetVarSub(temp.page_header_html, user, account,param),
                                        page_footer_html = GetVarSub(temp.page_footer_html, user, account, param),
                                        invoice_header_html = GetVarSub(temp.quote_header_html, user, account, param),
                                        invoice_body_html = RetuenBody(thisPurOrdList, billToThisPurOrdList, temp, account),
                                        invoice_footer_html = totalHtml+ GetVarSub(temp.quote_footer_html, user, account, param),
                                        invoice_appendix_html = "", // 模板里面没有todo
                                        tax_region_name = account.tax_region_id == null ? "" : new GeneralBLL().GetGeneralName((int)account.tax_region_id),
                                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        create_user_id = user.id,
                                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        update_user_id = user.id,
                                    };
                                    _dal.Insert(invocie);
                                    new sys_oper_log_dal().Insert(new sys_oper_log()
                                    {
                                        user_cate = "用户",
                                        user_id = user.id,
                                        name = user.name,
                                        phone = user.mobile == null ? "" : user.mobile,
                                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.INVOCIE,
                                        oper_object_id = invocie.id,// 操作对象id
                                        oper_type_id = (int)DicEnum.OPER_LOG_TYPE.ADD,
                                        oper_description = _dal.AddValue(invocie),
                                        remark = "保存发票"
                                    });
                                    var udf_contract_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);
                                    new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.COMPANY, user.id, invocie.id, udf_contract_list, param.udf, OPER_LOG_OBJ_CATE.CONTRACT_EXTENSION);

                                    var invDetail = new ctt_invoice_detail()
                                    {
                                        invoice_id = invocie.id,
                                        //is_emailed = (sbyte)(param.isInvoiceEmail?1:0),    
                                    };
                                    cidDal.Insert(invDetail);
                                    new sys_oper_log_dal().Insert(new sys_oper_log()
                                    {
                                        user_cate = "用户",
                                        user_id = user.id,
                                        name = user.name,
                                        phone = user.mobile == null ? "" : user.mobile,
                                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.INVOCIE_DETAIL,
                                        oper_object_id = invDetail.invoice_id,// 操作对象id
                                        oper_type_id = (int)DicEnum.OPER_LOG_TYPE.ADD,
                                        oper_description = _dal.AddValue(invDetail),
                                        remark = "保存发票详情"
                                    });
                                    int invoice_line = 1;
                                    if (thisPurOrdList != null && thisPurOrdList.Count > 0)
                                    {
                                        foreach (var thisDto in thisPurOrdList)
                                        {
                                            var thisacc_ded = cadDal.FindNoDeleteById(thisDto.id);
                                            thisacc_ded.invoice_id = invocie.id;
                                            thisacc_ded.invoice_line_item_no = invoice_line;
                                            invoice_line += 1;
                                            new sys_oper_log_dal().Insert(new sys_oper_log()
                                            {
                                                user_cate = "用户",
                                                user_id = user.id,
                                                name = user.name,
                                                phone = user.mobile == null ? "" : user.mobile,
                                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                                oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,
                                                oper_object_id = thisacc_ded.id,// 操作对象id
                                                oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                                                oper_description = _dal.CompareValue(cadDal.FindNoDeleteById(thisacc_ded.id), thisacc_ded),
                                                remark = ""
                                            });
                                            cadDal.Update(thisacc_ded);
                                        }
                                    }
                                    if (billToThisPurOrdList != null && billToThisPurOrdList.Count > 0)
                                    {
                                        foreach (var thisDto in billToThisPurOrdList)
                                        {
                                            var thisacc_ded = cadDal.FindNoDeleteById(thisDto.id);
                                            thisacc_ded.invoice_id = invocie.id;
                                            thisacc_ded.invoice_line_item_no = invoice_line;
                                            invoice_line += 1;
                                            new sys_oper_log_dal().Insert(new sys_oper_log()
                                            {
                                                user_cate = "用户",
                                                user_id = user.id,
                                                name = user.name,
                                                phone = user.mobile == null ? "" : user.mobile,
                                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                                oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,
                                                oper_object_id = thisacc_ded.id,// 操作对象id
                                                oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                                                oper_description = _dal.CompareValue(cadDal.FindNoDeleteById(thisacc_ded.id), thisacc_ded),
                                                remark = ""
                                            });
                                            cadDal.Update(thisacc_ded);
                                        }
                                    }
                                    foreach (var thisacc_ded in po.Value)
                                    {
                                        thisacc_ded.invoice_id = invocie.id;
                                        thisacc_ded.invoice_line_item_no = invoice_line;
                                        invoice_line += 1;
                                        new sys_oper_log_dal().Insert(new sys_oper_log()
                                        {
                                            user_cate = "用户",
                                            user_id = user.id,
                                            name = user.name,
                                            phone = user.mobile == null ? "" : user.mobile,
                                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                            oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,
                                            oper_object_id = thisacc_ded.id,// 操作对象id
                                            oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                                            oper_description = _dal.CompareValue(cadDal.FindNoDeleteById(thisacc_ded.id), thisacc_ded),
                                            remark = ""
                                        });
                                        cadDal.Update(thisacc_ded);
                                    }
                                }
                            }
                        }
                    }
                }




                return true;
            }
            return false;
        }




        /// <summary>
        /// 发票设置
        /// </summary>
        /// <returns></returns>
        public bool PreferencesInvoice(PreferencesInvoiceDto param, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            var account = new CompanyBLL().GetCompany(param.accRef.account_id);
            if (user == null || account == null)
                return false;

            param.accRef.update_user_id = user.id;
            param.accRef.update_time = param.accRef.create_time;
            var oldAccRef = new crm_account_reference_dal().GetAccountRef(param.accRef.account_id);
            if (oldAccRef == null)
            {
                param.accRef.create_user_id = user.id;
                param.accRef.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                new crm_account_reference_dal().Insert(param.accRef);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.REFERENCE,
                    oper_object_id = param.accRef.account_id,// 操作对象id
                    oper_type_id = (int)DicEnum.OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(param.accRef),
                    remark = "添加发票设置"
                });
            }
            else
            {
                new crm_account_reference_dal().Update(param.accRef);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.REFERENCE,
                    oper_object_id = param.accRef.account_id,// 操作对象id
                    oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.CompareValue(oldAccRef, param.accRef),
                    remark = "修改发票设置"
                });
            }


            if (account.is_tax_exempt == param.is_tax_exempt && account.tax_region_id == param.tax_region_id && account.tax_identification == param.tax_identification)
            {
                return true;
            }
            else
            {
                account.is_tax_exempt = (sbyte)param.is_tax_exempt;
                account.tax_identification = param.tax_identification;
                account.tax_region_id = param.tax_region_id;
                account.tax_region_id = account.tax_region_id == 0 ? null : account.tax_region_id;
                account.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                account.update_user_id = user.id;
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CUSTOMER,
                    oper_object_id = account.id,
                    oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.CompareValue(new CompanyBLL().GetCompany(param.accRef.account_id), account),
                    remark = "修改客户信息"
                });
                new crm_account_dal().Update(account);
            }


            return true;
        }

        #region 发票模板中的变量替换--处理发票使用
        private string GetVarSub(string thisText, UserInfoDto user,crm_account account, InvoiceDealDto param)
        {
            if (string.IsNullOrEmpty(thisText))
                return "";
            thisText = thisText.Replace("&gt;", ">");
            thisText = thisText.Replace("&lt;", "<");
            thisText = thisText.Replace("&nbsp;", " ");
            thisText = thisText.Replace("&amp;", " ");

            var _dal = new ctt_invoice_dal();
            Regex reg = new Regex(@"\[(.+?)]");
            var account_param = "'{\"a:id\":\"" + account.id + "\"}'";

            var accountSql = new sys_query_type_user_dal().GetQuerySql(900, 900, user.id, account_param, null);  // 客户相关查询
            if (!string.IsNullOrEmpty(accountSql))
            {
                var varTable = _dal.ExecuteDataTable(accountSql.ToString());
                if (varTable.Rows.Count > 0)
                {
                    foreach (Match m in reg.Matches(thisText))
                    {
                        string t = m.Groups[0].ToString();
                        if (varTable.Columns.Contains(t))
                        {
                            if (!string.IsNullOrEmpty(varTable.Rows[0][t].ToString()))
                            {
                                thisText = thisText.Replace(t, varTable.Rows[0][t].ToString());
                            }
                            else
                            {
                                thisText = thisText.Replace(t, "");
                            }

                        }
                    }
                }
            }


            var jifeiSql = new sys_query_type_user_dal().GetQuerySql(920, 920, user.id, "'{\"a:account_id\":\"" + account.id + "\"}'", null);    // 计费相关查询
            if (!string.IsNullOrEmpty(jifeiSql))
            {
                var varTable = _dal.ExecuteDataTable(jifeiSql.ToString());
                if (varTable.Rows.Count > 0)
                {
                    foreach (Match m in reg.Matches(thisText))
                    {
                        string t = m.Groups[0].ToString();
                        if (varTable.Columns.Contains(t))
                        {
                            if (!string.IsNullOrEmpty(varTable.Rows[0][t].ToString()))
                            {
                                thisText = thisText.Replace(t, varTable.Rows[0][t].ToString());
                            }
                            else
                            {
                                thisText = thisText.Replace(t, "");
                            }

                        }
                    }
                }

            }

       

            var companySql = new sys_query_type_user_dal().GetQuerySql(927, 927, user.id, "'{}'", null);
            if (!string.IsNullOrEmpty(companySql))
            {
                var varTable = _dal.ExecuteDataTable(companySql.ToString());
                if (varTable.Rows.Count > 0)
                {
                    foreach (Match m in reg.Matches(thisText))
                    {
                        string t = m.Groups[0].ToString();
                        if (varTable.Columns.Contains(t))
                        {
                            if (!string.IsNullOrEmpty(varTable.Rows[0][t].ToString()))
                            {
                                thisText = thisText.Replace(t, varTable.Rows[0][t].ToString());
                            }
                            else
                            {
                                thisText = thisText.Replace(t, "");
                            }
                        }
                    }
                }
            }
            if (!string.IsNullOrEmpty(param.thisIds))
            {
                var invoiceSql = new sys_query_type_user_dal().GetQuerySql(925, 925, user.id, "'{\"a:id\":\"" + param.thisIds + "\"}'", null);
                if (!string.IsNullOrEmpty(invoiceSql))
                {
                    var varTable = _dal.ExecuteDataTable(invoiceSql.ToString());
                    if (varTable.Rows.Count > 0)
                    {
                        foreach (Match m in reg.Matches(thisText))
                        {
                            string t = m.Groups[0].ToString();

                            if (varTable.Columns.Contains(t))
                            {
                                switch (t)
                                {
                                    case "[发票：号码/编号]":
                                    case "[发票：编号]":
                                        thisText = thisText.Replace(t, param.invoiceNo);
                                        break;
                                    case "[发票：日期范围始于]":
                                        thisText = thisText.Replace(t, param.date_range_from==null?"":((DateTime)param.date_range_from).ToString("yyyy-MM-dd"));
                                        break;
                                    case "[发票：日期范围至]":
                                        thisText = thisText.Replace(t, param.date_range_to == null ? "" : ((DateTime)param.date_range_to).ToString("yyyy-MM-dd"));
                                        break;
                                    case "[发票：订单号]":
                                        thisText = thisText.Replace(t, param.purchase_order_no);
                                        break;
                                    case "[发票：日期]":
                                        thisText = thisText.Replace(t, param.invoice_date.ToString("yyyy-MM-dd"));
                                        break;
                                    case "[发票：发票记录]":
                                        thisText = thisText.Replace(t, param.notes);
                                        break;
                                    default:
                                        if (!string.IsNullOrEmpty(varTable.Rows[0][t].ToString()))
                                        {
                                            thisText = thisText.Replace(t, varTable.Rows[0][t].ToString());
                                        }
                                        else
                                        {
                                            thisText = thisText.Replace(t, "");
                                        }
                                        break;
                                }
                            }
                        }
                    }

                }
            }
          

             var zaSql = new sys_query_type_user_dal().GetQuerySql(913, 913, user.id, "'{}'", null);
            if (!string.IsNullOrEmpty(zaSql))
            {
                var varTable = _dal.ExecuteDataTable(zaSql.ToString());
                if (varTable.Rows.Count > 0)
                {
                    foreach (Match m in reg.Matches(thisText))
                    {
                        string t = m.Groups[0].ToString();
                        if (varTable.Columns.Contains(t))
                        {
                            if (t == "[Miscellaneous: Primary Logo (Requires HTML)]")
                            {
                                thisText = thisText.Replace(t, $"<img src='{varTable.Rows[0][t].ToString()}' />");
                                continue;
                            }
                            if (!string.IsNullOrEmpty(varTable.Rows[0][t].ToString()))
                            {
                                thisText = thisText.Replace(t, varTable.Rows[0][t].ToString());
                            }
                            else
                            {
                                thisText = thisText.Replace(t, "");
                            }

                        }
                    }
                }

            }


            foreach (Match m in reg.Matches(thisText))
            {
                string t = m.Groups[0].ToString();
                thisText = thisText.Replace(t, "");
            }

            return thisText;
        }
        /// <summary>
        /// 根据模板展示发票的相关内容
        /// </summary>
        private string RetuenBody(List<InvoiceDeductionDto> thisParamList, List<InvoiceDeductionDto> billTOThisParamList, sys_quote_tmpl temp,crm_account account)
        {
            if (thisParamList != null && thisParamList.Count > 0 && temp != null &&(!string.IsNullOrEmpty(temp.body_html)))
            {
                var quote_body = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.BODY>(temp.body_html.Replace("'", "\""));
                if (quote_body.GRID_COLUMN != null && quote_body.GRID_COLUMN.Count > 0)
                {
                    StringBuilder stringBodyHtml = new StringBuilder();
                    #region 追加样式
                    stringBodyHtml.Append("<style type='text/css'> .ReadOnlyGrid_Table { width: 100%; border:1px black solid; border-collapse: collapse; font-family: Tahoma, Arial, 'Arial Unicode MS'; font-size:8pt; font-weight:normal; font-style:normal; text-decoration:none; color: #000; line-height: normal; } .ReadOnlyGrid_Table tr { page-break-inside: avoid; } .ReadOnlyGrid_TableHeader { background-color: #f3f3f3; border: 1px black solid; padding: 3px; } .ReadOnlyGrid_TableCell { vertical-align: top; padding: 3px; } .ReadOnlyGrid_TableFirstColumn { border-left:1px black transparent; } .ReadOnlyGrid_TableOtherColumn { border-left:1px black solid; } .ReadOnlyGrid_TableRowGroup { } .ReadOnlyGrid_TableLastRow { border-bottom: 1px black solid; } .ReadOnlyGrid_TableRowDivide { border-top:1px #ccc solid; } .ReadOnlyGrid_TableRowItemized { color: #666; } .ReadOnlyGrid_TableRowItemized .ReadOnlyGrid_Superscript { color: #666; } .ReadOnlyGrid_TableRowNonGroup { } .ReadOnlyGrid_Table td td { border: none; padding: 0px 3px 0px 0px; vertical-align:top; } .ReadOnlyGrid_Superscript { border: 1px black transparent; border-spacing: 0px; border-collapse: collapse; font-weight:normal; font-style:normal; text-decoration:none; } .ReadOnlyGrid_SuperscriptDesc { font-size:8pt; } .ReadOnlyGrid_SuperscriptCell { font-size:6pt; vertical-align: top; } .ReadOnlyGrid_Account { font-weight:bold; font-style:normal; text-decoration:none; } .ReadOnlyGrid_Subtotal { font-weight:bold; font-style:normal; text-decoration:none; text-align: right; } .ReadOnlyGrid_Container { font-family: Tahoma, Arial, 'Arial Unicode MS'; font-size:8pt; width: 100%; line-height: 200%; padding-top: 12px; } .PreviewInvoice_TaxBlockTable { font-family: Tahoma, Arial, 'Arial Unicode MS'; font-size: 8pt; } .PreviewInvoice_TaxRegionCell { font-weight: bold; padding-top: 10px; } .PreviewInvoice_TaxCategoryCell { } .PreviewInvoice_TaxCategoryName { font-weight :bold; } .PreviewInvoice_TaxCategoryAmountCell { text-align:right; } .PreviewInvoice_TaxIndividualCell { } .PreviewInvoice_TaxIndividualCellIndent { padding-left:15px; } .PreviewInvoice_TaxIndividualName { font-weight:bold; } .PreviewInvoice_TaxIndividualAmountCell { text-align: right; padding-left: 30px; } .PreviewInvoice_ContractBalanceTable { font-family: Tahoma, Arial, 'Arial Unicode MS'; font-size: 8pt; } .PreviewInvoice_ContractBalanceTitle { font-weight:bold; } .PreviewInvoice_ContractBalanceCell { } .PreviewInvoice_ContractBalanceSeparateCell { padding-bottom:10px; } .InvoiceTotalsBlock { width:100%; border-collapse:collapse; } .invoiceTotalsRow { height:20px; } .invoiceTotalsNameCell { font-weight:bold; text-align:left; vertical-align:top } .invoiceTotalsValueCell { text-align:right; width:120px; vertical-align:top } .invoiceGrandTotalNameCell { font-weight:bold; text-align:left; vertical-align:top;font-size:12pt; } .invoiceGrandTotalValueCell { font-weight:bold; text-align:right; width:120px; vertical-align:top;font-size:12pt; } .invoiceTotalsCellSpan { height:10px; } </style>");
                    #endregion
                    stringBodyHtml.Append($"<div class='ReadOnlyGrid_Container'><div class='ReadOnlyGrid_Account'>{account.name}</div><table class='ReadOnlyGrid_Table' style='border-color: #ccc;'>");
                    #region  拼接TH
                    stringBodyHtml.Append("<thead><tr>");
                    foreach (var item in quote_body.GRID_COLUMN)
                    {
                        if (item.Display == "yes")
                        {
                            stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableHeader'>{item.Column_label}</td>");
                        }
                    }
                    stringBodyHtml.Append("</tr></thead>");
                    #endregion
                    #region 拼接相关内容
                    var itemTypeList = new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.ACCOUNT_DEDUCTION_TYPE));
                    int AddNum = 1;
                    foreach (var param_item in thisParamList)
                    {
                        // accDedItem  param_item
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
                        stringBodyHtml.Append("<tr>");
                        foreach (var column_item in quote_body.GRID_COLUMN)
                        {
                            if (column_item.Display == "yes")
                            {
                                switch (column_item.Column_Content)
                                {
                                    case "发票中显示序列号，从1开始":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{AddNum}</td>");
                                            AddNum++;
                                        break;
                                    case "条目创建日期":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.item_date.ToString("yyyy-MM-dd")}</td>");
                                        break;
                                    case "条目描述":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.item_desc}</td>");
                                        break;
                                    case "类型":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{itemTypeList.FirstOrDefault(_ => _.val == param_item.item_type.ToString()).show}</td>");
                                        break;
                                    case "员工姓名":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.resource_name}</td>");
                                        break;
                                    case "计费时间":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{billable_hours}</td>");
                                        break;
                                    case "数量":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.quantity}</td>");
                                        break;
                                    case "费率/成本":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.rate}</td>");
                                        break;
                                    case "税率":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{accDedItem.effective_tax_rate}</td>");
                                        break;
                                    case "税":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{accDedItem.tax_category_name}</td>");
                                        break;
                                    case "计费总额":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.dollars}</td>");
                                        break;
                                    case "小时费率":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.hourly_rate}</td>");
                                        break;
                                    case "角色":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.role_name}</td>");
                                        break;
                                    case "工作类型":
                                        stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.work_type}</td>");
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }
                        stringBodyHtml.Append("</tr>");
                    }
                    #endregion
                    stringBodyHtml.Append($"</table><div class='ReadOnlyGrid_Subtotal'>{account.name}: ¥{GetTotalMoney(thisParamList).ToString("#0.00")}</div></div>");
                    #region 付费到这个客户的条目
                    if (billTOThisParamList != null && billTOThisParamList.Count > 0)
                    {

                        var dicBillToThis = billTOThisParamList.GroupBy(_ => _.account_id).ToDictionary(_ => _.Key, _ => _.ToList());
                        foreach (var billToThis in dicBillToThis)
                        {
                            var billToThisAccount = new CompanyBLL().GetCompany((long)billToThis.Key);
                            if (billToThisAccount == null)
                                continue;

                            stringBodyHtml.Append($"<div class='ReadOnlyGrid_Container'><div class='ReadOnlyGrid_Account'>{billToThis.Key}</div><table class='ReadOnlyGrid_Table' style='border-color: #ccc;'>");

                            #region  拼接TH
                            stringBodyHtml.Append("<thead><tr>");
                            foreach (var item in quote_body.GRID_COLUMN)
                            {
                                if (item.Display == "yes")
                                {
                                    stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableHeader'>{item.Column_label}</td>");
                                }
                            }
                            stringBodyHtml.Append("</tr></thead>");
                            #endregion

                            #region 拼接表格内容
                            foreach (var param_item in billToThis.Value as List<InvoiceDeductionDto>)
                            {
                              
                                stringBodyHtml.Append("<tbody><tr>");
                                foreach (var column_item in quote_body.GRID_COLUMN)
                                {
                                    if (column_item.Display == "yes")
                                    {
                                        switch (column_item.Column_Content)
                                        {
                                            case "日期":
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.item_date.ToString("yyyy-MM-dd")}</td>");
                                                break;
                                            case "条目描述":
                                                //thisHtmlText.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{"没有描述"}</td>");
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.item_desc}</td>");
                                                break;
                                            case "类型":

                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{itemTypeList.FirstOrDefault(_ => _.val == param_item.item_type.ToString()).show}</td>");
                                                break;
                                            case "员工姓名":
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.resource_name}</td>");
                                                break;
                                            case "计费时间":
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.billable_hours}</td>");
                                                break;
                                            case "数量":
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.quantity}</td>");
                                                break;
                                            case "费率/成本":
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.rate}</td>");
                                                break;
                                            case "税率":
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{"税率"}</td>");
                                                break;
                                            case "税":
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{"税"}</td>");
                                                break;
                                            case "计费总额":
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.dollars}</td>");
                                                break;
                                            case "小时费率":
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.hourly_rate}</td>");
                                                break;
                                            case "角色":
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.role_name}</td>");
                                                break;
                                            case "工作类型":
                                                stringBodyHtml.Append($"<td class='ReadOnlyGrid_TableOtherColumn ReadOnlyGrid_TableCell'>{param_item.work_type}</td>");
                                                break;
                                            default:
                                                break;
                                        }
                                    }
                                }
                                stringBodyHtml.Append("</tr></tbody>");
                            }
                            #endregion
                            stringBodyHtml.Append($"</table><div class='ReadOnlyGrid_Subtotal'>{billToThisAccount.name}: ¥{GetTotalMoney(billToThis.Value).ToString("#0.00")}</div></div>");
                        }
                    }
                    #endregion


                    return stringBodyHtml.ToString();
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
            if (param != null && param.Count > 0)
            {
                totalMoney = param.Sum(_ => _.dollars == null ? 0 : (decimal)_.dollars);
            }

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
        private string GetTaxCateHtml(List<InvoiceDeductionDto> paramList, List<InvoiceDeductionDto> billTOThisParamList,crm_account account)
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


        private string ReturnTotalHtml(List<InvoiceDeductionDto> paramList, List<InvoiceDeductionDto> billTOThisParamList, crm_account account)
        {
            StringBuilder thisHtmlText = new StringBuilder();
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
            var taxCate = GetTaxCateHtml(paramList, billTOThisParamList,account);  // 分税信息的展示
 
            thisHtmlText.Append($"<div><table style = 'width:100%; padding-top:20px; border-collapse:collapse;' ><tbody><tr><td style = 'vertical-align:top;' ></td><td style = 'vertical-align:top;width:300px; '><table class='InvoiceTotalsBlock'><tbody><tr class='invoiceTotalsRow'><td class='invoiceTotalsNameCell'>不计费时间</td><td class='invoiceTotalsValueCell'>{noBillHours.ToString("#0.00")}</td></tr><tr class='invoiceTotalsRow'> <td class='invoiceTotalsNameCell'>预付费时间</td><td class='invoiceTotalsValueCell'>{prepaidHours.ToString("#0.00")}</td></tr><tr class='invoiceTotalsRow'> <td class='invoiceTotalsNameCell'>付费时间汇总</td><td class='invoiceTotalsValueCell'>{billHours.ToString("#0.00")}</td></tr>{totalTaxHtml}<tr class='invoiceTotalsRow'><td class='invoiceTotalsNameCell'>总额汇总</td><td class='invoiceTotalsValueCell'>{totalMoney.ToString("#0.00")}</td></tr><tr class='invoiceTotalsRow'><td class='invoiceGrandTotalNameCell'>总价</td><td class='invoiceGrandTotalValueCell'>{(totalMoney + totalTax).ToString("#0.00")}</td></tr>{taxCate}</tbody></table></td></tr></tbody></table></div>");
            return thisHtmlText.ToString();
        }
        #endregion

        public ERROR_CODE InvoiceNumberAndDate(int id, string date, string number, long user_id)
        {
            var ci = _dal.FindNoDeleteById(id);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (ci != null && user != null)
            {
                if (!string.IsNullOrEmpty(number)) {
                    var kk = _dal.FindSignleBySql<ctt_invoice>($"select * from ctt_invoice where invoice_no='{number}' and delete_time=0");
                    if (kk != null && kk.id != id)
                    {
                        return ERROR_CODE.EXIST;
                    }                    
                }
                ci.invoice_no = number;
                var old = ci;
                if (!string.IsNullOrEmpty(date))
                {
                    ci.paid_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null).Date;//转换时间格式
                }
                else {
                    ci.paid_date = null;
                }               
                ci.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ci.update_user_id = user.id;
                if (_dal.Update(ci))
                {
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.INVOCIE,
                        oper_object_id = ci.id,// 操作对象id
                        oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                        oper_description = _dal.CompareValue(old, ci),
                        remark = "修改发票的编号和日期"
                    });
                    return ERROR_CODE.SUCCESS;
                }
            }
            return ERROR_CODE.ERROR;
        }
        /// <summary>
        /// 作废发票
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public bool VoidInvoice(int id, long user_id)
        {
            var ci = _dal.FindNoDeleteById(id);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (ci != null && user != null)
            {
                if (ci.is_voided == 1)
                {
                    return false;
                }
                var old = ci;
                ci.is_voided = 1;
                ci.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ci.update_user_id = user.id;
                if (_dal.Update(ci))
                {
                    var cad_dal = new crm_account_deduction_dal();
                    var account_deduction = cad_dal.FindListBySql<crm_account_deduction>($"select * from crm_account_deduction where invoice_id={ci.id} and delete_time=0");
                    if (account_deduction.Count > 0)
                    {
                        foreach (var ii in account_deduction)
                        {
                            var oldii = ii;
                            ii.invoice_id = null;
                            ii.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            ii.update_user_id = user_id;
                            if (cad_dal.Update(ii))
                            {
                                var add_log = new sys_oper_log()
                                {
                                    user_cate = "用户",
                                    user_id = (int)user.id,
                                    name = user.name,
                                    phone = user.mobile == null ? "" : user.mobile,
                                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                                    oper_object_id = ii.id,// 操作对象id
                                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                                    oper_description = cad_dal.CompareValue(oldii, ii),
                                    remark = "修改发票清空"
                                };          // 创建日志
                            }
                        }
                    }
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.INVOCIE,
                        oper_object_id = ci.id,// 操作对象id
                        oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                        oper_description = _dal.CompareValue(old, ci),
                        remark = "作废发票"
                    });
                    return true;
                }
            }
            return false;
        }
        /// <summary>
        /// 作废发票并取消审核
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public bool VoidInvoiceAndUnPost(int id, long user_id)
        {
            var cadlist = new crm_account_deduction_dal().FindListBySql<crm_account_deduction>($"select * from crm_account_deduction where invoice_id={id} and delete_time=0");
            if (!VoidInvoice(id, user_id))
            {
                return false;
            }
            if (cadlist.Count > 0)
            {
                foreach (var cad in cadlist)
                {
                    if (cad.type_id != null)
                    {
                        ReverseBLL rbll = new ReverseBLL();
                        string re;
                        switch (cad.type_id)
                        {
                            case (int)ACCOUNT_DEDUCTION_TYPE.CHARGE:
                                var result0 = rbll.Revoke_CHARGES(user_id, cad.id.ToString(), out re);
                                if (result0 != ERROR_CODE.SUCCESS)
                                {
                                    return false;
                                }
                                break;//成本
                            case (int)ACCOUNT_DEDUCTION_TYPE.SUBSCRIPTIONS:
                                var result1 = rbll.Revoke_Subscriptions(user_id, cad.id.ToString(), out re);
                                if (result1 != ERROR_CODE.SUCCESS)
                                {
                                    return false;
                                }
                                break;//订阅
                            case (int)ACCOUNT_DEDUCTION_TYPE.MILESTONES:
                                var result2 = rbll.Revoke_Milestones(user_id, cad.id.ToString(), out re);
                                if (result2 != ERROR_CODE.SUCCESS)
                                {
                                    return false;
                                }
                                break;//里程碑
                            case (int)ACCOUNT_DEDUCTION_TYPE.SERVICE://服务
                            case (int)ACCOUNT_DEDUCTION_TYPE.INITIAL_COST: //初始费用
                            case (int)ACCOUNT_DEDUCTION_TYPE.SERVICE_ADJUST://服务调整
                                var result3 = rbll.Revoke_Recurring_Services(user_id, cad.id.ToString(), out re);
                                if (result3 != ERROR_CODE.SUCCESS)
                                {
                                    return false;
                                }
                                break;
                            default: break;
                        }
                    }
                }
            }
            return true;
        }
        /// <summary>
        /// 取消本批次发票
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public bool VoidBatchInvoice(int id, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            var list = _dal.FindListBySql($"select * from ctt_invoice where batch_id=(select batch_id from ctt_invoice where id={id} and delete_time=0 ) and is_voided=0 and delete_time=0");
            if (list.Count > 0 && user != null)
            {
                foreach (var i in list)
                {
                    var old = i;
                    i.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    i.update_user_id = user.id;
                    i.is_voided = 1;
                    if (_dal.Update(i))
                    {
                        crm_account_deduction_dal cad_dal = new crm_account_deduction_dal();
                        var account_deduction = cad_dal.FindListBySql<crm_account_deduction>($"select * from crm_account_deduction where invoice_id={i.id} and delete_time=0");
                        if (account_deduction.Count > 0)
                        {
                            foreach (var ii in account_deduction)
                            {
                                var oldii = ii;
                                ii.invoice_id = null;
                                ii.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                ii.update_user_id = user_id;
                                if (cad_dal.Update(ii))
                                {
                                    var add_log = new sys_oper_log()
                                    {
                                        user_cate = "用户",
                                        user_id = (int)user.id,
                                        name = user.name,
                                        phone = user.mobile == null ? "" : user.mobile,
                                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                                        oper_object_id = ii.id,// 操作对象id
                                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                                        oper_description = cad_dal.CompareValue(oldii, ii),
                                        remark = "修改发票清空"
                                    };          // 创建日志
                                }
                            }
                        }
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.INVOCIE,
                            oper_object_id = i.id,// 操作对象id
                            oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.CompareValue(old, i),
                            remark = "作废发票"
                        });
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            return true;
        }
        /// <summary>
        /// 返回发票相关客户id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int GetAccount_id(int id)
        {
            var inv = _dal.FindNoDeleteById(id);
            if (inv != null)
            {
                return (int)inv.account_id;
            }
            return -1;
        }
        /// <summary>
        /// 返回发票所在批次
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public int GetBatch_id(int id)
        {
            var inv = _dal.FindNoDeleteById(id);
            if (inv != null)
            {
                return (int)inv.batch_id;
            }
            return -1;
        }
        
    }
}
