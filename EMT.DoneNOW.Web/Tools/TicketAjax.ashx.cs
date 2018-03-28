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
    /// TicketAjax 的摘要说明
    /// </summary>
    public class TicketAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "CheckContractPurchaseOrder":
                        CheckContractPurchaseOrder(context);
                        break;
                    case "GetTicket":
                        GetTicket(context);
                        break;
                    case "property":
                        GetTicketProperty(context);
                        break;
                    case "ChangeCheckComplete":
                        ChangeCheckComplete(context);
                        break;
                    case "GetCheckInfo":
                        GetCheckInfo(context);
                        break;
                    case "GetTicketAlert":
                        GetTicketAlert(context);
                        break;
                    case "DeleteTicket":
                        DeleteTicket(context);
                        break;
                    case "AddTicketNote":
                        AddTicketNote(context);
                        break;
                    case "IsTicket":
                        IsTicket(context);
                        break;
                    case "GetTicketActivity":
                        GetTicketActivity(context);
                        break;
                    case "GetTicketItemCount":
                        GetTicketItemCount(context);
                        break;
                    case "AcceptTicket":
                        AcceptTicket(context);
                        break;
                    case "MergeTicket":
                        MergeTicket(context);
                        break;
                    case "AbsorbTicket":
                        AbsorbTicket(context);
                        break;
                    case "DisRelationProject":
                        DisRelationProject(context);
                        break;
                    case "SignAsIssue":
                        SignAsIssue(context);
                        break;
                    case "GetProCount":
                        GetProCount(context);
                        break;
                    case "SinAsIncident":
                        SinAsIncident(context);
                        break;
                    case "RelaNewProblem":
                        RelaNewProblem(context);
                        break;
                    case "RelaNewRequests":
                        RelaNewRequests(context);
                        break;
                    case "DisRelaTicket":
                        DisRelaTicket(context);
                        break;
                    case "RelaProblem":
                        RelaProblem(context);
                        break;
                    case "RelaIncident":
                        RelaIncident(context);
                        break;
                    case "CheckRelaTicket":
                        CheckRelaTicket(context);
                        break;
                    case "TicketOtherManage":
                        TicketOtherManage(context);
                        break;
                    case "AppOther":
                        AppOther(context);
                        break;
                    case "RevokeAppOther":
                        RevokeAppOther(context);
                        break;
                    case "OtherPersonManage":
                        OtherPersonManage(context);
                        break;
                    case "GetRecTicket":
                        GetRecTicket(context);
                        break;
                    case "RecStatusManage":
                        RecStatusManage(context);
                        break;
                    case "DeleteMasterTicket":
                        DeleteMasterTicket(context);
                        break;
                    case "GetFutureIds":
                        GetFutureIds(context);
                        break;
                    case "DeleteTicketByIds":
                        DeleteTicketByIds(context);
                        break;
                    case "CheckTicketResTime":
                        CheckTicketResTime(context);
                        break;
                    case "GetCall":
                        GetCall(context);
                        break;
                    case "CallTicketResManage":
                        CallTicketResManage(context);
                        break;
                    case "DeleteTicketCall":
                        DeleteTicketCall(context);
                        break;
                    case "DoneCall":
                        DoneCall(context);
                        break;
                    case "DeleteCall":
                        DeleteCall(context);
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
        /// <summary>
        /// 比较合同和工单的采购订单信息,返回合同订单号和工单的成本未审批成本数量
        /// </summary>
        private void CheckContractPurchaseOrder(HttpContext context)
        {
            var contractId = context.Request.QueryString["contract_id"];
            var purchaseOrder = context.Request.QueryString["purchase_order"];
            var ticketId = context.Request.QueryString["ticket_id"];
            var returnOrder = "";
            int count = 0;
            bool isUpdateOrder = false;  // 是否需要更新采购订单
            if (!string.IsNullOrEmpty(contractId) && !string.IsNullOrEmpty(purchaseOrder))
            {
                var thisContract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contractId));
                if (thisContract != null && !string.IsNullOrEmpty(thisContract.purchase_order_no))
                {
                    returnOrder = thisContract.purchase_order_no;

                    if (purchaseOrder != thisContract.purchase_order_no)
                    {
                        isUpdateOrder = true;
                    }
                }
            }
            if (!string.IsNullOrEmpty(ticketId))
            {
                var thisCost = new ctt_contract_cost_dal().GetListByTicketId(long.Parse(ticketId), $" and bill_status=0 and purchase_order_no='{purchaseOrder}'");
                if (thisCost != null && thisCost.Count > 0)
                {
                    count = thisCost.Count;
                }
            }
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { isUpdateOrder = isUpdateOrder, count = count, returnOrder = returnOrder }));


        }
        /// <summary>
        /// 获取到工单相关的信息
        /// </summary>
        private void GetTicket(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            if (!string.IsNullOrEmpty(ticketId))
            {
                var thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(ticketId));
                if (thisTicket != null)
                {
                    context.Response.Write(new EMT.Tools.Serialize().SerializeJson(thisTicket));
                }
            }
        }
        /// <summary>
        /// 返回工单相关属性的值
        /// </summary>
        private void GetTicketProperty(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var propertyName = context.Request.QueryString["property"];
            if (!string.IsNullOrEmpty(ticketId) && !string.IsNullOrEmpty(propertyName))
            {
                var thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(ticketId));
                if (thisTicket != null)
                {
                    context.Response.Write(BaseDAL<sdk_task>.GetObjectPropertyValue(thisTicket, propertyName));
                }
            }
        }
        /// <summary>
        /// 判断是工单还是任务
        /// </summary>
        private void IsTicket(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var isTicket = "0";
            if (!string.IsNullOrEmpty(ticketId))
            {
                var thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(ticketId));
                if (thisTicket != null)
                {
                    if (thisTicket.type_id == (int)DTO.DicEnum.TASK_TYPE.PROJECT_ISSUE || thisTicket.type_id == (int)DTO.DicEnum.TASK_TYPE.PROJECT_PHASE || thisTicket.type_id == (int)DTO.DicEnum.TASK_TYPE.PROJECT_TASK)
                    {
                        isTicket = "2";
                    }
                    else if (thisTicket.type_id == (int)DTO.DicEnum.TASK_TYPE.SERVICE_DESK_TICKET || thisTicket.type_id == (int)DTO.DicEnum.TASK_TYPE.RECURRING_TICKET_MASTER || thisTicket.type_id == (int)DTO.DicEnum.TASK_TYPE.TASKFIRE_TICKET)
                    {
                        isTicket = "1";
                    }
                }
            }
            context.Response.Write(isTicket);
        }
        /// <summary>
        /// 改变检查单的完成状态
        /// </summary>
        private void ChangeCheckComplete(HttpContext context)
        {
            var ckId = context.Request.QueryString["check_id"];
            var isComplete = context.Request.QueryString["is_com"];
            var result = false;
            if (!string.IsNullOrEmpty(ckId) && !string.IsNullOrEmpty(isComplete))
            {
                result = new TicketBLL().ChangeCheckIsCom(long.Parse(ckId), isComplete == "1", LoginUserId);
            }
            context.Response.Write(result);
        }
        /// <summary>
        /// 获取到检查单的信息
        /// </summary>
        private void GetCheckInfo(HttpContext context)
        {
            var ckId = context.Request.QueryString["check_id"];
            if (!string.IsNullOrEmpty(ckId))
            {
                var thisCheck = new sdk_task_checklist_dal().FindNoDeleteById(long.Parse(ckId));
                if (thisCheck != null)
                {
                    var creRes = new sys_resource_dal().FindNoDeleteById(thisCheck.create_user_id);
                    var creaTeTime = Tools.Date.DateHelper.ConvertStringToDateTime(thisCheck.create_time);
                    // 返回 重要，完成，创建时间，创建人
                    context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { isImp = thisCheck.is_important == 1, isCom = thisCheck.is_competed == 1, creTime = creaTeTime.ToString("yyyy-MM-dd"), creRes = creRes == null ? "" : creRes.name }));
                }
            }
        }

        /// <summary>
        /// 返回工单的提醒信息---(返回客户告警，外包消息，变更管理消息)
        /// </summary>
        private void GetTicketAlert(HttpContext context)
        {
            var ticket_id = context.Request.QueryString["ticket_id"];
            if (!string.IsNullOrEmpty(ticket_id))
            {
                var thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(ticket_id));
                if (thisTicket != null)
                {
                    string accountAlert = "";   // 客户的新建 提醒信息
                    string outMasg = "";        // 外包消息
                    string changeMsg = "";      // 变更管理消息

                    var tickCreateAlert = new crm_account_alert_dal().FindAlert(thisTicket.account_id, DTO.DicEnum.ACCOUNT_ALERT_TYPE.NEW_TICKET_ALERT);
                    if (tickCreateAlert != null)
                    {
                        accountAlert += tickCreateAlert.alert_text + " ";
                    }

                    var tickDetailAlert = new crm_account_alert_dal().FindAlert(thisTicket.account_id, DTO.DicEnum.ACCOUNT_ALERT_TYPE.TICKET_DETAIL_ALERT);
                    if (tickDetailAlert != null)
                    {
                        accountAlert += tickDetailAlert.alert_text + " ";
                    }



                    context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { accountAlert = accountAlert, outMasg = outMasg, changeMsg = changeMsg }));

                }
            }
        }
        /// <summary>
        /// 删除工单
        /// </summary>
        private void DeleteTicket(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            if (!string.IsNullOrEmpty(ticketId))
            {
                string faileReason;
                var result = new TicketBLL().DeleteTicket(long.Parse(ticketId), LoginUserId, out faileReason);
                // 返回结果和失败原因
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { result = result, reason = faileReason, }));
            }
        }
        /// <summary>
        /// 快速新增备注
        /// </summary>
        private void AddTicketNote(HttpContext context)
        {
            var ticket_id = context.Request.QueryString["ticket_id"];
            var isInter = !string.IsNullOrEmpty(context.Request.QueryString["is_inter"]);
            var notiContacr = !string.IsNullOrEmpty(context.Request.QueryString["noti_contact"]);
            var notiPriRes = !string.IsNullOrEmpty(context.Request.QueryString["noti_pri_res"]);
            var notiIntAll = !string.IsNullOrEmpty(context.Request.QueryString["noti_inter_all"]);
            var ticketNoteType = context.Request.QueryString["ticket_note_type_id"];
            var noteDesc = context.Request.QueryString["ticket_note_desc"];
            var result = false;
            if (!string.IsNullOrEmpty(ticket_id) && !string.IsNullOrEmpty(noteDesc) && !string.IsNullOrEmpty(ticketNoteType))
            {
                var notiEmail = new TicketBLL().GetNotiEmail(long.Parse(ticket_id), notiContacr, notiPriRes, notiIntAll);
                result = new TicketBLL().SimpleAddTicketNote(long.Parse(ticket_id), LoginUserId, int.Parse(ticketNoteType), noteDesc, isInter, notiEmail);
            }
            context.Response.Write(result);
        }
        private void GetTicketItemCount(HttpContext context)
        {
            var ticket = context.Request.QueryString["ticketId"];
            if (!string.IsNullOrEmpty(ticket))
            {
                var dic = new ActivityBLL().GetTciektItemCount(long.Parse(ticket), LoginUserId);
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(dic));
            }

        }

        /// <summary>
        /// 获取到工单活动相关页面
        /// </summary>
        private void GetTicketActivity(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticketId"];
            if (string.IsNullOrEmpty(ticketId))
                return;
            List<string> filter = new List<string>();
            if (!string.IsNullOrEmpty(context.Request.QueryString["CkPublic"]))
                filter.Add("public");
            if (!string.IsNullOrEmpty(context.Request.QueryString["CkInter"]))
                filter.Add("internal");
            if (!string.IsNullOrEmpty(context.Request.QueryString["CkLabour"]))
                filter.Add("timesheet");
            if (!string.IsNullOrEmpty(context.Request.QueryString["CkNote"]))
                filter.Add("notes");
            if (!string.IsNullOrEmpty(context.Request.QueryString["CkAtt"]))
                filter.Add("attachment");
            if (!string.IsNullOrEmpty(context.Request.QueryString["CkMe"]))
                filter.Add("me");
            //if (!string.IsNullOrEmpty(context.Request.QueryString["CkMe"]))
            //    filter.Add("public");
            //if (!string.IsNullOrEmpty(context.Request.QueryString["orderBy"]))
            //    filter.Add("public");
            var order = context.Request.QueryString["orderBy"];
            var isShowSys = context.Request.QueryString["CkShowSys"];
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.ActivityBLL().GetTicketActHtml(long.Parse(ticketId), LoginUserId, order, isShowSys, filter, LoginUser.security_Level_id, UserPermit)));
        }
        /// <summary>
        /// 接受工单
        /// </summary>
        private void AcceptTicket(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var result = false;
            var faileReason = "";
            if (!string.IsNullOrEmpty(ticketId))
                result = new TicketBLL().AcceptTicket(long.Parse(ticketId), LoginUserId, ref faileReason);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { result = result, reason = faileReason, }));
            // AcceptTicket
        }
        /// <summary>
        /// 合并工单
        /// </summary>
        private void MergeTicket(HttpContext context)
        {
            var fromTicketId = context.Request.QueryString["from_ticket_id"];
            var toTicketId = context.Request.QueryString["to_ticket_id"];
            var reason = "";
            var result = false;
            if (!string.IsNullOrEmpty(fromTicketId) && !string.IsNullOrEmpty(toTicketId))
            {
                result = new TicketBLL().MergeTicket(long.Parse(toTicketId), long.Parse(fromTicketId), LoginUserId, ref reason);
            }
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { result = result, reason = reason, }));
        }
        /// <summary>
        /// 吸收工单
        /// </summary>
        private void AbsorbTicket(HttpContext context)
        {
            var ticketId = context.Request.QueryString["to_ticket_id"];
            var fromIds = context.Request.QueryString["from_ticket_ids"];
            var result = false;
            // var faileReason = "";
            if (!string.IsNullOrEmpty(ticketId) && !string.IsNullOrEmpty(fromIds))
                result = new TicketBLL().MergeTickets(long.Parse(ticketId), fromIds, LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 取消与项目的关联
        /// </summary>
        private void DisRelationProject(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var result = false;
            if (!string.IsNullOrEmpty(ticketId))
                result = new TicketBLL().DisRelationProject(long.Parse(ticketId), LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 标记为问题
        /// </summary>
        private void SignAsIssue(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var reason = "";
            var result = false;
            if (!string.IsNullOrEmpty(ticketId))
            {
                result = new TicketBLL().SignAsIssue(long.Parse(ticketId), LoginUserId, ref reason);
            }
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { result = result, reason = reason, }));
        }
        /// <summary>
        /// 检查选择的工单是否可以关联
        /// </summary>
        private void GetProCount(HttpContext context)
        {
            int result = 0;
            var ticketId = context.Request.QueryString["ticket_id"];
            if (!string.IsNullOrEmpty(ticketId))
            {
                result = new sdk_task_dal().GetProCount(long.Parse(ticketId));
            }
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 标记为事故并关联其他工单
        /// </summary>
        private void SinAsIncident(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var relaTicketId = context.Request.QueryString["rela_ticket_id"];
            var result = false;
            if (!string.IsNullOrEmpty(ticketId) && !string.IsNullOrEmpty(relaTicketId))
                result = new TicketBLL().SinAsIncident(long.Parse(ticketId), long.Parse(relaTicketId), LoginUserId, !string.IsNullOrEmpty(context.Request.QueryString["change_account"]));
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 标记为事故并关联新工单
        /// </summary>
        private void RelaNewProblem(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var relaTicketId = context.Request.QueryString["rela_ticket_id"];
            var result = false;
            if (!string.IsNullOrEmpty(ticketId) && !string.IsNullOrEmpty(relaTicketId))
                result = new TicketBLL().RelaNewProblem(long.Parse(ticketId), long.Parse(relaTicketId), LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 标记为事故并关联服务请求工单
        /// </summary>
        /// <param name="context"></param>
        private void RelaNewRequests(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var relaTicketId = context.Request.QueryString["rela_ticket_ids"];
            var result = false;
            if (!string.IsNullOrEmpty(ticketId) && !string.IsNullOrEmpty(relaTicketId))
                result = new TicketBLL().RelaNewRequests(long.Parse(ticketId), relaTicketId, LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 解除关联
        /// </summary>
        /// <param name="context"></param>
        private void DisRelaTicket(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var relaTicketId = context.Request.QueryString["rela_ticket_id"];
            var result = false;
            if (!string.IsNullOrEmpty(ticketId) && !string.IsNullOrEmpty(relaTicketId))
                result = new TicketBLL().DisRelaTicket(long.Parse(ticketId),long.Parse(relaTicketId),LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 关联问题
        /// </summary>
        /// <param name="context"></param>
        private void RelaProblem(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var relaTicketId = context.Request.QueryString["rela_ticket_ids"];
            var result = false;
            if (!string.IsNullOrEmpty(ticketId) && !string.IsNullOrEmpty(relaTicketId))
                result = new TicketBLL().RelaProblem(long.Parse(ticketId), relaTicketId, LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 关联前的检查
        /// </summary>
        /// <param name="context"></param>
        private void CheckRelaTicket(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var relaTicketId = context.Request.QueryString["rela_ticket_ids"];
            bool isDiffCompany = false;
            bool isHasPro = false;
            bool isSginInd = false;   // 是否关联事故
            // if (!string.IsNullOrEmpty(ticketId) && !string.IsNullOrEmpty(relaTicketId))
            var stDal = new sdk_task_dal();

            var relList = stDal.GetTicketByIds(relaTicketId);
            var thisTicket = stDal.FindNoDeleteById(long.Parse(ticketId));
            if(relList!=null&& relList.Count > 0 && thisTicket != null)
            {
                if (relList.Any(_ => _.account_id != thisTicket.account_id))
                    isDiffCompany = true;
                if (relList.Any(_ => _.problem_ticket_id != null))
                    isHasPro = true;
                if (relList.Any(_ => _.ticket_type_id == (int)DTO.DicEnum.TICKET_TYPE.PROBLEM && stDal.GetProCount(_.id) != 0))
                    isSginInd = true;
            }
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { diffAcc = isDiffCompany, isHasPro = isHasPro, isSginInd = isSginInd, }));

        }
        /// <summary>
        /// 关联事故
        /// </summary>
        /// <param name="context"></param>
        private void RelaIncident(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var relaTicketId = context.Request.QueryString["rela_ticket_ids"];
            var result = false;
            if (!string.IsNullOrEmpty(ticketId) && !string.IsNullOrEmpty(relaTicketId))
                result = new TicketBLL().RelaIncident(long.Parse(ticketId), relaTicketId, LoginUserId, !string.IsNullOrEmpty(context.Request.QueryString["change_account"]));
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 工单审批信息管理
        /// </summary>
        private void TicketOtherManage(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var boardId = context.Request.QueryString["board_id"];
            long? board_id = null;
            if (!string.IsNullOrEmpty(boardId))
                board_id = long.Parse(boardId);
            var appTypeId = context.Request.QueryString["app_type_id"];
            int app_type_id = (int)DTO.DicEnum.APPROVAL_TYPE.ALL_APPROVERS_MUST_APPROVE;
            if(string.IsNullOrEmpty(appTypeId))
                app_type_id = (int)DTO.DicEnum.APPROVAL_TYPE.ONE_APPROVER_MUST_APPROVE;
            var oldResIds = context.Request.QueryString["old_res_ids"];
            var newResIds = context.Request.QueryString["new_res_ids"];
            var isAdd = context.Request.QueryString["is_add"];
            var result = false;
            if (!string.IsNullOrEmpty(isAdd))
                result = new TicketBLL().AddTicketOther(long.Parse(ticketId), board_id, app_type_id, newResIds,LoginUserId);
            else
                result = new TicketBLL().EditTicketOther(long.Parse(ticketId), board_id, app_type_id, oldResIds, newResIds, LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 审批变更申请
        /// </summary>
        private void AppOther(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var result = false;
            if (!string.IsNullOrEmpty(ticketId))
                result = new TicketBLL().AppOther(long.Parse(ticketId),LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 撤销申请审批
        /// </summary>
        private void RevokeAppOther(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var result = false;
            if (!string.IsNullOrEmpty(ticketId))
                result = new TicketBLL().RevokeAppOther(long.Parse(ticketId), LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 审批负责人管理
        /// </summary>
        private void OtherPersonManage(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var isApp = context.Request.QueryString["is_app"];
            var reason = context.Request.QueryString["reason"];
            var result = false;
            if (!string.IsNullOrEmpty(ticketId))
            {
                int app = (int)DTO.DicEnum.CHANGE_APPROVE_STATUS_PERSON.REJECTED;
                if(!string.IsNullOrEmpty(isApp))
                    app = (int)DTO.DicEnum.CHANGE_APPROVE_STATUS_PERSON.APPROVED;
                result = new TicketBLL().OtherPersonManage(long.Parse(ticketId),app,reason,LoginUserId);
            }
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 获取工单审批周期信息
        /// </summary>
        private void GetRecTicket(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            if (!string.IsNullOrEmpty(ticketId))
            {
                var thisRec = new sdk_recurring_ticket_dal().GetByTicketId(long.Parse(ticketId));
                if(thisRec!=null)
                    context.Response.Write(new EMT.Tools.Serialize().SerializeJson(thisRec));
            }
        }
        /// <summary>
        /// 工单周期状态管理
        /// </summary>
        private void RecStatusManage(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var isActive = context.Request.QueryString["is_active"];
            bool result = false;
            if (!string.IsNullOrEmpty(ticketId) && !string.IsNullOrEmpty(isActive))
                result = new TicketBLL().RecTicketActiveManage(long.Parse(ticketId), isActive=="1",LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 删除定期主工单
        /// </summary>
        private void DeleteMasterTicket(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            var isDeletfuture = context.Request.QueryString["delete_future"];
            if (!string.IsNullOrEmpty(ticketId))
            {
                Dictionary<string, int> subResult = new Dictionary<string, int>();
                bool result = false;
                result = new TicketBLL().DeleteMaster(long.Parse(ticketId),LoginUserId,!string.IsNullOrEmpty(isDeletfuture),ref subResult,!string.IsNullOrEmpty(context.Request.QueryString["not_delete"]));
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new {result=result,dic= subResult }));
            }
                
            
        }
        /// <summary>
        /// 获取该工单下的所有未开始的工单Id
        /// </summary>
        private void GetFutureIds(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
            string ids = "";
            if (!string.IsNullOrEmpty(ticketId))
                ids = new TicketBLL().GetFutureIds(long.Parse(ticketId));
            context.Response.Write(ids);
        }
        /// <summary>
        /// 根据Id 删除相关工单
        /// </summary>
        private void DeleteTicketByIds(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"];
            var result = false;
            if (!string.IsNullOrEmpty(ids))
                result = new TicketBLL().DeleteTicketByIds(ids,LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 校验工单负责人的时间 是否已经使用
        /// </summary>
        private void CheckTicketResTime(HttpContext context)
        {
            var ticketIds = context.Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(ticketIds))
            {
                var tickList = new sdk_task_dal().GetTaskByIds(ticketIds);
                if (tickList != null && tickList.Count > 0)
                {
                    var start = DateTime.Parse(context.Request.QueryString["start"]);
                    var end = DateTime.Parse(context.Request.QueryString["end"]);
                    var tbll = new TicketBLL();
                    List<sys_resource> repearResList = new List<sys_resource>();
                    bool isHasRes = true;
                    if (!tickList.Any(_ => tbll.IsHasRes(_.id)))
                        // 代表选择工单无负责人
                        isHasRes = false;
                    else
                    {
                        var startLong = Tools.Date.DateHelper.ToUniversalTimeStamp(start);
                        var endLong = Tools.Date.DateHelper.ToUniversalTimeStamp(end);
                        foreach (var ticket in tickList)
                        {
                            var resList = tbll.GetResNameByTime(ticket.id, startLong, endLong);
                            if (resList != null && resList.Count > 0)
                                repearResList.AddRange(resList);
                        }
                        if (repearResList != null && repearResList.Count > 0)
                            repearResList = repearResList.Distinct().ToList();
                    }
                    context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { hasRes= isHasRes,resList= repearResList }));

                }
            }
        }
        /// <summary>
        /// 返回服务预定信息
        /// </summary>
        /// <param name="context"></param>
        private void GetCall(HttpContext context)
        {
            var callId = context.Request.QueryString["callId"];
            if (!string.IsNullOrEmpty(callId))
            {
                var call = new sdk_service_call_dal().FindNoDeleteById(long.Parse(callId));
                if(call!=null)
                    context.Response.Write(new EMT.Tools.Serialize().SerializeJson(call));
            }
        }
        /// <summary>
        /// 服务预定工单员工管理
        /// </summary>
        /// <param name="context"></param>
        private void CallTicketResManage(HttpContext context)
        {
            var result = false;
            var callTicketId = context.Request.QueryString["callTicketId"];
            var resIds = context.Request.QueryString["resIds"];
            if (!string.IsNullOrEmpty(callTicketId))
            {
                result = true;
                new TicketBLL().CallTicketResManage(long.Parse(callTicketId),resIds,LoginUserId);
            }
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 删除相关服务预定
        /// </summary>
        /// <param name="context"></param>
        private void DeleteTicketCall(HttpContext context)
        {
            var result = false;
            var callId = context.Request.QueryString["callId"];
            var ticketId = context.Request.QueryString["ticketId"];
            if (!string.IsNullOrEmpty(callId) && !string.IsNullOrEmpty(ticketId))
            {
                result = true;
                new TicketBLL().DeleteTaicktCall(long.Parse(callId), long.Parse(ticketId), LoginUserId);
            }
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 完成服务预定
        /// </summary>
        private void DoneCall(HttpContext context)
        {
            var callId = context.Request.QueryString["callId"];
            var result = false;
            if (!string.IsNullOrEmpty(callId))
                result = new TicketBLL().DoneCall(long.Parse(callId),LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 删除服务预定
        /// </summary>
        private void DeleteCall(HttpContext context)
        {
            var callId = context.Request.QueryString["callId"];
            var result = false;
            if (!string.IsNullOrEmpty(callId))
                result = new TicketBLL().DeleteCall(long.Parse(callId), LoginUserId);
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(result));
        }
    }
}