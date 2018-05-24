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

    
    }
}