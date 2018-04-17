using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// TimeoffPolicyAjax 的摘要说明
    /// </summary>
    public class TimeoffPolicyAjax : BaseAjax
    {
        TimeOffPolicyBLL bll = new TimeOffPolicyBLL();
        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "deletePolicy":
                    DeletePolicy(context);
                    break;
                case "addPolicyTier":       // 增加休假策略级别
                    AddPolicyTier(context);
                    break;
                case "editPolicyTier":       // 增加休假策略级别
                    EditPolicyTier(context);
                    break;
                case "associateResource":   // 关联员工
                    AssociateResource(context);
                    break;
                case "disassociateResource":
                    DisassociateResource(context);
                    break;
                case "deleteItemTier":
                    DeletePolicyTier(context);
                    break;
                case "getItemTierInfo":
                    GetItemTierInfo(context);
                    break;
                case "cancleRequest":
                    CancleTimeoffRequest(context);
                    break;
                case "approveRequest":
                    ApproveTimeoffRequest(context);
                    break;
                case "rejectRequest":
                    RejectTimeoffRequest(context);
                    break;
                default:
                    break;
            }
        }

        #region 休假策略
        /// <summary>
        /// 删除休假策略
        /// </summary>
        /// <param name="context"></param>
        private void DeletePolicy(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.DeletePolicy(id, LoginUserId)));
        }

        /// <summary>
        /// 增加休假策略级别
        /// </summary>
        /// <param name="context"></param>
        private void AddPolicyTier(HttpContext context)
        {
            decimal annualHours = decimal.Parse(context.Request.QueryString["annual"]);
            decimal capHours = decimal.Parse(context.Request.QueryString["cap"]);
            decimal? hoursPerPeriod = null;
            if (!string.IsNullOrEmpty(context.Request.QueryString["hoursPerPeriod"]))
                hoursPerPeriod = decimal.Parse(context.Request.QueryString["hoursPerPeriod"]);
            int startMonths = int.Parse(context.Request.QueryString["months"]);

            if (context.Request.QueryString["policyId"] == "0")
            {
                var items = context.Session["TimeoffPolicyTier"] as TimeoffPolicyTierListDto;
                if (items == null)
                    items = new TimeoffPolicyTierListDto();
                TimeoffPolicyTierDto dto = new TimeoffPolicyTierDto();
                dto.id = items.index++;
                dto.hoursPerPeriod = hoursPerPeriod;
                dto.eligibleMonths = startMonths;
                dto.cate = int.Parse(context.Request.QueryString["cate"]);
                dto.capHours = capHours;
                dto.annualHours = annualHours;
                items.items.Add(dto);
                context.Session["TimeoffPolicyTier"] = items;
                context.Response.Write(new Tools.Serialize().SerializeJson(true));
            }
            else
            {
                Core.tst_timeoff_policy_item_tier tier = new Core.tst_timeoff_policy_item_tier();
                tier.annual_hours = annualHours;
                tier.cap_hours = capHours;
                tier.timeoff_policy_item_id = long.Parse(context.Request.QueryString["itemid"]);
                tier.hours_accrued_per_period = hoursPerPeriod;
                tier.eligible_starting_months = startMonths;
                bool rtn = bll.AddTimeoffItemTier(tier, LoginUserId);
                context.Response.Write(new Tools.Serialize().SerializeJson(rtn));
            }
        }

        /// <summary>
        /// 编辑休假策略级别
        /// </summary>
        /// <param name="context"></param>
        private void EditPolicyTier(HttpContext context)
        {
            if (string.IsNullOrEmpty(context.Request.QueryString["tierId"]) || context.Request.QueryString["tierId"] == "0")    // 新增
            {
                AddPolicyTier(context);
                return;
            }

            long tierId = long.Parse(context.Request.QueryString["tierId"]);
            decimal annualHours = decimal.Parse(context.Request.QueryString["annual"]);
            decimal capHours = decimal.Parse(context.Request.QueryString["cap"]);
            decimal? hoursPerPeriod = null;
            if (!string.IsNullOrEmpty(context.Request.QueryString["hoursPerPeriod"]))
                hoursPerPeriod = decimal.Parse(context.Request.QueryString["hoursPerPeriod"]);
            int startMonths = int.Parse(context.Request.QueryString["months"]);

            if (context.Request.QueryString["policyId"] == "0")
            {
                var items = context.Session["TimeoffPolicyTier"] as TimeoffPolicyTierListDto;
                if (items == null)
                    items = new TimeoffPolicyTierListDto();
                TimeoffPolicyTierDto dto = items.items.Find(_ => _.id == tierId);
                if (dto != null)
                {
                    dto.hoursPerPeriod = hoursPerPeriod;
                    dto.eligibleMonths = startMonths;
                    dto.capHours = capHours;
                    dto.annualHours = annualHours;
                }
                context.Session["TimeoffPolicyTier"] = items;
                context.Response.Write(new Tools.Serialize().SerializeJson(true));
            }
            else
            {
                Core.tst_timeoff_policy_item_tier tier = new Core.tst_timeoff_policy_item_tier();
                tier.id = tierId;
                tier.annual_hours = annualHours;
                tier.cap_hours = capHours;
                tier.hours_accrued_per_period = hoursPerPeriod;
                tier.eligible_starting_months = startMonths;
                bool rtn = bll.EditTimeoffItemTier(tier, LoginUserId);
                context.Response.Write(new Tools.Serialize().SerializeJson(rtn));
            }
        }

        /// <summary>
        /// 删除休假策略级别
        /// </summary>
        /// <param name="context"></param>
        private void DeletePolicyTier(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            var items = context.Session["TimeoffPolicyTier"] as TimeoffPolicyTierListDto;
            if (items == null)
                context.Response.Write(new Tools.Serialize().SerializeJson(bll.DeleteTimeoffItemTier(id, LoginUserId)));
            else
            {
                var tr = items.items.Find(_ => _.id == id);
                if (tr == null)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(bll.DeleteTimeoffItemTier(id, LoginUserId)));
                }
                else
                {
                    items.items.Remove(tr);
                    context.Response.Write(new Tools.Serialize().SerializeJson(true));
                }
            }
        }

        /// <summary>
        /// 获取策略级别信息
        /// </summary>
        /// <param name="context"></param>
        private void GetItemTierInfo(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            var items = context.Session["TimeoffPolicyTier"] as TimeoffPolicyTierListDto;
            Core.tst_timeoff_policy_item_tier tier = null;
            TimeoffPolicyTierDto dto = null;
            if (items == null)
                tier = bll.GetTimeoffItemTier(id);
            else
            {
                var tr = items.items.Find(_ => _.id == id);
                if (tr == null)
                {
                    tier = bll.GetTimeoffItemTier(id);
                }
                else
                {
                    dto = tr;
                }
            }
            if (tier != null)
            {
                dto = new TimeoffPolicyTierDto
                {
                    annualHours = tier.annual_hours.Value,
                    capHours = tier.cap_hours.Value,
                    eligibleMonths = tier.eligible_starting_months,
                    hoursPerPeriod = tier.hours_accrued_per_period,
                    id = tier.id,
                    cate = bll.GetTimeoffItem(tier.timeoff_policy_item_id).cate_id
                };
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(dto));
        }

        /// <summary>
        /// 关联员工
        /// </summary>
        /// <param name="context"></param>
        private void AssociateResource(HttpContext context)
        {
            if (context.Request.QueryString["policyId"] == "0")
            {
                var items = context.Session["TimeoffAssRes"] as TimeoffAssociateResourceDto;
                if (items == null)
                    items = new TimeoffAssociateResourceDto();
                TimeoffResourceTierDto dto = new TimeoffResourceTierDto();
                dto.id = items.index++;
                dto.resourceId = context.Request.QueryString["resIds"];
                dto.resourceName = context.Request.QueryString["resNames"];
                dto.effBeginDate = DateTime.Parse(context.Request.QueryString["beginDate"]);
                dto.effEndDate = null;

                items.items.Add(dto);
                context.Session["TimeoffAssRes"] = items;
                context.Response.Write(new Tools.Serialize().SerializeJson(true));
            }
            else
            {
                bool rtn = bll.AddTimeoffResource(context.Request.QueryString["resIds"], long.Parse(context.Request.QueryString["policyId"]), DateTime.Parse(context.Request.QueryString["beginDate"]), LoginUserId);
                context.Response.Write(new Tools.Serialize().SerializeJson(rtn));
            }
        }

        /// <summary>
        /// 取消关联员工
        /// </summary>
        /// <param name="context"></param>
        private void DisassociateResource(HttpContext context)
        {
            var items = context.Session["TimeoffAssRes"] as TimeoffAssociateResourceDto;
            if (items == null)
                context.Response.Write(new Tools.Serialize().SerializeJson(bll.DeleteTimeoffResource(long.Parse(context.Request.QueryString["id"]), LoginUserId)));
            else
            {
                long id = long.Parse(context.Request.QueryString["id"]);
                var tr = items.items.Find(_ => _.id == id);
                if (tr == null)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(bll.DeleteTimeoffResource(id, LoginUserId)));
                }
                else
                {
                    items.items.Remove(tr);
                    context.Response.Write(new Tools.Serialize().SerializeJson(true));
                }
            }
        }
        #endregion


        #region 休假请求
        /// <summary>
        /// 取消休假请求
        /// </summary>
        /// <param name="context"></param>
        private void CancleTimeoffRequest(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.CancleTimeoffRequest(id, LoginUserId)));
        }

        /// <summary>
        /// 审批批准休假请求
        /// </summary>
        /// <param name="context"></param>
        private void ApproveTimeoffRequest(HttpContext context)
        {
            string ids = context.Request.QueryString["ids"];
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.ApproveTimeoffRequest(ids, LoginUserId)));
        }

        /// <summary>
        /// 审批拒绝休假请求
        /// </summary>
        /// <param name="context"></param>
        private void RejectTimeoffRequest(HttpContext context)
        {
            string ids = context.Request.QueryString["ids"];
            string reason = context.Request.QueryString["reason"];
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.RejectTimeoffRequest(ids, reason, LoginUserId)));
        }

        #endregion
    }
}