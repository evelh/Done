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

namespace EMT.DoneNOW.Web.Project
{
    public partial class TaskView : BasePage
    {
        protected sdk_task thisTask = null;
        protected v_task_all v_task = null;
        protected pro_project thisProject = null;
        protected crm_account thisAccount = null;
        protected ctt_contract thisContract = null;
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected List<UserDefinedFieldDto> task_udfList = null;     // task 自定义
        protected List<UserDefinedFieldValue> task_udfValueList = null;
        protected List<sdk_task_resource> thisTaskResList = null;
        protected List<TaskViewDto> tvdList = new List<TaskViewDto>();
        protected List<sdk_expense> taskExpList;
        protected string taskType = "";
        protected string tvbOrder = ""; // 排序方式
        protected string expOrder = ""; // 排序方式
        protected string serOrder = ""; // 排序方式
        protected List<DictionaryEntryDto> tvbDto =new List<DictionaryEntryDto>();
        protected List<DictionaryEntryDto> expDto = new List<DictionaryEntryDto>();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                thisTask = new sdk_task_dal().FindNoDeleteById(long.Parse(id));
                if (thisTask != null&&thisTask.project_id!=null)
                {
                    tvbDto.Add(new DictionaryEntryDto("type", "类型", 0));
                    tvbDto.Add(new DictionaryEntryDto("time", "操作时间", 0));
                    tvbDto.Add(new DictionaryEntryDto("resouName", "员工", 0));
                    tvbDto.Add(new DictionaryEntryDto("workHours", "实际工作时间", 0));
                    tvbDto.Add(new DictionaryEntryDto("notTiltle", "说明/标题", 0));
                    tvbDto.Add(new DictionaryEntryDto("billabled", "是否计费", 0));
                    tvbDto.Add(new DictionaryEntryDto("billed", "已计费", 0));

                    expDto.Add(new DictionaryEntryDto("type_id", "类型", 0));
                    expDto.Add(new DictionaryEntryDto("add_date", "费用日期", 0));
                    expDto.Add(new DictionaryEntryDto("create_user_id", "创建人", 0));
                    expDto.Add(new DictionaryEntryDto("expense_cost_code_id", "费用类别", 0));
                    expDto.Add(new DictionaryEntryDto("amount", "总额", 0));
                    expDto.Add(new DictionaryEntryDto("is_billable", "计费的", 0));
                    expDto.Add(new DictionaryEntryDto("approve_and_post_user_id", "已计费", 0));
                    

                    v_task = new v_task_all_dal().FindById(thisTask.id);
                    if (thisTask.type_id == (int)DicEnum.TASK_TYPE.PROJECT_ISSUE)
                    {
                        taskType = "问题";
                    }
                    else if (thisTask.type_id == (int)DicEnum.TASK_TYPE.PROJECT_TASK)
                    {
                        taskType = "任务";
                    }
                    else
                    {
                        Response.End();
                    }
                    thisProject = new pro_project_dal().FindNoDeleteById((long)thisTask.project_id);
                    if (thisProject != null)
                    {
                        thisAccount = new crm_account_dal().FindNoDeleteById(thisProject.account_id);
                        if (thisProject.contract_id != null)
                        {
                            thisContract = new ctt_contract_dal().FindNoDeleteById((long)thisProject.contract_id);
                        }
                    }
                    thisTaskResList = new sdk_task_resource_dal().GetTaskResByTaskId(thisTask.id);
                    var roleList = dic.FirstOrDefault(_ => _.Key == "role").Value as List<sys_role>;
                    var sysList = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value as List<DictionaryEntryDto>;

                    #region 工时备注附件
                    var tasEntryList = new sdk_work_entry_dal().GetByTaskId(thisTask.id);
                    if (tasEntryList != null && tasEntryList.Count > 0)
                    {
                        
                        var newList = (from a in tasEntryList
                                      join  b in roleList on a.role_id equals b.id
                                      join c in sysList on a.resource_id equals long.Parse(c.val)
                                      select new TaskViewDto {id=a.id,type="entry",time=Tools.Date.DateHelper.ConvertStringToDateTime((long)a.end_time),resouName = c.show+"("+b.name+")", workHours=a.hours_worked,notTiltle = a.summary_notes, billabled = a.is_billable==1?"✓":"",billed = a.approve_and_post_date==null?"": "✓", startDate= Tools.Date.DateHelper.ConvertStringToDateTime((long)a.start_time), workTypeId = a.cost_code_id, contractId = a.contract_id , showOnInv  = a.show_on_invoice==1,serviceId=a.service_id }).ToList();

                        tvdList.AddRange(newList);
                    }
                    var conAttDal = new com_attachment_dal();
                    var allTaskAttList = new List<com_attachment>();
                    var taskNoteList = new com_activity_dal().GetActiList($" and (task_id ={thisTask.id} or object_id={thisTask.id} )");
                    if (taskNoteList != null && taskNoteList.Count > 0)
                    {
                        var newList = (from a in taskNoteList
                                      join c in sysList on a.resource_id equals long.Parse(c.val) into temp
                                       from tt in temp.DefaultIfEmpty()
                                       select new TaskViewDto { id = a.id, type = "note", time = Tools.Date.DateHelper.ConvertStringToDateTime(a.create_time), resouName = tt == null ? "" : tt.show, notTiltle = a.name, noteDescr  = a.description}).ToList();
                        tvdList.AddRange(newList);

                        foreach (var thisTaskNote in taskNoteList)
                        {
                            var thisNoteAttList = conAttDal.GetAttListByOid(thisTaskNote.id);
                            if(thisNoteAttList!=null&& thisNoteAttList.Count > 0)
                            {
                                allTaskAttList.AddRange(thisNoteAttList);
                            }
                        }
                    }
                    var taskAttList = conAttDal.GetAttListByOid(thisTask.id);
                    if(taskAttList!=null&& taskAttList.Count > 0)
                    {
                        allTaskAttList.AddRange(taskAttList);
                     
                    }
                    if (allTaskAttList.Count > 0)
                    {
                        var newList = (from a in allTaskAttList
                                       join c in sysList on a.create_user_id equals long.Parse(c.val) into temp
                                       from tt in temp.DefaultIfEmpty()
                                       select new TaskViewDto { id = a.id, type = "atach", time = Tools.Date.DateHelper.ConvertStringToDateTime(a.create_time), resouName = tt==null?"":tt.show, notTiltle = a.title, fileType = a.type_id }).ToList();
                        tvdList.AddRange(newList);
                    }
                    if(tvdList!=null&& tvdList.Count > 0)
                    {
                        tvbOrder = Request.QueryString["tvbOrder"];
                        tvdList = tvdList.OrderBy(_ => _.time).ToList();
                        if (!string.IsNullOrEmpty(tvbOrder))
                        {
                            var tvbOrderArr = tvbOrder.Split(new char[] { '_' }, StringSplitOptions.RemoveEmptyEntries);
                            var orderFile = tvbDto.FirstOrDefault(_ => _.val == tvbOrderArr[0]);
                            if (tvbOrderArr[1] == "desc")
                            {
                                
                                //tvdList = (from a in tvdList 
                                //           orderby tvbOrderArr[0]  descending
                                //           select a).ToList();
                                tvdList.Sort(delegate (TaskViewDto t1, TaskViewDto t2) {
                                    return GetObjectPropertyValue(t2, tvbOrderArr[0]).CompareTo(GetObjectPropertyValue(t1, tvbOrderArr[0]));
                                });
                                orderFile.select = orderFile != null ? 2 : orderFile.select;
                            }
                            else
                            {
                                //tvdList = (from a in tvdList
                                //           orderby tvbOrderArr[0] 
                                //           select a).ToList();
                                tvdList.Sort(delegate (TaskViewDto t1, TaskViewDto t2) {
                                    return GetObjectPropertyValue(t1, tvbOrderArr[0]).CompareTo(GetObjectPropertyValue(t2, tvbOrderArr[0]));
                                });
                                orderFile.select = orderFile != null ? 1 : orderFile.select;
                            }
                        }
                    }
                    #endregion

                    #region 费用
                    taskExpList = new sdk_expense_dal().GetExpByTaskId(thisTask.id);
                    if(taskExpList!=null&& taskExpList.Count > 0)
                    {
                        taskExpList = taskExpList.OrderByDescending(_ => _.add_date).ToList();
                        expOrder = Request.QueryString["expOrder"];
                        if (!string.IsNullOrEmpty(expOrder))
                        {
                            var expOrderArr = expOrder.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                            var orderFile = expDto.FirstOrDefault(_ => _.val == expOrderArr[0]);
                            if (expOrderArr[1] == "desc")
                            {
                                //taskExpList = (from a in taskExpList
                                //           orderby expOrderArr[0] descending
                                //           select a).ToList();
                                taskExpList.Sort(delegate (sdk_expense t1, sdk_expense t2) {
                                    return GetObjectPropertyValue(t2, expOrderArr[0]).CompareTo(GetObjectPropertyValue(t1, expOrderArr[0]));
                                });
                                orderFile.select = orderFile != null ? 2 : orderFile.select;
                            }
                            else
                            {
                                //taskExpList = (from a in taskExpList
                                //           orderby expOrderArr[0]
                                //           select a).ToList();
                                taskExpList.Sort(delegate (sdk_expense t1, sdk_expense t2) {
                                    return GetObjectPropertyValue(t1, expOrderArr[0]).CompareTo(GetObjectPropertyValue(t2, expOrderArr[0]));
                                });

                                orderFile.select = orderFile != null ? 1 : orderFile.select;
                            }

                        }
                    }
                    #endregion
                }
                else
                {
                    Response.End();
                }
                
            }
            catch (Exception msg)
            {
                Response.End();
            }
        }
        public string GetObjectPropertyValue<T1>(T1 t, string filesname)
        {
            // T模板类型
            Type type = typeof(T1);
            // 获得属性
            System.Reflection.FieldInfo file = type.GetField(filesname);
            // 属性非空判断
            if (file == null) return string.Empty;
            // 获取Value
            object o = file.GetValue(t);
            // Value非空判断
            if (o == null) return string.Empty;
            // 返回Value
            return o.ToString();
        }

    }

  
    public class TaskViewDto
    {
        public long id;
        public string type;
        public DateTime time;
        public string resouName;
        public decimal? workHours;
        public string notTiltle;
        public string billabled;  // 工时使用，其余为空。是否计费  is_billable
        public string billed;     // 工时使用，其余为空。已计费   通过审批并提交判断
        public int fileType;
        public DateTime startDate;// 工时使用
        public DateTime endDate;  // 工时使用
        public long? workTypeId;  // 工时使用
        public long? contractId;  // 工时使用
        public long? serviceId;   // 服务，服务包ID
        public bool showOnInv;    // 在发票上显示，工时使用

        public string noteDescr;  // 描述  - 备注使用
    }
}