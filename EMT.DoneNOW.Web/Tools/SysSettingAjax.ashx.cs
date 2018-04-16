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
    }
}