using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class InvoiceBLL
    {
        private readonly  ctt_invoice_dal _dal = new ctt_invoice_dal();

        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("invoice_tmpl", new sys_quote_tmpl_dal().GetInvoiceTemp());  // 发票模板
            dic.Add("taxRegion", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TAX_REGION)));
            dic.Add("email_temp",new sys_quote_email_tmpl_dal().GetEmailTemlList());
            dic.Add("department",new sys_department_dal().GetDepartment());
            dic.Add("contract_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.CONTRACT_TYPE)));
            dic.Add("contract_cate", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.CONTRACT_CATE)));
            dic.Add("account_deduction_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.ACCOUNT_DEDUCTION_TYPE)));
            dic.Add("payment_term", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_TERM)));
            return dic;// PAYMENT_TERM
        }

        /// <summary>
        /// 发票处理--针对多个发票处理
        /// </summary>
        /// <returns></returns>
        public bool ProcessInvoice(InvoiceDealDto param,long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
           
            var temp = new sys_quote_tmpl_dal().FindNoDeleteById(param.invoice_template_id);
            if (user == null|| temp==null)
                return false;
            var arr = param.ids.Split(new char[]{','}, StringSplitOptions.RemoveEmptyEntries);
            if (arr != null && arr.Count() > 0)
            {
                var invoiceBatch= _dal.GetNextIdInvBat();
                var invoiceNo = _dal.GetNextIdInvNo();
                var cadDal = new crm_account_deduction_dal();
                var cidDal = new ctt_invoice_detail_dal();
                var comBLL = new CompanyBLL();
                foreach (var cad_id in arr)
                {
                    var acc_ded = cadDal.FindNoDeleteById(long.Parse(cad_id));
                    if (acc_ded == null)
                    {
                        continue;
                    }
                    var account = comBLL.GetCompany(acc_ded.account_id);                                
                    if (account == null)
                    {
                        continue;
                    }
                    var invocie = new ctt_invoice()
                    {
                        id = _dal.GetNextIdCom(),
                        batch_id = invoiceBatch,
                        account_id = acc_ded.account_id,
                        owner_resource_id = (long)account.resource_id,
                        invoice_no = invoiceNo.ToString(),
                        invoice_date = param.invoice_date,
                        total = acc_ded.extended_price,  
                        tax_value = acc_ded.tax_dollars, 
                        date_range_from = param.date_range_from,
                        date_range_to = param.date_range_to,
                        payment_term_id = param.payment_term_id,
                        purchase_order_no = param.purchase_order_no,
                        invoice_template_id = param.invoice_template_id,
                        page_header_html = temp.page_header_html,
                        page_footer_html = temp.page_footer_html,
                        invoice_header_html = temp.quote_header_html,
                        invoice_body_html = temp.body_html,
                        invoice_footer_html = temp.quote_footer_html,
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

                }

                return true;
            }
            return false;
        }


        /// <summary>
        /// 发票设置
        /// </summary>
        /// <returns></returns>
        public bool PreferencesInvoice(PreferencesInvoiceDto param,long user_id)
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
                    oper_description = _dal.CompareValue(oldAccRef,param.accRef),
                    remark = "修改发票设置"
                });
            }
         

            if(account.is_tax_exempt==param.is_tax_exempt&&account.tax_region_id == param.tax_region_id && account.tax_identification == param.tax_identification)
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
                    oper_description = _dal.CompareValue(new CompanyBLL().GetCompany(param.accRef.account_id),account),
                    remark = "修改客户信息"
                });
                new crm_account_dal().Update(account);
            }


            return true;
        }
        public bool InvoiceNumberAndDate(int id,string date,string number,long user_id) {
            var ci = _dal.FindNoDeleteById(id);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (ci != null&&user!=null) {
                var old = ci;
                ci.invoice_no = number;
                ci.invoice_date= DateTime.ParseExact(date.ToString(), "yyyyMMdd", null).Date;//转换时间格式
                ci.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ci.update_user_id = user.id;
                if (_dal.Update(ci)) {
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
                        oper_description = _dal.CompareValue(old,ci),
                        remark = "修改发票的编号和日期"
                    });
                }               
            }
            return false;
        }
        /// <summary>
        /// 作废发票
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public bool VoidInvoice(int id,long user_id) {
            var ci = _dal.FindNoDeleteById(id);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (ci != null && user != null)
            {
                if (ci.is_voided == 1) {
                    return false;
                }
                var old = ci;
                ci.is_voided = 1;
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
                        remark = "作废发票"
                    });
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
        public bool VoidInvoiceAndUnPost(int id, long user_id) {
            if (VoidInvoice(id, user_id)) {
                var cad = new crm_account_deduction_dal().FindSignleBySql<crm_account_deduction>($"select * from crm_account_deduction where invoice_id={id} and delete_time=0");
                if (cad != null) {
                    ReverseBLL rbll = new ReverseBLL();
                    string re;
                    switch (cad.type_id)
                    {                       
                        case (int)ACCOUNT_DEDUCTION_TYPE.CHARGE:
                            var result0 = rbll.Revoke_CHARGES(user_id,cad.id.ToString(), out re);
                            if (result0 == ERROR_CODE.SUCCESS) {
                                return true;
                            }
                            break;//成本
                        case (int)ACCOUNT_DEDUCTION_TYPE.SUBSCRIPTIONS:
                            var result1 = rbll.Revoke_Subscriptions(user_id,cad.id.ToString(), out re);
                            if (result1 == ERROR_CODE.SUCCESS)
                            {
                                return true;
                            }
                            break;//订阅
                        case (int)ACCOUNT_DEDUCTION_TYPE.MILESTONES:
                            var result2 = rbll.Revoke_Milestones(user_id,cad.id.ToString(), out re);
                            if (result2 == ERROR_CODE.SUCCESS)
                            {
                                return true;
                            }
                            break;//里程碑
                        case (int)ACCOUNT_DEDUCTION_TYPE.SERVICE://服务
                        case (int)ACCOUNT_DEDUCTION_TYPE.INITIAL_COST: //初始费用
                        case (int)ACCOUNT_DEDUCTION_TYPE.SERVICE_ADJUST://服务调整
                            var result3 = rbll.Revoke_Recurring_Services(user_id,cad.id.ToString(), out re);
                            if (result3 == ERROR_CODE.SUCCESS)
                            {
                                return true;
                            }
                            break;
                        default:break;
                    }
                }                
            }
            return false;
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
            if (list.Count > 0&&user!=null) {
                foreach (var i in list) {
                    var old = i;
                    i.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    i.update_user_id = user.id;
                    if (_dal.Update(i))
                    {
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
                }
            }
            return false;
        }
    }
}
