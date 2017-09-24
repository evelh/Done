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
    public partial class ProcessInvoice : BasePage
    {
        protected string[] idList = null;
        protected Dictionary<string, object> dic = new InvoiceBLL().GetField();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var ids = Request.QueryString["account_ids"];
                if (!string.IsNullOrEmpty(ids))
                {
                    List<string> accDedIds = new List<string>();
                   var  accountIDS = ids.Split(new char[] {',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var account_id in accountIDS)
                    {
                       var paramList = new crm_account_deduction_dal().GetInvDedDtoList(" and account_id=" + account_id);
                       var billTOThisParamList = new crm_account_deduction_dal().GetInvDedDtoList(" and account_id <> " + account_id + " and bill_account_id=" + account_id);
                        if (paramList != null && paramList.Count > 0)
                        {
                            accDedIds.AddRange(paramList.Select(_=>_.id.ToString()).ToList());
                        }
                        if (billTOThisParamList != null && billTOThisParamList.Count > 0)
                        {
                            accDedIds.AddRange(billTOThisParamList.Select(_ => _.id.ToString()).ToList());
                        } 
                    } 
                    if(accDedIds!=null&& accDedIds.Count > 0)
                    {
                        idList = accDedIds.ToArray();
                    }
                    if (!IsPostBack)
                    {
                        invoice_template_id.DataValueField = "id";
                        invoice_template_id.DataTextField = "name";
                        invoice_template_id.DataSource = dic.FirstOrDefault(_ => _.Key == "invoice_tmpl").Value;
                        invoice_template_id.DataBind();
                    }
                }
                else
                {
                    Response.Write("<script>window.close();</script>");
                }
            }
            catch (Exception)
            {

                Response.End();
            }
        }

        protected void process_Click(object sender, EventArgs e)
        {
            var param = AssembleModel<InvoiceDealDto>();
            param.isInvoiceEmail = is_InvoiceEmail.Checked;
            param.ids = Request.QueryString["ids"];

            var result = new InvoiceBLL().ProcessInvoice(param,GetLoginUserId());
            if (result)
            {
                // 跳转到发票预览
            }
            else
            {
                // 处理失败
            }
           
        }
    }
}