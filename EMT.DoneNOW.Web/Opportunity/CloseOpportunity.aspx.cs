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
using EMT.DoneNOW.BLL.CRM;
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
                if (!IsPostBack)
                {
                    var id = Request.QueryString["id"];
                    opportunity = new crm_opportunity_dal().GetOpportunityById(long.Parse(id));
                    if (opportunity != null)
                    {
                        StringBuilder text = new StringBuilder();
                        var costCode = new d_cost_code_dal().GetListCostCode((int)COST_CODE_CATE.MATERIAL_COST_CODE);
                        if (costCode != null && costCode.Count > 0)
                        {
                            foreach (var item in costCode)
                            {
                                text.Append($"<option id='{item.id}'>{item.name}</option>");
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

                        primaryQuote = new QuoteBLL().GetPrimaryQuote(opportunity.id);
                        if (primaryQuote != null)
                        {
                            if (primaryQuote.project_id != null) // 判断该报价是否关联项目提案，如果关联，默认选中，不关联，灰掉，不可选
                            {
                                activeproject.Enabled = false;
                                isactiveproject.Value = "1";
                            }
                            else
                            {
                                activeproject.Checked = true;
                            }

                            quoteItemList = new crm_quote_item_dal().GetQuoteItems($" and quote_id = {primaryQuote.id}");
                            if (quoteItemList != null && quoteItemList.Count > 0)
                            {
                                // 如果报价项中包含了服务 / 服务包、初始费用，则可以选中（默认不选）
                                // 此功能需要具有合同模块权限以及修改合同服务/包权限

                                var isServiceChargeItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.SERVICE || _.type_id == (int)QUOTE_ITEM_TYPE.SERVICE_PACK || _.type_id == (int)QUOTE_ITEM_TYPE.START_COST).ToList();
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

                                proAndOneTimeItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.PRODUCT || _.type_id == (int)QUOTE_ITEM_TYPE.DISCOUNT).ToList();
                                if (proAndOneTimeItem != null && proAndOneTimeItem.Count > 0)
                                {

                                }
                                else
                                {
                                    IncludePO.Value = "1";
                                    isIncludePO.Enabled = false;
                                }

                                shipItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES).ToList();
                                if (shipItem != null && shipItem.Count > 0)
                                {

                                }
                                else
                                {
                                    IncludeShip.Value = "1";
                                    isIncludeShip.Enabled = false;
                                }

                                degressionItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.DEGRESSION).ToList();
                                if (degressionItem != null && degressionItem.Count > 0)
                                {

                                }
                                else
                                {
                                    IncludeCharges.Value = "1";
                                    isIncludeCharges.Enabled = false;
                                }



                                // 步骤4，物料成本代码设置，主要针对产品类型的报价项，若该产品报价项未关联物料代码，则让用户选择

                                var proItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.PRODUCT).ToList();

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
                        }
                    }
                }

            }
            catch (Exception)
            {

                Response.End();
            }
        }
        /// <summary>
        /// 第二页点击下一页的时候可能会出现的问题
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ShowNext_Click(object sender, EventArgs e)
        {
            if((!isIncludePO.Checked) &&(!isIncludeShip.Checked) && (!isIncludeCharges.Checked))
            {
                return;
            }

            StringBuilder text = new StringBuilder();
            var costCode = new d_cost_code_dal().GetListCostCode((int)COST_CODE_CATE.MATERIAL_COST_CODE);
            if (costCode != null && costCode.Count > 0)
            {
                text.Append($"<option id='0'>  </option>");
                foreach (var item in costCode)
                {
                    text.Append($"<option id='{item.id}'>{item.name}</option>");
                }
            }
            var thisHtml = "";
            var scriptText = "";
            if (isIncludePO.Checked)
            {
                foreach (var item in proAndOneTimeItem)
                {
                    thisHtml += $" <tr><td id=\"txtBlack8\" style=\"vertical-align: middle;\" nowrap>{item.name}</td><td id=\"txtBlack8\" style=\"vertical-align: middle;\" nowrap align=\"right\">{item.quantity}</td><td nowrap align=\"left\"><span class=\"errorSmall\">*</span><select class='costCodeClass' name='{item.id}_select' id='{item.id}_select' style=\"width: 90%;\">" + text.ToString() + "</select></td></tr>;";

                    if (item.object_id != null)
                    {
                        var product = new EMT.DoneNOW.BLL.ProductBLL().GetProduct((long)item.object_id);
                        if (product != null)
                        {
                            scriptText += $"$('#{item.id}_select').val('{product.cost_code_id}');";
                            // var aa = product.cost_code_id;
                        }
                    }
                }
            }
            if (isIncludeShip.Checked)
            {

            }
            if (isIncludeCharges.Checked)
            {
                foreach (var item in degressionItem)
                {
                    thisHtml += $" <tr><td id=\"txtBlack8\" style=\"vertical-align: middle;\" nowrap>{item.name}</td><td id=\"txtBlack8\" style=\"vertical-align: middle;\" nowrap align=\"right\">{item.quantity}</td><td nowrap align=\"left\"><span class=\"errorSmall\">*</span><select class='costCodeClass' name='{item.id}_select' id='{item.id}_select' style=\"width: 90%;\">" + text.ToString() + "</select></td></tr>;";
                    var chargecostCode = new d_cost_code_dal().GetSingleCostCode((long)item.object_id);
                    if (chargecostCode != null)
                    {
                        scriptText += $"$('#{item.id}_select').val('{chargecostCode.id}');";
                    }
                    
                }
            }
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script> $(\"#thisBody\").html("+thisHtml+");</script>");
            // document.getElementsByClassName('Workspace1')[0].style.display = 'none';document.getElementsByClassName('Workspace4')[0].style.display = 'none';document.getElementsByClassName('Workspace5')[0].style.display = '';
        }
    }
}