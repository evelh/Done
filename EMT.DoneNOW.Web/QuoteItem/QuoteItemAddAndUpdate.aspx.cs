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
                var quote_id = Request.QueryString["quote_id"];    // 报价ID 需要根据报价ID 添加报价项
                var quote_item_id = Request.QueryString["id"];

                dic = new QuoteItemBLL().GetField();
                if (!string.IsNullOrEmpty(quote_item_id))
                {
                    quote_item = new crm_quote_item_dal().GetQuoteItem(long.Parse(quote_item_id));
                    if (quote_item != null)
                    {
                        isAdd = false;
                        _optional.Checked = quote_item.optional == 1;
                        switch (quote_item.type_id)   // todo 不同类型的报价项
                        {
                            case (int)QUOTE_ITEM_TYPE.WORKING_HOURS:
                                type = "工时";
                                break;
                            case (int)QUOTE_ITEM_TYPE.COST:
                                break;
                            case (int)QUOTE_ITEM_TYPE.DEGRESSION:
                                type = "";
                                break;
                            case (int)QUOTE_ITEM_TYPE.DISCOUNT:
                                break;
                            case (int)QUOTE_ITEM_TYPE.PRODUCT:
                                type = "产品";
                                break;
                            case (int)QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                break;
                            default:
                                Response.End();  // 未传类型，暂不创建
                                break;
                        }
                    }
                }
                else
                {
                    switch (Convert.ToInt64(type))   // todo 不同类型的报价项
                    {
                        case (int)QUOTE_ITEM_TYPE.WORKING_HOURS:
                            type = "工时";
                            break;
                        case (int)QUOTE_ITEM_TYPE.COST:
                            break;
                        case (int)QUOTE_ITEM_TYPE.DEGRESSION:
                            type = "";
                            break;
                        case (int)QUOTE_ITEM_TYPE.DISCOUNT:
                            break;
                        case (int)QUOTE_ITEM_TYPE.PRODUCT:
                            type = "产品";
                            break;
                        case (int)QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                            break;
                        default:
                            Response.End();  // 未传类型，暂不创建
                            break;
                    }
                }
                //if (string.IsNullOrEmpty(quote_id))
                //{
                //    //Response.End();
                //}


               // var type_id = Convert.ToInt64(type);
  

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
                period_type_id.Enabled = true;
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
            quote_item.optional = Convert.ToUInt64(_optional.Checked ? 1 : 0);
            if (isAdd)
            {
                quote_item.type_id = int.Parse(Request.QueryString["type_id"]);
                quote_item.quote_id = int.Parse(Request.QueryString["quote_id"]);
                var result = new QuoteItemBLL().Insert(quote_item,GetLoginUserId());
                switch (result)
                {
                    case DTO.ERROR_CODE.SUCCESS:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('添加报价项成功');window.close();self.opener.location.reload();</script>");
                        break;
                    case DTO.ERROR_CODE.ERROR:
                        break;
                    case DTO.ERROR_CODE.PARAMS_ERROR:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写');</script>");
                        break;
                    case DTO.ERROR_CODE.USER_NOT_FIND:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('用户信息丢失');</script>");
                        Response.Redirect("../login.aspx");
                        break;
                    default:
                        break;
                }
            }
            else
            {
                quote_item.type_id = this.quote_item.type_id;
                quote_item.create_time = this.quote_item.create_time;
                quote_item.create_user_id = this.quote_item.create_user_id;
                quote_item.update_time = this.quote_item.update_time;
                quote_item.update_user_id = this.quote_item.update_user_id;
                quote_item.id = this.quote_item.id;
                quote_item.quote_id = this.quote_item.quote_id;
                var result = new QuoteItemBLL().Update(quote_item, GetLoginUserId());
                switch (result)
                {
                    case DTO.ERROR_CODE.SUCCESS:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改报价项成功');window.close();self.opener.location.reload();</script>");
                        break;
                    case DTO.ERROR_CODE.ERROR:
                        break;
                    case DTO.ERROR_CODE.PARAMS_ERROR:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写');</script>");
                        break;
                    case DTO.ERROR_CODE.USER_NOT_FIND:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('用户信息丢失');</script>");
                        Response.Redirect("../login.aspx");
                        break;
                    default:
                        break;
                }
            }



        }

        protected void save_new_Click(object sender, EventArgs e)
        {
            var quote_item = AssembleModel<crm_quote_item>();
            quote_item.optional = Convert.ToUInt64(_optional.Checked ? 1 : 0);
            if (isAdd)
            {
                quote_item.type_id = int.Parse(Request.QueryString["type_id"]);
                quote_item.quote_id = int.Parse(Request.QueryString["quote_id"]);
                var result = new QuoteItemBLL().Insert(quote_item, GetLoginUserId());
                switch (result)
                {
                    case DTO.ERROR_CODE.SUCCESS:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('添加报价项成功');</script>");
                        Response.Write("QuoteItemAddAndUpdate.aspx?type_id="+type+ "&quote_id"+quote_item.quote_id);
                       // E:\DoneNOW\EMT.DoneNOW.Web\QuoteItem\QuoteItemAddAndUpdate.aspx
                        break;
                    case DTO.ERROR_CODE.ERROR:
                        break;
                    case DTO.ERROR_CODE.PARAMS_ERROR:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写');</script>");
                        break;
                    case DTO.ERROR_CODE.USER_NOT_FIND:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('用户信息丢失');</script>");
                        Response.Redirect("../login.aspx");
                        break;
                    default:
                        break;
                }
            }
            else
            {
                quote_item.type_id = this.quote_item.type_id;
                quote_item.create_time = this.quote_item.create_time;
                quote_item.create_user_id = this.quote_item.create_user_id;
                quote_item.update_time = this.quote_item.update_time;
                quote_item.update_user_id = this.quote_item.update_user_id;
                quote_item.id = this.quote_item.id;
                quote_item.quote_id = this.quote_item.quote_id;
                var result = new QuoteItemBLL().Update(quote_item, GetLoginUserId());
                switch (result)
                {
                    case DTO.ERROR_CODE.SUCCESS:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改报价项成功');</script>");
                        Response.Write("QuoteItemAddAndUpdate.aspx?type_id=" + type+"&id="+quote_item.id + "&quote_id" + quote_item.quote_id);
                        break;
                    case DTO.ERROR_CODE.ERROR:
                        break;
                    case DTO.ERROR_CODE.PARAMS_ERROR:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写');</script>");
                        break;
                    case DTO.ERROR_CODE.USER_NOT_FIND:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('用户信息丢失');</script>");
                        Response.Redirect("../login.aspx");
                        break;
                    default:
                        break;
                }
            }

        }
    }
}