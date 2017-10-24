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
    public class ProjectBLL
    {
        private pro_project_dal _dal = new pro_project_dal();

        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("project_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PROJECT_TYPE)));              // 项目类型
            dic.Add("project_status", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PROJECT_STATUS)));              // 项目状态
            dic.Add("project_line_of_business", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PROJECT_LINE_OF_BUSINESS)));              // 项目业务范围
            dic.Add("department" ,new sys_department_dal().GetDepartment());  // 部门

            dic.Add("org_location", new sys_organization_location_dal().GetLocList());  // 区域地址
            dic.Add("sys_resource", new sys_resource_dal().GetDictionary(true));  // 项目经理
            return dic;
        }

        public bool AddPro(ProjectDto param,long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                if (user == null)
                    return false;
                #region 1.项目基本信息
                var thisProject = param.project;
                thisProject.id = _dal.GetNextIdCom();
               // thisProject.status_id = (int)PROJECT_STATUS.NEW;
                thisProject.status_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisProject.status_detail = "";
                thisProject.create_user_id = user.id;
                thisProject.update_user_id = user.id;
                thisProject.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisProject.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                // department_id organization_location_id
                thisProject.line_of_business_id = thisProject.line_of_business_id == 0 ? null : thisProject.line_of_business_id;
                thisProject.department_id = thisProject.department_id == 0 ? null : thisProject.department_id;
                _dal.Insert(thisProject);
                OperLogBLL.OperLogAdd<pro_project>(thisProject,thisProject.id,user.id, OPER_LOG_OBJ_CATE.PROJECT,"新增项目");
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
                            var stDal = new sdk_task_dal();
                            var temTaskList = stDal.GetTaskByIds(param.tempChoTaskIds);
                            if(temTaskList!=null&& temTaskList.Count > 0)
                            {
                                bool isCopyRes = false;  // 用户是否选择导入项目成员--
                                if (!string.IsNullOrEmpty(param.IsCopyTeamMember))
                                {
                                    isCopyRes = true;
                                }
                                var createTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                var updateTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                var strDal = new sdk_task_resource_dal();
                                temTaskList.ForEach(_ => {
                                    var taskResList = strDal.GetTaskResByTaskId(_.id);

                                    _.id = stDal.GetNextIdCom();
                                    _.oid = 0;
                                    _.project_id = thisProject.id;
                                    _.owner_resource_id = isCopyRes ? _.owner_resource_id : null;
                                    _.create_user_id = user.id;
                                    _.update_user_id = user.id;
                                    _.create_time = createTime;
                                    _.update_time = updateTime;
                                    stDal.Insert(_);
                                    OperLogBLL.OperLogAdd<sdk_task>(_, _.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "从模板导入项目Task");
                                    if(isCopyRes&&taskResList != null&& taskResList.Count > 0)
                                    {
                                        taskResList.ForEach(tr =>
                                        {
                                            tr.id = strDal.GetNextIdCom();
                                            tr.oid = 0;
                                            tr.create_user_id = user.id;
                                            tr.create_time = createTime;
                                            tr.update_time = updateTime;
                                            tr.update_user_id = user.id;
                                            tr.contact_id = null;
                                            tr.task_id = _.id;
                                            strDal.Insert(tr);
                                            OperLogBLL.OperLogAdd<sdk_task_resource>(tr, tr.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "从模板导入任务分配对象");
                                        });
                                    }

                                });
                            }
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
                                camList.ForEach(_ => {
                                    _.id = ppcDal.GetNextIdCom();
                                    _.oid = 0;
                                    _.project_id = thisProject.id;
                                    _.create_time = createTime;
                                    _.create_user_id = user.id;
                                    _.update_time = updateTime;
                                    _.update_user_id = user.id;
                                    ppcDal.Insert(_);
                                    OperLogBLL.OperLogAdd<pro_project_calendar>(_, _.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_CALENDAR, "从模板导入日历条目");
                                });
                            }
                        }
                        // 项目成本
                        if (!string.IsNullOrEmpty(param.IsCopyProjectCharge))
                        {
                            var cccDal = new ctt_contract_cost_dal();
                            var costList = cccDal.GetCostByProId(tempPro.id);
                            if(costList!=null&& costList.Count > 0)
                            {
                                var createTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                var updateTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                costList.ForEach(_=> {
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
                var temp = new sys_notify_tmpl_dal().FindNoDeleteById((long)param.project.template_id);
                if (temp != null)
                {
                    var temp_email_List = new sys_notify_tmpl_email_dal().GetEmailByTempId(temp.id);
                    if(temp_email_List!=null&& temp_email_List.Count > 0)
                    {

                        StringBuilder toEmail = new StringBuilder(); 
                        #region 接受邮件的人的邮箱地址
                        
                        if (!string.IsNullOrEmpty(param.NoToMe))
                        {
                            toEmail.Append(user.email+";"); 
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
                            if(depSouList!=null&& depSouList.Count > 0)
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
                        if(toResList!=null&& toResList.Count > 0)
                        {
                            toResList = toResList.Distinct().ToList();
                            toResList.ForEach(_ => { if (!string.IsNullOrEmpty(_.email)) { toEmail.Append(_.email + ";"); } });
                        }
                        if (!string.IsNullOrEmpty(param.NoToOtherMail))
                        {
                            toEmail.Append(param.NoToOtherMail+';');
                        }
                        var toEmialString = toEmail.ToString();
                        if (!string.IsNullOrEmpty(toEmialString))
                        {
                            toEmialString = toEmialString.Substring(0, toEmialString.Length-1);
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
                            ccEmialString = ccEmialString.Substring(0, toEmialString.Length - 1);
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
                        var norify = new com_notify_email()
                        {
                            id = _dal.GetNextIdCom(),
                            cate_id = (int)NOTIFY_CATE.PROJECT,
                            event_id = (int)DicEnum.NOTIFY_EVENT.PROJECT_CREATED,
                            to_email = (string.IsNullOrEmpty(param.notify.to_email)?"": param.notify.to_email)+toEmialString,
                            cc_email = (string.IsNullOrEmpty(param.notify.cc_email) ? "" : param.notify.cc_email) +ccEmialString,
                            bcc_email = (string.IsNullOrEmpty(param.notify.bcc_email) ? "" : param.notify.bcc_email) + bccEmialString,
                            notify_tmpl_id = temp.id,
                            from_email = user.email,
                            from_email_name = user.name,
                            subject = string.IsNullOrEmpty(param.notify.subject) ? "" : param.notify.subject,
                            body_text = temp_email_List[0].body_text,
                            is_success = (sbyte)(isSuccess ? 1 : 0),
                            is_html_format = 0,
                            create_user_id = user.id,
                            update_user_id = user.id,
                            create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        };
                        new com_notify_email_dal().Insert(norify);
                        OperLogBLL.OperLogAdd<com_notify_email>(norify, norify.id, user.id, OPER_LOG_OBJ_CATE.NOTIFY, "新增项目-添加通知");
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
    }
}
