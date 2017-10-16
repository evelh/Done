using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractAdd : BasePage
    {
        protected int contractType; // 合同类型
        protected int isFinish;     // 新增合同页面类型
        protected string contractTypeName;  // 合同类型名称
        protected List<DictionaryEntryDto> contractCate;    // 合同种类
        protected List<DictionaryEntryDto> periodType;      // 计费周期类型
        protected List<DictionaryEntryDto> billPostType;    // 工时计费设置
        protected List<sys_resource> resourceList;  // 通知员工列表
        protected List<sys_role> roleList;  // 角色费率
        protected List<d_sla> slaList;      // SLA列表
        protected List<UserDefinedFieldDto> udfList;        // 自定义字段信息
        protected long contractId = 0;      // 新增成功的合同id
        private ContractBLL bll = new ContractBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);
            resourceList = new DAL.sys_resource_dal().GetSourceList();
            roleList = new DAL.sys_role_dal().GetList();

            if (IsPostBack)
            {
                ContractAddDto dto = new ContractAddDto();
                dto.contract = AssembleModel<ctt_contract>();

                if (!string.IsNullOrEmpty(Request.Form["isSdtDefault"]) && Request.Form["isSdtDefault"].Equals("on"))
                    dto.contract.is_sdt_default = 1;

                if (!string.IsNullOrEmpty(Request.Form["needTimeSheet"]) && Request.Form["needTimeSheet"].Equals("on"))
                    dto.contract.timeentry_need_begin_end = 1;

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
                        mil.dollars = decimal.Parse(Request.Form["MilAmount" + id]);
                        mil.due_date = DateTime.Parse(Request.Form["MilDate" + id]);
                        mil.cost_code_id = long.Parse(Request.Form["MilCode" + id]);
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

                contractId = bll.Insert(dto, GetLoginUserId());
                contractType = dto.contract.type_id;
                isFinish = 1;
            }
            else
            {
                if (!int.TryParse(Request.QueryString["type"], out contractType))
                    contractType = 0;
                isFinish = 0;
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