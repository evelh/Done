using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.ConfigurationItem
{
    public partial class AddOrEditConfigItem : BasePage
    {
        protected bool isAdd = true;
        protected crm_installed_product iProduct = null;
        protected List<UserDefinedFieldDto> iProduct_udfList = null;
        protected List<UserDefinedFieldValue> iProduct_udfValueList = null; //company
        protected Dictionary<string, object> dic = new InstalledProductBLL().GetField();
        protected crm_account account = null;
        protected ivt_product product = null;
        protected ctt_contract contract = null;
        protected crm_installed_product parentInsPro;
        protected List<crm_installed_product> childInsProList;
        protected ConfigurationItemAddDto param = new ConfigurationItemAddDto();
        protected ivt_product_dal ipDal = new ivt_product_dal();
        protected List<com_attachment> thisNoteAtt = null;   // 这个配置项的附件
        protected List<sys_resource> resList = new sys_resource_dal().GetSourceList();
        protected AttachmentBLL attBll = new AttachmentBLL();
        protected List<sys_notify_tmpl> tempList = new sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.CONFIGURATION_ITEM_CREATED);
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                iProduct_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONFIGURATION_ITEMS);
                var contract_id = Request.QueryString["contract_id"];
                if (!string.IsNullOrEmpty(contract_id))
                {
                    contract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contract_id));
                    if (contract != null)
                    {
                        account = new CompanyBLL().GetCompany(contract.account_id);
                    }
                }


                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    iProduct = new crm_installed_product_dal().GetInstalledProduct(long.Parse(id));
                    if (iProduct != null)
                    {
                        account = new CompanyBLL().GetCompany((long)iProduct.account_id);
                        var product = new ivt_product_dal().FindNoDeleteById(iProduct.product_id);
                   
                    }
                }
                var account_id = Request.QueryString["account_id"];
                if (!string.IsNullOrEmpty(account_id))
                {
                    account = new CompanyBLL().GetCompany(long.Parse(account_id));
                }
                //var contactList = new crm_contact_dal().GetContactByAccountId(account.id);
                //var serviceList = new ivt_service_dal().GetServiceList($" and vendor_id = {account.id}");
                #region 配置下拉框数据源

                var udfGroup = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.UDF_FILED_GROUP);
                List<d_general> cateList = null;
                if(udfGroup!=null&& udfGroup.Count > 0)
                {
                    cateList = udfGroup.Where(_ => _.parent_id == (int)UDF_CATE.CONFIGURATION_ITEMS).ToList();
                }
                installed_product_cate_id.DataTextField = "name";
                installed_product_cate_id.DataValueField = "id";
                installed_product_cate_id.DataSource = cateList;
                installed_product_cate_id.DataBind();
                installed_product_cate_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

                //contact_id.DataTextField = "name";
                //contact_id.DataValueField = "id";
                //contact_id.DataSource = contactList;
                //contact_id.DataBind();
                //contact_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

                // 
                //service.DataTextField = "name";
                //service.DataValueField = "id";
                //service.DataSource = serviceList;
                //service.DataBind();
                //service.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                //service.Enabled = false; // 所选合同如果是服务类型的，则此下拉框可选。可选内容为合同项
                #endregion
                if (iProduct != null)
                {
                    //account_id = iProduct.account_id.ToString();
                    iProduct_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.CONFIGURATION_ITEMS, iProduct.id, iProduct_udfList);
                    var isCopy = Request.QueryString["isCopy"];
                    
                    isAdd = false;
                    if (!string.IsNullOrEmpty(isCopy) && isCopy == "1")
                        isAdd = true;
                    if (!isAdd)
                    {
                        #region 记录浏览历史
                        var history = new sys_windows_history()
                        {
                            title = "配置项:" + (product == null ? "" : product.name) + account.name,
                            url = Request.RawUrl,
                        };
                        new IndexBLL().BrowseHistory(history, LoginUserId);
                        #endregion
                    }


                    if (iProduct.contract_id != null)
                    {
                        contract = new ctt_contract_dal().FindNoDeleteById((long)iProduct.contract_id);
                    }
                    if (iProduct.cate_id != null)
                    {
                        installed_product_cate_id.SelectedValue = iProduct.cate_id.ToString();
                    }
                    

                    if (iProduct.contact_id != null)
                    {
                        contact_id.SelectedValue = iProduct.contact_id.ToString();
                    }
                    viewSubscription_iframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONFIGSUBSCRIPTION + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.CONFIGSUBSCRIPTION + "&id=" + iProduct.id;

                    view_ticket_iframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_ACTIVE + "&group=215&con3962=" + iProduct.id+ "&param1=ShowPara";
                    // todo 订阅的通用查询
                    // "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_COMPANY_VIEW + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.ContactCompanyView + "&id=" + id;
                    thisNoteAtt = new com_attachment_dal().GetAttListByOid(iProduct.id);
                    if (!isAdd)
                    {
                        if (iProduct.parent_id != null)
                            parentInsPro = new crm_installed_product_dal().GetInstalledProduct((long)iProduct.parent_id);
                        childInsProList = new crm_installed_product_dal().GetChildInsPro(iProduct.id);
                    }
                }
                if (!IsPostBack)
                {
                    is_active_.Checked = true;
                    if (iProduct != null)
                    {
                        is_active_.Checked = iProduct.is_active == 1;
                    }
                }


            }
            catch (Exception msg)
            {
                Response.Write("<script>alert('"+msg.Message+"');window.close();</script>");
            }
            
        }

        protected void save_Click(object sender, EventArgs e)
        {
            var result = false;
            if (isAdd)
            {
                 result = new InstalledProductBLL().ConfigurationItemAdd(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('添加配置项成功！');location.href='AddOrEditConfigItem.aspx?id=" + param.id + "&account_id=" + param.account_id + "';self.opener.location.reload();</script>");
                }
                
            }
            else
            {
                 result = new InstalledProductBLL().EditConfigurationItem(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('修改配置项成功！');location.href='AddOrEditConfigItem.aspx?id=" + param.id + "&account_id=" + account.id + "';self.opener.location.reload();</script>");
                }
                
            }
            
           
        }
        /// <summary>
        /// 获取到页面参数
        /// </summary>
        /// <returns></returns>
        private ConfigurationItemAddDto GetPara()
        {
            // ConfigurationItemAddDto param = new ConfigurationItemAddDto() {};
            param = AssembleModel<ConfigurationItemAddDto>();
            param.terms = AssembleModel<Terms>();
            param.status = is_active_.Checked ? 1 : 0;
            if (iProduct_udfList != null && iProduct_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in iProduct_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);

                }
                param.udf = list;
            }

            if (isAdd)
            {

            }
            else
            {
                param.id = iProduct.id;
            }
            var ccMe = !string.IsNullOrEmpty(Request.Form["ccMe"]) && Request.Form["ccMe"].Equals("on");
            var ccAccMan = !string.IsNullOrEmpty(Request.Form["ccAccMan"]) && Request.Form["ccAccMan"].Equals("on");
            var sendFromSys = !string.IsNullOrEmpty(Request.Form["sendFromSys"]) && Request.Form["sendFromSys"].Equals("on");
            if((ccMe|| ccAccMan)&&!string.IsNullOrEmpty(Request.Form["notify_temp"]))
            {
                param.notice = new Notice() {
                    ckToMe = ccMe,
                    ckToAccMan = ccAccMan,
                    ckSendBySys = sendFromSys,
                    resources = Request.Form["notifyResIds"],
                    contacts = Request.Form["notifyConIds"],
                    notification_template = int.Parse(Request.Form["notify_temp"]),
                    subject = Request.Form["notify_title"],
                    other_emails = Request.Form["notify_others"],
                    additional_email_text = Request.Form["notify_description"],
                };
            }
            if (param.contract_id != null)
            {
                param.reviewByContract = 1;
            }
            else
            {
                if (!string.IsNullOrEmpty(Request.Form["ckByContract"])&& Request.Form["ckByContract"].Equals("on"))
                    param.reviewByContract = 1;
                else
                    param.reviewByContract = 0;
            }
            
            return param;
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var result = false;
            if (isAdd)
            {
                result = new InstalledProductBLL().ConfigurationItemAdd(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('添加配置项成功！');window.close();self.opener.location.reload();</script>");
                }

            }
            else
            {
                result = new InstalledProductBLL().EditConfigurationItem(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('修改配置项成功！');window.close();self.opener.location.reload();</script>");
                }

            }
        }

        protected void save_add_Click(object sender, EventArgs e)
        {
            
            var result = false;
            if (isAdd)
            {
                result = new InstalledProductBLL().ConfigurationItemAdd(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('添加配置项成功！');window.open('AddOrEditConfigItem.aspx?account_id=" + account.id + "','" + (int)EMT.DoneNOW.DTO.OpenWindow.AddInstalledProduct + "');</script>");
                }

            }
            else
            {
                result = new InstalledProductBLL().EditConfigurationItem(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('修改配置项成功！');window.open('AddOrEditConfigItem.aspx?account_id=" + account.id + "','" + (int)EMT.DoneNOW.DTO.OpenWindow.AddInstalledProduct + "');</script>");
                }

            }
        }
    }
}