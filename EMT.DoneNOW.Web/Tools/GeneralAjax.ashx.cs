﻿using System;
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
                    case "DeleteSkillFromGeneral":
                        DeleteSkillFromGeneral(context);
                        break;
                    case "ActiveGeneral":
                        ActiveGeneral(context);
                        break; 
                    case "DeleteTicketSubIssue":
                        DeleteTicketSubIssue(context);
                        break;
                    case "ActiveBoard":
                        ActiveBoard(context);
                        break;
                    case "DeleteBoard":
                        DeleteBoard(context);
                        break;
                    case "BoardInfo":
                        BoardInfo(context);
                        break;
                    case "ActiveCheckLib":
                        ActiveCheckLib(context);
                        break;
                    case "DeleteCheckLib":
                        DeleteCheckLib(context);
                        break;
                    case "CheckLibInfo":
                        CheckLibInfo(context);
                        break;
                    case "CopyCheckLib":
                        CopyCheckLib(context);
                        break;
                    case "TaxRegionDeleteCheck":
                        TaxRegionDeleteCheck(context);
                        break;
                    case "TaxCateDeleteCheck":
                        TaxCateDeleteCheck(context);
                        break; 
                    case "CheckExist":
                        CheckExist(context);
                        break;
                    case "CheckRegionCate":
                        CheckRegionCate(context);
                        break;
                    case "CheckRegionCateTax":
                        CheckRegionCateTax(context);
                        break;
                    case "DeleteRegion":
                        DeleteRegion(context);
                        break;
                    case "DeleteRegionTax":
                        DeleteRegionTax(context);
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
        /// <summary>
        /// 删除技能/证书/学位 相关字典表
        /// </summary>
        void DeleteSkillFromGeneral(HttpContext context)
        {
            bool result = false;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                result = new GeneralBLL().DeleteResourceGeneral(long.Parse(context.Request.QueryString["id"]),LoginUserId);
            WriteResponseJson(result);

        }

        void ActiveGeneral(HttpContext context)
        {
            bool result = false;
            bool isAvtive = false;
            if (!string.IsNullOrEmpty(context.Request.QueryString["isActive"]) && context.Request.QueryString["isActive"] == "1")
                isAvtive = true;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"])&&long.TryParse(context.Request.QueryString["id"],out id))
            {
                var resType = DTO.ERROR_CODE.ERROR;
                if (isAvtive)
                    resType = new GeneralBLL().Active(id,LoginUserId);
                else
                    resType = new GeneralBLL().NoActive(id, LoginUserId);
                if(resType== DTO.ERROR_CODE.SUCCESS)
                    result = true;
            }
            WriteResponseJson(result);
        }
        /// <summary>
        /// 删除工单子问题校验
        /// </summary>
        void DeleteTicketSubIssue(HttpContext context)
        {
            bool result = false;
            string reason = string.Empty;
            if (!string.IsNullOrEmpty(context.Request.QueryString["ids"]))
                result = new GeneralBLL().DeleteGeneralSubIssue(context.Request.QueryString["ids"],LoginUserId,ref reason);
            WriteResponseJson(new {result= result, reason=reason });
        }


        /// <summary>
        /// 激活/失活 变更委员会
        /// </summary>
        void ActiveBoard(HttpContext context)
        {
            bool result = false;
            bool isAvtive = false;
            if (!string.IsNullOrEmpty(context.Request.QueryString["isActive"]) && context.Request.QueryString["isActive"] == "1")
                isAvtive = true;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = new ChangeBoardBll().ActivBoard(id, LoginUserId, isAvtive);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 删除变更委员会
        /// </summary>
        void DeleteBoard(HttpContext context)
        {
            bool result = false;
            string reason = string.Empty;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = new ChangeBoardBll().DeleteBoard(id, LoginUserId, ref reason);
            WriteResponseJson(new { result = result, reason = reason });
        }
        /// <summary>
        /// 获取变更委员会相关内同
        /// </summary>
        void BoardInfo(HttpContext context)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
            {
                d_change_board board = new ChangeBoardBll().GetBoard(id);
                if (board != null)
                    WriteResponseJson(board);
            }
        }





        /// <summary>
        /// 激活/失活 检查单库
        /// </summary>
        void ActiveCheckLib(HttpContext context)
        {
            bool result = false;
            bool isAvtive = false;
            if (!string.IsNullOrEmpty(context.Request.QueryString["isActive"]) && context.Request.QueryString["isActive"] == "1")
                isAvtive = true;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = new CheckListBLL().ActivLib(id, LoginUserId, isAvtive);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 删除检查单库
        /// </summary>
        void DeleteCheckLib(HttpContext context)
        {
            bool result = false;
            string reason = string.Empty;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = new CheckListBLL().DeleteBoard(id, LoginUserId, ref reason);
            WriteResponseJson(new { result = result, reason = reason });
        }
        /// <summary>
        /// 复制检查单库
        /// </summary>
        void CopyCheckLib(HttpContext context)
        {
            bool result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = new CheckListBLL().CopyLib(id, LoginUserId);
            WriteResponseJson( result);
        }
        /// <summary>
        /// 获取检查单库
        /// </summary>
        void CheckLibInfo(HttpContext context)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
            {
                sys_checklist_lib lib = new CheckListBLL().GetLib(id);
                if (lib != null)
                    WriteResponseJson(lib);
            }
        }
        /// <summary>
        /// 税区删除校验
        /// </summary>
        void TaxRegionDeleteCheck(HttpContext context)
        {
            bool result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = new GeneralBLL().CheckTaxRegionDelete(id);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 税种删除校验
        /// </summary>
        void TaxCateDeleteCheck(HttpContext context)
        {
            bool result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = new GeneralBLL().CheckTaxCateDelete(id);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 校验名称重复
        /// </summary>
        void CheckExist(HttpContext context)
        {
            bool result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                long.TryParse(context.Request.QueryString["id"],out id);
            if (!string.IsNullOrEmpty(context.Request.QueryString["tableId"]) && !string.IsNullOrEmpty(context.Request.QueryString["name"]))
                result = new GeneralBLL().CheckExist(context.Request.QueryString["name"],int.Parse(context.Request.QueryString["tableId"]),id);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 校验税收类型是否重复
        /// </summary>
        void CheckRegionCate(HttpContext context)
        {
            bool result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                long.TryParse(context.Request.QueryString["id"], out id);
            long regionId = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["regionId"]))
                long.TryParse(context.Request.QueryString["regionId"], out regionId);
            long cateId = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["cateId"]))
                long.TryParse(context.Request.QueryString["cateId"], out cateId);
            if (cateId != 0 && regionId != 0)
                result = new GeneralBLL().CheckRegionCate(regionId,cateId,id);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 校验税收类型分税名称  是否重复
        /// </summary>
        void CheckRegionCateTax(HttpContext context)
        {
            bool result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                long.TryParse(context.Request.QueryString["id"], out id);
            long regionCateId = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["regionCateId"]))
                long.TryParse(context.Request.QueryString["regionCateId"], out regionCateId);
            if (regionCateId != 0 && !string.IsNullOrEmpty(context.Request.QueryString["name"]))
                result = new GeneralBLL().CheckCateTax(regionCateId, context.Request.QueryString["name"], id);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 删除税收种类
        /// </summary>
        void DeleteRegion(HttpContext context)
        {
            bool result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = new GeneralBLL().DeleteRegion(id,LoginUserId);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 删除分税
        /// </summary>
        void DeleteRegionTax(HttpContext context)
        {
            bool result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = new GeneralBLL().DeleteRegionTax(id, LoginUserId);
            WriteResponseJson(result);
        }
    }
}