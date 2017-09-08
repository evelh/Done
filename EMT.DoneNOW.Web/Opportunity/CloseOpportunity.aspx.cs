using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Text;

namespace EMT.DoneNOW.Web.Opportunity
{
    public partial class CloseOpportunity : BasePage
    {
        protected crm_account account = null;    // 该商机的客户
        protected crm_opportunity opportunity = null;
        protected crm_quote primaryQuote = null;            // 改商机下的主报价，可以为null
        protected List<crm_quote_item> quoteItemList = null;     // 主报价下的所有报价项的集合
        protected Dictionary<string, object> dic = new OpportunityBLL().GetField();
        protected sys_system_setting wonSetting = new SysSettingBLL().GetSetById(SysSettingEnum.CRM_OPPORTUNITY_WIN_REASON);
        protected List<crm_quote_item> proAndOneTimeItem = null;  // 一次性和产品的配置项
        protected List<crm_quote_item> shipItem = null;           // 配送配置项
        protected List<crm_quote_item> degressionItem = null;     // 成本的配置项
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                var id = Request.QueryString["id"];
                opportunity = new crm_opportunity_dal().GetOpportunityById(long.Parse(id));
                if (opportunity != null)
                {
                    StringBuilder text = new StringBuilder();
                    var costCode = new d_cost_code_dal().GetListCostCode((int)COST_CODE_CATE.MATERIAL_COST_CODE);
                    text.Append($"<option value='0'>   </option>");
                    if (costCode != null && costCode.Count > 0)
                    {
                        foreach (var item in costCode)
                        {
                            text.Append($"<option value='{item.id}'>{item.name}</option>");
                        }
                    }
                    codeSelect.Value = text.ToString();
                    account = new CompanyBLL().GetCompany(opportunity.account_id);
                    if (opportunity.status_id == (int)OPPORTUNITY_STATUS.CLOSED)
                    {
                        Response.Write("<script>if(!confirm('商机已被关闭，如果继续，系统会重复创建计费项和合同？')){window.close();}</script>");
                    }

                    #region 下拉框赋值
                    stage_id.DataTextField = "show";
                    stage_id.DataValueField = "val";
                    stage_id.DataSource = dic.FirstOrDefault(_ => _.Key == "opportunity_stage").Value;
                    stage_id.DataBind();

                    win_reason_type_id.DataTextField = "show";
                    win_reason_type_id.DataValueField = "val";
                    win_reason_type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "oppportunity_win_reason_type").Value;
                    win_reason_type_id.DataBind();
                    win_reason_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                    resource_id.DataTextField = "show";
                    resource_id.DataValueField = "val";
                    resource_id.DataSource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value;
                    resource_id.DataBind();

                    competitor_id.DataTextField = "show";
                    competitor_id.DataValueField = "val";
                    competitor_id.DataSource = dic.FirstOrDefault(_ => _.Key == "competition").Value;
                    competitor_id.DataBind();
                    competitor_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                    // period_type
                    period_type.DataTextField = "show";
                    period_type.DataValueField = "val";
                    period_type.DataSource = dic.FirstOrDefault(_ => _.Key == "period_type").Value;
                    period_type.DataBind();
                    period_type.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                    #endregion
                    period_type.SelectedValue = ((int)QUOTE_ITEM_PERIOD_TYPE.MONTH).ToString();

                    stage_id.SelectedValue = opportunity.stage_id == null ? "0" : opportunity.stage_id.ToString();
                    resource_id.SelectedValue = opportunity.resource_id.ToString();
                    competitor_id.SelectedValue = opportunity.competitor_id == null ? "0" : opportunity.competitor_id.ToString();
                    win_reason_type_id.SelectedValue = opportunity.win_reason_type_id == null ? "0" : opportunity.win_reason_type_id.ToString();
                    primaryQuote = new QuoteBLL().GetPrimaryQuote(opportunity.id);


