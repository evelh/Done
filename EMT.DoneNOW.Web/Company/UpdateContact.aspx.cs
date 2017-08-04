using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.CRM;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.Company
{
    public partial class UpdateContact : BasePage
    {
        protected List<crm_contact> locationContactList = null;
        protected List<crm_contact> faxPhoneContactList = null;
        protected crm_location defaultLocation = null;
        protected crm_account account = null;
        protected List<DictionaryEntryDto> dic =  new d_district_dal().GetDictionary();
        protected List<DictionaryEntryDto> country_dic = new DistrictBLL().GetCountryList();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var updateLocationContact = Request.QueryString["updateLocationContact"];
                var updateFaxPhoneContact = Request.QueryString["updateFaxPhoneContact"];
                var account_id = Request.QueryString["account_id"];

                // GetContactByIds
                if (!string.IsNullOrEmpty(updateLocationContact))
                {
                    locationContactList = new ContactBLL().GetContactByIds(updateLocationContact);
                }
                if (!string.IsNullOrEmpty(updateFaxPhoneContact))
                {
                    faxPhoneContactList = new ContactBLL().GetContactByIds(updateFaxPhoneContact);
                }
                
                account = new CompanyBLL().GetCompany(Convert.ToInt64(account_id));
                defaultLocation = new LocationBLL().GetLocationByAccountId(Convert.ToInt64(account_id));
                if (account != null)
                {
                    Phone.Text = account.phone;
                    Fax.Text = account.fax;
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

        protected void save_close_Click(object sender, EventArgs e)
        {
            var updateId = Request.Params["updateId"];
            var fax = Request.Params["Fax"];
            var phone = Request.Params["Phone"];
            var account_id = Request.QueryString["account_id"];
            if (!string.IsNullOrEmpty(updateId))
            {
                var result = new ContactBLL().UpdateContacts(updateId, phone, fax, GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('修改联系人成功！');window.close();</script>");
                }
                else
                {
                    Response.Write("<script>alert('修改联系人失败！');window.close();</script>");
                }
            }
        }
    }
}