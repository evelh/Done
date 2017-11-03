﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using System.Text;

namespace EMT.DoneNOW.Web.Project
{
    public partial class TaskAddOrEdit : BasePage
    {
        protected pro_project thisProject = null;
        protected sdk_task thisTask = null;
        protected bool isAdd = true;
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected pro_project_dal ppdal = new pro_project_dal();
        protected sdk_task_dal sdDal = new sdk_task_dal();
        protected int type_id;                            // task 的类型
        protected List<sdk_task> taskList = null;         // 该项目的task集合 用于任务的前驱任务的选择
        protected sdk_task parTask = null;                // 通过taskId进行新增
        protected List<UserDefinedFieldDto> task_udfList = null;     // task 自定义
        protected List<UserDefinedFieldValue> task_udfValueList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    ThisPageDataBind();
                }
                task_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TASK);
                var project_id = Request.QueryString["project_id"];
                if (!string.IsNullOrEmpty(project_id))
                {
                    thisProject = ppdal.FindNoDeleteById(long.Parse(project_id));
                }
                var parTaskId = Request.QueryString["par_task_id"];
                if (!string.IsNullOrEmpty(parTaskId))
                {
                    parTask = sdDal.FindNoDeleteById(long.Parse(parTaskId));
                    if (parTask != null)
                    {
                        if (parTask.project_id != null)
                        {
                            thisProject = ppdal.FindNoDeleteById((long)parTask.project_id);
                        }
                        
                    }
                }

                var typeString = Request.QueryString["type_id"];
                if (!string.IsNullOrEmpty(typeString))
                {
                    type_id = int.Parse(typeString);
                    if (!IsPostBack)
                    {
                        switch (type_id)
                        {
                            case (int)DicEnum.TASK_TYPE.PROJECT_ISSUE:
                                isProject_issue.Checked = true;
                                break;
                            case (int)DicEnum.TASK_TYPE.PROJECT_TASK:
                                isProject_issue.Checked = false;
                                break;
                            default:
                                break;
                        }
                    }
                   
                }
                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisTask = sdDal.FindNoDeleteById(long.Parse(id));
                    if (thisTask != null)
                    {
                        type_id = thisTask.type_id;
                        isAdd = false;
                        if (thisTask.project_id != null)
                        {
                            thisProject = ppdal.FindNoDeleteById((long)thisTask.project_id);
                        }
                        task_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.TASK, thisTask.id, task_udfList);
                        if (!IsPostBack)
                        {
                            status_id.SelectedValue = thisTask.status_id.ToString();
                            if (thisTask.is_visible_in_client_portal == 0)
                            {
                                DisplayInCapNone.Checked = true;
                            }
                            else
                            {
                                if (thisTask.can_client_portal_user_complete_task == 1)
                                {
                                    DisplayInCapYes.Checked = true;
                                }
                                else
                                {
                                    DisplayInCapYesNoComplete.Checked = true;
                                }
                            }

                            if (thisTask.is_project_issue == 1)
                            {
                                isProject_issue.Checked = true;
                            }
                            else
                            {
                                isProject_issue.Checked = false;
                            }

                            if(thisTask.estimated_type_id == (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXWORK)
                            {
                                TaskTypeFixedWork.Checked = true;
                            }
                            else if(thisTask.estimated_type_id == (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXDURATION)
                            {
                                TaskTypeFixedDuration.Checked = true;
                            }
                            else
                            {

                            }

                            department_id.SelectedValue = thisTask.department_id == null ? "0" : ((int)thisTask.department_id).ToString();
                        }
                    }
                }

                if (thisProject == null)
                {
                    Response.End();
                }



            }
            catch (Exception msg)
            {
                Response.End();
            }
        }

        public void ThisPageDataBind()
        {
            status_id.DataTextField = "show";
            status_id.DataValueField = "val";
            status_id.DataSource = dic.FirstOrDefault(_ => _.Key == "ticket_status").Value;
            status_id.DataBind();
            // status_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            department_id.DataTextField = "name";
            department_id.DataValueField = "id";
            department_id.DataSource = dic.FirstOrDefault(_ => _.Key == "department").Value;
            department_id.DataBind();
            department_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            DisplayInCapYesNoComplete.Checked = true;
            TaskTypeFixedWork.Checked = true;
        }

        protected void save_Click(object sender, EventArgs e)
        {
            var result = SaveTask();
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var result = SaveTask();

        }

        protected void save_view_Click(object sender, EventArgs e)
        {
            var result = SaveTask();
        }

        protected void save_add_Click(object sender, EventArgs e)
        {
            var result = SaveTask();
        }

        protected void save2_Click(object sender, EventArgs e)
        {
            var result = SaveTask();
        }

        /// <summary>
        /// 保存Task相关操作
        /// </summary>
        private bool SaveTask()
        {
            bool result = false;
            var param = GetParam();
            if (isAdd)
            {
                result = new TaskBLL().AddTask(param,GetLoginUserId());
            }

            return false;
        }
        /// <summary>
        /// 获取相应参数
        /// </summary>
        private TaskSaveDto GetParam()
        {
            TaskSaveDto param = AssembleModel<TaskSaveDto>();
            param.resDepIds = Request.Form["resDepList"];     // 员工角色 Id 
            param.contactIds = Request.Form["conIds"];        // 联系人 ID
            var preTaskIds = Request.Form["preIds"];    // 前驱任务IDs
            if (!string.IsNullOrEmpty(preTaskIds))
            {
                var preTasArr = preTaskIds.Split(new char[] { ','},StringSplitOptions.RemoveEmptyEntries);
                Dictionary<long, int> predic = new Dictionary<long, int>();
                foreach (var preTasId in preTasArr)
                {
                    var layDays = Request.Form[preTasId + "_lagDays"];
                    if((!string.IsNullOrEmpty(layDays))&& (!string.IsNullOrWhiteSpace(layDays)))
                    {
                        predic.Add(long.Parse(preTasId),int.Parse(layDays));
                    }
                }
                param.predic = predic;
            }
            var pageTask = AssembleModel<sdk_task>();
            pageTask.is_visible_in_client_portal = (sbyte)(DisplayInCapNone.Checked ? 1 : 0);
            pageTask.can_client_portal_user_complete_task = (sbyte)(DisplayInCapYes.Checked ? 1 : 0);
            if (TaskTypeFixedWork.Checked)
            {
                pageTask.estimated_type_id = (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXWORK;
            }
            else if (TaskTypeFixedDuration.Checked)
            {
                pageTask.estimated_type_id = (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXDURATION;
            }

            var startString = Request.Form["estimated_beginTime"];
            if (!string.IsNullOrEmpty(startString))
            {
                pageTask.estimated_begin_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(startString));
            }
            if (isAdd)
            {
                param.task = pageTask;
                param.task.type_id = type_id;
                param.task.project_id = thisProject.id;
                if(parTask != null)
                {
                    param.task.parent_id = parTask.id;
                }
                
            }
            else
            {

            }

            if (task_udfList != null && task_udfList.Count > 0)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in task_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = string.IsNullOrEmpty(Request.Form[udf.id.ToString()]) ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.udf = list;
            }



            return param;
        }

        protected void save_close2_Click(object sender, EventArgs e)
        {
            var result = SaveTask();
        }
    }
}