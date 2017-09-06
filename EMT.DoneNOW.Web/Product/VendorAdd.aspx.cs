using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.IVT;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Text;

namespace EMT.DoneNOW.Web
{
    public partial class VendorAdd : BasePage
    {
        protected long id;
        protected string state;//判断需要进行的操作
        protected ProductBLL vendorbll =new ProductBLL();
        protected ivt_product_vendor ivt_pv = new ivt_product_vendor();
        protected string vendorname = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
           id = Convert.ToInt64(Request.QueryString["id"]);
           state = Convert.ToString(Request.QueryString["state"]);
            if (!IsPostBack) {
                //获取类型为供应商的客户集合
                if (id > 0)
                {
                    ivt_pv = vendorbll.GetSingelVendor(id);
                    if (ivt_pv == null)
                    {
                        Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else
                    {
                        vendorname = vendorbll.GetVendorName((long)ivt_pv.vendor_account_id);
                        if (ivt_pv.is_active > 0)
                        {
                            this.active.Checked = true;
                        }
                        this.cost.Text = Convert.ToString(ivt_pv.vendor_cost);
                        this.number.Text = Convert.ToString(ivt_pv.vendor_product_no);
                    }

                }
            }          

        }
        public void save_deal() {
            StringBuilder veve = new StringBuilder();
            string is_active;
            if (this.active.Checked)
            {
              is_active = "y";
            }
            else
            {
               is_active ="n";
            }
            decimal cost = Convert.ToDecimal(this.cost.Text.ToString() == "" ? 0: Convert.ToDecimal(this.cost.Text.ToString()));
            string no = string.Empty;
            if (!string.IsNullOrEmpty(this.number.Text.ToString()))
            {
                no = this.number.Text.ToString();
            }
            veve.Append(@"{'vendorname':'"+Convert.ToString(Request.Form["vvname"])+ "','id':'" + Convert.ToString(Request.Form["CallBackHidden"]) + "','vendor_cost':'" + cost + "','vendor_product_no':'"+no+ "','active':'"+ is_active + "'}");           
            string k =veve.ToString();
            Response.Write("<script>window.opener.document.getElementById(\"vendor_data\").value=\""+k+"\";</script>");
            if (id > 0|| state!=null) {
                Response.Write("<script>window.opener.EditReturn();</script>");
            }else
            {
                Response.Write("<script>window.opener.kkk();</script>");
            }
        }
        protected void Save_Click(object sender, EventArgs e)
        {
            save_deal();
            Response.Write("<script>window.close();</script>");
        }
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();</script>");
        }
    }
}