                    if (primaryQuote != null)
                    {
                        if (!IsPostBack)
                        {
                            if (primaryQuote.project_id != null) // 判断该报价是否关联项目提案，如果关联，默认选中，不关联，灰掉，不可选
                            {
                                activeproject.Checked = true;
                            }
                            else
                            {
                                activeproject.Enabled = false;
                                isactiveproject.Value = "1";
                                
                            }
                        }
                        quoteItemList = new crm_quote_item_dal().GetQuoteItems($" and quote_id = {primaryQuote.id}");
                        if (quoteItemList != null && quoteItemList.Count > 0)
                        {
                            // 如果报价项中包含了服务 / 服务包、初始费用，则可以选中（默认不选）
                            // 此功能需要具有合同模块权限以及修改合同服务/包权限

                            var isServiceChargeItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.SERVICE || _.type_id == (int)QUOTE_ITEM_TYPE.SERVICE_PACK || _.type_id == (int)QUOTE_ITEM_TYPE.START_COST).ToList();
                            if (!IsPostBack)
                            {
                                if (isServiceChargeItem != null && isServiceChargeItem.Count > 0)
                                {
                                    // todo--需要判断用户权限
                                }
                                else
                                {
                                    addContractRequest.Enabled = false;
                                    isAddContractRequest.Value = "1";
                                    addContractServices.Enabled = false;
                                    isaddContractServices.Value = "1";
                                }
                            }
                            proAndOneTimeItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.PRODUCT || _.type_id == (int)QUOTE_ITEM_TYPE.DISCOUNT).ToList();
                            if (!IsPostBack)
                            {
                                if (proAndOneTimeItem != null && proAndOneTimeItem.Count > 0)
                                {
                                    isIncludePO.Checked = true;
                                }
                                else
                                {
                                    IncludePO.Value = "1";
                                    isIncludePO.Enabled = false;
                                }
                            }
                            shipItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES).ToList();
                            if (!IsPostBack)
                            {
                                if (shipItem != null && shipItem.Count > 0)
                                {
                                    isIncludeShip.Checked = true;
                                }
                                else
                                {
                                    IncludeShip.Value = "1";
                                    isIncludeShip.Enabled = false;
                                }
                            }
                            degressionItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.DEGRESSION).ToList();
                            if (!IsPostBack)
                            {
                                if (degressionItem != null && degressionItem.Count > 0)
                                {
                                    isIncludeCharges.Checked = true;
                                }
                                else
                                {
                                    IncludeCharges.Value = "1";
                                    isIncludeCharges.Enabled = false;
                                }
                            }
                            jqueryCode.Value = ReturnJquery();
                        }
                    }
                    else
                    {
                        activeproject.Enabled = false;
                        isactiveproject.Value = "1";
                        addContractRequest.Enabled = false;
                        isAddContractRequest.Value = "1";
                        addContractServices.Enabled = false;
                        isaddContractServices.Value = "1";
                        IncludePO.Value = "1";
                        isIncludePO.Enabled = false;
                        IncludeShip.Value = "1";
                        isIncludeShip.Enabled = false;
                        IncludeCharges.Value = "1";
                        isIncludeCharges.Enabled = false;
                    }
                }
            }
            catch (Exception)
            {

                Response.End();
            }
        }

        /// <summary>
        /// 根据不同的报价项选择不同的物料代码(执行不同的jquery代码放到前端执行)
        /// </summary>
        /// <returns></returns>
        private string ReturnJquery()
        {
            var scriptText = "";
            if (proAndOneTimeItem != null && proAndOneTimeItem.Count > 0)
            {
                foreach (var item in proAndOneTimeItem)
                {
                    if (item.object_id != null)
                    {
                        var product = new EMT.DoneNOW.BLL.ProductBLL().GetProduct((long)item.object_id);
                        if (product != null)
                        {
                            scriptText += $"$('#{item.id}_select').val({product.cost_code_id});";
                        }
                    }
                }
                return scriptText;
            }


            return "";
        }

        protected void Finish_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var result = new OpportunityBLL().CloseOpportunity(param,GetLoginUserId());
            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                    break;
                case ERROR_CODE.PARAMS_ERROR:
                    break;
                case ERROR_CODE.USER_NOT_FIND:
                    Response.Write("");
                    break;
                default:
                    break;
            }

        }
        /// <summary>
        /// 获取到需要用到的参数
        /// </summary>
        /// <returns></returns>
        private CloseOpportunityDto GetParam()
        {
            var thisOppo = AssembleModel<crm_opportunity>();
            opportunity.stage_id = thisOppo.stage_id;
            opportunity.resource_id = thisOppo.resource_id;
            opportunity.primary_product_id = thisOppo.primary_product_id;
            opportunity.competitor_id = thisOppo.competitor_id;
            opportunity.win_reason_type_id = thisOppo.win_reason_type_id;
            opportunity.win_reason = thisOppo.win_reason;

            CloseOpportunityDto param = new CloseOpportunityDto()
            {
                opportunity = this.opportunity,
                activateProject = activeproject.Checked,
                createContract = addContractRequest.Checked,
                addServicesToExistingContract = addContractServices.Checked,
                createTicketPostSaleQueue = addRequest.Checked,
            };

            var convertTo = Request.Form["optProject"];
            switch (convertTo)
            {
                case "rbProjectCost":
                    param.convertToServiceTicket = true;
                    break;
                case "RadioPC":
                    param.convertToProject = true;
                    break;
                case "rbContractCost":
                    param.convertToNewContractt = true;
                    break;
                case "RadioCCEx":
                    param.convertToOldContract = true;
                    break;
                case "RadioBI":
                    param.convertToTicket = true;
                    break;
                default:
                    break;
            }
            if (addContractRequest.Checked) // 创建合同
            {
                var contract = new ctt_contract()
                {
                    name = Request.Form["contract_name"],
                    start_date = Convert.ToDateTime(Request.Form["start_date"]),
                    period_type = int.Parse(Request.Form["period_type"]),
                };

                if (Request.Form["RadioBtnEndDate"] == "on")  // 通过开始和结束时间添加
                {
                    contract.end_date = Convert.ToDateTime(Request.Form["end_date"]);
                }
               
                if (Request.Form["RadioBtnEndAfter"] == "on")  // 通过重复周期添加
                {
                    contract.occurrences = int.Parse(Request.Form["occurrences"]);
                }
                param.contract = contract;
            }
            if (addContractServices.Checked)  // 添加到现有合同
            {
                ctt_contract contract = new ctt_contract()
                {
                    id = string.IsNullOrEmpty(Request.Form["contract_idHidden"]) ? 0 : long.Parse(Request.Form["contract_idHidden"]),
                };
                param.contract = contract;
                param.effective_date = Convert.ToDateTime(Request.Form["effective_date"]);
            }

            Dictionary<long, string> dic = new Dictionary<long, string>();
            param.isIncludePO = isIncludePO.Checked;
            if (isIncludePO.Checked)
            {
                if (proAndOneTimeItem != null && proAndOneTimeItem.Count > 0)
                {
                    foreach (var item in proAndOneTimeItem)
                    {
                        dic.Add(item.id, Request.Form[item.id.ToString()+"_select"]);
                    }
                }
            }
            param.isIncludeCharges = isIncludeCharges.Checked;
            if (isIncludeCharges.Checked)
            {
                if (degressionItem != null && degressionItem.Count > 0)
                {
                    foreach (var item in degressionItem)
                    {
                        dic.Add(item.id, Request.Form[item.id.ToString() + "_select"]);
                    }
                }
            }
            param.costCodeList = dic;


            return param;
        }
    }
}