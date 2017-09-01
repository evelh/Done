using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.IVT;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    public partial class VendorAdd : BasePage
    {
        protected long id;
        protected ProductBLL vendorbll = new ProductBLL();
        protected ivt_product_vendor ivt_pv = new ivt_product_vendor();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            id = 1;
            if (!IsPostBack) {
                //获取类型为供应商的客户集合
                if (id > 0) {
                    ivt_pv = vendorbll.GetSingelVendor(id);
                    if (ivt_pv == null)
                    {
                        Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else {
                        this.CallBack.Text = vendorbll.GetVendorName((long)ivt_pv.vendor_account_id);
                        if (ivt_pv.is_active > 0) {
                            this.active.Checked = true;
                        }
                        if (ivt_pv.is_default > 0) {
                            this.@default.Checked = true;
                        }
                        this.cost.Text = Convert.ToString(ivt_pv.vendor_cost);
                        this.number.Text = Convert.ToString(ivt_pv.vendor_product_no);
                    }

                }
            }
           

        }
        public void save_deal() {
            //获取供应商id
            ivt_pv.vendor_account_id = Convert.ToInt32(Request.Form["CallBackHidden"]);
        }
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            save_deal();
            string k="123";
            Response.Write("<script>window.opener.document.getElementById(\"vendor_data\").value=\"" + k+ "\";window.opener.vendoradd();window.close();</script>");
        }

        protected void Save_New_Click(object sender, EventArgs e)
        {

        }

        protected void Cancel_Click(object sender, EventArgs e)
        {

        }
    }
}