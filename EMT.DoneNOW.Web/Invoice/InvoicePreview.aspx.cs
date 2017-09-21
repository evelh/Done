using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Invoice
{
    public partial class InvoicePreview : System.Web.UI.Page
    {
        protected crm_account account = null;   // 当前展示的客户的ID，默认集合第一个
        protected List<crm_account> accList = null;   // 传递过来的客户的集合
        protected sys_quote_tmpl invoice_temp = null;  
        protected List<sys_quote_tmpl> invTempList = new sys_quote_tmpl_dal().GetInvoiceTemp();
        protected List<crm_account_deduction> thisAccDedList = null;  // 该客户下的条目
        protected List<crm_account_deduction> billToThisAccDedList = null;  // 计费到该客户的条目
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var invoice_temp_id = Request.QueryString["invoice_temp_id"];
                if(invTempList!=null&& invTempList.Count > 0)
                {
                    if (!string.IsNullOrEmpty(invoice_temp_id))
                    {
                        invoice_temp = new sys_quote_tmpl_dal().FindNoDeleteById(long.Parse(invoice_temp_id));
                    }
                    else
                    {

                    }
                }
               

                var accountIds = Request.QueryString["account_ids"];
                var account_id = Request.QueryString["account_id"];
                var accountList = new crm_account_dal().GetCompanyByIds(accountIds);
                if (accountList != null && accountList.Count > 0)
                {
                    if (!string.IsNullOrEmpty(account_id))
                    {
                        account = new CompanyBLL().GetCompany(long.Parse(account_id));
                    }
                    else
                    {
                        account = accountList[0];
                    }
                    if (account == null)
                    {
                        Response.End();
                    }
                }
                else
                {
                    Response.End();
                }
                
            }
            catch (Exception)
            {

                Response.End();
            }
            
        }
    }
}