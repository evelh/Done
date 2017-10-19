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
    public partial class ContractCopy : BasePage
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
            udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);
            resourceList = new DAL.sys_resource_dal().GetSourceList();
            roleList = new DAL.sys_role_dal().GetList();

            if (!IsPostBack)
            {
                long id = 0;
                if (string.IsNullOrEmpty(Request.QueryString["id"]) || !long.TryParse(Request.QueryString["id"], out id))
                {
                    Response.Close();
                    return;
                }

                contractCopy = bll.GetContract(id);
                contractCopy.name = "[Copy of]" + contractCopy.name;
                companyName = new CompanyBLL().GetCompany(contractCopy.account_id).name;
                if (contractCopy.contact_id != null && contractCopy.contact_id > 0)
                    contactList = new ContactBLL().GetContactByCompany(contractCopy.account_id);
                udfValues = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.CONTRACTS, id, udfList);

                if (contractCopy.type_id == (int)DicEnum.CONTRACT_TYPE.FIXED_PRICE)
                {
                    milestoneList = bll.GetMilestoneList(id);
                }

                if (contractCopy.type_id == (int)DicEnum.CONTRACT_TYPE.SERVICE)
                {
                    serviceList = new ContractServiceBLL().GetServiceList(id);
                }

                contractType = contractCopy.type_id;
                isFinish = 0;
            }
            else
            {
                ContractAddDto dto = new ContractAddDto();
                dto.contract = AssembleModel<ctt_contract>();
                
                if (!string.IsNullOrEmpty(Request.Form["isSdtDefault"]) && Request.Form["isSdtDefault"].Equals("on"))
                    dto.contract.is_sdt_default = 1;

                if (!string.IsNullOrEmpty(Request.Form["needTimeSheet"]) && Request.Form["needTimeSheet"].Equals("on"))
                    dto.contract.timeentry_need_begin_end = 1;
                else
                    dto.contract.timeentry_need_begin_end = 0;

                if (dto.contract.type_id == (int)DicEnum.CONTRACT_TYPE.BLOCK_HOURS)
                {
                    if (!string.IsNullOrEmpty(Request.Form["enableOverage"]) && Request.Form["enableOverage"].Equals("on"))
                        dto.contract.enable_overage_billing_rate = 1;
                }

                if (dto.contract.type_id == (int)DicEnum.CONTRACT_TYPE.FIXED_PRICE)
                {
                    if (!string.IsNullOrEmpty(Request.Form["applyPayment"]) && Request.Form["applyPayment"].Equals("on"))
                    {
                        decimal price = 0;
                        if (decimal.TryParse(Request.Form["alreadyReceived"], out price) && price > 0)
                            dto.alreadyReceived = price;
                        if (decimal.TryParse(Request.Form["toBeInvoiced"], out price) && price > 0)
                            dto.toBeInvoiced = price;
                        long code = 0;
                        if (long.TryParse(Request.Form["defaultCostCode"], out code))
                            dto.defaultCostCode = code;
                    }
                }

                if (udfList != null && udfList.Count > 0)                      // 首先判断是否有自定义信息
                {
                    var list = new List<UserDefinedFieldValue>();
                    foreach (var udf in udfList)                            // 循环添加
                    {
                        var new_udf = new UserDefinedFieldValue()
                        {
                            id = udf.id,
                            value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                        };
                        list.Add(new_udf);

                    }
                    dto.udf = list;
                }

                // 服务
                dto.serviceList = new List<ServiceInfoDto>();
                if (dto.contract.type_id == (int)DicEnum.CONTRACT_TYPE.SERVICE)
                {
                    if (!string.IsNullOrEmpty(Request.Form["AddServiceIds"]))   // 服务
                    {
                        string[] ids = Request.Form["AddServiceIds"].Split(',');
                        foreach (string id in ids)
                        {
                            ServiceInfoDto si = new ServiceInfoDto();
                            si.price = decimal.Parse(Request.Form["price" + id]);
                            si.number = decimal.Parse(Request.Form["num" + id]);
                            si.serviceId = long.Parse(id);
                            si.type = 1;
                            dto.serviceList.Add(si);
                        }
                    }
                    if (!string.IsNullOrEmpty(Request.Form["AddSerBunIds"]))    // 服务包
                    {
                        string[] ids = Request.Form["AddSerBunIds"].Split(',');
                        foreach (string id in ids)
                        {
                            ServiceInfoDto si = new ServiceInfoDto();
                            si.price = decimal.Parse(Request.Form["price" + id]);
                            si.number = decimal.Parse(Request.Form["num" + id]);
                            si.serviceId = long.Parse(id);
                            si.type = 2;
                            dto.serviceList.Add(si);
                        }
                    }
                }

                // 里程碑
                dto.milestone = new List<ctt_contract_milestone>();
                if (dto.contract.type_id == (int)DicEnum.CONTRACT_TYPE.FIXED_PRICE && (!string.IsNullOrEmpty(Request.Form["milestoneAddList"])))
                {
                    string[] ids = Request.Form["milestoneAddList"].Split(',');
                    foreach (string id in ids)
                    {
                        ctt_contract_milestone mil = new ctt_contract_milestone();
                        mil.name = Request.Form["MilName" + id];
                        mil.description = Request.Form["MilDetail" + id];
                        decimal dollar = 0;
                        if (!decimal.TryParse(Request.Form["MilAmount" + id], out dollar))
                            dollar = 0;
                        mil.dollars = dollar;
                        mil.due_date = DateTime.Parse(Request.Form["MilDate" + id]);
                        mil.cost_code_id = long.Parse(Request.Form["MilCode" + id]);
                        mil.status_id = int.Parse(Request.Form["isBill" + id]);
                        dto.milestone.Add(mil);
                    }
                }

                // 角色费率
                dto.rateList = new List<ContractRateDto>();
                if (dto.contract.type_id != (int)DicEnum.CONTRACT_TYPE.SERVICE
                    && dto.contract.type_id != (int)DicEnum.CONTRACT_TYPE.PER_TICKET)
                {
                    foreach (var role in roleList)
                    {
                        if (Request.Form["cbRoleRate" + role.id] != null && Request.Form["cbRoleRate" + role.id].Equals("on"))
                        {
                            var roleRate = new ContractRateDto();
                            roleRate.roleId = role.id;
                            roleRate.rate = decimal.Parse(Request.Form["txtRoleRate" + role.id]);
                            dto.rateList.Add(roleRate);
                        }
                    }
                }

                // 邮件通知
                dto.notifyUserIds = new List<long>();
                foreach (var res in resourceList)
                {
                    if (Request.Form["notify" + res.id] != null && Request.Form["notify" + res.id].Equals("on"))
                        dto.notifyUserIds.Add(res.id);
                }
                if (dto.notifyUserIds.Count != 0)
                {
                    dto.notifySubject = Request.Form["notifyTitle"];
                    dto.notifyMessage = Request.Form["notifyContent"];
                    dto.notifyEmails = Request.Form["notifyEmails"];
                }

                contractId = bll.CopyContract(dto, GetLoginUserId());
                isFinish = 1;

                udfValues = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.CONTRACTS, dto.contract.id, udfList);
                contractCopy = new ctt_contract();
                contractType = dto.contract.type_id;
            }

            Dictionary<string, object> dics = bll.GetField();
            contractCate = dics["cate"] as List<DictionaryEntryDto>;
            periodType = dics["periodType"] as List<DictionaryEntryDto>;
            periodType.Remove(periodType.Find(pt => pt.val.Equals(((int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME).ToString())));
            billPostType = dics["billPostType"] as List<DictionaryEntryDto>;
            slaList = bll.GetSLAList();

            contractTypeName = bll.GetContractTypeName(contractType);
        }
    }
}