using EMT.DoneNOW.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class InvoiceNumberAndDateEdit :BasePage
    {
        protected string company;
        protected string account;
        protected int id;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out id)) {

            }
            if (!string.IsNullOrEmpty(Request.QueryString["company"])) {
                company = Request.QueryString["company"];
            }
            if (!string.IsNullOrEmpty(Request.QueryString["account"])) {
                account = Request.QueryString["account"];
            }
        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            string number;
            string date;
            date= Request.Form["post_date"].Trim().ToString();//获取时间
            number = Request.Form["InvoiceNumber"].Trim().ToString();//获取发票编号
            if (new InvoiceBLL().InvoiceNumberAndDate(id, date, number, GetLoginUserId())) {
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
            }
            else
            {
                Response.Write("<script>alert('发票编号修改失败！');window.close();self.opener.location.reload();</script>");
            }

        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();</script>");
        }
    }
}