using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Company
{
    public partial class ViewCompany : BasePage
    {
        protected crm_account crm_account = null;
        protected Dictionary<string, object> dic = null;
        protected CompanyBLL companyBll = new CompanyBLL();
        protected string type;
        protected string actType;
        protected string iframeSrc;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                type = Request.QueryString["type"];
                if (id != null)
                {
                    if (AuthBLL.GetUserCompanyAuth(LoginUserId, LoginUser.security_Level_id, Convert.ToInt64(id)).CanView == false)     // 权限验证
                    {
                        Response.End();
                        return;
                    }
                    var src = Request.QueryString["src"];
                    if (!string.IsNullOrEmpty(src))
                        crm_account = companyBll.GetCompanyByOtherId(Convert.ToInt64(id), src);
                    else
                        crm_account = companyBll.GetCompanyByOtherId(Convert.ToInt64(id));
                    if (crm_account != null)
                    {
                       
                        dic = new CompanyBLL().GetField();    // 获取字典
                        if (string.IsNullOrEmpty(type))
                        {
                            type = "activity";
                        }
                        if (type == "activity" || type == "note" || type == "todo")
                        {
                            isHide.Value = "show";
                            //  Response.Write("<script>document.getElementById('showCompanyGeneral').style.display='none';</script>");
                        }
                        switch (type)    // 根据传过来的不同的类型，为页面中的iframe控件选择不同的src
                        {
                            case "activity":
                                var typeList = new ActivityBLL().GetCRMActionType();
                                noteType.DataSource = typeList;
                                noteType.DataTextField = "name";
                                noteType.DataValueField = "id";
                                noteType.DataBind();
                                actType = "活动";
                                break;
                            case "todo":            // 待办
                                iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.TODOS + "&type=" + (int)QueryType.Todos + "&group=112&con658=" + crm_account.id;
                                actType = "待办";
                                break;
                            case "note":            // 备注
                                iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.CRM_NOTE_SEARCH + "&type=" + (int)QueryType.CRMNote + "&group=110&con645=" + crm_account.id;
                                actType = "备注";
                                break;
                            case "opportunity":
                                iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.OPPORTUNITY_COMPANY_VIEW + "&type=" + (int)QueryType.OpportunityCompanyView + "&id=" + id;
                                actType = "商机";
                                break;//
                            case "contact":
                                iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.CONTACT_COMPANY_VIEW + "&type=" + (int)QueryType.ContactCompanyView + "&id=" + id;  // 联系人
                                actType = "联系人";
                                break;//
                            case "Subsidiaries":
                                iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.SUBCOMPANY_COMPANY_VIEW + "&type=" + (int)QueryType.SubcompanyCompanyView + "&id=" + id;  // 子公司
                                actType = "子客户";
                                break;//Subsidiaries
                            case "saleOrder":               // 销售订单
                                iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.SALEORDER + "&type=" + (int)QueryType.SaleOrder + "&group=42&con385=" + id;
                                actType = "销售订单";
                                break;
                            case "contract":        // 合同
                                iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.COMPANY_VIEW_CONTRACT + "&type=" + (int)QueryType.CompanyViewContract + "&con933=" + id;
                                actType = "合同";
                                break;
                            case "confirgItem":
                                iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.INSTALLEDPRODUCT + "&type=" + (int)QueryType.InstalledProductView + "&con358=" + id;
                                actType = "配置项";
                                break;
                            case "invoice":
                                iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.COMPANY_VIEW_INVOICE + "&type=" + (int)QueryType.CompanyViewInvoice + "&con934=" + id;
                                actType = "发票";
                                break;
                            case "attachment":
                                iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.COMPANY_VIEW_ATTACHMENT + "&type=" + (int)QueryType.CompanyViewAttachment + "&con674=" + id;
                                actType = "附件";
                                break;
                            default:
                                iframeSrc = "";  // 默认
                                actType = "活动";
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