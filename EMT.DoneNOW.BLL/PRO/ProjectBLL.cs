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
using System.Net.Mail;
using System.Net;

namespace EMT.DoneNOW.BLL
{
    public class ProjectBLL
    {
        private pro_project_dal _dal = new pro_project_dal();
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("project_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PROJECT_TYPE)));              // 项目类型
            dic.Add("project_status", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PROJECT_STATUS)));              // 项目状态
            dic.Add("project_line_of_business", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PROJECT_LINE_OF_BUSINESS)));              // 项目业务范围
            dic.Add("department", new sys_department_dal().GetDepartment());  // 部门
            dic.Add("task_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TASK_TYPE)));   // task 类型
            dic.Add("ticket_status", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TICKET_STATUS)));   // task 状态
            dic.Add("country", new DistrictBLL().GetCountryList());                          // 国家表
            dic.Add("addressdistrict", new d_district_dal().GetDictionary());                 // 地址表（省市县区）

            dic.Add("org_location", new sys_organization_location_dal().GetLocList());  // 区域地址
            dic.Add("sys_resource", new sys_resource_dal().GetDictionary(true));  // 项目经理
            return dic;
        }
        /// <summary>
        /// 新增项目
        /// </summary>
        public bool AddPro(ProjectDto param, long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                if (user == null)
                    return false;
                #region 1.项目基本信息
                var thisProject = param.project;


                if (thisProject.id == 0)
                {
                    thisProject.id = _dal.GetNextIdCom();
                }
                // thisProject.status_id = (int)PROJECT_STATUS.NEW;
                thisProject.opportunity_id = thisProject.opportunity_id == 0 ? null : thisProject.opportunity_id;
                thisProject.status_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisProject.status_detail = "";
                thisProject.no = ReturnProjectNo();
                thisProject.create_user_id = user.id;
                thisProject.update_user_id = user.id;
                thisProject.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisProject.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                // department_id organization_location_id
                thisProject.line_of_business_id = thisProject.line_of_business_id == 0 ? null : thisProject.line_of_business_id;
                thisProject.department_id = thisProject.department_id == 0 ? null : thisProject.department_id;
                thisProject.owner_resource_id = thisProject.owner_resource_id == 0 ? null : thisProject.owner_resource_id;
                _dal.Insert(thisProject);
                OperLogBLL.OperLogAdd<pro_project>(thisProject, thisProject.id, user.id, OPER_LOG_OBJ_CATE.PROJECT, "新增项目");
                #endregion

                #region 2.自定义信息
                var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.PROJECTS);  // 获取合同的自定义字段信息
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.PROJECTS, user.id,
                    thisProject.id, udf_list, param.udf, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_EXTENSION_INFORMATION);
                #endregion

                #region  导入相关配置--日历条目，项目成本，项目成员，项目设置

                if (!string.IsNullOrEmpty(param.fromTempId))
                {
                    var tempPro = _dal.FindNoDeleteById(long.Parse(param.fromTempId));
                    if (tempPro != null)
                    {
                        // task相关
                        if (!string.IsNullOrEmpty(param.tempChoTaskIds))
                        {
                            bool isCopyRes = false;  // 用户是否选择导入项目成员--
                            if (!string.IsNullOrEmpty(param.IsCopyTeamMember))
                            {
                                isCopyRes = true;
                            }
                            new TaskBLL().ImportFromTemp(thisProject.id, param.tempChoTaskIds, user.id, isCopyRes);
                        }
                        // 日历条目
                        if (!string.IsNullOrEmpty(param.IsCopyCalendarItem))
                        {
                            var ppcDal = new pro_project_calendar_dal();
                            var camList = ppcDal.GetCalByPro(tempPro.id);
                            if (camList != null && camList.Count > 0)
                            {
                                var createTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                var updateTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                camList.ForEach(_ =>
                                {
                                    _.id = ppcDal.GetNextIdCom();
                                    _.oid = 0;
                                    _.project_id = thisProject.id;
                                    _.create_time = createTime;
                                    _.create_user_id = user.id;
                                    _.update_time = updateTime;
                                    _.update_user_id = user.id;
                                    ppcDal.Insert(_);
                                    OperLogBLL.OperLogAdd<pro_project_calendar>(_, _.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_CALENDAR, "导入日历条目");
                                });
                            }
                        }
                        // 项目成本
                        if (!string.IsNullOrEmpty(param.IsCopyProjectCharge))
                        {
                            var cccDal = new ctt_contract_cost_dal();
                            var costList = cccDal.GetCostByProId(tempPro.id);
                            if (costList != null && costList.Count > 0)
                            {
                                var createTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                var updateTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                costList.ForEach(_ =>
                                {
                                    _.id = cccDal.GetNextIdCom();
                                    _.create_time = createTime;
                                    _.create_user_id = user.id;
                                    _.update_user_id = user.id;
                                    _.update_time = updateTime;
                                    _.date_purchased = DateTime.Now;
                                    _.status_id = (int)DicEnum.COST_STATUS.UNDETERMINED;

                                    _.paymenttype = null;
                                    _.invoice_no = null;
                                    _.extacctitemid = null;
                                    _.web_service_date = null;
                                    _.contract_id = null;
                                    _.purchase_order_no = null;
                                    // BlockRetainerIncidentId

                                    cccDal.Insert(_);
                                    OperLogBLL.OperLogAdd<ctt_contract_cost>(_, _.id, user.id, OPER_LOG_OBJ_CATE.CONTRACT_COST, "从模板导入项目成本");
                                });
                                // CONTRACT_COST
                            }
                        }
                        // 项目成员
                        if (!string.IsNullOrEmpty(param.IsCopyTeamMember))
                        {
                        }
                        // 项目设置
                        if (!string.IsNullOrEmpty(param.IsCopyProjectSet))
                        {
                        }
                    }

                }
                #endregion



                #region 3.项目团队处理
                var pptDal = new pro_project_team_dal();

                if (!string.IsNullOrEmpty(param.resDepIds))
                {
                    var resDepList = param.resDepIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (resDepList != null && resDepList.Count() > 0)
                    {
                        var srdDal = new sys_resource_department_dal();
                        var pptrDal = new pro_project_team_role_dal();
                        foreach (var resDepId in resDepList)
                        {
                            var roleDep = srdDal.FindById(long.Parse(resDepId));
                            if (roleDep != null)
                            {
                                var isHas = pptDal.GetSinProByIdResRol(thisProject.id, roleDep.resource_id, roleDep.role_id);
                                if (isHas == null)
                                {
                                    var item = new pro_project_team()
                                    {
                                        id = pptDal.GetNextIdCom(),
                                        project_id = thisProject.id,
                                        resource_id = roleDep.resource_id,
                                        resource_daily_hours = (decimal)param.project.resource_daily_hours,
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
                            var item = new pro_project_team()
                            {
                                id = pptDal.GetNextIdCom(),
                                project_id = thisProject.id,
                                contact_id = long.Parse(conId),
                                resource_daily_hours = (decimal)param.project.resource_daily_hours,
                                create_user_id = user.id,
                                update_user_id = user.id,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            };
                            pptDal.Insert(item);
                            OperLogBLL.OperLogAdd<pro_project_team>(item, item.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_ITEM, "新增项目团队-添加联系人");
                        }
                    }
                }
                #endregion

                #region 4.保存通知信息
                if (param.project.template_id != null)
                {
                    var temp = new sys_notify_tmpl_dal().FindNoDeleteById((long)param.project.template_id);
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
                                subject = param.subject,
                                body_text = temp_email_List[0].body_text + param.otherEmail,
                                // is_success = (sbyte)(isSuccess ? 1 : 0),
                                is_html_format = 0,
                                create_user_id = user.id,
                                update_user_id = user.id,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            };
                            isSuccess = SendEmail(notify);
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
        /// 修改项目
        /// </summary>
        public bool EditProject(ProjectDto param, long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                if (user == null)
                    return false;
                var oldPro = _dal.FindNoDeleteById(param.project.id);
                if (oldPro != null)
                {
                    #region 修改项目相关
                    param.project.oid = oldPro.oid;
                    param.project.update_user_id = user.id;
                    param.project.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    param.project.create_user_id = oldPro.create_user_id;
                    param.project.create_time = oldPro.create_time;
                    param.project.template_id = oldPro.template_id;
                    param.project.line_of_business_id = param.project.line_of_business_id == 0 ? null : param.project.line_of_business_id;
                    param.project.department_id = param.project.department_id == 0 ? null : param.project.department_id;
                    param.project.opportunity_id = param.project.opportunity_id == 0 ? null : param.project.opportunity_id;
                    param.project.owner_resource_id = param.project.owner_resource_id == 0 ? null : param.project.owner_resource_id;
                    _dal.Update(param.project);
                    OperLogBLL.OperLogUpdate<pro_project>(param.project, oldPro, param.project.id, user.id, OPER_LOG_OBJ_CATE.PROJECT, "修改项目");
                    #endregion
                    #region 修改项目自定义
                    var udf_project_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.PROJECTS);
                    new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.PROJECTS, udf_project_list, param.project.id, param.udf, user, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_EXTENSION_INFORMATION);
                    #endregion

                    #region 项目状态更改时添加备注信息

                    if (oldPro.status_id != param.project.status_id)
                    {
                        var oldStatus = new d_general_dal().FindNoDeleteById(oldPro.status_id);
                        var oldStatusName = oldStatus == null ? "" : oldStatus.name;
                        var newStatus = new d_general_dal().FindNoDeleteById(param.project.status_id);
                        var newStatusName = newStatus == null ? "" : newStatus.name;
                        var activity = new com_activity()
                        {
                            id = _dal.GetNextIdCom(),
                            cate_id = (int)DicEnum.ACTIVITY_CATE.PROJECT_NOTE,
                            action_type_id = (int)ACTIVITY_TYPE.PROJECT_NOTE,
                            object_id = param.project.id,
                            object_type_id = (int)OBJECT_TYPE.PROJECT,
                            account_id = param.project.account_id,
                            name = "状态变更、状态描述变更",
                            description = $"状态从{oldStatusName}变为{newStatusName}；状态描述从{oldPro.status_detail}到{param.project.status_detail}",
                            publish_type_id = (int)NOTE_PUBLISH_TYPE.PROJECT_ALL_USER,
                            create_user_id = user.id,
                            update_user_id = user.id,
                            create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            is_system_generate = 1,
                        };

                        new com_activity_dal().Insert(activity);
                        OperLogBLL.OperLogAdd<com_activity>(activity, activity.id, user.id, OPER_LOG_OBJ_CATE.NOTIFY, "修改项目状态-添加通知");
                    }



                    #endregion
                }
            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 完成项目
        /// </summary>
        public bool CompleteProject(CompleteProjectDto param, long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                if (user == null)
                    return false;
                if (param.project != null)
                {
                    var oldProject = _dal.FindNoDeleteById(param.project.id);
                    #region 1.修改项目相关
                    param.project.status_id = (int)PROJECT_STATUS.DONE;
                    param.project.start_date = DateTime.Now;
                    param.project.status_detail += "  项目被设置为完成状态";
                    param.project.update_user_id = user.id;
                    param.project.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    _dal.Update(param.project);
                    OperLogBLL.OperLogUpdate<pro_project>(param.project, oldProject, param.project.id, user.id, OPER_LOG_OBJ_CATE.PROJECT, "修改项目");
                    #endregion

                    #region 2.修改任务状态
                    if (param.taskList != null && param.taskList.Count > 0)
                    {
                        var tDal = new sdk_task_dal();
                        foreach (var task in param.taskList)
                        {
                            var oldTask = tDal.FindNoDeleteById(task.id);
                            if (oldTask != null)
                            {
                                task.status_id = (int)TICKET_STATUS.DONE;
                                task.estimated_end_date = DateTime.Now;
                                task.update_user_id = user.id;
                                task.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                tDal.Update(task);
                                OperLogBLL.OperLogUpdate<sdk_task>(task, oldTask, task.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "任务状态变更");
                            }

                        }
                    }
                    #endregion

                    #region 3.更新商机信息
                    if (param.project.opportunity_id != null)
                    {
                        var oDal = new crm_opportunity_dal();
                        var oldOpp = oDal.FindNoDeleteById((long)param.project.opportunity_id);
                        if (oldOpp != null)
                        {
                            if (param.isUpdateOppDate)
                            {
                                oldOpp.start_date = param.ProStartDate;
                            }
                            if (param.isUpdateOppStatus)
                            {
                                oldOpp.status_id = (int)OPPORTUNITY_STATUS.IMPLEMENTED;
                            }

                            if (param.isUpdateOppDate || param.isUpdateOppStatus)
                            {
                                OperLogBLL.OperLogUpdate<crm_opportunity>(oldOpp, oDal.FindNoDeleteById((long)param.project.opportunity_id), oldOpp.id, user.id, OPER_LOG_OBJ_CATE.OPPORTUNITY, "修改商机");
                                new crm_opportunity_dal().Update(oldOpp);
                            }

                        }

                    }

                    #endregion

                    #region 4.新增备注
                    var activity = new com_activity()
                    {
                        id = _dal.GetNextIdCom(),
                        cate_id = (int)DicEnum.ACTIVITY_CATE.PROJECT_NOTE,
                        action_type_id = (int)ACTIVITY_TYPE.PROJECT_NOTE,
                        object_id = param.project.id,
                        object_type_id = (int)OBJECT_TYPE.PROJECT,
                        account_id = param.project.account_id,
                        resource_id = param.project.owner_resource_id,
                        opportunity_id = param.project.opportunity_id,
                        name = "状态改变",
                        description = "项目被设置为完成状态",
                        publish_type_id = (int)NOTE_PUBLISH_TYPE.PROJECT_ALL_USER,
                        create_user_id = user.id,
                        update_user_id = user.id,
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        is_system_generate = 1,
                    };
                    new com_activity_dal().Insert(activity);
                    OperLogBLL.OperLogAdd<com_activity>(activity, activity.id, user.id, OPER_LOG_OBJ_CATE.NOTIFY, "修改项目状态-添加通知");
                    #endregion

                    #region 5.保存配置项信息
                    if (param.insProList != null && param.insProList.Count > 0)
                    {
                        var ipDal = new ivt_product_dal();
                        var cipDal = new crm_installed_product_dal();
                        var cccDal = new ctt_contract_cost_dal();
                        foreach (var inspro in param.insProList)
                        {
                            // 新增配置项
                            var product = ipDal.FindNoDeleteById(inspro.product_id);
                            var cost = cccDal.FindNoDeleteById(inspro.id);
                            if (product == null || cost == null)
                            {
                                continue;
                            }
                            var thisInsPro = new crm_installed_product()
                            {
                                id = _dal.GetNextIdCom(),
                                product_id = inspro.product_id,
                                cate_id = product.installed_product_cate_id,
                                installed_resource_id = user.id,
                                start_date = inspro.installOn,
                                through_date = inspro.warExpiration,
                                serial_number = inspro.serial_number,
                                is_active = 1,
                                account_id = param.project.account_id,
                                create_user_id = user.id,
                                update_user_id = user.id,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            };
                            cipDal.Insert(thisInsPro);
                            OperLogBLL.OperLogAdd<crm_installed_product>(thisInsPro, thisInsPro.id, user.id, OPER_LOG_OBJ_CATE.CONFIGURAITEM, "保存配置项");
                            // 修改成本为已创建配置项
                            var oldCost = cccDal.FindNoDeleteById(inspro.id);
                            cost.create_ci = 1;
                            cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            cost.update_user_id = user.id;
                            cccDal.Update(cost);
                            OperLogBLL.OperLogUpdate<ctt_contract_cost>(cost, oldCost, cost.id, user.id, OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改项目成本");

                        }
                    }
                    #endregion

                    #region 6.保存通知信息
                    if (param.noTempId != 0)
                    {
                        var temp = new sys_notify_tmpl_dal().FindNoDeleteById(param.noTempId);
                        if (temp != null)
                        {
                            var temp_email_List = new sys_notify_tmpl_email_dal().GetEmailByTempId(temp.id);
                            if (temp_email_List != null && temp_email_List.Count > 0)
                            {
                                string toEmail = "";
                                if (!string.IsNullOrEmpty(param.noResIds))
                                {
                                    var resList = new sys_resource_dal().GetListByIds(param.noResIds);
                                    if (resList != null && resList.Count > 0)
                                    {
                                        resList.ForEach(_ =>
                                        {
                                            if (!string.IsNullOrEmpty(_.email))
                                            {
                                                toEmail += _.email + ',';
                                            }
                                        });
                                    }
                                }
                                toEmail += param.otherMail;
                                bool isSuccess = false;
                                var notify = new com_notify_email()
                                {
                                    id = _dal.GetNextIdCom(),
                                    cate_id = (int)NOTIFY_CATE.PROJECT,
                                    event_id = (int)DicEnum.NOTIFY_EVENT.PROJECT_COMPLETED,
                                    to_email = toEmail,
                                    notify_tmpl_id = temp.id,
                                    from_email = user.email,
                                    from_email_name = user.name,
                                    subject = param.subject,
                                    body_text = temp_email_List[0].body_text + param.appendText,
                                    is_html_format = 0,
                                    create_user_id = user.id,
                                    update_user_id = user.id,
                                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                };
                                // isSuccess = SendEmail(notify);
                                notify.is_success = (sbyte)(isSuccess ? 1 : 0);
                                new com_notify_email_dal().Insert(notify);
                                OperLogBLL.OperLogAdd<com_notify_email>(notify, notify.id, user.id, OPER_LOG_OBJ_CATE.NOTIFY, "完成项目-添加通知");
                            }
                        }
                    }


                    #endregion
                }
                else
                {
                    return false;
                }
            }
            catch (Exception msg)
            {

                return false;
            }
            return true;
        }
        /// <summary>
        /// 停用项目
        /// </summary>
        public bool DisProject(long id, long user_id)
        {
            var thisPro = _dal.FindNoDeleteById(id);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (thisPro == null || user == null)
            {
                return false;
            }
            thisPro.status_id = (int)DicEnum.PROJECT_STATUS.DISABLE;
            thisPro.update_user_id = user.id;
            thisPro.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var oldPro = _dal.FindNoDeleteById(id);
            var result = _dal.Update(thisPro);
            if (result)
            {
                OperLogBLL.OperLogUpdate<pro_project>(thisPro, oldPro, thisPro.id, user.id, OPER_LOG_OBJ_CATE.PROJECT, "停用项目");
                return true;
            }
            else
            {
                return false;
            }

        }
        /// <summary>
        /// 删除项目(返回失败原因)
        /// </summary>
        public bool DeletePro(long ProjectId, long user_id, out string reson)
        {
            reson = "";

            var thisProject = _dal.FindNoDeleteById(ProjectId);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (thisProject != null && user != null)
            {
                var taskDal = new sdk_task_dal();
                var taskList = taskDal.GetProjectTask(thisProject.id);
                #region 工时校验
                // todo
                #endregion
                #region 成本校验
                var costList = new ctt_contract_cost_dal().GetCostByProId(thisProject.id);
                if (costList != null && costList.Count > 0)
                {
                    reson = "cost";
                    return false;
                }
                #endregion

                #region 费用校验
                var expList = new sdk_expense_dal().GetExpByProId(thisProject.id);
                if (expList != null && expList.Count > 0)
                {
                    reson = "expense";
                    return false;
                }
                #endregion
                #region 服务预定校验
                // todo
                #endregion
                #region 备注校验（包括任务相关备注）
                var caDal = new com_activity_dal();
                var actList = caDal.GetActiListByOID(thisProject.id);
                if (actList != null && actList.Count > 0)  // 项目备注校验
                {
                    reson = "proNote";
                    return false;
                }
                if (taskList != null && taskList.Count > 0)  // 任务备注校验
                {
                    foreach (var task in taskList)
                    {
                        var tnoList = caDal.GetActiListByOID(task.id);
                        if (tnoList != null && tnoList.Count > 0)
                        {
                            reson = "taskNote";
                            return false;
                        }
                    }
                }
                #endregion
                #region 附件校验（包括任务相关附件）
                var cattDal = new com_attachment_dal();
                var attList = cattDal.GetAttListByOid(thisProject.id);
                if (attList != null && attList.Count > 0)  // 项目备注校验
                {
                    reson = "proAttachment";
                    return false;
                }
                if (taskList != null && taskList.Count > 0)  // 任务备注校验
                {
                    foreach (var task in taskList)
                    {
                        var tnoList = cattDal.GetAttListByOid(task.id);
                        if (tnoList != null && tnoList.Count > 0)
                        {
                            reson = "taskAttachment";
                            return false;
                        }
                    }
                }
                #endregion
                #region 里程碑校验
                // todo
                #endregion

                #region 删除项目处理逻辑


                var deleteTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

                #region 项目团队相关删除
                var pptDal = new pro_project_team_dal();
                var pptrDal = new pro_project_team_role_dal();
                var resList = pptDal.GetResListByProId(thisProject.id);
                if (resList != null && resList.Count > 0)
                {
                    resList.ForEach(_ =>
                    {
                        var teamRole = pptrDal.GetSinTeamRole(_.id);
                        if (teamRole != null)
                        {
                            teamRole.delete_time = deleteTime;
                            teamRole.delete_user_id = user.id;
                            pptrDal.Update(teamRole);
                            OperLogBLL.OperLogDelete(teamRole, teamRole.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_ITEM_ROLE, "删除项目团队角色");
                        }

                        _.delete_user_id = user.id;
                        _.delete_time = deleteTime;
                        pptDal.Update(_);
                        OperLogBLL.OperLogDelete(_, _.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_ITEM, "删除项目团队员工");
                    });
                }
                var conList = pptDal.GetConListByProId(thisProject.id);
                if (conList != null && conList.Count > 0)
                {
                    conList.ForEach(_ =>
                    {
                        _.delete_time = deleteTime;
                        _.delete_user_id = user.id;
                        pptDal.Update(_);
                        OperLogBLL.OperLogDelete(_, _.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_ITEM, "删除项目团队角色");
                    });
                }
                #endregion

                #region 项目日历相关删除
                var ppcDal = new pro_project_calendar_dal();
                var proCalList = ppcDal.GetCalByPro(thisProject.id);
                if (proCalList != null && proCalList.Count > 0)
                {
                    proCalList.ForEach(_ =>
                    {
                        _.delete_time = deleteTime;
                        _.delete_user_id = user.id;
                        ppcDal.Update(_);
                        OperLogBLL.OperLogDelete(_, _.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_CALENDAR, "删除项目日历");
                    });
                }
                #endregion

                #region 删除项目任务 和删除项目 
                if (taskList != null && taskList.Count > 0)
                {
                    var strDal = new sdk_task_resource_dal();
                    taskList.ForEach(_ =>
                    {
                        var taskResList = strDal.GetTaskResByTaskId(_.id);
                        if (taskResList != null && taskResList.Count > 0)
                        {
                            taskResList.ForEach(tr =>
                            {
                                tr.delete_time = deleteTime;
                                tr.delete_user_id = user.id;
                                strDal.Update(tr);
                                OperLogBLL.OperLogDelete(tr, tr.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "删除任务分配对象");
                            });
                        }

                        // sdk_task_predecessor处理 todo

                        _.delete_time = deleteTime;
                        _.delete_user_id = user.id;
                        taskDal.Update(_);
                        OperLogBLL.OperLogDelete(_, _.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "删除项目Task");
                    });




                }

                thisProject.delete_time = deleteTime;
                thisProject.delete_user_id = user.id;
                _dal.Update(thisProject);
                OperLogBLL.OperLogDelete(thisProject, thisProject.id, user.id, OPER_LOG_OBJ_CATE.PROJECT, "删除项目");
                #endregion



                #endregion


            }
            else
            {
                reson = "404";
                return false;
            }

            return true;
        }

        public bool SaveAsBaseline(long ProjectId, long user_id)
        {
            bool result = false;
            try
            {
                var thisProject = _dal.FindNoDeleteById(ProjectId);
                if (thisProject != null)
                {
                    var old_project_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.PROJECTS);
                    var old_project_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.PROJECTS, thisProject.id, old_project_udfList);

                    var stDal = new sdk_task_dal();
                    var oldTaskList = stDal.GetAllProTask(thisProject.id);
                    var basId = _dal.GetNextIdCom();
                    var oldId = thisProject.id;
                    var user = UserInfoBLL.GetUserInfo(user_id);
                    if (user == null)
                        return false;
                    thisProject.id = basId;
                    thisProject.oid = 0;
                    thisProject.type_id = (int)DicEnum.PROJECT_TYPE.BENCHMARK;
                    thisProject.create_user_id = user.id;
                    thisProject.update_user_id = user.id;
                    thisProject.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisProject.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisProject.change_orders_budget = ProChaPrice(oldId);
                    thisProject.change_orders_revenue = ProChaCost(oldId);
                    if(oldTaskList!=null&& oldTaskList.Count > 0)
                    {
                        var nocomList = oldTaskList.Where(_ => _.status_id != (int)DicEnum.TICKET_STATUS.DONE).ToList();
                        if(nocomList!=null&& nocomList.Count > 0)
                        {
                            thisProject.percent_complete = (int)((nocomList.Count*100) / ((decimal)oldTaskList.Count));
                        }
                        else
                        {
                            thisProject.percent_complete = 0;
                        }

                    }
                    else
                    {
                        thisProject.percent_complete = 0;
                    }
                    _dal.Insert(thisProject);
                    OperLogBLL.OperLogAdd<pro_project>(thisProject, thisProject.id, user.id, OPER_LOG_OBJ_CATE.PROJECT, "新增基准");
                    new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.PROJECTS, user.id,
                 thisProject.id, old_project_udfList, old_project_udfValueList, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_EXTENSION_INFORMATION);

                    var oldProject = _dal.FindNoDeleteById(oldId);
                    oldProject.baseline_project_id = basId;
                    oldProject.create_user_id = user.id;
                    oldProject.update_user_id = user.id;
                    oldProject.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    oldProject.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    _dal.Update(oldProject);

                    if(oldTaskList != null&& oldTaskList.Count > 0)
                    {
                        oldTaskList.ForEach(_ => {


                        });
                    }





                }
            }
            catch (Exception msg)
            {
                result = false;
            }
            return result;
        }


        #region 项目相关数据获取方法
        /// <summary>
        /// 获取项目的任务完成百分比
        /// </summary>
        public decimal CompleteTaskPercent(long project_id)
        {
            decimal percent = 0;
            var taskList = new sdk_task_dal().GetProTask(project_id, $" and type_id in({(int)TASK_TYPE.PROJECT_TASK},{(int)TASK_TYPE.PROJECT_ISSUE})");
            if (taskList != null && taskList.Count > 0)
            {
                var comTask = taskList.Where(_ => _.status_id == (int)TICKET_STATUS.DONE).ToList();
                if (comTask != null && comTask.Count > 0)
                {
                    percent = comTask.Count / taskList.Count;
                }
            }

            return percent;
        }
        /// <summary>
        /// 获取项目的估算时间
        /// </summary>
        public decimal ESTIMATED_HOURS(long project_id)
        {
            decimal hours = 0;
            var taskList = new sdk_task_dal().GetProjectTask(project_id);
            if (taskList != null && taskList.Count > 0)
            {
                hours = taskList.Sum(_ => _.estimated_hours);
            }
            return hours;
        }
        /// <summary>
        /// 获取项目的变更单时间
        /// </summary>
        public decimal ProChaHours(long project_id)
        {
            decimal hours = 0;
            var costList = new ctt_contract_cost_dal().GetCostByProId(project_id);
            if (costList != null && costList.Count > 0)
            {
                hours = costList.Sum(_ => _.change_order_hours == null ? 0 : (decimal)_.change_order_hours);
            }
            return hours;
        }
        /// <summary>
        /// 变更单收入
        /// </summary>
        public decimal ProChaPrice(long project_id)
        {
            decimal price = 0;
            var costList = new ctt_contract_cost_dal().GetCostByProId(project_id);
            if (costList != null && costList.Count > 0)
            {
                price = costList.Sum(_ => _.unit_price != null && _.quantity != null ? ((decimal)_.unit_price * (decimal)_.quantity) : 0);
            }
            return price;
        }
        /// <summary>
        /// 变更单成本
        /// </summary>
        public decimal ProChaCost(long project_id)
        {
            decimal cost = 0;
            var costList = new ctt_contract_cost_dal().GetCostByProId(project_id);
            if (costList != null && costList.Count > 0)
            {
                cost = costList.Sum(_ => _.unit_cost != null && _.quantity != null ? ((decimal)_.unit_cost * (decimal)_.quantity) : 0);
            }
            return cost;
        }
        /// <summary>
        /// 获取项目的实际时间
        /// </summary>
        public decimal ProWorkHours(long project_id)
        {
            decimal hours = 0;
            var taskList = new sdk_task_dal().GetProjectTask(project_id);
            if (taskList != null && taskList.Count > 0)
            {
                hours = taskList.Sum(_ => RetTaskActHours(_.id));
            }
            return hours;
        }
        /// <summary>
        /// 获取项目的估算差异
        /// </summary>
        public decimal Provariance(long project_id)
        {
            decimal hours = 0;
            var taskList = new sdk_task_dal().GetProjectTask(project_id);
            if (taskList != null && taskList.Count > 0)
            {
                hours = taskList.Sum(_ => _.projected_variance);
            }
            return hours;
        }

        #endregion
        /// <summary>
        /// 获取项目编号
        /// </summary>
        public string ReturnProjectNo()
        {
            string no = "P" + DateTime.Now.ToString("yyyyMMdd");
            var prolist = _dal.GetProByNo(no);
            if (prolist != null && prolist.Count > 0)
            {
                int maxNo = 0;
                prolist.ForEach(_ =>
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
        /// 获取任务的实际工作时间
        /// </summary>
        public decimal RetTaskActHours(long task_id)
        {
            decimal hourSum = 0;
            var workEntList = new sdk_work_entry_dal().GetByTaskId(task_id);
            if (workEntList != null && workEntList.Count > 0)
            {
                hourSum = workEntList.Sum(_ => _.hours_worked == null ? 0 : (decimal)_.hours_worked);
            }
            return hourSum;
        }

        /// <summary>
        /// 发送邮件，返回是否发送成功
        /// </summary>
        public bool SendEmail(com_notify_email email)
        {
            try
            {

                MailMessage message = new MailMessage();

                MailAddress fromAddr = new MailAddress(email.from_email);
                message.From = fromAddr;
                // message.From = ;
                // 设置收件人
                var toEmailList = email.to_email.Split(new char[] { ';' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var toEmail in toEmailList)
                {
                    message.To.Add(toEmail);
                }


                // 设置抄送人
                var ccEmailList = email.cc_email.Split(new char[] { ';' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var ccEmail in ccEmailList)
                {
                    message.CC.Add(ccEmail);
                }

                message.To.Add("zhufei_dsjt@shdsjt.cn");

                // 密送地址
                var bccEmailList = email.bcc_email.Split(new char[] { ';' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var bccEmail in bccEmailList)
                {
                    message.Bcc.Add(bccEmail);
                }


                // 设置邮件标题
                message.Subject = email.subject;
                // 设置邮件内容
                message.Body = email.body_text;
                message.BodyEncoding = Encoding.GetEncoding("gb2312");

                SmtpClient client = new SmtpClient();
                #region 需要授权码或者密码进行发送邮件(测试通过--)
                //client.Host = "smtp.163.com";
                ////设置发送人的邮箱账号和密码 --是否使用授权码登陆发送
                //client.UseDefaultCredentials = true;
                //client.Credentials = new NetworkCredential("15738813663@163.com", "tt123456");
                ////启用ssl,也就是安全发送
                //client.EnableSsl = true;
                #endregion

                client.Host = "localhost";
                // client.Send(message);

                //发送邮件
                client.Send(message);
            }
            catch (Exception msg)
            {

                return false;
            }

            return true;
        }
    }
}
