using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Project
{
    public partial class TaskHistory : BasePage
    {
        protected sdk_task thisTask = null;
        protected List<sys_oper_log> logList = null;

        private QueryCommonBLL bll = new QueryCommonBLL();
        protected int catId = 0;
        //protected string queryPage;     // 查询页名称
        protected long queryTypeId;     // 查询页id
        protected long paraGroupId;     // 查询条件分组id
        protected string addBtn;        // 根据不同查询页得到的新增按钮名
        protected QueryResultDto queryResult = null;            // 查询结果数据
        protected List<QueryResultParaDto> resultPara = null;   // 查询结果列信息
        protected List<DictionaryEntryDto> queryParaValue = new List<DictionaryEntryDto>();
        protected int tableWidth = 1200;
        protected long objId = 0;
        protected bool isFromTicket = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var tId = Request.QueryString["task_id"];
                if (!string.IsNullOrEmpty(tId))
                {
                    thisTask = new sdk_task_dal().FindNoDeleteById(long.Parse(tId));
                    if (thisTask != null)
                    {
                        objId = thisTask.id;
                    }
                }
                isFromTicket = !string.IsNullOrEmpty(Request.QueryString["fromTicket"]);

                if (thisTask == null)
                {
                    Response.End();
                }
                else
                {
                    catId = (int)DicEnum.QUERY_CATE.TASK_HISTORY;
                    queryTypeId = (int)QueryType.TASK_HISTORY;
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

                    QueryData();
                    CalcTableWidth();

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
                        string ql = keys[p.id.ToString() + "_l"];
                        string qh = keys[p.id.ToString() + "_h"];
                        if (string.IsNullOrEmpty(ql) && string.IsNullOrEmpty(qh))   // 空值，跳过
                            continue;
                        if (!string.IsNullOrEmpty(ql))
                        {
                            queryParaValue.Add(new DictionaryEntryDto(p.id.ToString() + "_l", ql));     // 记录查询条件和条件值
                            pa.value = ql;
                        }
                        if (!string.IsNullOrEmpty(qh))
                        {
                            queryParaValue.Add(new DictionaryEntryDto(p.id.ToString() + "_h", qh));     // 记录查询条件和条件值
                            pa.value2 = qh;
                        }
                        pa.id = p.id;

                        queryPara.query_params.Add(pa);
                    }
                    else    // 其他类型一个值
                    {
                        string val = keys[p.id.ToString()];
                        if (string.IsNullOrEmpty(val))
                            continue;
                        pa.id = p.id;
                        pa.value = val;
                        queryParaValue.Add(new DictionaryEntryDto(p.id.ToString(), val));     // 记录查询条件和条件值

                        queryPara.query_params.Add(pa);
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

    }
}