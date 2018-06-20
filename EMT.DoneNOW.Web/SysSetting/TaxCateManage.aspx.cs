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
    public partial class TaxCateManage : BasePage
    {
        protected bool isAdd = true;
        protected d_general thisTaxCate;
        protected GeneralBLL genBll = new GeneralBLL();
        protected CostCodeBLL codeBll = new CostCodeBLL();
        protected string workTypeIds;
        protected string materialIds;
        protected string serviceIds;
        protected string expenseIds;
        protected string milestoneIds;
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                thisTaxCate = genBll.GetSingleGeneral(id,true);
            if (thisTaxCate != null)
            {
                isAdd = false;
                List<d_cost_code> CodeList = codeBll.GetCodeByTaxCate(thisTaxCate.id);
                if (CodeList != null && CodeList.Count > 0) {
                    List<d_cost_code> workType = CodeList.Where(_ => _.cate_id == (int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE).ToList();
                    List<d_cost_code> expenseType = CodeList.Where(_ => _.cate_id == (int)DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY).ToList();
                    List<d_cost_code> materialType = CodeList.Where(_ => _.cate_id == (int)DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE).ToList();
                    List<d_cost_code> serviceType = CodeList.Where(_ => _.cate_id == (int)DicEnum.COST_CODE_CATE.RECURRING_CONTRACT_SERVICE_CODE).ToList();
                    List<d_cost_code> milestoneType = CodeList.Where(_ => _.cate_id == (int)DicEnum.COST_CODE_CATE.MILESTONE_CODE).ToList();
                    if (workType.Count > 0)
                    {
                        workType.ForEach(_ => {
                            workTypeIds += _.id.ToString() +',';
                        });
                    }
                    if (expenseType.Count > 0)
                    {
                        expenseType.ForEach(_ => {
                            expenseIds += _.id.ToString() + ',';
                        });
                    }
                    if (materialType.Count > 0)
                    {
                        materialType.ForEach(_ => {
                            materialIds += _.id.ToString() + ',';
                        });
                    }
                    if (serviceType.Count > 0)
                    {
                        serviceType.ForEach(_ => {
                            serviceIds += _.id.ToString() + ',';
                        });
                    }
                    if (milestoneType.Count > 0)
                    {
                        milestoneType.ForEach(_ => {
                            milestoneIds += _.id.ToString() + ',';
                        });
                    }

                    if (!string.IsNullOrEmpty(workTypeIds))
                        workTypeIds = workTypeIds.Substring(0, workTypeIds.Length-1);
                    if (!string.IsNullOrEmpty(materialIds))
                        materialIds = materialIds.Substring(0, materialIds.Length - 1);
                    if (!string.IsNullOrEmpty(serviceIds))
                        serviceIds = serviceIds.Substring(0, serviceIds.Length - 1);
                    if (!string.IsNullOrEmpty(expenseIds))
                        expenseIds = expenseIds.Substring(0, expenseIds.Length - 1);
                    if (!string.IsNullOrEmpty(milestoneIds))
                        milestoneIds = milestoneIds.Substring(0, milestoneIds.Length - 1);
                }
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var pageDic = AssembleModel<d_general>();
            pageDic.general_table_id = (int)GeneralTableEnum.QUOTE_ITEM_TAX_CATE;
            if (!isAdd)
            {
                thisTaxCate.name = pageDic.name;
                thisTaxCate.remark = pageDic.remark;
                thisTaxCate.is_active = pageDic.is_active;
            }


            string ids = "";
            if (!string.IsNullOrEmpty(Request.Form["workTypeIds"]))
                ids += Request.Form["workTypeIds"] + ',';
            if (!string.IsNullOrEmpty(Request.Form["materialIds"]))
                ids += Request.Form["materialIds"] + ',';
            if (!string.IsNullOrEmpty(Request.Form["serviceIds"]))
                ids += Request.Form["serviceIds"] + ',';
            if (!string.IsNullOrEmpty(Request.Form["expenseIds"]))
                ids += Request.Form["expenseIds"] + ',';
            if (!string.IsNullOrEmpty(Request.Form["milestoneIds"]))
                ids += Request.Form["milestoneIds"] + ',';
            if (!string.IsNullOrEmpty(ids))
                ids = ids.Substring(0, ids.Length-1);

            bool result = false;
            if (isAdd)
            {
                result = genBll.AddGeneral(pageDic, LoginUserId);
                codeBll.ChangeCodeTaxCate(ids, pageDic.id,LoginUserId);
            }
            else
            {
                result = genBll.EditGeneral(thisTaxCate, LoginUserId);
                codeBll.ChangeCodeTaxCate(ids, thisTaxCate.id, LoginUserId);
            }

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");

        }
    }
}