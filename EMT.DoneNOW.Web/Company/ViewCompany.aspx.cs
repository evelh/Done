using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.CRM;

namespace EMT.DoneNOW.Web.Company
{
    public partial class ViewCompany : BasePage
    {
        protected crm_account crm_account = null;
        protected Dictionary<string, object> dic = null;
        protected CompanyBLL companyBll = new CompanyBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                var type = Request.QueryString["type"];
                if (id != null)
                {
                    crm_account = new CompanyBLL().GetCompany(Convert.ToInt64(id));
                    if (crm_account != null)
                    {
                        //Edit.OnClientClick = $"window.open(EditCompany.aspx?id={crm_account.id});";
                        dic = new CompanyBLL().GetField();    // 获取字典
                        if (type == "activity" || type == "note" || type == "todo")
                        {
                            isHide.Value = "show";
                            activetytype.Value = type;
                            //  Response.Write("<script>document.getElementById('showCompanyGeneral').style.display='none';</script>");
                        }
                        switch (type)    // 根据传过来的不同的类型，为页面中的iframe控件选择不同的src
                        {
                            case "activity":
                                viewCompany_iframe.Src = "../Activity/ViewActivity.aspx?id=" + crm_account.id.ToString();  // 活动
                                break;
                            case "todo":
                                viewCompany_iframe.Src = "";  // 待办
                                break;
                            case "note":
                                viewCompany_iframe.Src = "";  // 备注
                                break;
                            case "opportunity":
                                viewCompany_iframe.Src = "";  // 商机
                                break;//
                            case "contact":
                                viewCompany_iframe.Src = "";  // 联系人
                                break;//
                            case "Subsidiaries":
                                viewCompany_iframe.Src = "";  // 子公司
                                break;//Subsidiaries
                            default:
                                viewCompany_iframe.Src = "";  // 默认
                                break;
                        }
                        //viewCompany_iframe.Src = "";  // 
                    }
                    else
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

        /// <summary>
        /// 获取到当前操作的客户
        /// </summary>
        /// <returns></returns>
        public crm_account GetAccount()
        {
            return crm_account;
        }

        /// <summary>
        /// 获取到客户的默认地址
        /// </summary>
        /// <returns></returns>
        public crm_location GetDefaultLocation()
        {
            return new LocationBLL().GetLocationByAccountId(crm_account.id);
        }

        /// <summary>
        /// 获取到客户的主要联系人，可能为null
        /// </summary>
        /// <returns></returns>
        public crm_contact GetDefaultContact()
        {
            return new ContactBLL().GetDefaultByAccountId(crm_account.id);
        }
    }
}