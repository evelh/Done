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
        protected long formTypeId;
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
        protected List<sys_notify_tmpl> tempList ;

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
                long.TryParse(Request.QueryString["formTypeId"],out formTypeId);
            var thisFromType = tempTypeList.FirstOrDefault(_=>_.id==formTypeId);
            if (thisFromType != null)
                typeName = thisFromType.name;
            if (formTypeId == (int)DicEnum.FORM_TMPL_TYPE.OPPORTUNITY)
            {
                typeName = "商机";
                oppoStageList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_STAGE);
                oppoSourceList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_SOURCE);
                oppoStatusList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_STATUS);
                oppoIntDegList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_INTEREST_DEGREE);
                oppoComperList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.COMPETITOR);
                tempList = new DAL.sys_notify_tmpl_dal().GetTempByEvent(((int)DicEnum.NOTIFY_EVENT.OPPORTUNITY_CREATEDOREDITED).ToString());
            }
           
        }
    }
}