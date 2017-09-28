using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.Tools;

namespace EMT.DoneNOW.Web
{
    public partial class SelectCallBack : BasePage
    {
        private QueryCommonBLL bll = new QueryCommonBLL();
        protected string callBackFunc;  // 回调方法
        protected bool isMuilt = false; // 是否多选查找带回
        protected long queryTypeId;     // 查询页id
        protected long paraGroupId;     // 查询条件分组id
        protected string callBackField; // 回调字段名
        protected QueryResultDto queryResult = null;            // 查询结果数据
        protected List<QueryResultParaDto> resultPara = null;   // 查询结果列信息
        protected List<DictionaryEntryDto> queryParaValue = new List<DictionaryEntryDto>();  // 查询条件和条件值
        protected List<QueryConditionParaDto> condition;    // 根据不同页面类型获取的查询条件列表
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["callBack"]))
                callBackFunc = Request.QueryString["callBack"];

            // 是否多选查找带回
            string muilt = HttpContext.Current.Request.QueryString["muilt"];
            if (!string.IsNullOrEmpty(muilt) && muilt.Equals("1"))
                isMuilt = true;

            int catId = 0;
            if (!int.TryParse(Request.QueryString["cat"], out catId))
            {
                Response.Close();
                return;
            }

            var group = bll.GetQueryGroup(catId);
            if (group == null || group.Count == 0)
            {
                Response.Close();
                return;
            }

            queryTypeId = group[0].query_type_id;
            paraGroupId = group[0].id;

            callBackField = HttpContext.Current.Request.QueryString["field"];
            if (string.IsNullOrEmpty(callBackField))
            {
                Response.Close();
                return;
            }

            condition = bll.GetConditionParaVisiable(GetLoginUserId(), paraGroupId);

            QueryData();
        }

        /// <summary>
        /// 根据查询条件获取查询结果
        /// </summary>
        private void QueryData()
        {
            queryParaValue.Clear();
            resultPara = bll.GetResultParaSelect(GetLoginUserId(), paraGroupId);    // 获取查询结果列信息
            //queryResult = bll.getDataTest();return;
            var keys = HttpContext.Current.Request;
            string order = keys["order"];   // order by 条件
            int page = string.IsNullOrEmpty(keys["page_num"]) ? 1 : int.Parse(keys["page_num"]);  // 查询页数

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
            }

            if (queryResult == null)  // 不使用缓存或缓存过期
            {
                var para = bll.GetConditionParaAll(GetLoginUserId(), paraGroupId);   // 查询条件信息
                QueryParaDto queryPara = new QueryParaDto();
                queryPara.query_params = new List<Para>();
                foreach (var p in para)
                {
                    Para pa = new Para();
                    if (p.data_type == (int)DicEnum.QUERY_PARA_TYPE.NUMBER
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.DATE
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.DATETIME)    // 数值和日期类型是范围值
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

                queryPara.query_type_id = queryTypeId;
                queryPara.para_group_id = paraGroupId;
                queryPara.page = page;
                queryPara.order_by = order;
                queryPara.page_size = 0;

                queryResult = bll.GetResult(GetLoginUserId(), queryPara);
            }
        }

        protected void Search_Click(object sender, EventArgs e)
        {

        }
    }
}