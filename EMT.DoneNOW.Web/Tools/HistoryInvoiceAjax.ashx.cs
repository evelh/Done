using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// HistoryInvoiceAjax 的摘要说明
    /// </summary>
    public class HistoryInvoiceAjax : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var id = Convert.ToInt32(context.Request.QueryString["id"]);
            switch (action)
            {
                case "voidone": VoidOne(context,id); break;
                case "voidbatch": VoidBatch(context, id); break;
                case "voidunpost": VoidUnpost(context, id); break;
                default:break;
            }
         }
        /// <summary>
        /// 作废单张发票
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void VoidOne(HttpContext context, int id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                if (new InvoiceBLL().VoidInvoice(id, res.id))
                {
                    context.Response.Write("发票作废成功！");
                }
                else {
                    context.Response.Write("发票作废失败！");
                }
            }
        }
        /// <summary>
        /// 作废这个批次发票
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void VoidBatch(HttpContext context, int id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                if (new InvoiceBLL().VoidBatchInvoice(id, res.id))
                {
                    context.Response.Write("本批次发票作废成功！");
                }
                else
                {
                    context.Response.Write("本批次发票作废失败！");
                }
            }
        }
        /// <summary>
        /// 作废单个发票并撤销审批
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void VoidUnpost(HttpContext context, int id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                if (new InvoiceBLL().VoidInvoiceAndUnPost(id, res.id))
                {
                    context.Response.Write("发票作废并撤销审核成功！");
                }
                else
                {
                    context.Response.Write("发票作废并撤销审核失败！");
                }
            }
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}