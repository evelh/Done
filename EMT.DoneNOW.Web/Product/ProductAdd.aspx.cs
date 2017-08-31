using EMT.DoneNOW.BLL.IVT;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class ProductAdd : BasePage
    {
        protected long id;
        private ProductBLL pbll = new ProductBLL();
        private ivt_product product = new ivt_product();
        protected string url;
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);//获取id
            id = 2;
            if (!IsPostBack) {
                if (id > 0) {
                    product = pbll.GetProduct(id);
                    if (product == null)
                    {
                        Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else {
                        this.Product_Name.Text = product.product_name.ToString();
                        if (product.description != null && !string.IsNullOrEmpty(product.description.ToString())) {
                            this.Product_Description.Text = product.description.ToString();
                        }
                        if (product.is_active > 0) {
                            this.Active.Checked = true;
                        }
                        if (product.is_serialized > 0) {
                            this.Serialized.Checked = true;
                        }
                        if (product.does_not_require_procurement > 0) {
                            this.does_not_require_procurement.Checked = true;
                        }
                        if (product.unit_cost != null && !string.IsNullOrEmpty(product.unit_cost.ToString())) {
                            this.Unit_Cost.Text = product.unit_cost.ToString();
                        }
                        if (product.unit_price != null && !string.IsNullOrEmpty(product.unit_price.ToString())) {
                            this.Unit_Price.Text = product.unit_price.ToString();
                        }
                        if (product.msrp != null && !string.IsNullOrEmpty(product.msrp.ToString())) {
                            this.MSRP.Text = product.msrp.ToString();
                        }
                        if (product.internal_id != null && !string.IsNullOrEmpty(product.internal_id.ToString())) {
                            this.Internal_Product_ID.Text = product.internal_id.ToString();
                        }
                        if (product.external_id != null && !string.IsNullOrEmpty(product.external_id.ToString())) {
                            this.External_Product_ID.Text = product.external_id.ToString();
                        }
                        if (product.link != null && !string.IsNullOrEmpty(product.link.ToString())) {
                            this.Product_Link.Text = product.link.ToString();
                        }
                        if (product.url != null && !string.IsNullOrEmpty(product.url.ToString())) {
                            url = product.url.ToString();
                        }
                        if (product.sku != null && !string.IsNullOrEmpty(product.sku.ToString())) {
                            this.Product_SKU.Text = product.sku.ToString();
                        }
                        if (product.manu_name != null && !string.IsNullOrEmpty(product.manu_name.ToString())) {
                            this.Manufacturer.Text = product.manu_name.ToString();
                        }
                        if (product.manu_product_no != null && !string.IsNullOrEmpty(product.manu_product_no.ToString())) {
                            this.Manufacturer_Product_Number.Text = product.manu_product_no.ToString();
                        }
                    }
                }
                
            }
        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {

        }

        protected void Save_New_Click(object sender, EventArgs e)
        {

        }

        protected void Cancel_Click(object sender, EventArgs e)
        {

        }
    }
}