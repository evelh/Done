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
    public class TaskBLL
    {
        private sdk_task_dal _dal = new sdk_task_dal();

        /// <summary>
        /// 新增Task
        /// </summary>
        public bool AddTask(TaskSaveDto param, long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                if (user == null)
                    return false;
                var thisTask = param.task;
                thisTask.id = _dal.GetNextIdCom();
                thisTask.department_id = thisTask.department_id == 0 ? null : thisTask.department_id;
                thisTask.no = ReturnTaskNo();
                thisTask.create_user_id = user.id;
                thisTask.oid = 0;
                if (thisTask.estimated_duration == null)
                {
                    thisTask.estimated_duration = GetDayByTime((long)thisTask.estimated_begin_time, (long)thisTask.estimated_end_time, (long)thisTask.project_id);
                }
                else
                {
                    thisTask.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(RetrunMaxTime((long)thisTask.project_id, Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time), (int)thisTask.estimated_duration));
                }
                if (thisTask.parent_id != null)
                {
                    thisTask.sort_order = GetMinUserSortNo((long)thisTask.parent_id);
                }
                else
                {
                    thisTask.sort_order = GetMinUserNoParSortNo((long)thisTask.project_id);
                }

                thisTask.update_user_id = user.id;
                thisTask.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisTask.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

                #region 1.保存Task信息
                 _dal.Insert(thisTask);
                thisTask = _dal.FindNoDeleteById(thisTask.id);
                if (thisTask != null)
                {
                    OperLogBLL.OperLogAdd<sdk_task>(thisTask, thisTask.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "新增task");
                }
                #endregion

                #region task 相关扩展字段
                var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TASK);  // 获取合同的自定义字段信息
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.TASK, user.id,
                    thisTask.id, udf_list, param.udf, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK_INFORMATION);
                #endregion
                #region  保存前驱任务相关 根据延迟时间计算task开始结束相关信息
                var thisDic = param.predic;
                var startDate = Tools.Date.DateHelper.ConvertStringToDateTime((long)param.task.estimated_begin_time);
                var stpDal = new sdk_task_predecessor_dal();

                if (thisDic != null && thisDic.Count > 0)
                {
                    var nowTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    foreach (var dic in thisDic)
                    {
                        var thisPreTask = _dal.FindNoDeleteById(dic.Key);
                        if (thisPreTask != null)
                        {
                            var thisSDate = Tools.Date.DateHelper.ConvertStringToDateTime((long)thisPreTask.estimated_end_time);
                            thisSDate = RetrunMaxTime((long)param.task.project_id, thisSDate, dic.Value+2);
                            if (startDate < thisSDate)
                            {
                                startDate = thisSDate;
                            }
                            var stp = new sdk_task_predecessor()
                            {
                                id = stpDal.GetNextIdCom(),
                                create_time = nowTime,
                                update_time = nowTime,
                                create_user_id = user.id,
                                update_user_id = user.id,
                                task_id = thisTask.id,
                                predecessor_task_id = dic.Key,
                                dependant_lag = dic.Value,
                            };
                            stpDal.Insert(stp);
                            OperLogBLL.OperLogAdd<sdk_task_predecessor>(stp, stp.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_PREDECESSOR, "新增前驱任务");
                        }
                    }
                }
                if (param.task.start_no_earlier_than_date != null)
                {
                    startDate = Tools.Date.DateHelper.ConvertStringToDateTime((long)param.task.estimated_begin_time);
                }
                else
                {
                    param.task.estimated_begin_time = Tools.Date.DateHelper.ToUniversalTimeStamp(startDate);
                }
                #endregion
                //  根据开始时间和结束时间计算最终时间
                param.task.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(RetrunMaxTime((long)param.task.project_id, startDate, (int)param.task.estimated_duration));

                var oldTask = _dal.FindNoDeleteById(thisTask.id);
                if (oldTask != null && oldTask.estimated_end_time != param.task.estimated_end_time)
                {
                    oldTask.estimated_end_time = param.task.estimated_end_time;
                    oldTask.estimated_begin_time = param.task.estimated_begin_time;
                    // 修改task的开始结束时间相关
                    OperLogBLL.OperLogUpdate<sdk_task>(oldTask, _dal.FindNoDeleteById(thisTask.id), thisTask.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                    _dal.Update(oldTask);
                }

                #region 时间发生变化，修改后面的任务
                //var thisHoujiTaskList = new sdk_task_predecessor_dal().GetTaskByPreId(thisTask.id);
                //if (thisHoujiTaskList != null && thisHoujiTaskList.Count > 0)
                //{
                //    thisHoujiTaskList.ForEach(_ =>
                //    {
                //        UpdateTaskDate(_.id, user_id);
                //    });
                //}
                #endregion


                // 递归修改父阶段相关数据
                UpdateParDate(param.task.parent_id, (long)param.task.estimated_begin_time, Tools.Date.DateHelper.ConvertStringToDateTime((long)param.task.estimated_end_time), user.id);
                // 修改项目相关
                var ppDal = new pro_project_dal();
                var thisProject = ppDal.FindNoDeleteById((long)param.task.project_id);

                if (thisProject.start_date > startDate || thisProject.end_date < Tools.Date.DateHelper.ConvertStringToDateTime((long)param.task.estimated_end_time))
                {
                    if (thisProject.start_date > startDate)
                    {
                        thisProject.start_date = startDate;
                    }
                    if (thisProject.end_date < Tools.Date.DateHelper.ConvertStringToDateTime((long)param.task.estimated_end_time))
                    {
                        thisProject.end_date = Tools.Date.DateHelper.ConvertStringToDateTime((long)param.task.estimated_end_time);
                    }
                    TimeSpan ts1 = new TimeSpan(((DateTime)thisProject.start_date).Ticks);
                    TimeSpan ts2 = new TimeSpan(((DateTime)thisProject.end_date).Ticks);
                    TimeSpan ts = ts1.Subtract(ts2).Duration();
                    thisProject.duration = ts.Days + 1;
                    OperLogBLL.OperLogUpdate<pro_project>(thisProject, ppDal.FindNoDeleteById(thisProject.id), thisProject.id, user_id, OPER_LOG_OBJ_CATE.PROJECT, "修改项目时间");
                    ppDal.Update(thisProject);
                }




                #region 保存任务负责人，联系人相关字段
                var strd = new sdk_task_resource_dal();
                var pptDal = new pro_project_team_dal();
                var pptrDal = new pro_project_team_role_dal();
                if (!string.IsNullOrEmpty(param.resDepIds))
                {
                    var resDepList = param.resDepIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (resDepList != null && resDepList.Count() > 0)
                    {
                        var srdDal = new sys_resource_department_dal();
                        foreach (var resDepId in resDepList)
                        {
                            var roleDep = srdDal.FindById(long.Parse(resDepId));
                            if (roleDep != null)
                            {
                                var isHas = strd.GetSinByTasResRol(thisTask.id, roleDep.resource_id, roleDep.role_id);
                                if (isHas == null)  // 相同的员工角色如果已经存在则不重复添加
                                {
                                    var item = new sdk_task_resource()
                                    {
                                        id = strd.GetNextIdCom(),
                                        task_id = thisTask.id,
                                        role_id = roleDep.role_id,
                                        resource_id = roleDep.resource_id,
                                        create_user_id = user.id,
                                        update_user_id = user.id,
                                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    };
                                    strd.Insert(item);
                                    OperLogBLL.OperLogAdd<sdk_task_resource>(item, item.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增任务分配对象");
                                }

                                var isProHas = pptDal.GetSinProByIdResRol(thisProject.id, roleDep.resource_id, roleDep.role_id);
                                if (isProHas == null)   // 项目中不存在则新增
                                {
                                    var item = new pro_project_team()
                                    {
                                        id = pptDal.GetNextIdCom(),
                                        project_id = thisProject.id,
                                        resource_id = roleDep.resource_id,
                                        resource_daily_hours = (decimal)thisProject.resource_daily_hours,
                                        create_user_id = user.id,
                                        update_user_id = user.id,
                                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    };
                                    pptDal.Insert(item);
                                    OperLogBLL.OperLogAdd<pro_project_team>(item, item.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_ITEM, "新增项目团队-添加员工");

                                    var item_role = new pro_project_team_role()
                                    {
                                        id = pptrDal.GetNextIdCom(),
                                        project_team_id = item.id,
                                        role_id = roleDep.role_id,
                                        create_user_id = user.id,
                                        update_user_id = user.id,
                                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    };
                                    pptrDal.Insert(item_role);
                                    OperLogBLL.OperLogAdd<pro_project_team_role>(item_role, item_role.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_ITEM_ROLE, "新增项目团队角色");
                                }
                            }
                        }
                    }
                }

                if (!string.IsNullOrEmpty(param.contactIds))
                {
                    var conIdList = param.contactIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (conIdList != null && conIdList.Count() > 0)
                    {
                        foreach (var conId in conIdList)
                        {
                            var item = new sdk_task_resource()
                            {
                                id = strd.GetNextIdCom(),
                                task_id = thisTask.id,
                                contact_id = long.Parse(conId),
                                create_user_id = user.id,
                                update_user_id = user.id,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            };
                            strd.Insert(item);
                            OperLogBLL.OperLogAdd<sdk_task_resource>(item, item.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增任务分配对象");
                        }
                    }
                }

                #endregion

                #region 如果是阶段，保存角色费率相关信息
                if (thisTask.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE)
                {
                    if (param.rateDic != null && param.rateDic.Count > 0)
                    {
                        var stbDal = new sdk_task_budget_dal();
                        var nowTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        foreach (var rate in param.rateDic)
                        {
                            var stb = new sdk_task_budget()
                            {
                                id = stbDal.GetNextIdCom(),
                                create_time = nowTime,
                                update_time = nowTime,
                                create_user_id = user.id,
                                update_user_id = user.id,
                                task_id = thisTask.id,
                                contract_rate_id = rate.Key,
                                estimated_hours = rate.Value,
                            };
                            stbDal.Insert(stb);
                            OperLogBLL.OperLogAdd<sdk_task_budget>(stb, stb.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_PREDECESSOR, "新增项目阶段预估工时");
                        }
                    }
                }
                #endregion



                #region 备注相关
                if (param.task.status_id == (int)DicEnum.TICKET_STATUS.DONE)
                {
                    var activity = new com_activity()
                    {
                        id = _dal.GetNextIdCom(),
                        cate_id = (int)DicEnum.ACTIVITY_CATE.TASK_NOTE,
                        action_type_id = (int)ACTIVITY_TYPE.TASK_NOTE,
                        object_id = param.task.id,
                        object_type_id = (int)OBJECT_TYPE.TASK,
                        resource_id = param.task.owner_resource_id,
                        name = "完成原因",
                        description = $"任务被{user.name}取消，时间为{DateTime.Now.ToString("yyyy-MM-dd")}",
                        publish_type_id = (int)NOTE_PUBLISH_TYPE.PROJECT_ALL_USER,
                        create_user_id = user.id,
                        update_user_id = user.id,
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        is_system_generate = 1,
                        task_id = param.task.id,
                        task_status_id = (int)DicEnum.TICKET_STATUS.DONE,
                    };
                    new com_activity_dal().Insert(activity);
                    OperLogBLL.OperLogAdd<com_activity>(activity, activity.id, user.id, OPER_LOG_OBJ_CATE.NOTIFY, "修改项目状态-添加通知");
                }

                #endregion

                #region 通知相关
                if (param.task.template_id != null)
                {
                    var temp = new sys_notify_tmpl_dal().FindNoDeleteById((long)param.task.template_id);
                    if (temp != null)
                    {
                        var temp_email_List = new sys_notify_tmpl_email_dal().GetEmailByTempId(temp.id);
                        if (temp_email_List != null && temp_email_List.Count > 0)
                        {

                            StringBuilder toEmail = new StringBuilder();
                            #region 接受邮件的人的邮箱地址

                            if (!string.IsNullOrEmpty(param.NoToMe))
                            {
                                toEmail.Append(user.email + ";");
                            }
                            if (!string.IsNullOrEmpty(param.NoToProlead) && thisProject.owner_resource_id != null)
                            {
                                var thisResource = new sys_resource_dal().FindNoDeleteById((long)thisProject.owner_resource_id);
                                if (thisResource != null && !string.IsNullOrEmpty(thisResource.email))
                                {
                                    toEmail.Append(thisResource.email + ";");
                                }
                            }
                            if (!string.IsNullOrEmpty(param.NoToContacts))
                            {
                                var conList = new crm_contact_dal().GetContactByIds(param.NoToContacts);
                                if (conList != null && conList.Count > 0)
                                {
                                    conList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { toEmail.Append(_.email + ";"); } });
                                }

                            }
                            List<sys_resource> toResList = null;
                            if (!string.IsNullOrEmpty(param.NoToResIds))
                            {
                                var resList = new sys_resource_dal().GetListByIds(param.NoToResIds);
                                if (resList != null && resList.Count > 0)
                                {
                                    toResList.AddRange(resList);
                                }
                            }
                            if (!string.IsNullOrEmpty(param.NoToDepIds))
                            {
                                var depSouList = new sys_resource_dal().GetListByDepId(param.NoToDepIds);
                                if (depSouList != null && depSouList.Count > 0)
                                {
                                    toResList.AddRange(depSouList);
                                }
                            }
                            if (!string.IsNullOrEmpty(param.NoToToWorkIds))
                            {
                                var workresList = new sys_workgroup_dal().GetResouListByWorkIds(param.NoToToWorkIds);
                                if (workresList != null && workresList.Count > 0)
                                {
                                    toResList.AddRange(workresList);
                                }
                            }
                            if (toResList != null && toResList.Count > 0)
                            {
                                toResList = toResList.Distinct().ToList();
                                toResList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { toEmail.Append(_.email + ";"); } });
                            }
                            if (!string.IsNullOrEmpty(param.NoToOtherMail))
                            {
                                toEmail.Append(param.NoToOtherMail + ';');
                            }
                            var toEmialString = toEmail.ToString();
                            if (!string.IsNullOrEmpty(toEmialString))
                            {
                                toEmialString = toEmialString.Substring(0, toEmialString.Length - 1);
                            }
                            #endregion
                            StringBuilder ccEmail = new StringBuilder();
                            #region 抄送接收邮件地址
                            if (!string.IsNullOrEmpty(param.NoCcMe))
                            {
                                ccEmail.Append(user.email + ";");
                            }
                            if (!string.IsNullOrEmpty(param.NoCcContactIds))
                            {
                                var conList = new crm_contact_dal().GetContactByIds(param.NoCcContactIds);
                                if (conList != null && conList.Count > 0)
                                {
                                    conList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { ccEmail.Append(_.email + ";"); } });
                                }

                            }
                            List<sys_resource> ccResList = null;
                            if (!string.IsNullOrEmpty(param.NoCcResIds))
                            {
                                var resList = new sys_resource_dal().GetListByIds(param.NoCcResIds);
                                if (resList != null && resList.Count > 0)
                                {
                                    ccResList.AddRange(resList);
                                }
                            }
                            if (!string.IsNullOrEmpty(param.NoCcDepIds))
                            {
                                var depSouList = new sys_resource_dal().GetListByDepId(param.NoCcDepIds);
                                if (depSouList != null && depSouList.Count > 0)
                                {
                                    ccResList.AddRange(depSouList);
                                }
                            }
                            if (!string.IsNullOrEmpty(param.NoCcWorkIds))
                            {
                                var workresList = new sys_workgroup_dal().GetResouListByWorkIds(param.NoCcWorkIds);
                                if (workresList != null && workresList.Count > 0)
                                {
                                    ccResList.AddRange(workresList);
                                }
                            }
                            if (ccResList != null && ccResList.Count > 0)
                            {
                                ccResList = ccResList.Distinct().ToList();
                                ccResList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { ccEmail.Append(_.email + ";"); } });
                            }
                            if (!string.IsNullOrEmpty(param.NoCcOtherMail))
                            {
                                ccEmail.Append(param.NoCcOtherMail + ';');
                            }
                            var ccEmialString = ccEmail.ToString();
                            if (!string.IsNullOrEmpty(ccEmialString))
                            {
                                ccEmialString = ccEmialString.Substring(0, ccEmialString.Length - 1);
                            }
                            #endregion
                            StringBuilder bccEmail = new StringBuilder();
                            #region 密送接收邮件地址
                            if (!string.IsNullOrEmpty(param.NoBccContractIds))
                            {
                                var conList = new crm_contact_dal().GetContactByIds(param.NoBccContractIds);
                                if (conList != null && conList.Count > 0)
                                {
                                    conList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { bccEmail.Append(_.email + ";"); } });
                                }

                            }
                            List<sys_resource> bccResList = null;
                            if (!string.IsNullOrEmpty(param.NoBccResIds))
                            {
                                var resList = new sys_resource_dal().GetListByIds(param.NoBccResIds);
                                if (resList != null && resList.Count > 0)
                                {
                                    bccResList.AddRange(resList);
                                }
                            }
                            if (!string.IsNullOrEmpty(param.NoBccDepIds))
                            {
                                var depSouList = new sys_resource_dal().GetListByDepId(param.NoBccDepIds);
                                if (depSouList != null && depSouList.Count > 0)
                                {
                                    bccResList.AddRange(depSouList);
                                }
                            }
                            if (!string.IsNullOrEmpty(param.NoBccWorkIds))
                            {
                                var workresList = new sys_workgroup_dal().GetResouListByWorkIds(param.NoBccWorkIds);
                                if (workresList != null && workresList.Count > 0)
                                {
                                    bccResList.AddRange(workresList);
                                }
                            }
                            if (bccResList != null && bccResList.Count > 0)
                            {
                                bccResList = bccResList.Distinct().ToList();
                                bccResList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { bccEmail.Append(_.email + ";"); } });
                            }
                            if (!string.IsNullOrEmpty(param.NoBccOtherMail))
                            {
                                bccEmail.Append(param.NoBccOtherMail + ';');
                            }
                            var bccEmialString = bccEmail.ToString();
                            if (!string.IsNullOrEmpty(bccEmialString))
                            {
                                bccEmialString = bccEmialString.Substring(0, bccEmialString.Length - 1);
                            }

                            #endregion
                            bool isSuccess = false;
                            var notify = new com_notify_email()
                            {
                                id = _dal.GetNextIdCom(),
                                cate_id = (int)NOTIFY_CATE.PROJECT,
                                event_id = (int)DicEnum.NOTIFY_EVENT.PROJECT_CREATED,
                                to_email = toEmialString,
                                cc_email = ccEmialString,
                                bcc_email = bccEmialString,
                                notify_tmpl_id = temp.id,
                                from_email = user.email,
                                from_email_name = user.name,
                                subject = param.subject == null ? "" : param.subject,
                                body_text = temp_email_List[0].body_text + param.otherEmail,
                                // is_success = (sbyte)(isSuccess ? 1 : 0),
                                is_html_format = 0,
                                create_user_id = user.id,
                                update_user_id = user.id,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            };
                            // isSuccess =new ProjectBLL().SendEmail(notify);
                            notify.is_success = (sbyte)(isSuccess ? 1 : 0);
                            new com_notify_email_dal().Insert(notify);
                            OperLogBLL.OperLogAdd<com_notify_email>(notify, notify.id, user.id, OPER_LOG_OBJ_CATE.NOTIFY, "新增项目-添加通知");
                        }
                    }
                }

                #endregion

                #region 更新客户最后活动时间
                crm_account thisAccount = new CompanyBLL().GetCompany(thisTask.account_id);
                if (thisAccount != null) { thisAccount.last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now); new CompanyBLL().EditAccount(thisAccount, user_id); }
                #endregion
            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 修改task
        /// </summary>
        public bool EditTask(TaskSaveDto param, long user_id)
        {
            // 需要执行的操作
            // 1.修改前驱任务
            // 前驱任务修改导致时间改变。需要更改task开始结束时间
            // 2.修改task本身相关信息
            // 3.修改自定义信息相关
            // 4.修改task团队成员信息（员工，联系人）
            // 5.如果时间落在项目时间外面，需要更改项目时间
            var oldTask = _dal.FindNoDeleteById(param.task.id);
            if (oldTask == null)
                return false;
            var oldTaskEndTime = oldTask.estimated_end_time;
            var thisTask = param.task;
            if (thisTask.estimated_duration == null)
            {
                thisTask.estimated_duration = GetDayByTime((long)thisTask.estimated_begin_time, (long)thisTask.estimated_end_time, (long)thisTask.project_id);
            }
            else
            {
                //var test = RetrunMaxTime(6970,DateTime.Parse("2018-01-07"),2);
                var thisDura = GetDayByTime((long)thisTask.estimated_begin_time, (long)thisTask.estimated_end_time, (long)thisTask.project_id);
                if(thisDura!= (int)thisTask.estimated_duration)
                {
                    thisTask.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(RetrunMaxTime((long)thisTask.project_id, Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time), (int)thisTask.estimated_duration));
                }
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            bool isPhase = thisTask.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE;
            if (!isPhase)
            {

                #region  保存前驱任务相关 根据延迟时间计算task开始结束相关信息
                var thisDic = param.predic;
                var startDate = Tools.Date.DateHelper.ConvertStringToDateTime((long)param.task.estimated_begin_time);
                var stpDal = new sdk_task_predecessor_dal();

                if (thisDic != null && thisDic.Count > 0)
                {
                    var nowTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    foreach (var dic in thisDic)
                    {
                        var thisPreTask = _dal.FindNoDeleteById(dic.Key);
                        if (thisPreTask != null)
                        {
                            var thisSDate = Tools.Date.DateHelper.ConvertStringToDateTime((long)thisPreTask.estimated_end_time);
                            thisSDate = RetrunMaxTime((long)param.task.project_id, thisSDate, dic.Value + 1);
                            if (startDate < thisSDate)
                            {
                                startDate = thisSDate;
                            }

                            // 是否能查到，判断新增还是修改
                            var thisStp = stpDal.GetSinByTaskAndPre(param.task.id, dic.Key);
                            if (thisStp != null)
                            {
                                if (thisStp.dependant_lag != dic.Value)
                                {
                                    thisStp.dependant_lag = dic.Value;
                                    thisStp.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                    thisStp.update_user_id = user_id;
                                    OperLogBLL.OperLogUpdate<sdk_task_predecessor>(thisStp, stpDal.GetSinByTaskAndPre(param.task.id, dic.Key), thisStp.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK_PREDECESSOR, "修改前驱任务");
                                    stpDal.Update(thisStp);
                                }
                            }
                            else
                            {
                                var stp = new sdk_task_predecessor()
                                {
                                    id = stpDal.GetNextIdCom(),
                                    create_time = nowTime,
                                    update_time = nowTime,
                                    create_user_id = user_id,
                                    update_user_id = user_id,
                                    task_id = param.task.id,
                                    predecessor_task_id = dic.Key,
                                    dependant_lag = dic.Value,
                                };
                                stpDal.Insert(stp);
                                OperLogBLL.OperLogAdd<sdk_task_predecessor>(stp, stp.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK_PREDECESSOR, "新增前驱任务");
                            }

                        }
                    }
                }
                if (param.task.start_no_earlier_than_date != null)
                {
                    startDate = Tools.Date.DateHelper.ConvertStringToDateTime((long)param.task.estimated_begin_time);
                }
                else
                {
                    param.task.estimated_begin_time = Tools.Date.DateHelper.ToUniversalTimeStamp(startDate);
                }
                #endregion
                //  根据开始时间和结束时间计算最终时间
                var thisDura = GetDayByTime(Tools.Date.DateHelper.ToUniversalTimeStamp(startDate), (long)thisTask.estimated_end_time, (long)thisTask.project_id);
                if (thisDura != (int)thisTask.estimated_duration)
                {
                    thisTask.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(RetrunMaxTime((long)thisTask.project_id, startDate, (int)thisTask.estimated_duration));
                }
                //param.task.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(RetrunMaxTime((long)param.task.project_id, startDate, (int)param.task.estimated_duration));


                var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TASK);  // 获取合同的自定义字段信息
                new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.TASK, udf_list,
                    thisTask.id, param.udf, user, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK_INFORMATION);
            }
            else
            {
                if (param.rateDic != null && param.rateDic.Count > 0)
                {
                    var stbDal = new sdk_task_budget_dal();
                    var nowTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    foreach (var rate in param.rateDic)
                    {
                        var thisTaskRate = stbDal.GetSinByTIdRid(thisTask.id, rate.Key);
                        if (thisTaskRate != null)
                        {
                            if (thisTaskRate.estimated_hours != rate.Value)
                            {
                                thisTaskRate.estimated_hours = rate.Value;
                                thisTaskRate.update_time = nowTime;
                                thisTaskRate.update_user_id = user_id;
                                OperLogBLL.OperLogUpdate<sdk_task_budget>(thisTaskRate, stbDal.FindNoDeleteById(thisTaskRate.id), thisTaskRate.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_PHASE_WORK_HOURS, "修改项目阶段预估工时");
                            }
                        }
                        else
                        {
                            var stb = new sdk_task_budget()
                            {
                                id = stbDal.GetNextIdCom(),
                                create_time = nowTime,
                                update_time = nowTime,
                                create_user_id = user_id,
                                update_user_id = user_id,
                                task_id = thisTask.id,
                                contract_rate_id = rate.Key,
                                estimated_hours = rate.Value,
                            };
                            stbDal.Insert(stb);
                            OperLogBLL.OperLogAdd<sdk_task_budget>(stb, stb.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_PHASE_WORK_HOURS, "新增项目阶段预估工时");
                        }
                    }
                }
            }
            // 修改task的开始结束时间相关
            if (oldTask.parent_id != thisTask.parent_id)   // 父task 修改，相应排序号也要修改
            {
                var newSortNo = "";
                if (thisTask.parent_id != null)
                {
                    newSortNo = GetMinUserSortNo((long)thisTask.parent_id);
                }
                else
                {
                    newSortNo = GetMinUserNoParSortNo((long)thisTask.project_id);
                }
                //  
                ChangeTaskSortNo(newSortNo, thisTask.id, user_id);
                ChangBroTaskSortNoReduce((long)thisTask.project_id, oldTask.parent_id, user_id);

            }

            thisTask.update_user_id = user_id;
            thisTask.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (thisTask.status_id == (int)DicEnum.TICKET_STATUS.DONE)
            {
                thisTask.date_completed = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var thisVt = new v_task_all_dal().FindById(thisTask.id);
                if (thisVt != null && !isPhase)
                {
                    // 预估偏差将会变更为：实际时间 - （预估时间+变更单时间）+剩余时间
                    thisTask.projected_variance = (thisVt.worked_hours == null ? 0 : (decimal)thisVt.worked_hours) - (thisTask.estimated_hours + (thisVt.change_Order_Hours == null ? 0 : (decimal)thisVt.change_Order_Hours));
                    thisTask.reason = "";
                }
            }
            OperLogBLL.OperLogUpdate<sdk_task>(thisTask, _dal.FindNoDeleteById(thisTask.id), thisTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
            _dal.Update(thisTask);

            var thisProject = new pro_project_dal().FindNoDeleteById((long)thisTask.project_id);

            // 修改相关父任务 和 项目的开始结束时间
            if (thisTask.parent_id != null)
            {
                AdjustmentDate((long)thisTask.parent_id, user_id);
            }
            AdjustProDate((long)thisTask.project_id, user_id);


            #region 修改结束时间后，相关后续任务的时间需要调整
            if (oldTaskEndTime != thisTask.estimated_end_time && oldTaskEndTime != null)
            {
                var diffDay = GetDayByTime((long)oldTaskEndTime, (long)thisTask.estimated_end_time, (long)thisTask.project_id);


                var thisHoujiTaskList = new sdk_task_predecessor_dal().GetTaskByPreId(thisTask.id);
                if (thisHoujiTaskList != null && thisHoujiTaskList.Count > 0)
                {
                    thisHoujiTaskList.ForEach(_ =>
                    {
                        UpdateTaskDate(_.id, user_id);
                    });
                }
            }

            #endregion


            #region 团队成员相关操作
            // 获取到原有的员工，联系人（）
            var strDal = new sdk_task_resource_dal();
            var pptDal = new pro_project_team_dal();
            var pptrDal = new pro_project_team_role_dal();
            var srdDal = new sys_resource_department_dal();
            if (!isPhase)
            {
                var oldTaskResList = strDal.GetResByTaskId(thisTask.id);
                var oldTaskConList = strDal.GetConByTaskId(thisTask.id);

                if (oldTaskResList != null && oldTaskResList.Count > 0)
                {
                    if (!string.IsNullOrEmpty(param.resDepIds))   // 数据库中有，页面也有
                    {
                        var thisIdList = param.resDepIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
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
                                        task_id = thisTask.id,
                                        role_id = roleDep.role_id,
                                        resource_id = roleDep.resource_id,
                                        create_user_id = user.id,
                                        update_user_id = user.id,
                                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    };
                                    strDal.Insert(item);
                                    OperLogBLL.OperLogAdd<sdk_task_resource>(item, item.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增任务分配对象");
                                }
                                else
                                {
                                    oldTaskResList.Remove(isHas);
                                }
                                #region 如果项目中没有该员工角色，未项目添加员工角色
                                var isProHas = pptDal.GetSinProByIdResRol(thisProject.id, roleDep.resource_id, roleDep.role_id);
                                if (isProHas == null)   // 项目中不存在则新增
                                {
                                    var item = new pro_project_team()
                                    {
                                        id = pptDal.GetNextIdCom(),
                                        project_id = thisProject.id,
                                        resource_id = roleDep.resource_id,
                                        resource_daily_hours = (decimal)thisProject.resource_daily_hours,
                                        create_user_id = user.id,
                                        update_user_id = user.id,
                                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    };
                                    pptDal.Insert(item);
                                    OperLogBLL.OperLogAdd<pro_project_team>(item, item.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_ITEM, "新增项目团队-添加员工");

                                    var item_role = new pro_project_team_role()
                                    {
                                        id = pptrDal.GetNextIdCom(),
                                        project_team_id = item.id,
                                        role_id = roleDep.role_id,
                                        create_user_id = user.id,
                                        update_user_id = user.id,
                                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    };
                                    pptrDal.Insert(item_role);
                                    OperLogBLL.OperLogAdd<pro_project_team_role>(item_role, item_role.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_ITEM_ROLE, "新增项目团队角色");
                                }
                                #endregion
                            }
                        }
                        if (oldTaskResList.Count > 0)
                        {
                            foreach (var oldTaskRes in oldTaskResList)
                            {
                                strDal.SoftDelete(oldTaskRes, user_id);
                                OperLogBLL.OperLogDelete<sdk_task_resource>(oldTaskRes, oldTaskRes.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "删除任务团队成员");
                            }
                        }
                    }
                    else            // 原来有，页面没有（全部删除）
                    {
                        foreach (var oldTaskRes in oldTaskResList)
                        {
                            strDal.SoftDelete(oldTaskRes, user_id);
                            OperLogBLL.OperLogDelete<sdk_task_resource>(oldTaskRes, oldTaskRes.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "删除任务团队成员");
                        }
                    }
                }
                else
                {
                    if (!string.IsNullOrEmpty(param.resDepIds))// 页面有，数据库没有（全部新增）
                    {
                        var resDepList = param.resDepIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        if (resDepList != null && resDepList.Count() > 0)
                        {

                            foreach (var resDepId in resDepList)
                            {
                                var roleDep = srdDal.FindById(long.Parse(resDepId));
                                if (roleDep != null)
                                {
                                    var isHas = strDal.GetSinByTasResRol(thisTask.id, roleDep.resource_id, roleDep.role_id);
                                    if (isHas == null)  // 相同的员工角色如果已经存在则不重复添加
                                    {
                                        var item = new sdk_task_resource()
                                        {
                                            id = strDal.GetNextIdCom(),
                                            task_id = thisTask.id,
                                            role_id = roleDep.role_id,
                                            resource_id = roleDep.resource_id,
                                            create_user_id = user.id,
                                            update_user_id = user.id,
                                            create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                            update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        };
                                        strDal.Insert(item);
                                        OperLogBLL.OperLogAdd<sdk_task_resource>(item, item.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增任务分配对象");
                                    }

                                    var isProHas = pptDal.GetSinProByIdResRol(thisProject.id, roleDep.resource_id, roleDep.role_id);
                                    if (isProHas == null)   // 项目中不存在则新增
                                    {
                                        var item = new pro_project_team()
                                        {
                                            id = pptDal.GetNextIdCom(),
                                            project_id = thisProject.id,
                                            resource_id = roleDep.resource_id,
                                            resource_daily_hours = (decimal)thisProject.resource_daily_hours,
                                            create_user_id = user.id,
                                            update_user_id = user.id,
                                            create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                            update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        };
                                        pptDal.Insert(item);
                                        OperLogBLL.OperLogAdd<pro_project_team>(item, item.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_ITEM, "新增项目团队-添加员工");

                                        var item_role = new pro_project_team_role()
                                        {
                                            id = pptrDal.GetNextIdCom(),
                                            project_team_id = item.id,
                                            role_id = roleDep.role_id,
                                            create_user_id = user.id,
                                            update_user_id = user.id,
                                            create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                            update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        };
                                        pptrDal.Insert(item_role);
                                        OperLogBLL.OperLogAdd<pro_project_team_role>(item_role, item_role.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_ITEM_ROLE, "新增项目团队角色");
                                    }
                                }
                            }
                        }
                    }
                }

                if (oldTaskConList != null && oldTaskConList.Count > 0)
                {
                    if (!string.IsNullOrEmpty(param.contactIds))
                    {
                        var conIdArr = param.contactIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        foreach (var conId in conIdArr)
                        {
                            var thisTaskCon = oldTaskConList.FirstOrDefault(_ => _.contact_id.ToString() == conId);
                            if (thisTaskCon != null)
                            {
                                oldTaskConList.Remove(thisTaskCon);
                            }
                            else
                            {
                                var item = new sdk_task_resource()
                                {
                                    id = strDal.GetNextIdCom(),
                                    task_id = thisTask.id,
                                    contact_id = long.Parse(conId),
                                    create_user_id = user.id,
                                    update_user_id = user.id,
                                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                };
                                strDal.Insert(item);
                                OperLogBLL.OperLogAdd<sdk_task_resource>(item, item.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增任务分配对象");
                            }
                        }
                    }
                    if (oldTaskConList.Count > 0)
                    {
                        foreach (var oldTaskCon in oldTaskConList)
                        {
                            strDal.SoftDelete(oldTaskCon, user_id);
                            OperLogBLL.OperLogDelete<sdk_task_resource>(oldTaskCon, oldTaskCon.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "删除任务团队成员");
                        }
                    }
                }
                else
                {
                    if (!string.IsNullOrEmpty(param.contactIds))
                    {
                        var conIdList = param.contactIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        if (conIdList != null && conIdList.Count() > 0)
                        {
                            foreach (var conId in conIdList)
                            {
                                var item = new sdk_task_resource()
                                {
                                    id = strDal.GetNextIdCom(),
                                    task_id = thisTask.id,
                                    contact_id = long.Parse(conId),
                                    create_user_id = user.id,
                                    update_user_id = user.id,
                                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                };
                                strDal.Insert(item);
                                OperLogBLL.OperLogAdd<sdk_task_resource>(item, item.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增任务分配对象");
                            }
                        }
                    }
                }


            }
            #endregion

            #region 备注相关
            if (param.task.status_id == (int)DicEnum.TICKET_STATUS.DONE)
            {
                InsActTaskDone(thisTask.id, user_id);
            }

            #endregion

            #region 通知相关
            if (param.task.template_id != null)
            {
                var temp = new sys_notify_tmpl_dal().FindNoDeleteById((long)param.task.template_id);
                if (temp != null)
                {
                    var temp_email_List = new sys_notify_tmpl_email_dal().GetEmailByTempId(temp.id);
                    if (temp_email_List != null && temp_email_List.Count > 0)
                    {

                        StringBuilder toEmail = new StringBuilder();
                        #region 接受邮件的人的邮箱地址

                        if (!string.IsNullOrEmpty(param.NoToMe))
                        {
                            toEmail.Append(user.email + ";");
                        }
                        if (!string.IsNullOrEmpty(param.NoToProlead) && thisProject.owner_resource_id != null)
                        {
                            var thisResource = new sys_resource_dal().FindNoDeleteById((long)thisProject.owner_resource_id);
                            if (thisResource != null && !string.IsNullOrEmpty(thisResource.email))
                            {
                                toEmail.Append(thisResource.email + ";");
                            }
                        }
                        if (!string.IsNullOrEmpty(param.NoToContacts))
                        {
                            var conList = new crm_contact_dal().GetContactByIds(param.NoToContacts);
                            if (conList != null && conList.Count > 0)
                            {
                                conList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { toEmail.Append(_.email + ";"); } });
                            }

                        }
                        List<sys_resource> toResList = null;
                        if (!string.IsNullOrEmpty(param.NoToResIds))
                        {
                            var resList = new sys_resource_dal().GetListByIds(param.NoToResIds);
                            if (resList != null && resList.Count > 0)
                            {
                                toResList.AddRange(resList);
                            }
                        }
                        if (!string.IsNullOrEmpty(param.NoToDepIds))
                        {
                            var depSouList = new sys_resource_dal().GetListByDepId(param.NoToDepIds);
                            if (depSouList != null && depSouList.Count > 0)
                            {
                                toResList.AddRange(depSouList);
                            }
                        }
                        if (!string.IsNullOrEmpty(param.NoToToWorkIds))
                        {
                            var workresList = new sys_workgroup_dal().GetResouListByWorkIds(param.NoToToWorkIds);
                            if (workresList != null && workresList.Count > 0)
                            {
                                toResList.AddRange(workresList);
                            }
                        }
                        if (toResList != null && toResList.Count > 0)
                        {
                            toResList = toResList.Distinct().ToList();
                            toResList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { toEmail.Append(_.email + ";"); } });
                        }
                        if (!string.IsNullOrEmpty(param.NoToOtherMail))
                        {
                            toEmail.Append(param.NoToOtherMail + ';');
                        }
                        var toEmialString = toEmail.ToString();
                        if (!string.IsNullOrEmpty(toEmialString))
                        {
                            toEmialString = toEmialString.Substring(0, toEmialString.Length - 1);
                        }
                        #endregion
                        StringBuilder ccEmail = new StringBuilder();
                        #region 抄送接收邮件地址
                        if (!string.IsNullOrEmpty(param.NoCcMe))
                        {
                            ccEmail.Append(user.email + ";");
                        }
                        if (!string.IsNullOrEmpty(param.NoCcContactIds))
                        {
                            var conList = new crm_contact_dal().GetContactByIds(param.NoCcContactIds);
                            if (conList != null && conList.Count > 0)
                            {
                                conList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { ccEmail.Append(_.email + ";"); } });
                            }

                        }
                        List<sys_resource> ccResList = null;
                        if (!string.IsNullOrEmpty(param.NoCcResIds))
                        {
                            var resList = new sys_resource_dal().GetListByIds(param.NoCcResIds);
                            if (resList != null && resList.Count > 0)
                            {
                                ccResList.AddRange(resList);
                            }
                        }
                        if (!string.IsNullOrEmpty(param.NoCcDepIds))
                        {
                            var depSouList = new sys_resource_dal().GetListByDepId(param.NoCcDepIds);
                            if (depSouList != null && depSouList.Count > 0)
                            {
                                ccResList.AddRange(depSouList);
                            }
                        }
                        if (!string.IsNullOrEmpty(param.NoCcWorkIds))
                        {
                            var workresList = new sys_workgroup_dal().GetResouListByWorkIds(param.NoCcWorkIds);
                            if (workresList != null && workresList.Count > 0)
                            {
                                ccResList.AddRange(workresList);
                            }
                        }
                        if (ccResList != null && ccResList.Count > 0)
                        {
                            ccResList = ccResList.Distinct().ToList();
                            ccResList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { ccEmail.Append(_.email + ";"); } });
                        }
                        if (!string.IsNullOrEmpty(param.NoCcOtherMail))
                        {
                            ccEmail.Append(param.NoCcOtherMail + ';');
                        }
                        var ccEmialString = ccEmail.ToString();
                        if (!string.IsNullOrEmpty(ccEmialString))
                        {
                            ccEmialString = ccEmialString.Substring(0, ccEmialString.Length - 1);
                        }
                        #endregion
                        StringBuilder bccEmail = new StringBuilder();
                        #region 密送接收邮件地址
                        if (!string.IsNullOrEmpty(param.NoBccContractIds))
                        {
                            var conList = new crm_contact_dal().GetContactByIds(param.NoBccContractIds);
                            if (conList != null && conList.Count > 0)
                            {
                                conList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { bccEmail.Append(_.email + ";"); } });
                            }

                        }
                        List<sys_resource> bccResList = null;
                        if (!string.IsNullOrEmpty(param.NoBccResIds))
                        {
                            var resList = new sys_resource_dal().GetListByIds(param.NoBccResIds);
                            if (resList != null && resList.Count > 0)
                            {
                                bccResList.AddRange(resList);
                            }
                        }
                        if (!string.IsNullOrEmpty(param.NoBccDepIds))
                        {
                            var depSouList = new sys_resource_dal().GetListByDepId(param.NoBccDepIds);
                            if (depSouList != null && depSouList.Count > 0)
                            {
                                bccResList.AddRange(depSouList);
                            }
                        }
                        if (!string.IsNullOrEmpty(param.NoBccWorkIds))
                        {
                            var workresList = new sys_workgroup_dal().GetResouListByWorkIds(param.NoBccWorkIds);
                            if (workresList != null && workresList.Count > 0)
                            {
                                bccResList.AddRange(workresList);
                            }
                        }
                        if (bccResList != null && bccResList.Count > 0)
                        {
                            bccResList = bccResList.Distinct().ToList();
                            bccResList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { bccEmail.Append(_.email + ";"); } });
                        }
                        if (!string.IsNullOrEmpty(param.NoBccOtherMail))
                        {
                            bccEmail.Append(param.NoBccOtherMail + ';');
                        }
                        var bccEmialString = bccEmail.ToString();
                        if (!string.IsNullOrEmpty(bccEmialString))
                        {
                            bccEmialString = bccEmialString.Substring(0, bccEmialString.Length - 1);
                        }

                        #endregion
                        bool isSuccess = false;
                        var notify = new com_notify_email()
                        {
                            id = _dal.GetNextIdCom(),
                            cate_id = (int)NOTIFY_CATE.PROJECT,
                            event_id = (int)DicEnum.NOTIFY_EVENT.PROJECT_CREATED,
                            to_email = toEmialString,
                            cc_email = ccEmialString,
                            bcc_email = bccEmialString,
                            notify_tmpl_id = temp.id,
                            from_email = user.email,
                            from_email_name = user.name,
                            subject = param.subject == null ? "" : param.subject,
                            body_text = temp_email_List[0].body_text + param.otherEmail,
                            // is_success = (sbyte)(isSuccess ? 1 : 0),
                            is_html_format = 0,
                            create_user_id = user.id,
                            update_user_id = user.id,
                            create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        };
                        // isSuccess =new ProjectBLL().SendEmail(notify);
                        notify.is_success = (sbyte)(isSuccess ? 1 : 0);
                        new com_notify_email_dal().Insert(notify);
                        OperLogBLL.OperLogAdd<com_notify_email>(notify, notify.id, user.id, OPER_LOG_OBJ_CATE.NOTIFY, "新增项目-添加通知");
                    }
                }
            }

            #endregion
            #region 更新客户最后活动时间
            crm_account thisAccount = new CompanyBLL().GetCompany(thisTask.account_id);
            if (thisAccount != null) { thisAccount.last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now); new CompanyBLL().EditAccount(thisAccount, user_id); }
            #endregion
            return true;
        }

        /// <summary>
        /// 修改任务的开始结束时间（根据前驱任务的时间）
        /// </summary>
        public void UpdateTaskDate(long task_id, long user_id)
        {
            var thisTask = _dal.FindNoDeleteById(task_id);
            var oldTask = _dal.FindNoDeleteById(task_id);
            if (thisTask != null && thisTask.project_id != null && thisTask.estimated_end_time != null && thisTask.estimated_begin_time != null && thisTask.start_no_earlier_than_date == null)
            {
                var stpDal = new sdk_task_predecessor_dal();
                var thisPreList = stpDal.GetRelList(task_id);  // 获取前驱任务的相关集合
                if (thisPreList != null && thisPreList.Count > 0)
                {
                    // 获取到前驱任务的最晚时间
                    var MaxDate = thisPreList.Max(_ =>
                    {
                        long thisDate = 0;
                        var preTask = _dal.FindNoDeleteById(_.predecessor_task_id);
                        if (preTask != null && preTask.estimated_end_time != null)
                        {
                            var thisPreDate = RetrunMaxTime((long)thisTask.project_id, Tools.Date.DateHelper.ConvertStringToDateTime((long)preTask.estimated_end_time), _.dependant_lag + 2);
                            thisDate = Tools.Date.DateHelper.ToUniversalTimeStamp(thisPreDate);
                        }
                        return thisDate;
                    });

                    var thisMaxDate = Tools.Date.DateHelper.ConvertStringToDateTime(MaxDate);
                    var thisTaskStart = Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time);

                    // 与现在的时间比较，是否需要改变
                    if (thisMaxDate.ToString("yyyy-MM-dd") != thisTaskStart.ToString("yyyy-MM-dd"))
                    {
                        thisTask.estimated_begin_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(thisMaxDate.ToString("yyyy-MM-dd")+" "+ thisTaskStart.ToString("HH:mm:ss")));
                        thisTask.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(RetrunMaxTime((long)thisTask.project_id, Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time), (int)thisTask.estimated_duration));
                        _dal.Update(thisTask);
                        OperLogBLL.OperLogUpdate<sdk_task>(thisTask, oldTask, thisTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                        #region 时间发生变化，修改后面的任务
                        var thisHoujiTaskList = new sdk_task_predecessor_dal().GetTaskByPreId(thisTask.id);
                        if (thisHoujiTaskList != null && thisHoujiTaskList.Count > 0)
                        {
                            thisHoujiTaskList.ForEach(_ =>
                            {
                                UpdateTaskDate(_.id, user_id);
                            });
                        }
                        #endregion

                        //  需要改变则更改相关父阶段，项目的开始结束时间
                        if (thisTask.parent_id != null)
                        {
                            AdjustmentDate((long)thisTask.parent_id, user_id);
                        }
                        AdjustProDate((long)thisTask.project_id, user_id);
                    }
                }
            }
        }

        /// <summary>
        /// 不考虑其他因素，只更改task
        /// </summary>
        public bool OnlyEditTask(sdk_task thisTask, long user_id)
        {
            var oldTask = _dal.FindNoDeleteById(thisTask.id);
            if (oldTask == null)
            {
                return false;
            }
            thisTask.update_user_id = user_id;
            thisTask.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            OperLogBLL.OperLogUpdate<sdk_task>(thisTask, oldTask, thisTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
            _dal.Update(thisTask);
            return true;
        }

        /// <summary>
        /// 任务完成插入备注
        /// </summary>
        public void InsActTaskDone(long task_id, long user_id)
        {
            var thisTask = _dal.FindNoDeleteById(task_id);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (thisTask != null && thisTask.status_id == (int)DicEnum.TICKET_STATUS.DONE && user != null)
            {
                var activity = new com_activity()
                {
                    id = _dal.GetNextIdCom(),
                    cate_id = (int)DicEnum.ACTIVITY_CATE.TASK_NOTE,
                    action_type_id = (int)ACTIVITY_TYPE.TASK_NOTE,
                    object_id = thisTask.id,
                    object_type_id = (int)OBJECT_TYPE.TASK,
                    resource_id = thisTask.owner_resource_id,
                    name = "完成原因",
                    description = $"任务被{user.name}取消，时间为{DateTime.Now.ToString("yyyy-MM-dd")}",
                    publish_type_id = (int)NOTE_PUBLISH_TYPE.PROJECT_ALL_USER,
                    create_user_id = user.id,
                    update_user_id = user.id,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    is_system_generate = 1,
                    task_id = thisTask.id,
                    task_status_id = (int)DicEnum.TICKET_STATUS.DONE,
                };
                new com_activity_dal().Insert(activity);
                OperLogBLL.OperLogAdd<com_activity>(activity, activity.id, user.id, OPER_LOG_OBJ_CATE.NOTIFY, "修改项目状态-添加通知");
            }

        }

        /// <summary>
        /// 递归修改父Task 的时间
        /// </summary>
        public void UpdateParDate(long? tid, long startDate, DateTime endDate, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (tid != null && user != null)
            {
                var parTask = _dal.FindNoDeleteById((long)tid);
                if (parTask != null)
                {
                    if (parTask.estimated_begin_time > startDate || parTask.estimated_end_time < Tools.Date.DateHelper.ToUniversalTimeStamp(endDate))
                    {
                        if (parTask.estimated_begin_time > startDate)
                        {
                            parTask.estimated_begin_time = startDate;
                        }
                        if (parTask.estimated_end_time < Tools.Date.DateHelper.ToUniversalTimeStamp(endDate))
                        {
                            parTask.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(endDate);
                        }
                        parTask.update_user_id = user.id;
                        parTask.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        OperLogBLL.OperLogUpdate<sdk_task>(parTask, _dal.FindNoDeleteById(parTask.id), parTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                        _dal.Update(parTask);
                        UpdateParDate(parTask.parent_id, (long)parTask.estimated_begin_time, Tools.Date.DateHelper.ConvertStringToDateTime((long)parTask.estimated_end_time), user_id);
                    }
                }
            }
        }
        /// <summary>
        /// 根据开始时间结束时间计算任务的持续时间(当用户未填写持续时间时，根据这个进行计算)
        /// </summary>
        public int GetDayByTime(long start_time, long end_time, long project_id)
        {
            var thisProject = new pro_project_dal().FindNoDeleteById(project_id);
            var startDate = Tools.Date.DateHelper.ConvertStringToDateTime(start_time);
            var endDate = Tools.Date.DateHelper.ConvertStringToDateTime(end_time);
            // 得出实际相差天数，筛选除去设置后，真是相差天数
            TimeSpan ts1 = new TimeSpan(startDate.Ticks);
            TimeSpan ts2 = new TimeSpan(endDate.Ticks);
            var diffDays = ts1.Subtract(ts2).Duration().Days + 1;   // 天数需要+1  //
            var realDays = 0;
            if (thisProject.exclude_weekend == 1)
            {
                for (int i = 0; i < diffDays; i++)
                {
                    var thisDate = startDate.AddDays(i);
                    var thisWeekDays = thisDate.DayOfWeek;
                    if (thisWeekDays != DayOfWeek.Saturday && thisWeekDays != DayOfWeek.Sunday)
                    {
                        realDays++;
                    }
                }
            }
            else
            {
                realDays = diffDays;
            }

            if (thisProject.exclude_holiday == 0 && thisProject.organization_location_id != null)
            {
                var holDays = 0;
                var thisLocation = new sys_organization_location_dal().FindNoDeleteById((long)thisProject.organization_location_id);
                if (thisLocation != null)
                {
                    var holiDays = new d_holiday_dal().GetHoliDays(thisLocation.holiday_set_id);
                    if (holiDays != null && holiDays.Count > 0)
                    {
                        foreach (var thisHol in holiDays)
                        {
                            if (startDate < thisHol.hd && thisHol.hd < endDate)
                            {
                                if (thisHol.hd_type == 1)
                                {
                                    holDays -= 1;
                                }
                                else if (thisHol.hd_type == 0)
                                {
                                    holDays += 1;
                                }
                            }
                        }
                    }
                }
                if (holDays != 0)
                {
                    realDays += holDays;
                }
            }
            return realDays;
        }


        /// <summary>
        /// 根据时间，和延迟（持续）时间，计算应该推迟到那一天（包括项目的周末和节假日的设置）
        /// </summary>
        /// <param name="project_id">项目的Id</param>
        /// <param name="thisDate">传进去日期</param>
        /// <param name="days">延迟的天数</param>
        /// <returns>返回计算出来的日期</returns>
        public DateTime RetrunMaxTime(long project_id, DateTime thisDate, int days)
        {
            var starDate = new DateTime(thisDate.Year, thisDate.Month, thisDate.Day);
            var newThisDate = thisDate;
            var thisProject = new pro_project_dal().FindNoDeleteById(project_id);

            if (days >= 0)
            {
                if (thisProject.exclude_weekend == 1)    // 调整任务不包括非工作日（周末）
                {
                    newThisDate = ReturnDateWtihWeek(thisDate, days, false);
                    //newThisDate = newThisDate.AddDays(-1);
                }
                else
                {
                    newThisDate = thisDate.AddDays(days);
                }

                if (thisProject.exclude_holiday == 0 && thisProject.organization_location_id != null)
                {
                    var holDays = 0;
                    var thisLocation = new sys_organization_location_dal().FindNoDeleteById((long)thisProject.organization_location_id);
                    if (thisLocation != null)
                    {
                        var holiDays = new d_holiday_dal().GetHoliDays(thisLocation.holiday_set_id);
                        if (holiDays != null && holiDays.Count > 0)
                        {
                            foreach (var thisHol in holiDays)
                            {
                                if (starDate < thisHol.hd && thisHol.hd < newThisDate)
                                {
                                    if (thisHol.hd_type == 1)
                                    {
                                        holDays -= 1;
                                    }
                                    else if (thisHol.hd_type == 0)
                                    {
                                        holDays += 1;
                                    }
                                }
                            }
                        }
                    }
                    if (holDays != 0)
                    {
                        if (thisProject.exclude_weekend == 0)    // 调整任务不包括非工作日（周末）
                        {
                            newThisDate = ReturnDateWtihWeek(newThisDate, holDays, true);
                        }
                        else
                        {
                            newThisDate = newThisDate.AddDays(holDays);
                        }
                    }
                }
            }
            else
            {
                newThisDate = ReturnDateWtihWeek(thisDate, days, true);
                if (thisProject.exclude_holiday == 0 && thisProject.organization_location_id != null)
                {
                    var holDays = 0;
                    var thisLocation = new sys_organization_location_dal().FindNoDeleteById((long)thisProject.organization_location_id);
                    if (thisLocation != null)
                    {
                        var holiDays = new d_holiday_dal().GetHoliDays(thisLocation.holiday_set_id);
                        if (holiDays != null && holiDays.Count > 0)
                        {
                            foreach (var thisHol in holiDays)
                            {
                                if (starDate < thisHol.hd && thisHol.hd < newThisDate)
                                {
                                    if (thisHol.hd_type == 1)
                                    {
                                        holDays -= 1;
                                    }
                                    else if (thisHol.hd_type == 0)
                                    {
                                        holDays += 1;
                                    }
                                }
                            }
                        }
                    }
                    if (holDays != 0)
                    {
                        if (thisProject.exclude_weekend == 0)    // 调整任务不包括非工作日（周末）
                        {
                            newThisDate = ReturnDateWtihWeek(newThisDate, 0 - holDays, true);
                        }
                        else
                        {
                            newThisDate = newThisDate.AddDays(0 - holDays);
                        }
                    }
                }
            }

            return newThisDate;
        }

        /// <summary>
        /// 计算往后推迟(退前)几天的返回天数（是否包括周末）
        /// </summary>
        public DateTime ReturnDateWtihWeek(DateTime thisDate, int days, bool isCloWeekday)
        {

            var newDate = thisDate;
            if (days >= 0)
            {
                days = days - 1;
                if (isCloWeekday)  // true 代表包括周末
                {
                    newDate = thisDate.AddDays(days);
                }
                else
                {
                    // 1.计算第一周
                    // 2.剩余添加天数除5 添加周
                    // 3.添加最后一周天数
                    // 1.
                    var firstWeek = (int)newDate.DayOfWeek;    //计算开始时间是周几。。 
                    if (firstWeek > 0 && firstWeek <= 5)
                    {
                        if (days < 6 - firstWeek)
                        {
                            newDate = newDate.AddDays(days);
                        }
                        else
                        {
                            newDate = newDate.AddDays(7 - firstWeek + 1);
                        }
                        days -= (6 - firstWeek);
                    }
                    else
                    {
                        newDate = newDate.AddDays(firstWeek == 0 ? 1 : 2); // 周末补到星期一去处理
                    }
                    if (days > 0)
                    {
                        // 2.
                        var weekNum = days / 5;
                        newDate = newDate.AddDays(weekNum * 7);
                        // 3.
                        if (days % 5 != 0)
                        {
                            newDate = newDate.AddDays(days % 5);
                        }
                    }
                }
            }
            else
            {
                days = days + 1;
                if (isCloWeekday)  // true 代表包括周末
                {
                    newDate = thisDate.AddDays(days);
                }
                else
                {
                    // 1.计算本周几天
                    // 2.计算剩余几周
                    // 3.剩余天数倒推算应该是哪一天
                    var xuhuanDays = 0 - days;
                    for (int i = 0; i < xuhuanDays; i++)
                    {
                        var thisDays = thisDate.AddDays(0 - i);
                        var thisDayWeek = (int)thisDays.DayOfWeek;
                        if (thisDayWeek == 0 || thisDayWeek == 6)
                        {
                            xuhuanDays++;
                        }
                        newDate = newDate.AddDays(-1);
                    }
                    var newDateDayWeek = (int)newDate.DayOfWeek;
                    if (newDateDayWeek == 0)
                    {
                        newDate = newDate.AddDays(-2);
                    }
                    else if (newDateDayWeek == 6)
                    {
                        newDate = newDate.AddDays(-1);
                    }
                }
            }
            return newDate;

        }

        /// <summary>
        /// 返回Task编号
        /// </summary>
        public string ReturnTaskNo()
        {
            string no = "T" + DateTime.Now.ToString("yyyyMMdd");
            var taskList = _dal.GetTaskByNo(no);
            if (taskList != null && taskList.Count > 0)
            {
                int maxNo = 0;
                taskList.ForEach(_ =>
                {
                    try
                    {
                        var noList = _.no.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                        if (noList.Count() >= 2)
                        {
                            var thisNo = int.Parse(noList[1]);
                            if (maxNo < thisNo)
                            {
                                maxNo = thisNo;
                            }
                        }
                    }
                    catch (Exception)
                    { }
                });
                maxNo += 1;
                return no + '.' + maxNo.ToString("0000");
            }
            else
            {
                return no + ".0001";
            }
        }


        #region 获取排序号重复代码-备用
        ///// <summary>
        ///// 返回新增的task的排序号
        ///// </summary>
        //public string ReturnSortOrder(long project_id, long? parTask_id)
        //{
        //    string sorNo = "";
        //    var taskList = _dal.GetProTask(project_id);
        //    if (taskList != null && taskList.Count > 0)
        //    {
        //        if (parTask_id == null)
        //        {
        //            var noParTaskList = taskList.Where(_ => _.parent_id == null).ToList();
        //            if (noParTaskList != null && noParTaskList.Count > 0)
        //            {
        //                sorNo = (int.Parse(noParTaskList.Max(_ => _.sort_order)) + 1).ToString("#00");
        //            }
        //            else
        //            {
        //                sorNo = "01";
        //            }
        //        }
        //        else
        //        {
        //            var parTask = _dal.FindNoDeleteById((long)parTask_id);
        //            var parTaskList = taskList.Where(_ => _.parent_id == parTask_id).ToList();
        //            if (parTaskList != null && parTaskList.Count > 0)
        //            {
        //                var maxSortNo = parTaskList.Max(_ => _.sort_order);
        //                var maxSortNoArr = maxSortNo.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
        //                var maxNo = (int.Parse(maxSortNoArr[maxSortNoArr.Length - 1]) + 1).ToString("#00");
        //                var thisMaxNo = "";
        //                for (int i = 0; i < maxSortNoArr.Length; i++)
        //                {

        //                    if (i == maxSortNoArr.Length - 1)
        //                    {
        //                        thisMaxNo += maxNo;
        //                    }
        //                    else
        //                    {
        //                        thisMaxNo += maxSortNoArr[i] + ".";
        //                    }
        //                }
        //                sorNo = thisMaxNo;
        //            }
        //            else
        //            {
        //                sorNo = parTask.sort_order + ".01";
        //            }
        //        }
        //    }
        //    else
        //    {
        //        sorNo = "01";
        //    }
        //    return sorNo;
        //}
        #endregion 

        /// <summary>
        /// 返回阶段的预估时间
        /// </summary>
        public decimal ReturnPhaBugHours(long phase_id)
        {
            decimal hours = 0;
            var thisPhase = _dal.FindNoDeleteById(phase_id);
            if (thisPhase != null && thisPhase.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE)
            {
                var budList = new sdk_task_budget_dal().GetListByTaskId(thisPhase.id);
                if (budList != null && budList.Count > 0)
                {
                    hours = budList.Sum(_ => _.estimated_hours);
                }
            }

            return hours;
        }

        /// <summary>
        /// 修改task的排序号(递归修改子节点排序号)
        /// </summary>
        public void ChangeTaskSortNo(string sortNo, long taskId, long user_id)
        {
            var thisTask = _dal.FindNoDeleteById(taskId);
            if (thisTask != null)
            {
                var dateNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var oldSortNo = thisTask.sort_order;
                thisTask.sort_order = sortNo;
                thisTask.update_time = dateNow;
                thisTask.update_user_id = user_id;
                OperLogBLL.OperLogUpdate<sdk_task>(thisTask, _dal.FindNoDeleteById(thisTask.id), thisTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                _dal.Update(thisTask);

                var subTaskList = _dal.GetTaskByParentId(thisTask.id);
                if (subTaskList != null && subTaskList.Count > 0)
                {
                    var parDepthNum = thisTask.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var thisSubTask in subTaskList)
                    {
                        var thisNoChaNo = thisSubTask.sort_order.Remove(0, oldSortNo.Length);  // 获取到不会改变的部分 todo 临界值测试
                        var newNo = thisTask.sort_order + thisNoChaNo;
                        ChangeTaskSortNo(newNo, thisSubTask.id, user_id);
                    }
                }
            }
        }

        #region task排序号相关改变事件
        /// <summary>
        /// 通过父节点改变兄弟节点的排序号(补足空余排序号，同时修改本身的子节点的排序号) parid为null代表项目下的节点
        /// </summary>
        public void ChangBroTaskSortNoReduce(long project_id, long? par_task_id, long user_id)
        {
            var thisProject = new pro_project_dal().FindNoDeleteById(project_id);

            if (par_task_id == null)
            {
                var noParTaskList = _dal.GetNoParTaskByProId(project_id); // 为没有父节点的task排序
                if (noParTaskList != null && noParTaskList.Count > 0)
                {
                    // 上一兄弟节点找不到，补到最小的可用的节点
                    var nextNo = GetMinUserNoParSortNo(project_id);
                    noParTaskList = noParTaskList.OrderBy(_ => _.sort_order).ToList();
                    foreach (var noParTask in noParTaskList)
                    {
                        if (int.Parse(noParTask.sort_order) > int.Parse(nextNo))
                        {
                            ChangeTaskSortNo(nextNo, noParTask.id, user_id);
                            //noParTask.sort_order = nextNo;
                            //_dal.Update(noParTask);
                            nextNo = GetMinUserNoParSortNo(project_id);
                        }
                    }
                }
            }
            else
            {
                var parTask = _dal.FindNoDeleteById((long)par_task_id);
                var thisparTaskMaxNo = GetMinUserSortNo((long)par_task_id);
                var thisSubList = _dal.GetTaskByParentId((long)par_task_id);
                if (thisSubList != null && thisSubList.Count > 0)
                {
                    var thisparTaskMaxNoArr = thisparTaskMaxNo.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                    var shoChaList = thisSubList.Where(_ =>
                    {
                        var result = false;
                        var thisSortNoArr = _.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                        if (int.Parse(thisSortNoArr[thisSortNoArr.Length - 1]) > int.Parse(thisparTaskMaxNoArr[thisparTaskMaxNoArr.Length - 1]))
                        {
                            result = true;
                        }
                        return result;
                    }).ToList();

                    if (shoChaList != null && shoChaList.Count > 0)
                    {
                        foreach (var thisSub in shoChaList)
                        {
                            ChangeTaskSortNo(thisparTaskMaxNo, thisSub.id, user_id);
                            //thisSub.sort_order = thisparTaskMaxNo;
                            //_dal.Update(thisSub);
                            // 查日志
                            thisparTaskMaxNo = GetMinUserSortNo(parTask.id);

                        }
                    }

                }
            }
        }
        /// <summary>
        /// 获取到最小的可用的排序号
        /// </summary>
        public string GetMinUserNoParSortNo(long project_id)
        {
            var nextNo = "";
            var noParTaskList = _dal.GetNoParTaskByProId(project_id); // 为没有父节点的task排序
            if (noParTaskList != null && noParTaskList.Count > 0)
            {
                // 上一兄弟节点找不到，补到最小的可用的节点
                noParTaskList = noParTaskList.OrderBy(_ => _.sort_order).ToList();
                foreach (var noParTask in noParTaskList)
                {
                    var thisNextNo = (int.Parse(noParTask.sort_order) + 1).ToString("#00");
                    if (!noParTaskList.Any(_ => _.sort_order == thisNextNo))
                    {
                        nextNo = thisNextNo;
                    }
                    if (nextNo != "")
                    {
                        break;
                    }
                }
                if (nextNo == "")
                {
                    nextNo = GetMinUserNoParSortNo(project_id);
                }
            }
            else
            {
                nextNo = "01";
            }
            return nextNo;
        }
        /// <summary>
        /// 获取到这个task下的最小的可用的排序号
        /// </summary>
        public string GetMinUserSortNo(long task_id)
        {
            var sortNo = "";
            var thisTask = _dal.FindNoDeleteById(task_id);
            if (thisTask != null)
            {
                var thisSubTaskList = _dal.GetTaskByParentId(thisTask.id);
                if (thisSubTaskList != null && thisSubTaskList.Count > 0)
                {
                    var nextNo = "";
                    int num = 0;
                    foreach (var thisSubTask in thisSubTaskList)
                    {

                        var thisNoArr = thisSubTask.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                        var thisNextNo = thisTask.sort_order + "." + (num + 1).ToString("#00");
                        num++;
                        if (!thisSubTaskList.Any(_ => _.sort_order == thisNextNo))
                        {
                            nextNo = thisNextNo;
                        }
                        if (nextNo != "")
                        {
                            break;
                        }
                    }
                    if (nextNo == "")
                    {
                        sortNo = thisTask.sort_order + "." + (num + 1).ToString("#00");
                    }
                    else
                    {
                        sortNo = nextNo;
                    }
                }
                else
                {
                    sortNo = thisTask.sort_order + ".01";
                }
            }
            return sortNo;
        }
        /// <summary>
        /// 新增兄弟节点，改变其他相关节点的位置
        /// </summary>
        /// <param name="taskId">要取代的task的id</param>
        /// <param name="num"></param>
        /// <param name="user"></param>
        public void ChangeBroTaskSortNoAdd(long taskId, int num, long user_id)
        {
            // 1 获取到在这个task之后的task（包含它本身）
            // 2 循环增加排序号（同时更新子节点相关排序号）

            var thisTask = _dal.FindNoDeleteById(taskId);
            if (thisTask != null)
            {
                List<sdk_task> subTaskList = new List<sdk_task>();
                if (thisTask.parent_id == null)
                {
                    subTaskList = _dal.GetNoParTaskByProId((long)thisTask.project_id);
                }
                else
                {
                    subTaskList = _dal.GetTaskByParentId((long)thisTask.parent_id);
                }

                if (subTaskList != null && subTaskList.Count > 0)
                {
                    var thisNoArr = thisTask.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                    var thisNo = thisNoArr[thisNoArr.Length - 1];
                    // 获取到需要改变的task
                    var shoChaList = subTaskList.Where(_ =>
                    {
                        var result = false;
                        var thisSortNoArr = _.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                        if (int.Parse(thisSortNoArr[thisSortNoArr.Length - 1]) >= int.Parse(thisNo))
                        {
                            result = true;
                        }
                        return result;
                    }).ToList();
                    if (shoChaList != null && shoChaList.Count > 0)
                    {
                        shoChaList = shoChaList.OrderBy(_ => _.sort_order).ToList();
                        shoChaList.Reverse();
                        foreach (var shooChaTask in shoChaList)
                        {
                            var shooChaTaskNoArr = shooChaTask.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                            var lastshooChaTaskNo = shooChaTaskNoArr[0]; // 获取到开始数字加一

                            var noChange = "";
                            if (shooChaTask.sort_order.Length > 3)
                            {
                                noChange = shooChaTask.sort_order.Substring(2);
                            }
                            // var thisNoChaNo = shooChaTask.sort_order.Substring(0, lastshooChaTaskNo.Length );  // 获取到不会改变的部分 todo 临界值测试
                            var newNo = (int.Parse(lastshooChaTaskNo) + num).ToString("#00") + noChange;
                            ChangeTaskSortNo(newNo, shooChaTask.id, user_id);
                        }
                    }

                }
            }

        }
        /// <summary>
        /// 当插入节点不是阶段时，新增阶段并将原节点转移到阶段下，返回阶段ID
        /// </summary>
        public long? InsertPhase(long task_id, long user_id)
        {
            long? id = null;
            var user = UserInfoBLL.GetUserInfo(user_id);
            var oriTask = _dal.FindNoDeleteById(task_id);  // Original获取到原本的taskid，不是阶段时进行操作
            if (user != null && oriTask != null && oriTask.type_id != (int)DicEnum.TASK_TYPE.PROJECT_PHASE)
            {
                #region 创建新阶段
                var newPhase = new sdk_task()
                {
                    id = _dal.GetNextIdCom(),
                    project_id = oriTask.project_id,
                    status_id = (int)DicEnum.TICKET_STATUS.NEW,
                    type_id = (int)DicEnum.TASK_TYPE.PROJECT_PHASE,
                    title = oriTask.title,
                    account_id = oriTask.account_id,
                    estimated_begin_time = oriTask.estimated_begin_time,
                    estimated_end_time = oriTask.estimated_end_time,
                    estimated_duration = oriTask.estimated_duration,
                    no = ReturnTaskNo(),
                    create_user_id = user.id,
                    update_user_id = user.id,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    sort_order = oriTask.sort_order,
                    parent_id = oriTask.parent_id,
                };
                _dal.Insert(newPhase);
                OperLogBLL.OperLogAdd<sdk_task>(newPhase, newPhase.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "新增阶段");
                id = newPhase.id;
                var old_task_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TASK);
                //var old_task_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.TASK, oriTask.id, old_task_udfList);
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.TASK, user.id,
                newPhase.id, old_task_udfList, null, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK);
                #endregion

                #region 更改原来的task的相关信息
                oriTask.sort_order = GetMinUserSortNo(newPhase.id);
                oriTask.parent_id = newPhase.id;
                oriTask.update_user_id = user.id;
                oriTask.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                OperLogBLL.OperLogUpdate<sdk_task>(oriTask, _dal.FindNoDeleteById(oriTask.id), oriTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                _dal.Update(oriTask);
                #endregion

            }
            return id;
        }
        /// <summary>
        /// 两个兄弟节点位置互换
        /// </summary>
        public void ChangeSubTaskSort(long project_id, long? parent_id, long from_id, long to_id, long user_id)
        {
            List<sdk_task> subList = null;
            sdk_task parentTask = null;
            if (parent_id == null)
            {
                subList = _dal.GetNoParTaskByProId(project_id);
            }
            else
            {
                parentTask = _dal.FindNoDeleteById((long)parent_id);
                subList = _dal.GetTaskByParentId((long)parent_id);
            }

            if (subList != null && subList.Count > 0)
            {
                var fromTask = subList.FirstOrDefault(_ => _.id == from_id);
                var toTask = subList.FirstOrDefault(_ => _.id == to_id);
                if (fromTask != null && toTask != null)
                {
                    var fromTaskSortArr = fromTask.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                    var toTaskSortArr = toTask.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                    if (int.Parse(toTaskSortArr[toTaskSortArr.Length - 1]) > int.Parse(fromTaskSortArr[fromTaskSortArr.Length - 1]))
                    {
                        // 筛选出在两者之间的兄弟节点
                        var needChangeTaskList = subList.Where(_ =>
                        {
                            var thisSortArr = _.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                            if (int.Parse(thisSortArr[thisSortArr.Length - 1]) > int.Parse(fromTaskSortArr[fromTaskSortArr.Length - 1]) && int.Parse(thisSortArr[thisSortArr.Length - 1]) < int.Parse(toTaskSortArr[toTaskSortArr.Length - 1]))
                            {
                                return true;
                            }
                            else
                            {
                                return false;
                            }
                        }).ToList();
                        if (needChangeTaskList != null && needChangeTaskList.Count > 0)
                        {
                            needChangeTaskList = needChangeTaskList.OrderBy(_ => _.sort_order).ToList();
                            var parentSort = "";
                            if (parentTask != null)
                            {
                                parentSort = parentTask.sort_order + ".";
                            }
                            var lastSort = needChangeTaskList[needChangeTaskList.Count - 1].sort_order;
                            foreach (var thisNeedChaTask in needChangeTaskList)
                            {
                                var thisLastSortArr = thisNeedChaTask.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                                var newSort = parentSort + (int.Parse(thisLastSortArr[thisLastSortArr.Length - 1]) - 1).ToString("#00");
                                ChangeTaskSortNo(newSort, thisNeedChaTask.id, user_id);
                            }
                            ChangeTaskSortNo(lastSort, fromTask.id, user_id);
                        }
                        //else
                        //{
                        //    fromTask.sort_order = toTask.sort_order;
                        //    toTask.sort_order = fromTask.sort_order;
                        //    OnlyEditTask(fromTask,user_id);
                        //    OnlyEditTask(toTask, user_id);
                        //}
                    }
                    else
                    {
                        var needChangeTaskList = subList.Where(_ =>
                        {
                            var thisSortArr = _.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                            if (int.Parse(thisSortArr[thisSortArr.Length - 1]) < int.Parse(fromTaskSortArr[fromTaskSortArr.Length - 1]) && int.Parse(thisSortArr[thisSortArr.Length - 1]) >= int.Parse(toTaskSortArr[toTaskSortArr.Length - 1]))
                            {
                                return true;
                            }
                            else
                            {
                                return false;
                            }
                        }).ToList();
                        if (needChangeTaskList != null && needChangeTaskList.Count > 0)
                        {
                            needChangeTaskList = needChangeTaskList.OrderBy(_ => _.sort_order).ToList();
                            var parentSort = "";
                            if (parentTask != null)
                            {
                                parentSort = parentTask.sort_order + ".";
                            }
                            var firstSort = needChangeTaskList[0].sort_order;
                            foreach (var thisNeedChaTask in needChangeTaskList)
                            {
                                var thisLastSortArr = thisNeedChaTask.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                                var newSort = parentSort + (int.Parse(thisLastSortArr[thisLastSortArr.Length - 1]) + 1).ToString("#00");
                                ChangeTaskSortNo(newSort, thisNeedChaTask.id, user_id);
                            }
                            ChangeTaskSortNo(firstSort, fromTask.id, user_id);
                        }
                        //else
                        //{
                        //    fromTask.sort_order = toTask.sort_order;
                        //    toTask.sort_order = fromTask.sort_order;
                        //    OnlyEditTask(fromTask, user_id);                                                                                                                                                                                                                                                                                                
                        //    OnlyEditTask(toTask, user_id);
                        //}
                    }

                }
            }

        }

        #endregion

        /// <summary>
        /// 导入task，为task的sort重新排序，no重新获取
        /// </summary>
        public void ImportFromTemp(long project_id, string taskIds, long user_id, bool isCopyTeamber)
        {
            var ppDal = new pro_project_dal();
            var thisProject = ppDal.FindNoDeleteById(project_id);
            var user = UserInfoBLL.GetUserInfo(user_id);
            var nowDate = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (thisProject != null && user != null)
            {
                if (!string.IsNullOrEmpty(taskIds))
                {
                    var taskIDArr = taskIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    // 导入，无需排序
                    // 创建字典，关联新老关系
                    // todo - 关联前驱后续相关关系
                    var strDal = new sdk_task_resource_dal();
                    var stpDal = new sdk_task_predecessor_dal();
                    Dictionary<long, long> idDic = new Dictionary<long, long>(); // task 的ID 的新旧关联
                    Dictionary<long, List<sdk_task_predecessor>> taskPreDic = new Dictionary<long, List<sdk_task_predecessor>>();  // 新的taskID 和 旧的前驱任务的对应
                    foreach (var thisTaskId in taskIDArr)
                    {
                        var thisTask = _dal.FindNoDeleteById(long.Parse(thisTaskId));
                        if (thisTask != null)
                        {
                            var taskResList = strDal.GetTaskResByTaskId(thisTask.id);
                            if (thisTask.project_id == null)
                                continue;
                            var oldProject = ppDal.FindNoDeleteById((long)thisTask.project_id);
                            if (oldProject == null)
                                continue;
                            int diffDays = GetDiffDays((DateTime)oldProject.start_date,Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time));
                            #region task相关
                            // 获取到旧的任务与旧的项目开始天数时间差，平移到新的项目上
                            var oldId = thisTask.id;
                            if (thisTask.parent_id != null && taskIDArr.Contains(thisTask.parent_id.ToString()))
                            {
                                var newParId = idDic.FirstOrDefault(_ => _.Key == (long)thisTask.parent_id).Value;
                                var newSortNo = GetMinUserSortNo(newParId);
                                thisTask.parent_id = newParId;
                                thisTask.sort_order = newSortNo;
                            }
                            else
                            {
                                var newSortNo = GetMinUserNoParSortNo(project_id);
                                thisTask.sort_order = newSortNo;
                                thisTask.parent_id = null;
                            }
                            thisTask.oid = 0;
                            thisTask.id = _dal.GetNextIdCom();
                            thisTask.project_id = thisProject.id;
                            thisTask.no = ReturnTaskNo();
                            thisTask.create_user_id = user.id;
                            thisTask.update_user_id = user.id;
                            thisTask.create_time = nowDate;
                            thisTask.update_time = nowDate;
                            thisTask.owner_resource_id = isCopyTeamber ? thisTask.owner_resource_id : null;
                            thisTask.estimated_begin_time = Tools.Date.DateHelper.ToUniversalTimeStamp(((DateTime)thisProject.start_date).AddDays(diffDays));
                            thisTask.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(RetrunMaxTime(thisProject.id, ((DateTime)thisProject.start_date).AddDays(diffDays),(int)thisTask.estimated_duration));
                            _dal.Insert(thisTask);
                            OperLogBLL.OperLogAdd<sdk_task>(thisTask, thisTask.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "新增task");
                            idDic.Add(oldId, thisTask.id);
                            #endregion

                            #region task团队相关
                            if (taskResList != null && taskResList.Count > 0)
                            {
                                taskResList.ForEach(tr =>
                                {
                                    tr.id = strDal.GetNextIdCom();
                                    tr.oid = 0;
                                    tr.create_user_id = user.id;
                                    tr.create_time = nowDate;
                                    tr.update_time = nowDate;
                                    tr.update_user_id = user.id;
                                    tr.contact_id = null;
                                    tr.task_id = thisTask.id;
                                    strDal.Insert(tr);
                                    OperLogBLL.OperLogAdd<sdk_task_resource>(tr, tr.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "从模板导入任务分配对象");
                                });
                            }

                            #endregion

                            #region 获取相关前驱任务信息
                            var thisPreList = stpDal.GetRelList(long.Parse(thisTaskId));
                            if (thisPreList != null && thisPreList.Count > 0)
                                taskPreDic.Add(thisTask.id,thisPreList);
                            #endregion
                        }
                    }

                    if (taskPreDic.Count > 0)
                    {
                        foreach (var taskPre in taskPreDic)
                        {
                            taskPre.Value.ForEach(_ => {
                                if (taskIDArr.Contains(_.predecessor_task_id.ToString())&& idDic.Any(thisID => thisID.Key == _.predecessor_task_id))
                                {
                                    var preNewId = idDic.FirstOrDefault(thisID => thisID.Key == _.predecessor_task_id).Value;
                                    var thisPre = new sdk_task_predecessor() {
                                        id = stpDal.GetNextIdCom(),
                                        task_id = taskPre.Key,
                                        create_time = nowDate,
                                        update_time = nowDate,
                                        create_user_id = user_id,
                                        update_user_id = user_id,
                                        predecessor_task_id = preNewId,
                                        dependant_lag = _.dependant_lag,
                                    };
                                    stpDal.Insert(thisPre);
                                    OperLogBLL.OperLogAdd<sdk_task_predecessor>(thisPre, thisPre.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_PREDECESSOR, "新增task前驱");
                                }
                            });
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 获取task已计费金额
        /// </summary>
        public decimal GetTaskBilledDollar(long task_id)
        {
            decimal totalMoney = 0;
            var sweList = new sdk_work_entry_dal().GetByTaskId(task_id);
            var dccDal = new d_cost_code_dal();
            var srDal = new sys_role_dal();
            if (sweList != null && sweList.Count > 0)
            {
                foreach (var swe in sweList)
                {
                    if (swe.is_billable == 0 || swe.hours_billed == null)
                    {
                        continue;
                    }
                    if (swe.cost_code_id != null && swe.role_id != null)
                    {
                        var thisCostCode = dccDal.FindNoDeleteById((long)swe.cost_code_id);
                        var thisRole = srDal.FindNoDeleteById((long)swe.role_id);
                        if (thisCostCode != null && thisRole != null)
                        {
                            if (thisCostCode.show_on_invoice != (int)DicEnum.SHOW_ON_INVOICE.BILLED)
                            {
                                continue;
                            }
                            var billHours = (decimal)swe.hours_billed;
                            if (thisCostCode.min_hours != null && billHours < thisCostCode.min_hours)
                            {
                                billHours = (decimal)thisCostCode.min_hours;
                            }
                            if (thisCostCode.max_hours != null && billHours > thisCostCode.max_hours)
                            {
                                billHours = (decimal)thisCostCode.max_hours;
                            }

                            switch (thisCostCode.billing_method_id)
                            {
                                case (int)DicEnum.WORKTYPE_BILLING_METHOD.USE_ROLE_RATE:
                                    totalMoney += (billHours * thisRole.hourly_rate);
                                    break;
                                case (int)DicEnum.WORKTYPE_BILLING_METHOD.FLOAT_ROLE_RATE:
                                    if (thisCostCode.rate_adjustment != null)
                                    {
                                        totalMoney += (billHours * (thisRole.hourly_rate + (decimal)thisCostCode.rate_adjustment));
                                    }
                                    break;
                                case (int)DicEnum.WORKTYPE_BILLING_METHOD.RIDE_ROLE_RATE:
                                    if (thisCostCode.rate_multiplier != null)
                                    {
                                        totalMoney += (billHours * (thisRole.hourly_rate * (decimal)thisCostCode.rate_multiplier));
                                    }
                                    break;
                                case (int)DicEnum.WORKTYPE_BILLING_METHOD.USE_UDF_ROLE_RATE:
                                    if (thisCostCode.custom_rate != null)
                                    {
                                        totalMoney += (billHours * (decimal)thisCostCode.custom_rate);
                                    }
                                    break;
                                case (int)DicEnum.WORKTYPE_BILLING_METHOD.BY_TIMES:
                                    if (thisCostCode.flat_rate != null)
                                    {
                                        totalMoney += (billHours * (decimal)thisCostCode.flat_rate);
                                    }
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                }
            }
            return totalMoney;
        }
        /// <summary>
        /// 获取到task的变更单变更金额
        /// </summary>
        public decimal GetTaskChangeDollar(long task_id)
        {
            decimal totalMoney = 0;
            var cadDal = new crm_account_deduction_dal();
            var thisTaskDedList = cadDal.GetDedListByTaskId(task_id);
            if (thisTaskDedList != null && thisTaskDedList.Count > 0)
            {
                foreach (var thisTaskDed in thisTaskDedList)
                {
                    if (thisTaskDed.extended_price != null)
                    {
                        totalMoney += (decimal)thisTaskDed.extended_price;
                    }
                }
            }
            return totalMoney;
        }


        /// <summary>
        ///  获取到前驱任务中的最晚时间 （没有返回任务的开始时间）
        /// </summary>
        public DateTime GetPreMaxTime(long taskId)
        {
            var stpDal = new sdk_task_predecessor_dal();
            var thisTask = _dal.FindNoDeleteById(taskId);
            var maxDate = Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time);
            if (thisTask != null)
            {
                var preList = stpDal.GetRelList(thisTask.id);
                if (preList != null && preList.Count > 0)
                {
                    preList.ForEach(_ =>
                    {
                        var thisPreTask = _dal.FindNoDeleteById(_.predecessor_task_id);
                        if (thisPreTask != null)
                        {
                            var thisDate = Tools.Date.DateHelper.ConvertStringToDateTime(((long)thisPreTask.estimated_end_time)).AddDays(_.dependant_lag);
                            if (thisDate > maxDate)
                            {
                                maxDate = thisDate;
                            }
                        }
                    });
                }
            }
            return maxDate;

        }

        /// <summary>
        /// 将选中task的开始时间，结束时间平移相应天数
        /// </summary>
        public bool ChangeTaskTime(string ids, int days, long user_id)
        {
            bool result = false;
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                if (!string.IsNullOrEmpty(ids) && user != null)
                {
                    var idArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var taskId in idArr)
                    {
                        var thisTask = _dal.FindNoDeleteById(long.Parse(taskId));
                        if (thisTask != null)
                        {
                            var startDate = Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time);
                            var newStartDate = RetrunMaxTime((long)thisTask.project_id, startDate, days);
                            thisTask.estimated_begin_time = Tools.Date.DateHelper.ToUniversalTimeStamp(newStartDate);

                            var newEndDate = RetrunMaxTime((long)thisTask.project_id, Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_end_time), days);
                            thisTask.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(newEndDate);
                            thisTask.update_user_id = user.id;
                            thisTask.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            OperLogBLL.OperLogUpdate<sdk_task>(thisTask, _dal.FindNoDeleteById(thisTask.id), thisTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                            _dal.Update(thisTask);

                            UpdateParDate(thisTask.parent_id, (long)thisTask.estimated_begin_time, Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_end_time), user_id);
                        }
                    }
                }


                result = true;
            }
            catch (Exception msg)
            {
                result = false;
            }
            return result;
        }
        /// <summary>
        /// 完成task
        /// </summary>
        public bool CompleteTask(long task_id, string reason, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            var vtDal = new v_task_all_dal();
            var thisTask = _dal.FindNoDeleteById(task_id);
            var v_task = vtDal.FindById(task_id);
            if (user != null && thisTask != null && thisTask.type_id != (int)TASK_TYPE.PROJECT_PHASE && v_task != null)
            {
                thisTask.status_id = (int)TICKET_STATUS.DONE;
                thisTask.reason = reason;
                thisTask.date_completed = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisTask.projected_variance -= (thisTask.estimated_hours - (v_task.worked_hours != null ? (decimal)v_task.worked_hours : 0));
                thisTask.update_user_id = user.id;
                thisTask.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                OperLogBLL.OperLogUpdate<sdk_task>(thisTask, _dal.FindNoDeleteById(thisTask.id), thisTask.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "完成任务");
                _dal.Update(thisTask);
                #region 更新客户最后活动时间
                crm_account thisAccount = new CompanyBLL().GetCompany(thisTask.account_id);
                if (thisAccount != null) { thisAccount.last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now); new CompanyBLL().EditAccount(thisAccount, user_id); }
                #endregion
                return true;
            }
            return false;
        }
        /// <summary>
        /// 获取到节点的上一兄弟节点
        /// </summary>
        public sdk_task GetLastBroTask(long task_id)
        {
            var thisTask = _dal.FindNoDeleteById(task_id);
            if (thisTask != null)
            {
                var thisSortNoArr = thisTask.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                var lastNo = (int.Parse(thisSortNoArr[thisSortNoArr.Count() - 1]) - 1).ToString("#00");
                var nextNo = thisTask.sort_order.Substring(0, thisTask.sort_order.Length - 2) + lastNo;
                var nextTask = _dal.GetSinTaskBySortNo((long)thisTask.project_id, nextNo);
                return nextTask;

            }
            return null;
        }
        /// <summary>
        /// 删除任务
        /// </summary>
        public bool DeleteTasks(long task_id, bool isDelSub, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            var thisTask = _dal.FindNoDeleteById(task_id);
            if (thisTask != null)
            {
                DeleteProTask(thisTask.id, user_id);
                DeleteTaskRes(thisTask.id, user_id);
                var thisSubList = _dal.GetTaskByParentId(thisTask.id);  // 获取到这个任务的所有子节点
                // var nextTask = GetNextBroTask(thisTask.id);             // 获取到这个节点的下一兄弟节点
                _dal.SoftDelete(thisTask, user_id);
                OperLogBLL.OperLogDelete<sdk_task>(thisTask, thisTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "删除任务");
                ChangBroTaskSortNoReduce((long)thisTask.project_id, thisTask.parent_id, user_id);

                if (thisSubList != null && thisSubList.Count > 0)
                {
                    if (isDelSub)  // 删除子节点，递归删除所有节点
                    {
                        foreach (var thisSubTask in thisSubList)
                        {
                            DeleteTasks(thisSubTask.id, isDelSub, user_id);
                        }
                    }
                    else
                    {
                        var nextTask = _dal.GetSinTaskBySortNo((long)thisTask.project_id, thisTask.sort_order);
                        if (nextTask != null)  // 代表后面有兄弟节点
                        {
                            ChangeBroTaskSortNoAdd(nextTask.id, thisSubList.Count, user_id);
                        }
                        else                    // 代表后面没有兄弟节点
                        {

                        }
                        foreach (var thisSubTask in thisSubList)
                        {
                            string newSortNo = "";
                            if (thisTask.parent_id == null)
                            {
                                newSortNo = GetMinUserNoParSortNo((long)thisTask.project_id);
                            }
                            else
                            {
                                newSortNo = GetMinUserSortNo((long)thisTask.parent_id);
                            }
                            thisSubTask.parent_id = thisTask.parent_id;
                            OperLogBLL.OperLogUpdate<sdk_task>(thisSubTask, _dal.FindNoDeleteById(thisSubTask.id), thisSubTask.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                            _dal.Update(thisSubTask);
                            ChangeTaskSortNo(newSortNo, thisSubTask.id, user_id);
                        }
                    }
                }

            }


            return true;
        }
        /// <summary>
        ///  删除这个任务的所有前驱任务
        /// </summary>
        public bool DeleteProTask(long task_id, long user_id)
        {
            var sdpDal = new sdk_task_predecessor_dal();
            var thiPreList = sdpDal.GetRelList(task_id);
            if (thiPreList != null && thiPreList.Count > 0)
            {
                foreach (var thisPre in thiPreList)
                {
                    sdpDal.SoftDelete(thisPre, user_id);
                    OperLogBLL.OperLogDelete<sdk_task_predecessor>(thisPre, thisPre.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK_PREDECESSOR, "删除前驱任务");
                }
                return true;
            }
            return false;
        }
        /// <summary>
        /// 删除任务的团队成员
        /// </summary>
        public bool DeleteTaskRes(long task_id, long user_id)
        {
            var strDal = new sdk_task_resource_dal();
            var strList = strDal.GetTaskResByTaskId(task_id);
            if (strList != null && strList.Count > 0)
            {
                foreach (var str in strList)
                {
                    strDal.SoftDelete(str, user_id);
                    OperLogBLL.OperLogDelete<sdk_task_resource>(str, str.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "删除任务团队成员");
                }

                return true;
            }
            return false;
        }
        /// <summary>
        /// 调整任务的开始结束时间（根据子节点的开始结束时间进行调整）
        /// </summary>
        public void AdjustmentDate(long task_id, long user_id)
        {
            var thisTask = _dal.FindNoDeleteById(task_id);
            var thisSubTask = _dal.GetTaskByParentId(task_id);
            if (thisTask != null && thisSubTask != null && thisSubTask.Count > 0)
            {
                var minStartDate = thisSubTask.Min(_ => (long)_.estimated_begin_time);
                var maxEndDate = thisSubTask.Max(_ => (long)_.estimated_end_time);

                if (((long)thisTask.estimated_begin_time > minStartDate) || ((long)thisTask.estimated_end_time < maxEndDate))
                {
                    if ((long)thisTask.estimated_begin_time > minStartDate)
                    {
                        thisTask.estimated_begin_time = minStartDate;
                    }
                    if ((long)thisTask.estimated_end_time < maxEndDate)
                    {
                        thisTask.estimated_end_time = maxEndDate;
                    }
                    thisTask.estimated_duration = GetDayByTime((long)thisTask.estimated_begin_time, (long)thisTask.estimated_end_time, (long)thisTask.project_id);
                    thisTask.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisTask.update_user_id = user_id;
                    OperLogBLL.OperLogUpdate<sdk_task>(thisTask, _dal.FindNoDeleteById(thisTask.id), thisTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "更改task时间");
                    _dal.Update(thisTask);
                    if (thisTask.parent_id != null)
                    {
                        AdjustmentDate((long)thisTask.parent_id, user_id);
                    }
                }
            }
        }
        /// <summary>
        /// 调整项目的开始结束时间
        /// </summary>
        public void AdjustProDate(long project_id, long user_id)
        {
            var ppDal = new pro_project_dal();
            var stDal = new sdk_task_dal();
            var thisPro = ppDal.FindNoDeleteById(project_id);
            if (thisPro != null)
            {
                var taskList = stDal.GetAllProTask(project_id);
                if (taskList != null && taskList.Count > 0)
                {
                    var minStartDate = taskList.Min(_ => (long)_.estimated_begin_time);
                    var maxEndDate = Tools.Date.DateHelper.ConvertStringToDateTime(taskList.Max(_ => (long)_.estimated_end_time));

                    if (thisPro.start_date != null && thisPro.end_date != null)
                    {
                        var proStartDate = Tools.Date.DateHelper.ToUniversalTimeStamp((DateTime)thisPro.start_date);
                        var proEndDate = (DateTime)thisPro.end_date;
                        if (((DateTime)thisPro.start_date > Tools.Date.DateHelper.ConvertStringToDateTime(minStartDate)) || ((DateTime)thisPro.end_date < maxEndDate))
                        {
                            if (((DateTime)thisPro.start_date > Tools.Date.DateHelper.ConvertStringToDateTime(minStartDate)))
                            {
                                thisPro.start_date = Tools.Date.DateHelper.ConvertStringToDateTime(minStartDate);
                            }
                            if ((DateTime)thisPro.end_date < maxEndDate)
                            {
                                thisPro.end_date = maxEndDate;
                            }
                            TimeSpan ts1 = new TimeSpan(((DateTime)thisPro.start_date).Ticks);
                            TimeSpan ts2 = new TimeSpan(((DateTime)thisPro.end_date).Ticks);
                            TimeSpan ts = ts1.Subtract(ts2).Duration();
                            thisPro.duration = ts.Days + 1;
                            var oldPro = ppDal.FindNoDeleteById(project_id);
                            ppDal.Update(thisPro);
                            OperLogBLL.OperLogUpdate<pro_project>(thisPro, oldPro, thisPro.id, user_id, OPER_LOG_OBJ_CATE.PROJECT, "修改项目");
                        }


                    }
                    else
                    {
                        var oldPro = ppDal.FindNoDeleteById(project_id);
                        thisPro.start_date = Tools.Date.DateHelper.ConvertStringToDateTime(minStartDate);
                        thisPro.end_date = maxEndDate;
                        //thisPro.duration = GetDayByTime(minStartDate, Tools.Date.DateHelper.ToUniversalTimeStamp(maxEndDate),project_id);TimeSpan ts1 = new TimeSpan(((DateTime)param.project.start_date).Ticks);
                        TimeSpan ts1 = new TimeSpan(((DateTime)thisPro.start_date).Ticks);
                        TimeSpan ts2 = new TimeSpan(((DateTime)thisPro.end_date).Ticks);
                        TimeSpan ts = ts1.Subtract(ts2).Duration();
                        thisPro.duration = ts.Days + 1;
                        ppDal.Update(thisPro);
                        OperLogBLL.OperLogUpdate<pro_project>(thisPro, oldPro, thisPro.id, user_id, OPER_LOG_OBJ_CATE.PROJECT, "修改项目");
                    }

                }
            }
        }

        /// <summary>
        /// 新增工时
        /// </summary>
        public bool AddWorkEntry(SdkWorkEntryDto para, long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                //var newRecord = para.wordRecord;
                //newRecord.id = _dal.GetNextIdCom();
                //newRecord.create_user_id = user_id;
                //newRecord.update_user_id = user_id;
                //newRecord.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                //newRecord.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                //new sdk_work_record_dal().Insert(newRecord);
                //OperLogBLL.OperLogAdd<sdk_work_record>(newRecord, newRecord.id, user_id, OPER_LOG_OBJ_CATE.SDK_WORK_RECORD, "新增工作报表");
                // 根据合同的 bill_post_type_id 判断是否立刻审批提交  PostWorkEntry
                ctt_contract thisContract = null;
                if (para.workEntry.contract_id != null)
                {
                    thisContract = new ctt_contract_dal().FindNoDeleteById((long)para.workEntry.contract_id);
                }
                var thisBatchId = _dal.GetNextId("seq_entry_batch");
                var newEntry = para.workEntry;
                newEntry.id = _dal.GetNextIdCom();
                newEntry.batch_id = thisBatchId;
                //newEntry.work_record_id = newRecord.id;
                newEntry.create_user_id = user_id;
                newEntry.update_user_id = user_id;
                newEntry.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                newEntry.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

                // newEntry.is_billable = 
                //if (newEntry.hours_worked != null)
                //{
                //    new sdk_work_entry_dal().Insert(newEntry);
                //    OperLogBLL.OperLogAdd<sdk_work_entry>(newEntry, newEntry.id, user_id, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "新增工时");
                //    if (thisContract != null && thisContract.bill_post_type_id != null)
                //    {
                //        new ApproveAndPostBLL().PostWorkEntry(newEntry.id, Convert.ToInt32(DateTime.Now.ToString("yyyyMMdd")), user_id, "A");
                //    }
                //}


                #region 页面批量新增操作

                if (para.pagEntDtoList != null && para.pagEntDtoList.Count > 0)
                {
                    foreach (var thisEnt in para.pagEntDtoList)
                    {
                        newEntry.id = _dal.GetNextIdCom();
                        newEntry.oid = 0;
                        newEntry.hours_worked = thisEnt.workHours;
                        newEntry.summary_notes = thisEnt.sumNote;
                        newEntry.internal_notes = thisEnt.ineNote;
                        newEntry.batch_id = thisBatchId;
                        newEntry.start_time = thisEnt.startDate ?? Tools.Date.DateHelper.ToUniversalTimeStamp(thisEnt.time);
                        newEntry.offset_hours = thisEnt.offset;
                        newEntry.end_time = thisEnt.endDate;
                        newEntry.hours_billed = thisEnt.billHours ?? (thisEnt.workHours + thisEnt.offset);
                        new sdk_work_entry_dal().Insert(newEntry);
                        OperLogBLL.OperLogAdd<sdk_work_entry>(newEntry, newEntry.id, user_id, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "新增工时");
                        if (thisContract != null && thisContract.bill_post_type_id == (int)DicEnum.BILL_POST_TYPE.BILL_NOW)
                        {
                            new ApproveAndPostBLL().PostWorkEntry(newEntry.id, Convert.ToInt32(DateTime.Now.ToString("yyyyMMdd")), user_id, "A");
                        }
                    }
                }
                #endregion


                var choTask = _dal.FindNoDeleteById(newEntry.task_id);
                if (choTask != null)
                {
                    var v_task = new v_task_all_dal().FindById(choTask.id);
                    if (v_task != null)
                    {
                        // 预估时间+变更单小时+预估差异 - 实际时间
                        var isEdit = para.remain_hours != (v_task.estimated_hours ?? 0) + (v_task.change_Order_Hours ?? 0) + (v_task.projected_variance ?? 0) - (v_task.worked_hours ?? 0);
                        if (isEdit || choTask.status_id != para.status_id)
                        {
                            choTask.status_id = para.status_id;
                            choTask.projected_variance += para.remain_hours - (v_task.remain_hours == null ? 0 : (decimal)v_task.remain_hours);
                            if (para.status_id == (int)DicEnum.TICKET_STATUS.DONE)
                            {
                                choTask.date_completed = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                choTask.projected_variance -= (choTask.estimated_hours - (v_task.worked_hours != null ? (decimal)v_task.worked_hours : 0));
                            }
                           
                            
                            OperLogBLL.OperLogUpdate<sdk_task>(choTask, _dal.FindNoDeleteById(choTask.id), choTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "更改task");
                            _dal.Update(choTask);
                           

                        }
                    }
                }


                #region 通知
                if (para.notify_id != 0)
                {
                    var temp = new sys_notify_tmpl_dal().FindNoDeleteById((long)para.notify_id);
                    if (temp != null)
                    {
                        var srDal = new sys_resource_dal();
                        var temp_email_List = new sys_notify_tmpl_email_dal().GetEmailByTempId(temp.id);
                        if (temp_email_List != null && temp_email_List.Count > 0)
                        {
                            string toEmialString = "";
                            string ccEmialString = "";
                            if (choTask != null)
                            {
                                #region 接受邮件人列表
                                var taskResList = new sdk_task_resource_dal().GetSysResByTaskId(choTask.id);
                                if (taskResList != null && taskResList.Count > 0)
                                {
                                    taskResList.ForEach(_ => { toEmialString += _.email + ";"; });
                                }
                                var project = new pro_project_dal().FindNoDeleteById((long)choTask.project_id);
                                if (project != null && project.owner_resource_id != null)
                                {
                                    var proLead = srDal.FindNoDeleteById((long)project.owner_resource_id);
                                    if (proLead != null)
                                    {
                                        toEmialString += proLead.email + ";";
                                    }
                                }
                                if (choTask.owner_resource_id != null)
                                {
                                    var taskLead = srDal.FindNoDeleteById((long)choTask.owner_resource_id);
                                    if (taskLead != null)
                                    {
                                        toEmialString += taskLead.email + ";";
                                    }
                                }
                                if (!string.IsNullOrEmpty(para.contact_ids))
                                {
                                    var conList = new crm_contact_dal().GetContactByIds(para.contact_ids);
                                    if (conList != null && conList.Count > 0)
                                    {
                                        conList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { toEmialString += _.email + ";"; } });
                                    }
                                }

                                List<sys_resource> toResList = new List<sys_resource>();
                                if (!string.IsNullOrEmpty(para.resIds))
                                {
                                    var resList = new sys_resource_dal().GetListByIds(para.resIds);
                                    if (resList != null && resList.Count > 0)
                                    {
                                        toResList.AddRange(resList);
                                    }
                                }
                                if (!string.IsNullOrEmpty(para.workGropIds))
                                {
                                    var workresList = new sys_workgroup_dal().GetResouListByWorkIds(para.workGropIds);
                                    if (workresList != null && workresList.Count > 0)
                                    {
                                        toResList.AddRange(workresList);
                                    }
                                }
                                if (toResList.Count > 0)
                                {
                                    toResList = toResList.Distinct().ToList();
                                    toResList.ForEach(_ => { toEmialString += _.email + ";"; });
                                }
                                if (!string.IsNullOrEmpty(para.otherEmail))
                                {
                                    toEmialString += para.otherEmail + ";";
                                }

                                #endregion

                                #region 抄送邮件人列表
                                if (para.CCMe)
                                {
                                    ccEmialString += user.email;
                                }

                                #endregion


                            }

                            var notify = new com_notify_email()
                            {
                                id = _dal.GetNextIdCom(),
                                cate_id = (int)NOTIFY_CATE.PROJECT,
                                event_id = (int)DicEnum.NOTIFY_EVENT.TICKET_TIME_ENTRY_CREATED_EDITED,
                                to_email = toEmialString,
                                cc_email = ccEmialString,
                                notify_tmpl_id = para.notify_id,
                                from_email = user.email,
                                from_email_name = user.name,
                                subject = para.subjects,
                                body_text = temp_email_List[0].body_text + para.otherEmail,
                                // is_success = (sbyte)(isSuccess ? 1 : 0),
                                is_html_format = 0,
                                create_user_id = user_id,
                                update_user_id = user_id,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            };
                            new com_notify_email_dal().Insert(notify);
                            OperLogBLL.OperLogAdd<com_notify_email>(notify, notify.id, user.id, OPER_LOG_OBJ_CATE.NOTIFY, "新增工时-添加通知");
                        }
                    }
                }
                #endregion
                #region 更新客户最后活动时间
                var thisTask = _dal.FindNoDeleteById(newEntry.task_id);
                if (thisTask != null)
                {
                    crm_account thisAccount = new CompanyBLL().GetCompany(thisTask.account_id);
                    if (thisAccount != null) { thisAccount.last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now); new CompanyBLL().EditAccount(thisAccount, user_id); }
                }
                #endregion
            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// 修改工时
        /// </summary>
        public bool EditWorkEntry(SdkWorkEntryDto para, long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                //var swrDal = new sdk_work_record_dal();
                var sweDal = new sdk_work_entry_dal();
                //var oldRecord = swrDal.FindNoDeleteById(para.wordRecord.id);
                //var oldEmtry = sweDal.FindNoDeleteById(para.workEntry.id);
                //if (oldEmtry != null ) // && oldRecord != null
                //{
                //para.wordRecord.update_user_id = user_id;
                //para.wordRecord.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                //OperLogBLL.OperLogUpdate<sdk_work_record>(para.wordRecord, oldRecord, oldRecord.id, user_id, OPER_LOG_OBJ_CATE.SDK_WORK_RECORD, "工时报表修改");
                //swrDal.Update(para.wordRecord);

                //para.workEntry.update_user_id = user_id;
                //para.workEntry.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                //OperLogBLL.OperLogUpdate<sdk_work_entry>(para.workEntry, oldEmtry, oldEmtry.id, user_id, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "工时修改");
                //swrDal.Update(para.wordRecord);
                // sweDal.Update(para.workEntry);

                ctt_contract thisContract = null;
                if (para.workEntry.contract_id != null)
                {
                    thisContract = new ctt_contract_dal().FindNoDeleteById((long)para.workEntry.contract_id);
                }

                var newEntry = para.workEntry;
                var thisBatchId = para.workEntry.batch_id;
                var oldBatchList = sweDal.GetBatchList(thisBatchId);
                var pageStartTime = newEntry.start_time;
                if (oldBatchList != null && oldBatchList.Count > 0)
                {
                    if (para.pagEntDtoList != null && para.pagEntDtoList.Count > 0)
                    {
                        var editList = para.pagEntDtoList.Where(_ => _.id > 0).ToList();
                        var addList = para.pagEntDtoList.Where(_ => _.id < 0).ToList();
                        if (editList != null && editList.Count > 0)
                        {
                            foreach (var thisEnt in editList)
                            {
                                var thisEntry = oldBatchList.FirstOrDefault(_ => _.id == thisEnt.id);
                                if (thisEntry != null)
                                {
                                    oldBatchList.Remove(thisEntry);
                                    newEntry.id = thisEntry.id;
                                    newEntry.oid = thisEntry.oid;
                                    newEntry.create_time = thisEntry.create_time;
                                    newEntry.create_user_id = thisEntry.create_user_id;
                                    newEntry.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                    newEntry.update_user_id = user_id;
                                    newEntry.summary_notes = thisEnt.sumNote;
                                    newEntry.internal_notes = thisEnt.ineNote;
                                    newEntry.hours_worked = thisEnt.workHours;
                                    //newEntry.hours_billed = thisEntry.hours_worked;
                                    newEntry.start_time = thisEnt.startDate ?? Tools.Date.DateHelper.ToUniversalTimeStamp(thisEnt.time);
                                    newEntry.offset_hours = thisEnt.offset;
                                    newEntry.end_time = thisEnt.endDate;
                                    newEntry.hours_billed = thisEnt.billHours ?? (thisEnt.workHours + thisEnt.offset);
                                    if (pageStartTime == null)
                                    {
                                        newEntry.start_time = Tools.Date.DateHelper.ToUniversalTimeStamp(thisEnt.time);
                                    }
                                    sweDal.Update(newEntry);
                                    OperLogBLL.OperLogUpdate<sdk_work_entry>(newEntry, thisEntry, thisEntry.id, user_id, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "工时修改");

                                    if (thisContract != null && thisContract.bill_post_type_id == (int)DicEnum.BILL_POST_TYPE.BILL_NOW && newEntry.approve_and_post_date == null && newEntry.approve_and_post_user_id == null)
                                    {
                                        new ApproveAndPostBLL().PostWorkEntry(newEntry.id, Convert.ToInt32(DateTime.Now.ToString("yyyyMMdd")), user_id, "A");
                                    }
                                }
                            }
                        }



                        if (addList != null && addList.Count > 0)
                        {
                            foreach (var thisEnt in addList)
                            {
                                newEntry.id = _dal.GetNextIdCom();
                                newEntry.oid = 0;
                                newEntry.hours_worked = thisEnt.workHours;
                                newEntry.summary_notes = thisEnt.sumNote;
                                newEntry.internal_notes = thisEnt.ineNote;
                                newEntry.batch_id = thisBatchId;
                                newEntry.start_time = Tools.Date.DateHelper.ToUniversalTimeStamp(thisEnt.time);
                                newEntry.offset_hours = 0;
                                newEntry.hours_billed = thisEnt.workHours;
                                new sdk_work_entry_dal().Insert(newEntry);
                                OperLogBLL.OperLogAdd<sdk_work_entry>(newEntry, newEntry.id, user_id, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "新增工时");
                                if (thisContract != null && thisContract.bill_post_type_id != null)
                                {
                                    new ApproveAndPostBLL().PostWorkEntry(newEntry.id, Convert.ToInt32(DateTime.Now.ToString("yyyyMMdd")), user_id, "A");
                                }
                            }
                        }
                    }
                    if (oldBatchList.Count > 0)
                    {
                        foreach (var thisOldBatch in oldBatchList)
                        {
                            sweDal.SoftDelete(thisOldBatch, user_id);
                            OperLogBLL.OperLogDelete<sdk_work_entry>(thisOldBatch, thisOldBatch.id, user_id, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "删除工时");

                        }
                    }

                }
                var choTask = _dal.FindNoDeleteById(para.workEntry.task_id);
                if (choTask != null)
                {
                    var v_task = new v_task_all_dal().FindById(choTask.id);
                    if (v_task != null)
                    {
                        var isEdit = para.remain_hours != (v_task.estimated_hours ?? 0) + (v_task.change_Order_Hours ?? 0) + (v_task.projected_variance ?? 0) - (v_task.worked_hours ?? 0);
                        if (isEdit || choTask.status_id != para.status_id)
                        {
                            choTask.status_id = para.status_id;
                            if(choTask.status_id != para.status_id && para.status_id == (int)DicEnum.TICKET_STATUS.DONE)
                            {
                                choTask.date_completed = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            }
                            choTask.projected_variance += para.remain_hours - (v_task.remain_hours == null ? 0 : (decimal)v_task.remain_hours);
                            OperLogBLL.OperLogUpdate<sdk_task>(choTask, _dal.FindNoDeleteById(choTask.id), choTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "更改task");
                            _dal.Update(choTask);
                        }
                    }
                }

                #region 通知
                if (para.notify_id != 0)
                {
                    var temp = new sys_notify_tmpl_dal().FindNoDeleteById((long)para.notify_id);
                    if (temp != null)
                    {
                        var srDal = new sys_resource_dal();
                        var temp_email_List = new sys_notify_tmpl_email_dal().GetEmailByTempId(temp.id);
                        if (temp_email_List != null && temp_email_List.Count > 0)
                        {
                            string toEmialString = "";
                            string ccEmialString = "";
                            if (choTask != null)
                            {
                                #region 接受邮件人列表
                                var taskResList = new sdk_task_resource_dal().GetSysResByTaskId(choTask.id);
                                if (taskResList != null && taskResList.Count > 0)
                                {
                                    taskResList.ForEach(_ => { toEmialString += _.email + ";"; });
                                }
                                var project = new pro_project_dal().FindNoDeleteById((long)choTask.project_id);
                                if (project != null && project.owner_resource_id != null)
                                {
                                    var proLead = srDal.FindNoDeleteById((long)project.owner_resource_id);
                                    if (proLead != null)
                                    {
                                        toEmialString += proLead.email + ";";
                                    }
                                }
                                if (choTask.owner_resource_id != null)
                                {
                                    var taskLead = srDal.FindNoDeleteById((long)choTask.owner_resource_id);
                                    if (taskLead != null)
                                    {
                                        toEmialString += taskLead.email + ";";
                                    }
                                }
                                if (!string.IsNullOrEmpty(para.contact_ids))
                                {
                                    var conList = new crm_contact_dal().GetContactByIds(para.contact_ids);
                                    if (conList != null && conList.Count > 0)
                                    {
                                        conList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { toEmialString += _.email + ";"; } });
                                    }
                                }

                                List<sys_resource> toResList = new List<sys_resource>();
                                if (!string.IsNullOrEmpty(para.resIds))
                                {
                                    var resList = new sys_resource_dal().GetListByIds(para.resIds);
                                    if (resList != null && resList.Count > 0)
                                    {
                                        toResList.AddRange(resList);
                                    }
                                }
                                if (!string.IsNullOrEmpty(para.workGropIds))
                                {
                                    var workresList = new sys_workgroup_dal().GetResouListByWorkIds(para.workGropIds);
                                    if (workresList != null && workresList.Count > 0)
                                    {
                                        toResList.AddRange(workresList);
                                    }
                                }
                                if (toResList.Count > 0)
                                {
                                    toResList = toResList.Distinct().ToList();
                                    toResList.ForEach(_ => { toEmialString += _.email + ";"; });
                                }

                                #endregion

                                #region 抄送邮件人列表
                                if (para.CCMe)
                                {
                                    ccEmialString += user.email;
                                }

                                #endregion


                            }

                            var notify = new com_notify_email()
                            {
                                id = _dal.GetNextIdCom(),
                                cate_id = (int)NOTIFY_CATE.PROJECT,
                                event_id = (int)DicEnum.NOTIFY_EVENT.TICKET_TIME_ENTRY_CREATED_EDITED,
                                to_email = toEmialString,
                                cc_email = ccEmialString,
                                notify_tmpl_id = para.notify_id,
                                from_email = user.email,
                                from_email_name = user.name,
                                subject = para.subjects,
                                body_text = temp_email_List[0].body_text + para.otherEmail,
                                // is_success = (sbyte)(isSuccess ? 1 : 0),
                                is_html_format = 0,
                                create_user_id = user_id,
                                update_user_id = user_id,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            };
                            new com_notify_email_dal().Insert(notify);
                            OperLogBLL.OperLogAdd<com_notify_email>(notify, notify.id, user.id, OPER_LOG_OBJ_CATE.NOTIFY, "修改工时-添加通知");
                        }
                    }
                }
                #endregion
                //}
            }
            catch (Exception)
            {

                return false;
            }
            return true;
        }
        /// <summary>
        /// 删除工时
        /// </summary>
        public bool DeleteEntry(long ent_id, long user_id, out string reason)
        {
            try
            {
                reason = "";
                var sweDal = new sdk_work_entry_dal();
                var swrDal = new sdk_work_record_dal();
                var thisEntry = sweDal.FindNoDeleteById(ent_id);
                if (thisEntry != null)
                {
                    if (thisEntry.approve_and_post_user_id == null && thisEntry.approve_and_post_date == null)
                    {
                        //if (thisEntry.work_record_id != null)
                        //{
                        //    var thisRecord = swrDal.FindNoDeleteById((long)thisEntry.work_record_id);
                        //    swrDal.SoftDelete(thisRecord, user_id);
                        //    OperLogBLL.OperLogDelete<sdk_work_record>(thisRecord, thisRecord.id, user_id, OPER_LOG_OBJ_CATE.SDK_WORK_RECORD, "删除工时报表");
                        //}
                        sweDal.SoftDelete(thisEntry, user_id);
                        OperLogBLL.OperLogDelete<sdk_work_entry>(thisEntry, thisEntry.id, user_id, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "删除工时");
                    }
                    else
                    {
                        reason = "已录入工时，不可删除";
                        return false;
                    }
                }
            }
            catch (Exception msg)
            {
                reason = msg.Message;
                return false;
            }
            return true;
        }

        /// <summary>
        /// 新增任务备注
        /// </summary>
        public bool AddTaskNote(TaskNoteDto param, long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);

                #region 任务备注相关
                var thisAddNote = param.taskNote;
                if (thisAddNote.id == 0)
                {
                    thisAddNote.id = _dal.GetNextIdCom();
                }
                var project = param.thisProjetc;
                var account = new crm_account_dal().FindNoDeleteById(param.account_id);
                var contact = new ContactBLL().GetDefaultByAccountId(account.id);
                // thisAddNote.cate_id = (int)DicEnum.ACTIVITY_CATE.TASK_NOTE;
                thisAddNote.object_id = param.object_id;
                // thisAddNote.object_type_id = (int)OBJECT_TYPE.TASK;
                thisAddNote.account_id = account.id;
                if (param.thisTask != null)
                {
                    thisAddNote.task_id = param.thisTask.id;
                    thisAddNote.resource_id = param.thisTask.owner_resource_id;
                }

                if (contact != null)
                {
                    thisAddNote.contact_id = contact.id;
                }
                if (param.thisTicket != null)
                {
                    thisAddNote.ticket_id = param.thisTicket.id;
                    thisAddNote.resource_id = param.thisTicket.owner_resource_id;
                }
                //thisAddNote.resource_id = project.owner_resource_id;
                //thisAddNote.contract_id = project.contract_id;
                thisAddNote.create_user_id = user_id;
                thisAddNote.update_user_id = user_id;
                thisAddNote.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisAddNote.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

                new com_activity_dal().Insert(thisAddNote);
                OperLogBLL.OperLogAdd<com_activity>(thisAddNote, thisAddNote.id, user_id, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");
                #endregion

                #region 修改任务状态
                if (param.thisTask != null)
                {
                    if (param.status_id != 0 && param.thisTask.status_id != param.status_id)
                    {
                        param.thisTask.status_id = param.status_id;
                        OperLogBLL.OperLogUpdate<sdk_task>(param.thisTask, _dal.FindNoDeleteById(param.thisTask.id), param.thisTask.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                        _dal.Update(param.thisTask);
                        #region 更新客户最后活动时间
                        crm_account thisAccount = new CompanyBLL().GetCompany(param.thisTask.account_id);
                        if (thisAccount != null) { thisAccount.last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now); new CompanyBLL().EditAccount(thisAccount, user_id); }
                        #endregion
                        if (param.status_id == (int)DicEnum.TICKET_STATUS.DONE)
                        {
                            InsActTaskDone(param.thisTask.id, user_id);
                        }
                    }
                }
                #endregion

             

                #region 修改工单相关信息
                if (param.thisTicket != null)
                {
                    var ticBll = new TicketBLL();
                    if (param.isAddSol && param.thisTicket != null)
                    {
                        param.thisTicket.resolution += $"\r\n{thisAddNote.name}\r\n{thisAddNote.description}";
                    }
                    if (param.status_id != 0 && param.thisTicket.status_id != param.status_id)
                    {
                        param.thisTicket.status_id = param.status_id;
                        //   修改工单状态为完成时，暂不处理
                        if (param.status_id == (int)DicEnum.TICKET_STATUS.DONE)
                        {
                            param.thisTicket.date_completed = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        }
                    }
                    ticBll.EditTicket(param.thisTicket, user_id);

                    var solList = _dal.GetSubTaskByType(param.thisTicket.id, TICKET_TYPE.INCIDENT);
                    if (param.isAddAllSol)
                    {
                        // 获取到相关 事故，追加到解决方案
                        if(solList!=null&& solList.Count > 0)
                        {
                            solList.ForEach(_=>{
                                _.resolution += $"\r\n{thisAddNote.name}\r\n{thisAddNote.description}";
                                ticBll.EditTicket(_, user_id);
                            });
                        }
                    }
                    if (param.isAddAllNote)
                    {
                        if (solList != null && solList.Count > 0)
                        {
                            solList.ForEach(_=> {
                                ticBll.AddTicketNote(param,_.id,user_id);
                            });
                        }
                    }

                }
                #endregion

                #region 备注附件相关
                //var attList = Session
                if (param.filtList != null && param.filtList.Count > 0)
                {
                    var caDal = new com_attachment_dal();
                    var attBll = new AttachmentBLL();
                    foreach (var thisFile in param.filtList)
                    {
                        if (thisFile.type_id == ((int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())
                        {

                            attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.NOTES, thisAddNote.id, (int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT, thisFile.new_filename, "", thisFile.old_filename, thisFile.fileSaveName, thisFile.conType, thisFile.Size, user_id);
                        }
                        else
                        {
                            attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.NOTES, thisAddNote.id, int.Parse(thisFile.type_id), thisFile.new_filename, thisFile.old_filename, null, null, null, 0, user_id);
                        }
                    }
                }
                #endregion

                #region 通知相关
                var notiContract = new ctt_contract_dal().FindNoDeleteById(thisAddNote.object_id);

                var srDal = new sys_resource_dal();
                string htmlBody = "";
                if (param.notify_id != 0)
                {
                    var temp = new sys_notify_tmpl_dal().FindNoDeleteById((long)param.notify_id);
                    if (temp != null)
                    {

                        var temp_email_List = new sys_notify_tmpl_email_dal().GetEmailByTempId(temp.id);
                        if (temp_email_List != null && temp_email_List.Count > 0)
                        {
                            htmlBody = temp_email_List[0].body_text;
                        }
                    }
                }
                if (param.notify_id == 0 && notiContract == null)
                    return true;

                string toEmialString = "";
                string ccEmialString = "";
                var create_id = param.thisProjetc.create_user_id;
                if (param.thisTask != null)
                {
                    create_id = param.thisTask.create_user_id;
                }
                #region 接收邮件人列表

                if (!string.IsNullOrEmpty(param.contact_ids))
                {
                    var conList = new crm_contact_dal().GetContactByIds(param.contact_ids);
                    if (conList != null && conList.Count > 0)
                    {
                        conList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { toEmialString += _.email + ";"; } });
                    }
                }

                List<sys_resource> toResList = new List<sys_resource>();
                if (!string.IsNullOrEmpty(param.resIds))
                {
                    var resList = new sys_resource_dal().GetListByIds(param.resIds);
                    if (resList != null && resList.Count > 0)
                    {
                        toResList.AddRange(resList);
                    }
                }
                if (!string.IsNullOrEmpty(param.workGropIds))
                {
                    var workresList = new sys_workgroup_dal().GetResouListByWorkIds(param.workGropIds);
                    if (workresList != null && workresList.Count > 0)
                    {
                        toResList.AddRange(workresList);
                    }
                }
                if (toResList.Count > 0)
                {
                    toResList = toResList.Distinct().ToList();
                    toResList.ForEach(_ => { toEmialString += _.email + ";"; });
                }
                if (param.toCrea)
                {
                    var creRes = srDal.FindNoDeleteById(create_id);
                    if (creRes != null)
                    {
                        toEmialString += creRes.email + ";";
                    }
                }
                if (param.toAccMan)
                {
                    if (account.resource_id != null)
                    {
                        var accRes = srDal.FindNoDeleteById(create_id);
                        if (accRes != null)
                        {
                            toEmialString += accRes.email + ";";
                        }
                    }
                }


                if (!string.IsNullOrEmpty(param.otherEmail))
                {
                    toEmialString += param.otherEmail + ";";
                }
                if (param.toPriRes && param.thisTicket != null&&param.thisTicket.owner_resource_id!=null)
                {
                    var priRes = srDal.FindNoDeleteById((long)param.thisTicket.owner_resource_id);
                    if (priRes != null&&!string.IsNullOrEmpty(priRes.email))
                    {
                        toEmialString += priRes.email+";";
                    }
                }

                if (param.toOtherRes && param.thisTicket != null)
                {
                    var otherResList = srDal.GetTaskRes(param.thisTicket.id);
                    if(otherResList!=null&& otherResList.Count > 0)
                    {
                        otherResList.ForEach(_=> {
                            if (!string.IsNullOrEmpty(_.email))
                            {
                                toEmialString += _.email+";";
                            }
                        });
                    }
                }
                #endregion

                #region 抄送邮件人列表
                if (param.ccMe)
                {
                    ccEmialString += user.email;
                }

                #endregion

                var sysEmail = new d_general_dal().FindNoDeleteById((int)DicEnum.SUPPORT_EMAIL.SYS_EMAIL);
                var fromEmail = user.email;
                var from_email_name = user.name;
                if (param.fromSys)
                {
                    if (sysEmail != null && !string.IsNullOrEmpty(sysEmail.name))
                    {
                        fromEmail = sysEmail.name;
                        from_email_name = sysEmail.remark;
                    }
                }
                var cate_id = (int)NOTIFY_CATE.PROJECT;
                int? event_id = (int)NOTIFY_EVENT.PROJECT_NOTE_CREATED_OR_EDITED;
                var thisTaks = _dal.FindNoDeleteById(thisAddNote.object_id);
                if (thisTaks != null)
                {
                    event_id = (int)NOTIFY_EVENT.TASK_NOTE_CREATED_EDITED;
                }
                else
                {
                    if (notiContract != null)
                    {
                        cate_id = (int)NOTIFY_CATE.CONTRACT;
                        event_id = null;
                    }
                }
                var notify = new com_notify_email()
                {
                    id = _dal.GetNextIdCom(),
                    cate_id = cate_id,
                    event_id = event_id,
                    to_email = toEmialString,
                    cc_email = ccEmialString,
                    notify_tmpl_id = param.notify_id,
                    from_email = fromEmail,
                    from_email_name = from_email_name,
                    subject = param.subjects,
                    body_text = htmlBody + param.otherEmail + (param.incloNoteAtt ? thisAddNote.description : ""),
                    // is_success = (sbyte)(isSuccess ? 1 : 0),
                    is_html_format = 0,
                    create_user_id = user_id,
                    update_user_id = user_id,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                };
                new com_notify_email_dal().Insert(notify);
                OperLogBLL.OperLogAdd<com_notify_email>(notify, notify.id, user_id, OPER_LOG_OBJ_CATE.NOTIFY, "新增备注-添加通知");

                #endregion

            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 为服务预定下的工单添加相关备注
        /// </summary>
        public bool AddCallTaskNote(TaskNoteDto param, long user_id)
        {
            if (param.thisCall == null)
                return false;
            var sscDal = new sdk_service_call_dal();
            var thisCall = sscDal.FindNoDeleteById(param.thisCall.id);
            if (thisCall == null)
                return false;
            var ticketList = _dal.GetTciketByCall(thisCall.id);
            if (ticketList == null || ticketList.Count <= 0)
                return false;
            var user = UserInfoBLL.GetUserInfo(user_id);
            var caDal = new com_activity_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var attBll = new AttachmentBLL();
            var comBll = new CompanyBLL();
            var srDal = new sys_resource_dal();
            foreach (var thisTicket in ticketList)
            {
                var thisAddNote = new com_activity() {
                    id= caDal.GetNextIdCom(),
                    cate_id = (int)ACTIVITY_CATE.TICKET_NOTE,
                    object_id = thisTicket.id,
                    object_type_id = (int)DicEnum.OBJECT_TYPE.TICKETS,
                    action_type_id = param.taskNote.action_type_id,
                    name = param.taskNote.name,
                    description = param.taskNote.description,
                    account_id = thisTicket.account_id,
                    contact_id = thisTicket.contact_id,
                    publish_type_id = param.taskNote.publish_type_id,
                    create_time = timeNow,
                    update_time = timeNow,
                    create_user_id = user_id,
                    update_user_id  = user_id,
                    resource_id = thisTicket.owner_resource_id,

                };
                caDal.Insert(thisAddNote);
                OperLogBLL.OperLogAdd<com_activity>(thisAddNote, thisAddNote.id, user_id, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");

                if (param.status_id != 0 && thisTicket.status_id != param.status_id)
                {
                    thisTicket.status_id = param.status_id;
                    var oldTicket = _dal.FindNoDeleteById(thisTicket.id);
                    _dal.Update(thisTicket);
                    OperLogBLL.OperLogUpdate<sdk_task>(thisTicket, oldTicket, thisTicket.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改状态");
                }

                #region 备注附件相关
                if (param.filtList != null && param.filtList.Count > 0)
                {
                    
                    foreach (var thisFile in param.filtList)
                    {
                        if (thisFile.type_id == ((int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())
                        {
                            attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.NOTES, thisAddNote.id, (int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT, thisFile.new_filename, "", thisFile.old_filename, thisFile.fileSaveName, thisFile.conType, thisFile.Size, user_id);
                        }
                        else
                        {
                            attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.NOTES, thisAddNote.id, int.Parse(thisFile.type_id), thisFile.new_filename, thisFile.old_filename, null, null, null, 0, user_id);
                        }
                    }
                }
                #endregion

                #region 通知相关
                string htmlBody = "";
                if (param.notify_id != 0)
                {
                    var temp = new sys_notify_tmpl_dal().FindNoDeleteById((long)param.notify_id);
                    if (temp != null)
                    {
                        var temp_email_List = new sys_notify_tmpl_email_dal().GetEmailByTempId(temp.id);
                        if (temp_email_List != null && temp_email_List.Count > 0)
                            htmlBody = temp_email_List[0].body_text;
                    }
                }
                else
                {
                    continue;
                }
                var account = comBll.GetCompany(thisTicket.account_id);

                string toEmialString = "";
                string ccEmialString = "";
                var create_id = param.thisProjetc.create_user_id;
                if (param.thisTask != null)
                    create_id = param.thisTask.create_user_id;
                #region 接收邮件人列表

                if (!string.IsNullOrEmpty(param.contact_ids))
                {
                    var conList = new crm_contact_dal().GetContactByIds(param.contact_ids);
                    if (conList != null && conList.Count > 0)
                        conList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { toEmialString += _.email + ";"; } });
                }

                List<sys_resource> toResList = new List<sys_resource>();
                if (!string.IsNullOrEmpty(param.resIds))
                {
                    var resList = new sys_resource_dal().GetListByIds(param.resIds);
                    if (resList != null && resList.Count > 0)
                        toResList.AddRange(resList);
                }
                if (!string.IsNullOrEmpty(param.workGropIds))
                {
                    var workresList = new sys_workgroup_dal().GetResouListByWorkIds(param.workGropIds);
                    if (workresList != null && workresList.Count > 0)
                        toResList.AddRange(workresList);
                }
                if (toResList.Count > 0)
                {
                    toResList = toResList.Distinct().ToList();
                    toResList.ForEach(_ => { toEmialString += _.email + ";"; });
                }
                if (param.toCrea)
                {
                    var creRes = srDal.FindNoDeleteById(create_id);
                    if (creRes != null)
                        toEmialString += creRes.email + ";";
                }
                if (param.toAccMan)
                {
                    if (account.resource_id != null)
                    {
                        var accRes = srDal.FindNoDeleteById(create_id);
                        if (accRes != null)
                            toEmialString += accRes.email + ";";
                    }
                }


                if (!string.IsNullOrEmpty(param.otherEmail))
                    toEmialString += param.otherEmail + ";";
                if (param.toPriRes && param.thisTicket != null && param.thisTicket.owner_resource_id != null)
                {
                    var priRes = srDal.FindNoDeleteById((long)param.thisTicket.owner_resource_id);
                    if (priRes != null && !string.IsNullOrEmpty(priRes.email))
                        toEmialString += priRes.email + ";";
                }

                if (param.toOtherRes && param.thisTicket != null)
                {
                    var otherResList = srDal.GetTaskRes(param.thisTicket.id);
                    if (otherResList != null && otherResList.Count > 0)
                    {
                        otherResList.ForEach(_ => {
                            if (!string.IsNullOrEmpty(_.email))
                            {
                                toEmialString += _.email + ";";
                            }
                        });
                    }
                }
                #endregion

                #region 抄送邮件人列表
                if (param.ccMe)
                    ccEmialString += user.email;

                #endregion

                var sysEmail = new d_general_dal().FindNoDeleteById((int)DicEnum.SUPPORT_EMAIL.SYS_EMAIL);
                var fromEmail = user.email;
                var from_email_name = user.name;
                if (param.fromSys)
                {
                    if (sysEmail != null && !string.IsNullOrEmpty(sysEmail.name))
                    {
                        fromEmail = sysEmail.name;
                        from_email_name = sysEmail.remark;
                    }
                }
                var cate_id = (int)NOTIFY_CATE.TICKETS;
                int? event_id = (int)NOTIFY_EVENT.TICKET_NOTE_CREATED_EDITED;
                var notify = new com_notify_email()
                {
                    id = _dal.GetNextIdCom(),
                    cate_id = cate_id,
                    event_id = event_id,
                    to_email = toEmialString,
                    cc_email = ccEmialString,
                    notify_tmpl_id = param.notify_id,
                    from_email = fromEmail,
                    from_email_name = from_email_name,
                    subject = param.subjects,
                    body_text = htmlBody + param.otherEmail + (param.incloNoteAtt ? thisAddNote.description : ""),
                    // is_success = (sbyte)(isSuccess ? 1 : 0),
                    is_html_format = 0,
                    create_user_id = user_id,
                    update_user_id = user_id,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                };
                new com_notify_email_dal().Insert(notify);
                OperLogBLL.OperLogAdd<com_notify_email>(notify, notify.id, user_id, OPER_LOG_OBJ_CATE.NOTIFY, "新增备注-添加通知");
                #endregion
            }
            return true;
        }
        /// <summary>
        /// 修改任务备注
        /// </summary>
        public bool EditTaskNote(TaskNoteDto param, long user_id)
        {
            try
            {
                var cacDal = new com_activity_dal();
                var user = UserInfoBLL.GetUserInfo(user_id);
                var account = new crm_account_dal().FindNoDeleteById(param.account_id);
                var thisAddNote = param.taskNote;
                #region 修改备注
                param.taskNote.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                param.taskNote.update_user_id = user_id;
                OperLogBLL.OperLogUpdate<com_activity>(param.taskNote, cacDal.FindNoDeleteById(param.taskNote.id), param.taskNote.id, user_id, OPER_LOG_OBJ_CATE.ACTIVITY, "更改任务备注");
                cacDal.Update(param.taskNote);
                #endregion


                #region 修改工单相关信息
                if (param.thisTicket != null)
                {
                    var ticBll = new TicketBLL();
                    if (param.isAddSol && param.thisTicket != null)
                    {
                        param.thisTicket.resolution += $"\r\n{thisAddNote.name}\r\n{thisAddNote.description}";
                    }
                    if (param.status_id != 0 && param.thisTicket.status_id != param.status_id)
                    {
                        param.thisTicket.status_id = param.status_id;
                        //   修改工单状态为完成时，暂不处理
                        if (param.status_id == (int)DicEnum.TICKET_STATUS.DONE)
                        {
                        }
                    }
                    ticBll.EditTicket(param.thisTicket, user_id);
                }
                if (param.thisTask != null)
                {
                    #region 更新客户最后活动时间
                    crm_account thisAccount = new CompanyBLL().GetCompany(param.thisTask.account_id);
                    if (thisAccount != null) { thisAccount.last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now); new CompanyBLL().EditAccount(thisAccount, user_id); }
                    #endregion
                }
                #endregion

                var caDal = new com_attachment_dal();
                #region 修改原附件
                var oldAttList = new com_attachment_dal().GetAttListByOid(thisAddNote.id);
                if (oldAttList != null && oldAttList.Count > 0)
                {
                    var attIdList = param.attIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var oldAtt in oldAttList)
                    {
                        if (!attIdList.Any(_ => _ == oldAtt.id.ToString()))
                        {
                            caDal.SoftDelete(oldAtt, user_id);
                            OperLogBLL.OperLogDelete<com_attachment>(oldAtt, oldAtt.id, user_id, OPER_LOG_OBJ_CATE.ATTACHMENT, "删除备注附件");
                        }
                    }
                }
                #endregion


                #region 新增附件
                if (param.filtList != null && param.filtList.Count > 0)
                {

                    var attBll = new AttachmentBLL();
                    foreach (var thisFile in param.filtList)
                    {
                        if (thisFile.type_id == ((int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())
                        {

                            attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.NOTES, thisAddNote.id, (int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT, thisFile.new_filename, "", thisFile.old_filename, thisFile.fileSaveName, thisFile.conType, thisFile.Size, user_id);
                        }
                        else
                        {
                            attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.NOTES, thisAddNote.id, int.Parse(thisFile.type_id), thisFile.new_filename, thisFile.old_filename, null, null, null, 0, user_id);
                        }
                    }
                }
                #endregion



                #region 通知相关
                var notiContract = new ctt_contract_dal().FindNoDeleteById(thisAddNote.object_id);

                var srDal = new sys_resource_dal();
                string htmlBody = "";
                if (param.notify_id != 0)
                {
                    var temp = new sys_notify_tmpl_dal().FindNoDeleteById((long)param.notify_id);
                    if (temp != null)
                    {

                        var temp_email_List = new sys_notify_tmpl_email_dal().GetEmailByTempId(temp.id);
                        if (temp_email_List != null && temp_email_List.Count > 0)
                        {
                            htmlBody = temp_email_List[0].body_text;
                        }
                    }
                }
                if (param.notify_id == 0 && notiContract == null)
                    return true;
                string toEmialString = "";
                string ccEmialString = "";
                var create_id = param.thisProjetc.create_user_id;
                if (param.thisTask != null)
                {
                    create_id = param.thisTask.create_user_id;
                }
                #region 接收邮件人列表

                if (!string.IsNullOrEmpty(param.contact_ids))
                {
                    var conList = new crm_contact_dal().GetContactByIds(param.contact_ids);
                    if (conList != null && conList.Count > 0)
                    {
                        conList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { toEmialString += _.email + ";"; } });
                    }
                }

                List<sys_resource> toResList = new List<sys_resource>();
                if (!string.IsNullOrEmpty(param.resIds))
                {
                    var resList = new sys_resource_dal().GetListByIds(param.resIds);
                    if (resList != null && resList.Count > 0)
                    {
                        toResList.AddRange(resList);
                    }
                }
                if (!string.IsNullOrEmpty(param.workGropIds))
                {
                    var workresList = new sys_workgroup_dal().GetResouListByWorkIds(param.workGropIds);
                    if (workresList != null && workresList.Count > 0)
                    {
                        toResList.AddRange(workresList);
                    }
                }
                if (toResList.Count > 0)
                {
                    toResList = toResList.Distinct().ToList();
                    toResList.ForEach(_ => { toEmialString += _.email + ";"; });
                }
                if (param.toCrea)
                {
                    var creRes = srDal.FindNoDeleteById(create_id);
                    if (creRes != null)
                    {
                        toEmialString += creRes.email + ";";
                    }
                }
                if (param.toAccMan)
                {
                    if (account.resource_id != null)
                    {
                        var accRes = srDal.FindNoDeleteById(create_id);
                        if (accRes != null)
                        {
                            toEmialString += accRes.email + ";";
                        }
                    }
                }


                if (!string.IsNullOrEmpty(param.otherEmail))
                {
                    toEmialString += param.otherEmail + ";";
                }

                #endregion

                #region 抄送邮件人列表
                if (param.ccMe)
                {
                    ccEmialString += user.email;
                }

                #endregion



                var sysEmail = new d_general_dal().FindNoDeleteById((int)DicEnum.SUPPORT_EMAIL.SYS_EMAIL);
                var fromEmail = user.email;
                var from_email_name = user.name;
                if (param.fromSys)
                {
                    if (sysEmail != null && !string.IsNullOrEmpty(sysEmail.name))
                    {
                        fromEmail = sysEmail.name;
                        from_email_name = sysEmail.remark;
                    }
                }
                var cate_id = (int)NOTIFY_CATE.PROJECT;
                int? event_id = (int)NOTIFY_EVENT.PROJECT_NOTE_CREATED_OR_EDITED;
                var thisTaks = _dal.FindNoDeleteById(thisAddNote.object_id);
                if (thisTaks != null)
                {
                    event_id = (int)NOTIFY_EVENT.TASK_NOTE_CREATED_EDITED;
                }
                else
                {
                    var thisContract = new ctt_contract_dal().FindNoDeleteById(thisAddNote.object_id);
                    if (thisContract != null)
                    {
                        cate_id = (int)NOTIFY_CATE.CONTRACT;
                        event_id = null;
                    }
                }
                var notify = new com_notify_email()
                {
                    id = _dal.GetNextIdCom(),
                    cate_id = cate_id,
                    event_id = event_id,
                    to_email = toEmialString,
                    cc_email = ccEmialString,
                    notify_tmpl_id = param.notify_id,
                    from_email = fromEmail,
                    from_email_name = from_email_name,
                    subject = param.subjects,
                    body_text = htmlBody + param.otherEmail + (param.incloNoteAtt ? thisAddNote.description : ""),
                    // is_success = (sbyte)(isSuccess ? 1 : 0),
                    is_html_format = 0,
                    create_user_id = user_id,
                    update_user_id = user_id,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                };
                new com_notify_email_dal().Insert(notify);
                OperLogBLL.OperLogAdd<com_notify_email>(notify, notify.id, user_id, OPER_LOG_OBJ_CATE.NOTIFY, "修改备注-添加通知");
                #endregion
            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// 删除备注，以及这个备注相关的附件
        /// </summary>
        public bool DeleteTaskNote(long note_id, long user_id)
        {
            var caDal = new com_activity_dal();
            var thisNote = caDal.FindNoDeleteById(note_id);
            if (thisNote != null)
            {

                var oldAttList = new com_attachment_dal().GetAttListByOid(note_id);
                caDal.SoftDelete(thisNote, user_id);
                OperLogBLL.OperLogDelete<com_activity>(thisNote, thisNote.id, user_id, OPER_LOG_OBJ_CATE.ACTIVITY, "删除备注附件");
                if (oldAttList != null && oldAttList.Count > 0)
                {
                    var attDal = new com_attachment_dal();
                    foreach (var oldAtt in oldAttList)
                    {
                        attDal.SoftDelete(oldAtt, user_id);
                        OperLogBLL.OperLogDelete<com_attachment>(oldAtt, oldAtt.id, user_id, OPER_LOG_OBJ_CATE.ATTACHMENT, "删除备注附件");
                    }
                }


                return true;
            }
            return false;
        }
        /// <summary>
        /// 新增费用，保存费用报表
        /// </summary>
        public bool AddExpense(ExpenseDto param, long user_id)
        {
            try
            {

                var seDal = new sdk_expense_dal();
                var serDal = new sdk_expense_report_dal();
                var thisExp = param.thisExpense;
                var thisExpRep = param.thisExpReport;
                if (thisExpRep.id == 0)
                {
                    thisExpRep.id = serDal.GetNextIdCom();
                    thisExpRep.status_id = (int)EXPENSE_REPORT_STATUS.HAVE_IN_HAND;
                    thisExpRep.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisExpRep.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisExpRep.create_user_id = user_id;
                    thisExpRep.update_user_id = user_id;
                    thisExpRep.submit_time = thisExpRep.create_time;
                    thisExpRep.submit_user_id = user_id;
                    serDal.Insert(thisExpRep);
                    OperLogBLL.OperLogAdd<sdk_expense_report>(thisExpRep, thisExpRep.id, user_id, OPER_LOG_OBJ_CATE.SDK_EXPENSE_REPORT, "新增费用报表");
                }
                thisExp.id = seDal.GetNextIdCom();
                thisExp.expense_report_id = thisExpRep.id;
                thisExp.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisExp.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisExp.create_user_id = user_id;
                thisExp.update_user_id = user_id;
                seDal.Insert(thisExp);
                OperLogBLL.OperLogAdd<sdk_expense>(thisExp, thisExp.id, user_id, OPER_LOG_OBJ_CATE.SDK_EXPENSE, "新增费用");
                #region 更新客户最后活动时间
                if (thisExp.is_billable == 1)
                {
                    crm_account thisAccount = new CompanyBLL().GetCompany(thisExp.account_id);
                    if (thisAccount != null) { thisAccount.last_activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now); new CompanyBLL().EditAccount(thisAccount, user_id); }
                }
                #endregion
                return true;
            }
            catch (Exception msg)
            {
                return false;
            }
        }
        /// <summary>
        /// 修改费用
        /// </summary>
        public bool EditExpense(ExpenseDto param, long user_id)
        {
            try
            {
                var seDal = new sdk_expense_dal();
                var serDal = new sdk_expense_report_dal();
                var thisExp = param.thisExpense;
                var thisExpRep = param.thisExpReport;
                if (thisExpRep.id == 0)
                {
                    thisExpRep.id = serDal.GetNextIdCom();
                    thisExpRep.status_id = (int)EXPENSE_REPORT_STATUS.HAVE_IN_HAND;
                    thisExpRep.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisExpRep.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisExpRep.create_user_id = user_id;
                    thisExpRep.update_user_id = user_id;
                    serDal.Insert(thisExpRep);
                    OperLogBLL.OperLogAdd<sdk_expense_report>(thisExpRep, thisExpRep.id, user_id, OPER_LOG_OBJ_CATE.SDK_EXPENSE_REPORT, "新增费用报表");
                }

                thisExp.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisExp.update_user_id = user_id;
                thisExp.expense_report_id = thisExpRep.id;
                OperLogBLL.OperLogUpdate<sdk_expense>(thisExp, seDal.FindNoDeleteById(thisExp.id), thisExp.id, user_id, OPER_LOG_OBJ_CATE.SDK_EXPENSE, "修改费用");
                seDal.Update(thisExp);

                return true;
            }
            catch (Exception msg)
            {
                return false;
            }
        }
        /// <summary>
        /// 是否可以编辑费用
        /// </summary>
        public bool CanEditExpense(long eid)
        {
            var seDal = new sdk_expense_dal();
            var serDal = new sdk_expense_report_dal();
            var thisExp = seDal.FindNoDeleteById(eid);
            if (thisExp != null)
            {
                if (thisExp.approve_and_post_date == null && thisExp.approve_and_post_user_id == null)
                {
                    var thisReport = serDal.FindNoDeleteById(thisExp.expense_report_id);
                    if (thisReport != null && (thisReport.status_id == (int)DicEnum.EXPENSE_REPORT_STATUS.HAVE_IN_HAND || thisReport.status_id == (int)DicEnum.EXPENSE_REPORT_STATUS.REJECTED))
                    {
                        return true;
                    }
                }
            }
            return false;
        }
        /// <summary>
        /// 删除费用
        /// </summary>
        public bool DeleteExpense(long eId, long user_id, out string failReason)
        {
            failReason = "";
            try
            {
                var seDal = new sdk_expense_dal();
                var thisExp = seDal.FindNoDeleteById(eId);
                if (thisExp != null)
                {
                    if (CanEditExpense(eId))
                    {
                        if (thisExp.approve_and_post_date == null && thisExp.approve_and_post_user_id == null)
                        {
                            seDal.SoftDelete(thisExp, user_id);
                            OperLogBLL.OperLogDelete<sdk_expense>(thisExp, thisExp.id, user_id, OPER_LOG_OBJ_CATE.SDK_EXPENSE, "删除费用");
                            return true;
                        }
                        else
                        {
                            failReason = "不能删除已经审批提交的费用";
                            return false;
                        }
                    }
                    else
                    {
                        failReason = "费用已经审批或者相关报表状态不可以删除";
                        return false;
                    }

                }
                else
                {
                    failReason = "未找到该费用";
                    return false;
                }

            }
            catch (Exception msg)
            {
                failReason = msg.Message;
                return false;
            }
        }
        /// <summary>
        /// 关联多个里程碑
        /// </summary>
        public bool AssMiles(string ids, long phaId, long user_id)
        {
            try
            {
                var thisPha = _dal.FindNoDeleteById(phaId);
                if (thisPha != null && thisPha.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE && (!string.IsNullOrEmpty(ids)))
                {
                    var idArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var thisId in idArr)
                    {
                        AssMile(long.Parse(thisId), phaId, user_id);
                    }
                }
            }
            catch (Exception msg)
            {
                return false;
            }

            return true;
        }
        /// <summary>
        /// 关联里程碑
        /// </summary>
        public bool AssMile(long conMiles, long phaId, long user_id)
        {
            try
            {
                var taskMile = new sdk_task_milestone()
                {
                    id = _dal.GetNextIdCom(),
                    contract_milestone_id = conMiles,
                    task_id = phaId,
                    create_user_id = user_id,
                    update_user_id = user_id,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                };
                new sdk_task_milestone_dal().Insert(taskMile);
                OperLogBLL.OperLogAdd<sdk_task_milestone>(taskMile, taskMile.id, user_id, OPER_LOG_OBJ_CATE.SDK_MILESTONE, "关联合同里程碑");
                return true;

            }
            catch (Exception msg)
            {
                return false;
            }
        }
        /// <summary>
        /// 解除关联里程碑
        /// </summary>
        public bool DisMile(long stmId, long user_id)
        {
            try
            {
                var stmDal = new sdk_task_milestone_dal();
                var thisTaskMile = stmDal.FindNoDeleteById(stmId);
                if (thisTaskMile != null)
                {
                    stmDal.SoftDelete(thisTaskMile, user_id);
                    OperLogBLL.OperLogDelete<sdk_task_milestone>(thisTaskMile, thisTaskMile.id, user_id, OPER_LOG_OBJ_CATE.SDK_MILESTONE, "解除关联里程碑");
                }
                return true;
            }
            catch (Exception msg)
            {
                return false;
            }
        }
        /// <summary>
        /// 批量解除关联里程碑
        /// </summary>
        public bool DisMiles(string ids, long user_id)
        {
            try
            {
                if ((!string.IsNullOrEmpty(ids)))
                {
                    var idArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var thisId in idArr)
                    {
                        DisMile(long.Parse(thisId), user_id);
                    }
                }
            }
            catch (Exception msg)
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// 批量将里程碑状态更改为准备计费
        /// </summary>
        public bool ReadyMiles(string ids, long user_id)
        {
            try
            {
                if (!string.IsNullOrEmpty(ids))
                {
                    var idArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var thisId in idArr)
                    {
                        ReadyMile(long.Parse(thisId), user_id);
                    }
                }
            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 将里程碑状态更改为准备计费
        /// </summary>
        public bool ReadyMile(long mileId, long user_id)
        {
            try
            {
                var ccmDal = new ctt_contract_milestone_dal();
                var stmDal = new sdk_task_milestone_dal();
                var thisConMile = ccmDal.FindNoDeleteById(mileId);
                if (thisConMile == null)
                {
                    var taskMile = stmDal.FindNoDeleteById(mileId);
                    if (taskMile != null)
                    {
                        thisConMile = ccmDal.FindNoDeleteById(taskMile.contract_milestone_id);
                    }
                }
                if (thisConMile != null && thisConMile.status_id != (int)DicEnum.MILESTONE_STATUS.READY_TO_BILL)
                {
                    thisConMile.status_id = (int)DicEnum.MILESTONE_STATUS.READY_TO_BILL;
                    thisConMile.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisConMile.update_user_id = user_id;
                    OperLogBLL.OperLogUpdate<ctt_contract_milestone>(thisConMile, ccmDal.FindNoDeleteById(thisConMile.id), thisConMile.id, user_id, OPER_LOG_OBJ_CATE.CONTRACT_MILESTONE, "修改里程碑状态");
                    ccmDal.Update(thisConMile);
                }

            }
            catch (Exception msg)
            {

                return false;
            }

            return true;
        }

        /// <summary>
        /// 取消任务
        /// </summary>
        public bool CancelTask(long task_id, long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                var thisTask = _dal.FindNoDeleteById(task_id);
                if (thisTask != null && user != null)
                {
                    thisTask.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisTask.update_user_id = user_id;
                    thisTask.status_id = (int)DicEnum.TICKET_STATUS.DONE;
                    thisTask.is_cancelled = 1;
                    thisTask.estimated_hours = 0;
                    thisTask.hours_per_resource = 0;
                    OperLogBLL.OperLogUpdate<sdk_task>(thisTask, _dal.FindNoDeleteById(thisTask.id), thisTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "取消任务");
                    _dal.Update(thisTask);

                    var activity = new com_activity()
                    {
                        id = _dal.GetNextIdCom(),
                        cate_id = (int)DicEnum.ACTIVITY_CATE.TASK_NOTE,
                        action_type_id = (int)ACTIVITY_TYPE.TASK_NOTE,
                        object_id = thisTask.id,
                        object_type_id = (int)OBJECT_TYPE.TASK,
                        resource_id = thisTask.owner_resource_id,
                        name = "完成原因",
                        description = $"任务被{user.name}取消，时间为{DateTime.Now.ToString("yyyy-MM-dd")}",
                        publish_type_id = (int)NOTE_PUBLISH_TYPE.PROJECT_ALL_USER,
                        create_user_id = user_id,
                        update_user_id = user_id,
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        is_system_generate = 1,
                        task_id = thisTask.id,
                        task_status_id = (int)DicEnum.TICKET_STATUS.DONE,
                    };
                    new com_activity_dal().Insert(activity);
                    OperLogBLL.OperLogAdd<com_activity>(activity, activity.id, user_id, OPER_LOG_OBJ_CATE.NOTIFY, "修改项目状态完成-添加通知");
                }
            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 恢复任务
        /// </summary>
        public bool RecoveTask(long task_id, long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                var thisTask = _dal.FindNoDeleteById(task_id);
                if (thisTask != null && user != null && thisTask.is_cancelled != 0)
                {
                    thisTask.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisTask.update_user_id = user_id;
                    thisTask.is_cancelled = 0;
                    OperLogBLL.OperLogUpdate<sdk_task>(thisTask, _dal.FindNoDeleteById(thisTask.id), thisTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "恢复任务");
                    _dal.Update(thisTask);
                }
            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// 将任务添加到任务库
        /// </summary>
        public bool AddTaskToLibary(sdk_task_library param, long user_id)
        {
            try
            {
                param.id = _dal.GetNextIdCom();
                param.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                param.create_user_id = user_id;
                param.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                param.update_user_id = user_id;
                new sdk_task_library_dal().Insert(param);
                OperLogBLL.OperLogAdd<sdk_task_library>(param, param.id, user_id, OPER_LOG_OBJ_CATE.SDK_TASK_LIBARY, "");
            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 编辑任务库
        /// </summary>
        public bool EditTaskLibary(sdk_task_library param,long userId)
        {
            sdk_task_library_dal stlDal = new sdk_task_library_dal();
            var oldLib = stlDal.FindNoDeleteById(userId);
            if (oldLib == null)
                return false;
            param.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            param.update_user_id = userId;
            stlDal.Update(param);
            OperLogBLL.OperLogUpdate<sdk_task_library>(param, oldLib, param.id, userId, OPER_LOG_OBJ_CATE.SDK_TASK_LIBARY, "");
            return true;
        }
        /// <summary>
        /// 删除任务库
        /// </summary>
        public bool DeleteLibary(long id,long userId)
        {
            sdk_task_library_dal stlDal = new sdk_task_library_dal();
            var oldLib = stlDal.FindNoDeleteById(userId);
            if (oldLib == null)
                return true;
            stlDal.SoftDelete(oldLib,userId);
            OperLogBLL.OperLogDelete<sdk_task_library>(oldLib, oldLib.id, userId, OPER_LOG_OBJ_CATE.SDK_TASK_LIBARY, "");
            return true;
        }

        /// <summary>
        /// 删除任务成员是这个员工的成员信息，或者主负责人是这个员工的移除
        /// </summary>
        public bool DeleteTeamRes(long projetc_id, long resource_id, long user_id)
        {
            try
            {
                var strDal = new sdk_task_resource_dal();
                var strList = strDal.GetListByProIdResId(projetc_id, resource_id);
                var taskList = _dal.GetListByProAndRes(projetc_id, resource_id);
                if (strList != null && strList.Count > 0)
                {
                    strList.ForEach(_ =>
                    {
                        strDal.SoftDelete(_, user_id);
                        OperLogBLL.OperLogDelete<sdk_task_resource>(_, _.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "删除任务团队成员");
                    });
                }

                if (taskList != null && taskList.Count > 0)
                {
                    taskList.ForEach(_ =>
                    {
                        _.owner_resource_id = null;
                        OnlyEditTask(_, user_id);
                    });
                }
            }
            catch (Exception)
            {

                return false;
            }

            return true;
        }
        /// <summary>
        /// 根据项目id和员工id查找员工是否在任务中出现
        /// </summary>
        public bool ResIsInTask(long project_id, long resource_id)
        {
            var strList = new sdk_task_resource_dal().GetListByProIdResId(project_id, resource_id);
            if (strList != null && strList.Count > 0)
            {
                return true;
            }
            var taskList = _dal.GetListByProAndRes(project_id, resource_id);
            if (taskList != null && taskList.Count > 0)
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// 删除成员是这个联系人的信息
        /// </summary>
        public bool DeleteTeamCon(long project_id, long contact_id, long user_id)
        {
            try
            {
                var strDal = new sdk_task_resource_dal();
                // GetListByConId
                var strList = strDal.GetListByConId(project_id, contact_id);
                if (strList != null && strList.Count > 0)
                {
                    strList.ForEach(_ =>
                    {
                        strDal.SoftDelete(_, user_id);
                        OperLogBLL.OperLogDelete<sdk_task_resource>(_, _.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "删除任务团队成员");
                    });
                }
            }
            catch (Exception msg)
            {
                return false;
            }

            return true;
        }
        /// <summary>
        /// 获取到规则当中优先级高的一个并返回
        /// </summary>
        public d_cost_code_rule GetRule(List<d_cost_code_rule> ruleList, long? account_id = null)
        {
            d_cost_code_rule returnRule = null;
            if (ruleList != null && ruleList.Count > 0)
            {
                if (account_id != null)
                {
                    returnRule = ruleList.FirstOrDefault(_ => _.resource_id != null && _.account_id == account_id);
                }
                else
                {
                    returnRule = ruleList.FirstOrDefault(_ => _.resource_id != null && _.account_id != null);
                }
                if (returnRule == null)
                {
                    if (account_id != null)
                    {
                        returnRule = ruleList.FirstOrDefault(_ => _.department_id != null && _.account_id == account_id);
                    }
                    else
                    {
                        returnRule = ruleList.FirstOrDefault(_ => _.department_id != null && _.account_id != null);
                    }
                    if (returnRule == null)
                    {
                        if (account_id != null)
                        {
                            returnRule = ruleList.FirstOrDefault(_ => _.account_id == account_id);
                        }
                        else
                        {
                            returnRule = ruleList.FirstOrDefault(_ => _.account_id != null);
                        }
                        if (returnRule == null)
                        {
                            returnRule = ruleList.FirstOrDefault(_ => _.department_id != null);
                            if (returnRule == null)
                            {
                                returnRule = ruleList[0];
                            }
                        }

                    }

                }

            }
            return returnRule;
        }
        /// <summary>
        /// 获取两个时间相差天数
        /// </summary>
        public int GetDiffDays(DateTime startDate,DateTime endDate)
        {
            int diffDay = 0;
            TimeSpan ts1 = new TimeSpan(startDate.Ticks);
            TimeSpan ts2 = new TimeSpan(endDate.Ticks);
            diffDay = ts1.Subtract(ts2).Duration().Days;   
            return diffDay;
        }
    }
}
