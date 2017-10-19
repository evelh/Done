using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractRenew : BasePage
    {
        protected ctt_contract contractCopy;
        protected int contractType; // 合同类型
        protected int isFinish;     // 新增合同页面类型
        protected List<DictionaryEntryDto> contractCate;    // 合同种类
        protected List<DictionaryEntryDto> periodType;      // 计费周期类型
        protected List<DictionaryEntryDto> billPostType;    // 工时计费设置
        protected List<sys_resource> resourceList;  // 通知员工列表
        protected List<sys_role> roleList;  // 角色费率
        protected List<d_sla> slaList;      // SLA列表
        protected List<UserDefinedFieldDto> udfList;        // 自定义字段信息
        protected List<UserDefinedFieldValue> udfValues;    // 自定义字段值
        protected string contractTypeName;
        protected long contractId = 0;      // 新增成功的合同id
        protected string companyName;       // 客户名称
        protected List<crm_contact> contactList = null;     // 联系人列表
        protected List<ContractMilestoneEntityDto> milestoneList = new List<ContractMilestoneEntityDto>();  // 合同的里程碑
        protected List<ContractServiceEntityDto> serviceList = new List<ContractServiceEntityDto>();        // 合同的服务
        private ContractBLL bll = new ContractBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                long id = 0;
                if (string.IsNullOrEmpty(Request.QueryString["id"]) || !long.TryParse(Request.QueryString["id"], out id))
                {
                    Response.Close();
                    return;
                }

                contractCopy = bll.GetContract(id);
            }
        }
    }
}