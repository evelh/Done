using System;
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
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.Project
{
    public partial class TaskEdit : BasePage
    {
        protected string[] idList;  // 传进来的task集合
        protected List<sdk_task> taskList = new List<sdk_task>();
        protected pro_project thisProject;
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected string titleValue;           // 标题 在页面上显示的值           
        protected int statuValue;              // 状态在页面上显示的值
        protected int? priorityValue;            // 优先级在页面上显示的值
        protected string displayWayValue;      // 显示方式 在页面上显示的值
        protected string fixTypeValue;         //  在页面上显示的值
        protected decimal? estHoursValue;       //  在页面上显示的值
        protected long? depValue = null;                //  部门在页面上显示的值
        protected int workTypeValue;           // 工作类型在页面上显示的值
        protected long? priResValue;             // 主要负责人 在页面上显示的值
        protected List<UserDefinedFieldDto> udfTaskPara =  new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TASK);
        protected List<UserDefinedFieldValue> udfValue = null;
        protected UserDefinedFieldsBLL udfBLL = new UserDefinedFieldsBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            // 批量修改 
            // 1。多个任务 2.单个任务 
            try
            {
                var stDal = new sdk_task_dal();
                var ppDal = new pro_project_dal();
                var ids = Request.QueryString["taskIds"];
                if (!string.IsNullOrEmpty(ids))
                {
                    idList = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (idList.Count() == 1)
                    {
                        var thisTask = stDal.FindNoDeleteById(long.Parse(idList[0]));
                        if (thisTask != null)
                        {
                            if (!IsPostBack)
                            {
                                thisProject = ppDal.FindNoDeleteById((long)thisTask.project_id);
                                titleValue = thisTask.title;
                                statuValue = thisTask.status_id;
                                priorityValue = thisTask.priority;
                                estHoursValue = thisTask.estimated_hours;
                                depValue = thisTask.department_id;
                                // workTypeValue = thisTask.
                                priResValue = thisTask.owner_resource_id;
                                if (thisTask.is_visible_in_client_portal == 1)
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
                                else
                                {
                                    DisplayInCapNone.Checked = true;
                                }
                            }
                            udfValue = new UserDefinedFieldsBLL().GetUdfValue(UDF_CATE.TASK,thisTask.id, udfTaskPara);
                            taskList.Add(thisTask);
                        }
                    }
                    else if (idList.Count() > 1)
                    {
                        taskList = stDal.GetTaskByIds(ids, $" and type_id in ({(int)DicEnum.TASK_TYPE.PROJECT_TASK},{(int)DicEnum.TASK_TYPE.PROJECT_ISSUE})");
                        if (taskList != null && taskList.Count > 0)
                        {
                            
                            thisProject = ppDal.FindNoDeleteById((long)taskList[0].project_id);
                            var firstTask = taskList[0];
                            taskList.Remove(firstTask);
                            if (!IsPostBack)
                            {
                                udfValue = udfBLL.GetUdfValue(UDF_CATE.TASK, firstTask.id, udfTaskPara);

                                if(udfTaskPara!=null&& udfTaskPara.Count > 0)
                                {
                                    foreach (var udfTask in udfTaskPara)
                                    {
                                        var thisValue = udfValue.FirstOrDefault(_ => _.id == udfTask.id).value;
                                        var count = udfBLL.GetSameValueCount(UDF_CATE.TASK, ids,udfTask.col_name,thisValue.ToString());
                                        if (count > 1)
                                        {
                                            udfValue.FirstOrDefault(_ => _.id == udfTask.id).value = "多个值-保持不变";
                                        }
                                        else
                                        {

                                        }
                                    }
                                }

                                if (taskList.Any(_ => _.title != firstTask.title))
                                {
                                    titleValue = "多个值-保持不变";
                                }
                                else
                                {
                                    titleValue = firstTask.title;
                                }
                                if (taskList.Any(_ => _.status_id != firstTask.status_id))
                                {
                                    statuValue = 0;
                                }
                                else
                                {
                                    statuValue = firstTask.status_id;
                                }
                                if (taskList.Any(_ => _.priority != firstTask.priority))
                                {
                                    priorityValue = null;
                                }
                                else
                                {
                                    priorityValue = firstTask.priority;
                                }
                                #region 在页面上的显示设置
                                if (firstTask.is_visible_in_client_portal == 1)
                                {
                                    if (taskList.Any(_ => _.is_visible_in_client_portal != firstTask.is_visible_in_client_portal))
                                    {
                                        displayWayValue = "1";
                                    }
                                    else
                                    {
                                        if (firstTask.can_client_portal_user_complete_task == 1)
                                        {
                                            if (taskList.Any(_ => _.can_client_portal_user_complete_task != firstTask.can_client_portal_user_complete_task))
                                            {
                                                displayWayValue = "1";
                                            }
                                            else
                                            {
                                                DisplayInCapYes.Checked = true;
                                            }
                                        }
                                        else
                                        {
                                            if (taskList.Any(_ => _.can_client_portal_user_complete_task != firstTask.can_client_portal_user_complete_task))
                                            {
                                                displayWayValue = "1";
                                            }
                                            else
                                            {
                                                DisplayInCapYesNoComplete.Checked = true;
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    if (taskList.Any(_ => _.is_visible_in_client_portal != firstTask.is_visible_in_client_portal))
                                    {
                                        displayWayValue = "1";
                                    }
                                    else
                                    {
                                        DisplayInCapNone.Checked = true;
                                    }
                                }
                                if (!string.IsNullOrEmpty(displayWayValue))
                                {
                                    noChange.Checked = true;
                                }

                                #endregion

                                #region 固定工作，固定时间的设置
                                if (taskList.Any(_ => _.estimated_type_id != firstTask.estimated_type_id))
                                {
                                    fixTypeValue = "1";
                                    typeNoChange.Checked = true;
                                }
                                else
                                {
                                    if (firstTask.estimated_type_id == (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXWORK)
                                    {
                                        TaskTypeFixedWork.Checked = true;
                                    }
                                    else if (firstTask.estimated_type_id == (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXDURATION)
                                    {
                                        TaskTypeFixedDuration.Checked = true;
                                    }
                                }
                                #endregion

                                if (taskList.Any(_ => _.estimated_hours != firstTask.estimated_hours))
                                {
                                    estHoursValue = null;
                                }
                                else
                                {
                                    estHoursValue = firstTask.estimated_hours;
                                }
                                if (taskList.Any(_ => _.department_id != firstTask.department_id))
                                {
                                    depValue = null;
                                }
                                else
                                {
                                    depValue = firstTask.department_id;
                                }

                                if (taskList.Any(_ => _.owner_resource_id != firstTask.owner_resource_id))
                                {
                                    priResValue = 0;
                                }
                                else
                                {
                                    priResValue = firstTask.owner_resource_id;
                                }
                            }
                        }
                    }

                    if (!IsPostBack)
                    {
                        ThisPageDataBind();
                    }


                    if (statuValue == 0)
                    {
                        status_id.Items.Insert(0, new ListItem() { Value = "0", Text = "多个选择-保持不变", Selected = true });
                    }
                    else
                    {
                        status_id.SelectedValue = statuValue.ToString();
                    }
                    if (depValue == null)
                    {
                        department_id.ClearSelection();
                        department_id.Items.Insert(0, new ListItem() { Value = "0", Text = "多个选择-保持不变", Selected = true });
                    }
                    else
                    {
                        department_id.ClearSelection();
                        department_id.SelectedValue = depValue.ToString();
                    }

                

                }
                else
                {
                    Response.End();
                }
            }
            catch (Exception)
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



            department_id.DataTextField = "name";
            department_id.DataValueField = "id";
            department_id.DataSource = dic.FirstOrDefault(_ => _.Key == "department").Value;
            department_id.DataBind();
            department_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });


        }

        protected void save_Click(object sender, EventArgs e)
        {
            var stDal = new sdk_task_dal();
            var ids = Request.QueryString["taskIds"];
            var thisTaskList = stDal.GetTaskByIds(ids, $" and type_id in ({(int)DicEnum.TASK_TYPE.PROJECT_TASK},{(int)DicEnum.TASK_TYPE.PROJECT_ISSUE})");
            if(thisTaskList != null&& thisTaskList.Count > 0)
            {
                var pageTitle = Request.Form["title"];
                var pageStatu = Request.Form["status_id"];
                var pagePriority = Request.Form["priority"];
                var displayIsChange = noChange.Checked;
                var pageEstimated_hours = Request.Form["estimated_hours"];
                var pageDepa = Request.Form["department_id"];
                var pageRes = Request.Form["owner_resource_id"];
                var user = UserInfoBLL.GetUserInfo(GetLoginUserId());
                var ctaDal = new v_task_all_dal();
                foreach (var thisTask in thisTaskList)
                {
                    if (pageTitle != "多个值-保持不变")
                    {
                        if (!string.IsNullOrEmpty(pageTitle))
                        {
                            thisTask.title = pageTitle;
                        }
                    }
                    if (pageStatu != "0")
                    {
                        thisTask.status_id = int.Parse(pageStatu);
                    }
                    if (!string.IsNullOrEmpty(pagePriority))
                    {
                        thisTask.priority = int.Parse(pagePriority);
                    }
                    if (!displayIsChange)  // 代表页面上选择进行更改
                    {
                        if (DisplayInCapNone.Checked)
                        {
                            thisTask.is_visible_in_client_portal = 0;
                        }
                        else
                        {
                            thisTask.is_visible_in_client_portal = 1;
                            if (DisplayInCapYes.Checked)
                            {
                                thisTask.can_client_portal_user_complete_task = 1;
                            }else if (DisplayInCapYesNoComplete.Checked)
                            {
                                thisTask.can_client_portal_user_complete_task = 0;
                            }
                        }
                    }
                    if (!typeNoChange.Checked)
                    {
                        if (TaskTypeFixedWork.Checked)
                        {
                            thisTask.estimated_type_id = (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXWORK;
                        }
                        else if (TaskTypeFixedDuration.Checked)
                        {
                            thisTask.estimated_type_id = (int)DicEnum.TIME_ENTRY_METHOD_TYPE.FIXDURATION;
                        }
                    }
                    if (!string.IsNullOrEmpty(pageEstimated_hours))
                    {
                        thisTask.estimated_hours = decimal.Parse(pageEstimated_hours);
                        var vTask = ctaDal.FindById(thisTask.id);
                        if (vTask != null)
                        {
                            thisTask.projected_variance = (vTask.worked_hours == null ? 0 : (decimal)vTask.worked_hours) - (thisTask.estimated_hours + (vTask.change_Order_Hours == null ? 0 : (decimal)vTask.change_Order_Hours)) + (vTask.remain_hours == null ? 0 : (decimal)vTask.remain_hours);
                        }
                    }
                    if (pageDepa != "0")
                    {
                        if (!string.IsNullOrEmpty(pageDepa))
                        {
                            thisTask.department_id = int.Parse(pageDepa);
                        }
                        else
                        {
                            thisTask.department_id = null;
                        }
                    }
                    if (pageRes != "0")
                    {
                        if (!string.IsNullOrEmpty(pageRes))
                        {
                            thisTask.owner_resource_id = long.Parse(pageRes);
                        }
                        else
                        {
                            thisTask.owner_resource_id = null;
                        }
                    }
                    OperLogBLL.OperLogUpdate<sdk_task>(thisTask, stDal.FindNoDeleteById(thisTask.id), thisTask.id, GetLoginUserId(), OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改task");
                    stDal.Update(thisTask);
                    var thisUdfValue =  udfBLL.GetUdfValue(UDF_CATE.TASK, thisTask.id, udfTaskPara);
                    if (udfTaskPara != null && udfTaskPara.Count > 0)                      // 首先判断是否有自定义信息
                    {
                        var list = new List<UserDefinedFieldValue>();
                        foreach (var udf in udfTaskPara)                            // 循环添加
                        {
                            var new_udf = new UserDefinedFieldValue();
                            // if(udf.data_type != (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST) // todo,根据类型去取值
                            new_udf.id = udf.id;
                            var thisvv = Request.Form[udf.id.ToString()];
                            if(thisvv== "多个值-保持不变")
                            {
                                new_udf.value = thisUdfValue.FirstOrDefault(_ => _.id == udf.id).value;
                            }
                            else
                            {
                                new_udf.value = thisvv == "" ? null : thisvv; 
                            }
                            
                            
                            list.Add(new_udf);

                        }
                        udfBLL.UpdateUdfValue(UDF_CATE.TASK, udfTaskPara, thisTask.id, list, user, OPER_LOG_OBJ_CATE.PROJECT_TASK);
                    }

                }
            }
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
        }
    }
}