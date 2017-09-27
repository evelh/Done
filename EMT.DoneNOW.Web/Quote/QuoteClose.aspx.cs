using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System.Text;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.Quote
{
    public partial class QuoteClose : BasePage
    {
        protected crm_quote quote = null;
        protected List<crm_quote_item> quoteItemList = null;
        protected crm_opportunity opportunity = null;
        protected sys_system_setting wonSetting = new SysSettingBLL().GetSetById(SysSettingEnum.CRM_OPPORTUNITY_WIN_REASON);
        protected Dictionary<string, object> dic = new OpportunityBLL().GetField();
        protected List<crm_quote_item> serviceItem = null; // 该报价下的服务报价项
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var quote_id = Request.QueryString["id"];
                quote = new QuoteBLL().GetQuote(long.Parse(quote_id));
                if(quote.is_primary_quote != 1) // 关闭报价只针对主报价
                {
                    Response.Write("<script>alert('关闭报价只针对主报价');window.close();</script>");
                }
                if (quote.project_id == null)
                {
                    Response.Write("<script>alert('请关联项目后进行关闭报价操作');window.close();</script>");
                }
                opportunity = new crm_opportunity_dal().GetOpportunityById(quote.opportunity_id);
                win_reason_type_id.DataTextField = "show";
                win_reason_type_id.DataValueField = "val";
                win_reason_type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "oppportunity_win_reason_type").Value;
                win_reason_type_id.DataBind();
                win_reason_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                win_reason_type_id.SelectedValue = opportunity.win_reason_type_id == null ? "0" : opportunity.win_reason_type_id.ToString();


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
                var disSource = "";
                var disCostCode = costCode.Where(_ => _.id == 37 || _.id == 43).ToList();
                if (disCostCode != null && disCostCode.Count > 0)
                {
                    foreach (var item in disCostCode)
                    {
                        disSource += $"<option value='{item.id}'>{item.name}</option>";
                    }
                }
                disCodeSelct.Value = disSource;


                quoteItemList = new crm_quote_item_dal().GetQuoteItems($"and quote_id = {quote.id}");
                quoteItemList = quoteItemList.Where(_ => _.optional == 0&&_.type_id!=(int)QUOTE_ITEM_TYPE.COST&& _.type_id != (int)QUOTE_ITEM_TYPE.SERVICE&& _.type_id != (int)QUOTE_ITEM_TYPE.WORKING_HOURS).ToList();
                if (quoteItemList != null && quoteItemList.Count > 0)
                {
                     serviceItem = quoteItemList.Where(_ => _.type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.SERVICE|| _.type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.START_COST).ToList();
                    if (serviceItem != null && serviceItem.Count > 0)
                    {
                        Response.Write("<script>alert('报价中包含服务/包、初始费用等,请使用关闭商机向导');window.close();</script>");
                    }

                    jqueryCode.Value = ReturnJquery();
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }



        /// <summary>
        /// 为页面上的下拉框赋值的jquery
        /// </summary>
        /// <returns></returns>
        private string ReturnJquery()
        {
            var scriptText = "";
            if (quoteItemList != null && quoteItemList.Count > 0)
            {
                foreach (var item in quoteItemList)
                {
                    if (item.object_id != null)
                    {
                        if (item.type_id == (int)QUOTE_ITEM_TYPE.PRODUCT)
                        {
                            var product = new EMT.DoneNOW.BLL.ProductBLL().GetProduct((long)item.object_id);
                            if (product != null)
                            {
                                scriptText += $"$('#{item.id}_select').val({product.cost_code_id});";
                            }
                        }
                        if(item.type_id == (int)QUOTE_ITEM_TYPE.DEGRESSION)
                        {
                            scriptText += $"$('#{item.id}_select').val({item.object_id});";
                        }
                    }
                }
            }
            return scriptText;
        }

        protected void finish_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var result = new QuoteBLL().CloseQuote(GetLoginUserId(),param);
            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                    ClientScript.RegisterStartupScript(this.GetType(), "显示页面", "<script>document.getElementsByClassName('Workspace1')[0].style.display = 'none';document.getElementsByClassName('Workspace3')[0].style.display = 'none';document.getElementsByClassName('Workspace4')[0].style.display = '';</script>");
                    if (param.saleOrderId != null)  
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "显示销售订单", "<script>document.getElementsByClassName('ShowSaleOrder')[0].style.display = '';document.getElementById('newSaleOrderId').value = '" + param.saleOrderId+"';</script>"); 
                    }
                    break;
                case ERROR_CODE.PARAMS_ERROR:
                    break;
                case ERROR_CODE.USER_NOT_FIND:
                    break;
                default:
                    break;
            }
        }
        /// <summary>
        /// 获取到关闭报价需要的参数
        /// </summary>
        /// <returns></returns>
        protected QuoteCloseDto GetParam()
        {
            QuoteCloseDto param = new QuoteCloseDto();
            opportunity.win_reason_type_id = int.Parse(Request.Form["win_reason_type_id"]);
            opportunity.win_reason = Request.Form["win_reason"];
            param.opportunity = opportunity;
            param.quote = quote;


            if (quoteItemList != null && quoteItemList.Count > 0)
            {
                Dictionary<long, string> dic = new Dictionary<long, string>();
                foreach (var item in quoteItemList)
                {
                    dic.Add(item.id, Request.Form[item.id.ToString() + "_select"]);
                }
                param.dic = dic;
            }

            param.isCreateInvoice = Request.Form["ApproveAndPostType"] == "add";



            return param;
        }
    }
}