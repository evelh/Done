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
                    if(thisTicket.type_id==(int)DTO.DicEnum.TASK_TYPE.PROJECT_ISSUE|| thisTicket.type_id == (int)DTO.DicEnum.TASK_TYPE.PROJECT_PHASE|| thisTicket.type_id == (int)DTO.DicEnum.TASK_TYPE.PROJECT_TASK)
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
                        accountAlert += tickCreateAlert.alert_text+ " ";
                    }

                    var tickDetailAlert = new crm_account_alert_dal().FindAlert(thisTicket.account_id, DTO.DicEnum.ACCOUNT_ALERT_TYPE.TICKET_DETAIL_ALERT);
                    if (tickDetailAlert != null)
                    {
                        accountAlert += tickDetailAlert.alert_text + " ";
                    }



                    context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { accountAlert= accountAlert, outMasg= outMasg, changeMsg= changeMsg }));

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
            if (!string.IsNullOrEmpty(ticket_id) && !string.IsNullOrEmpty(noteDesc)&&!string.IsNullOrEmpty(ticketNoteType))
            {
                var notiEmail = new TicketBLL().GetNotiEmail(long.Parse(ticket_id), notiContacr, notiPriRes, notiIntAll);
                result = new TicketBLL().SimpleAddTicketNote(long.Parse(ticket_id),LoginUserId,int.Parse(ticketNoteType),noteDesc,isInter,notiEmail);
            }
            context.Response.Write(result);
        }
        /// <summary>
        /// 获取到工单活动相关页面
        /// </summary>
        private void GetTicketActivity(HttpContext context)
        {
            var ticketId = context.Request.QueryString["ticket_id"];
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
            //if (!string.IsNullOrEmpty(context.Request.QueryString["CkMe"]))
            //    filter.Add("public");
            //if (!string.IsNullOrEmpty(context.Request.QueryString["orderBy"]))
            //    filter.Add("public");
            context.Response.Write(new Tools.Serialize().SerializeJson(new BLL.ActivityBLL().GetTicketActHtml(long.Parse(ticketId),LoginUserId,filter)));
        }
    }
}