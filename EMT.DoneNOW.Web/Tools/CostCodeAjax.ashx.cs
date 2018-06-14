﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// CostCodeAjax 的摘要说明
    /// </summary>
    public class CostCodeAjax : BaseAjax
    {
        protected CostCodeBLL codeBll = new CostCodeBLL();
        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "CheckName": CheckName(context);break;               // 校验成本代码名称是否重复（同一种类下）
                case "CheckCodeDelete": CheckCodeDelete(context); break;  // 校验成本代码是否可以删除
                case "DeleteCode": DeleteCode(context); break;            // 删除成本代码
                case "ChangeCodeLedger": ChangeCodeLedger(context); break;            // 修改物料代码的总账代码
                    
                default:break;
            }
        }
        /// <summary>
        /// 校验名称
        /// </summary>
        void CheckName(HttpContext context)
        {
            var result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                long.TryParse(context.Request.QueryString["id"],out id);
            if (!string.IsNullOrEmpty(context.Request.QueryString["name"]) && !string.IsNullOrEmpty(context.Request.QueryString["cateId"]))
                result = codeBll.CheckCodeName(context.Request.QueryString["name"],long.Parse(context.Request.QueryString["cateId"]),id);
            WriteResponseJson(result);

        }
        /// <summary>
        /// 校验物料代码是否可以删除
        /// </summary>
        void CheckCodeDelete(HttpContext context)
        {
            var result = false;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                result = codeBll.DeleteCodeCheck(long.Parse(context.Request.QueryString["id"]));
            WriteResponseJson(result);

        }
        /// <summary>
        /// 删除物料代码 - 直接删除不做检验
        /// </summary>
        void DeleteCode(HttpContext context)
        {
            var result = false;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                result = codeBll.DeleteCode(long.Parse(context.Request.QueryString["id"]),LoginUserId);
            WriteResponseJson(result);
        }

        /// <summary>
        /// 修改工作类型的总账代码
        /// </summary>
        void ChangeCodeLedger(HttpContext context)
        {
            var result = false;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
            {
                var code = codeBll.GetCodeById(long.Parse(context.Request.QueryString["id"]));
                if(!string.IsNullOrEmpty(context.Request.QueryString["ledId"])&& code != null)
                {
                    code.general_ledger_id = int.Parse(context.Request.QueryString["ledId"]);
                    result = codeBll.EditCode(code,LoginUserId);
                }
            }
            WriteResponseJson(result);
        }

        

    }
}