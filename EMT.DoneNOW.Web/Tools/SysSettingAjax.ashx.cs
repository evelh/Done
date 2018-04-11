using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// SysSettingAjax 的摘要说明
    /// </summary>
    public class SysSettingAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "ChangeSetValue":
                    ChangeSetValue(context);
                    break;
                default:
                    break;
            }
        }
        /// <summary>
        /// 改变系统设置的某个值
        /// </summary>
        private void ChangeSetValue(HttpContext context)
        {
            var settValue = context.Request.QueryString["setValue"];
            var settId = context.Request.QueryString["setId"];
            var result = false;
            if (!string.IsNullOrEmpty(settId))
            {
                result = true;
                new BLL.SysSettingBLL().ChangeSetValue(long.Parse(settId), settValue,LoginUserId);
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }



    }
}