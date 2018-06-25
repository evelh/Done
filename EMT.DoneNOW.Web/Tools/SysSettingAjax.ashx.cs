using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
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
                case "GetSkillCates":
                    GetSkillCates(context);
                    break;
                case "GetDics":
                    GetDics(context);
                    break;
                case "SetQuoteEmailTmplDefault":
                    SetQuoteEmailTmplDefault();
                    break;
                case "DeleteQuoteEmailTmpl":
                    DeleteQuoteEmailTmpl();
                    break;
                case "CheckBoardName":
                    CheckBoardName(context);
                    break;
                case "UdfStatus":
                    GetUdfStatus();
                    break;
                case "UpdateUdfStatus":
                    UpdateUdfStatus();
                    break;
                case "DeleteUdf":
                    DeleteUdf();
                    break;
                case "GetCompanyImportFields":
                    GetCompanyImportFields();
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

        /// <summary>
        /// 获取技能、证书、学位类别
        /// </summary>
        /// <param name="context"></param>
        private void GetSkillCates(HttpContext context)
        {
            List<DictionaryEntryDto> list = null;
            if(context.Request.QueryString["type"]=="1")
            {
                list = new GeneralBLL().GetDicValues(GeneralTableEnum.SKILLS_CATE, (long)DicEnum.SKILLS_CATE_TYPE.SKILLS);
            }
            if (context.Request.QueryString["type"] == "2")
            {
                list = new GeneralBLL().GetDicValues(GeneralTableEnum.SKILLS_CATE, (long)DicEnum.SKILLS_CATE_TYPE.CERTIFICATION);
            }
            if (context.Request.QueryString["type"] == "3")
            {
                list = new GeneralBLL().GetDicValues(GeneralTableEnum.SKILLS_CATE, (long)DicEnum.SKILLS_CATE_TYPE.DEGREE);
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(list));
        }

        /// <summary>
        /// 获取字典项
        /// </summary>
        /// <param name="context"></param>
        private void GetDics(HttpContext context)
        {
            long tableId = long.Parse(context.Request.QueryString["id"]);
            var list = new GeneralBLL().GetDicValues(tableId);
            context.Response.Write(new Tools.Serialize().SerializeJson(list));
        }

        /// <summary>
        /// 设置邮件模板默认
        /// </summary>
        private void SetQuoteEmailTmplDefault()
        {
            WriteResponseJson(new QuoteAndInvoiceEmailTempBLL().SetDefault(long.Parse(request.QueryString["id"]), int.Parse(request.QueryString["type"]), LoginUserId));
        }

        /// <summary>
        /// 删除邮件模板
        /// </summary>
        private void DeleteQuoteEmailTmpl()
        {
            WriteResponseJson(new QuoteAndInvoiceEmailTempBLL().DeleteTmpl(long.Parse(request.QueryString["id"]), LoginUserId));
        }

        /// <summary>
        /// 查询自定义字段激活状态
        /// </summary>
        private void GetUdfStatus()
        {
            var bll = new UserDefinedFieldsBLL();
            WriteResponseJson(bll.GetUdfIsActive(long.Parse(request.QueryString["id"])));
        }

        /// <summary>
        /// 激活/取消激活自定义字段
        /// </summary>
        private void UpdateUdfStatus()
        {
            bool active = false;
            if (!string.IsNullOrEmpty(request.QueryString["active"]) && request.QueryString["active"] == "1")
                active = true;

            WriteResponseJson(new UserDefinedFieldsBLL().UpdateUdfStatus(long.Parse(request.QueryString["id"]), active, LoginUserId));
        }

        /// <summary>
        /// 删除自定义字段
        /// </summary>
        private void DeleteUdf()
        {
            WriteResponseJson(new UserDefinedFieldsBLL().DeleteUdf(long.Parse(request.QueryString["id"]), LoginUserId));
        }

        void CheckBoardName(HttpContext context)
        {
            var name = context.Request.QueryString["name"];
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                long.TryParse(context.Request.QueryString["id"],out id);
            bool result = false;
            if (!string.IsNullOrEmpty(name))
                result = new ChangeBoardBll().CheckBoardName(name,id);
            WriteResponseJson(result);
        }

        /// <summary>
        /// 获取客户导入字段
        /// </summary>
        private void GetCompanyImportFields()
        {
            WriteResponseJson(new DataImportBLL().GetCompanyImportFieldsStr());
        }
    }
}