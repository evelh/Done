using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.IVT;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace EMT.DoneNOW.Web
{
    public partial class ProductAdd : BasePage
    {
        protected List<UserDefinedFieldDto> contact_udfList = null;      // 联系人自定义
        protected string callBackFiled = "";
        protected long id;
        private ProductBLL pbll = new ProductBLL();
        protected ivt_product product = new ivt_product();
        protected string url;
        protected string cate_name;
        protected string code_name;
        protected List<VendorDto> VendorList = new List<VendorDto>();
        protected List<ivt_product_vendor> vendorlist = new List<ivt_product_vendor>();
        protected List<PageContextMenuDto> contextMenu = null;  // 右键菜单信息
        protected string vendor_json;
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);//获取id
            id = 1;
            GetMenus();
            if (!IsPostBack) {
                var dic = pbll.GetField();
                this.Item_Type.DataTextField = "show";
                this.Item_Type.DataValueField = "val";
                this.Item_Type.DataSource = dic.FirstOrDefault(_ => _.Key == "Item_Type").Value;
                this.Item_Type.DataBind();
                this.Item_Type.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                this.Period_Type.DataTextField = "show";
                this.Period_Type.DataValueField = "val";
                this.Period_Type.DataSource = dic.FirstOrDefault(_ => _.Key == "Period_Type").Value;
                this.Period_Type.DataBind();
                this.Period_Type.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                if (id > 0) {
                    product = pbll.GetProduct(id);
                    if (product == null)
                    {
                        Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else {
                        bind();
                        vendorlist = pbll.GetVendorList(product.id);
                        foreach (var ve in vendorlist) {
                            VendorList.Add(new VendorDto() {vendor=ve,vendorname=pbll.GetVendorName((long)ve.vendor_account_id)});
                        }
                    }
                }
                
            }            
        }
        #region 绑定初始值
        private void bind() {
            this.Product_Name.Text = product.product_name.ToString();
            if (product.description != null && !string.IsNullOrEmpty(product.description.ToString()))
            {
                this.Product_Description.Text = product.description.ToString();
            }
            if (product.is_active <= 0)
            {
                this.Active.Checked = false;
            }
            if (product.is_serialized > 0)
            {
                this.Serialized.Checked = true;
            }
            if (product.does_not_require_procurement > 0)
            {
                this.does_not_require_procurement.Checked = true;
            }
            if (product.unit_cost != null && !string.IsNullOrEmpty(product.unit_cost.ToString()))
            {
                this.Unit_Cost.Text = product.unit_cost.ToString();
            }
            if (product.unit_price != null && !string.IsNullOrEmpty(product.unit_price.ToString()))
            {
                this.Unit_Price.Text = product.unit_price.ToString();
            }
            if (product.msrp != null && !string.IsNullOrEmpty(product.msrp.ToString()))
            {
                this.MSRP.Text = product.msrp.ToString();
            }
            if (product.internal_id != null && !string.IsNullOrEmpty(product.internal_id.ToString()))
            {
                this.Internal_Product_ID.Text = product.internal_id.ToString();
            }
            if (product.external_id != null && !string.IsNullOrEmpty(product.external_id.ToString()))
            {
                this.External_Product_ID.Text = product.external_id.ToString();
            }
            if (product.link != null && !string.IsNullOrEmpty(product.link.ToString()))
            {
                this.Product_Link.Text = product.link.ToString();
            }
            if (product.url != null && !string.IsNullOrEmpty(product.url.ToString()))
            {
                url = product.url.ToString();
            }
            if (product.sku != null && !string.IsNullOrEmpty(product.sku.ToString()))
            {
                this.Product_SKU.Text = product.sku.ToString();
            }
            if (product.manu_name != null && !string.IsNullOrEmpty(product.manu_name.ToString()))
            {
                this.Manufacturer.Text = product.manu_name.ToString();
            }
            if (product.manu_product_no != null && !string.IsNullOrEmpty(product.manu_product_no.ToString()))
            {
                this.Manufacturer_Product_Number.Text = product.manu_product_no.ToString();
            }
            if (product.cate_id != null && !string.IsNullOrEmpty(product.cate_id.ToString()))
            {
                cate_name = new GeneralBLL().GetGeneralParentName((int)product.cate_id);
                //this.accCallBack.Text = cate_name;
                //this.accCallBack.Text = (product.cate_id.ToString());
            }
            if (!string.IsNullOrEmpty(product.cost_code_id.ToString()))
            //code_name
            { code_name = pbll.cost_code_name((long)product.cost_code_id); }
            if (product.installed_product_cate_id != null) {
                this.Item_Type.SelectedValue = product.installed_product_cate_id.ToString();
            }
            if (product.period_type_id != null) {
                this.Period_Type.SelectedValue = product.period_type_id.ToString();
            }
        }
        #endregion
        //处理数据
        private void save_deal() {
            if (id > 0)
            {
                product = pbll.GetProduct(id);
            }
            //需要进行唯一性校验
            product.product_name = this.Product_Name.Text.ToString();
            string cate,code;
            if (!string.IsNullOrEmpty(Request.Form["CallBackHidden"].ToString()))
            {
                cate = Convert.ToString(Request.Form["CallBackHidden"]);
                product.cate_id = Convert.ToInt32(cate);
            }

            if (!string.IsNullOrEmpty(Request.Form["accCallBackHidden"].ToString())) {
                code = Convert.ToString(Request.Form["accCallBackHidden"]);
                product.cost_code_id = Convert.ToInt32(code);
            }
            product.description = this.Product_Description.Text.ToString();
            product.unit_cost =Convert.ToDecimal(this.Unit_Cost.Text.ToString());
            product.unit_price = Convert.ToDecimal(this.Unit_Price.Text.ToString());
            product.msrp = Convert.ToDecimal(this.MSRP.Text.ToString());
            product.internal_id = this.Internal_Product_ID.Text.ToString();
            product.external_id = this.External_Product_ID.Text.ToString();
            product.link = this.Product_Link.Text.ToString();
            if (this.Item_Type.SelectedValue.ToString() != "0")
                product.installed_product_cate_id = Convert.ToInt32(this.Item_Type.SelectedValue.ToString());
            if (this.Period_Type.SelectedValue.ToString() != "0")
                product.period_type_id = Convert.ToInt32(this.Period_Type.SelectedValue.ToString());
            if (this.Active.Checked) {
                product.is_active = 1;
            }
            if (this.Serialized.Checked) {
                product.is_serialized = 1;
            }
            if (this.does_not_require_procurement.Checked) {
                product.does_not_require_procurement = 1;
            }
            product.manu_name = this.Manufacturer.Text.ToString();
            product.manu_product_no = this.Manufacturer_Product_Number.Text.ToString();
            product.sku = this.Product_SKU.Text.ToString();
            string t = Convert.ToString(Request.Form["vendor_data"].ToString());
            t = t.Replace("[,", "[").Replace(",]", "]");
            var tt=new EMT.Tools.Serialize().DeserializeJson<VendorData>(t);
            //更新
            if (id > 0) {
                var result=pbll.InsertProductAndVendor(product, tt, GetLoginUserId());
            }
            //新增
            else {
                var result=pbll.UpdateProductAndVendor(product,tt,GetLoginUserId());

            }

            

        }
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            save_deal();
        }

        protected void Save_New_Click(object sender, EventArgs e)
        {

        }

        protected void Cancel_Click(object sender, EventArgs e)
        {

        }
        private void GetMenus()
        {
            contextMenu = new List<PageContextMenuDto>();
            contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()" });
            contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
            contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()" });
            contextMenu.Add(new PageContextMenuDto { text = "失活", click_function = "NoActive()" });
            contextMenu.Add(new PageContextMenuDto { text = "设为默认", click_function = "Default()" });
        }
    }
}