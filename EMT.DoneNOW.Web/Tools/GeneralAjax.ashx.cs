using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// GeneralAjax 的摘要说明
    /// </summary>
    public class GeneralAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "general":
                        var general_id = context.Request.QueryString["id"];
                        GetGeneralInfo(context, long.Parse(general_id));
                        break;
                    case "GetTaxSum":
                        var accDedIds = context.Request.QueryString["ids"];
                        var tax_id = context.Request.QueryString["taxId"];
                        GetTaxSum(context, long.Parse(tax_id), accDedIds);
                        break;
                    case "GetNotiTempEmail":
                        var notiTempId = context.Request.QueryString["temp_id"];
                        GetNotiTempEmail(context,long.Parse(notiTempId));
                        break;
                    case "costCodeRule":
                        var cosId = context.Request.QueryString["code_id"];
                        GetSinCodeRule(context,long.Parse(cosId));
                        break;
                    case "GetCostCodeByType":
                        var cosTypeId = context.Request.QueryString["type_id"];
                        GetCostCodeByType(context,int.Parse(cosTypeId));
                        break;
                    case "GetGenListByTableId":
                        var ggTableId = context.Request.QueryString["table_id"];
                        GetGenListByTableId(context,int.Parse(ggTableId));
                        break;
                    case "GetGeneralByParentId":
                        var pId = context.Request.QueryString["parent_id"];
                        GetGeneralByParentId(context,long.Parse(pId));
                        break;
                    case "GetSysSetting":
                        GetSysSetting(context);
                        break;
                    case "DeleteHolidaySet":
                        DeleteHolidaySet(context);
                        break;
                    case "DeleteHoliday":
                        DeleteHoliday(context);
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



        private void GetGeneralInfo(HttpContext context, long id)
        {
            var general = new d_general_dal().GetGeneralById(id);
            if (general != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(general));
            }
        }
        /// <summary>
        ///  根据税区和条目税种计算税额
        /// </summary>
        private void GetTaxSum(HttpContext context, long tax_id, string accDedIds)
        {
            if (tax_id == 0 || string.IsNullOrEmpty(accDedIds))
            {
                context.Response.Write("0.00");
                return;
            }

            decimal totalMoney = 0;
            // 所有需要计算的条目的Id的集合
            var accDedIdList = accDedIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            if (accDedIdList != null && accDedIdList.Count() > 0)
            {
                var adDal = new crm_account_deduction_dal();
                foreach (var accDedId in accDedIdList)
                {
                    var accDedList = adDal.GetInvDedDtoList($" and id={accDedId}");
                    var thisAccDed = adDal.FindNoDeleteById(long.Parse(accDedId));
                    if (accDedList != null && accDedList.Count > 0)
                    {
                        var accDed = accDedList.FirstOrDefault(_ => _.id.ToString() == accDedId);
                        if (accDed.tax_category_id != null)
                        {
                            var thisTax = new d_tax_region_cate_dal().GetSingleTax(tax_id, (long)accDed.tax_category_id);
                            if (thisTax != null && thisAccDed.extended_price != null)
                            {
                                totalMoney += (decimal)(thisAccDed.extended_price * thisTax.total_effective_tax_rate);
                            }
                        }
                    }
                }
            }
            context.Response.Write(totalMoney.ToString("#0.00"));

        }
        /// <summary>
        /// 根据通知模板获取相关模板邮件信息
        /// </summary>
        private void GetNotiTempEmail(HttpContext context, long temp_id)
        {

            var tempEmailList = new sys_notify_tmpl_email_dal().GetEmailByTempId(temp_id);
            if (tempEmailList != null&& tempEmailList.Count>0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(tempEmailList[0]));
            }
        }
        /// <summary>
        /// 获取到费用规则信息
        /// </summary>
        private void GetSinCodeRule(HttpContext context,long code_rule_id)
        {
            var codeRule = new d_cost_code_rule_dal().GetRuleByCodeId(code_rule_id);
            if (codeRule != null&& codeRule.Count>0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(codeRule[0]));
            }

        }
        /// <summary>
        /// 根据类型获取相应的物料代码
        /// </summary>
        private void GetCostCodeByType(HttpContext context,int type_id)
        {
            var codeList = new d_cost_code_dal().GetListCostCode(type_id);
            if (codeList != null && codeList.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(codeList));
            }
        }
        /// <summary>
        /// 根据字典表ID 获取相应信息
        /// </summary>
        private void GetGenListByTableId(HttpContext context, int table_id)
        {
            var genList = new d_general_dal().GetGeneralByTableId(table_id);
            if (genList != null && genList.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(genList));
            }
        }
        /// <summary>
        /// 根据父ID 获取相应信息
        /// </summary>
        private void GetGeneralByParentId(HttpContext context, long parent_id)
        {
            var genList = new d_general_dal().GetGeneralByParentId(parent_id);
            if (genList != null && genList.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(genList));
            }
        }
        /// <summary>
        /// 获取到系统设置信息
        /// </summary>
        private void GetSysSetting(HttpContext context)
        {
            var sysId = context.Request.QueryString["sys_id"];
            if (!string.IsNullOrEmpty(sysId))
            {
                var thisSet = new sys_system_setting_dal().FindById(long.Parse(sysId));
                if (thisSet != null)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(thisSet));
                }
            }
        }

        /// <summary>
        /// 删除节假日设置
        /// </summary>
        /// <param name="context"></param>
        private void DeleteHolidaySet(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new GeneralBLL().DeleteHolidaySet(id,LoginUserId)));
        }

        /// <summary>
        /// 删除节假日详情
        /// </summary>
        /// <param name="context"></param>
        private void DeleteHoliday(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(new GeneralBLL().DeleteHoliday(id, LoginUserId)));
        }
    }
}