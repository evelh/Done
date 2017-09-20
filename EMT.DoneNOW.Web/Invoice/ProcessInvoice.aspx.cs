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
                var ids = Request.QueryString["ids"];
                if (!string.IsNullOrEmpty(ids))
                {
                    idList = ids.Split(new char[] {',' }, StringSplitOptions.RemoveEmptyEntries);
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