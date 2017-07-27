using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL.CRM;

namespace EMT.DoneNOW.Web.Contact
{
    public partial class ViewContact : System.Web.UI.Page
    {
        protected crm_account account = null;
        protected crm_contact contact = null;
        protected CompanyBLL companyBll = new CompanyBLL();
        protected ContactBLL contactBLL = new ContactBLL();
        protected LocationBLL locationBLL = new LocationBLL();
        protected Dictionary<string, object> dic = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var account_id = Request.QueryString["account_id"];      // 客户ID
                var contact_id = Request.QueryString["contact_id"];      // 联系人ID
                account = companyBll.GetCompany(Convert.ToInt64(account_id));
                contact = contactBLL.GetContact(Convert.ToInt64(contact_id));
                if (account!=null&&contact!=null)
                {
                    dic = new CompanyBLL().GetField();
                }
                else
                {
                    Response.End();
                }

            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}