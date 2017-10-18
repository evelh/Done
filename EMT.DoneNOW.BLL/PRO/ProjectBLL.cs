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
                thisProject.status_id = (int)PROJECT_STATUS.NEW;
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

                #region 3.项目团队处理
                var pptDal = new pro_project_team_dal();
                
                if (!string.IsNullOrEmpty(param.resouIds))
                {
                    var resouIdList = param.resouIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (resouIdList != null && resouIdList.Count() > 0)
                    {
                        var srdDal = new sys_resource_department_dal();
                        var pptrDal = new pro_project_team_role_dal();
                        foreach (var resouId in resouIdList)
                        {
                            var roleList = srdDal.GetRolesBySource(long.Parse(resouId), DEPARTMENT_CATE.DEPARTMENT);
                            if (roleList != null && roleList.Count > 0)
                            {
                                var item = new pro_project_team() {
                                    id= pptDal.GetNextIdCom(),
                                    project_id = thisProject.id,
                                    resource_id = long.Parse(resouId),
                                    resource_daily_hours = param.resource_daily_hours,
                                    create_user_id = user.id,
                                    update_user_id = user.id,
                                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                };
                                pptDal.Insert(item);
                                OperLogBLL.OperLogAdd<pro_project_team>(item, item.id, user.id, OPER_LOG_OBJ_CATE.PROJECT_ITEM, "新增项目团队-添加员工");
                                foreach (var role in roleList)
                                {
                                    var item_role = new pro_project_team_role() {
                                        id= pptrDal.GetNextIdCom(),
                                        project_team_id = item.id,
                                        role_id = role.id,
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
                                resource_daily_hours = param.resource_daily_hours,
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
                var temp = new sys_notify_tmpl_email_dal().FindNoDeleteById(param.noti_temp_id);
                if (temp != null)
                {
                    bool isSuccess = false; // todo 发送邮件
                    var norify = new com_notify_email()
                    {
                        id = _dal.GetNextIdCom(),
                        cate_id = (int)NOTIFY_CATE.PROJECT,
                        event_id = (int)DicEnum.NOTIFY_EVENT.PROJECT_CREATED,
                        to_email = param.notify.to_email,
                        cc_email = param.notify.cc_email,
                        bcc_email = param.notify.bcc_email,
                        notify_tmpl_id = temp.id,
                        from_email = user.email,
                        from_email_name = user.name,
                        subject = param.notify.subject,
                        body_text = temp.body_text,
                        is_success = (sbyte)(isSuccess ? 1:0),
                        is_html_format = 0,
                        create_user_id = user.id,
                        update_user_id = user.id,
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    };
                    new com_notify_email_dal().Insert(norify);
                    OperLogBLL.OperLogAdd<com_notify_email>(norify, norify.id, user.id, OPER_LOG_OBJ_CATE.NOTIFY, "新增项目-添加通知");
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
