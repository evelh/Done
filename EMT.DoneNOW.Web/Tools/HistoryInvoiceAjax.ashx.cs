using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// HistoryInvoiceAjax 的摘要说明
    /// </summary>
    public class HistoryInvoiceAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var id = Convert.ToInt32(context.Request.QueryString["id"]);
            switch (action)
            {
                case "voidone": VoidOne(context, id); break;
                case "voidbatch": VoidBatch(context, id); break;
                case "voidunpost": VoidUnpost(context, id); break;
                case "getaccount_id": GetAccount_id(context, id); break;
                case "getbatch_id": GetBatch_id(context, id); break;

                default: break;
            }
        }
        public void GetAccount_id(HttpContext context, int id)
        {
            int a_id = new InvoiceBLL().GetAccount_id(id);
            if (a_id > 0)
            {
                context.Response.Write(a_id);
            }
            else
            {
                context.Response.Write("-1");
            }
        }
        public void GetBatch_id(HttpContext context, int id)
        {
            int a_id = new InvoiceBLL().GetBatch_id(id);
            if (a_id > 0)
            {
                context.Response.Write(a_id);
            }
            else
            {
                context.Response.Write("-1");
            }
        }
        /// <summary>
        /// 作废单张发票
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void VoidOne(HttpContext context, int id)
        {

            if (new InvoiceBLL().VoidInvoice(id, LoginUserId))
            {
                context.Response.Write("发票作废成功！");
            }
            else
            {
                context.Response.Write("发票作废失败！");
            }

        }
        /// <summary>
        /// 作废这个批次发票
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void VoidBatch(HttpContext context, int id)
        {

            if (new InvoiceBLL().VoidBatchInvoice(id, LoginUserId))
            {
                context.Response.Write("本批次发票作废成功！");
            }
            else
            {
                context.Response.Write("本批次发票作废失败！");
            }

        }
        /// <summary>
        /// 作废单个发票并撤销审批
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void VoidUnpost(HttpContext context, int id)
        {

            if (new InvoiceBLL().VoidInvoiceAndUnPost(id, LoginUserId))
            {
                context.Response.Write("发票作废并撤销审核成功！");
            }
            else
            {
                context.Response.Write("发票作废并撤销审核失败！");
            }

        }

    }
}