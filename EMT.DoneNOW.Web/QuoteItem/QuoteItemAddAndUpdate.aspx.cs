using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.QuoteItem
{
    public partial class QuoteItemAddAndUpdate : BasePage
    {
        protected crm_quote_item quote_item = null;
        protected bool isAdd = true;
        protected string type = "";
        protected Dictionary<string, object> dic = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                type = Request.QueryString["type_id"];             // 报价项类型
                var quote_id = Request.QueryString["quote_id"];    // 报价ID
                var quote_item_id = Request.QueryString["id"];

                dic = new QuoteItemBLL().GetField();
                if (!string.IsNullOrEmpty(quote_item_id))
                {
                    quote_item = new crm_quote_item_dal().GetQuoteItem(long.Parse(quote_item_id));
                    if (quote_item != null)
                    {
                        isAdd = false;
                    }
                }
                if (string.IsNullOrEmpty(quote_id))
                {
                    Response.End();
                }


               // var type_id = Convert.ToInt64(type);
                switch (Convert.ToInt64(type))   // todo 不同类型的报价项
                {
                    case (int)QUOTE_ITEM_TYPE.WORKING_HOURS:
                        type = "工时";
                        break;
                    case (int)QUOTE_ITEM_TYPE.COST:
                        break;
                    case (int)QUOTE_ITEM_TYPE.DEGRESSION:
                        type = "产品";
                        break;
                    case (int)QUOTE_ITEM_TYPE.DISCOUNT:
                        break;
                    case (int)QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                        break;
                    default:
                        Response.End();  // 未传类型，暂不创建
                        break;
                }

                #region 下拉框配置数据源
                // 税收种类
                tax_cate_id.DataTextField = "show";
                tax_cate_id.DataValueField = "val";
                tax_cate_id.DataSource = dic.FirstOrDefault(_ => _.Key == "quote_item_tax_cate").Value;
                tax_cate_id.DataBind();
                tax_cate_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                // 期间类型
                period_type_id.DataTextField = "show";
                period_type_id.DataValueField = "val";
                period_type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "quote_item_period_type").Value;
                period_type_id.DataBind();
                // period_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                period_type_id.SelectedValue = ((int)QUOTE_ITEM_PERIOD_TYPE.ONE_TIME).ToString();
                #endregion


                if (!isAdd)
                {
                    if (quote_item.tax_cate_id != null)
                    {
                        tax_cate_id.SelectedValue = quote_item.tax_cate_id.ToString();
                    }
                    if (quote_item.period_type_id!=null)
                    {
                        period_type_id.SelectedValue = quote_item.period_type_id.ToString();
                    }
                }

            }
            catch (Exception)
            {
                Response.End();
            }
        }
        /// <summary>
        /// 保存并关闭
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_close_Click(object sender, EventArgs e)
        {
            var quote_item = AssembleModel<crm_quote_item>();

            if (isAdd)
            {
                var result = new QuoteItemBLL().Insert(quote_item,GetLoginUserId());
                switch (result)
                {
                    case DTO.ERROR_CODE.SUCCESS:
                        break;
                    case DTO.ERROR_CODE.ERROR:
                        break;
                    case DTO.ERROR_CODE.PARAMS_ERROR:
                        break;

                    case DTO.ERROR_CODE.USER_NOT_FIND:
                        break;

                    default:
                        break;
                }
            }
            else
            {

            }



        }
    }
}