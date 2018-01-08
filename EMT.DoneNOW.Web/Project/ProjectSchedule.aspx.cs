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
    public partial class ProjectSchedule : BasePage
    {
        protected pro_project thisProject = null;
        protected List<sdk_task> taskList = null;
        protected bool isTransTemp = false;         // 判断是否进入转换模板页面
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        private QueryCommonBLL bll = new QueryCommonBLL();
        protected int catId = 0;
        //protected string queryPage;     // 查询页名称
        protected long queryTypeId;     // 查询页id
        protected long paraGroupId;     // 查询条件分组id
        protected string addBtn;        // 根据不同查询页得到的新增按钮名
        protected QueryResultDto queryResult = null;            // 查询结果数据
        protected List<QueryResultParaDto> resultPara = null;   // 查询结果列信息
        protected List<PageContextMenuDto> contextMenu = null;  // 右键菜单信息
        protected List<DictionaryEntryDto> queryParaValue = new List<DictionaryEntryDto>();  // 查询条件和条件值
        protected int tableWidth = 1200;
        protected long objId = 0;
        protected sdk_task_dal stDal = new sdk_task_dal();
        protected TaskBLL tBll = new TaskBLL();
        protected string pageShowType = "";     // 页面过滤数据类型 --默认展示全部的数据（过滤阶段，完成等信息）
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["project_id"];
                thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                if (thisProject != null)
                {
                    pageShowType = Request.QueryString["pageShowType"];
                    taskList = new sdk_task_dal().GetProjectTask(thisProject.id);
                    var isTran = Request.QueryString["isTranTemp"];
                    if ((!string.IsNullOrEmpty(isTran))) //thisProject.type_id != (int)DicEnum.PROJECT_TYPE.TEMP &&
                    {
                        isTransTemp = true;
                    }
                    if (!IsPostBack)
                    {
                        var tempList = new pro_project_dal().GetTempList();
                        // 项目模板  --project_temp
                        if (tempList != null && tempList.Count > 0)
                        {
                            project_temp.DataTextField = "name";
                            project_temp.DataValueField = "id";
                            project_temp.DataSource = tempList;
                            project_temp.DataBind();
                        }

                        organization_location_id.DataTextField = "name";
                        organization_location_id.DataValueField = "id";
                        organization_location_id.DataSource = dic.FirstOrDefault(_ => _.Key == "org_location").Value;
                        organization_location_id.DataBind();

                        useResource_daily_hours.Checked = thisProject.use_resource_daily_hours == 1;
                        excludeWeekend.Checked = thisProject.exclude_weekend == 1;
                        excludeHoliday.Checked = thisProject.exclude_holiday == 1;
                        warnTime_off.Checked = thisProject.warn_time_off == 1;
                    }

                    //  if (!int.TryParse(Request.QueryString["cat"], out catId))
                    var catIdString = Request.QueryString["CatID"];
                    if (string.IsNullOrEmpty(catIdString))
                    {
                        catId = (int)DicEnum.QUERY_CATE.PROJECT_TASK;
                    }
                    else
                    {
                        catId = int.Parse(catIdString);
                    }

                    // if (!long.TryParse(Request.QueryString["type"], out queryTypeId))

                    var queryTypeIdString = Request.QueryString["QeryTypeId"];
                    if (string.IsNullOrEmpty(queryTypeIdString))
                    {
                        queryTypeId = (int)QueryType.PROJECT_TASK;
                        //queryTypeId = (int)QueryType.PROJECT_PHASE;
                    }
                    else
                    {
                        queryTypeId = int.Parse(queryTypeIdString);
                    }


                    if (catId == 0 || queryTypeId == 0)
                    {
                        Response.Close();
                        return;
                    }
                    // 一个query_type下只有一个group时可以不传参gruop_id
                    if (paraGroupId == 0)
                    {
                        var groups = bll.GetQueryGroup(catId);
                        foreach (var g in groups)
                        {
                            if (g.query_type_id == queryTypeId)
                            {
                                if (paraGroupId != 0)   // 一个query_type下有多个group，不能判断使用哪个
                                {
                                    Response.Close();
                                    return;
                                }
                                paraGroupId = g.id;
                            }
                        }
                    }
                    // if (!long.TryParse(Request.QueryString["id"], out objId))
                    objId = thisProject.id;
                    QueryData();
                    CalcTableWidth();

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

        private void QueryData()
        {
            queryParaValue.Clear();
            resultPara = bll.GetResultParaSelect(GetLoginUserId(), paraGroupId);    // 获取查询结果列信息

            //var keys = Request.Form;
            var keys = HttpContext.Current.Request.QueryString;
            string order = keys["order"];   // order by 条件
            int page;
            if (!int.TryParse(keys["page_num"], out page))
                page = 1;
            //int page = string.IsNullOrEmpty(keys["page_num"]) ? 1 : int.Parse(keys["page_num"]);  // 查询页数
            int pageSize = string.IsNullOrEmpty(keys["page_size"]) ? 0 : int.Parse(keys["page_size"]);  // 查询每页个数

            // 检查order
            if (order != null)
            {
                order = order.Trim();
                string[] strs = order.Split(' ');
                if (strs.Length != 2 || (!strs[1].ToLower().Equals("asc") && !strs[1].ToLower().Equals("desc")))
                    order = "";
            }
            if (string.IsNullOrEmpty(order))
                order = null;

            if (!string.IsNullOrEmpty(keys["search_id"]))   // 使用缓存查询条件
            {
                queryResult = bll.GetResult(GetLoginUserId(), keys["search_id"], page, order);
                return;
            }

            if (objId != 0)    // 查询条件只有实体id，可以默认带入id查找
            {
                var cdts = bll.GetConditionParaVisiable(GetLoginUserId(), paraGroupId);
                if (cdts.Count == 1)
                {
                    QueryParaDto queryPara = new QueryParaDto();
                    queryPara.query_params = new List<Para>();
                    Para pa = new Para();
                    // 975
                    pa.id = cdts[0].id;
                    pa.value = objId.ToString();
                    queryPara.query_params.Add(pa);
                    queryPara.query_type_id = queryTypeId;
                    queryPara.para_group_id = paraGroupId;
                    queryPara.page = page;
                    queryPara.order_by = order;
                    queryPara.page_size = pageSize;

                    queryResult = bll.GetResult(GetLoginUserId(), queryPara);
                    return;
                }
            }

            if (queryResult == null)  // 不使用缓存或缓存过期
            {
                var para = bll.GetConditionParaVisiable(GetLoginUserId(), paraGroupId);   // 查询条件信息
                QueryParaDto queryPara = new QueryParaDto();
                queryPara.query_params = new List<Para>();
                foreach (var p in para)
                {
                    Para pa = new Para();
                    if (p.data_type == (int)DicEnum.QUERY_PARA_TYPE.NUMBER
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.DATE
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.DATETIME
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.TIMESPAN)    // 数值和日期类型是范围值
                    {
                        string ql = keys["con" + p.id.ToString() + "_l"];
                        string qh = keys["con" + p.id.ToString() + "_h"];
                        if (string.IsNullOrEmpty(ql) && string.IsNullOrEmpty(qh))   // 空值，跳过
                            continue;
                        if (!string.IsNullOrEmpty(ql))
                        {
                            queryParaValue.Add(new DictionaryEntryDto("con" + p.id.ToString() + "_l", ql));     // 记录查询条件和条件值
                            pa.value = ql;
                        }
                        if (!string.IsNullOrEmpty(qh))
                        {
                            queryParaValue.Add(new DictionaryEntryDto("con" + p.id.ToString() + "_h", qh));     // 记录查询条件和条件值
                            pa.value2 = qh;
                        }
                        pa.id = p.id;

                        queryPara.query_params.Add(pa);
                    }
                    else    // 其他类型一个值
                    {
                        string val = keys["con" + p.id.ToString()];
                        if (string.IsNullOrEmpty(val))
                            continue;
                        pa.id = p.id;
                        pa.value = val;
                        queryParaValue.Add(new DictionaryEntryDto("con" + p.id.ToString(), val));     // 记录查询条件和条件值

                        queryPara.query_params.Add(pa);
                    }
                }
                if (queryTypeId == (int)QueryType.PROJECT_BASELINE)
                {
                    if (thisProject.baseline_project_id != null)
                    {
                        Para pa = new Para();
                        pa.id = 975;
                        pa.value = thisProject.baseline_project_id.ToString();
                    }
                }
                queryPara.query_type_id = queryTypeId;
                queryPara.para_group_id = paraGroupId;
                queryPara.page = page;
                queryPara.order_by = order;
                queryPara.page_size = pageSize;

                queryResult = bll.GetResult(GetLoginUserId(), queryPara);
            }
        }
        private void CalcTableWidth()
        {
            if (resultPara == null)
                return;

            int charCnt = 0;
            foreach (var p in resultPara)
            {
                if (p.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                    || p.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE
                    || p.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP)
                    continue;

                charCnt += p.length;
            }
            tableWidth = charCnt * 16;
        }
        /// <summary>
        /// 判断是否有子task 决定页面上是否可折叠
        /// </summary>
        protected bool IsHasSubTask(long taskId)
        {
            var result = false;
            var subList = stDal.GetTaskByParentId(taskId);
            if (subList != null && subList.Count > 0)
            {
                switch (pageShowType)
                {
                    case "phase":  // 只显示阶段
                        var phaseList = subList.Where(_ => _.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE).ToList();
                        if (phaseList != null && phaseList.Count > 0)
                        {
                            result = true;
                        }
                        break;
                    case "TaskComplete": // w完成的task
                        var taskComList = subList.Where(_ => _.status_id == (int)DicEnum.TICKET_STATUS.DONE).ToList();
                        if (taskComList != null && taskComList.Count > 0)
                        {
                            result = true;
                        }
                        break;
                    case "TaskNoComplete": // 未完成的task
                        var taskNoComList = subList.Where(_ => _.status_id != (int)DicEnum.TICKET_STATUS.DONE).ToList();
                        if (taskNoComList != null && taskNoComList.Count > 0)
                        {
                            result = true;
                        }
                        break;
                    case "ExpiredTask":  // 过期的任务和问题
                        var longTimeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        var expTaskList = subList.Where(_ => (long)_.estimated_end_time >= longTimeNow).ToList();
                        if (expTaskList != null && expTaskList.Count > 0)
                        {
                            result = true;
                        }
                        break;
                    // 不能按时完成
                    case "Issues":   // 只显示问题类型的task
                        var issTaskList = subList.Where(_ => _.type_id == (int)DicEnum.TASK_TYPE.PROJECT_ISSUE).ToList();
                        if (issTaskList != null && issTaskList.Count > 0)
                        {
                            result = true;
                        }
                        break;
                    case "phaseBudHours":
                        var phaseBudList = subList.Where(_ => _.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE).ToList();
                        if (phaseBudList != null && phaseBudList.Count > 0)
                        {
                            result = true;
                        }
                        break;
                    default:
                        result = true;
                        break;
                }

                var purchaseList = subList.Where(_ => _.type_id == (int)DicEnum.TASK_TYPE.PROJECT_PHASE).ToList();
                if (purchaseList != null && purchaseList.Count > 0)
                {
                    result = true;
                }
            }

            return result;
            // todo  根据pageShowType进行过滤，只考虑阶段或者状态相关
        }
    }
}