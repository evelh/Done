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
        protected List<string> accDedIds = null;
        protected int invoiceNum = 0;
        protected Dictionary<string, object> dic = new InvoiceBLL().GetField();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var ids = Request.QueryString["account_ids"];
                if (!string.IsNullOrEmpty(ids))
                {
                     accDedIds = new List<string>();
                    var accountIDS = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var account_id in accountIDS)
                    {
                        var paramList = new crm_account_deduction_dal().GetInvDedDtoList(" and account_id=" + account_id+ " and invoice_id is null");
                        // 区分为包括 采购订单和不包括采购订单
                        if (paramList != null && paramList.Count > 0)
                        {
                            accDedIds.AddRange(paramList.Select(_=>_.id.ToString()));

                            var noPurOrderList = paramList.Where(_=>string.IsNullOrEmpty(_.purchase_order_no
                                )).ToList(); // 代表无
                            var purchOrderList = paramList.Where(_ => !string.IsNullOrEmpty(_.purchase_order_no
                               )).ToList();
                            if (noPurOrderList != null && noPurOrderList.Count > 0)
                            {

                                invoiceNum+=1;
                            }
                            if (purchOrderList != null && purchOrderList.Count > 0)
                            {
                                var poDic = purchOrderList.GroupBy(_ => _.purchase_order_no).ToDictionary(_ => _.Key, _ => _.ToList());
                                if (poDic != null && poDic.Count > 0)
                                {
                                    invoiceNum += poDic.Count;
                                }
                            }
                        }
                    }
                 
                }
            
                if (!IsPostBack)
                {
                    invoice_template_id.DataValueField = "id";
                    invoice_template_id.DataTextField = "name";
                    invoice_template_id.DataSource = dic.FirstOrDefault(_ => _.Key == "invoice_tmpl").Value;
                    invoice_template_id.DataBind();
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
            
            string ids = "";
            if (accDedIds != null&& accDedIds.Count > 0)
            {
                foreach (var item in accDedIds)
                {
                    ids += item + ',';
                }
            }
            param.ids = ids.Substring(0,ids.Length-1);

            var result = new InvoiceBLL().ProcessInvoice(param, GetLoginUserId());
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close(); </script>");
            }
            else
            {
                
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！');window.close(); </script>");
            }

        }
    }
}