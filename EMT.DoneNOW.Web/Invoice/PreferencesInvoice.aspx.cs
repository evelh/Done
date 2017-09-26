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
    public partial class PreferencesInvoice : BasePage
    {
        protected crm_account account = null;
        protected crm_account_reference accRef = null;
        protected crm_account parentAccount = null;
        protected Dictionary<string, object> dic = new InvoiceBLL().GetField();
        protected List<crm_contact> contractList = null;   // 联系人列表
        protected List<sys_resource> resourceList = new sys_resource_dal().GetSourceList();
        protected void Page_Load(object sender, EventArgs e)

        {
            try
            {
                var account_id = Request.QueryString["account_id"];
                if (!string.IsNullOrEmpty(account_id))
                {

                    #region 下拉框赋值
                    invoice_tmpl_id.DataValueField = "id";
                    invoice_tmpl_id.DataTextField = "name";
                    invoice_tmpl_id.DataSource = dic.FirstOrDefault(_ => _.Key == "invoice_tmpl").Value;
                    invoice_tmpl_id.DataBind();
                    invoice_tmpl_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });


                    tax_region_id.DataValueField = "val";
                    tax_region_id.DataTextField = "show";
                    tax_region_id.DataSource = dic.FirstOrDefault(_ => _.Key == "taxRegion").Value;
                    tax_region_id.DataBind();
                    tax_region_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                    // invoice_email_message_tmpl_id
                    invoice_email_message_tmpl_id.DataValueField = "id";
                    invoice_email_message_tmpl_id.DataTextField = "name";
                    invoice_email_message_tmpl_id.DataSource = dic.FirstOrDefault(_ => _.Key == "email_temp").Value;
                    invoice_email_message_tmpl_id.DataBind();
                    invoice_email_message_tmpl_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                    #endregion

                    account = new CompanyBLL().GetCompany(long.Parse(account_id));
                    contractList = new crm_contact_dal().GetContactByAccountId(account.id);
                    accRef = new crm_account_reference_dal().GetAccountRef(account.id);
                    if (accRef != null)
                    {
                        invoice_tmpl_id.SelectedValue = accRef.invoice_tmpl_id == null ? "0" : accRef.invoice_tmpl_id.ToString();
                        tax_region_id.SelectedValue = account.tax_region_id == null ? "0" : account.tax_region_id.ToString();
                    }

                    if (!IsPostBack)
                    {
                        // no_contract_bill_to_parent
                        nocontract_bill_to_parent.Checked = accRef != null && accRef.no_contract_bill_to_parent == 1;
                        _ctl3_chkTaxExempt_ATCheckBox.Checked = account != null && account.is_tax_exempt == 1;
                        if (accRef != null)
                        {
                            if(accRef.invoice_address_type_id== (int)DicEnum.INVOICE_ADDRESS_TYPE.USE_ACCOUNT_ADDRESS)
                            {
                                _ctl3_rdoAccount.Checked = true;
                            }
                            else if (accRef.invoice_address_type_id == (int)DicEnum.INVOICE_ADDRESS_TYPE.USE_PARENT_ACC_ADD)
                            {
                                _ctl3_UseParent.Checked = true;
                            }
                            else if (accRef.invoice_address_type_id == (int)DicEnum.INVOICE_ADDRESS_TYPE.USE_PARENT_INVOIVE_ADD)
                            {
                                _ctl3UseParInv.Checked = true;
                            }
                            else if (accRef.invoice_address_type_id == (int)DicEnum.INVOICE_ADDRESS_TYPE.USE_INSERT)
                            {
                                _ctl3_rdoAccountBillTo.Checked = true;
                            }
                            enable_email.Checked = accRef.enable_email_invoice == 1;
                        }

                    }

                    if (account.parent_id != null)
                    {
                        parentAccount = new CompanyBLL().GetCompany((long)account.parent_id);
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
        /// 页面参数处理
        /// </summary>
        protected PreferencesInvoiceDto GetParam()
        {
            var thisParam= AssembleModel<PreferencesInvoiceDto>();
            var thisRef = AssembleModel<crm_account_reference>();
            thisRef.no_contract_bill_to_parent = (sbyte)(nocontract_bill_to_parent.Checked ? 1 : 0);
            thisParam.is_tax_exempt = _ctl3_chkTaxExempt_ATCheckBox.Checked ? 1 : 0;
            thisRef.enable_email_invoice = (sbyte)(enable_email.Checked?1:0);
            // 是否14)	支持发送邮件：界面输入-todo
            var addressType = Request.Form["_ctl3_rdoBillTo"];
            switch (addressType)
            {
                case "_ctl3_rdoAccount":
                    thisRef.invoice_address_type_id = (int)DicEnum.INVOICE_ADDRESS_TYPE.USE_ACCOUNT_ADDRESS;
                    
                    break;
                case "_ctl3_UseParent":
                    thisRef.invoice_address_type_id = (int)DicEnum.INVOICE_ADDRESS_TYPE.USE_PARENT_ACC_ADD;
                    break;
                case "_ctl3UseParInv":
                    thisRef.invoice_address_type_id = (int)DicEnum.INVOICE_ADDRESS_TYPE.USE_PARENT_INVOIVE_ADD;
                    break;
                case "_ctl3_rdoAccountBillTo":
                    thisRef.invoice_address_type_id = (int)DicEnum.INVOICE_ADDRESS_TYPE.USE_INSERT;
                    var location = AssembleModel<crm_location>();
                    location.account_id = account.id;
                    location.is_default = 0;
                    if (location.province_id != 0 && location.city_id != 0 && location.district_id != null && location.district_id != 0 && (!string.IsNullOrEmpty(location.address)))
                    {
                        break;
                    }
                    if (thisRef.billing_location_id == null)
                    {
                        new LocationBLL().Insert(location,GetLoginUserId());
                        thisRef.billing_location_id = location.id;
                    }
                    else
                    {
                        var oldLocation = new crm_location_dal().FindNoDeleteById((long)thisRef.billing_location_id);
                        location.id = oldLocation.id;
                        location.is_default = oldLocation.is_default;
                        location.location_label = oldLocation.location_label;
                        new LocationBLL().Update(location,GetLoginUserId());
                        
                    }

                    break;
                default:
                    break;
            }




            if (accRef != null)
            {
                accRef.invoice_tmpl_id = thisRef.invoice_tmpl_id;
                accRef.attention = thisRef.attention;
                accRef.address = thisRef.address;
                accRef.additional_address = thisRef.additional_address;
                accRef.province_id = thisRef.province_id;
                accRef.city_id = thisRef.city_id;
                accRef.district_id = thisRef.district_id;
                accRef.postal_code = thisRef.postal_code;
                accRef.no_contract_bill_to_parent = thisRef.no_contract_bill_to_parent;
                accRef.invoice_address_type_id = thisRef.invoice_address_type_id;
                accRef.email_to_contacts = thisRef.email_to_contacts;
                accRef.email_to_others = thisRef.email_to_others;
                accRef.email_bcc_resources = thisRef.email_bcc_resources;
                accRef.email_bcc_account_manager = thisRef.email_bcc_account_manager;


                thisParam.accRef = this.accRef;
            }
            else
            {
                thisRef.account_id = account.id;
                thisParam.accRef = thisRef;
               
            }
            return thisParam;
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var result = new InvoiceBLL().PreferencesInvoice(param,GetLoginUserId());
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close(); </script>");
                // 跳转到预览界面
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！');window.close(); </script>");
            }
                 
        }
    }
}