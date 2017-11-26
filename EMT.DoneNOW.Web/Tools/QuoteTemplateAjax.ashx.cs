using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.Tools.Date;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// QuoteTemplateAjax 的摘要说明
    /// </summary>
    public class QuoteTemplateAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                var QuoteTemp_id = context.Request.QueryString["id"];
                switch (action)
                {
                    case "delete":
                        DeleteQuoteTemplate(context, long.Parse(QuoteTemp_id));
                        break;
                    case "deleteInvoiceTmpl":
                        DeleteInvoiceTemplate(context, long.Parse(QuoteTemp_id));
                        break;
                    case "default":
                        DefaultQuoteTemplate(context, long.Parse(QuoteTemp_id));
                        break;
                    case "defaultInvoiceTmpl":
                        DefaultInvoiceTemplate(context, long.Parse(QuoteTemp_id));
                        break;
                    case "active":
                        ActiveQuoteTemplate(context, long.Parse(QuoteTemp_id));
                        break;
                    case "activeInvoiceTmpl":
                        ActiveInvoiceTemplate(context, long.Parse(QuoteTemp_id));
                        break;
                    case "noactive":
                        NOActiveQuoteTemplate(context, long.Parse(QuoteTemp_id));
                        break;
                    case "noactiveInvoiceTmpl":
                        NoActiveInvoiceTemplate(context, long.Parse(QuoteTemp_id));
                        break;
                    case "copy":
                        CopyQuoteTemplate(context, long.Parse(QuoteTemp_id));
                        break;
                    case "copyInvoiceTmpl":
                        CopyInvoiceTemplate(context, long.Parse(QuoteTemp_id));
                        break;
                    default:
                        break;
                }
            }
            catch (Exception e)
            {
                context.Response.Write(e.Message);
                context.Response.End();

            }
        }
        public void DeleteQuoteTemplate(HttpContext context, long QuoteTemp_id)
        {
             
                if (new QuoteTemplateBLL().quote_template_delete(LoginUserId, QuoteTemp_id)==DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("删除报价模板成功！");
                }
                else
                {
                    context.Response.Write("删除报价模板失败！");
                }
             
        }

        /// <summary>
        /// 删除发票模板
        /// </summary>
        /// <param name="context"></param>
        /// <param name="invoiceTmplId"></param>
        public void DeleteInvoiceTemplate(HttpContext context, long invoiceTmplId)
        {
            if (new QuoteTemplateBLL().quote_template_delete(LoginUserId, invoiceTmplId) == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("删除发票模板成功！");
            }
            else
            {
                context.Response.Write("删除发票模板失败！");
            }
        }

        public void CopyQuoteTemplate(HttpContext context, long QuoteTemp_id)
        {
             
                if (new QuoteTemplateBLL().copy_quote_template(LoginUserId, ref QuoteTemp_id) == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write(QuoteTemp_id);
                }
                else
                {
                    context.Response.Write("error");
                }
          
        }

        /// <summary>
        /// 复制发票模板
        /// </summary>
        /// <param name="context"></param>
        /// <param name="invoiceTmplId"></param>
        public void CopyInvoiceTemplate(HttpContext context, long invoiceTmplId)
        {
            if (new QuoteTemplateBLL().copy_quote_template(LoginUserId, ref invoiceTmplId) == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write(invoiceTmplId);
            }
            else
            {
                context.Response.Write("error");
            }
        }

        public void DefaultQuoteTemplate(HttpContext context, long QuoteTemp_id)
        {
             
                var result = new QuoteTemplateBLL().default_quote_template(LoginUserId, QuoteTemp_id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("设为默认报价模板成功！");
                }
                else
               if (result == DTO.ERROR_CODE.DEFAULT)
                {
                    context.Response.Write("已经是默认状态，无需再操作！");
                }
                else {
                    context.Response.Write("设为默认报价模板失败！");
                }
             
        }

        /// <summary>
        /// 设置发票模板为默认
        /// </summary>
        /// <param name="context"></param>
        /// <param name="invoiceTmplId"></param>
        public void DefaultInvoiceTemplate(HttpContext context, long invoiceTmplId)
        {
            var result = new QuoteTemplateBLL().default_quote_template(LoginUserId, invoiceTmplId);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("设为默认发票模板成功！");
            }
            else if (result == DTO.ERROR_CODE.DEFAULT)
            {
                context.Response.Write("已经是默认状态，无需再操作！");
            }
            else
            {
                context.Response.Write("设为默认发票模板失败！");
            }

        }

        public void ActiveQuoteTemplate(HttpContext context, long QuoteTemp_id)
        {
             
                var result = new QuoteTemplateBLL().active_quote_template(LoginUserId, QuoteTemp_id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("设为激活状态报价模板成功！");
                }
                else if (result == DTO.ERROR_CODE.ACTIVATION)
                {
                    context.Response.Write("已经是激活状态，无需再操作！");
                }
                else {
                    context.Response.Write("设为激活状态报价模板失败！");
                }
            
        }

        /// <summary>
        /// 激活发票模板
        /// </summary>
        /// <param name="context"></param>
        /// <param name="invoiceTmplId"></param>
        public void ActiveInvoiceTemplate(HttpContext context, long invoiceTmplId)
        {
            var result = new QuoteTemplateBLL().active_quote_template(LoginUserId, invoiceTmplId);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("设为激活状态发票模板成功！");
            }
            else if (result == DTO.ERROR_CODE.ACTIVATION)
            {
                context.Response.Write("已经是激活状态，无需再操作！");
            }
            else
            {
                context.Response.Write("设为激活状态发票模板失败！");
            }

        }

        public void NOActiveQuoteTemplate(HttpContext context, long QuoteTemp_id)
        {
             
                var result = new QuoteTemplateBLL().no_active_quote_template(LoginUserId, QuoteTemp_id);
                if (result==DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("设为停用状态报价模板成功！");
                }
                else if(result==DTO.ERROR_CODE.NO_ACTIVATION)
                {
                    context.Response.Write("已经是停用状态，无需再操作！");
                }
                else {
                    context.Response.Write("设为停用状态报价模板失败！");
                }
           
        }

        /// <summary>
        /// 停用发票模板
        /// </summary>
        /// <param name="context"></param>
        /// <param name="invoiceTmplId"></param>
        public void NoActiveInvoiceTemplate(HttpContext context, long invoiceTmplId)
        {
            var result = new QuoteTemplateBLL().no_active_quote_template(LoginUserId, invoiceTmplId);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("设为停用状态发票模板成功！");
            }
            else if (result == DTO.ERROR_CODE.NO_ACTIVATION)
            {
                context.Response.Write("已经是停用状态，无需再操作！");
            }
            else
            {
                context.Response.Write("设为停用状态发票模板失败！");
            }
        }



    }
}