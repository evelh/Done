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

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class MasterTicket : BasePage
    {
        protected sdk_task thisTicket = null;   // 当前工单
        protected bool isAdd = true;            // 新增还是编辑
        protected bool isCopy = false;          // 复制
        protected crm_account thisAccount = null;  // 工单的客户
        protected crm_contact thisContact = null;  // 工单的联系人
        protected sys_resource priRes = null;      // 工单的主负责人
        protected sys_resource_department proResDep = null; // 工单的主负责人
        protected crm_installed_product insPro = null; // 工单的配置项
        protected ctt_contract thisContract = null;    // 工单的合同
        protected d_cost_code thisCostCode = null;     //  工单的工作类型
        protected List<d_sla> slaList = new d_sla_dal().GetList();
        protected List<d_general> ticStaList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_STATUS);          // 工单状态集合
        protected List<d_general> priorityList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_PRIORITY_TYPE);   // 工单优先级集合
        protected List<d_general> issueTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_ISSUE_TYPE);     // 工单问题类型
        protected List<d_general> sourceTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_SOURCE_TYPES);     // 工单来源
        protected List<d_general> ticketCateList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_CATE);     // 工单种类
        protected List<d_general> ticketTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_TYPE);     // 工单类型
        protected List<sys_department> depList = new sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE);
        protected List<d_cost_code> costList = new d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE);
        protected List<sys_resource_department> ticketResList = null;  // 工单的员工
        protected List<UserDefinedFieldDto> tickUdfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
        protected List<UserDefinedFieldValue> ticketUdfValueList = null;
        protected List<sdk_task_checklist> ticketCheckList = null;   // 工单的检查单集合
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Bind();  // 绑定页面下拉数据
            }
        }
        public void Bind()
        {
            status_id.DataValueField = "id";
            status_id.DataTextField = "name";
            status_id.DataSource = ticStaList;
            status_id.DataBind();
            status_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            priority_type_id.DataValueField = "id";
            priority_type_id.DataTextField = "name";
            priority_type_id.DataSource = priorityList;
            priority_type_id.DataBind();
            priority_type_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            issue_type_id.DataValueField = "id";
            issue_type_id.DataTextField = "name";
            issue_type_id.DataSource = issueTypeList;
            issue_type_id.DataBind();
            issue_type_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            source_type_id.DataValueField = "id";
            source_type_id.DataTextField = "name";
            source_type_id.DataSource = sourceTypeList;
            source_type_id.DataBind();
            source_type_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            ticketCateList = ticketCateList.Where(_ => _.id == (int)DicEnum.TICKET_CATE.STANDARD).ToList(); // 暂时只支持标准一种类型
            cate_id.DataValueField = "id";
            cate_id.DataTextField = "name";
            cate_id.DataSource = ticketCateList;
            cate_id.DataBind();
            cate_id.SelectedValue = ((int)DicEnum.TICKET_CATE.STANDARD).ToString();

            //ticket_type_id.DataValueField = "id";
            //ticket_type_id.DataTextField = "name";
            //ticket_type_id.DataSource = ticketTypeList;
            //ticket_type_id.DataBind();

            cost_code_id.DataValueField = "id";
            cost_code_id.DataTextField = "name";
            cost_code_id.DataSource = costList;
            cost_code_id.DataBind();
            cost_code_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            department_id.DataValueField = "id";
            department_id.DataTextField = "name";
            department_id.DataSource = depList;
            department_id.DataBind();
            department_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            //sla_id.DataValueField = "id";
            //sla_id.DataTextField = "name";
            //sla_id.DataSource = slaList;
            //sla_id.DataBind();
            //sla_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            //notify_id.DataValueField = "id";
            //notify_id.DataTextField = "name";
            //notify_id.DataSource = new sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.TICKET_CREATED_EDITED);
            //notify_id.DataBind();
        }

        protected void save_Click(object sender, EventArgs e)
        {

        }

        protected void save_close_Click(object sender, EventArgs e)
        {

        }
    }
}