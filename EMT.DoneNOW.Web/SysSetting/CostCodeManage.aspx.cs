using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class CostCodeManage : BasePage
    {
        protected bool isAdd = true;
        protected d_cost_code code;
        protected d_cost_code_rule codeRule;
        protected int cateId;
        
        protected CostCodeBLL codeBll = new CostCodeBLL();
        protected d_general cateGeneral;
        protected List<sys_department> depList = new DAL.sys_department_dal().GetDepartment();
        protected List<d_general> ledgerList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.GENERAL_LEDGER);
        protected List<d_general> taxCateList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.QUOTE_ITEM_TAX_CATE);
        protected List<d_general> expTypeList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.EXPENSE_TYPE);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["cateId"]))
                int.TryParse(Request.QueryString["cateId"],out cateId);
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                code = codeBll.GetCodeById(id);
            if (code != null)
            {
                isAdd = false;
                cateId = code.cate_id;
            }
            if (cateId == 0) {
                Response.Write("<script>alert('未获取到相关种类！');window.close();</script>");
            }
            cateGeneral = new GeneralBLL().GetSingleGeneral(cateId);
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            d_cost_code param = GetParam();
            bool result = false;
            if (isAdd)
                result = codeBll.AddCode(param,LoginUserId);
            else
                result = codeBll.EditCode(param, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");
        }


        protected d_cost_code GetParam()
        {
            d_cost_code pageCode = AssembleModel<d_cost_code>();
            pageCode.cate_id = cateId;
            if (!string.IsNullOrEmpty(Request.Form["isActive"]) && Request.Form["isActive"] == "on")
                pageCode.is_active = 1;
            else
                pageCode.is_active = 0;
            if(cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE)
                pageCode.is_active = 1;
          

            if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE) {
                #region 角色费率相关，计费方式
            var rateType = Request.Form["RateTypeGroup"];
            if (rateType == "rdRole")
            {
                pageCode.billing_method_id = (int)DicEnum.WORKTYPE_BILLING_METHOD.USE_ROLE_RATE;
            }
            else if (rateType == "rdAdjust")
            {
                pageCode.billing_method_id = (int)DicEnum.WORKTYPE_BILLING_METHOD.FLOAT_ROLE_RATE;
                if (!string.IsNullOrEmpty(Request.Form["txtAdjust"]))
                    pageCode.rate_adjustment = decimal.Parse(Request.Form["txtAdjust"]);
            }
            else if (rateType == "rdMulti")
            {
                pageCode.billing_method_id = (int)DicEnum.WORKTYPE_BILLING_METHOD.RIDE_ROLE_RATE;
                if (!string.IsNullOrEmpty(Request.Form["txtMulti"]))
                    pageCode.rate_multiplier = decimal.Parse(Request.Form["txtMulti"]);
            }
            else if (rateType == "rdUdf")
            {
                pageCode.billing_method_id = (int)DicEnum.WORKTYPE_BILLING_METHOD.USE_UDF_ROLE_RATE;
                if (!string.IsNullOrEmpty(Request.Form["txtUdf"]))
                    pageCode.custom_rate = decimal.Parse(Request.Form["txtUdf"]);
            }
            else if (rateType == "rdFix")
            {
                pageCode.billing_method_id = (int)DicEnum.WORKTYPE_BILLING_METHOD.BY_TIMES;
                if (!string.IsNullOrEmpty(Request.Form["txtrdFix"]))
                    pageCode.flat_rate = decimal.Parse(Request.Form["txtrdFix"]);
            }

            if (!string.IsNullOrEmpty(Request.Form["ckLess"]) && Request.Form["ckLess"] == "rdLess" && !string.IsNullOrEmpty(Request.Form["txtLess"]))
                pageCode.min_hours = decimal.Parse(Request.Form["txtLess"]);
            if (!string.IsNullOrEmpty(Request.Form["ckMore"]) && Request.Form["ckMore"] == "rdMore" && !string.IsNullOrEmpty(Request.Form["txtMore"]))
                pageCode.max_hours = decimal.Parse(Request.Form["txtMore"]);

            var billType = Request.Form["BillTypeGroup"];
            if (billType == "rdNoBillNoShow")
                pageCode.show_on_invoice = (int)DicEnum.SHOW_ON_INVOICE.NO_SHOW_ONINCOICE;
            else if (billType == "rdNoBillShow")
                pageCode.show_on_invoice = (int)DicEnum.SHOW_ON_INVOICE.SHOW_DISBILLED;
            else if (billType == "rdBill")
                pageCode.show_on_invoice = (int)DicEnum.SHOW_ON_INVOICE.BILLED;
                #endregion
                if (!string.IsNullOrEmpty(Request.Form["isIncludeContract"]) && Request.Form["isIncludeContract"] == "on")
                    pageCode.excluded_new_contract = 1;
                else
                    pageCode.excluded_new_contract = 0;
            }
            else if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE)
            {
                if (!string.IsNullOrEmpty(Request.Form["isQuickAddCharge"]) && Request.Form["isQuickAddCharge"] == "on")
                    pageCode.is_quick_cost = 1;
                else
                    pageCode.is_quick_cost = 0;
            }
            else if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE)
            {
                if (!string.IsNullOrEmpty(Request.Form["isTimeOff"]) && Request.Form["isTimeOff"] == "on")
                    pageCode.is_timeoff = 1;
                else
                    pageCode.is_timeoff = 0;

                if (!string.IsNullOrEmpty(Request.Form["isRegTime"]) && Request.Form["isRegTime"] == "on")
                    pageCode.is_regular_time = 1;
                else
                    pageCode.is_regular_time = 0;
            }

            if (!isAdd)
            {
                code.name = pageCode.name;
                code.is_active = pageCode.is_active;
                code.external_id = pageCode.external_id;
                code.general_ledger_id = pageCode.general_ledger_id;
                if (cateId != (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE)
                {
                    code.tax_category_id = pageCode.tax_category_id;
                }
                if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE) {
                    code.billing_method_id = pageCode.billing_method_id;
                    code.rate_adjustment = pageCode.rate_adjustment;
                    code.rate_multiplier = pageCode.rate_multiplier;
                    code.custom_rate = pageCode.custom_rate;
                    code.flat_rate = pageCode.flat_rate;
                    code.min_hours = pageCode.min_hours;
                    code.max_hours = pageCode.max_hours;
                    code.show_on_invoice = pageCode.show_on_invoice;
                    code.department_id = pageCode.department_id;
                    code.excluded_new_contract = pageCode.excluded_new_contract;
                }
                else if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE)
                {
                    code.is_quick_cost = pageCode.is_quick_cost;
                    code.unit_cost = pageCode.unit_cost;
                    code.unit_price = pageCode.unit_price;

                }
                else if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE)
                {
                    code.is_timeoff = pageCode.is_timeoff;
                    code.is_regular_time = pageCode.is_regular_time;
                }
                else if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY)
                {
                    code.expense_type_id = pageCode.expense_type_id;
                }
                return code;
            }

            return pageCode;
        }
    }
}