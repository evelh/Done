using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
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
        protected string actType;
        protected string type = "";
        protected string iframeSrc;
        protected sys_bookmark thisBookMark;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
               
                // var account_id = Request.QueryString["account_id"];      // 客户ID
                var contact_id = Request.QueryString["id"];      // 联系人ID

                if (AuthBLL.GetUserContactAuth(LoginUserId, LoginUser.security_Level_id, Convert.ToInt64(contact_id)).CanView == false)
                {
                    Response.End();
                    return;
                }

                contact = contactBLL.GetContact(Convert.ToInt64(contact_id));
                thisBookMark = new IndexBLL().GetSingBook(Request.Url.LocalPath + "?id=" + Convert.ToInt64(contact_id), LoginUserId);
                if (contact != null)
                {
                    account = companyBll.GetCompany(contact.account_id);
                }
                type = Request.QueryString["type"];
                if (string.IsNullOrEmpty(type))
                {
                    type = "activity";
                }
                if (type == "activity" || type == "note" || type == "todo")
                {
                    isHide.Value = "show";                                    
                }
                switch (type)    // 根据传过来的不同的类型，为页面中的iframe控件选择不同的src
                {
                    case "activity":
                        actType = "活动";
                        break;
                    case "todo":
                        iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.TODOS + "&type=" + (int)QueryType.Todos + "&group=112&con659=" + contact_id + "&param1=contactId&param2=" + contact_id;  // 待办
                        actType = "待办";
                        break;
                    case "note":
                        iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.CRM_NOTE_SEARCH + "&type=" + (int)QueryType.CRMNote + "&group=110&con646=" + contact_id + "&param1=contactId&param2=" + contact_id;  // 备注
                        actType = "备注";
                        break;
                    case "opportunity":
                        iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.OPPORTUNITY_CONTACT_VIEW + "&type=" + (int)QueryType.OpportunityContactView + "&id=" + contact_id;  // 商机
                        actType = "商机";
                        break;
                    case "configura":
                        iframeSrc= "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.INSTALLEDPRODUCT + "&type=" + (int)QueryType.InstalledProductView + "&con966=" + contact_id;
                        actType = "配置项";
                        break;
                    case "ticket":
                        iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_ACTIVE + "&group=215&con5602=" + contact_id + "&param1=ShowPara";
                        actType = "工单";
                        break;
                    case "group":
                        actType = "联系人组";
                        iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.ACCOUNT_CONTACT_GROUP_SEARCH + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.ACCOUNT_CONTACT_GROUP_SEARCH ; // todo 添加参数
                        break;
                    default:
                        iframeSrc = "";  // 默认
                        break;
                }
                if (type.Equals("activity"))
                {
                    var typeList = new ActivityBLL().GetCRMActionType();
                    noteType.DataSource = typeList;
                    noteType.DataTextField = "name";
                    noteType.DataValueField = "id";
                    noteType.DataBind();
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