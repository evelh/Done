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
                #endregion

                #region 2 新增自定义信息
                var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);  // 获取合同的自定义字段信息
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.TICKETS, userId,
                    thisTicket.id, udf_list, param.udfList, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK_INFORMATION);
                #endregion

                #region 3 工单其他负责人
                TicketResManage(thisTicket.id, param.resDepIds, userId);
                #endregion

                #region 4 检查单信息
                CheckManage(param.ckList, thisTicket.id,userId);
                #endregion

                #region 5 发送邮件相关
                SendTicketEmail(param,userId);
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
                if (oldTicket.status_id== (int)DicEnum.TICKET_STATUS.DONE&& updateTicket.status_id!= (int)DicEnum.TICKET_STATUS.DONE)
                {
                    updateTicket.reopened_count = (oldTicket.reopened_count ?? 0) + 1;
                    updateTicket.date_completed = null;
                    updateTicket.reason = param.repeatReason;
                    isRepeat = true;
                }
                // 完成判断
                if(oldTicket.status_id != (int)DicEnum.TICKET_STATUS.DONE && updateTicket.status_id == (int)DicEnum.TICKET_STATUS.DONE)
                {
                    updateTicket.date_completed = timeNow;
                    updateTicket.reason = param.completeReason;
                    isComplete = true;
                    if (param.isAppSlo)
                    {
                        updateTicket.resolution = (oldTicket.resolution ?? "") + updateTicket.resolution;
                    }
                }
                if(oldTicket.sla_id==null&& updateTicket.sla_id != null)
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
                    TicketSlaEvent(updateTicket,userId);
                }
                EditTicket(updateTicket,userId);
                // 添加活动信息
                if (isComplete)
                {
                    AddCompleteActive(updateTicket,userId);
                }
                // 添加活动信息
                if (isRepeat)
                {
                    AddCompleteActive(updateTicket, userId,true);
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
            {
                ticket.sla_start_time = timeNow;
            }
            ticket.id = _dal.GetNextIdCom();
            ticket.create_time = timeNow;
            ticket.create_user_id = user_id;
            ticket.update_time = timeNow;
            ticket.update_user_id = user_id;
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
                if(ckList!=null&& ckList.Count > 0)
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
        public void AddCompleteActive(sdk_task ticket,long userId,bool isRepeat = false)
        {
            if(ticket!=null&& (ticket.status_id == (int)DicEnum.TICKET_STATUS.DONE|| isRepeat))
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
                    name = isRepeat? "重新打开原因" : "完成原因",
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
                OperLogBLL.OperLogAdd<com_activity>(activity, activity.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, isRepeat?"重新打开工单":"完成工单");
            }
            
        }
        /// <summary>
        /// 改变检查单的状态
        /// </summary>
        public bool ChangeCheckIsCom(long ckId,bool icCom,long userId)
        {
            var result = false;
            var stcDal = new sdk_task_checklist_dal();
            var thisCk = stcDal.FindNoDeleteById(ckId);
            var newIsCom = (sbyte)(icCom?1:0);
            if(thisCk!=null&& thisCk.is_competed!= newIsCom)
            {
                var oldCk = stcDal.FindNoDeleteById(ckId);
                thisCk.is_competed = newIsCom;
                thisCk.update_user_id = userId;
                thisCk.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                stcDal.Update(thisCk);
                OperLogBLL.OperLogUpdate<sdk_task_checklist>(thisCk, oldCk, thisCk.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST,"修改检查单");
                result = true;
            }
            return result;

        }

        /// <summary>
        /// 新增工单备注
        /// </summary>
        public bool AddTicketNote(TaskNoteDto param,long ticket_id, long user_id)
        {
            try
            {
                var thisTicket = _dal.FindNoDeleteById(ticket_id);
                if (thisTicket == null)
                    return false;
                if (thisTicket.status_id != (int)DicEnum.TICKET_STATUS.DONE && thisTicket.status_id != param.status_id)
                {
                    thisTicket.status_id = param.status_id;
                    EditTicket(thisTicket,user_id);
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
        public bool DeleteTicket(long ticketId,long userId,out string failReason)
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
                if(entryList!=null&& entryList.Count > 0)
                {
                    couldDelete = false;
                    failReason += "工单有工时，不能删除;";
                }

                var expList = new sdk_expense_dal().GetExpByTaskId(thisTicket.id);
                if(expList!=null&& expList.Count > 0)
                {
                    couldDelete = false;
                    failReason += "工单有费用，不能删除;";
                }

                var costList = new ctt_contract_cost_dal().GetListByTicketId(thisTicket.id);
                if(costList!=null&& costList.Count > 0)
                {
                    couldDelete = false;
                    failReason += "工单有成本，不能删除;";
                }

                if (couldDelete)
                {
                    #region 删除工单间关联关系
                    var subTicketList = new sdk_task_dal().GetTaskByParentId(thisTicket.id);
                    if(subTicketList!=null&& subTicketList.Count > 0)
                    {
                        foreach (var subTicket in subTicketList)
                        {
                            subTicket.parent_id = null;
                            EditTicket(subTicket,userId);
                        }
                    }
                    #endregion

                    #region 删除备注 
                    var caDal = new com_activity_dal();
                    var actList = caDal.GetActiList(" and ticket_id="+ thisTicket.id.ToString());
                    if(actList!=null&& actList.Count > 0)
                    {
                        actList.ForEach(_ => {
                            caDal.SoftDelete(_,userId);
                            OperLogBLL.OperLogDelete<com_activity>(_,_.id,userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY,"删除活动");
                        });
                    }
                    #endregion

                    #region 删除附件
                    var comAttDal = new com_attachment_dal();
                    var attList = comAttDal.GetAttListByOid(thisTicket.id);
                    if(attList!=null&& attList.Count > 0)
                    {
                        attList.ForEach(_ => {
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
                    if(otherList!=null&& otherList.Count > 0)
                    {
                        otherList.ForEach(_ => {
                            stoDal.SoftDelete(_,userId);
                            OperLogBLL.OperLogDelete<sdk_task_other>(_, _.id, userId, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK, "删除工单");
                        });
                    }
                    #endregion


                    #region 删除审批人信息
                    var stopDal = new sdk_task_other_person_dal();
                    var appList = stopDal.GetTicketOther(thisTicket.id);
                    if (appList != null && appList.Count > 0)
                    {
                        appList.ForEach(_ => {
                            stopDal.SoftDelete(_, userId);
                            OperLogBLL.OperLogDelete<sdk_task_other_person>(_, _.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TICKET_SERVICE_REQUEST, "删除审批人");
                        });
                    }
                    #endregion


                    #region 删除工单信息

                    _dal.SoftDelete(thisTicket,userId);
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
        public void TicketSlaEvent(sdk_task thisTicket,long userId)
        {
            var statusGeneral = new d_general_dal().FindNoDeleteById(thisTicket.status_id);
            if (thisTicket.sla_id != null&& statusGeneral!=null)
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
                    thisTaskSla.first_response_elapsed_hours = GetDiffHours((long)thisTicket.sla_start_time,timeNow);
                }
                if(thisTicket.resolution_plan_actual_time!=null && statusGeneral.ext1 == ((int)SLA_EVENT_TYPE.RESOLUTIONPLAN).ToString())
                {
                    thisTaskSla.resolution_plan_resource_id = userId;
                    thisTaskSla.resolution_plan_elapsed_hours = GetDiffHours((long)thisTicket.resolution_plan_actual_time,timeNow);
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
                        if(oldStatusGeneral.ext1 != ((int)SLA_EVENT_TYPE.WAITINGCUSTOMER).ToString() && statusGeneral.ext1 == ((int)SLA_EVENT_TYPE.WAITINGCUSTOMER).ToString())
                        {
                            thisTaskSla.total_waiting_customer_hours += GetDiffHours(oldTicket.update_time,timeNow);
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
        public int GetDiffHours(long startDate,long endDate)
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
        public bool AddLabour(sdk_work_entry thisEntry,long userId)
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
                OperLogBLL.OperLogUpdate<sdk_work_entry>(thisEntry, oldLabour,thisEntry.id, userId, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "修改工时");
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
        public bool AddTicketLabour(SdkWorkEntryDto param,long userId,ref string failReason)
        {
            try
            {
                #region 过滤父级工单，暂不支持多级
                param.workEntry = GetParentId(param.workEntry);
                #endregion

                #region  添加工时
                AddLabour(param.workEntry,userId);
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
                var proTicketList = _dal.GetSubTaskByType(param.ticketId,DicEnum.TICKET_TYPE.PROBLEM);
                if (proTicketList != null && proTicketList.Count > 0)
                {
                    proTicketList.ForEach(_ => {
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
                            if (!string.IsNullOrEmpty(param.workEntry.summary_notes)&&!string.IsNullOrEmpty(param.workEntry.internal_notes))
                            {
                                long noteId;
                                AppNoteLabour(_, param.workEntry.summary_notes,userId ,out noteId,true);
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
                    if(contract!=null && contract.bill_post_type_id == (int)DicEnum.BILL_POST_TYPE.BILL_NOW)
                    {
                        new ApproveAndPostBLL().PostWorkEntry(param.workEntry.id, Convert.ToInt32(DateTime.Now.ToString("yyyyMMdd")), userId, "A");
                    }
                }
                #endregion

                #region 新增合同成本相关
                AddTicketLabourCost(param.thisCost,userId);
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
            if(thisEntry.parent_note_id != null)
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
            else if(thisEntry.parent_attachment_id != null)
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
        public void AppNoteLabour(sdk_task thisTicket, string note, long userId,out long thisNoteId, bool isSummary = false, long? noteId = null)
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
        public void AddTicketLabourCost(ctt_contract_cost thisCost,long userId)
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
            if (oldLaour == null )
            {
                failReason = "未查询到该工时信息";
                return false;
            }
            if(oldLaour.approve_and_post_date != null || oldLaour.approve_and_post_user_id != null)
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
                EditLabour(param.workEntry,userId);
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
                proTicketList.ForEach(_ => {
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


        /// <summary>
        /// 快速新增工单备注
        /// </summary>
        public bool SimpleAddTicketNote(long ticketId,long userId,int noteTypeId,string noteDes,bool isInter,string notifiEmail)
        {
            var result = false;
            try
            {
                var thisTicket = _dal.FindNoDeleteById(ticketId);
                var caDal = new com_activity_dal();
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var thisNote = new com_activity()
                {
                    id= caDal.GetNextIdCom(),
                    account_id = thisTicket.account_id,
                    object_id = thisTicket.id,
                    ticket_id = thisTicket.id,
                    action_type_id = noteTypeId,
                    publish_type_id= isInter?((int)NOTE_PUBLISH_TYPE.TICKET_INTERNA_USER) :((int)NOTE_PUBLISH_TYPE.TICKET_ALL_USER),
                    cate_id = (int)ACTIVITY_CATE.TICKET_NOTE,
                    name = noteDes.Length>=40? noteDes.Substring(0,39): noteDes,
                    description = noteDes,
                    create_time = timeNow,
                    update_time = timeNow,
                    create_user_id = userId,
                    update_user_id = userId,
                    object_type_id = (int)OBJECT_TYPE.TICKETS,
                    task_status_id =thisTicket.status_id,
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
        public string GetNotiEmail(long ticketId,bool notiContact,bool notiPriRes,bool noriInterAll)
        {
            return "";
        }
        /// <summary>
        /// 获取相关邮箱，发送邮件
        /// </summary>
        public void SendTicketEmail(TicketManageDto param,long userId)
        {
            if (param.notify_id == 0||string.IsNullOrEmpty(param.Subject))
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
                if(toResList!=null&& toResList.Count > 0)
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
            var email = new com_notify_email() {
                id=cneDal.GetNextIdCom(),
                cate_id = (int)NOTIFY_CATE.TICKETS,
                event_id = (int)NOTIFY_EVENT.TICKET_CREATED_EDITED,
                create_user_id = userId,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = userId,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                to_email = toEmail.ToString(),   // 界面输入，包括发送对象、员工、其他地址等四个部分组成
                notify_tmpl_id = (int)param.notify_id,  // 根据通知模板
                from_email = param.EmailFrom? thisUser.email:"",
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
        public bool AcceptTicket(long ticketId,long userId,ref string failReason)
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
                var roleList =  new sys_resource_department_dal().GetResRoleList((long)thisTicket.department_id,userId);
                if(roleList!=null&& roleList.Count > 0)
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
                    if(queueDepList!=null&& queueDepList.Count > 0)
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
                        if(depList!=null&& depList.Count > 0)
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
            EditTicket(thisTicket,userId);
            return true;
        }
        /// <summary>
        /// 转发修改工单-添加备注
        /// </summary>
        public void AddModifyTicketNote(long ticketId,long userId)
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
                publish_type_id =  ((int)NOTE_PUBLISH_TYPE.TICKET_ALL_USER),
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
        public bool MergeTickets(long toTicketId,string fromTicketIds,long userId)
        {
            var faileReason = "";
            var toTicket = _dal.FindNoDeleteById(toTicketId);
            if (toTicket == null || string.IsNullOrEmpty(fromTicketIds))
                return false;
            var fromArr = fromTicketIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (var fromTicketId in fromArr)
            {
                MergeTicket(toTicketId,long.Parse(fromTicketId),userId,ref faileReason);
            }
            return true;
        }
        /// <summary>
        /// 合并吸收单个工单
        /// </summary>
        public bool MergeTicket(long toTicketId,long fromTicketId,long userId,ref string faileReason)
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
            if(fromTicket.type_id ==(int)DicEnum.TICKET_TYPE.PROBLEM|| fromTicket.type_id == (int)DicEnum.TICKET_TYPE.CHANGE_REQUEST)
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
            if(fromTicket.contact_id!=null)
                TransferContact(toTicketId,(long)fromTicket.contact_id,userId);
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
        public void TransferContact(long ticketId,long contactId,long userId)
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
            thisCon = new sdk_task_resource() {
                id=srDal.GetNextIdCom(),
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
        public bool CopyToProject(string ticketIds,long projectId,long departmentId,long? phaseId,long userId)
        {
            var project = new pro_project_dal().FindNoDeleteById(projectId);
            if (project == null||string.IsNullOrEmpty(ticketIds))
                return false;
            var ticketIdArr = ticketIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
            foreach (var ticketId in ticketIdArr)
            {
                SingCopyProject(long.Parse(ticketId),projectId, departmentId, phaseId,userId);
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
            if (thisTicket == null||thisProject==null)
                return false;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var oldStatus = thisTicket.status_id;
            thisTicket.status_id = (int)DicEnum.TICKET_STATUS.DONE;
            thisTicket.date_completed = timeNow;
            EditTicket(thisTicket,userId);

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
            newTask.start_no_earlier_than_date = parPhase == null ?thisProject.start_date:Tools.Date.DateHelper.ConvertStringToDateTime((long)parPhase.estimated_begin_time);
            newTask.department_id = departmentId;
            newTask.estimated_hours = 0;
            newTask.sort_order = parPhase == null ? tBll.GetMinUserNoParSortNo(projectId) : tBll.GetMinUserSortNo((long)phaseId);
            newTask.no = tBll.ReturnTaskNo();
            newTask.create_time = timeNow;
            newTask.update_time = timeNow;
            newTask.create_user_id = userId;
            newTask.update_user_id = userId;
            _dal.Insert(newTask);
            OperLogBLL.OperLogAdd<sdk_task>(newTask, newTask.id,userId, OPER_LOG_OBJ_CATE.PROJECT_TASK, "新增task");
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
        public bool DisRelationProject(long ticketId,long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return false;
            thisTicket.project_id = null;
            EditTicket(thisTicket,userId);
            return true;
        }
    }
}
