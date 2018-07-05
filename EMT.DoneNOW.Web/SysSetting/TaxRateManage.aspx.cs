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
    public partial class TaxRateManage : BasePage
    {
        protected d_general thisTaxCate;
        protected d_general thisTaxRegion;
        protected bool isAdd = true;
        protected d_tax_region_cate thisCate;
        protected GeneralBLL genBll = new GeneralBLL();
        protected List<d_tax_region_cate_tax> taxList;
        protected List<d_general> regionList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.TAX_REGION);
        protected List<d_general> cateList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.QUOTE_ITEM_TAX_CATE);
        protected void Page_Load(object sender, EventArgs e)
        {
            long regionId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["regionId"]) && long.TryParse(Request.QueryString["regionId"], out regionId))
                thisTaxRegion = genBll.GetSingleGeneral(regionId,true);
            long cateId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["cateId"]) && long.TryParse(Request.QueryString["cateId"], out cateId))
                thisTaxCate = genBll.GetSingleGeneral(cateId,true);

            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                thisCate = genBll.GetRegionCate(id);
            if (thisCate != null)
            {
                isAdd = false;
                thisTaxRegion = genBll.GetSingleGeneral(thisCate.tax_region_id, true);
                thisTaxCate = genBll.GetSingleGeneral(thisCate.tax_cate_id, true);
                taxList = genBll.GetCateTaxList(thisCate.id);
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var pageCate = AssembleModel<d_tax_region_cate>();
            if (!isAdd)
            {
                thisCate.tax_cate_id = pageCate.tax_cate_id;
                thisCate.tax_region_id = pageCate.tax_region_id;
            }
            bool result = false;
            if (isAdd)
                result = genBll.AddRegionCate(pageCate,LoginUserId);
            else
                result = genBll.EditRegionCate(thisCate, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");


        }
    }
}