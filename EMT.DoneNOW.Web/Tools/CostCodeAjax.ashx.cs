using System;
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
                case "GetCodeByIds": GetCodeByIds(context); break;            // 根据Id 获取相关的代码
                case "ExcludeContract": ExcludeContract(context); break;            // 从新合同中排除工作类型
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

        void GetCodeByIds(HttpContext context)
        {
            string ids = context.Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(ids))
            {
                var codeList = codeBll.GetCodeByIds(ids);
                if (codeList != null && codeList.Count > 0)
                {
                    WriteResponseJson(codeList);
                }
            }
        }
        /// <summary>
        /// 工作类型用，为全部的未过期的合同，添加一个例外因素
        /// </summary>
        void ExcludeContract(HttpContext context)
        {
            bool result = false;
            long id =0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = codeBll.ExcludeContract(id,LoginUserId);
            WriteResponseJson(result);
        }
    }
}