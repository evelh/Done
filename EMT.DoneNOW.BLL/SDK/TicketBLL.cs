using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class TicketBLL
    {
        private sdk_task_dal _dal = new sdk_task_dal();
        /// <summary>
        /// 新增工单操作
        /// </summary>
        /// <param name="param"></param>
        /// <param name="userId"></param>
        /// <param name="faileReason"></param>
        /// <returns></returns>
        public bool AddTicket(TicketManageDto param, long userId, out string faileReason)
        {
            faileReason = "";
            try
            {
                var thisTicket = param.ticket;
                #region 1 新增工单
                if (thisTicket != null)
                    InsertTicket(thisTicket, userId);
                else
                    return false;
                #endregion

                #region 2 新增自定义信息
                var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.TICKETS, userId,
                    thisTicket.id, udf_list, param.udfList, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK_INFORMATION);
                #endregion

                #region 3 工单其他负责人
                TicketResManage(thisTicket.id, param.resDepIds, userId);
                #endregion

                #region 4 检查单信息
                CheckManage(param.ckList, thisTicket.id, userId);
                #endregion

                #region 5 发送邮件相关
                SendTicketEmail(param, userId);
                #endregion

            }
            catch (Exception msg)
            {
                faileReason = msg.Message;
                return false;
            }
            return true;
        }
        /// <summary>
        /// 修改工单操作
        /// </summary>
        /// <param name="param"></param>
        /// <param name="userId"></param>
        /// <param name="faileReason"></param>
        /// <returns></returns>
        public bool EditTicket(TicketManageDto param, long userId, out string faileReason)
        {
            faileReason = "";
            try
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                #region 工单信息处理
                var oldTicket = _dal.FindNoDeleteById(param.ticket.id);
                if (oldTicket == null)
                    return false;
                bool isComplete = false;   // 是否是完成
                bool isRepeat = false;     // 是否是重新打开
                // 状态从第一次从“新建”改为其他，会触发 存储响应时间
                var updateTicket = param.ticket;
                if (oldTicket.first_activity_time == null && oldTicket.status_id == (int)DicEnum.TICKET_STATUS.NEW)
                {
                    updateTicket.first_activity_time = timeNow;
                }
                // 重新打开判断  -- 从完成状态变为其他状态次数
                if (oldTicket.status_id == (int)DicEnum.TICKET_STATUS.DONE && updateTicket.status_id != (int)DicEnum.TICKET_STATUS.DONE)
                {
                    updateTicket.reopened_count = (oldTicket.reopened_count ?? 0) + 1;
                    updateTicket.date_completed = null;
                    updateTicket.reason = param.repeatReason;
                    isRepeat = true;
                }
                // 完成判断
                if (oldTicket.status_id != (int)DicEnum.TICKET_STATUS.DONE && updateTicket.status_id == (int)DicEnum.TICKET_STATUS.DONE)
                {
                    updateTicket.date_completed = timeNow;
                    updateTicket.reason = param.completeReason;
                    isComplete = true;
                    if (param.isAppSlo)
                    {
                        updateTicket.resolution = (oldTicket.resolution ?? "") + updateTicket.resolution;
                    }
                }
                if (oldTicket.sla_id == null && updateTicket.sla_id != null)
                {
                    updateTicket.sla_start_time = timeNow;
                }
                if (oldTicket.sla_id != null && updateTicket.sla_id == null)
                {
                    // updateTicket.sla_start_time = null;
                }

                var statusGeneral = new d_general_dal().FindNoDeleteById(updateTicket.status_id);

                var oldStatusGeneral = new d_general_dal().FindNoDeleteById(oldTicket.status_id);

                if (statusGeneral != null && !string.IsNullOrEmpty(statusGeneral.ext1))
                {
                    // 根据状态事件，执行相应的操作
                    switch (int.Parse(statusGeneral.ext1))
                    {
                        case (int)SLA_EVENT_TYPE.RESOLUTIONPLAN:
                            updateTicket.resolution_plan_actual_time = timeNow;
                            break;
                        case (int)SLA_EVENT_TYPE.RESOLUTION:
                            updateTicket.resolution_actual_time = timeNow;
                            break;
                        default:
                            break;
                    }
                    TicketSlaEvent(updateTicket, userId);
                }
                EditTicket(updateTicket, userId);
                // 添加活动信息
                if (isComplete)
                {
                    AddCompleteActive(updateTicket, userId);
                }
                // 添加活动信息
                if (isRepeat)
                {
                    AddCompleteActive(updateTicket, userId, true);
                }
                #endregion

                #region 自定义字段处理
                var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);  // 获取合同的自定义字段信息
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.TICKETS, userId,
                    updateTicket.id, udf_list, param.udfList, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK_INFORMATION);
                #endregion

                #region 员工相关处理
                TicketResManage(updateTicket.id, param.resDepIds, userId);
                #endregion

                #region 检查单相关处理
                CheckManage(param.ckList, updateTicket.id, userId);
                #endregion

                #region 发送邮件相关
                SendTicketEmail(param, userId);
                #endregion
            }
            catch (Exception msg)
            {
                faileReason = msg.Message;
                return false;
            }
            return true;
        }
        /// <summary>
        /// 新增工单
        /// </summary>
        public bool InsertTicket(sdk_task ticket, long user_id)
        {
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (ticket.sla_id != null)
                ticket.sla_start_time = timeNow;
            ticket.id = _dal.GetNextIdCom();
            ticket.create_time = timeNow;
            ticket.create_user_id = user_id;
            ticket.update_time = timeNow;
            ticket.update_user_id = user_id;
            if (string.IsNullOrEmpty(ticket.no))
                ticket.no = new TaskBLL().ReturnTaskNo();
            _dal.Insert(ticket);
            OperLogBLL.OperLogAdd<sdk_task>(ticket, ticket.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "新增工单");
            return true;
        }
        /// <summary>
        /// 编辑工单信息
        /// </summary>
        public bool EditTicket(sdk_task ticket, long user_id)
        {
            bool result = false;
            var oldTicket = _dal.FindNoDeleteById(ticket.id);
            if (oldTicket != null)
            {
                string desc = _dal.CompareValue<sdk_task>(oldTicket, ticket);
                if (string.IsNullOrEmpty(desc))
                    return true;
                ticket.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ticket.update_user_id = user_id;
                _dal.Update(ticket);
                OperLogBLL.OperLogUpdate<sdk_task>(ticket, oldTicket, ticket.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改工单信息");
            }
            return result;
        }
        /// <summary>
        /// 工单员工的管理
        /// </summary>
        public void TicketResManage(long ticketId, string resDepIds, long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
            {
                return;
            }
            var strDal = new sdk_task_resource_dal();
            var srdDal = new sys_resource_department_dal();
            var oldTaskResList = strDal.GetResByTaskId(ticketId);
            if (oldTaskResList != null && oldTaskResList.Count > 0)
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                if (!string.IsNullOrEmpty(resDepIds))   // 数据库中有，页面也有
                {
                    var thisIdList = resDepIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var resDepId in thisIdList)
                    {
                        var roleDep = srdDal.FindById(long.Parse(resDepId));
                        if (roleDep != null)
                        {
                            var isHas = oldTaskResList.FirstOrDefault(_ => _.resource_id == roleDep.resource_id && _.role_id == roleDep.role_id);
                            if (isHas == null)  // 相同的员工角色如果已经存在则不重复添加
                            {
                                var item = new sdk_task_resource()
                                {
                                    id = strDal.GetNextIdCom(),
                                    task_id = ticketId,
                                    role_id = roleDep.role_id,
                                    resource_id = roleDep.resource_id,
                                    department_id = (int)roleDep.department_id,
                                    create_user_id = userId,
                                    update_user_id = userId,
                                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                };
                                strDal.Insert(item);
                                OperLogBLL.OperLogAdd<sdk_task_resource>(item, item.id, userId, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增工单分配对象");
                            }
                            else
                            {
                                oldTaskResList.Remove(isHas);
                            }
                        }
                    }
                    if (oldTaskResList.Count > 0)
                    {
                        foreach (var oldTaskRes in oldTaskResList)
                        {
                            strDal.SoftDelete(oldTaskRes, userId);
                            OperLogBLL.OperLogDelete<sdk_task_resource>(oldTaskRes, oldTaskRes.id, userId, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "删除工单团队成员");
                        }
                    }
                }
                else            // 原来有，页面没有（全部删除）
                {
                    foreach (var oldTaskRes in oldTaskResList)
                    {
                        strDal.SoftDelete(oldTaskRes, userId);
                        OperLogBLL.OperLogDelete<sdk_task_resource>(oldTaskRes, oldTaskRes.id, userId, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "删除工单团队成员");
                    }
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(resDepIds))// 页面有，数据库没有（全部新增）
                {
                    var resDepList = resDepIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (resDepList != null && resDepList.Count() > 0)
                    {

                        foreach (var resDepId in resDepList)
                        {
                            var roleDep = srdDal.FindById(long.Parse(resDepId));
                            if (roleDep != null)
                            {
                                var isHas = strDal.GetSinByTasResRol(ticketId, roleDep.resource_id, roleDep.role_id);
                                if (isHas == null)  // 相同的员工角色如果已经存在则不重复添加
                                {
                                    var item = new sdk_task_resource()
                                    {
                                        id = strDal.GetNextIdCom(),
                                        task_id = ticketId,
                                        role_id = roleDep.role_id,
                                        resource_id = roleDep.resource_id,
                                        department_id = (int)roleDep.department_id,
                                        create_user_id = userId,
                                        update_user_id = userId,
                                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    };
                                    strDal.Insert(item);
                                    OperLogBLL.OperLogAdd<sdk_task_resource>(item, item.id, userId, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增工单分配对象");
                                }


                            }
                        }
                    }
                }
            }
        }
        /// <summary>
        /// 工单的检查单管理
        /// </summary>
        public void CheckManage(List<CheckListDto> ckList, long ticketId, long userId)
        {
            var stcDal = new sdk_task_checklist_dal();
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return;
            var oldCheckList = stcDal.GetCheckByTask(ticketId);
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (oldCheckList != null && oldCheckList.Count > 0)
            {
                if (ckList != null && ckList.Count > 0)
                {
                    var editList = ckList.Where(_ => _.ckId > 0).ToList();
                    var addList = ckList.Where(_ => _.ckId < 0).ToList();
                    if (editList != null && editList.Count > 0)
                    {
                        foreach (var thisEnt in editList)
                        {
                            var oldThisEdit = oldCheckList.FirstOrDefault(_ => _.id == thisEnt.ckId);
                            var thisEdit = stcDal.FindNoDeleteById(thisEnt.ckId);
                            if (oldThisEdit != null && thisEdit != null)
                            {
                                oldCheckList.Remove(oldThisEdit);
                                thisEdit.is_competed = (sbyte)(thisEnt.isComplete ? 1 : 0);
                                thisEdit.is_important = (sbyte)(thisEnt.isImport ? 1 : 0);
                                thisEdit.item_name = thisEnt.itemName;
                                thisEdit.kb_article_id = thisEnt.realKnowId;
                                thisEdit.sort_order = thisEnt.sortOrder;
                                thisEdit.update_user_id = userId;
                                thisEdit.update_time = timeNow;
                                stcDal.Update(thisEdit);
                                OperLogBLL.OperLogUpdate<sdk_task_checklist>(thisEdit, oldThisEdit, thisEdit.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "修改检查单信息");
                            }
                        }
                    }
                    if (addList != null && addList.Count > 0)
                    {
                        foreach (var thisEnt in addList)
                        {
                            var thisCheck = new sdk_task_checklist()
                            {
                                id = stcDal.GetNextIdCom(),
                                is_competed = (sbyte)(thisEnt.isComplete ? 1 : 0),
                                is_important = (sbyte)(thisEnt.isImport ? 1 : 0),
                                item_name = thisEnt.itemName,
                                kb_article_id = thisEnt.realKnowId,
                                update_user_id = userId,
                                update_time = timeNow,
                                create_time = timeNow,
                                create_user_id = userId,
                                task_id = ticketId,
                                sort_order = thisEnt.sortOrder,
                            };
                            stcDal.Insert(thisCheck);
                            OperLogBLL.OperLogAdd<sdk_task_checklist>(thisCheck, thisCheck.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "新增检查单信息");
                        }
                    }
                }
                if (oldCheckList.Count > 0)
                {
                    oldCheckList.ForEach(_ =>
                    {
                        stcDal.SoftDelete(_, userId);
                        OperLogBLL.OperLogDelete<sdk_task_checklist>(_, _.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "删除检查单信息");
                    });
                }
            }
            else
            {
                if (ckList != null && ckList.Count > 0)
                {
                    foreach (var thisEnt in ckList)
                    {
                        var thisCheck = new sdk_task_checklist()
                        {
                            id = stcDal.GetNextIdCom(),
                            is_competed = (sbyte)(thisEnt.isComplete ? 1 : 0),
                            is_important = (sbyte)(thisEnt.isImport ? 1 : 0),
                            item_name = thisEnt.itemName,
                            kb_article_id = thisEnt.realKnowId,
                            update_user_id = userId,
                            update_time = timeNow,
                            create_time = timeNow,
                            create_user_id = userId,
                            task_id = ticketId,
                            sort_order = thisEnt.sortOrder,
                        };
                        stcDal.Insert(thisCheck);
                        OperLogBLL.OperLogAdd<sdk_task_checklist>(thisCheck, thisCheck.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "新增检查单信息");
                    }
                }
            }
        }
        /// <summary>
        /// 工单完成时，保存活动信息
        /// </summary>
        public void AddCompleteActive(sdk_task ticket, long userId, bool isRepeat = false)
        {
            if (ticket != null && (ticket.status_id == (int)DicEnum.TICKET_STATUS.DONE || isRepeat))
            {
                var activity = new com_activity()
                {
                    id = _dal.GetNextIdCom(),
                    cate_id = (int)DicEnum.ACTIVITY_CATE.TICKET_NOTE,
                    action_type_id = (int)ACTIVITY_TYPE.TASK_INFO,
                    object_id = ticket.id,
                    object_type_id = (int)OBJECT_TYPE.TICKETS,
                    account_id = ticket.account_id,
                    contact_id = ticket.contact_id,
                    name = isRepeat ? "重新打开原因" : "完成原因",
                    description = ticket.reason,
                    publish_type_id = (int)NOTE_PUBLISH_TYPE.TICKET_ALL_USER,
                    ticket_id = ticket.id,
                    create_user_id = userId,
                    update_user_id = userId,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    is_system_generate = 0,
                    task_status_id = (int)DicEnum.TICKET_STATUS.DONE,
                };
                new com_activity_dal().Insert(activity);
                OperLogBLL.OperLogAdd<com_activity>(activity, activity.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, isRepeat ? "重新打开工单" : "完成工单");
            }

        }
        /// <summary>
        /// 改变检查单的状态
        /// </summary>
        public bool ChangeCheckIsCom(long ckId, bool icCom, long userId)
        {
            var result = false;
            var stcDal = new sdk_task_checklist_dal();
            var thisCk = stcDal.FindNoDeleteById(ckId);
            var newIsCom = (sbyte)(icCom ? 1 : 0);
            if (thisCk != null && thisCk.is_competed != newIsCom)
            {
                var oldCk = stcDal.FindNoDeleteById(ckId);
                thisCk.is_competed = newIsCom;
                thisCk.update_user_id = userId;
                thisCk.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                stcDal.Update(thisCk);
                OperLogBLL.OperLogUpdate<sdk_task_checklist>(thisCk, oldCk, thisCk.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "修改检查单");
                result = true;
            }
            return result;

        }

        /// <summary>
        /// 新增工单备注
        /// </summary>
        public bool AddTicketNote(TaskNoteDto param, long ticket_id, long user_id)
        {
            try
            {
                var thisTicket = _dal.FindNoDeleteById(ticket_id);
                if (thisTicket == null)
                    return false;
                if (thisTicket.status_id != (int)DicEnum.TICKET_STATUS.DONE && thisTicket.status_id != param.status_id)
                {
                    thisTicket.status_id = param.status_id;
                    EditTicket(thisTicket, user_id);
                }

                var caDal = new com_activity_dal();
                var thisActivity = param.taskNote;
                thisActivity.ticket_id = ticket_id;
                thisActivity.id = caDal.GetNextIdCom();
                thisActivity.oid = 0;
                thisActivity.object_id = thisTicket.id;
                thisActivity.account_id = thisTicket.account_id;
                thisActivity.task_status_id = thisTicket.status_id;
                caDal.Insert(thisActivity);
                OperLogBLL.OperLogAdd<com_activity>(thisActivity, thisActivity.id, user_id, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");

                if (param.filtList != null && param.filtList.Count > 0)
                {
                    var attBll = new AttachmentBLL();
                    foreach (var thisFile in param.filtList)
                    {
                        if (thisFile.type_id == ((int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())
                        {
                            attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.NOTES, thisActivity.id, (int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT, thisFile.new_filename, "", thisFile.old_filename, thisFile.fileSaveName, thisFile.conType, thisFile.Size, user_id);
                        }
                        else
                        {
                            attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.NOTES, thisActivity.id, int.Parse(thisFile.type_id), thisFile.new_filename, thisFile.old_filename, null, null, null, 0, user_id);
                        }
                    }
                }
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// 删除工单，返回不可删除的原因，返回多条
        /// </summary>
        public bool DeleteTicket(long ticketId, long userId, out string failReason)
        {
            failReason = "";
            var couldDelete = true;   // 校验是否可以删除
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket != null)
            {
                // 如果做过外包，且未被取消，不能删除，提醒“工单被外包，不能删除”
                // 如果有工时，不能删除，提醒“工单有工时，不能删除”
                // 如果有费用，不能删除，提醒“工单有费用，不能删除”
                // 如果有成本，不能删除，提醒“工单有成本，不能删除”
                // 如果有员工对变更申请进行了审批（同意或拒绝），提醒“有员工对变更申请进行了审批（同意或拒绝），不能删除”
                var entryList = new sdk_work_entry_dal().GetByTaskId(thisTicket.id);
                if (entryList != null && entryList.Count > 0)
                {
                    couldDelete = false;
                    failReason += "工单有工时，不能删除;";
                }

                var expList = new sdk_expense_dal().GetExpByTaskId(thisTicket.id);
                if (expList != null && expList.Count > 0)
                {
                    couldDelete = false;
                    failReason += "工单有费用，不能删除;";
                }

                var costList = new ctt_contract_cost_dal().GetListByTicketId(thisTicket.id);
                if (costList != null && costList.Count > 0)
                {
                    couldDelete = false;
                    failReason += "工单有成本，不能删除;";
                }

                if (couldDelete)
                {
                    #region 删除工单间关联关系
                    var subTicketList = new sdk_task_dal().GetTaskByParentId(thisTicket.id);
                    if (subTicketList != null && subTicketList.Count > 0)
                    {
                        foreach (var subTicket in subTicketList)
                        {
                            subTicket.parent_id = null;
                            EditTicket(subTicket, userId);
                        }
                    }
                    #endregion

                    #region 删除备注 
                    var caDal = new com_activity_dal();
                    var actList = caDal.GetActiList(" and ticket_id=" + thisTicket.id.ToString());
                    if (actList != null && actList.Count > 0)
                    {
                        actList.ForEach(_ =>
                        {
                            caDal.SoftDelete(_, userId);
                            OperLogBLL.OperLogDelete<com_activity>(_, _.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "删除活动");
                        });
                    }
                    #endregion

                    #region 删除附件
                    var comAttDal = new com_attachment_dal();
                    var attList = comAttDal.GetAttListByOid(thisTicket.id);
                    if (attList != null && attList.Count > 0)
                    {
                        attList.ForEach(_ =>
                        {
                            comAttDal.SoftDelete(_, userId);
                            OperLogBLL.OperLogDelete<com_attachment>(_, _.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ATTACHMENT, "删除附件");
                        });
                    }
                    #endregion

                    #region 删除待办

                    #endregion

                    #region 删除服务预定

                    #endregion

                    #region 删除变更信息
                    var stoDal = new sdk_task_other_dal();
                    var otherList = stoDal.GetTicketOther(thisTicket.id);
                    if (otherList != null)
                    {
                        stoDal.SoftDelete(otherList, userId);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                        OperLogBLL.OperLogDelete<sdk_task_other>(otherList, otherList.task_id, userId, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK, "删除工单");
                    }
                    #endregion


                    #region 删除审批人信息
                    var stopDal = new sdk_task_other_person_dal();
                    var appList = stopDal.GetTicketOther(thisTicket.id);
                    if (appList != null && appList.Count > 0)
                    {
                        appList.ForEach(_ =>
                        {
                            stopDal.SoftDelete(_, userId);
                            OperLogBLL.OperLogDelete<sdk_task_other_person>(_, _.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TICKET_SERVICE_REQUEST, "删除审批人");
                        });
                    }
                    #endregion


                    #region 删除工单信息

                    _dal.SoftDelete(thisTicket, userId);
                    OperLogBLL.OperLogDelete<sdk_task>(thisTicket, thisTicket.id, userId, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK, "删除工单");
                    #endregion
                }
                else
                {
                    return false;
                }

            }
            return true;
        }

        /// <summary>
        /// 工单Sla事件管理
        /// </summary>
        public void TicketSlaEvent(sdk_task thisTicket, long userId)
        {
            var statusGeneral = new d_general_dal().FindNoDeleteById(thisTicket.status_id);
            if (thisTicket.sla_id != null && statusGeneral != null)
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                // sdk_task_sla_event
                var stseDal = new sdk_task_sla_event_dal();
                var thisTaskSla = stseDal.GetTaskSla(thisTicket.id);
                if (thisTaskSla == null)
                {
                    thisTaskSla = new sdk_task_sla_event()
                    {
                        id = stseDal.GetNextIdCom(),
                        create_time = timeNow,
                        update_time = timeNow,
                        create_user_id = userId,
                        update_user_id = userId,
                        task_id = thisTicket.id,
                    };
                    stseDal.Insert(thisTaskSla);
                    OperLogBLL.OperLogAdd<sdk_task_sla_event>(thisTaskSla, thisTaskSla.id, userId, OPER_LOG_OBJ_CATE.TICKET_SLA_EVENT, "新增工单sla事件");
                }

                if (thisTicket.sla_start_time != null && statusGeneral.ext1 == ((int)SLA_EVENT_TYPE.FIRSTRESPONSE).ToString())
                {
                    thisTaskSla.first_response_resource_id = userId;
                    thisTaskSla.first_response_elapsed_hours = GetDiffHours((long)thisTicket.sla_start_time, timeNow);
                }
                if (thisTicket.resolution_plan_actual_time != null && statusGeneral.ext1 == ((int)SLA_EVENT_TYPE.RESOLUTIONPLAN).ToString())
                {
                    thisTaskSla.resolution_plan_resource_id = userId;
                    thisTaskSla.resolution_plan_elapsed_hours = GetDiffHours((long)thisTicket.resolution_plan_actual_time, timeNow);
                }
                if (thisTicket.resolution_actual_time != null && statusGeneral.ext1 == ((int)SLA_EVENT_TYPE.RESOLUTION).ToString())
                {
                    thisTaskSla.resolution_resource_id = userId;
                    thisTaskSla.resolution_elapsed_hours = GetDiffHours((long)thisTicket.resolution_actual_time, timeNow);
                }
                // todo 计算 sla 目标
                #region 计算等待客户时长相关
                var oldTicket = _dal.FindNoDeleteById(thisTicket.id);
                if (oldTicket != null)
                {
                    var oldStatusGeneral = new d_general_dal().FindNoDeleteById(oldTicket.status_id);
                    if (oldStatusGeneral != null && !string.IsNullOrEmpty(oldStatusGeneral.ext1))
                    {
                        if (oldStatusGeneral.ext1 != ((int)SLA_EVENT_TYPE.WAITINGCUSTOMER).ToString() && statusGeneral.ext1 == ((int)SLA_EVENT_TYPE.WAITINGCUSTOMER).ToString())
                        {
                            thisTaskSla.total_waiting_customer_hours += GetDiffHours(oldTicket.update_time, timeNow);
                        }
                    }
                }
                #endregion

                var oldEvent = stseDal.FindNoDeleteById(thisTaskSla.id);
                if (oldEvent != null)
                {

                }
                stseDal.Update(thisTaskSla);
                OperLogBLL.OperLogUpdate<sdk_task_sla_event>(thisTaskSla, oldEvent, thisTaskSla.id, userId, OPER_LOG_OBJ_CATE.TICKET_SLA_EVENT, "修改工单sla事件");
            }
        }

        /// <summary>
        /// 获取到两个时间相差的小时数
        /// </summary>
        public int GetDiffHours(long startDate, long endDate)
        {
            int hours = 0;
            var thisStartDate = Tools.Date.DateHelper.ConvertStringToDateTime(startDate);
            var thisEndDate = Tools.Date.DateHelper.ConvertStringToDateTime(endDate);
            TimeSpan ts1 = new TimeSpan(thisStartDate.Ticks);
            TimeSpan ts2 = new TimeSpan(thisEndDate.Ticks);
            TimeSpan ts = ts1.Subtract(ts2).Duration();
            if (ts.Days > 0)
            {
                hours += ts.Days * 24;
            }
            if (ts.Hours > 0)
            {
                hours += ts.Hours;
            }
            return hours;
        }


        #region 工单工时管理
        /// <summary>
        /// 添加工单工时信息
        /// </summary>
        public bool AddLabour(sdk_work_entry thisEntry, long userId)
        {
            var sweDal = new sdk_work_entry_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisEntry.id = sweDal.GetNextIdCom();
            thisEntry.create_time = timeNow;
            thisEntry.update_time = timeNow;
            thisEntry.create_user_id = userId;
            thisEntry.update_user_id = userId;
            sweDal.Insert(thisEntry);
            OperLogBLL.OperLogAdd<sdk_work_entry>(thisEntry, thisEntry.id, userId, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "新增工时");
            return true;
        }
        public bool EditLabour(sdk_work_entry thisEntry, long userId)
        {
            var sweDal = new sdk_work_entry_dal();
            var oldLabour = sweDal.FindNoDeleteById(thisEntry.id);
            if (oldLabour != null)
            {
                string desc = _dal.CompareValue<sdk_work_entry>(oldLabour, thisEntry);
                if (string.IsNullOrEmpty(desc))
                    return true;
                thisEntry.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisEntry.update_user_id = userId;
                sweDal.Update(thisEntry);
                OperLogBLL.OperLogUpdate<sdk_work_entry>(thisEntry, oldLabour, thisEntry.id, userId, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "修改工时");
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// 工单工时的添加处理
        /// </summary>
        public bool AddTicketLabour(SdkWorkEntryDto param, long userId, ref string failReason)
        {
            try
            {
                #region 过滤父级工单，暂不支持多级
                param.workEntry = GetParentId(param.workEntry);
                #endregion

                #region  添加工时
                AddLabour(param.workEntry, userId);
                #endregion

                #region 保存工单相关
                var oldTicket = _dal.FindNoDeleteById(param.ticketId);
                if (oldTicket != null)
                {
                    if (oldTicket.status_id != param.status_id)
                    {
                        oldTicket.status_id = param.status_id;
                    }
                    if (param.isAppthisResoule)
                    {
                        oldTicket.resolution += "\r\n" + param.workEntry.summary_notes;
                    }
                    EditTicket(oldTicket, userId);
                }

                #endregion

                #region 更新相关事故的解决方案
                var proTicketList = _dal.GetSubTaskByType(param.ticketId, DicEnum.TICKET_TYPE.PROBLEM);
                if (proTicketList != null && proTicketList.Count > 0)
                {
                    proTicketList.ForEach(_ =>
                    {
                        if (param.isAppOtherResoule)
                        {
                            _.resolution += "\r\n" + param.workEntry.summary_notes;
                        }
                        if (param.isAppOtherNote)
                        {
                            if (_.status_id != (int)DicEnum.TICKET_STATUS.DONE)
                            {
                                _.status_id = param.status_id;
                            }
                            if (!string.IsNullOrEmpty(param.workEntry.summary_notes) && !string.IsNullOrEmpty(param.workEntry.internal_notes))
                            {
                                long noteId;
                                AppNoteLabour(_, param.workEntry.summary_notes, userId, out noteId, true);
                                if (noteId != 0)
                                {
                                    AppNoteLabour(_, param.workEntry.internal_notes, userId, out noteId, false, noteId);
                                }

                            }
                        }
                        EditTicket(_, userId);
                    });
                }
                #endregion

                #region 通知相关

                #endregion

                #region 根据合同设置 是否立刻审批并提交
                if (param.workEntry.contract_id != null)
                {
                    var contract = new ctt_contract_dal().FindNoDeleteById((long)param.workEntry.contract_id);
                    if (contract != null && contract.bill_post_type_id == (int)DicEnum.BILL_POST_TYPE.BILL_NOW)
                    {
                        new ApproveAndPostBLL().PostWorkEntry(param.workEntry.id, Convert.ToInt32(DateTime.Now.ToString("yyyyMMdd")), userId, "A");
                    }
                }
                #endregion

                #region 新增合同成本相关
                AddTicketLabourCost(param.thisCost, userId);
                #endregion


            }
            catch (Exception msg)
            {
                failReason = msg.Message;
                return false;
            }

            return true;
        }

        public sdk_work_entry GetParentId(sdk_work_entry thisEntry)
        {
            if (thisEntry.parent_id == null && thisEntry.parent_note_id == null && thisEntry.parent_attachment_id == null)
                return thisEntry;
            if (thisEntry.parent_note_id != null)
            {
                var parNote = new com_activity_dal().FindNoDeleteById((long)thisEntry.parent_note_id);
                if (parNote != null)
                {
                    if (parNote.parent_id != null)
                        thisEntry.parent_note_id = (int)parNote.object_id;
                }
                else
                    thisEntry.parent_note_id = null;

            }
            else if (thisEntry.parent_attachment_id != null)
            {
                var parAtt = new com_attachment_dal().FindNoDeleteById((long)thisEntry.parent_attachment_id);
                if (parAtt != null)
                {
                    if (parAtt.parent_id != null)
                        thisEntry.parent_attachment_id = (int)parAtt.object_id;
                }
                else
                    thisEntry.parent_attachment_id = null;
            }
            else if (thisEntry.parent_id != null)
            {
                var parEnt = new sdk_work_entry_dal().FindNoDeleteById((long)thisEntry.parent_id);
                if (parEnt != null)
                {
                    if (parEnt.parent_id != null)
                        thisEntry.parent_id = (int)parEnt.parent_id;
                    if (parEnt.parent_note_id != null)
                    {
                        thisEntry.parent_id = null;
                        thisEntry.parent_note_id = parEnt.parent_note_id;
                    }
                    else if (parEnt.parent_attachment_id != null)
                    {
                        thisEntry.parent_id = null;
                        thisEntry.parent_attachment_id = parEnt.parent_attachment_id;
                    }
                }
                else
                    thisEntry.parent_id = null;
            }
            return thisEntry;
        }
        /// <summary>
        /// 添加工单工时时，附件相关备注 isSummary 代表是工时说明备注，还是内部说明备注
        /// </summary>
        public void AppNoteLabour(sdk_task thisTicket, string note, long userId, out long thisNoteId, bool isSummary = false, long? noteId = null)
        {
            var activ = new com_activity();
            var caDal = new com_activity_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            activ.id = caDal.GetNextIdCom();
            if (isSummary)
            {
                thisNoteId = activ.id;
            }
            else
            {
                thisNoteId = 0;
            }
            activ.cate_id = (int)DicEnum.ACTIVITY_CATE.TICKET_NOTE;
            activ.object_type_id = (int)DicEnum.OBJECT_TYPE.TICKETS;
            activ.account_id = thisTicket.account_id;
            activ.contact_id = thisTicket.contact_id;
            activ.ticket_id = thisTicket.id;
            activ.description = note;
            activ.create_time = timeNow;
            activ.update_time = timeNow;
            activ.create_user_id = userId;
            activ.update_user_id = userId;
            if (isSummary)
            {
                activ.object_type_id = (int)DicEnum.OBJECT_TYPE.TICKETS;
                activ.object_id = thisTicket.id;
                activ.publish_type_id = (int)NOTE_PUBLISH_TYPE.TICKET_ALL_USER;
            }
            else
            {
                activ.object_type_id = (int)DicEnum.OBJECT_TYPE.NOTES;
                activ.object_id = (long)noteId;
                activ.publish_type_id = (int)NOTE_PUBLISH_TYPE.TICKET_INTERNA_USER;
            }
            caDal.Insert(activ);
            OperLogBLL.OperLogAdd<com_activity>(activ, activ.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");
        }
        /// <summary>
        /// 新增 项目工时成本
        /// </summary>
        public void AddTicketLabourCost(ctt_contract_cost thisCost, long userId)
        {
            if (thisCost != null)
            {
                var costCode = new d_cost_code_dal().FindNoDeleteById(thisCost.cost_code_id);
                if (costCode != null)
                {
                    var cccDal = new ctt_contract_cost_dal();
                    thisCost.id = cccDal.GetNextIdCom();
                    thisCost.is_billable = 1;
                    thisCost.name = costCode.name;
                    thisCost.unit_cost = costCode.unit_cost;
                    thisCost.sub_cate_id = (int)DicEnum.BILLING_ENTITY_SUB_TYPE.CONTRACT_COST;
                    thisCost.cost_type_id = (int)COST_TYPE.OPERATIONA;
                    thisCost.status_id = (int)COST_STATUS.UNDETERMINED;
                    cccDal.Insert(thisCost);
                    OperLogBLL.OperLogAdd<ctt_contract_cost>(thisCost, thisCost.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_COST, "新增合同成本");
                }
            }
        }

        /// <summary>
        /// 修改工单工时信息
        /// </summary>
        public bool EditTicketLabour(SdkWorkEntryDto param, long userId, ref string failReason)
        {
            var oldLaour = new sdk_work_entry_dal().FindNoDeleteById(param.workEntry.id);
            if (oldLaour == null)
            {
                failReason = "未查询到该工时信息";
                return false;
            }
            if (oldLaour.approve_and_post_date != null || oldLaour.approve_and_post_user_id != null)
            {
                failReason = "该工时已经进行审批提交，不可进行更改";
                return false;
            }
            var thisTicket = _dal.FindNoDeleteById(param.ticketId);
            if (thisTicket == null)
            {
                failReason = "相关工单已删除";
                return false;
            }
            if (thisTicket.status_id == (int)TICKET_STATUS.DONE)
            {
                failReason = "已完成工单不能进行编辑工时相关操作";
                return false;
            }

            #region 修改工单相关
            EditLabour(param.workEntry, userId);
            #endregion

            #region 保存工单相关
            var oldTicket = _dal.FindNoDeleteById(param.ticketId);
            if (oldTicket != null)
            {
                if (oldTicket.status_id != param.status_id)
                {
                    oldTicket.status_id = param.status_id;
                }
                if (param.isAppthisResoule)
                {
                    oldTicket.resolution += "\r\n" + param.workEntry.summary_notes;
                }
                EditTicket(oldTicket, userId);
            }

            #endregion

            #region 更新相关事故的解决方案
            var proTicketList = _dal.GetSubTaskByType(param.ticketId, DicEnum.TICKET_TYPE.PROBLEM);
            if (proTicketList != null && proTicketList.Count > 0)
            {
                proTicketList.ForEach(_ =>
                {
                    if (param.isAppOtherResoule)
                    {
                        _.resolution += "\r\n" + param.workEntry.summary_notes;
                    }
                    if (param.isAppOtherNote)
                    {
                        if (_.status_id != (int)DicEnum.TICKET_STATUS.DONE)
                        {
                            _.status_id = param.status_id;
                        }
                        if (!string.IsNullOrEmpty(param.workEntry.summary_notes) && !string.IsNullOrEmpty(param.workEntry.internal_notes))
                        {
                            long noteId;
                            AppNoteLabour(_, param.workEntry.summary_notes, userId, out noteId, true);
                            if (noteId != 0)
                            {
                                AppNoteLabour(_, param.workEntry.internal_notes, userId, out noteId, false, noteId);
                            }

                        }
                    }
                    EditTicket(_, userId);
                });
            }
            #endregion

            #region 新增合同成本相关
            AddTicketLabourCost(param.thisCost, userId);
            #endregion

            return true;
        }



        #endregion

        #region 工单查看
        /// <summary>
        /// 快速新增工单备注
        /// </summary>
        public bool SimpleAddTicketNote(long ticketId, long userId, int noteTypeId, string noteDes, bool isInter, string notifiEmail)
        {
            var result = false;
            try
            {
                var thisTicket = _dal.FindNoDeleteById(ticketId);
                var caDal = new com_activity_dal();
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var thisNote = new com_activity()
                {
                    id = caDal.GetNextIdCom(),
                    account_id = thisTicket.account_id,
                    object_id = thisTicket.id,
                    ticket_id = thisTicket.id,
                    action_type_id = noteTypeId,
                    publish_type_id = isInter ? ((int)NOTE_PUBLISH_TYPE.TICKET_INTERNA_USER) : ((int)NOTE_PUBLISH_TYPE.TICKET_ALL_USER),
                    cate_id = (int)ACTIVITY_CATE.TICKET_NOTE,
                    name = noteDes.Length >= 40 ? noteDes.Substring(0, 39) : noteDes,
                    description = noteDes,
                    create_time = timeNow,
                    update_time = timeNow,
                    create_user_id = userId,
                    update_user_id = userId,
                    object_type_id = (int)OBJECT_TYPE.TICKETS,
                    task_status_id = thisTicket.status_id,
                    resource_id = thisTicket.owner_resource_id,
                };
                caDal.Insert(thisNote);
                OperLogBLL.OperLogAdd<com_activity>(thisNote, thisNote.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");

                #region todo 工单备注事件的默认模板，如果不设置则不发送
                #endregion
                result = true;
            }
            catch (Exception)
            {
                result = false;
            }

            return result;
        }
        /// <summary>
        /// 快速新增中，获取相关的通知人邮箱
        /// </summary>
        public string GetNotiEmail(long ticketId, bool notiContact, bool notiPriRes, bool noriInterAll)
        {
            return "";
        }
        /// <summary>
        /// 获取相关邮箱，发送邮件
        /// </summary>
        public void SendTicketEmail(TicketManageDto param, long userId)
        {
            if (param.notify_id == 0 || string.IsNullOrEmpty(param.Subject))
                return;
            var srDal = new sys_resource_dal();
            var thisUser = srDal.FindNoDeleteById(userId);
            if (thisUser == null)
                return;
            var toEmail = new StringBuilder();
            var ccEmail = new StringBuilder();
            var bccEmail = new StringBuilder();
            if (!string.IsNullOrEmpty(param.ToResId))
            {
                var toResList = srDal.GetListByIds(param.ToResId);
                if (toResList != null && toResList.Count > 0)
                    toResList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { toEmail.Append(_.email + ','); } });
            }
            else
            {
                return;
            }
            if (!string.IsNullOrEmpty(param.CCResId))
            {
                var ccResList = srDal.GetListByIds(param.CCResId);
                if (ccResList != null && ccResList.Count > 0)
                    ccResList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { ccEmail.Append(_.email + ','); } });
            }
            if (!string.IsNullOrEmpty(param.BCCResId))
            {
                var bccResList = srDal.GetListByIds(param.CCResId);
                if (bccResList != null && bccResList.Count > 0)
                    bccResList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { bccEmail.Append(_.email + ','); } });
            }
            var cneDal = new com_notify_email_dal();
            var tempEmail = new sys_notify_tmpl_email_dal().GetEmailByTempId(param.notify_id);
            var email = new com_notify_email()
            {
                id = cneDal.GetNextIdCom(),
                cate_id = (int)NOTIFY_CATE.TICKETS,
                event_id = (int)NOTIFY_EVENT.TICKET_CREATED_EDITED,
                create_user_id = userId,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = userId,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                to_email = toEmail.ToString(),   // 界面输入，包括发送对象、员工、其他地址等四个部分组成
                notify_tmpl_id = (int)param.notify_id,  // 根据通知模板
                from_email = param.EmailFrom ? thisUser.email : "",
                from_email_name = param.EmailFrom ? thisUser.name : "",
                //body_text =  tempEmail[0].body_text,
                //body_html = tempEmail[0].body_html,
                subject = param.Subject,

            };
            cneDal.Insert(email);
            OperLogBLL.OperLogAdd<com_notify_email>(email, email.id, userId, OPER_LOG_OBJ_CATE.NOTIFY, "新增通知-工单新增编辑");
        }
        /// <summary>
        /// 工单接受
        /// </summary>
        public bool AcceptTicket(long ticketId, long userId, ref string failReason)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
            {
                failReason = "工单已被删除！";
                return false;
            }
            if (thisTicket.owner_resource_id != null)
            {
                failReason = "工单已有主负责人,无法接受！";
                return false;
            }
            thisTicket.owner_resource_id = userId;
            long? roleId = null;
            if (thisTicket.department_id != null)
            {
                var roleList = new sys_resource_department_dal().GetResRoleList((long)thisTicket.department_id, userId);
                if (roleList != null && roleList.Count > 0)
                {
                    var defRole = roleList.FirstOrDefault(_ => _.is_default == 1);
                    if (defRole != null)
                        roleId = defRole.role_id;
                    else
                        roleId = roleList[0].role_id;
                }
                else
                {
                    var queueDepList = new sys_resource_department_dal().GetRolesBySource(userId, DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE);
                    if (queueDepList != null && queueDepList.Count > 0)
                    {
                        var defRole = queueDepList.FirstOrDefault(_ => _.is_default == 1);
                        if (defRole != null)
                            roleId = defRole.role_id;
                        else
                            roleId = queueDepList[0].role_id;
                    }
                    if (roleId == null)
                    {
                        var depList = new sys_resource_department_dal().GetRolesBySource(userId, DicEnum.DEPARTMENT_CATE.DEPARTMENT);
                        if (depList != null && depList.Count > 0)
                        {
                            var defRole = depList.FirstOrDefault(_ => _.is_default == 1);
                            if (defRole != null)
                                roleId = defRole.role_id;
                            else
                                roleId = depList[0].role_id;
                        }
                    }
                }
            }
            else
            {
                var role = new sys_resource_department_dal().GetDefault(userId);
                if (role != null)
                    roleId = role.role_id;
            }
            if (roleId == null)
            {
                failReason = "当前用户不属于任何队列不能执行该操作！";
                return false;
            }
            thisTicket.role_id = roleId;
            EditTicket(thisTicket, userId);
            return true;
        }
        /// <summary>
        /// 转发修改工单-添加备注
        /// </summary>
        public void AddModifyTicketNote(long ticketId, long userId)
        {
            var caDal = new com_activity_dal();
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var modifyNote = new com_activity()
            {
                id = caDal.GetNextIdCom(),
                account_id = thisTicket.account_id,
                object_id = thisTicket.id,
                ticket_id = thisTicket.id,
                action_type_id = (int)ACTIVITY_TYPE.TASK_INFO,
                contact_id = thisTicket.contact_id,
                publish_type_id = ((int)NOTE_PUBLISH_TYPE.TICKET_ALL_USER),
                cate_id = (int)ACTIVITY_CATE.TICKET_NOTE,
                name = "工单转发",
                description = "",
                create_time = timeNow,
                update_time = timeNow,
                create_user_id = userId,
                update_user_id = userId,
                object_type_id = (int)OBJECT_TYPE.TICKETS,
                status_id = thisTicket.status_id,
                is_system_generate = 1,
            };
            caDal.Insert(modifyNote);
            OperLogBLL.OperLogAdd<com_activity>(modifyNote, modifyNote.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");
        }
        /// <summary>
        /// 合并吸收工单 - 原工单的parent_id 变更为目标工单
        /// </summary>
        /// <param name="toTicketId">目标工单</param>
        /// <param name="fromTicketIds">原工单</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool MergeTickets(long toTicketId, string fromTicketIds, long userId)
        {
            var faileReason = "";
            var toTicket = _dal.FindNoDeleteById(toTicketId);
            if (toTicket == null || string.IsNullOrEmpty(fromTicketIds))
                return false;
            var fromArr = fromTicketIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (var fromTicketId in fromArr)
            {
                MergeTicket(toTicketId, long.Parse(fromTicketId), userId, ref faileReason);
            }
            return true;
        }
        /// <summary>
        /// 合并吸收单个工单
        /// </summary>
        public bool MergeTicket(long toTicketId, long fromTicketId, long userId, ref string faileReason)
        {
            #region 合并条件筛选
            if (toTicketId == fromTicketId)
            {
                faileReason = "原工单不能是目标工单";
                return false;
            }
            var toTicket = _dal.FindNoDeleteById(toTicketId);
            if (toTicket == null)
            {
                faileReason = "目标工单已删除";
                return false;
            }
            var fromTicket = _dal.FindNoDeleteById(fromTicketId);
            if (fromTicket == null)
            {
                faileReason = "原工单已删除";
                return false;
            }
            if (fromTicket.type_id == (int)DicEnum.TICKET_TYPE.PROBLEM || fromTicket.type_id == (int)DicEnum.TICKET_TYPE.CHANGE_REQUEST)
            {
                faileReason = "原工单不能是问题和变更申请";
                return false;
            }
            if (toTicket.type_id == (int)DicEnum.TICKET_TYPE.PROBLEM || toTicket.type_id == (int)DicEnum.TICKET_TYPE.CHANGE_REQUEST)
            {
                faileReason = "目标工单不能是问题和变更申请";
                return false;
            }
            #endregion
            // 相关操作
            #region  联系人转移
            if (fromTicket.contact_id != null)
                TransferContact(toTicketId, (long)fromTicket.contact_id, userId);
            #endregion

            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            #region 变更原工单相关信息
            var queueSet = new SysSettingBLL().GetSetById(SysSettingEnum.SDK_TICKER_MERGE_QUEUE);
            if (queueSet != null && !string.IsNullOrEmpty(queueSet.setting_value))
                fromTicket.department_id = long.Parse(queueSet.setting_value);
            fromTicket.date_completed = timeNow;
            fromTicket.status_id = (int)DicEnum.TICKET_STATUS.DONE;
            fromTicket.parent_id = toTicketId;
            EditTicket(fromTicket, userId);
            #endregion

            #region 生成两条备注
            var caDal = new com_activity_dal();
            var fromNote = new com_activity()
            {
                id = caDal.GetNextIdCom(),
                account_id = fromTicket.account_id,
                object_id = fromTicket.id,
                ticket_id = fromTicket.id,
                action_type_id = (int)ACTIVITY_TYPE.TASK_INFO,
                contact_id = fromTicket.contact_id,
                publish_type_id = ((int)NOTE_PUBLISH_TYPE.TICKET_ALL_USER),
                cate_id = (int)ACTIVITY_CATE.TICKET_NOTE,
                name = "工单完成并被合并",
                description = $"工单完成并被合并到{toTicket.no}",
                create_time = timeNow,
                update_time = timeNow,
                create_user_id = userId,
                update_user_id = userId,
                object_type_id = (int)OBJECT_TYPE.TICKETS,
                status_id = fromTicket.status_id,
                is_system_generate = 0,
                can_edit = 0,
            };
            caDal.Insert(fromNote);
            OperLogBLL.OperLogAdd<com_activity>(fromNote, fromNote.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");

            var toNote = new com_activity()
            {
                id = caDal.GetNextIdCom(),
                account_id = toTicket.account_id,
                object_id = toTicket.id,
                ticket_id = toTicket.id,
                action_type_id = (int)ACTIVITY_TYPE.TASK_INFO,
                contact_id = toTicket.contact_id,
                publish_type_id = ((int)NOTE_PUBLISH_TYPE.TICKET_ALL_USER),
                cate_id = (int)ACTIVITY_CATE.TICKET_NOTE,
                name = "工单吸收合并其他工单",
                description = $"工单吸收合并以下工单：{toTicket.no}",
                create_time = timeNow,
                update_time = timeNow,
                create_user_id = userId,
                update_user_id = userId,
                object_type_id = (int)OBJECT_TYPE.TICKETS,
                status_id = toTicket.status_id,
                is_system_generate = 0,
                can_edit = 0,
            };
            caDal.Insert(toNote);
            OperLogBLL.OperLogAdd<com_activity>(toNote, toNote.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");
            #endregion


            return true;
        }
        /// <summary>
        /// 工单中插入联系人
        /// </summary>
        public void TransferContact(long ticketId, long contactId, long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            var thisContact = new crm_contact_dal().FindNoDeleteById(contactId);
            if (thisTicket == null || thisContact == null)
                return;
            if (thisTicket.contact_id == contactId)
                return;
            var srDal = new sdk_task_resource_dal();
            var thisCon = srDal.GetConTact(ticketId, contactId);
            if (thisCon != null)
                return;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisCon = new sdk_task_resource()
            {
                id = srDal.GetNextIdCom(),
                contact_id = contactId,
                create_time = timeNow,
                create_user_id = userId,
                update_time = timeNow,
                update_user_id = userId,
                task_id = ticketId,
            };
            srDal.Insert(thisCon);
            OperLogBLL.OperLogAdd<sdk_task_resource>(thisCon, thisCon.id, userId, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增工单分配对象");
        }
        /// <summary>
        /// 复制到项目
        /// </summary>
        public bool CopyToProject(string ticketIds, long projectId, long departmentId, long? phaseId, long userId)
        {
            var project = new pro_project_dal().FindNoDeleteById(projectId);
            if (project == null || string.IsNullOrEmpty(ticketIds))
                return false;
            var ticketIdArr = ticketIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (var ticketId in ticketIdArr)
            {
                SingCopyProject(long.Parse(ticketId), projectId, departmentId, phaseId, userId);
            }
            return true;
        }
        /// <summary>
        /// 单个工单  复制到项目
        /// </summary>">
        public bool SingCopyProject(long ticketId, long projectId, long departmentId, long? phaseId, long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            var thisProject = new pro_project_dal().FindNoDeleteById(projectId);
            if (thisTicket == null || thisProject == null)
                return false;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var oldStatus = thisTicket.status_id;
            thisTicket.status_id = (int)DicEnum.TICKET_STATUS.DONE;
            thisTicket.date_completed = timeNow;
            EditTicket(thisTicket, userId);

            #region 新增相关任务
            var tBll = new TaskBLL();
            sdk_task parPhase = null;
            if (phaseId != null)
                parPhase = _dal.FindNoDeleteById((long)phaseId);
            var newTask = new sdk_task();
            newTask.id = _dal.GetNextIdCom();
            newTask.account_id = thisProject.account_id;
            newTask.status_id = oldStatus;
            newTask.title = thisTicket.title;
            newTask.description = thisTicket.description;
            newTask.priority = 0;
            newTask.is_visible_in_client_portal = 1;
            newTask.can_client_portal_user_complete_task = 0;
            newTask.type_id = (int)DicEnum.TASK_TYPE.PROJECT_TASK;
            newTask.estimated_begin_time = parPhase == null ? Tools.Date.DateHelper.ToUniversalTimeStamp((DateTime)thisProject.start_date) : parPhase.estimated_begin_time;
            newTask.estimated_end_time = newTask.estimated_begin_time;
            newTask.estimated_duration = 1;
            newTask.start_no_earlier_than_date = parPhase == null ? thisProject.start_date : Tools.Date.DateHelper.ConvertStringToDateTime((long)parPhase.estimated_begin_time);
            newTask.department_id = departmentId;
            newTask.estimated_hours = 0;
            newTask.sort_order = parPhase == null ? tBll.GetMinUserNoParSortNo(projectId) : tBll.GetMinUserSortNo((long)phaseId);
            newTask.no = tBll.ReturnTaskNo();
            newTask.create_time = timeNow;
            newTask.update_time = timeNow;
            newTask.create_user_id = userId;
            newTask.update_user_id = userId;
            _dal.Insert(newTask);
            OperLogBLL.OperLogAdd<sdk_task>(newTask, newTask.id, userId, OPER_LOG_OBJ_CATE.PROJECT_TASK, "新增task");
            #endregion

            #region 新增备注
            var caDal = new com_activity_dal();

            var fromNote = new com_activity()
            {
                id = caDal.GetNextIdCom(),
                account_id = thisTicket.account_id,
                object_id = thisTicket.id,
                ticket_id = thisTicket.id,
                action_type_id = (int)ACTIVITY_TYPE.TASK_INFO,
                contact_id = thisTicket.contact_id,
                publish_type_id = ((int)NOTE_PUBLISH_TYPE.TICKET_ALL_USER),
                cate_id = (int)ACTIVITY_CATE.TICKET_NOTE,
                name = "工单复制到项目",
                description = $"项目名称：{thisProject.name} \n\r 任务标题：{newTask.title}\n\r 查看任务详情：任务详情链接",
                create_time = timeNow,
                update_time = timeNow,
                create_user_id = userId,
                update_user_id = userId,
                object_type_id = (int)OBJECT_TYPE.TICKETS,
                status_id = thisTicket.status_id,
                is_system_generate = 1,
            };
            caDal.Insert(fromNote);
            OperLogBLL.OperLogAdd<com_activity>(fromNote, fromNote.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");

            var taskNote = new com_activity()
            {
                id = caDal.GetNextIdCom(),
                account_id = null,
                object_id = newTask.id,
                ticket_id = null,
                action_type_id = (int)ACTIVITY_TYPE.TASK_INFO,
                contact_id = null,
                publish_type_id = ((int)NOTE_PUBLISH_TYPE.TASK_ALL_USER),
                cate_id = (int)ACTIVITY_CATE.TASK_NOTE,
                name = "工单复制到项目",
                description = $"工单：{thisTicket.title} \n\r 查看工单详情：工单详情链接",
                create_time = timeNow,
                update_time = timeNow,
                create_user_id = userId,
                update_user_id = userId,
                object_type_id = (int)OBJECT_TYPE.TASK,
                status_id = newTask.status_id,
                is_system_generate = 1,
            };
            caDal.Insert(taskNote);
            OperLogBLL.OperLogAdd<com_activity>(taskNote, taskNote.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");
            #endregion
            return true;
        }
        /// <summary>
        /// 取消与项目的关联
        /// </summary>
        public bool DisRelationProject(long ticketId, long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return false;
            thisTicket.project_id = null;
            EditTicket(thisTicket, userId);
            return true;
        }
        /// <summary>
        /// 将工单类型 标记为问题
        /// </summary>
        public bool SignAsIssue(long ticketId, long userId, ref string failReason)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
            {
                failReason = "工单已删除！";
                return false;
            }
            if (thisTicket.ticket_type_id == (int)DicEnum.TICKET_TYPE.ALARM || thisTicket.ticket_type_id == (int)DicEnum.TICKET_TYPE.SERVICE_REQUEST || thisTicket.ticket_type_id == (int)DicEnum.TICKET_TYPE.INCIDENT)
            {
                thisTicket.ticket_type_id = (int)DicEnum.TICKET_TYPE.PROBLEM;
                EditTicket(thisTicket, userId);
                return true;
            }
            else
            {
                failReason = "工单类型必须为服务请求/事故/告警之一！";
                return false;
            }
        }
        /// <summary>
        /// 标记为事故并关联其他工单
        /// </summary>
        public bool SinAsIncident(long ticketId, long relaTicketId, long userId, bool isAddTicket = false)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            var relaTicket = _dal.FindNoDeleteById(relaTicketId);
            if (thisTicket == null || relaTicket == null)
                return false;
            if (thisTicket.ticket_type_id != (int)DicEnum.TICKET_TYPE.ALARM && thisTicket.ticket_type_id != (int)DicEnum.TICKET_TYPE.SERVICE_REQUEST && thisTicket.ticket_type_id != (int)DicEnum.TICKET_TYPE.PROBLEM && thisTicket.ticket_type_id != (int)DicEnum.TICKET_TYPE.INCIDENT)
                return false;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var tBll = new TaskBLL();
            sdk_task newTicket = null;
            if (isAddTicket)
            {
                newTicket = new sdk_task()
                {
                    //id=_dal.GetNextIdCom(),
                    //create_user_id = userId,
                    //update_user_id = userId,
                    //create_time = timeNow,
                    //update_time  =timeNow,
                    //no = tBll.ReturnTaskNo(),
                    type_id = (int)DicEnum.TASK_TYPE.SERVICE_DESK_TICKET,
                    ticket_type_id = (int)TICKET_TYPE.PROBLEM,
                    title = relaTicket.title,
                    description = relaTicket.description,
                    account_id = thisTicket.account_id,
                    contact_id = null,
                    status_id = relaTicket.status_id,
                    priority_type_id = relaTicket.priority_type_id,
                    issue_type_id = relaTicket.issue_type_id,
                    sub_issue_type_id = relaTicket.sub_issue_type_id,
                    source_type_id = relaTicket.source_type_id,
                    estimated_end_time = relaTicket.estimated_end_time,
                    estimated_duration = relaTicket.estimated_duration,
                    estimated_hours = relaTicket.estimated_hours,
                    sla_id = relaTicket.sla_id,
                    department_id = relaTicket.department_id,
                    owner_resource_id = relaTicket.owner_resource_id,
                    role_id = relaTicket.role_id,
                    cost_code_id = relaTicket.cost_code_id,
                    cate_id = (int)TICKET_CATE.STANDARD,
                    resolution = relaTicket.resolution,
                    sla_start_time = relaTicket.sla_start_time,
                    last_activity_time = timeNow,
                };
                if (newTicket.status_id != (int)TICKET_STATUS.NEW)
                    newTicket.first_activity_time = timeNow;
                InsertTicket(newTicket, userId);
            }
            thisTicket.ticket_type_id = (int)DicEnum.TICKET_TYPE.INCIDENT;
            thisTicket.problem_ticket_id = isAddTicket && newTicket != null ? newTicket.id : relaTicket.id;
            EditTicket(thisTicket, userId);

            var oldProTicketList = _dal.GetProList(thisTicket.id);
            if (oldProTicketList != null && oldProTicketList.Count > 0)
                oldProTicketList.ForEach(_ =>
                {
                    _.problem_ticket_id = isAddTicket && newTicket != null ? newTicket.id : relaTicket.id;
                    EditTicket(_, userId);
                });
            if (!isAddTicket && relaTicket.ticket_type_id != (int)TICKET_TYPE.PROBLEM)
            {
                relaTicket.ticket_type_id = (int)TICKET_TYPE.PROBLEM;
                EditTicket(relaTicket, userId);
            }
            return true;
        }
        /// <summary>
        /// 标记为事故并关联新的问题
        /// </summary>
        public bool RelaNewProblem(long ticketId, long issueTicketId, long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            var issTicket = _dal.FindNoDeleteById(issueTicketId);
            if (thisTicket == null || issTicket == null)
                return false;
            if (thisTicket.ticket_type_id != (int)DicEnum.TICKET_TYPE.ALARM && thisTicket.ticket_type_id != (int)DicEnum.TICKET_TYPE.SERVICE_REQUEST && thisTicket.ticket_type_id != (int)DicEnum.TICKET_TYPE.PROBLEM && thisTicket.ticket_type_id != (int)DicEnum.TICKET_TYPE.INCIDENT)
                return false;
            thisTicket.ticket_type_id = (int)TICKET_TYPE.INCIDENT;
            thisTicket.problem_ticket_id = issueTicketId;
            EditTicket(thisTicket, userId);
            return true;
        }
        /// <summary>
        /// 标记为事故并关联新的变更申请单
        /// </summary>
        public bool RelaNewRequests(long ticketId, string requestIds, long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null || string.IsNullOrEmpty(requestIds))
                return false;
            //if (thisTicket.ticket_type_id != (int)DicEnum.TICKET_TYPE.SERVICE_REQUEST)
            //    return false;
            thisTicket.ticket_type_id = (int)DicEnum.TICKET_TYPE.INCIDENT;
            EditTicket(thisTicket, userId);
            var idsArr = requestIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            var strDal = new sdk_task_relation_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            foreach (var id in idsArr)
            {
                var reqTicket = _dal.FindNoDeleteById(long.Parse(id));
                if (reqTicket == null || reqTicket.ticket_type_id != (int)DicEnum.TICKET_TYPE.CHANGE_REQUEST)
                    continue;
                var thisRela = strDal.GetRela(ticketId, reqTicket.id);
                if (thisRela != null)
                    continue;
                thisRela = new sdk_task_relation()
                {
                    id = strDal.GetNextIdCom(),
                    create_time = timeNow,
                    update_time = timeNow,
                    create_user_id = userId,
                    update_user_id = userId,
                    task_id = thisTicket.id,
                    parent_task_id = reqTicket.id,
                };
                strDal.Insert(thisRela);
                OperLogBLL.OperLogAdd<sdk_task_relation>(thisRela, thisRela.id, userId, OPER_LOG_OBJ_CATE.TICKET_RELATION, "新增工单关联");
            }
            return true;
        }
        /// <summary>
        /// 解除两个工单之间的关联
        /// </summary>
        public bool DisRelaTicket(long ticketId, long relaTicketId, long userId)
        {
            var strDal = new sdk_task_relation_dal();
            var thisRela = strDal.GetRela(ticketId, relaTicketId);
            if (thisRela != null)
            {
                strDal.SoftDelete(thisRela, userId);
                OperLogBLL.OperLogDelete<sdk_task_relation>(thisRela, thisRela.id, userId, OPER_LOG_OBJ_CATE.TICKET_RELATION, "删除工单关联");
            }
            return true;
        }
        /// <summary>
        /// 关联问题
        /// </summary>
        public bool RelaProblem(long ticketId, string problemIds, long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null || string.IsNullOrEmpty(problemIds))
                return false;
            var idArr = problemIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            var strDal = new sdk_task_relation_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            foreach (var thisId in idArr)
            {
                var problem = _dal.FindNoDeleteById(long.Parse(thisId));
                if (problem == null || problem.ticket_type_id != (int)DicEnum.TICKET_TYPE.PROBLEM)
                    continue;
                var thisRela = strDal.GetRela(problem.id, ticketId);
                if (thisRela != null)
                    continue;
                thisRela = new sdk_task_relation()
                {
                    id = strDal.GetNextIdCom(),
                    create_time = timeNow,
                    update_time = timeNow,
                    create_user_id = userId,
                    update_user_id = userId,
                    task_id = problem.id,
                    parent_task_id = thisTicket.id,
                };
                strDal.Insert(thisRela);
                OperLogBLL.OperLogAdd<sdk_task_relation>(thisRela, thisRela.id, userId, OPER_LOG_OBJ_CATE.TICKET_RELATION, "新增工单关联");
            }
            return true;
        }
        /// <summary>
        /// 关联事故
        /// </summary>
        public bool RelaIncident(long ticketId, string relaTicketIds, long userId, bool isChangeAcc = false)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null || string.IsNullOrEmpty(relaTicketIds))
                return false;
            var idArr = relaTicketIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            var strDal = new sdk_task_relation_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            foreach (var thisId in idArr)
            {
                var problem = _dal.FindNoDeleteById(long.Parse(thisId));
                if (problem == null)
                    continue;
                sdk_task newTicket = null;
                if (problem.account_id != thisTicket.account_id && isChangeAcc)
                {
                    newTicket = new sdk_task()
                    {
                        //id=_dal.GetNextIdCom(),
                        //create_user_id = userId,
                        //update_user_id = userId,
                        //create_time = timeNow,
                        //update_time  =timeNow,
                        //no = tBll.ReturnTaskNo(),
                        type_id = (int)DicEnum.TASK_TYPE.SERVICE_DESK_TICKET,
                        ticket_type_id = (int)TICKET_TYPE.INCIDENT,
                        title = problem.title,
                        description = problem.description,
                        account_id = thisTicket.account_id,
                        contact_id = null,
                        status_id = problem.status_id,
                        priority_type_id = problem.priority_type_id,
                        issue_type_id = problem.issue_type_id,
                        sub_issue_type_id = problem.sub_issue_type_id,
                        source_type_id = problem.source_type_id,
                        estimated_end_time = problem.estimated_end_time,
                        estimated_duration = problem.estimated_duration,
                        estimated_hours = problem.estimated_hours,
                        sla_id = problem.sla_id,
                        department_id = problem.department_id,
                        owner_resource_id = problem.owner_resource_id,
                        role_id = problem.role_id,
                        cost_code_id = problem.cost_code_id,
                        cate_id = (int)TICKET_CATE.STANDARD,
                        resolution = problem.resolution,
                        sla_start_time = problem.sla_start_time,
                        last_activity_time = timeNow,
                    };
                    if (newTicket.status_id != (int)TICKET_STATUS.NEW)
                        newTicket.first_activity_time = timeNow;
                    InsertTicket(newTicket, userId);
                }

                var thisRela = strDal.GetRela(problem.id, ticketId);
                if (!isChangeAcc && thisRela != null)
                    continue;
                if (problem.account_id == thisTicket.account_id && newTicket == null)
                {
                    problem.ticket_type_id = (int)DicEnum.TICKET_TYPE.INCIDENT;
                    EditTicket(problem, userId);
                }

                thisRela = new sdk_task_relation()
                {
                    id = strDal.GetNextIdCom(),
                    create_time = timeNow,
                    update_time = timeNow,
                    create_user_id = userId,
                    update_user_id = userId,
                    task_id = problem.account_id != thisTicket.account_id && isChangeAcc ? newTicket.id : problem.id,
                    parent_task_id = thisTicket.id,
                };
                strDal.Insert(thisRela);
                OperLogBLL.OperLogAdd<sdk_task_relation>(thisRela, thisRela.id, userId, OPER_LOG_OBJ_CATE.TICKET_RELATION, "新增工单关联");
            }
            return true;
        }
        /// <summary>
        /// 保存审批信息
        /// </summary>
        public bool AddTicketOther(long ticketId, long? boardId, int appTypeId, string resIds, long userId, string conIds = "")
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return false;
            var stoDal = new sdk_task_other_dal();
            var sto = stoDal.GetTicketOther(ticketId);
            if (sto != null)
                return false;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            sto = new sdk_task_other()
            {
                //id= stoDal.GetNextIdCom(),
                create_time = timeNow,
                update_time = timeNow,
                create_user_id = userId,
                update_user_id = userId,
                change_board_id = boardId,
                task_id = ticketId,
                approval_type_id = appTypeId,
                approve_status_id = (int)DicEnum.CHANGE_APPROVE_STATUS.ASSIGNED,
            };
            stoDal.Insert(sto);
            OperLogBLL.OperLogAdd<sdk_task_other>(sto, sto.task_id, userId, OPER_LOG_OBJ_CATE.TICKET_RELATION, "新增变更申请");

            var stopDal = new sdk_task_other_person_dal();
            if (!string.IsNullOrEmpty(resIds))
            {
                var resArr = resIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                var srDal = new sys_resource_dal();
                foreach (var resId in resArr)
                {
                    var thisRes = srDal.FindNoDeleteById(long.Parse(resId));
                    if (thisRes == null)
                        continue;
                    var stop = new sdk_task_other_person()
                    {
                        id = stopDal.GetNextIdCom(),
                        task_id = ticketId,
                        create_time = timeNow,
                        update_time = timeNow,
                        create_user_id = userId,
                        update_user_id = userId,
                        resource_id = thisRes.id,
                        approve_status_id = (int)DicEnum.CHANGE_APPROVE_STATUS_PERSON.WAIT,
                    };
                    stopDal.Insert(stop);
                    OperLogBLL.OperLogAdd<sdk_task_other_person>(stop, stop.id, userId, OPER_LOG_OBJ_CATE.CHANGE_REQUEST_APPROL, "新增变更申请审批人");
                }

            }
            #region 联系人暂时不做- 预留
            //if (!string.IsNullOrEmpty(conIds))
            //{
            //    var conArr = conIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            //    var ccDal = new crm_contact_dal();
            //    foreach (var conId in conArr)
            //    {
            //        var thisCon = ccDal.FindNoDeleteById(long.Parse(conId));
            //        if (thisCon == null)
            //            continue;
            //        var stop = new sdk_task_other_person()
            //        {
            //            id = stopDal.GetNextIdCom(),
            //            task_id = ticketId,
            //            create_time = timeNow,
            //            update_time = timeNow,
            //            create_user_id = userId,
            //            update_user_id = userId,
            //            contact_id = thisCon.id
            //        };
            //        stopDal.Insert(stop);
            //        OperLogBLL.OperLogAdd<sdk_task_other_person>(stop, stop.id, userId, OPER_LOG_OBJ_CATE.CHANGE_REQUEST_APPROL, "新增变更申请审批人");
            //    }

            //}
            #endregion
            return true;
        }
        /// <summary>
        /// 修改审批信息
        /// </summary>
        public bool EditTicketOther(long ticketId, long? boardId, int appTypeId, string oldResIds, string newResIds, long userId)
        {
            var stoDal = new sdk_task_other_dal();
            var stopDal = new sdk_task_other_person_dal();
            var thisOther = stoDal.GetTicketOther(ticketId);
            if (thisOther == null)
                return false;
            if (boardId == null && string.IsNullOrEmpty(oldResIds) && string.IsNullOrEmpty(newResIds))
                return false;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisOther.change_board_id = boardId;
            thisOther.approval_type_id = appTypeId;
            thisOther.update_time = timeNow;
            thisOther.update_user_id = userId;
            var oldOther = stoDal.GetTicketOther(ticketId);
            stoDal.Update(thisOther);
            OperLogBLL.OperLogUpdate<sdk_task_other>(thisOther, oldOther, thisOther.task_id, userId, OPER_LOG_OBJ_CATE.TICKET_RELATION, "编辑变更申请");
            var oldPersonList = stopDal.GetTicketOther(ticketId);
            if (oldPersonList != null && oldPersonList.Count > 0)
            {
                var resList = oldPersonList.Where(_ => _.resource_id != null).ToList();
                if (resList != null && resList.Count > 0)
                {
                    if (!string.IsNullOrEmpty(oldResIds))
                    {
                        var oldResArr = oldResIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        foreach (var oldRes in oldResArr)
                        {
                            var thisOld = resList.FirstOrDefault(_ => _.id == long.Parse(oldRes));
                            if (thisOld != null)
                                resList.Remove(thisOld);
                        }
                        if (resList.Count > 0)
                            resList.ForEach(_ =>
                            {
                                stopDal.SoftDelete(_, userId);
                                OperLogBLL.OperLogDelete<sdk_task_other_person>(_, _.id, userId, OPER_LOG_OBJ_CATE.CHANGE_REQUEST_APPROL, "删除变更申请审批人");
                            });
                    }
                    else
                        resList.ForEach(_ =>
                        {
                            stopDal.SoftDelete(_, userId);
                            OperLogBLL.OperLogDelete<sdk_task_other_person>(_, _.id, userId, OPER_LOG_OBJ_CATE.CHANGE_REQUEST_APPROL, "删除变更申请审批人");
                        });
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(newResIds))
                {
                    var resArr = newResIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    var srDal = new sys_resource_dal();
                    foreach (var resId in resArr)
                    {
                        var thisRes = srDal.FindNoDeleteById(long.Parse(resId));
                        if (thisRes == null)
                            continue;
                        var stop = new sdk_task_other_person()
                        {
                            id = stopDal.GetNextIdCom(),
                            task_id = ticketId,
                            create_time = timeNow,
                            update_time = timeNow,
                            create_user_id = userId,
                            update_user_id = userId,
                            resource_id = thisRes.id,
                            approve_status_id = (int)DicEnum.CHANGE_APPROVE_STATUS_PERSON.WAIT,
                        };
                        stopDal.Insert(stop);
                        OperLogBLL.OperLogAdd<sdk_task_other_person>(stop, stop.id, userId, OPER_LOG_OBJ_CATE.CHANGE_REQUEST_APPROL, "新增变更申请审批人");
                    }
                }
            }

            return true;
        }
        /// <summary>
        /// 审批变更申请
        /// </summary>
        public bool AppOther(long ticketId, long userId)
        {
            var stoDal = new sdk_task_other_dal();
            var thisOther = stoDal.GetTicketOther(ticketId);
            if (thisOther == null || thisOther.approve_status_id != (int)DicEnum.CHANGE_APPROVE_STATUS.ASSIGNED)
                return false;
            var oldOther = stoDal.GetTicketOther(ticketId);
            thisOther.approve_status_id = (int)DicEnum.CHANGE_APPROVE_STATUS.REQUESTED;
            thisOther.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisOther.update_user_id = userId;
            stoDal.Update(thisOther);
            OperLogBLL.OperLogUpdate<sdk_task_other>(thisOther, oldOther, thisOther.task_id, userId, OPER_LOG_OBJ_CATE.TICKET_RELATION, "编辑变更申请");
            return true;
        }
        /// <summary>
        /// 撤销申请审批
        /// </summary>
        public bool RevokeAppOther(long ticketId, long userId)
        {
            var stoDal = new sdk_task_other_dal();
            var stopDal = new sdk_task_other_person_dal();
            var thisOther = stoDal.GetTicketOther(ticketId);
            if (thisOther == null || thisOther.approve_status_id == (int)DicEnum.CHANGE_APPROVE_STATUS.NOT_ASSIGNED || thisOther.approve_status_id == (int)DicEnum.CHANGE_APPROVE_STATUS.ASSIGNED)
                return false;
            var oldOther = stoDal.GetTicketOther(ticketId);
            thisOther.approve_status_id = (int)DicEnum.CHANGE_APPROVE_STATUS.ASSIGNED;
            thisOther.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisOther.update_user_id = userId;
            stoDal.Update(thisOther);
            OperLogBLL.OperLogUpdate<sdk_task_other>(thisOther, oldOther, thisOther.task_id, userId, OPER_LOG_OBJ_CATE.TICKET_RELATION, "编辑变更申请");
            var oldPersonList = stopDal.GetTicketOther(ticketId);
            if (oldPersonList != null && oldPersonList.Count > 0)
            {
                var timeNow = thisOther.update_time;
                oldPersonList.ForEach(_ =>
                {
                    var old = stopDal.FindNoDeleteById(_.id);
                    _.update_time = timeNow;
                    _.update_user_id = userId;
                    _.approve_status_id = (int)DicEnum.CHANGE_APPROVE_STATUS_PERSON.WAIT;
                    _.oper_time = null;
                    _.description = null;
                    stopDal.Update(_);
                    OperLogBLL.OperLogUpdate<sdk_task_other_person>(_, old, _.id, userId, OPER_LOG_OBJ_CATE.CHANGE_REQUEST_APPROL, "编辑变更申请审批人");
                });
            }

            return true;
        }
        /// <summary>
        /// 审批 审批人信息
        /// </summary>
        public bool OtherPersonManage(long ticketId, int appStatus, string reason, long userId)
        {
            var stopDal = new sdk_task_other_person_dal();
            var thisOtherPerson = stopDal.GetPerson(ticketId, userId);
            if (thisOtherPerson == null)
                return false;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var oldPerson = stopDal.GetPerson(ticketId, userId);
            thisOtherPerson.approve_status_id = appStatus;
            // (int)DicEnum.CHANGE_APPROVE_STATUS_PERSON.APPROVED;
            thisOtherPerson.oper_time = timeNow;
            thisOtherPerson.description = reason;
            thisOtherPerson.update_time = timeNow;
            thisOtherPerson.update_user_id = userId;
            stopDal.Update(thisOtherPerson);
            OperLogBLL.OperLogUpdate<sdk_task_other_person>(thisOtherPerson, oldPerson, thisOtherPerson.id, userId, OPER_LOG_OBJ_CATE.CHANGE_REQUEST_APPROL, "编辑变更申请审批人");
            ChangeOtherStatus(ticketId, userId);
            return true;
        }

        /// <summary>
        /// 根据审批人的审批状态改变审批的状态
        /// </summary>
        public void ChangeOtherStatus(long ticketId, long userId)
        {
            var stoDal = new sdk_task_other_dal();
            var stopDal = new sdk_task_other_person_dal();
            var thisOther = stoDal.GetTicketOther(ticketId);
            if (thisOther == null)
                return;
            var personList = stopDal.GetTicketOther(ticketId);
            if (personList == null || personList.Count == 0)
                return;
            var oldStatus = thisOther.approve_status_id;
            if (thisOther.approval_type_id == (int)DicEnum.APPROVAL_TYPE.ALL_APPROVERS_MUST_APPROVE)
            {
                if (personList.Any(_ => _.approve_status_id == (int)DicEnum.CHANGE_APPROVE_STATUS_PERSON.REJECTED))
                    thisOther.approve_status_id = (int)DicEnum.CHANGE_APPROVE_STATUS.REJECTED;
                else if (personList.Any(_ => _.approve_status_id == (int)DicEnum.CHANGE_APPROVE_STATUS_PERSON.APPROVED) && personList.Any(_ => _.approve_status_id != (int)DicEnum.CHANGE_APPROVE_STATUS_PERSON.APPROVED))
                    thisOther.approve_status_id = (int)DicEnum.CHANGE_APPROVE_STATUS.PARCIALLY_APPROVED;
                else if (!personList.Any(_ => _.approve_status_id != (int)DicEnum.CHANGE_APPROVE_STATUS_PERSON.APPROVED))
                    thisOther.approve_status_id = (int)DicEnum.CHANGE_APPROVE_STATUS.APPROVED;
            }
            else if (thisOther.approval_type_id == (int)DicEnum.APPROVAL_TYPE.ONE_APPROVER_MUST_APPROVE)
            {
                if (personList.Any(_ => _.approve_status_id == (int)DicEnum.CHANGE_APPROVE_STATUS_PERSON.REJECTED))
                    thisOther.approve_status_id = (int)DicEnum.CHANGE_APPROVE_STATUS.REJECTED;
                else if (personList.Any(_ => _.approve_status_id == (int)DicEnum.CHANGE_APPROVE_STATUS_PERSON.APPROVED))
                    thisOther.approve_status_id = (int)DicEnum.CHANGE_APPROVE_STATUS.APPROVED;

            }

            if (oldStatus != thisOther.approve_status_id)
            {
                var oldOther = stoDal.GetTicketOther(ticketId);
                thisOther.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisOther.update_user_id = userId;
                stoDal.Update(thisOther);
                OperLogBLL.OperLogUpdate<sdk_task_other>(thisOther, oldOther, thisOther.task_id, userId, OPER_LOG_OBJ_CATE.TICKET_RELATION, "编辑变更申请");
            }
        }
        #endregion#

        #region 定期主工单 - 管理
        public bool AddMasterTicket(MasterTicketDto param, long userId)
        {
            try
            {
                #region 1 新增工单
                var thisTicket = param.masterTicket;
                if (thisTicket != null)
                {
                    thisTicket.no = new TaskBLL().ReturnTaskNo() + ".000";
                    thisTicket.type_id = (int)DicEnum.TASK_TYPE.RECURRING_TICKET_MASTER;
                    thisTicket.ticket_type_id = (int)DicEnum.TICKET_TYPE.SERVICE_REQUEST;
                    InsertTicket(thisTicket, userId);
                }
                else return false;
                // todo 保存自定义信息
                var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);  // 获取合同的自定义字段信息
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.TICKETS, userId,
                    thisTicket.id, udf_list, param.udfList, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK_INFORMATION);
                #endregion

                #region 2 定期主工单周期
                param.masterRecurr.task_id = thisTicket.id;
                AddTicketRecurr(param, userId);
                #endregion

                var subTicketList = _dal.GetSubTicket(param.masterTicket.id);
                #region 3 批量添加 备注
                if (!string.IsNullOrEmpty(param.noteTitle) && !string.IsNullOrEmpty(param.noteDescription) && param.noteTypeId != 0 && param.publishId != 0)
                {
                    AddMasterTicketNote(param.masterTicket.id, param.publishId, param.noteTypeId, param.noteTitle, param.noteDescription, userId);
                    if (subTicketList != null && subTicketList.Count > 0)
                        subTicketList.ForEach(_ =>
                        {
                            AddMasterTicketNote(_.id, param.publishId, param.noteTypeId, param.noteTitle, param.noteDescription, userId);
                        });
                }
                #endregion

                #region 4 批量添加 附件
                if (param.filtList != null && param.filtList.Count > 0)
                {
                    AddMasterTicketAtt(param.masterTicket.id, param.filtList, userId);
                    if (subTicketList != null && subTicketList.Count > 0)
                        subTicketList.ForEach(_ =>
                        {
                            AddMasterTicketAtt(_.id, param.filtList, userId);
                        });
                }
                #endregion

                #region 5 批量通知
                if(param.tempId != 0 && !string.IsNullOrEmpty(param.subject))
                {
                    var toMails = GetNotiEmails(param.masterTicket.id, param.ccMe, param.ccAccMan, param.ccOwn, param.ccCons, param.ccRes, param.otherEmail, userId);
                    if (!string.IsNullOrEmpty(toMails))
                    {
                        AddMasterTicketNotify(param.masterTicket.id, param.tempId, param.subject, param.appText, toMails, param.sendFromSys, userId);
                        if (subTicketList != null && subTicketList.Count > 0)
                            subTicketList.ForEach(_ =>
                            {
                                AddMasterTicketNotify(_.id, param.tempId, param.subject, param.appText, toMails, param.sendFromSys, userId);
                            });
                    }
                }
                #endregion

                // todo 服务预定
            }
            catch (Exception e)
            {
                return false;
            }
            return true;

        }
        /// <summary>
        /// 编辑定期主工单
        /// </summary>
        public bool EditMasterTicket(MasterTicketDto param, long userId)
        {
            // 修改周期，新增备注，附件，通知 服务预定（生成之后不能再次生成）
            var thisTicket = _dal.FindNoDeleteById(param.masterTicket.id);
            if (thisTicket == null)
                return false;
            EditMasterRecurr(param,userId);
            #region 同新增
            var subTicketList = _dal.GetSubTicket(param.masterTicket.id);
            #region 3 批量添加 备注
            if(!string.IsNullOrEmpty(param.noteTitle) &&!string.IsNullOrEmpty(param.noteDescription)&& param.noteTypeId !=0&& param.publishId != 0)
            {
                AddMasterTicketNote(param.masterTicket.id, param.publishId, param.noteTypeId, param.noteTitle, param.noteDescription, userId);
                if (subTicketList != null && subTicketList.Count > 0)
                    subTicketList.ForEach(_ =>
                    {
                        AddMasterTicketNote(_.id, param.publishId, param.noteTypeId, param.noteTitle, param.noteDescription, userId);
                    });
            }

            #endregion

            #region 4 批量添加 附件
            if (param.filtList != null && param.filtList.Count > 0)
            {
                AddMasterTicketAtt(param.masterTicket.id, param.filtList, userId);
                if (subTicketList != null && subTicketList.Count > 0)
                    subTicketList.ForEach(_ =>
                    {
                        AddMasterTicketAtt(_.id, param.filtList, userId);
                    });
            }
            #endregion

            #region 5 批量通知
            if (param.tempId != 0 && !string.IsNullOrEmpty(param.subject))
            {
                var toMails = GetNotiEmails(param.masterTicket.id, param.ccMe, param.ccAccMan, param.ccOwn, param.ccCons, param.ccRes, param.otherEmail, userId);
                if (!string.IsNullOrEmpty(toMails))
                {
                    AddMasterTicketNotify(param.masterTicket.id, param.tempId, param.subject, param.appText, toMails, param.sendFromSys, userId);
                    if (subTicketList != null && subTicketList.Count > 0)
                        subTicketList.ForEach(_ =>
                        {
                            AddMasterTicketNotify(_.id, param.tempId, param.subject, param.appText, toMails, param.sendFromSys, userId);
                        });
                }
            }
            #endregion

            #endregion
            return true;
        }
        /// <summary>
        /// 编辑主工单周期
        /// </summary>
        public bool EditMasterRecurr(MasterTicketDto param, long userId)
        {
            var srtDal = new sdk_recurring_ticket_dal();
            var oldTicketRec = srtDal.GetByTicketId(param.masterTicket.id);
            if (oldTicketRec == null)
                return false;
            var lastDate = Tools.Date.DateHelper.ConvertStringToDateTime(oldTicketRec.last_instance_due_datetime);
            var lastNo = oldTicketRec.last_instance_no.ToString();
            if (oldTicketRec.recurring_end_date != param.masterRecurr.recurring_end_date || oldTicketRec.recurring_instances != param.masterRecurr.recurring_instances)
            {
                switch (oldTicketRec.recurring_frequency)
                {
                    case (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.DAY:
                        EditTicketRecurrByDay(param.masterRecurr, userId,ref lastDate,ref lastNo);
                        break;
                    case (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.WEEK:
                        EditTicketRecurrByWeek(param.masterRecurr, userId, ref lastDate, ref lastNo);
                        break;
                    case (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.MONTH:
                        EditTicketRecurrByMonth(param.masterRecurr, userId, ref lastDate, ref lastNo);
                        break;
                    case (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.YEAR:
                        EditTicketRecurrByYear(param.masterRecurr, userId, ref lastDate, ref lastNo);
                        break;
                    default:
                        break;
                }
                oldTicketRec.recurring_end_date = param.masterRecurr.recurring_end_date;
                oldTicketRec.recurring_instances = param.masterRecurr.recurring_instances;
            }
            oldTicketRec.last_instance_due_datetime = Tools.Date.DateHelper.ToUniversalTimeStamp(lastDate);
            var lastNoArr = lastNo.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
            oldTicketRec.last_instance_no = int.Parse(lastNoArr[lastNoArr.Length - 1]);
            oldTicketRec.is_active = param.masterRecurr.is_active;
            oldTicketRec.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            oldTicketRec.update_user_id = userId;
            var olderRec = srtDal.GetByTicketId(param.masterTicket.id);
            srtDal.Update(oldTicketRec);
            OperLogBLL.OperLogUpdate<sdk_recurring_ticket>(oldTicketRec, olderRec, oldTicketRec.task_id, userId, OPER_LOG_OBJ_CATE.MASTER_TICKET, "编辑定期工单周期");

            return true;

        }
        /// <summary>
        /// 添加工单周期
        /// </summary>
        public bool AddTicketRecurr(MasterTicketDto param, long userId)
        {
            var thisRec = param.masterRecurr;
            thisRec.task_id = param.masterTicket.id;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            string addJson = "";
            var lastDate = thisRec.recurring_end_date??thisRec.recurring_start_date;
            var lastNo = param.masterTicket.no;
            switch (thisRec.recurring_frequency)
            {
                case (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.DAY:
                    AddTicketRecurrByDay(param, userId, ref lastDate, ref lastNo);
                    addJson = "{" + $"\"every\":\"{param.day_day}\",\"no_sat\":\"{(param.day_no_sat ? "1" : "0")}\",\"no_sun\":\"{(param.day_no_sun ? "1" : "0")}\"" + "}";
                    break;
                case (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.WEEK:
                    AddTicketRecurrByWeek(param, userId, ref lastDate, ref lastNo);
                    string days = "";
                    if (param.week_mon)
                        days += "1,";
                    if (param.week_tus)
                        days += "2,";
                    if (param.week_wed)
                        days += "3,";
                    if (param.week_thu)
                        days += "4,";
                    if (param.week_fri)
                        days += "5,";
                    if (param.week_sat)
                        days += "6,";
                    if (param.week_sun)
                        days += "7,";
                    if (!string.IsNullOrEmpty(days))
                        days = days.Substring(0, days.Length - 1);
                    addJson = "{" + $"\"every\":\"{param.week_week}\",\"dayofweek\":[{days}]" + "}";
                    break;
                case (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.MONTH:
                    AddTicketRecurrByMonth(param, userId, ref lastDate, ref lastNo);
                    if (param.month_type == "1")
                        addJson = "{" + $"\"month\":\"{param.month_month}\",\"day\":\"{param.month_day}\"," + "}";
                    else if (param.month_type == "2")
                    {
                        //string dateNo = "";
                        //if (param.month_week_num == "1")
                        //    dateNo = "1st";
                        //else if (param.month_week_num == "2")
                        //    dateNo = "2nd";
                        //else if (param.month_week_num == "3")
                        //    dateNo = "3rd";
                        //else if (param.month_week_num == "4")
                        //    dateNo = "4th";
                        //else if (param.month_week_num == "5")
                        //    dateNo = "last";
                        addJson = "{" + $"\"month\":\"{param.month_month}\",\"no\":\"{param.month_week_num}\",\"dayofweek\":\"{param.month_week_day}\"" + "}";
                    }
                    break;
                case (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.YEAR:
                    AddTicketRecurrByYear(param, userId, ref lastDate, ref lastNo);
                    if (param.year_type == "1")
                        addJson = "{" + $"\"month\":\"{param.year_month}\",\"day\":\"{param.year_month_day}\"," + "}";
                    else if (param.year_type == "2")
                    {
                        //string dateNo = "";
                        //if (param.year_month_week_num == "1")
                        //    dateNo = "1st";
                        //else if (param.year_month_week_num == "2")
                        //    dateNo = "2nd";
                        //else if (param.year_month_week_num == "3")
                        //    dateNo = "3rd";
                        //else if (param.year_month_week_num == "4")
                        //    dateNo = "4th";
                        //else if (param.year_month_week_num == "5")
                        //    dateNo = "last";
                        addJson = "{" + $"\"month\":\"{param.year_month}\",\"no\":\"{param.year_month_week_num}\",\"dayofweek\":\"{param.year_month_week_day}\"" + "}";
                    }
                    break;
                default:
                    break;
            }
            thisRec.recurring_define = addJson;
            thisRec.last_instance_due_datetime = Tools.Date.DateHelper.ToUniversalTimeStamp(lastDate);
            var lastNoArr = lastNo.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
            thisRec.last_instance_no = int.Parse(lastNoArr[lastNoArr.Length - 1]);
            thisRec.create_time = timeNow;
            thisRec.update_time = timeNow;
            thisRec.create_user_id = userId;
            thisRec.update_user_id = userId;
            new sdk_recurring_ticket_dal().Insert(thisRec);
            OperLogBLL.OperLogAdd<sdk_recurring_ticket>(thisRec, thisRec.task_id, userId, OPER_LOG_OBJ_CATE.MASTER_TICKET, "新增定期工单周期");
            return true;
        }
        /// <summary>
        /// 按天 添加子工单
        /// </summary>
        public void AddTicketRecurrByDay(MasterTicketDto param, long userId, ref DateTime lastDate, ref string lastNo)
        {
            var thisRec = param.masterRecurr;
            var firstDate = thisRec.recurring_start_date;  // 最开始的时间
            if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
            {
                var startDate = thisRec.recurring_start_date;
                var endDate = (DateTime)thisRec.recurring_end_date;
                TimeSpan ts1 = new TimeSpan(startDate.Ticks);
                TimeSpan ts2 = new TimeSpan(endDate.Ticks);
                var diffRec = ts1.Subtract(ts2).Duration().Days + 1;  // 获取到最大的添加 子工单
                for (int i = 0; i < diffRec; i++)
                {

                    if (param.day_no_sat || param.day_no_sun)
                    {
                        if (firstDate.DayOfWeek == DayOfWeek.Saturday && param.day_no_sat)
                            firstDate = firstDate.AddDays(1);
                        if (firstDate.DayOfWeek == DayOfWeek.Sunday && param.day_no_sun)
                            firstDate = firstDate.AddDays(1);
                    }
                    if (firstDate > endDate)
                        break;
                    else
                    {
                        AddSubTicket(param.masterTicket.id, userId, i + 1, firstDate, ref lastNo);
                        firstDate = firstDate.AddDays(param.day_day);
                        lastDate = firstDate;
                    }

                }
            }
            else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
            {
                for (int i = 0; i < thisRec.recurring_instances; i++)
                {

                    if (param.day_no_sat || param.day_no_sun)
                    {
                        if (firstDate.DayOfWeek == DayOfWeek.Saturday && param.day_no_sat)
                            firstDate = firstDate.AddDays(1);
                        if (firstDate.DayOfWeek == DayOfWeek.Sunday && param.day_no_sun)
                            firstDate = firstDate.AddDays(1);
                    }
                    AddSubTicket(param.masterTicket.id, userId, i + 1, firstDate, ref lastNo);
                    firstDate = firstDate.AddDays(param.day_day);
                    lastDate = firstDate;
                }
            }

        }
        /// <summary>
        /// 修改周期 -按天
        /// </summary>
        public void EditTicketRecurrByDay(sdk_recurring_ticket thisRec, long userId, ref DateTime lastDate, ref string lastNo)
        {
            var firstDate = Tools.Date.DateHelper.ConvertStringToDateTime(thisRec.last_instance_due_datetime).AddDays(1);
            int num = thisRec.last_instance_no + 1;
            int dayNums = 1;
            if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
            {
                var endDate = (DateTime)thisRec.recurring_end_date;
                TimeSpan ts1 = new TimeSpan(firstDate.Ticks);
                TimeSpan ts2 = new TimeSpan(endDate.Ticks);
                dayNums = ts1.Subtract(ts2).Duration().Days + 1;
            }
            else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
            {
                var oldRec = new sdk_recurring_ticket_dal().GetByTicketId(thisRec.task_id);
                dayNums = (int)thisRec.recurring_instances - (int)oldRec.recurring_instances;
            }
            var dayDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrDayDto>(thisRec.recurring_define);
            for (int i = 0; i < dayNums; i++)
            {

                if (dayDto.no_sat == 1 || dayDto.no_sun == 1)
                {
                    if (firstDate.DayOfWeek == DayOfWeek.Saturday && dayDto.no_sat == 1)
                        firstDate = firstDate.AddDays(1);
                    if (firstDate.DayOfWeek == DayOfWeek.Sunday && dayDto.no_sun == 1)
                        firstDate = firstDate.AddDays(1);
                }
                if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num > (int)thisRec.recurring_instances))
                    break;
                else
                {
                    AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                    firstDate = firstDate.AddDays(dayDto.every);
                    lastDate = firstDate;
                    num++;
                }

            }

        }
        /// <summary>
        /// 按周 添加子工单
        /// </summary>
        public void AddTicketRecurrByWeek(MasterTicketDto param, long userId, ref DateTime lastDate, ref string lastNo)
        {
            var thisRec = param.masterRecurr;
            var firstDate = thisRec.recurring_start_date;  // 最开始的时间

            int num = 1;
            int weekNums = 1;
            if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
            {
                var endDate = (DateTime)thisRec.recurring_end_date;
                weekNums = DiffWeek(thisRec.recurring_start_date, endDate);  // 获取到最大的添加 子工单
            }
            else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
                weekNums = (int)thisRec.recurring_instances;
            else return;
            for (int i = 0; i < weekNums; i++)
            {
                if (firstDate.DayOfWeek == DayOfWeek.Monday)
                {
                    if (param.week_mon)
                    {
                        AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Tuesday)
                {
                    if (param.week_tus)
                    {
                        AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Wednesday)
                {
                    if (param.week_wed)
                    {
                        AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Thursday)
                {
                    if (param.week_thu)
                    {
                        AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Friday)
                {
                    if (param.week_fri)
                    {
                        AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Saturday)
                {
                    if (param.week_sat)
                    {
                        AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Sunday)
                {
                    if (param.week_sun)
                    {
                        AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (param.week_week != 1)
                {
                    firstDate = firstDate.AddDays((param.week_week - 1) * 7);
                    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                        break;
                }
            }
        }
        /// <summary>
        /// 修改周期 -按周
        /// </summary>
        public void EditTicketRecurrByWeek(sdk_recurring_ticket thisRec, long userId, ref DateTime lastDate, ref string lastNo)
        {
            var firstDate = Tools.Date.DateHelper.ConvertStringToDateTime(thisRec.last_instance_due_datetime).AddDays(1);  // 最开始的时间
            int num = thisRec.last_instance_no + 1;
            int weekNums = 1;
            if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
            {
                var endDate = (DateTime)thisRec.recurring_end_date;
                weekNums = DiffWeek(firstDate, endDate);  // 获取到最大的添加 子工单
            }
            else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
            {
                var oldRec = new sdk_recurring_ticket_dal().GetByTicketId(thisRec.task_id);
                weekNums = (int)thisRec.recurring_instances - (int)oldRec.recurring_instances;
            }
            var weekDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrWeekDto>(thisRec.recurring_define);
            for (int i = 0; i < weekNums; i++)
            {
                if (firstDate.DayOfWeek == DayOfWeek.Monday)
                {
                    if (weekDto.dayofweek.Any(_ => _ == 1))
                    {
                        AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Tuesday)
                {
                    if (weekDto.dayofweek.Any(_ => _ == 2))
                    {
                        AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Wednesday)
                {
                    if (weekDto.dayofweek.Any(_ => _ == 3))
                    {
                        AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Thursday)
                {
                    if (weekDto.dayofweek.Any(_ => _ == 4))
                    {
                        AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Friday)
                {
                    if (weekDto.dayofweek.Any(_ => _ == 5))
                    {
                        AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Saturday)
                {
                    if (weekDto.dayofweek.Any(_ => _ == 6))
                    {
                        AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (firstDate.DayOfWeek == DayOfWeek.Sunday)
                {
                    if (weekDto.dayofweek.Any(_ => _ == 7))
                    {
                        AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                    firstDate = firstDate.AddDays(1);
                }
                if (weekDto.every != 1)
                {
                    firstDate = firstDate.AddDays((weekDto.every - 1) * 7);
                    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                        break;
                }
            }

        }
        /// <summary>
        /// 按月 添加子工单
        /// </summary>
        public void AddTicketRecurrByMonth(MasterTicketDto param, long userId, ref DateTime lastDate, ref string lastNo)
        {
            var thisRec = param.masterRecurr;
            var firstDate = thisRec.recurring_start_date;  // 最开始的时间

            int num = 1;
            int monthNums = 1;
            if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
            {
                var endDate = (DateTime)thisRec.recurring_end_date;
                monthNums = (((DateTime)thisRec.recurring_end_date).Year - thisRec.recurring_start_date.Year) * 12 + (((DateTime)thisRec.recurring_end_date).Month - thisRec.recurring_start_date.Month) + 1;
            }
            else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
                monthNums = (int)thisRec.recurring_instances + 1;
            else return;
            if (param.month_type == "1")
            {
                for (int i = 0; i < monthNums; i++)
                {
                    int tiaoMonth = 0;
                    int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);  // 当月的天数
                    if (param.month_day <= days)
                    {
                        if (firstDate.Day > param.month_day)
                        {
                            firstDate = firstDate.AddDays(days - firstDate.Day + 1);
                            tiaoMonth = 1;
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                        }
                        else
                        {
                            firstDate = firstDate.AddDays(param.month_day - firstDate.Day);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                            firstDate = firstDate.AddDays(days - firstDate.Day + 1);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                        }
                    }
                    else
                    {
                        firstDate = firstDate.AddDays(days - firstDate.Day);
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;

                        AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        firstDate = firstDate.AddDays(1);
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }

                    if (param.month_month > 1)
                    {
                        firstDate = firstDate.AddMonths(param.month_month - 1 - tiaoMonth);
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                }
            }
            else if (param.month_type == "2")
            {
                for (int i = 0; i < monthNums; i++)
                {
                    int tiaoMonth = 0;
                    var choDays = ReturnDayInMonth(firstDate, param.month_week_num, param.month_week_day);
                    if (choDays == 0)
                        return;
                    int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);  // 当月的天数
                    if (choDays <= days)
                    {
                        if (firstDate.Day > choDays)
                        {
                            firstDate = firstDate.AddDays(days - firstDate.Day + 1);
                            tiaoMonth = 1;
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                        }
                        else
                        {
                            firstDate = firstDate.AddDays(choDays - firstDate.Day);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                            firstDate = firstDate.AddDays(days - firstDate.Day + 1);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                        }
                    }
                    //else
                    //{
                    //    firstDate = firstDate.AddDays(days - firstDate.Day);
                    //    AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                    //    lastDate = firstDate;
                    //    num++;
                    //    firstDate = firstDate.AddDays(1);
                    //    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                    //        break;
                    //}
                    if (param.month_month > 1)
                    {
                        firstDate = firstDate.AddMonths(param.month_month - 1 - tiaoMonth);
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                }
            }
        }
        /// <summary>
        /// 修改周期 -按月
        /// </summary>
        public void EditTicketRecurrByMonth(sdk_recurring_ticket thisRec, long userId, ref DateTime lastDate, ref string lastNo)
        {
            var firstDate = Tools.Date.DateHelper.ConvertStringToDateTime(thisRec.last_instance_due_datetime).AddDays(1);  // 最开始的时间
            int num = thisRec.last_instance_no + 1;
            int monthNums = 1;
            if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
            {
                var endDate = (DateTime)thisRec.recurring_end_date;
                monthNums = (((DateTime)thisRec.recurring_end_date).Year - firstDate.Year) * 12 + (((DateTime)thisRec.recurring_end_date).Month - firstDate.Month) + 1;
            }
            else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
            {
                var oldRec = new sdk_recurring_ticket_dal().GetByTicketId(thisRec.task_id);
                monthNums = (int)thisRec.recurring_instances - (int)oldRec.recurring_instances;
            }
            var monthDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrMonthDto>(thisRec.recurring_define);
            if (monthDto.day != 0)
            {
                for (int i = 0; i < monthNums; i++)
                {
                    int tiaoMonth = 0;
                    int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);  // 当月的天数
                    if (monthDto.day <= days)
                    {
                        if (firstDate.Day > monthDto.day)
                        {
                            firstDate = firstDate.AddDays(days - firstDate.Day + 1);
                            tiaoMonth = 1;
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                        }
                        else
                        {
                            firstDate = firstDate.AddDays(monthDto.day - firstDate.Day);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                            firstDate = firstDate.AddDays(days - firstDate.Day + 1);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                        }
                    }
                    else
                    {
                        firstDate = firstDate.AddDays(days - firstDate.Day);
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;

                        AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                        firstDate = firstDate.AddDays(1);
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }

                    if (monthDto.month > 1)
                    {
                        firstDate = firstDate.AddMonths(monthDto.month - 1 - tiaoMonth);
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                }
            }
            else 
            {
                for (int i = 0; i < monthNums; i++)
                {
                    int tiaoMonth = 0;
                    var choDays = ReturnDayInMonth(firstDate, monthDto.no, monthDto.dayofweek);
                    if (choDays == 0)
                        return;
                    int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);  // 当月的天数
                    if (choDays <= days)
                    {
                        if (firstDate.Day > choDays)
                        {
                            firstDate = firstDate.AddDays(days - firstDate.Day + 1);
                            tiaoMonth = 1;
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                        }
                        else
                        {
                            firstDate = firstDate.AddDays(choDays - firstDate.Day);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                            firstDate = firstDate.AddDays(days - firstDate.Day + 1);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                        }
                    }
                    //else
                    //{
                    //    firstDate = firstDate.AddDays(days - firstDate.Day);
                    //    AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                    //    lastDate = firstDate;
                    //    num++;
                    //    firstDate = firstDate.AddDays(1);
                    //    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                    //        break;
                    //}
                    if (monthDto.month > 1)
                    {
                        firstDate = firstDate.AddMonths(monthDto.month - 1 - tiaoMonth);
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                    }
                }
            }
        }
        /// <summary>
        /// 按年 添加子工单
        /// </summary>
        public void AddTicketRecurrByYear(MasterTicketDto param, long userId, ref DateTime lastDate, ref string lastNo)
        {
            var thisRec = param.masterRecurr;
            var firstDate = thisRec.recurring_start_date;  // 最开始的时间
            int num = 1;
            int yearNums = 1;
            int yearMonth = int.Parse(param.year_month);   // 代表选择的是第几月
            if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
                yearNums = ((DateTime)thisRec.recurring_end_date).Year - thisRec.recurring_start_date.Year + 1;
            else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
                yearNums = (int)thisRec.recurring_instances + 1;
            if (param.year_type == "1")
            {
                for (int i = 0; i < yearNums; i++)
                {
                    if (i == 0)
                    {
                        if (firstDate.Month < yearMonth)
                        {
                            firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearMonth.ToString("#00") + "-01");
                            int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);
                            if (days > param.year_month_day)
                                firstDate = firstDate.AddDays(param.year_month_day - 1);
                            else
                                firstDate = firstDate.AddDays(days - 1);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                        }
                        else if (firstDate.Month == yearMonth)
                        {
                            if (firstDate.Day < param.year_month_day)
                            {
                                int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);
                                if (days > param.year_month_day)
                                    firstDate = firstDate.AddDays(param.year_month_day - 1);
                                else
                                    firstDate = firstDate.AddDays(days - 1);
                                AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                                lastDate = firstDate;
                                num++;
                            }
                        }
                    }
                    else if (i == yearNums - 1)
                    {
                        if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
                        {
                            var endDate = (DateTime)thisRec.recurring_end_date;
                            if (endDate.Month > yearMonth)
                            {
                                firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearMonth.ToString("#00") + "-01");
                                int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);
                                if (days > param.year_month_day)
                                    firstDate = firstDate.AddDays(param.year_month_day - 1);
                                else
                                    firstDate = firstDate.AddDays(days - 1);
                                if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                    break;
                                AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                                lastDate = firstDate;
                                num++;
                            }
                            else if (endDate.Month == yearMonth)
                            {
                                if (endDate.Day >= param.year_month_day)
                                {
                                    firstDate = DateTime.Parse(endDate.Year.ToString("#0000") + "-" + yearMonth.ToString("#00") + "-" + param.year_month_day.ToString("#00"));
                                    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                        break;
                                    AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                                    lastDate = firstDate;
                                    num++;
                                }

                            }
                        }
                        else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
                        {
                            firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearMonth.ToString("#00") + "-01");
                            int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);
                            if (days > param.year_month_day)
                                firstDate = firstDate.AddDays(param.year_month_day - 1);
                            else
                                firstDate = firstDate.AddDays(days - 1);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                        }
                    }
                    else
                    {
                        firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearMonth.ToString("#00") + "-01");
                        int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);
                        if (days > param.year_month_day)
                            firstDate = firstDate.AddDays(param.year_month_day - 1);
                        else
                            firstDate = firstDate.AddDays(days - 1);
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                        AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                    }
                    firstDate = DateTime.Parse(firstDate.AddYears(1).Year.ToString("#0000") + "-01-" + "01");
                    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                        break;
                }
            }
            else if (param.year_type == "2")
            {
                for (int i = 0; i < yearNums; i++)
                {
                    var choDays = ReturnDayInMonth(firstDate, param.year_month_week_num, param.year_month_week_day);
                    if (choDays == 0)
                        return;
                    if (i == 0)
                    {
                        if (firstDate.Month < yearMonth)
                        {
                            firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearMonth.ToString("#00") + "-" + choDays.ToString("#00"));
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                        }
                        else if (firstDate.Month == yearMonth)
                        {
                            if (firstDate.Day < choDays)
                            {

                                firstDate = firstDate.AddDays(choDays - firstDate.Day);
                                if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                    break;
                                AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                                lastDate = firstDate;
                                num++;
                            }
                        }
                    }
                    else if (i == yearNums - 1)
                    {
                        if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
                        {
                            var endDate = (DateTime)thisRec.recurring_end_date;
                            if (endDate.Month > yearMonth)
                            {
                                firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearMonth.ToString("#00") + "-" + choDays.ToString("#00"));
                                if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                    break;
                                AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                                lastDate = firstDate;
                                num++;
                            }
                            else if (endDate.Month == yearMonth)
                            {
                                if (endDate.Day >= choDays)
                                {
                                    firstDate = DateTime.Parse(endDate.Year.ToString("#0000") + "-" + yearMonth.ToString("#00") + "-" + choDays.ToString("#00"));
                                    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                        break;
                                    AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                                    lastDate = firstDate;
                                    num++;
                                }

                            }
                        }
                        else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
                        {
                            firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearMonth.ToString("#00") + "-" + choDays.ToString("#00"));
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                        }
                    }
                    else
                    {
                        firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearMonth.ToString("#00") + "-" + choDays.ToString("#00"));
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                        AddSubTicket(param.masterTicket.id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                    }
                    firstDate = DateTime.Parse(firstDate.AddYears(1).Year.ToString("#0000") + "-" + yearMonth.ToString("#00") + "-" + "01");
                    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                        break;
                }
            }

        }
        /// <summary>
        /// 修改周期 -按年
        /// </summary>
        public void EditTicketRecurrByYear(sdk_recurring_ticket thisRec, long userId, ref DateTime lastDate, ref string lastNo)
        {
            var firstDate = Tools.Date.DateHelper.ConvertStringToDateTime(thisRec.last_instance_due_datetime).AddDays(1);  // 最开始的时间
            int num = thisRec.last_instance_no + 1;
            int yearNums = 1;
            if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
                yearNums = ((DateTime)thisRec.recurring_end_date).Year - firstDate.Year + 1;
            else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
            {
                var oldRec = new sdk_recurring_ticket_dal().GetByTicketId(thisRec.task_id);
                yearNums = (int)thisRec.recurring_instances - (int)oldRec.recurring_instances;
            }
            var yearDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrMonthDto>(thisRec.recurring_define);
            if (yearDto.day != 0)
            {
                for (int i = 0; i < yearNums; i++)
                {
                    if (i == 0)
                    {
                        if (firstDate.Month < yearDto.month)
                        {
                            firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearDto.month.ToString("#00") + "-01");
                            int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);
                            if (days > yearDto.day)
                                firstDate = firstDate.AddDays(yearDto.day - 1);
                            else
                                firstDate = firstDate.AddDays(days - 1);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                        }
                        else if (firstDate.Month == yearDto.month)
                        {
                            if (firstDate.Day < yearDto.day)
                            {
                                int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);
                                if (days > yearDto.day)
                                    firstDate = firstDate.AddDays(yearDto.day - 1);
                                else
                                    firstDate = firstDate.AddDays(days - 1);
                                AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                                lastDate = firstDate;
                                num++;
                            }
                        }
                    }
                    else if (i == yearNums - 1)
                    {
                        if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
                        {
                            var endDate = (DateTime)thisRec.recurring_end_date;
                            if (endDate.Month > yearDto.month)
                            {
                                firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearDto.month.ToString("#00") + "-01");
                                int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);
                                if (days > yearDto.day)
                                    firstDate = firstDate.AddDays(yearDto.day - 1);
                                else
                                    firstDate = firstDate.AddDays(days - 1);
                                if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                    break;
                                AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                                lastDate = firstDate;
                                num++;
                            }
                            else if (endDate.Month == yearDto.month)
                            {
                                if (endDate.Day >= yearDto.day)
                                {
                                    firstDate = DateTime.Parse(endDate.Year.ToString("#0000") + "-" + yearDto.month.ToString("#00") + "-" + yearDto.day.ToString("#00"));
                                    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                        break;
                                    AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                                    lastDate = firstDate;
                                    num++;
                                }

                            }
                        }
                        else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
                        {
                            firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearDto.month.ToString("#00") + "-01");
                            int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);
                            if (days > yearDto.day)
                                firstDate = firstDate.AddDays(yearDto.day - 1);
                            else
                                firstDate = firstDate.AddDays(days - 1);
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                        }
                    }
                    else
                    {
                        firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearDto.month.ToString("#00") + "-01");
                        int days = DateTime.DaysInMonth(firstDate.Year, firstDate.Month);
                        if (days > yearDto.day)
                            firstDate = firstDate.AddDays(yearDto.day - 1);
                        else
                            firstDate = firstDate.AddDays(days - 1);
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                        AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                    }
                    firstDate = DateTime.Parse(firstDate.AddYears(1).Year.ToString("#0000") + "-01-" + "01");
                    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                        break;
                }
            }
            else 
            {
                for (int i = 0; i < yearNums; i++)
                {
                    var choDays = ReturnDayInMonth(firstDate, yearDto.no, yearDto.dayofweek);
                    if (choDays == 0)
                        return;
                    if (i == 0)
                    {
                        if (firstDate.Month < yearDto.month)
                        {
                            firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearDto.month.ToString("#00") + "-" + choDays.ToString("#00"));
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                        }
                        else if (firstDate.Month == yearDto.month)
                        {
                            if (firstDate.Day < choDays)
                            {

                                firstDate = firstDate.AddDays(choDays - firstDate.Day);
                                if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                    break;
                                AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                                lastDate = firstDate;
                                num++;
                            }
                        }
                    }
                    else if (i == yearNums - 1)
                    {
                        if (thisRec.recurring_end_date != null && thisRec.recurring_instances == null)
                        {
                            var endDate = (DateTime)thisRec.recurring_end_date;
                            if (endDate.Month > yearDto.month)
                            {
                                firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearDto.month.ToString("#00") + "-" + choDays.ToString("#00"));
                                if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                    break;
                                AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                                lastDate = firstDate;
                                num++;
                            }
                            else if (endDate.Month == yearDto.month)
                            {
                                if (endDate.Day >= choDays)
                                {
                                    firstDate = DateTime.Parse(endDate.Year.ToString("#0000") + "-" + yearDto.month.ToString("#00") + "-" + choDays.ToString("#00"));
                                    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                        break;
                                    AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                                    lastDate = firstDate;
                                    num++;
                                }

                            }
                        }
                        else if (thisRec.recurring_end_date == null && thisRec.recurring_instances != null)
                        {
                            firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearDto.month.ToString("#00") + "-" + choDays.ToString("#00"));
                            if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                                break;
                            AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                            lastDate = firstDate;
                            num++;
                        }
                    }
                    else
                    {
                        firstDate = DateTime.Parse(firstDate.Year.ToString("#0000") + "-" + yearDto.month.ToString("#00") + "-" + choDays.ToString("#00"));
                        if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                            break;
                        AddSubTicket(thisRec.task_id, userId, num, firstDate, ref lastNo);
                        lastDate = firstDate;
                        num++;
                    }
                    firstDate = DateTime.Parse(firstDate.AddYears(1).Year.ToString("#0000") + "-" + yearDto.month.ToString("#00") + "-" + "01");
                    if ((thisRec.recurring_end_date != null && firstDate > thisRec.recurring_end_date) || (thisRec.recurring_instances != null && num >= (int)thisRec.recurring_instances))
                        break;
                }
            }
        }
        /// <summary>
        /// 保存子工单信息
        /// </summary>
        public bool AddSubTicket(long parTicketId, long userId, int num, DateTime dueTime, ref string lastNo)
        {
            var thisSubTicket = _dal.FindNoDeleteById(parTicketId);
            if (thisSubTicket == null)
                return false;
            thisSubTicket.no = thisSubTicket.no + "." + num.ToString("#000");
            lastNo = thisSubTicket.no;
            thisSubTicket.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(dueTime);
            thisSubTicket.ticket_type_id = (int)DicEnum.TICKET_TYPE.SERVICE_REQUEST;
            thisSubTicket.type_id = (int)DicEnum.TASK_TYPE.SERVICE_DESK_TICKET;
            thisSubTicket.last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisSubTicket.recurring_ticket_id = parTicketId;
            return InsertTicket(thisSubTicket, userId);
        }
        /// <summary>
        /// 为工单 添加备注
        /// </summary>
        public bool AddMasterTicketNote(long ticketId, long publishId, long noteType, string title, string description, long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return false;
            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(description) || publishId == 0 || noteType == 0)
                return false;
            var activity = new com_activity()
            {
                id = _dal.GetNextIdCom(),
                cate_id = (int)DicEnum.ACTIVITY_CATE.TICKET_NOTE,
                action_type_id = (int)noteType,
                object_id = ticketId,
                object_type_id = (int)OBJECT_TYPE.TICKETS,
                account_id = thisTicket.account_id,
                contact_id = thisTicket.contact_id,
                resource_id = thisTicket.owner_resource_id,
                contract_id = thisTicket.contract_id,
                name = title,
                description = description,
                publish_type_id = (int)publishId,
                ticket_id = ticketId,
                create_user_id = userId,
                update_user_id = userId,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                is_system_generate = 0,
            };
            new com_activity_dal().Insert(activity);
            OperLogBLL.OperLogAdd<com_activity>(activity, activity.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");
            return true;
        }
        /// <summary>
        /// 为工单 添加附件
        /// </summary>
        public bool AddMasterTicketAtt(long ticketId, List<AddFileDto> fileList, long userId)
        {
            if (fileList == null || fileList.Count <= 0)
                return false;
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return false;
            var attBll = new AttachmentBLL();
            foreach (var thisFile in fileList)
            {
                if (thisFile.type_id == ((int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())

                    attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.TASK, ticketId, (int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT, thisFile.new_filename, "", thisFile.old_filename, thisFile.fileSaveName, thisFile.conType, thisFile.Size, userId);
                else
                    attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.TASK, ticketId, int.Parse(thisFile.type_id), thisFile.new_filename, thisFile.old_filename, null, null, null, 0, userId);
            }
            return true;
        }
        /// <summary>
        /// 获取邮箱地址
        /// </summary>
        /// <returns></returns>
        public string GetNotiEmails(long ticketId, bool ccMe, bool ccAccMan, bool ccOwn, string conIds, string resIds, string otherMails, long userId)
        {
            List<string> allEmails = new List<string>();
            var ticket = _dal.FindNoDeleteById(ticketId);
            if (ticket == null)
                return "";
            var srDal = new sys_resource_dal();
            var ccDal = new crm_contact_dal();
            if (ccMe)
            {
                var meUser = srDal.FindNoDeleteById(userId);
                if (meUser != null && !string.IsNullOrEmpty(meUser.email) && (!allEmails.Contains(meUser.email)))
                    allEmails.Add(meUser.email);
            }
            var account = new CompanyBLL().GetCompany(ticket.account_id);
            if (account != null && account.resource_id != null && ccAccMan)
            {
                var accMan = srDal.FindNoDeleteById((long)account.resource_id);
                if (accMan != null && !string.IsNullOrEmpty(accMan.email) && (!allEmails.Contains(accMan.email)))
                    allEmails.Add(accMan.email);
            }
            if (ticket.owner_resource_id != null && ccOwn)
            {
                var own = srDal.FindNoDeleteById((long)ticket.owner_resource_id);
                if (own != null && !string.IsNullOrEmpty(own.email) && (!allEmails.Contains(own.email)))
                    allEmails.Add(own.email);
            }

            if (!string.IsNullOrEmpty(conIds))
            {
                var conList = ccDal.GetContactByIds(conIds);
                if (conList != null && conList.Count > 0)
                    conList.ForEach(_ =>
                    {
                        if (!string.IsNullOrEmpty(_.email) && (!allEmails.Contains(_.email)))
                            allEmails.Add(_.email);
                    });
            }

            if (!string.IsNullOrEmpty(resIds))
            {
                var resList = srDal.GetListByIds(resIds);
                if (resList != null && resList.Count > 0)
                    resList.ForEach(_ =>
                    {
                        if (!string.IsNullOrEmpty(_.email) && (!allEmails.Contains(_.email)))
                            allEmails.Add(_.email);
                    });
            }
            if (!string.IsNullOrEmpty(otherMails))
            {
                var otherArr = otherMails.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var other in otherArr)
                {
                    if (!string.IsNullOrEmpty(other) && (!allEmails.Contains(other)))
                        allEmails.Add(other);
                }
            }

            if (allEmails.Count > 0)
            {
                var emails = "";
                allEmails.ForEach(_ => { emails += _ + ','; });
                if (emails != "")
                    emails = emails.Substring(0, emails.Length);
                return emails;
            }
            else return "";

        }
        /// <summary>
        /// 为工单 添加通知
        /// </summary>
        public bool AddMasterTicketNotify(long ticketId, int tempId, string subject, string desc, string toEmail, bool fromSys, long userId)
        {
            var thisUser = new sys_resource_dal().FindNoDeleteById(userId);
            if (thisUser == null)
                return false;
            var emaslList = new sys_notify_tmpl_email_dal().GetEmailByTempId(tempId);
            var cneDal = new com_notify_email_dal();
            var email = new com_notify_email()
            {
                id = cneDal.GetNextIdCom(),
                cate_id = (int)NOTIFY_CATE.SERVICE_DESK,
                event_id = (int)NOTIFY_EVENT.RECURRENCE_MASTER_CREATED_EDITED,
                create_user_id = userId,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = userId,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                to_email = toEmail,
                notify_tmpl_id = tempId,
                from_email = fromSys ? "" : thisUser.email,
                from_email_name = fromSys ? "" : thisUser.name,
                body_text = (emaslList != null && emaslList.Count > 0 ? emaslList[0].body_text : "") + desc,
                subject = subject,

            };
            cneDal.Insert(email);
            OperLogBLL.OperLogAdd<com_notify_email>(email, email.id, userId, OPER_LOG_OBJ_CATE.NOTIFY, "新增通知");
            return true;
        }
        /// <summary>
        /// 删除定期主工单  isDeleFuture 是否删除未过期工单   true 表示全部删除 false 不删除过期
        /// </summary>
        public bool DeleteMaster(long ticketId,long userId,bool isDeleFuture, ref Dictionary<string, int> result,bool isDelMaster = true)
        {
            result.Add("delete",0);
            result.Add("no_delete", 0);
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return true;
            string faileReason;
            var subTicket = _dal.GetSubTicket(ticketId);
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if(subTicket!=null&& subTicket.Count > 0)
            {
                foreach (var sub in subTicket)
                {
                    if(sub.estimated_end_time< timeNow && isDeleFuture)
                    {
                        result["no_delete"] += 1;
                        continue;
                    }
                    var res = DeleteTicket(sub.id, userId, out faileReason);
                    if (res)
                        result["delete"] += 1;
                    else
                        result["no_delete"] += 1;
                }
            }

            var isDeletPar = false;
            if(result["no_delete"]==0)
                isDeletPar = DeleteTicket(ticketId, userId, out faileReason);
            return isDeletPar;
        }// DeleteTickresultet
        /// <summary>
        /// 获取该工单下的所有未开始的工单的Ids
        /// </summary>
        public string GetFutureIds(long ticketId)
        {
            string ids = "";
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return "";
            var subTicket = _dal.GetSubTicket(ticketId);
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (subTicket != null && subTicket.Count > 0)
            {
                foreach (var sub in subTicket)
                {
                    if (sub.estimated_end_time > timeNow )
                    {
                        ids += sub.id.ToString() + ",";
                    }
                    
                }
            }
            if (!string.IsNullOrEmpty(ids))
                ids = ids.Substring(0, ids.Length-1);
            return ids;
        }
        /// <summary>
        /// 工单周期状态 激活/失活 管理
        /// </summary>
        public bool RecTicketActiveManage(long ticketId, bool isActive, long userId)
        {
            var srtDal = new sdk_recurring_ticket_dal();
            var thisRec = srtDal.GetByTicketId(ticketId);
            if (thisRec == null)
                return false;
            if (thisRec.is_active == ((sbyte)(isActive ? 1 : 0)))
                return true;
            var oldRec = srtDal.GetByTicketId(ticketId);
            thisRec.is_active = (sbyte)(isActive ? 1 : 0);
            thisRec.update_user_id = userId;
            thisRec.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            srtDal.Update(thisRec);
            OperLogBLL.OperLogAdd<sdk_recurring_ticket>(thisRec, thisRec.task_id, userId, OPER_LOG_OBJ_CATE.MASTER_TICKET, "编辑定期工单周期");
            return true;
        }
        #endregion

        /// <summary>
        /// 根据Ids 获取相应工单并删除
        /// </summary>
        public bool DeleteTicketByIds(string ids,long userId)
        {
            var ticketList = _dal.GetTicketByIds(ids);
            if(ticketList!=null&& ticketList.Count > 0)
            {
                string faileReason = "";
                int failNum = 0;
                ticketList.ForEach(_ => {
                   var result = DeleteTicket(_.id, userId, out faileReason);
                    if (!result)
                        failNum++;
                });
                return failNum == 0;
            }
            return true;
        }

        /// <summary>
        /// 获取两个时间相差多少周
        /// </summary>
        public int DiffWeek(DateTime start, DateTime end)
        {
            int diffWeek = 1;
            var firstSunDay = start.AddDays(7 - (int)start.DayOfWeek);
            if (start.DayOfWeek == DayOfWeek.Sunday)
                firstSunDay = start;
            if (firstSunDay > end)
                return 1;
            else
            {
                TimeSpan ts1 = new TimeSpan(firstSunDay.Ticks);
                TimeSpan ts2 = new TimeSpan(end.Ticks);
                var diffRec = ts1.Subtract(ts2).Duration().Days + 1;
                diffWeek = diffWeek + (diffRec / 7);
                var yushu = diffRec % 7;
                if (yushu > 0)
                    diffWeek += 1;
            }
            return diffWeek;
        }
        /// <summary>
        /// 根据第几周的星期几 返回这一天是几号
        /// </summary>
        /// <param name="date"></param>
        /// <param name="weekNum"></param>
        /// <param name="weekDay"></param>
        /// <returns></returns>
        public int ReturnDayInMonth(DateTime date, string weekNum, string weekDay)
        {
            var firstDay = date.AddDays(0 - date.Day + 1);
            var monthDays = DateTime.DaysInMonth(date.Year, date.Month);
            if (weekDay == "7")
            {
                if (weekNum == "last")
                    return monthDays;
                else
                    return int.Parse(weekNum);
            }
            else if (weekDay == "8")
            {
                int num = 1;
                switch (weekNum)
                {
                    case "2nd":
                        num = 2;
                        break;
                    case "3rd":
                        num = 3;
                        break;
                    case "4th":
                        num = 4;
                        break;
                    default:
                        break;
                }

                if (weekNum == "last")
                {
                    for (int i = monthDays; i > 0; i--)
                    {
                        var thisDay = firstDay.AddDays(i - 1);
                        if (thisDay.DayOfWeek != DayOfWeek.Saturday && thisDay.DayOfWeek != DayOfWeek.Sunday)
                            return thisDay.Day;
                    }
                }
                else
                {
                    for (int i = 0; i < num; i++)
                    {
                        if (firstDay.DayOfWeek == DayOfWeek.Saturday)
                            firstDay = firstDay.AddDays(1);
                        if (firstDay.DayOfWeek == DayOfWeek.Sunday)
                            firstDay = firstDay.AddDays(1);
                        firstDay = firstDay.AddDays(1);
                    }
                    return firstDay.Day;
                }

            }
            else if (weekNum != "last")
            {
                int times = 0;
                for (int i = 0; i < monthDays; i++)
                {
                    var newDay = firstDay.AddDays(i);
                    if ((int)newDay.DayOfWeek == int.Parse(weekDay))
                    {
                        times++;
                        if (times == int.Parse(weekNum))
                        {
                            return newDay.Day;
                        }
                    }

                }
            }
            else
            {
                for (int i = monthDays; i > 0; i--)
                {
                    var thisDay = firstDay.AddDays(i - 1);
                    if ((int)thisDay.DayOfWeek == int.Parse(weekDay))
                        return thisDay.Day;
                }
            }
            return 0;
        }
        /// <summary>
        /// 获取工单相关数量
        /// </summary>
        public Dictionary<string,string> GetTicketTypeCount(long userId)
        {
            var dic = new Dictionary<string, string>();
            var actCount = _dal.GetTicketCount(false, $"  and status_id <> {(int)DicEnum.TICKET_STATUS.DONE} and (owner_resource_id = {userId}||EXISTS(SELECT 1 from sdk_task_resource r where r.task_id = t.id and r.resource_id={userId}))");
            var actRecCount = _dal.GetTicketCount(true, $" and status_id <> {(int)DicEnum.TICKET_STATUS.DONE} and (owner_resource_id = {userId}||EXISTS(SELECT 1 from sdk_task_resource r where r.task_id = t.id and r.resource_id={userId}))");
            dic.Add("open", $"({actCount}+{actRecCount})");
            var overCount = _dal.GetTicketCount(false, $" and estimated_end_time<(unix_timestamp(now()) *1000) and (owner_resource_id = {userId}||EXISTS(SELECT 1 from sdk_task_resource r where r.task_id = t.id and r.resource_id={userId}))");
            var overRecCount = _dal.GetTicketCount(true, $" and estimated_end_time<(unix_timestamp(now()) *1000) and (owner_resource_id = {userId}||EXISTS(SELECT 1 from sdk_task_resource r where r.task_id = t.id and r.resource_id={userId}))");
            dic.Add("over", $"({overCount}+{overRecCount})");
            var myCount = _dal.GetTicketCount(false, $" and t.create_user_id = {userId}");
            var myRecCount = _dal.GetTicketCount(true, $" and t.create_user_id = {userId}");
            dic.Add("my", $"({myCount+ myRecCount})");
            var completeCount = _dal.GetTicketCount(false, " and status_id = "+(int)DicEnum.TICKET_STATUS.DONE+ $" and (owner_resource_id = {userId}||EXISTS(SELECT 1 from sdk_task_resource r where r.task_id = t.id and r.resource_id={userId}))");
            var completeRecCount = _dal.GetTicketCount(true, " and status_id = "+(int)DicEnum.TICKET_STATUS.DONE+ $" and (owner_resource_id = {userId}||EXISTS(SELECT 1 from sdk_task_resource r where r.task_id = t.id and r.resource_id={userId}))");
            dic.Add("complete", $"({completeCount}+{completeRecCount})");

            var changeCount = Convert.ToInt32(_dal.GetSingle("SELECT COUNT(DISTINCT st.id)  from sdk_task st INNER JOIN sdk_task_relation str on  st.id = str.parent_task_id where st.delete_time = 0 and str.delete_time = 0 "+ $" and (st.owner_resource_id = {userId}||EXISTS(SELECT 1 from sdk_task_resource r where r.task_id = st.id and r.resource_id={userId}))"));
            dic.Add("change", $"({changeCount})");

            var resDepList = new sys_resource_department_dal().GetRolesBySource(userId, DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE);
            if(resDepList!=null&& resDepList.Count > 0)
            {
                foreach (var resDep in resDepList)
                {
                    var depCount = _dal.GetTicketCount(false, "  and status_id<>1894  and department_id =" + resDep.department_id);
                    var depRecCount = _dal.GetTicketCount(true, "  and status_id<>1894  and department_id =" + resDep.department_id);
                    dic.Add("dep_"+ resDep.department_id, $"({depCount}+{depRecCount})");

                    var noResCount = _dal.GetTicketCount(false, "  and status_id<>1894  and department_id =" + resDep.department_id+ " and not EXISTS(SELECT 1 from sdk_task_resource r where t.id = r.task_id and r.delete_time = 0 and  r.resource_id is not null ) and owner_resource_id is null ");
                    var noResRecCount = _dal.GetTicketCount(true, "  and status_id<>1894  and department_id =" + resDep.department_id + " and not EXISTS(SELECT 1 from sdk_task_resource r where t.id = r.task_id and r.delete_time = 0 and  r.resource_id is not null ) and owner_resource_id is null ");
                    dic.Add("noRes_" + resDep.department_id, $"({noResCount}+{noResRecCount})");
                }
            }
            return dic;
        }

        #region 服务预定相关
        /// <summary>
        /// 新增服务预定
        /// </summary>
        public bool AddServiceCall(ServiceCallDto param,long userId)
        {
            var sscDal = new sdk_service_call_dal();
            if (param.call == null)
                return false;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            param.call.id = sscDal.GetNextIdCom();
            param.call.create_time = timeNow;
            param.call.update_time = timeNow;
            param.call.create_user_id = userId;
            param.call.update_user_id = userId;
            sscDal.Insert(param.call);
            OperLogBLL.OperLogAdd<sdk_service_call>(param.call, param.call.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL, "新增服务预定");
            CallTicketManage(param.call.id,param.ticketIds, userId);
            return true;
        }
        /// <summary>
        /// 编辑服务预定
        /// </summary>
        public bool EditServiceCall(ServiceCallDto param, long userId)
        {
            var sscDal = new sdk_service_call_dal();
            var oldSer = sscDal.FindNoDeleteById(param.call.id);
            if (oldSer == null)
                return false;
            param.call.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            param.call.update_user_id = userId;
            sscDal.Update(param.call);
            OperLogBLL.OperLogUpdate<sdk_service_call>(param.call, oldSer, param.call.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL, "编辑服务预定");
            CallTicketManage(param.call.id, param.ticketIds, userId);
            return true;
        }

        /// <summary>
        /// 添加服务预定工单
        /// </summary>
        public void CallTicketManage(long callId, string ticketIds, long userId)
        {
            var ssctDal = new sdk_service_call_task_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var oldTicketCallList = ssctDal.GetTaskCall(callId);
            if(oldTicketCallList!=null&& oldTicketCallList.Count > 0)
            {
                if (!string.IsNullOrEmpty(ticketIds))
                {
                    var ticArr = ticketIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var ticId in ticArr)
                    {
                        var firstTickCall = oldTicketCallList.FirstOrDefault(_=>_.task_id==long.Parse(ticId));
                        if (firstTickCall != null)
                        {
                            oldTicketCallList.Remove(firstTickCall);
                            continue;
                        }
                        else
                        {
                            var thisTicket = _dal.FindNoDeleteById(long.Parse(ticId));
                            if (thisTicket == null)
                                continue;
                            var taskRes = ssctDal.GetSingTaskCall(callId, thisTicket.id);
                            if (taskRes != null)
                                continue;
                            taskRes = new sdk_service_call_task()
                            {
                                id = ssctDal.GetNextIdCom(),
                                create_time = timeNow,
                                create_user_id = userId,
                                service_call_id = callId,
                                task_id = thisTicket.id,
                                update_time = timeNow,
                                update_user_id = userId,
                            };
                            ssctDal.Insert(taskRes);
                            OperLogBLL.OperLogAdd<sdk_service_call_task>(taskRes, taskRes.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_TICKET, "新增服务预定关联工单");
                            AddCallTicketRes(taskRes, userId);
                        }
                            
                    }
                }
                if(oldTicketCallList.Count>0)
                    oldTicketCallList.ForEach(_ => {
                        DeleteTaicktCall(callId, _.task_id, userId);
                    });
            }
            else
            {
                if (!string.IsNullOrEmpty(ticketIds))
                {
                    var ticArr = ticketIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var ticId in ticArr)
                    {
                        var thisTicket = _dal.FindNoDeleteById(long.Parse(ticId));
                        if (thisTicket == null)
                            continue;
                        var taskRes = ssctDal.GetSingTaskCall(callId, thisTicket.id);
                        if (taskRes != null)
                            continue;
                        taskRes = new sdk_service_call_task()
                        {
                            id = ssctDal.GetNextIdCom(),
                            create_time = timeNow,
                            create_user_id = userId,
                            service_call_id = callId,
                            task_id = thisTicket.id,
                            update_time = timeNow,
                            update_user_id = userId,
                        };
                        ssctDal.Insert(taskRes);
                        OperLogBLL.OperLogAdd<sdk_service_call_task>(taskRes, taskRes.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_TICKET, "新增服务预定关联工单");
                        AddCallTicketRes(taskRes, userId);
                    }
                }
            }
           
        }
        /// <summary>
        /// 添加服务预定负责人
        /// </summary>
        public void AddCallTicketRes(sdk_service_call_task param,long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(param.task_id);
            if (thisTicket == null)
                return;
            var ssctrDal = new sdk_service_call_task_resource_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (thisTicket.owner_resource_id != null)
            {
                var ssct = new sdk_service_call_task_resource() {
                    id = ssctrDal.GetNextIdCom(),
                    create_time = timeNow,
                    create_user_id = userId,
                    resource_id = (long)thisTicket.owner_resource_id,
                    service_call_task_id = param.id,
                    update_time = timeNow,
                    update_user_id = userId,
                };
                ssctrDal.Insert(ssct);
                OperLogBLL.OperLogAdd<sdk_service_call_task_resource>(ssct, ssct.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_RESOURCE, "新增服务预定负责人");
            }
            var sdrDal = new sdk_task_resource_dal();
            var resList = sdrDal.GetResByTaskId(param.task_id);
            if(resList!=null&& resList.Count > 0)
            {
                foreach (var res in resList)
                {
                    if (res.resource_id == null)
                        continue;
                    var ssct = new sdk_service_call_task_resource()
                    {
                        id = ssctrDal.GetNextIdCom(),
                        create_time = timeNow,
                        create_user_id = userId,
                        resource_id = (long)res.resource_id,
                        service_call_task_id = param.id,
                        update_time = timeNow,
                        update_user_id = userId,
                    };
                    ssctrDal.Insert(ssct);
                    OperLogBLL.OperLogAdd<sdk_service_call_task_resource>(ssct, ssct.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_RESOURCE, "新增服务预定负责人");
                }
            }
        }
        /// <summary>
        /// 删除服务预定工单
        /// </summary>
        public bool DeleteTaicktCall(long callId, long ticketId,long userId)
        {
            var ssctDal = new sdk_service_call_task_dal();
            var thisCall = ssctDal.GetSingTaskCall(callId,ticketId);
            if (thisCall == null)
                return true;
            DeleteCallRes(thisCall.id,userId);
            ssctDal.SoftDelete(thisCall,userId);
            OperLogBLL.OperLogDelete<sdk_service_call_task>(thisCall, thisCall.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_TICKET, "删除服务预定关联工单");
            return true;
        }
        /// <summary>
        /// 删除服务预定负责人
        /// </summary>
        public bool DeleteCallRes(long callTaskId,long userId)
        {
            var ssctrDal = new sdk_service_call_task_resource_dal();
            var list = ssctrDal.GetTaskResList(callTaskId);
            if (list != null && list.Count > 0)
                list.ForEach(_ => {
                    ssctrDal.SoftDelete(_,userId);
                    OperLogBLL.OperLogDelete<sdk_service_call_task_resource>(_, _.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_RESOURCE, "删除服务预定负责人");
                });
            return true;
        }

        /// <summary>
        /// 校验工单是否有负责人
        /// </summary>
        public bool IsHasRes(long ticketId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return false;
            if (thisTicket.owner_resource_id != null)
                return true;
            else
            {
                var resList = new sdk_task_resource_dal().GetResByTaskId(thisTicket.id);
                if (resList != null && resList.Count > 0 && resList.Any(_ => _.resource_id != null))
                    return true;
                else
                    return false;
                
            }
        }
        /// <summary>
        /// 是否有指定的负责人
        /// </summary>
        public bool IsHasRes(long ticketId,long resId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return false;
            if (thisTicket.owner_resource_id == resId)
                return true;
            else
            {
                var resList = new sdk_task_resource_dal().GetResByTaskId(thisTicket.id);
                if (resList != null && resList.Count > 0 && resList.Any(_ => _.resource_id == resId))
                    return true;
                else
                    return false;

            }
        }
        /// <summary>
        /// 获取指定时间内有服务预定的负责人名称
        /// </summary>
        public List<sys_resource> GetResNameByTime(long ticketId,long start,long end)
        {
            var resStringList = new List<sys_resource>();
            var srDal = new sys_resource_dal();  // GetResByTime
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket != null)
            {
                if (thisTicket.owner_resource_id != null)
                {
                    var res = srDal.GetResByTime((long)thisTicket.owner_resource_id,start,end);
                    if (res != null)
                        resStringList.Add(res);
                }
                var resList = new sdk_task_resource_dal().GetResByTaskId(thisTicket.id);
                if (resList != null && resList.Count > 0)
                {
                    foreach (var thisRes in resList)
                    {
                        if (thisRes.resource_id == null)
                            continue;
                        var res = srDal.GetResByTime((long)thisRes.resource_id, start, end);
                        if (res != null)
                            resStringList.Add(res);
                    }
                }
            }
            return resStringList;
        }
        /// <summary>
        /// 获取工单负责人的相关名称
        /// </summary>
        public string GetResName(long ticketId)
        {
            string name = "";
            var srDal = new sys_resource_dal();  // GetResByTime
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket != null)
            {
                if (thisTicket.owner_resource_id != null)
                {
                    var res = srDal.FindNoDeleteById((long)thisTicket.owner_resource_id);
                    if (res != null)
                        name += res.name + ',';
                }
                var resList = new sdk_task_resource_dal().GetResByTaskId(thisTicket.id);
                if (resList != null && resList.Count > 0)
                {
                    foreach (var thisRes in resList)
                    {
                        if (thisRes.resource_id == null)
                            continue;
                        var res = srDal.FindNoDeleteById((long)thisRes.resource_id);
                        if (res != null)
                            name += res.name + ',';
                    }
                }
            }
            if (!string.IsNullOrEmpty(name))
                name = name.Substring(0,name.Length-1);
            return name;
        }
        /// <summary>
        /// 服务预定工单联系人管理
        /// </summary>
        public void CallTicketResManage(long callTicketId,string resIds,long userId)
        {
            var ssctrDal = new sdk_service_call_task_resource_dal();
            var ssctDal = new sdk_service_call_task_dal();
            var srDal = new sys_resource_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var thisCallTicket = ssctDal.FindNoDeleteById(callTicketId);
            if (thisCallTicket == null)
                return;

            var oldTicketCallResList = ssctrDal.GetTaskResList(callTicketId);
            if (oldTicketCallResList != null && oldTicketCallResList.Count > 0)
            {
                if (!string.IsNullOrEmpty(resIds))
                {
                    var resArr = resIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var resId in resArr)
                    {
                        var firstTickCall = oldTicketCallResList.FirstOrDefault(_ => _.resource_id == long.Parse(resId));
                        if (firstTickCall != null)
                        {
                            oldTicketCallResList.Remove(firstTickCall);
                            continue;
                        }
                        else
                        {
                            var sysRes = srDal.FindNoDeleteById(long.Parse(resId));
                            if (sysRes == null)
                                continue;
                            var taskRes = ssctrDal.GetSingResCall(callTicketId, sysRes.id);
                            if (taskRes != null)
                                continue;
                            var ssct = new sdk_service_call_task_resource()
                            {
                                id = ssctrDal.GetNextIdCom(),
                                create_time = timeNow,
                                create_user_id = userId,
                                resource_id = sysRes.id,
                                service_call_task_id = callTicketId,
                                update_time = timeNow,
                                update_user_id = userId,
                            };
                            ssctrDal.Insert(ssct);
                            OperLogBLL.OperLogAdd<sdk_service_call_task_resource>(ssct, ssct.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_RESOURCE, "新增服务预定负责人");
                        }

                    }
                }
                if (oldTicketCallResList.Count > 0)
                    oldTicketCallResList.ForEach(_ => {
                        ssctrDal.SoftDelete(_, userId);
                        OperLogBLL.OperLogDelete<sdk_service_call_task_resource>(_, _.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_RESOURCE, "删除服务预定负责人");
                    });
            }
            else
            {
                if (!string.IsNullOrEmpty(resIds))
                {
                    var resArr = resIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var resId in resArr)
                    {
                       
                        var sysRes = srDal.FindNoDeleteById(long.Parse(resId));
                        if (sysRes == null)
                            continue;
                        var taskRes = ssctrDal.GetSingResCall(callTicketId, sysRes.id);
                        if (taskRes != null)
                            continue;
                        var ssct = new sdk_service_call_task_resource()
                        {
                            id = ssctrDal.GetNextIdCom(),
                            create_time = timeNow,
                            create_user_id = userId,
                            resource_id = sysRes.id,
                            service_call_task_id = callTicketId,
                            update_time = timeNow,
                            update_user_id = userId,
                        };
                        ssctrDal.Insert(ssct);
                        OperLogBLL.OperLogAdd<sdk_service_call_task_resource>(ssct, ssct.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_RESOURCE, "新增服务预定负责人");
                        
                    }
                }
            }
        }
        /// <summary>
        /// 删除服务预定
        /// </summary>
        public bool DeleteCall(long callId,long userId)
        {
            var sscDal = new sdk_service_call_dal();
            var thisCall = sscDal.FindNoDeleteById(callId);
            if (thisCall != null)
            {
                sscDal.SoftDelete(thisCall, userId);
                OperLogBLL.OperLogDelete<sdk_service_call>(thisCall, thisCall.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL, "删除服务预定");
            }
            return true;
        }
        /// <summary>
        /// 完成服务预定
        /// </summary>
        public  bool DoneCall(long callId, long userId)
        {
            var sscDal = new sdk_service_call_dal();
            var thisCall = sscDal.FindNoDeleteById(callId);
            if (thisCall == null)
                return false;
            if (thisCall.status_id == (int)DicEnum.SERVICE_CALL_STATUS.DONE)
                return true;
            var oldCall = sscDal.FindNoDeleteById(callId);
            thisCall.status_id = (int)DicEnum.SERVICE_CALL_STATUS.DONE;
            thisCall.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisCall.update_user_id = userId;
            sscDal.Update(thisCall);
            OperLogBLL.OperLogUpdate<sdk_service_call>(thisCall, oldCall, thisCall.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL, "编辑服务预定");
            return true;
        }
        /// <summary>
        /// 获取服务预定的工单的Id
        /// </summary>
        public string GetCallTicketIds(long callId)
        {
            var thisCall = new sdk_service_call_dal().FindNoDeleteById(callId);
            if (thisCall == null)
                return "";
            var ticketList = _dal.GetTciketByCall(thisCall.id);
            var ids = "";
            if(ticketList!=null&& ticketList.Count > 0)
                ticketList.ForEach(_ => {
                    ids += _.id.ToString() + ',';
                });
            if (!string.IsNullOrEmpty(ids))
                ids = ids.Substring(0, ids.Length-1);
            return ids;
        }
        /// <summary>  
        /// 新增服务预定
        /// </summary>
        public bool TaskCallAdd(TaskServiceCallDto param,long userId)
        {
            if (param.thisTicket == null)
                return false;
            if (param.isAddCall&&param.thisCall!=null)
            {
                var sscDal = new sdk_service_call_dal();
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                param.thisCall.id = sscDal.GetNextIdCom();
                param.thisCall.create_time = timeNow;
                param.thisCall.update_time = timeNow;
                param.thisCall.create_user_id = userId;
                param.thisCall.update_user_id = userId;
                sscDal.Insert(param.thisCall);
                OperLogBLL.OperLogAdd<sdk_service_call>(param.thisCall, param.thisCall.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL, "新增服务预定");
                var ssctDal = new sdk_service_call_task_dal();
                var taskRes = new sdk_service_call_task()
                {
                    id = ssctDal.GetNextIdCom(),
                    create_time = timeNow,
                    create_user_id = userId,
                    service_call_id = param.thisCall.id,
                    task_id = param.thisTicket.id,
                    update_time = timeNow,
                    update_user_id = userId,
                };
                ssctDal.Insert(taskRes);
                OperLogBLL.OperLogAdd<sdk_service_call_task>(taskRes, taskRes.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_TICKET, "新增服务预定关联工单");
                CallTicketResManage(taskRes.id,param.resIds,userId);
            }
            CallTaskManage(param.thisTicket.id,param.callIds,userId);
            AddCallNotify(param,userId);
            return true;
        }
        /// <summary>
        /// 新增服务预定
        /// </summary>
        public bool AddCallOnly(sdk_service_call param,long userId)
        {
            var sscDal = new sdk_service_call_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            param.id = sscDal.GetNextIdCom();
            param.create_time = timeNow;
            param.update_time = timeNow;
            param.create_user_id = userId;
            param.update_user_id = userId;
            sscDal.Insert(param);
            OperLogBLL.OperLogAdd<sdk_service_call>(param, param.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SERVICE_CALL, "新增服务预定");
            return true;
        }

        /// <summary>
        /// 工单的 服务预定（ 新增--）
        /// </summary>
        public void CallTaskManage(long ticketId,string callIds,long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return;
            var ssctDal = new sdk_service_call_task_dal();
            var sscDal = new sdk_service_call_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            #region  页面上获取的只是该客户下的服务预定，不能与所有服务预定进行比较
            //var oldCallList = ssctDal.GetTaskCallByTask(ticketId);
            //if(oldCallList!=null&& oldCallList.Count > 0)
            //{
            //    if (!string.IsNullOrEmpty(callIds))
            //    {
            //        var callArr = callIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            //        foreach (var callId in callArr)
            //        {
            //            var taskRes = oldCallList.FirstOrDefault(_=>_.task_id ==ticketId&&_.service_call_id.ToString()==callId);
            //            if (taskRes != null)
            //            {
            //                oldCallList.Remove(taskRes);
            //                continue;
            //            }
            //            var call = sscDal.FindNoDeleteById(long.Parse(callId));
            //            if (call == null)
            //                continue;
            //            taskRes = new sdk_service_call_task()
            //            {
            //                id = ssctDal.GetNextIdCom(),
            //                create_time = timeNow,
            //                create_user_id = userId,
            //                service_call_id = call.id,
            //                task_id = ticketId,
            //                update_time = timeNow,
            //                update_user_id = userId,
            //            };
            //            ssctDal.Insert(taskRes);
            //            OperLogBLL.OperLogAdd<sdk_service_call_task>(taskRes, taskRes.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_TICKET, "新增服务预定关联工单");
            //        }
            //    }
            //    oldCallList.ForEach(_ => {
            //        ssctDal.SoftDelete(_,userId);
            //        OperLogBLL.OperLogDelete<sdk_service_call_task>(_, _.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_TICKET, "删除服务预定关联工单");
            //    });
            //}
            //else
            //{
            //    if (!string.IsNullOrEmpty(callIds))
            //    {
            //        var callArr = callIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
            //        foreach (var callId in callArr)
            //        {
            //            var call = sscDal.FindNoDeleteById(long.Parse(callId));
            //            if (call == null)
            //                continue;
            //            var taskRes = ssctDal.GetSingTaskCall(call.id,ticketId);
            //            if (taskRes != null)
            //                continue;
            //            taskRes = new sdk_service_call_task()
            //            {
            //                id = ssctDal.GetNextIdCom(),
            //                create_time = timeNow,
            //                create_user_id = userId,
            //                service_call_id = call.id,
            //                task_id = ticketId,
            //                update_time = timeNow,
            //                update_user_id = userId,
            //            };
            //            ssctDal.Insert(taskRes);
            //            OperLogBLL.OperLogAdd<sdk_service_call_task>(taskRes, taskRes.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_TICKET, "新增服务预定关联工单");
            //        }
            //    }
            //}
            #endregion
            if (!string.IsNullOrEmpty(callIds))
            {
                var callArr = callIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var callId in callArr)
                {
                    var call = sscDal.FindNoDeleteById(long.Parse(callId));
                    if (call == null)
                        continue;
                    var taskRes = ssctDal.GetSingTaskCall(call.id, ticketId);
                    if (taskRes != null)
                        continue;
                    taskRes = new sdk_service_call_task()
                    {
                        id = ssctDal.GetNextIdCom(),
                        create_time = timeNow,
                        create_user_id = userId,
                        service_call_id = call.id,
                        task_id = ticketId,
                        update_time = timeNow,
                        update_user_id = userId,
                    };
                    ssctDal.Insert(taskRes);
                    OperLogBLL.OperLogAdd<sdk_service_call_task>(taskRes, taskRes.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL_TICKET, "新增服务预定关联工单");
                }
            }
        }

        /// <summary>
        /// 编辑服务预定
        /// </summary>
        public bool TaskCallEdit(TaskServiceCallDto param, long userId)
        {
            if (param.thisTicket == null||param.thisCall==null)
                return false;
            var sscDal = new sdk_service_call_dal();
            var oldCall = sscDal.FindNoDeleteById(param.thisCall.id);
            if (oldCall == null)
                return false;
            param.thisCall.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            param.thisCall.update_user_id = userId;
            sscDal.Update(param.thisCall);
            OperLogBLL.OperLogUpdate<sdk_service_call>(param.thisCall, oldCall, param.thisCall.id, userId, OPER_LOG_OBJ_CATE.SERVICE_CALL, "编辑服务预定");
            var thisCallTask = new sdk_service_call_task_dal().GetSingTaskCall(param.thisCall.id, param.thisTicket.id);
            if (thisCallTask != null)
                CallTicketResManage(thisCallTask.id, param.resIds, userId);
            AddCallNotify(param, userId);
            return true;
        }
        
        /// <summary>
        /// 新增服务预定的通知相关
        /// </summary>
        public void AddCallNotify(TaskServiceCallDto param,long userId)
        {
            if (param.notiTempId == 0)
                return;
            var thisTemp = new sys_notify_tmpl_dal().FindNoDeleteById(param.notiTempId);
            if (thisTemp == null)
                return;
            var srDal = new sys_resource_dal();
            var thisUser = srDal.FindNoDeleteById(userId);
            if (thisUser == null)
                return;
           
            var ccDal = new crm_contact_dal();
            var tempEmail = new sys_notify_tmpl_email_dal().GetEmailByTempId(thisTemp.id);
            StringBuilder emails = new StringBuilder();
            if (!string.IsNullOrEmpty(param.notiResIds))
            {
                var resArr = param.notiResIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                foreach (var res in resArr)
                {
                    var thisRes = srDal.FindNoDeleteById(long.Parse(res));
                    if (thisRes != null&&!string.IsNullOrEmpty(thisRes.email))
                        emails.Append(thisRes.id.ToString()+';');
                }
            }
            if (!string.IsNullOrEmpty(param.notiConIds))
            {
                var resArr = param.notiConIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var res in resArr)
                {
                    var thisCon = ccDal.FindNoDeleteById(long.Parse(res));
                    if (thisCon != null && !string.IsNullOrEmpty(thisCon.email))
                        emails.Append(thisCon.email.ToString() + ';');
                }
            }
            if(!string.IsNullOrEmpty(param.otherEmail))
                emails.Append(param.otherEmail);
            var cneDal = new com_notify_email_dal();
            var email = new com_notify_email()
            {
                id = cneDal.GetNextIdCom(),
                cate_id = (int)NOTIFY_CATE.SERVICE_BOOK,
                event_id = (int)NOTIFY_EVENT.SERVICE_CALL_CREATED_EDITED,
                create_user_id = userId,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = userId,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                to_email = emails.ToString(),   
                notify_tmpl_id = (int)param.notiTempId,  // 根据通知模板
                from_email = param.sendBySys ?"": thisUser.email,
                from_email_name = param.sendBySys ?"": thisUser.name,
                body_text = (tempEmail!=null&& tempEmail.Count>0?tempEmail[0].body_text:"")+ param.appText,
                //body_html = tempEmail[0].body_html,
                subject = param.subject,

            };
            cneDal.Insert(email);
            OperLogBLL.OperLogAdd<com_notify_email>(email, email.id, userId, OPER_LOG_OBJ_CATE.NOTIFY, "新增通知");
        }
        /// <summary>
        /// 获取员工在某一时间的服务预定
        /// </summary>
        public List<sdk_service_call> GetCallByResDate(long resId,DateTime date)
        {
            var thisTimeStamp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
            return _dal.FindListBySql<sdk_service_call>($"SELECT ssc.* from sdk_service_call ssc INNER JOIN sdk_service_call_task ssct on ssc.id = ssct.service_call_id INNER JOIN sdk_service_call_task_resource ssctr on ssct.id = ssctr.service_call_task_id where ssc.delete_time = 0 and ssct.delete_time = 0 and ssctr.delete_time = 0 and ssctr.resource_id = {resId} and (FROM_UNIXTIME(ssc.start_time / 1000, '%Y-%m-%d') = '{date.ToString("yyyy-MM-dd")}' or (start_time<={thisTimeStamp} and end_time>={thisTimeStamp}))");
        }
        /// <summary>
        /// 获取某一时间无负责人的 服务预定
        /// </summary>
        public List<sdk_service_call> GetNoResCallByDate(DateTime date)
        {
            var thisTimeStamp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
            return _dal.FindListBySql<sdk_service_call>($"SELECT ssc.* from sdk_service_call ssc where not EXISTS (SELECT 1 from sdk_service_call_task ssct , sdk_service_call_task_resource ssctr where  ssct.id = ssctr.service_call_task_id and ssc.id = ssct.service_call_id and ssct.delete_time = 0 and ssctr.delete_time = 0) and delete_time = 0 and (FROM_UNIXTIME(ssc.start_time / 1000, '%Y-%m-%d') = '{date.ToString("yyyy-MM-dd")}' or (start_time<={thisTimeStamp} and end_time>={thisTimeStamp}))");
        }
        #endregion


    }
}
