using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL.CRM;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web
{
    public partial class ViewContact : BasePage
    {
        protected crm_account account = null;
        protected crm_contact contact = null;
        protected List<UserDefinedFieldDto> contactUDFList = null;                   // 用户自定义字段
        protected List<UserDefinedFieldValue> contactEDFValueList = null;            // 用户自定义字段的值
        protected CompanyBLL companyBll = new CompanyBLL();
        protected ContactBLL contactBLL = new ContactBLL();
        protected LocationBLL locationBLL = new LocationBLL();
        protected Dictionary<string, object> dic = null;
        protected string type = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var account_id = Request.QueryString["account_id"];      // 客户ID
                var contact_id = Request.QueryString["contact_id"];      // 联系人ID
                account = companyBll.GetCompany(Convert.ToInt64(account_id));
                contact = contactBLL.GetContact(Convert.ToInt64(contact_id));
                type = Request.QueryString["type"];
                if (type == "activity" || type == "note" || type == "todo")
                {
                    isHide.Value = "show";                                    
                }
                switch (type)    // 根据传过来的不同的类型，为页面中的iframe控件选择不同的src
                {
                   
                    case "todo":
                        viewContact_iframe.Src = "";  // 待办
                        break;
                    case "note":
                        viewContact_iframe.Src = "";  // 备注
                        break;
                    case "opportunity":
                        viewContact_iframe.Src = "";  // 商机
                        break;      
                    default:
                        viewContact_iframe.Src = "";  // 默认
                        break;
                }
                if (account!=null&&contact!=null)
                {
                    dic = new CompanyBLL().GetField();
                    contactUDFList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTACT);
                    contactEDFValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.CONTACT,contact.id,contactUDFList);
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