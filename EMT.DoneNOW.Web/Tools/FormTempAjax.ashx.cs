using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// FormTempAjax 的摘要说明
    /// </summary>
    public class FormTempAjax : BaseAjax
    {
        private FormTemplateBLL tempBll = new FormTemplateBLL();
        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "CheckTempCode":
                    CheckTempCode(context);
                    break;
                case "ActiveTmpl":
                    ActiveTmpl(context);
                    break;
                case "GetTemp":
                    GetTemp(context);
                    break;
                case "DeleteTmpl":
                    DeleteTmpl(context);
                    break;
                case "GetTempObj":
                    GetTempObj(context);
                    break;
                default:break;
            }
        }
        /// <summary>
        /// 校验快速代码 是否重复
        /// </summary>
        public void CheckTempCode(HttpContext context)
        {
            var code = context.Request.QueryString["code"];
            var result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                long.TryParse(context.Request.QueryString["id"],out id);
            if (!string.IsNullOrEmpty(code))
                result = tempBll.CheckTempCode(code,id);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }

        /// <summary>
        ///  激活/失活 模板
        /// </summary>
        public void ActiveTmpl(HttpContext context)
        {
            var id = context.Request.QueryString["id"];
            var result = false;
            bool isActive = false;
            if (!string.IsNullOrEmpty(context.Request.QueryString["active"]))
                isActive = true;
            if (!string.IsNullOrEmpty(id))
                result = tempBll.ActiveTmpl(long.Parse(id), isActive,LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 获取模板信息
        /// </summary>
        public void GetTemp(HttpContext context)
        {
            var id = context.Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
            {
                var thisTemp = tempBll.GetTempById(long.Parse(id));
                if(thisTemp!=null)
                    context.Response.Write(new EMT.Tools.Serialize().SerializeJson(thisTemp));
            }
        }

        /// <summary>
        ///  删除 模板
        /// </summary>
        public void DeleteTmpl(HttpContext context)
        {
            var id = context.Request.QueryString["id"];
            var result = false;
            if (!string.IsNullOrEmpty(id))
                result = tempBll.DeleteTmpl(long.Parse(id), LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 获取模板关联的相关对象
        /// </summary>
        public void GetTempObj(HttpContext context)
        {
            long id = 0;
            if(!string.IsNullOrEmpty(context.Request.QueryString["id"])&&long.TryParse(context.Request.QueryString["id"],out id))
            {
                var thisTmpl = tempBll.GetTempById(id);
                switch (thisTmpl.form_type_id)
                {
                    case (int)DTO.DicEnum.FORM_TMPL_TYPE.OPPORTUNITY:
                        var thisOppoTmpl = tempBll.GetOpportunityTmpl(thisTmpl.id);
                        if (thisOppoTmpl != null)
                            WriteResponseJson(thisOppoTmpl);
                        break;
                    case (int)DTO.DicEnum.FORM_TMPL_TYPE.PROJECT_NOTE:
                    case (int)DTO.DicEnum.FORM_TMPL_TYPE.TASK_NOTE:
                    case (int)DTO.DicEnum.FORM_TMPL_TYPE.TICKET_NOTE:
                        var thisNote = tempBll.GetNoteTmpl(thisTmpl.id);
                        if (thisNote != null)
                            WriteResponseJson(thisNote);
                        break;
                    case (int)DTO.DicEnum.FORM_TMPL_TYPE.QUICK_CALL:
                        var thisQuickCallTmpl = tempBll.GetQuickCallTmpl(thisTmpl.id);
                        if (thisQuickCallTmpl != null)
                            WriteResponseJson(thisQuickCallTmpl);
                        break;
                    case (int)DTO.DicEnum.FORM_TMPL_TYPE.QUOTE:
                        var thisQuoteTmpl = tempBll.GetQuoteTmpl(thisTmpl.id);
                        if (thisQuoteTmpl != null)
                            WriteResponseJson(thisQuoteTmpl);
                        break;
                    case (int)DTO.DicEnum.FORM_TMPL_TYPE.RECURRING_TICKET:
                        var thisRecTicketTmpl = tempBll.GetRecTicketTmpl(thisTmpl.id);
                        if (thisRecTicketTmpl != null)
                            WriteResponseJson(thisRecTicketTmpl);
                        break;
                    case (int)DTO.DicEnum.FORM_TMPL_TYPE.SERVICE_CALL:
                        var thisServiceCallTmpl = tempBll.GetServiceCallTmpl(thisTmpl.id);
                        if (thisServiceCallTmpl != null)
                            WriteResponseJson(thisServiceCallTmpl);
                        break;
                    case (int)DTO.DicEnum.FORM_TMPL_TYPE.TASK_TIME_ENTRY:
                    case (int)DTO.DicEnum.FORM_TMPL_TYPE.TICKET_TIME_ENTRY:
                        var thisEntryTmpl = tempBll.GetWorkEntryTmpl(thisTmpl.id);
                        if (thisEntryTmpl != null)
                            WriteResponseJson(thisEntryTmpl);
                        break;
                    case (int)DTO.DicEnum.FORM_TMPL_TYPE.TICKET:
                        var thisTicketTmpl = tempBll.GetTicketTmpl(thisTmpl.id);
                        if (thisTicketTmpl != null)
                            WriteResponseJson(thisTicketTmpl);
                        break;
                    default:
                        break;
                }
            }
            
        }

        



    }
}