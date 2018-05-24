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
        protected sys_form_tmpl_opportunity tempOppo;
        protected List<d_general> tempRangList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.FORM_TEMPLATE_RANGE_TYPE);          // 模板范围
        protected List<d_general> tempTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.FORM_TEMPLATE_TYPE);          // 模板类型
        protected List<sys_department> depList = new DAL.sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.DEPARTMENT);
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList(false);
        protected List<d_general> oppoStageList;
        protected List<d_general> oppoSourceList;
        protected List<d_general> oppoStatusList;
        protected List<d_general> oppoIntDegList;
        protected List<d_general> oppoComperList;
        protected crm_account thisAccount;
        protected crm_contact thisContact;
        protected ivt_product thisProduct;  
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
                if (pushList!=null&& pushList.Count > 0)
                    pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.PROJECT_NOTE).ToString()).ToList();
                if(actList!=null&& actList.Count>0)
                    actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.PROJECT_NOTE).ToString()).ToList();

            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TASK_NOTE)
            {
                typeName = "任务备注";
                if (pushList != null && pushList.Count > 0)
                    pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();
                if (actList != null && actList.Count > 0)
                    actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();

            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.TICKET_NOTE)
            {
                typeName = "工单备注";
                if (pushList != null && pushList.Count > 0)
                    pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TICKET_NOTE).ToString()).ToList();
                if (actList != null && actList.Count > 0)
                    actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TICKET_NOTE).ToString()).ToList();
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

            }
           

            return null;
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
            }
            else if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.PROJECT_NOTE)
            {

            }
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result?"成功":"失败")}！');window.close();self.opener.location.reload();</script>");

        }
    }
}