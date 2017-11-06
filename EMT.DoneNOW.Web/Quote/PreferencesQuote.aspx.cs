using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Quote
{
    public partial class PreferencesQuote : BasePage
    {
        protected List<crm_contact> contactList = null;
        protected List<sys_resource> resourceList = null;
        protected crm_account_reference accRef = null;
        protected long accountId;
        private QuoteBLL bll = new QuoteBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var id = Request.QueryString["account_id"];
                if (string.IsNullOrEmpty(id))
                {
                    id = Request.QueryString["quote_id"];
                    if (string.IsNullOrEmpty(id))
                    {
                        Response.Close();
                        return;
                    }
                    else
                    {
                        var quote = bll.GetQuote(long.Parse(id));
                        accountId = quote.account_id;
                    }
                }
                else
                    accountId = long.Parse(id);

                var dic = bll.GetField();
                
                quote_email_message_tmpl_id.DataValueField = "id";
                quote_email_message_tmpl_id.DataTextField = "name";
                quote_email_message_tmpl_id.DataSource = dic.FirstOrDefault(_ => _.Key == "email_tmpl").Value;
                quote_email_message_tmpl_id.DataBind();
                
                quote_tmpl_id.DataValueField = "id";
                quote_tmpl_id.DataTextField = "name";
                quote_tmpl_id.DataSource = dic.FirstOrDefault(_ => _.Key == "quote_tmpl").Value;
                quote_tmpl_id.DataBind();

                accRef = bll.GetQuoteRef(accountId);
                if (accRef != null)
                {
                    quote_tmpl_id.SelectedValue = accRef.quote_tmpl_id.ToString();
                    quote_email_message_tmpl_id.SelectedValue = accRef.quote_email_message_tmpl_id.ToString();
                }
            }
            else
            {
                accountId = long.Parse(Request.Form["account_id"]);

                var thisRef = AssembleModel<crm_account_reference>();
                bool emailQuoteContact = false;
                bool emailAccountResource = false;
                if (!string.IsNullOrEmpty(Request.Form["chooseQuoteContact"]) && Request.Form["chooseQuoteContact"].Equals("on"))
                    emailQuoteContact = true;
                if (!string.IsNullOrEmpty(Request.Form["chooseManage"]) && Request.Form["chooseManage"].Equals("on"))
                    emailAccountResource = true;
                if (bll.PreferencesQuote(thisRef, emailQuoteContact, emailAccountResource, GetLoginUserId()))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close(); </script>");
                }
            }
            var account = new CompanyBLL().GetCompany(accountId);
            contactList = new ContactBLL().GetContactByCompany(account.id);
            resourceList = new UserResourceBLL().GetAllSysResource();
        }
    }
}