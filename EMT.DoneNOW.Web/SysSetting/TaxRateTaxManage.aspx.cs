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
    public partial class TaxRateTaxManage : BasePage
    {
        protected bool isAdd = true;
        protected d_tax_region_cate thisCate;
        protected d_tax_region_cate_tax thisCateTax;
        protected GeneralBLL genBll = new GeneralBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long regionCateId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["regionCateId"]) && long.TryParse(Request.QueryString["regionCateId"], out regionCateId))
                thisCate = genBll.GetRegionCate(regionCateId);
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                thisCateTax = genBll.GetCateTax(id);
            if (thisCateTax != null)
            {
                thisCate = genBll.GetRegionCate(thisCateTax.tax_region_cate_id);
            }

            if (thisCate == null)
            {
                Response.Write("<script>alert('未获取到税收类型信息！');window.close();</script>");
            }
        }


        protected void save_close_Click(object sender, EventArgs e)
        {
            var pageCateTax = AssembleModel<d_tax_region_cate_tax>();
            if (!isAdd)
            {
                thisCateTax.tax_name = pageCateTax.tax_name;
                thisCateTax.tax_rate = pageCateTax.tax_rate;
                thisCateTax.sort_order = pageCateTax.sort_order;
            }
            else
            {
                pageCateTax.tax_region_cate_id = thisCate.id;
            }
            bool result = false;
            if (isAdd)
                result = genBll.AddRegionCateTax(pageCateTax, LoginUserId);
            else
                result = genBll.EditRegionCateTax(thisCateTax, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");
        }
    }
}