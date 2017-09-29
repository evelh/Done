using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;
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
        protected int id;
        protected string number;
        protected string account;
        protected string date=string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out id)) {
                Response.Write("<script>alert('获取相关信息失败！');window.close();self.opener.location.reload();</script>");
            }
            var invoice = new ctt_invoice_dal().FindNoDeleteById(id);
            number = invoice.invoice_no;
            account = new crm_account_dal().FindNoDeleteById(invoice.account_id).name;
            if(invoice.paid_date!=null)
            date = invoice.paid_date.ToString().Substring(0,10).Replace("/","-");
        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            string number;
            string date;
            date= Request.Form["datevalue"].Trim().ToString();//获取时间
            number = Request.Form["InvoiceNumber"].Trim().ToString();//获取发票编号
            var result = new InvoiceBLL().InvoiceNumberAndDate(id, date, number, GetLoginUserId());
            if (result == DTO.ERROR_CODE.SUCCESS) {
                Response.Write("<script>alert('发票修改成功！');window.close();self.opener.location.reload();</script>");
            }
            else if (result==DTO.ERROR_CODE.EXIST) {
                Response.Write("<script>alert('发票编号已经存在，请修改！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                Response.Write("<script>alert('发票修改失败！');window.close();</script>");
            }

        }
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();</script>");
        }
    }
}