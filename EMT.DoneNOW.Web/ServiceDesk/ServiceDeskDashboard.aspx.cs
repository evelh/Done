using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class ServiceDeskDashboard : BasePage
    {
        protected string refreshMin;
        protected TicketBLL ticBll = new TicketBLL();
        protected CompanyBLL comBll = new CompanyBLL();
        protected InstalledProductBLL insProBll = new InstalledProductBLL();
        protected List<sdk_task> allTicketList;
        protected List<d_general> ticStaList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_STATUS);          // 工单状态集合
        protected List<d_general> priorityList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_PRIORITY_TYPE);   // 工单优先级集合
        protected List<d_general> issueTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_ISSUE_TYPE);     // 工单问题类型
        protected List<d_general> sourceTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_SOURCE_TYPES);     // 工单来源
        protected List<d_general> ticketCateList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_CATE);     // 工单种类
        protected List<d_general> ticketTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_TYPE);     // 工单类型
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList(false);
        protected List<d_account_classification> classList = new DAL.d_account_classification_dal().GetAccClassList();
        protected List<ivt_product> proList = new DAL.ivt_product_dal().GetProList();
        protected List<sys_department> depList = new DAL.sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE);
        protected List<d_general> ticSolPer = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.SYS_TICKET_RESOLUTION_METRICS);     // 工单解决参数
        protected Dictionary<long, List<sdk_task>> classTickDic = new Dictionary<long, List<sdk_task>>();    // 客户类别分组
        protected Dictionary<long, List<sdk_task>> productTickDic = new Dictionary<long, List<sdk_task>>();  // 产品分组
        protected Dictionary<string, int> countDic = new Dictionary<string, int>();
        protected List<sys_resource> limitResList;  // 权限过滤后的工单负责人
        protected void Page_Load(object sender, EventArgs e)
        {
            refreshMin = Request.QueryString["refreshMin"];
            allTicketList = ticBll.GetAllTicket();
            countDic = ticBll.GetServiceDeskCount();
            if (allTicketList!=null&& allTicketList.Count > 0)
            {
                classTickDic = allTicketList.GroupBy(_ =>
                {
                    long classId = 0; var acc = comBll.GetCompany(_.account_id);
                    if (acc != null) { classId = acc.classification_id ?? 0; }
                    return classId;
                }).OrderBy(_=>_.Key).ToDictionary(_ => _.Key, _ => _.ToList());
                productTickDic = allTicketList.GroupBy(_ =>
                {
                    long productId = 0;
                    if (_.installed_product_id != null)
                    {
                        var insPro = insProBll.GetById((long)_.installed_product_id);
                        if (insPro != null)
                        {
                            productId = insPro.product_id;
                        }
                    }
                    return productId;
                }).OrderBy(_ => _.Key).ToDictionary(_ => _.Key, _ => _.ToList());
            }
            // {"row":8,"t1":"t","col1":"71,72","col2":"71,72,73"}
            var ticketLimtJson = "{\"row\":\"8\",\"t1\":\"t\",\"col1\":\"71,72\",\"col2\":\"71,72,73\"}";
            var ticketLimitSql = Convert.ToString(new DAL.sdk_task_dal().GetSingle($"select f_rpt_getsql_limit('{ticketLimtJson}',{LoginUserId.ToString()})"));
            var limitTicket = new DAL.v_ticket_dal().FindListBySql("SELECT * from v_ticket t where t.type_id = 1809 "+ ticketLimitSql); 
            var resIdList = ticBll.ReturnResIdsByTicket(limitTicket);
            if (resIdList != null && resIdList.Count > 0 && resList != null && resList.Count > 0)
            {
                limitResList = new List<sys_resource>();
                resIdList.ForEach(_ =>
                {
                    var thisRes = resList.FirstOrDefault(r => r.id.ToString() == _);
                    if (thisRes != null)
                        limitResList.Add(thisRes);
                });
            }

        }
    }
}