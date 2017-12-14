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
    public partial class SearchConditionFrame : BasePage
    {
        private QueryCommonBLL bll = new QueryCommonBLL();
        //protected string queryPage;     // 查询页名称
        protected int catId = 0;
        protected long queryTypeId;     // 查询页id
        protected long paraGroupId;     // 查询条件分组id
        protected List<QueryConditionParaDto> condition;    // 根据不同页面类型获取的查询条件列表
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["cat"], out catId))
                catId = 0;
            if (!long.TryParse(Request.QueryString["type"], out queryTypeId))
                queryTypeId = 0;
            if (!long.TryParse(Request.QueryString["group"], out paraGroupId))
                paraGroupId = 0;
            if (catId == 0 || queryTypeId == 0 || paraGroupId == 0)
            {
                Response.Close();
                return;
            }

            InitData();
            condition = bll.GetConditionParaVisiable(GetLoginUserId(), paraGroupId);
        }

        private void InitData()
        {
            currentQuery = new PageQueryConditionNameDto();
            currentQuery.page_query = new List<PageQueryConditionNameDto.PageQuery>();

            switch (catId)
            {
                case (int)DicEnum.QUERY_CATE.COMPANY:
                    currentQuery.page_name = "客户查询";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTACT:
                    currentQuery.page_name = "联系人查询";
                    break;
                case (int)DicEnum.QUERY_CATE.OPPORTUNITY:
                    currentQuery.page_name = "商机查询";
                    break;
                case (int)DicEnum.QUERY_CATE.QUOTE:
                    currentQuery.page_name = "报价查询";
                    break;
                case (int)DicEnum.QUERY_CATE.QUOTE_TEMPLATE:
                    currentQuery.page_name = "报价模板查询";
                    break;
                case (int)DicEnum.QUERY_CATE.INSTALLEDPRODUCT:
                    currentQuery.page_name = "配置项查询";
                    break;
                case (int)DicEnum.QUERY_CATE.SUBSCRIPTION:
                    currentQuery.page_name = "订阅查询";
                    break;
                case (int)DicEnum.QUERY_CATE.SALEORDER:
                    currentQuery.page_name = "销售订单查询";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT:
                    currentQuery.page_name = "合同查询";
                    break;
                case (int)DicEnum.QUERY_CATE.SYS_ROLE:
                    currentQuery.page_name = "角色管理";
                    break;
                case (int)DicEnum.QUERY_CATE.SYS_DEPARTMENT:
                    currentQuery.page_name = "部门管理";
                    break;
                case (int)DicEnum.QUERY_CATE.RESOURCE:
                    currentQuery.page_name = "联系人管理";
                    break;
                case (int)DicEnum.QUERY_CATE.SECURITY_LEVEL:
                    currentQuery.page_name = "安全等级管理";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_MILESTONE:
                    currentQuery.page_name = "里程碑状态管理";
                    break;
                case (int)DicEnum.QUERY_CATE.PRODUCT:
                    currentQuery.page_name = "产品管理";
                    break;
                case (int)DicEnum.QUERY_CATE.CONFIGITEMTYPE:
                    currentQuery.page_name = "配置项类型管理";
                    break;
                case (int)DicEnum.QUERY_CATE.REVOKE_CHARGES:
                    currentQuery.page_name = "撤销成本审批";
                    break;
                case (int)DicEnum.QUERY_CATE.REVOKE_MILESTONES:
                    currentQuery.page_name = "撤销里程碑审批";
                    break;
                case (int)DicEnum.QUERY_CATE.REVOKE_RECURRING_SERVICES:
                    currentQuery.page_name = "撤销定期服务审批";
                    break;
                case (int)DicEnum.QUERY_CATE.REVOKE_SUBSCRIPTIONS:
                    currentQuery.page_name = "撤销订阅审批";
                    break;
                case (int)DicEnum.QUERY_CATE.INVOICE_TEMPLATE:
                    currentQuery.page_name = "发票模板管理";
                    break;
                case (int)DicEnum.QUERY_CATE.INVOICE_HISTORY:
                    currentQuery.page_name = "历史发票管理";
                    break;
                case (int)DicEnum.QUERY_CATE.MARKET:
                    currentQuery.page_name = "市场领域管理";
                    break;
                case (int)DicEnum.QUERY_CATE.TERRITORY:
                    currentQuery.page_name = "客户地域管理";
                    break;
                case (int)DicEnum.QUERY_CATE.COMPETITOR:
                    currentQuery.page_name = "竞争对手管理";
                    break;
                case (int)DicEnum.QUERY_CATE.ACCOUNTTYPE:
                    currentQuery.page_name = "客户类别管理";
                    break;
                case (int)DicEnum.QUERY_CATE.SUFFIXES:
                    currentQuery.page_name = "姓名后缀管理";
                    break;
                case (int)DicEnum.QUERY_CATE.ACTIONTYPE:
                    currentQuery.page_name = "活动类型管理";
                    break;
                case (int)DicEnum.QUERY_CATE.OPPORTUNITYAGES:
                    currentQuery.page_name = "商机阶段管理";
                    break;
                case (int)DicEnum.QUERY_CATE.OPPORTUNITYSOURCE:
                    currentQuery.page_name = "商机来源管理";
                    break;
                case (int)DicEnum.QUERY_CATE.OPPPORTUNITYWINREASON:
                    currentQuery.page_name = "关闭商机原因管理";
                    break;
                case (int)DicEnum.QUERY_CATE.OPPPORTUNITYLOSSREASON:
                    currentQuery.page_name = "丢失商机原因管理";
                    break;
                case (int)DicEnum.QUERY_CATE.APPROVE_CHARGES:
                case (int)DicEnum.QUERY_CATE.APPROVE_MILESTONES:
                case (int)DicEnum.QUERY_CATE.APPROVE_RECURRING_SERVICES:
                case (int)DicEnum.QUERY_CATE.APPROVE_SUBSCRIPTIONS:
                case (int)DicEnum.QUERY_CATE.APPROVE_LABOUR:
                case (int)DicEnum.QUERY_CATE.APPROVE_EXPENSE:
                    currentQuery.page_name = "审批并提交";
                    break;
                case (int)DicEnum.QUERY_CATE.GENERATE_INVOICE:
                    currentQuery.page_name = "待生成发票的条目查询";
                    break;
                case (int)DicEnum.QUERY_CATE.PROJECT_SEARCH:
                    currentQuery.page_name = "项目查询";
					break;
                case (int)DicEnum.QUERY_CATE.CRM_NOTE_SEARCH:  
                    currentQuery.page_name = "备注查询";
                    break;
                case (int)DicEnum.QUERY_CATE.TODOS:
                    currentQuery.page_name = "待办查询";
                    break;
                case (int)DicEnum.QUERY_CATE.INVENTORY_ITEM:
                    currentQuery.page_name = "库存产品查询";
                    break;
                default:
                    currentQuery.page_name = "";
                    break;
            }

            var info = new QueryCommonBLL().GetQueryGroup(catId);
            foreach (var v in info)
            {
                currentQuery.page_query.Add(new PageQueryConditionNameDto.PageQuery { query_name = v.name, typeId = v.query_type_id, groupId = v.id });
            }
            
        }
        
        protected PageQueryConditionNameDto currentQuery;   // 当前查询页的标题、链接等信息
    }
}