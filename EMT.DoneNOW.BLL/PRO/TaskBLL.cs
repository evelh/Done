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
                thisTask.sort_order = ReturnSortOrder((long)thisTask.project_id,thisTask.parent_id);
                thisTask.update_user_id = user.id;
                thisTask.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisTask.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

                #region 1.保存Task信息
                _dal.Insert(thisTask);
                OperLogBLL.OperLogAdd<sdk_task>(thisTask, thisTask.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "新增task");
                #endregion

                #region task 相关扩展字段
                var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TASK);  // 获取合同的自定义字段信息
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.TASK, user.id,
                    thisTask.id, udf_list, param.udf, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK);
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
                            var thisSDate = (DateTime)thisPreTask.estimated_end_date;
                            thisSDate = RetrunMaxTime((long)param.task.project_id, thisSDate, dic.Value);
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
                param.task.estimated_end_date = RetrunMaxTime((long)param.task.project_id,startDate,(int)param.task.estimated_duration);

                // 修改task的开始结束时间相关
                OperLogBLL.OperLogUpdate<sdk_task>(thisTask,_dal.FindNoDeleteById(thisTask.id), thisTask.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                _dal.Update(thisTask);


                // 递归修改父阶段相关数据
                UpdateParDate(param.task.parent_id,(long)param.task.estimated_begin_time,(DateTime)param.task.estimated_end_date,user.id);
                // 修改项目相关
                var ppDal = new pro_project_dal();
                var thisProject = ppDal.FindNoDeleteById((long)param.task.project_id);

                if (thisProject.start_date > startDate || thisProject.end_date < param.task.estimated_end_date)
                {
                    if (thisProject.start_date > startDate)
                    {
                        thisProject.start_date = startDate;
                    }
                    if (thisProject.end_date < param.task.estimated_end_date)
                    {
                        thisProject.end_date = param.task.estimated_end_date;
                    }
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
                                var isHas = strd.GetSinByTasResRol(thisTask.id,roleDep.resource_id,roleDep.role_id);
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

                               var isProHas =  pptDal.GetSinProByIdResRol(thisProject.id, roleDep.resource_id, roleDep.role_id);
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
                            var stb = new sdk_task_budget() {
                                id= stbDal.GetNextIdCom(),
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
                if(param.task.status_id == (int)DicEnum.TICKET_STATUS.DONE)
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
                                subject = param.subject==null?"": param.subject,
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

            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// 递归修改父Task 的时间
        /// </summary>
        public void UpdateParDate(long? tid, long startDate, DateTime endDate,long user_id)
        {
            if (tid != null)
            {
                var parTask = _dal.FindNoDeleteById((long)tid);
                if (parTask != null)
                {
                    if (parTask.estimated_begin_time > startDate || parTask.estimated_end_date < endDate)
                    {
                        if (parTask.estimated_begin_time > startDate)
                        {
                            parTask.estimated_begin_time = startDate;
                        }
                        if (parTask.estimated_end_date < endDate)
                        {
                            parTask.estimated_end_date = endDate;
                        }
                        OperLogBLL.OperLogUpdate<sdk_task>(parTask, _dal.FindNoDeleteById(parTask.id), parTask.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                        _dal.Update(parTask);
                        UpdateParDate(parTask.parent_id, (long)parTask.estimated_begin_time, (DateTime)parTask.estimated_end_date, user_id);
                    }
                }
            }
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

            var thisProject = new pro_project_dal().FindNoDeleteById(project_id);

            if (days >= 0)
            {
                if (thisProject.exclude_weekend == 0)    // 调整任务不包括非工作日（周末）
                {
                    thisDate = ReturnDateWtihWeek(thisDate, days, true);
                }
                else
                {
                    thisDate = thisDate.AddDays(days);
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
                                if (starDate < thisHol.hd && thisHol.hd < thisDate)
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
                            thisDate = ReturnDateWtihWeek(thisDate, holDays, true);
                        }
                        else
                        {
                            thisDate = thisDate.AddDays(holDays);
                        }
                    }
                }
            }

            return thisDate;
        }

        /// <summary>
        /// 计算往后推迟几天的返回天数（是否包括周末）
        /// </summary>
        public DateTime ReturnDateWtihWeek(DateTime thisDate, int days, bool isCloWeekday)
        {
            if (isCloWeekday)  // true 代表包括周末
            {
                thisDate = thisDate.AddDays(days);
            }
            else
            {
                // 1.计算第一周
                // 2.剩余添加天数除5 添加周
                // 3.添加最后一周天数
                // 1.
                var firstWeek = (int)thisDate.DayOfWeek;    //计算开始时间是周几。。 
                if (firstWeek > 0 || firstWeek <= 5)
                {
                    if (days < 5 - firstWeek)
                    {
                        thisDate = thisDate.AddDays(days);
                    }
                    else
                    {
                        thisDate = thisDate.AddDays(7 - firstWeek + 1);
                    }
                    days -= (5 - firstWeek);
                }
                else
                {
                    thisDate = thisDate.AddDays(firstWeek == 0 ? 1 : 2); // 周末补到星期一去处理
                }
                if (days > 0)
                {
                    // 2.
                    var weekNum = days / 5;
                    thisDate = thisDate.AddDays(weekNum * 7);
                    // 3.
                    if (weekNum % 5 != 0)
                    {
                        thisDate = thisDate.AddDays(weekNum % 5);
                    }
                }
            }
            return thisDate;
        }

        /// <summary>
        /// 返回Task编号
        /// </summary>
        public string ReturnTaskNo()
        {
            string no = "P" + DateTime.Now.ToString("yyyyMMdd");
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

        /// <summary>
        /// 返回新增的task的排序号
        /// </summary>
        public string ReturnSortOrder(long project_id,long? parTask_id)
        {
            string sorNo = "";
            var taskList = _dal.GetProTask(project_id);
            if (taskList != null && taskList.Count > 0)
            {
                if (parTask_id == null)
                {
                    var noParTaskList = taskList.Where(_ => _.parent_id == null).ToList();
                    if(noParTaskList!=null&& noParTaskList.Count > 0)
                    {
                        sorNo = (int.Parse(noParTaskList.Max(_ => _.sort_order))+1).ToString("#00");
                    }
                    else
                    {
                        sorNo = "01";
                    }
                }
                else
                {
                    var parTask = _dal.FindNoDeleteById((long)parTask_id);
                    var parTaskList = taskList.Where(_ => _.parent_id == parTask_id).ToList();
                    if(parTaskList!=null&& parTaskList.Count > 0)
                    {
                        var maxSortNo = parTaskList.Max(_ => _.sort_order);
                        var maxSortNoArr = maxSortNo.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                        var maxNo = (int.Parse(maxSortNoArr[maxSortNoArr.Length - 1]) + 1).ToString("#00");
                        var thisMaxNo = "";
                        for (int i = 0; i < maxSortNoArr.Length; i++)
                        {
                            thisMaxNo += maxSortNoArr[i]+".";
                            if(i == maxSortNoArr.Length - 1)
                            {
                                thisMaxNo += maxNo;
                            }
                        }
                        sorNo = thisMaxNo;
                    }
                    else
                    {
                        sorNo = parTask.sort_order + ".01";
                    }
                }
            }
            else
            {
                sorNo = "01";
            }
           
            return sorNo;
        }
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
                if(budList!=null&& budList.Count > 0)
                {
                    hours = budList.Sum(_ => _.estimated_hours);
                }
            }

            return hours;
        }

        /// <summary>
        /// 修改task的排序号(递归修改子节点排序号)
        /// </summary>
        public void ChangeTaskSortNo(string sortNo,long taskId, UserInfoDto user)
        {
            var thisTask = _dal.FindNoDeleteById(taskId);
            if (thisTask != null)
            {
                var dateNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var oldSortNo = thisTask.sort_order;  // oldSortNo会不会改变，待测试  todo-测试1539，110
                thisTask.sort_order = sortNo;
                OperLogBLL.OperLogUpdate<sdk_task>(thisTask, _dal.FindNoDeleteById(thisTask.id), thisTask.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                _dal.Update(thisTask);

                var subTaskList = _dal.GetTaskByParentId(thisTask.id);
                if (subTaskList != null && subTaskList.Count > 0)
                {
                    var parDepthNum = thisTask.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var thisSubTask in subTaskList)
                    {
                        var thisNoChaNo = thisSubTask.sort_order.Substring(oldSortNo.Length, thisSubTask.sort_order.Length-1);  // 获取到不会改变的部分 todo 临界值测试
                        var newNo = thisTask.sort_order + thisNoChaNo;
                        ChangeTaskSortNo(newNo,thisSubTask.id,user);
                    }
                }
            }
        }

        /// <summary>
        /// 通过父节点改变兄弟节点的排序号(补足空余排序号，同时修改本身的字节点的排序号) par_task_id为null 代表项目下的节点
        /// </summary>
        public void ChangBroTaskSortNoReduce(long project_id,long? par_task_id, UserInfoDto user)
        {
            var thisProject = new pro_project_dal().FindNoDeleteById(project_id);
            
            if (par_task_id == null)
            {
                var noParTaskList = _dal.GetNoParTaskByProId(project_id); // 为没有父节点的task排序
                if(noParTaskList!=null&& noParTaskList.Count > 0)
                {
                    // 上一兄弟节点找不到，补到最小的可用的节点
                    var nextNo = GetMinUserNoParSortNo(project_id);
                   
                    foreach (var noParTask in noParTaskList)
                    {
                        if (int.Parse(noParTask.sort_order) > int.Parse(nextNo))
                        {
                            ChangeTaskSortNo(nextNo,noParTask.id, user);
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

                    if(shoChaList!=null&& shoChaList.Count > 0)
                    {
                        foreach (var thisSub in shoChaList)
                        {
                            ChangeTaskSortNo(thisparTaskMaxNo,thisSub.id,user);
                            //thisSub.sort_order = thisparTaskMaxNo;
                            //_dal.Update(thisSub);
                            // 查日志
                            thisparTaskMaxNo = GetMinUserSortNo(parTask.id);
                            
                        }
                    }
                    
                }
            }
        }

        public string GetMinUserNoParSortNo(long project_id)
        {
            var nextNo = "";
            var noParTaskList = _dal.GetNoParTaskByProId(project_id); // 为没有父节点的task排序
            if (noParTaskList != null && noParTaskList.Count > 0)
            {
                // 上一兄弟节点找不到，补到最小的可用的节点

                foreach (var noParTask in noParTaskList)
                {
                    var thisNextNo = (int.Parse(noParTask.no) + 1).ToString("#00");
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
                    nextNo = ReturnSortOrder(project_id, null);
                }
            }
            return nextNo;
        }
        /// <summary>
        /// 获取到这个task下的最小的可用的排序号
        /// </summary>
        public string  GetMinUserSortNo(long task_id)
        {
            var sortNo = "";
            var thisTask = _dal.FindNoDeleteById(task_id);
            if (thisTask != null)
            {
                var thisSubTaskList = _dal.GetTaskByParentId(thisTask.id);
                if (thisSubTaskList != null && thisSubTaskList.Count > 0)
                {
                    var nextNo = "";
                    foreach (var thisSubTask in thisSubTaskList)
                    {
                        
                        var thisNoArr = thisSubTask.no.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        var thisNextNo = thisTask.sort_order+"."+ (int.Parse(thisNoArr[thisNoArr.Length - 1])+1).ToString("#00");
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
                        sortNo = ReturnSortOrder((long)thisTask.project_id,thisTask.id);
                    }
                    else
                    {
                        sortNo = nextNo;
                    }
                }
                else
                {
                    sortNo = thisTask.no + ".01";
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
        public void ChangeBroTaskSortNoAdd(long taskId,int num, UserInfoDto user)
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
                    if(shoChaList!=null&& shoChaList.Count > 0)
                    {
                        shoChaList.Reverse();
                        foreach (var shooChaTask in shoChaList)
                        {
                            var shooChaTaskNoArr = shooChaTask.sort_order.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);
                            var lastshooChaTaskNo = shooChaTaskNoArr[shooChaTaskNoArr.Length - 1]; // 获取到末尾加一
                            var thisNoChaNo = shooChaTask.sort_order.Substring(0, lastshooChaTaskNo.Length - 1);  // 获取到不会改变的部分 todo 临界值测试
                            var newNo = thisNoChaNo + (int.Parse(lastshooChaTaskNo)+ num).ToString("#0.00");
                            ChangeTaskSortNo(newNo, shooChaTask.id, user);
                        }
                    }

                }
            }

        }
    }
}
