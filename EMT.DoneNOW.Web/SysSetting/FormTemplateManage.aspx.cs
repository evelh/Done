using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class FormTemplateManage :BasePage
    {
        protected bool isAdd = true;
        protected sys_form_tmpl temp;
        protected long objId;
        protected int formTypeId;
        protected string typeName;
        protected sys_form_tmpl_opportunity tempOppo;      // 商机模板
        protected sys_form_tmpl_activity tempNote;         // 备注模板
        protected sys_form_tmpl_quick_call tempQuickCall;  // 快速服务预定模板
        protected sys_form_tmpl_quote tempQuote;           // 报价模板
        protected sys_form_tmpl_recurring_ticket tempRecTicket;           // 定期工单模板
        protected sys_form_tmpl_service_call tempSerCall;           // 服务预定模板
        protected sys_form_tmpl_work_entry tempEntry;           // 工时模板
        protected sys_form_tmpl_ticket tempTicket;           // 工单模板
        protected List<sys_form_tmpl_ticket_checklist> tempCheckList;   //  工单检查单

        protected List<d_general> tempRangList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.FORM_TEMPLATE_RANGE_TYPE);          // 模板范围
        protected List<d_general> tempTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.FORM_TEMPLATE_TYPE);          // 模板类型
        protected List<sys_department> depList = new DAL.sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.DEPARTMENT);
        protected List<sys_department> queueList = new DAL.sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE);
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList(false);

        protected List<d_general> ticStaList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_STATUS);          // 工单状态集合
        protected List<d_general> priorityList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_PRIORITY_TYPE);   // 工单优先级集合
        protected List<d_general> issueTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_ISSUE_TYPE);     // 工单问题类型
        protected List<d_general> sourceTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_SOURCE_TYPES);     // 工单来源
        protected List<d_general> ticketCateList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_CATE);     // 工单种类
        protected List<d_general> ticketTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_TYPE);     // 工单类型
        protected List<sys_role> roleList = new DAL.sys_role_dal().GetList();
        protected List<d_sla> slaList = new DAL.d_sla_dal().GetList();
        protected List<ResRole> resRoleList;

        protected List<d_general> taxRegionList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TAX_REGION);          // 模板范围
        protected List<sys_quote_tmpl> quoteTempList = new DAL.sys_quote_tmpl_dal().GetQuoteTemp();  // 报价模板
        protected List<d_general> payTermList;
        protected List<d_general> payTypeList;
        protected List<d_general> shipTypeList ;

        protected List<d_general> oppoStageList;
        protected List<d_general> oppoSourceList;
        protected List<d_general> oppoStatusList;
        protected List<d_general> oppoIntDegList;
        protected List<d_general> oppoComperList;
        protected crm_account thisAccount;
        protected crm_contact thisContact;
        protected ivt_product thisProduct;
        protected ctt_contract thisContract;
        protected d_cost_code thisCostCode;
        protected crm_opportunity thisOppo;
        protected sys_resource_department proResDep = null; // 工单的主负责人
        protected crm_installed_product thisInsPro;
        protected List<UserDefinedFieldDto> tickUdfList = null;// 
        protected List<UserDefinedFieldValue> ticketUdfValueList = null;

        protected List<d_general> callStatusList;
        protected List<d_cost_code> workTypeList;

        protected List<sys_notify_tmpl> tempNotiList ;  // 通知模板
        protected List<d_general> pushList = new DAL.d_general_dal().GetGeneralByTableId((int) GeneralTableEnum.NOTE_PUBLISH_TYPE);   // 备注发布对象
        protected List<d_general> actList = new DAL.d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.ACTION_TYPE);
        protected List<d_general> notifyList = new DAL.d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.FORM_TMPL_QUICK_EMAIL_OBJECT);  // 邮件通知对象
        protected string[] notiIds;
        protected FormTemplateBLL tempBll = new FormTemplateBLL();
        protected CompanyBLL accountBll = new CompanyBLL();
        protected ContactBLL contactBll = new ContactBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            var id = Request.QueryString["id"];
            if(!string.IsNullOrEmpty(id)&&long.TryParse(id,out objId))
            {
                temp = tempBll.GetTempById(objId);
                if (temp != null)
                {
                    if(string.IsNullOrEmpty(Request.QueryString["isCopy"]))
                        isAdd = false;
                    formTypeId = temp.form_type_id;
                    if (!string.IsNullOrEmpty(temp.quick_email_object_ids))
                        notiIds = temp.quick_email_object_ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (temp.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.OPPORTUNITY)
                    {
                        tempOppo = tempBll.GetOpportunityTmpl(temp.id);
                        if (tempOppo != null)
                        {
                            if (tempOppo.account_id!=null)
                                thisAccount = accountBll.GetCompany((long)tempOppo.account_id);
                            if (tempOppo.contact_id != null)
                                thisContact = contactBll.GetContact((long)tempOppo.contact_id);
                            if (tempOppo.primary_product_id != null)
                                thisProduct = new DAL.ivt_product_dal().FindNoDeleteById((long)tempOppo.primary_product_id);
                        }
                    }
                    else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.PROJECT_NOTE || formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET_NOTE || formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TASK_NOTE)
                    {
                        tempNote = tempBll.GetNoteTmpl(temp.id);
                    }
                    else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.QUICK_CALL)
                    {
                        tempQuickCall = tempBll.GetQuickCallTmpl(temp.id);
                        if (tempQuickCall != null)
                        {
                            if (tempQuickCall.account_id != null)
                                thisAccount = accountBll.GetCompany((long)tempQuickCall.account_id);
                            if (tempQuickCall.contact_id != null)
                                thisContact = contactBll.GetContact((long)tempQuickCall.contact_id);
                            if (tempQuickCall.contract_id != null)
                                thisContract = new ContractBLL().GetContract((long)tempQuickCall.contract_id);
                            if (tempQuickCall.cost_code_id != null)
                                thisCostCode = new DAL.d_cost_code_dal().FindNoDeleteById((long)tempQuickCall.cost_code_id);
                        }
                    }
                    else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.QUOTE)
                    {
                        tempQuote = tempBll.GetQuoteTmpl(temp.id);
                        if (tempQuote != null)
                        {
                            if (tempQuote.account_id != null)
                                thisAccount = accountBll.GetCompany((long)tempQuote.account_id);
                            if (tempQuote.contact_id != null)
                                thisContact = contactBll.GetContact((long)tempQuote.contact_id);
                            if (tempQuote.opportunity_id != null)
                                thisOppo = new DAL.crm_opportunity_dal().FindNoDeleteById((long)tempQuote.opportunity_id);
                        }
                    }
                    else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.RECURRING_TICKET)
                    {
                        tempRecTicket = tempBll.GetRecTicketTmpl(temp.id);
                        if (tempRecTicket != null)
                        {
                            if(tempRecTicket.account_id!=null)
                                thisAccount = accountBll.GetCompany((long)tempRecTicket.account_id);
                            if (tempRecTicket.contact_id != null)
                                thisContact = contactBll.GetContact((long)tempRecTicket.contact_id);
                            if (tempRecTicket.contract_id != null)
                                thisContract = new ContractBLL().GetContract((long)tempRecTicket.contract_id);
                            if (tempRecTicket.cost_code_id != null)
                                thisCostCode = new DAL.d_cost_code_dal().FindNoDeleteById((long)tempRecTicket.cost_code_id);
                            if (tempRecTicket.installed_product_id != null)
                            {
                                thisInsPro = new InstalledProductBLL().GetById((long)tempRecTicket.installed_product_id);
                                if (thisInsPro != null)
                                    thisProduct = new ProductBLL().GetProduct(thisInsPro.product_id);
                            }
                            tickUdfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
                            ticketUdfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.FORM_RECTICKET, tempRecTicket.id, tickUdfList);
                        }
                        
                    }
                    else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.SERVICE_CALL)
                    {
                        tempSerCall = tempBll.GetServiceCallTmpl(temp.id);
                        if (tempSerCall != null)
                        {
                            if (tempSerCall.account_id != null)
                                thisAccount = accountBll.GetCompany((long)tempSerCall.account_id);
                        }
                    }
                    else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TASK_TIME_ENTRY|| formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET_TIME_ENTRY)
                    {
                        tempEntry = tempBll.GetWorkEntryTmpl(temp.id);
                        if (tempEntry != null)
                        {
                            if (tempEntry.cost_code_id != null)
                                thisCostCode = new DAL.d_cost_code_dal().FindNoDeleteById((long)tempEntry.cost_code_id);
                        }
                    }
                    else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET)
                    {
                        tempTicket = tempBll.GetTicketTmpl(temp.id);
                        if (tempTicket != null)
                        {
                            if (tempTicket.account_id != null)
                                thisAccount = accountBll.GetCompany((long)tempTicket.account_id);
                            if (tempTicket.contact_id != null)
                                thisContact = contactBll.GetContact((long)tempTicket.contact_id);
                            if (tempTicket.contract_id != null)
                                thisContract = new ContractBLL().GetContract((long)tempTicket.contract_id);
                            if (tempTicket.cost_code_id != null)
                                thisCostCode = new DAL.d_cost_code_dal().FindNoDeleteById((long)tempTicket.cost_code_id);
                            if (tempTicket.installed_product_id != null)
                            {
                                thisInsPro = new InstalledProductBLL().GetById((long)tempTicket.installed_product_id);
                                if (thisInsPro != null)
                                    thisProduct = new ProductBLL().GetProduct(thisInsPro.product_id);
                            }
                            if (tempTicket.owner_resource_id != null && tempTicket.role_id != null)
                            {
                                var resDepList = new DAL.sys_resource_department_dal().GetResDepByResAndRole((long)tempTicket.owner_resource_id, (long)tempTicket.role_id);
                                if (resDepList != null && resDepList.Count > 0)
                                {
                                    proResDep = resDepList[0];
                                    
                                }
                            }
                               

                            tickUdfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
                            ticketUdfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.FORM_TICKET, tempTicket.id, tickUdfList);
                        }
                    }

                    // GetTicketTmpl

                }
            }
            if (!string.IsNullOrEmpty(Request.QueryString["formTypeId"]))
                int.TryParse(Request.QueryString["formTypeId"],out formTypeId);
            var thisFromType = tempTypeList.FirstOrDefault(_=>_.id==formTypeId);
            if (thisFromType != null)
                typeName = thisFromType.name;
            if (notifyList != null&& notifyList.Count>0)
                notifyList = notifyList.Where(_ => _.parent_id == formTypeId).ToList();
            if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.OPPORTUNITY)
            {
                typeName = "商机";
                oppoStageList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_STAGE);
                oppoSourceList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_SOURCE);
                oppoStatusList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_STATUS);
                oppoIntDegList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_INTEREST_DEGREE);
                oppoComperList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.COMPETITOR);
                tempNotiList = new DAL.sys_notify_tmpl_dal().GetTempByEvent(((int)DicEnum.NOTIFY_EVENT.OPPORTUNITY_CREATEDOREDITED).ToString());
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.PROJECT_NOTE)
            {
                typeName = "项目备注";
                tempNotiList = new DAL.sys_notify_tmpl_dal().GetTempByEvent(((int)DicEnum.NOTIFY_EVENT.PROJECT_NOTE_CREATED_OR_EDITED).ToString());
                if (pushList!=null&& pushList.Count > 0)
                    pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.PROJECT_NOTE).ToString()).ToList();
                if(actList!=null&& actList.Count>0)
                    actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.PROJECT_NOTE).ToString()).ToList();

            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TASK_NOTE)
            {
                typeName = "任务备注";
                tempNotiList = new DAL.sys_notify_tmpl_dal().GetTempByEvent(((int)DicEnum.NOTIFY_EVENT.TASK_NOTE_CREATED_EDITED).ToString());
                if (pushList != null && pushList.Count > 0)
                    pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();
                if (actList != null && actList.Count > 0)
                    actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();

            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET_NOTE)
            {
                typeName = "工单备注";
                tempNotiList = new DAL.sys_notify_tmpl_dal().GetTempByEvent(((int)DicEnum.NOTIFY_EVENT.TICKET_NOTE_CREATED_EDITED).ToString());
                if (pushList != null && pushList.Count > 0)
                    pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TICKET_NOTE).ToString()).ToList();
                if (actList != null && actList.Count > 0)
                    actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TICKET_NOTE).ToString()).ToList();
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.QUICK_CALL)
            {
                typeName = "快速服务预定";
                resRoleList =  new DAL.sys_resource_department_dal().FindListBySql<ResRole>("select DISTINCT resource_id,role_id from sys_resource_department");
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.QUOTE)
            {
                typeName = "报价";
                payTermList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.PAYMENT_TERM);
                payTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.PAYMENT_TYPE);
                shipTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.PAYMENT_SHIP_TYPE);
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.RECURRING_TICKET)
            {
                typeName = "定期工单";
                tickUdfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
                resRoleList = new DAL.sys_resource_department_dal().FindListBySql<ResRole>("select DISTINCT resource_id,role_id from sys_resource_department");
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.SERVICE_CALL)
            {
                typeName = "服务预定";
                callStatusList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.SERVICE_CALL_STATUS);
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TASK_TIME_ENTRY)
            {
                typeName = "任务工时";
                workTypeList = new DAL.d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE);
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET)
            {
                typeName = "工单";
                tickUdfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET_TIME_ENTRY)
            {
                typeName = "工单工时";
                workTypeList = new DAL.d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE);
            }



        }
        /// <summary>
        /// 获取模板参数
        /// </summary>
        protected sys_form_tmpl GetTemp()
        {
            sys_form_tmpl formTemp = AssembleModel<sys_form_tmpl>();
            if (!string.IsNullOrEmpty(Request.Form["isActive"]) && Request.Form["isActive"].Equals("on"))
                formTemp.is_active = 1;
            else
                formTemp.is_active = 0;
            formTemp.form_type_id = formTypeId;
            if (Request.Form["availablity"]== "rdo_me")
            {
                formTemp.range_type_id = (int)DicEnum.RANG_TYPE.OWN;

            }
            else if (Request.Form["availablity"] == "rdo_department")
            {
                formTemp.range_type_id = (int)DicEnum.RANG_TYPE.DEPARTMENT;
            }
            else if (Request.Form["availablity"] == "rdo_company")
            {
                formTemp.range_type_id = (int)DicEnum.RANG_TYPE.ALL;
            }
            var ids = string.Empty;
            if (notifyList != null && notifyList.Count>0)
            {
                notifyList.ForEach(_ => {
                    if (!string.IsNullOrEmpty(Request.Form["noti" + _.id.ToString()]) && Request.Form["noti" + _.id.ToString()].Equals("on"))
                        ids += _.id.ToString()+',';
                });
                if (!string.IsNullOrEmpty(ids))
                    ids = ids.Substring(0, ids.Length-1);
            }
            formTemp.quick_email_object_ids = ids;
            if (!string.IsNullOrEmpty(Request.Form["from_sys_email"]) && Request.Form["from_sys_email"].Equals("on"))
                formTemp.from_sys_email = 1;
            else
                formTemp.from_sys_email = 0;
            
            if (!isAdd)
            {
                temp.tmpl_name = formTemp.tmpl_name;
                temp.speed_code = formTemp.speed_code;
                temp.is_active = formTemp.is_active;
                temp.remark = formTemp.remark;
                temp.range_type_id = formTemp.range_type_id;
                temp.range_department_id = formTemp.range_department_id;
                temp.form_type_id = formTemp.form_type_id;
                temp.quick_email_object_ids = formTemp.quick_email_object_ids;
                temp.from_sys_email = formTemp.from_sys_email;
                temp.other_emails = formTemp.other_emails;
                temp.notify_tmpl_id = formTemp.notify_tmpl_id;
                temp.subject = formTemp.subject;
                temp.additional_email_text = formTemp.additional_email_text;
                return temp;
            }
            return formTemp;
        }
        /// <summary>
        /// 获取模板相关参数
        /// </summary>
        protected object GetParam()
        {
            if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.OPPORTUNITY)
            {
                #region 商机相关
                sys_form_tmpl_opportunity pageTempOppo = AssembleModel<sys_form_tmpl_opportunity>();
                if(Request.Form["OppoCloseType"]== "pcdKeepCurrent")
                    pageTempOppo.projected_close_date_type_id = (int)DicEnum.PROJECTED_CLOSE_DATE.TODAY;
                else if (Request.Form["OppoCloseType"] == "radioFromToday")
                {
                    pageTempOppo.projected_close_date_type_id = (int)DicEnum.PROJECTED_CLOSE_DATE.FROM_TODAY;
                    int dateTypeValue = 0;
                    if (!string.IsNullOrEmpty(Request.Form["txtOppoFromToday"]))
                        int.TryParse(Request.Form["txtOppoFromToday"], out dateTypeValue);
                    pageTempOppo.projected_close_date_type_value = dateTypeValue;
                }
                else if (Request.Form["OppoCloseType"] == "radioFromCreateDate")
                {
                    pageTempOppo.projected_close_date_type_id = (int)DicEnum.PROJECTED_CLOSE_DATE.FROM_CREATE;
                    int dateTypeValue = 0;
                    if (!string.IsNullOrEmpty(Request.Form["txtOppoFromCreate"]))
                        int.TryParse(Request.Form["txtOppoFromCreate"], out dateTypeValue);
                    pageTempOppo.projected_close_date_type_value = dateTypeValue;
                }
                else if (Request.Form["OppoCloseType"] == "radioLastDayOfMonth")
                {
                    tempOppo.projected_close_date_type_id = (int)DicEnum.PROJECTED_CLOSE_DATE.LAST_DAY_OF_MONTH;
                    int dateTypeValue = 1;
                    if (!string.IsNullOrEmpty(Request.Form["selOppoDayMonth"]))
                        int.TryParse(Request.Form["selOppoDayMonth"], out dateTypeValue);
                    tempOppo.projected_close_date_type_value = dateTypeValue;
                }
                if (!string.IsNullOrEmpty(Request.Form["ckOppoUseQuote"]) && Request.Form["ckOppoUseQuote"].Equals("on"))
                    pageTempOppo.use_quote_revenue_and_cost = 1;
                else
                    pageTempOppo.use_quote_revenue_and_cost = 0;
                if (!string.IsNullOrEmpty(Request.Form["ckOppoSpreadValue"]) && Request.Form["ckOppoSpreadValue"].Equals("on"))
                    pageTempOppo.spread_revenue_recognition_value = 1;
                else
                    pageTempOppo.spread_revenue_recognition_value = 0;
                if (!isAdd)
                {
                    pageTempOppo.name = tempOppo.name;
                    pageTempOppo.account_id = tempOppo.account_id;
                    pageTempOppo.contact_id = tempOppo.contact_id;
                    pageTempOppo.resource_id = tempOppo.resource_id;
                    pageTempOppo.stage_id = tempOppo.stage_id;
                    pageTempOppo.source_id = tempOppo.source_id;
                    pageTempOppo.status_id = tempOppo.status_id;
                    pageTempOppo.competitor_id = tempOppo.competitor_id;
                    pageTempOppo.probability = tempOppo.probability;
                    pageTempOppo.interest_degree_id = tempOppo.interest_degree_id;
                    pageTempOppo.projected_close_date_type_id = tempOppo.projected_close_date_type_id;
                    pageTempOppo.projected_close_date_type_value = tempOppo.projected_close_date_type_value;
                    pageTempOppo.primary_product_id = tempOppo.primary_product_id;
                    pageTempOppo.promotion_name = tempOppo.promotion_name;
                    pageTempOppo.spread_revenue_recognition_value = tempOppo.spread_revenue_recognition_value;
                    pageTempOppo.spread_revenue_recognition_unit = tempOppo.spread_revenue_recognition_unit;
                    pageTempOppo.number_months_for_estimating_total_profit = tempOppo.number_months_for_estimating_total_profit;
                    pageTempOppo.one_time_revenue = tempOppo.one_time_revenue;
                    pageTempOppo.one_time_cost = tempOppo.one_time_cost;
                    pageTempOppo.monthly_revenue = tempOppo.monthly_revenue;
                    pageTempOppo.monthly_cost = tempOppo.monthly_cost;
                    pageTempOppo.quarterly_revenue = tempOppo.quarterly_revenue;
                    pageTempOppo.quarterly_cost = tempOppo.quarterly_cost;
                    pageTempOppo.semi_annual_revenue = tempOppo.semi_annual_revenue;
                    pageTempOppo.semi_annual_cost = tempOppo.semi_annual_cost;
                    pageTempOppo.yearly_revenue = tempOppo.yearly_revenue;
                    pageTempOppo.yearly_cost = tempOppo.yearly_cost;
                    pageTempOppo.use_quote_revenue_and_cost = tempOppo.use_quote_revenue_and_cost;
                    pageTempOppo.ext1 = tempOppo.ext1;
                    pageTempOppo.ext2 = tempOppo.ext2;
                    pageTempOppo.ext3 = tempOppo.ext3;
                    pageTempOppo.ext4 = tempOppo.ext4;
                    pageTempOppo.ext5 = tempOppo.ext5;
                    return pageTempOppo;
                }
                else
                    return pageTempOppo;

                #endregion
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.PROJECT_NOTE)
            {
                #region 项目备注相关
                sys_form_tmpl_activity pageTempNote = AssembleModel<sys_form_tmpl_activity>();
                if (!string.IsNullOrEmpty(Request.Form["isAnnounce"]) && Request.Form["isAnnounce"].Equals("on"))
                    pageTempNote.announce = 1;
                else
                    pageTempNote.announce = 0;
                if (!isAdd)
                {
                    tempNote.action_type_id = pageTempNote.action_type_id;
                    tempNote.announce = pageTempNote.announce;
                    tempNote.publish_type_id = pageTempNote.publish_type_id;
                    tempNote.name = pageTempNote.name;
                    tempNote.description = pageTempNote.description;
                    return tempNote;
                }
                else
                    return pageTempNote;

                #endregion

            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.QUICK_CALL)
            {
                #region 快速服务预定
                sys_form_tmpl_quick_call pageTempQuickCall = AssembleModel<sys_form_tmpl_quick_call>();
                if (!string.IsNullOrEmpty(Request.Form["resRoleId"]))
                {
                    var resArr = Request.Form["resRoleId"].Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (resArr.Count() == 2)
                    {
                        pageTempQuickCall.owner_resource_id = long.Parse(resArr[0]);
                        pageTempQuickCall.role_id = long.Parse(resArr[1]);
                    }
                }
                if (!isAdd)
                {
                    tempQuickCall.account_id = pageTempQuickCall.account_id;
                    tempQuickCall.contact_id = pageTempQuickCall.contact_id;
                    tempQuickCall.title = pageTempQuickCall.title;
                    tempQuickCall.description = pageTempQuickCall.description;
                    tempQuickCall.priority_type_id = pageTempQuickCall.priority_type_id;
                    tempQuickCall.issue_type_id = pageTempQuickCall.issue_type_id;
                    tempQuickCall.sub_issue_type_id = pageTempQuickCall.sub_issue_type_id;
                    tempQuickCall.cate_id = pageTempQuickCall.cate_id;
                    tempQuickCall.contract_id = pageTempQuickCall.contract_id;
                    tempQuickCall.cost_code_id = pageTempQuickCall.cost_code_id;
                    tempQuickCall.department_id = pageTempQuickCall.department_id;
                    tempQuickCall.owner_resource_id = pageTempQuickCall.owner_resource_id;
                    tempQuickCall.role_id = pageTempQuickCall.role_id;
                    tempQuickCall.second_resource_ids = pageTempQuickCall.second_resource_ids;
                    tempQuickCall.estimated_begin_time = pageTempQuickCall.estimated_begin_time;
                    tempQuickCall.estimated_end_time = pageTempQuickCall.estimated_end_time;
                    return tempQuickCall;
                }
                else return pageTempQuickCall;
                #endregion
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.QUOTE)
            {
                #region 报价预定
                sys_form_tmpl_quote pageTempQuote = AssembleModel<sys_form_tmpl_quote>();
                if (!string.IsNullOrEmpty(Request.Form["isActive"]) && Request.Form["isActive"].Equals("on"))
                    pageTempQuote.is_active = 1;
                else pageTempQuote.is_active = 0;
                if (!string.IsNullOrEmpty(Request.Form["isBillTo"]) && Request.Form["isBillTo"].Equals("on"))
                    pageTempQuote.bill_to_as_sold_to = 1;
                else pageTempQuote.bill_to_as_sold_to = 0;
                if (!string.IsNullOrEmpty(Request.Form["isShipTo"]) && Request.Form["isShipTo"].Equals("on"))
                    pageTempQuote.ship_to_as_sold_to = 1;
                else pageTempQuote.ship_to_as_sold_to = 0;
                if (!isAdd)
                {
                    pageTempQuote.id = tempQuote.id;
                    pageTempQuote.oid = tempQuote.oid;
                    pageTempQuote.form_tmpl_id = tempQuote.form_tmpl_id;
                    pageTempQuote.create_time = tempQuote.create_time;
                    pageTempQuote.create_user_id = tempQuote.create_user_id;
                    pageTempQuote.update_time = tempQuote.update_time;
                    pageTempQuote.update_user_id = tempQuote.update_user_id;
                }
                return pageTempQuote;
                #endregion
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.RECURRING_TICKET)
            {
                #region 定期工单

                sys_form_tmpl_recurring_ticket pageTempRecTicket = AssembleModel<sys_form_tmpl_recurring_ticket>();
                if(Request.Form["EndType"]== "radioEndDaysFromNow")
                    pageTempRecTicket.recurring_instances = null;
                else
                    pageTempRecTicket.recurring_end_date = null;
                if (!string.IsNullOrEmpty(Request.Form["resRoleId"]))
                {
                    var resArr = Request.Form["resRoleId"].Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (resArr.Count() == 2)
                    {
                        pageTempRecTicket.owner_resource_id = long.Parse(resArr[0]);
                        pageTempRecTicket.role_id = long.Parse(resArr[1]);
                    }
                }
                string recurring_define = string.Empty;
                if (Request.Form["FreType"] == "radioDaily")
                {
                    int every = 1;
                    if (!string.IsNullOrEmpty(Request.Form["every"]))
                        int.TryParse(Request.Form["every"],out every);
                    int no_sat = 0;   // 
                    if (!string.IsNullOrEmpty(Request.Form["day_no_sat"]) && Request.Form["day_no_sat"].Equals("on"))
                        no_sat = 1;
                    int no_sun = 0;
                    if (!string.IsNullOrEmpty(Request.Form["day_no_sun"]) && Request.Form["day_no_sun"].Equals("on"))
                        no_sun = 1;
                    TicketRecurrDayDto dayDto = new TicketRecurrDayDto()
                    {every = every,
                    no_sat = no_sat,
                    no_sun = no_sun,
                    };
                    recurring_define = new Tools.Serialize().SerializeJson(dayDto);
                    pageTempRecTicket.recurring_frequency = (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.DAY;
                }
                else if(Request.Form["FreType"] == "radioWeekly")
                {
                    int week_eve_week = 1;
                    if (!string.IsNullOrEmpty(Request.Form["week_eve_week"]))
                        int.TryParse(Request.Form["week_eve_week"], out week_eve_week);
                    List<int> intArr = new List<int>();
                    if (!string.IsNullOrEmpty(Request.Form["ckWeekSun"]) && Request.Form["ckWeekSun"].Equals("on"))
                        intArr.Add(0);
                    if (!string.IsNullOrEmpty(Request.Form["ckWeekMon"]) && Request.Form["ckWeekMon"].Equals("on"))
                        intArr.Add(1);
                    if (!string.IsNullOrEmpty(Request.Form["ckWeekTus"]) && Request.Form["ckWeekTus"].Equals("on"))
                        intArr.Add(2);
                    if (!string.IsNullOrEmpty(Request.Form["ckWeekWed"]) && Request.Form["ckWeekWed"].Equals("on"))
                        intArr.Add(3);
                    if (!string.IsNullOrEmpty(Request.Form["ckWeekThu"]) && Request.Form["ckWeekThu"].Equals("on"))
                        intArr.Add(4);
                    if (!string.IsNullOrEmpty(Request.Form["ckWeekFri"]) && Request.Form["ckWeekFri"].Equals("on"))
                        intArr.Add(5);
                    if (!string.IsNullOrEmpty(Request.Form["ckWeekSat"]) && Request.Form["ckWeekSat"].Equals("on"))
                        intArr.Add(6);
                    TicketRecurrWeekDto weekDto = new TicketRecurrWeekDto()
                    {
                       every = week_eve_week,
                       dayofweek  = intArr.ToArray(),
                    };
                    recurring_define = new Tools.Serialize().SerializeJson(weekDto);
                    pageTempRecTicket.recurring_frequency = (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.WEEK;
                }
                else if (Request.Form["FreType"] == "radioMonthly")
                {
                    TicketRecurrMonthDto monthDto = new TicketRecurrMonthDto();
                    if (Request.Form["monthType"] == "radioSpecificDay")
                    {
                        if (!string.IsNullOrEmpty(Request.Form["month_month_day"]))
                            int.TryParse(Request.Form["month_month_day"],out monthDto.month);
                        if (!string.IsNullOrEmpty(Request.Form["month_day_num"]))
                            int.TryParse(Request.Form["month_day_num"], out monthDto.day);
                    }
                    else if (Request.Form["monthType"] == "radioRelativeDay")
                    {
                        monthDto.day = -1;
                        if (!string.IsNullOrEmpty(Request.Form["month_month_eve_num"]))
                            int.TryParse(Request.Form["month_month_eve_num"], out monthDto.month);
                        monthDto.no = Request.Form["month_1_month"];
                        monthDto.dayofweek = Request.Form["month_1_week"];
                    }
                    recurring_define = new Tools.Serialize().SerializeJson(monthDto);
                    pageTempRecTicket.recurring_frequency = (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.MONTH;
                }
                else if (Request.Form["FreType"] == "radioYearly")
                {
                    TicketRecurrMonthDto yearDto = new TicketRecurrMonthDto();
                    if (Request.Form["YearType"] == "radioYearlySpecific")
                    {
                        if (!string.IsNullOrEmpty(Request.Form["year_every_month"]))
                            int.TryParse(Request.Form["year_every_month"], out yearDto.month);
                        if (!string.IsNullOrEmpty(Request.Form["year_month_day"]))
                            int.TryParse(Request.Form["year_month_day"], out yearDto.day);
                    }
                    else if (Request.Form["YearType"] == "radioRelativeDay")
                    {
                        yearDto.day = -1;
                        if (!string.IsNullOrEmpty(Request.Form["year_the_month"]))
                            int.TryParse(Request.Form["year_the_month"], out yearDto.month);
                        yearDto.no = Request.Form["year_month_week_num"];
                        yearDto.dayofweek = Request.Form["year_the_week"];
                    }
                    recurring_define = new Tools.Serialize().SerializeJson(yearDto);
                    pageTempRecTicket.recurring_frequency = (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.YEAR;
                }
                pageTempRecTicket.recurring_define = recurring_define;

              

                if (!isAdd)
                {
                    pageTempRecTicket.id = tempRecTicket.id;
                    pageTempRecTicket.oid = tempRecTicket.oid;
                    pageTempRecTicket.form_tmpl_id = tempRecTicket.form_tmpl_id;
                    pageTempRecTicket.create_time = tempRecTicket.create_time;
                    pageTempRecTicket.create_user_id = tempRecTicket.create_user_id;
                    pageTempRecTicket.update_time = tempRecTicket.update_time;
                    pageTempRecTicket.update_user_id = tempRecTicket.update_user_id;
                }
                return pageTempRecTicket;

                #endregion
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.SERVICE_CALL)
            {
                #region 服务预定
                sys_form_tmpl_service_call pageTempCall = AssembleModel<sys_form_tmpl_service_call>();
               
                if (!isAdd)
                {
                    tempSerCall.account_id = pageTempCall.account_id;
                    tempSerCall.start_time = pageTempCall.start_time;
                    tempSerCall.end_time = pageTempCall.end_time;
                    tempSerCall.description = pageTempCall.description;
                    tempSerCall.status_id = pageTempCall.status_id;
                    return tempSerCall;
                }
                else
                    return pageTempCall;
                #endregion
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TASK_NOTE)
            {
                #region 任务备注相关
                sys_form_tmpl_activity pageTempNote = AssembleModel<sys_form_tmpl_activity>();
                if (!isAdd)
                {
                    tempNote.action_type_id = pageTempNote.action_type_id;
                    tempNote.status_id = pageTempNote.status_id;
                    tempNote.publish_type_id = pageTempNote.publish_type_id;
                    tempNote.name = pageTempNote.name;
                    tempNote.description = pageTempNote.description;
                    return tempNote;
                }
                else
                    return pageTempNote;
                #endregion
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TASK_TIME_ENTRY|| formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET_TIME_ENTRY)
            {
                #region 工时相关
                sys_form_tmpl_work_entry pageTempEntry = AssembleModel<sys_form_tmpl_work_entry>();

                if (!string.IsNullOrEmpty(Request.Form["isNoBill"]) && Request.Form["isNoBill"].Equals("on"))
                    pageTempEntry.is_billable = 0;
                else
                    pageTempEntry.is_billable = 1;
                if(pageTempEntry.is_billable == 1)
                    pageTempEntry.show_on_invoice = 1;
                else
                {
                    if (!string.IsNullOrEmpty(Request.Form["isShowOnInvoice"]) && Request.Form["isShowOnInvoice"].Equals("on"))
                        pageTempEntry.show_on_invoice = 1;
                    else
                        pageTempEntry.show_on_invoice = 0;
                }
                decimal? hours_worked = null;
                if(!string.IsNullOrEmpty(Request.Form["hours"])|| !string.IsNullOrEmpty(Request.Form["mins"]))
                {
                    int hours = 0;
                    if (!string.IsNullOrEmpty(Request.Form["hours"]))
                        int.TryParse(Request.Form["hours"],out hours);
                    int mins = 0;
                    if (!string.IsNullOrEmpty(Request.Form["mins"]))
                        int.TryParse(Request.Form["mins"], out mins);
                    decimal myMin = (decimal)mins / 60;
                    hours_worked = hours + myMin;

                }
                if(formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET_TIME_ENTRY)
                {
                    if (!string.IsNullOrEmpty(Request.Form["ckAppSlo"]) && Request.Form["ckAppSlo"].Equals("on"))
                        pageTempEntry.append_to_resolution = 1;
                    else
                        pageTempEntry.append_to_resolution = 0;
                    if (!string.IsNullOrEmpty(Request.Form["ckAppSloInc"]) && Request.Form["ckAppSloInc"].Equals("on"))
                        pageTempEntry.append_to_resolution_incidents = 1;
                    else
                        pageTempEntry.append_to_resolution_incidents = 0;
                    if (!string.IsNullOrEmpty(Request.Form["ckCreateNote"]) && Request.Form["ckCreateNote"].Equals("on"))
                        pageTempEntry.apply_note_incidents = 1;
                    else
                        pageTempEntry.apply_note_incidents = 0;
                }



                pageTempEntry.hours_worked = hours_worked;

                if (!isAdd)
                {
                    tempEntry.status_id = pageTempEntry.status_id;
                    tempEntry.role_id = pageTempEntry.role_id;
                    tempEntry.hours_worked = pageTempEntry.hours_worked;
                    tempEntry.cost_code_id = pageTempEntry.cost_code_id;
                    tempEntry.is_billable = pageTempEntry.is_billable;
                    tempEntry.show_on_invoice = pageTempEntry.show_on_invoice;
                    tempEntry.summary_notes = pageTempEntry.summary_notes;
                    tempEntry.internal_notes = pageTempEntry.internal_notes;
                    if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET_TIME_ENTRY)
                    {
                        tempEntry.append_to_resolution = pageTempEntry.append_to_resolution;
                        tempEntry.append_to_resolution_incidents = pageTempEntry.append_to_resolution_incidents;
                        tempEntry.apply_note_incidents = pageTempEntry.apply_note_incidents;
                    }
                    return tempEntry;
                }
                else
                    return pageTempEntry;
                #endregion
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET_NOTE)
            {
                #region 工单备注相关
                sys_form_tmpl_activity pageTempNote = AssembleModel<sys_form_tmpl_activity>();
                if (!string.IsNullOrEmpty(Request.Form["ckAppSlo"]) && Request.Form["ckAppSlo"].Equals("on"))
                    pageTempNote.append_to_resolution = 1;
                else
                    pageTempNote.append_to_resolution = 0;
                if (!string.IsNullOrEmpty(Request.Form["ckAppSloInc"]) && Request.Form["ckAppSloInc"].Equals("on"))
                    pageTempNote.append_to_resolution_incidents = 1;
                else
                    pageTempNote.append_to_resolution_incidents = 0;
                if (!string.IsNullOrEmpty(Request.Form["ckCreateNote"]) && Request.Form["ckCreateNote"].Equals("on"))
                    pageTempNote.apply_note_incidents = 1;
                else
                    pageTempNote.apply_note_incidents = 0;

                if (!isAdd)
                {
                    tempNote.action_type_id = pageTempNote.action_type_id;
                    tempNote.status_id = pageTempNote.status_id;
                    tempNote.publish_type_id = pageTempNote.publish_type_id;
                    tempNote.name = pageTempNote.name;
                    tempNote.description = pageTempNote.description;
                    return tempNote;
                }
                else
                    return pageTempNote;
                #endregion
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET)
            {
                #region 工单相关
                sys_form_tmpl_ticket pageTempTicket = AssembleModel<sys_form_tmpl_ticket>();
                long? owner_resource_id = null;
                long? role_id = null;
                var priResString = Request.Form["redDepId"];
                if (!string.IsNullOrEmpty(priResString))
                {
                    var resDep = new DAL.sys_resource_department_dal().FindById(long.Parse(priResString));
                    if (resDep != null)
                    {
                        owner_resource_id = resDep.resource_id;
                        role_id = resDep.role_id;
                    }
                }
                pageTempTicket.owner_resource_id = owner_resource_id;
                pageTempTicket.role_id = role_id;

                if (!isAdd)
                {
                    pageTempTicket.id = tempTicket.id;
                    pageTempTicket.oid = tempTicket.oid;
                    pageTempTicket.create_time = tempTicket.create_time;
                    pageTempTicket.create_user_id = tempTicket.create_user_id;
                    pageTempTicket.update_time = tempTicket.update_time;
                    pageTempTicket.update_user_id = tempTicket.update_user_id;
                    pageTempTicket.form_tmpl_id = tempTicket.form_tmpl_id;
                }
                return pageTempTicket;

                #endregion

            }





            return null;
        }
        /// <summary>
        /// 获取自定义信息
        /// </summary>
        protected List<UserDefinedFieldValue> GetUdfValue()
        {
            var list = new List<UserDefinedFieldValue>();
            if (tickUdfList != null && tickUdfList.Count > 0)
            {
                foreach (var udf in tickUdfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);

                }
            }
            return list;
        }
        /// <summary>
        /// 获取检查单相关
        /// </summary>
        protected List<CheckListDto> GetCheckList()
        {
            List<CheckListDto> ckList = new List<CheckListDto>();
            #region 检查单相关
            var CheckListIds = Request.Form["CheckListIds"];  // 检查单Id
            if (!string.IsNullOrEmpty(CheckListIds))
            {
                
                var checkIdArr = CheckListIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var checkId in checkIdArr)
                {
                    if (string.IsNullOrEmpty(Request.Form[checkId + "_item_name"]))  // 条目名称为空 不添加
                        continue;
                    var is_complete = Request.Form[checkId + "_is_complete"];
                    var is_import = Request.Form[checkId + "_is_import"];
                    var sortOrder = Request.Form[checkId + "_sort_order"];
                    decimal? sort = null;
                    if (!string.IsNullOrEmpty(sortOrder))
                    {
                        sort = decimal.Parse(sortOrder);
                    }
                    var thisCheck = new CheckListDto()
                    {
                        ckId = long.Parse(checkId),
                        isComplete = is_complete == "on",
                        itemName = Request.Form[checkId + "_item_name"],
                        isImport = is_import == "on",
                        sortOrder = sort,
                    };
                    ckList.Add(thisCheck);
                }
               
            }
            #endregion
            return ckList;
        }

        protected void SaveClose_Click(object sender, EventArgs e)
        {
            var formTmpl = GetTemp();
            var obj = GetParam();
            var result = false;
            if(formTmpl!=null&& obj != null)
            {
                if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.OPPORTUNITY)
                {
                    if (isAdd)
                        result = tempBll.AddOpportunityTmpl(formTmpl, obj as sys_form_tmpl_opportunity, LoginUserId);
                    else
                        result = tempBll.EditOpportunityTmpl(formTmpl, obj as sys_form_tmpl_opportunity, LoginUserId);
                }
                else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.PROJECT_NOTE|| formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET_NOTE|| formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TASK_NOTE)
                {
                    if (isAdd)
                        result = tempBll.AddNoteTmpl(formTmpl, obj as sys_form_tmpl_activity, LoginUserId);
                    else
                        result = tempBll.EditNoteTmpl(formTmpl, obj as sys_form_tmpl_activity, LoginUserId);
                }
                else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.QUICK_CALL)
                {
                    if (isAdd)
                        result = tempBll.AddQuickCallTmpl(formTmpl, obj as sys_form_tmpl_quick_call, LoginUserId);
                    else
                        result = tempBll.EditQuickCallTmpl(formTmpl, obj as sys_form_tmpl_quick_call, LoginUserId);
                }
                else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.QUOTE)
                {
                    if (isAdd)
                        result = tempBll.AddQuoteTmpl(formTmpl, obj as sys_form_tmpl_quote, LoginUserId);
                    else
                        result = tempBll.EditQuoteTmpl(formTmpl, obj as sys_form_tmpl_quote, LoginUserId);
                }
                else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.RECURRING_TICKET)
                {
                    if (isAdd)
                        result = tempBll.AddRecTicketTmpl(formTmpl, obj as sys_form_tmpl_recurring_ticket, GetUdfValue(),LoginUserId);
                    else
                        result = tempBll.EditRecTicketTmpl(formTmpl, obj as sys_form_tmpl_recurring_ticket, GetUdfValue(), LoginUserId);
                }
                else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.SERVICE_CALL)
                {
                    if (isAdd)
                        result = tempBll.AddServiceCallTmpl(formTmpl, obj as sys_form_tmpl_service_call,  LoginUserId);
                    else
                        result = tempBll.EditServiceCallTmpl(formTmpl, obj as sys_form_tmpl_service_call,  LoginUserId);
                }
                else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TASK_TIME_ENTRY|| formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET_TIME_ENTRY)
                {
                    if (isAdd)
                        result = tempBll.AddWorkEntryTmpl(formTmpl, obj as sys_form_tmpl_work_entry, LoginUserId);
                    else
                        result = tempBll.EditWorkEntryTmpl(formTmpl, obj as sys_form_tmpl_work_entry, LoginUserId);
                }
                else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET)
                {
                    if (isAdd)
                        result = tempBll.AddTicketTmpl(formTmpl, obj as sys_form_tmpl_ticket, GetUdfValue(), GetCheckList(), LoginUserId);
                    else
                        result = tempBll.EditTicketTmpl(formTmpl, obj as sys_form_tmpl_ticket, GetUdfValue(), GetCheckList(), LoginUserId);
                }
            }

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result?"成功":"失败")}！');window.close();self.opener.location.reload();</script>");

        }
    }

    public class ResRole
    {
       public long resource_id;
        public long role_id;
    }
}