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
        protected bool isSaleOrder = false;  // 是否是销售订单
        protected List<ivt_reserve> thisReserList = null;
        protected long? saleOrderId = null;  // 销售订单ID
        protected long quote_id;             // 报价ID
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                isSaleOrder = !string.IsNullOrEmpty(Request.QueryString["isSaleOrder"]);
                var sId = Request.QueryString["sale_order_id"];
                if (!string.IsNullOrEmpty(sId))
                {
                    saleOrderId = long.Parse(sId);
                }


                type = Request.QueryString["type_id"];             // 报价项类型
                var quote_id = Request.QueryString["quote_id"];    // 报价ID 需要根据报价ID 添加报价项
                if (!string.IsNullOrEmpty(quote_id))
                {
                    this.quote_id = long.Parse(quote_id);
                }
                var quote_item_id = Request.QueryString["id"];
                thisQuoteId.Value = quote_id;
                dic = new QuoteItemBLL().GetField();
                if (!string.IsNullOrEmpty(quote_item_id))
                {
                    quote_item = new crm_quote_item_dal().GetQuoteItem(long.Parse(quote_item_id));
                    if (quote_item != null)
                    {
                        if (quote_item.quote_id != null)
                        {
                            this.quote_id = (long)quote_item.quote_id;
                        }
                        isAdd = false;
                        if (!IsPostBack)
                        {
                            _optional.Checked = quote_item.optional == 1;
                        }
                        ItemTypeId.Value = quote_item.type_id.ToString();

                        switch (quote_item.type_id)   // todo 不同类型的报价项
                        {
                            case (int)QUOTE_ITEM_TYPE.WORKING_HOURS:
                                type = "工时";
                                break;
                            case (int)QUOTE_ITEM_TYPE.COST:
                                type = "费用";
                                break;
                            case (int)QUOTE_ITEM_TYPE.DEGRESSION:
                                type = "成本";
                                break;
                            case (int)QUOTE_ITEM_TYPE.DISCOUNT:
                                type = "折扣";
                                break;
                            case (int)QUOTE_ITEM_TYPE.PRODUCT:
                                type = "产品";
                                break;
                            case (int)QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                type = "配送费用";
                                break;
                            case (int)QUOTE_ITEM_TYPE.SERVICE:
                                type = "服务";
                                break;
                            case (int)QUOTE_ITEM_TYPE.START_COST:
                                type = "初始费用";
                                break;
                            default:
                                break;
                        }
                    }
                }
                else
                {
                    ItemTypeId.Value = type;
                    switch (Convert.ToInt64(type))   // todo 不同类型的报价项
                    {
                        case (int)QUOTE_ITEM_TYPE.WORKING_HOURS:
                            type = "工时";
                            break;
                        case (int)QUOTE_ITEM_TYPE.COST:
                            type = "费用";
                            break;
                        case (int)QUOTE_ITEM_TYPE.DEGRESSION:
                            type = "成本";
                            break;
                        case (int)QUOTE_ITEM_TYPE.DISCOUNT:
                            type = "折扣";
                            break;
                        case (int)QUOTE_ITEM_TYPE.PRODUCT:
                            type = "产品";
                            break;
                        case (int)QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                            type = "配送费用";
                            break;
                        case (int)QUOTE_ITEM_TYPE.SERVICE:
                            type = "服务";
                            break;
                        case (int)QUOTE_ITEM_TYPE.START_COST:
                            type = "初始费用";
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
                period_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                period_type_id.SelectedValue = ((int)QUOTE_ITEM_PERIOD_TYPE.ONE_TIME).ToString();
                period_type_id.Enabled = true;
                #endregion


                if (!isAdd)
                {
                    if (quote_item.tax_cate_id != null)
                    {
                        tax_cate_id.SelectedValue = quote_item.tax_cate_id.ToString();
                    }
                    if (quote_item.period_type_id != null)
                    {
                        period_type_id.SelectedValue = quote_item.period_type_id.ToString();
                    }
                    if (quote_item.type_id == (int)DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT)
                    {
                        thisReserList = new ivt_reserve_dal().GetListByItemId(quote_item.id);
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
            Dictionary<long, int> wareDic = null;
            var param = GetParam(out wareDic);
            var result = DTO.ERROR_CODE.SUCCESS;
            if (isAdd)
            {
                if (isSaleOrder)
                {
                    result = new QuoteItemBLL().Insert(param, wareDic, GetLoginUserId(), true, saleOrderId);
                }
                else
                {
                    result = new QuoteItemBLL().Insert(param, wareDic, GetLoginUserId());
                }

            }
            else
            {
                if (isSaleOrder)
                {
                    result = new QuoteItemBLL().Update(param, wareDic, GetLoginUserId(), true, saleOrderId);
                }
                else
                {
                    result = new QuoteItemBLL().Update(param, wareDic, GetLoginUserId());
                }

            }
            switch (result)
            {
                case DTO.ERROR_CODE.SUCCESS:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存报价项成功');window.close();self.opener.location.reload();</script>");
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

        protected void save_new_Click(object sender, EventArgs e)
        {
            Dictionary<long, int> wareDic = null;
            var param = GetParam(out wareDic);
            var result = DTO.ERROR_CODE.SUCCESS;
            if (isAdd)
            {
                if (isSaleOrder)
                {
                    result = new QuoteItemBLL().Insert(param, wareDic, GetLoginUserId(), true, saleOrderId);
                }
                else
                {
                    result = new QuoteItemBLL().Insert(param, wareDic, GetLoginUserId());
                }

            }
            else
            {
                if (isSaleOrder)
                {
                    result = new QuoteItemBLL().Update(param, wareDic, GetLoginUserId(), true, saleOrderId);
                }
                else
                {
                    result = new QuoteItemBLL().Update(param, wareDic, GetLoginUserId());
                }

            }

            switch (result)
            {
                case DTO.ERROR_CODE.SUCCESS:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存报价项成功');self.opener.location.reload();location.href = 'QuoteItemAddAndUpdate.aspx?type_id=" + param.type_id + "&quote_id=" + param.quote_id + "&isSaleOrder=" + Request.QueryString["isSaleOrder"] + "&sale_order_id=" + Request.QueryString["sale_order_id"] + "';</script>");
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


        private crm_quote_item GetParam(out Dictionary<long, int> wareDic)
        {
            var quote_item = AssembleModel<crm_quote_item>();
            quote_item.optional = Convert.ToUInt64(_optional.Checked ? 1 : 0);
            quote_item.period_type_id = quote_item.period_type_id == 0 ? null : quote_item.period_type_id;
            if (isAdd)
            {
                quote_item.type_id = int.Parse(Request.Form["ItemTypeId"]);
                quote_item.quote_id = int.Parse(Request.QueryString["quote_id"]);
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
                quote_item.oid = this.quote_item.oid;
            }
            wareDic = new Dictionary<long, int>();
            switch (quote_item.type_id)
            {
                case (int)QUOTE_ITEM_TYPE.WORKING_HOURS:

                    break;
                case (int)QUOTE_ITEM_TYPE.COST:

                    break;
                case (int)QUOTE_ITEM_TYPE.DEGRESSION:

                    break;
                case (int)QUOTE_ITEM_TYPE.DISCOUNT:

                    break;
                case (int)QUOTE_ITEM_TYPE.PRODUCT:
                    var wareIds = Request.Form["wareIds"];
                    if (!string.IsNullOrEmpty(wareIds))
                    {
                        var wareIdArr = wareIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        foreach (var wareId in wareIdArr)
                        {
                            var thisAvailable = Request.Form[wareId + "_available"];
                            var hand = Request.Form[wareId + "_hand"];
                            var use = Request.Form[wareId + "_use"];
                            if (!string.IsNullOrEmpty(thisAvailable))
                            {
                                wareDic.Add(long.Parse(wareId), int.Parse(thisAvailable));
                            }
                        }
                    }
                    break;
                case (int)QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:

                    break;
                case (int)QUOTE_ITEM_TYPE.SERVICE:
                    var opBLL = new OpportunityBLL();
                    if (quote_item.object_id != null)
                    {
                        if (opBLL.isServiceOrBag((long)quote_item.object_id) == 1)
                        {
                            var service = new ivt_service_dal().GetSinService((long)quote_item.object_id);
                            if (service != null)
                            {
                                quote_item.period_type_id = service.period_type_id;
                            }
                        }
                        else if (opBLL.isServiceOrBag((long)quote_item.object_id) == 1)
                        {
                            var serviceBundle = new ivt_service_bundle_dal().GetSinSerBun((long)quote_item.object_id);
                            if (serviceBundle != null)
                            {
                                quote_item.period_type_id = serviceBundle.period_type_id;
                            }
                        }
                    }
                    break;
                case (int)QUOTE_ITEM_TYPE.START_COST:
                    quote_item.period_type_id = (int)QUOTE_ITEM_PERIOD_TYPE.ONE_TIME;
                    break;
                default:
                    break;
            }

            return quote_item;
        }
    }
}