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

namespace EMT.DoneNOW.Web.Quote
{
    public partial class QuoteAddAndUpdate : BasePage
    {
        protected crm_opportunity opportunity = new crm_opportunity();
        protected crm_quote quote = null;
        protected bool isAdd = true;
        protected CompanyBLL companyBLL = new CompanyBLL();
        protected Dictionary<string, object> dic = null;
        protected crm_account account = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                dic = new QuoteBLL().GetField();
                #region 下拉框配置数据源
                tax_region_id.DataValueField = "val";
                tax_region_id.DataTextField = "show";
                tax_region_id.DataSource = dic.FirstOrDefault(_ => _.Key == "taxRegion").Value;
                tax_region_id.DataBind();
                tax_region_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                payment_term_id.DataValueField = "val";
                payment_term_id.DataTextField = "show";
                payment_term_id.DataSource = dic.FirstOrDefault(_ => _.Key == "payment_term").Value;
                payment_term_id.DataBind();
                payment_term_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });


                payment_type_id.DataValueField = "val";
                payment_type_id.DataTextField = "show";
                payment_type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "payment_type").Value;
                payment_type_id.DataBind();
                payment_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                shipping_type_id.DataValueField = "val";
                shipping_type_id.DataTextField = "show";
                shipping_type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "payment_ship_type").Value;
                shipping_type_id.DataBind();
                shipping_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                quote_tmpl_id.DataValueField = "id";
                quote_tmpl_id.DataTextField = "name";
                quote_tmpl_id.DataSource = dic.FirstOrDefault(_ => _.Key == "quote_tmpl").Value;
                quote_tmpl_id.DataBind();
                quote_tmpl_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                #endregion

                if (!string.IsNullOrEmpty(id))
                {
                    quote = new crm_quote_dal().GetQuote(Convert.ToInt64(id));
                    if (quote != null)
                    {
                        isAdd = false;

                    }

                }
                else
                {
                    var opportunity_id = Request.QueryString["quote_opportunity_id"];
                    if (!string.IsNullOrEmpty(opportunity_id))
                    {
                        opportunity = new crm_opportunity_dal().GetOpportunityById(long.Parse(opportunity_id));
                        account = new CompanyBLL().GetCompany(opportunity.account_id);
                    }

                }
                if (!IsPostBack)
                {
                    if (!isAdd)
                    {
                        account = new CompanyBLL().GetCompany(quote.account_id);
                        if (account != null)
                        {
                            tax_region_id.SelectedValue = account.tax_region_id != null ? account.tax_region_id.ToString() : "0";
                            payment_term_id.SelectedValue = quote.payment_term_id != null ? quote.payment_term_id.ToString() : "0";
                            payment_type_id.SelectedValue = quote.payment_type_id != null ? quote.payment_type_id.ToString() : "0"; //shipping_type_id
                            shipping_type_id.SelectedValue = quote.shipping_type_id != null ? quote.shipping_type_id.ToString() : "0";
                            quote_tmpl_id.SelectedValue = quote.quote_tmpl_id != null ? quote.quote_tmpl_id.ToString() : "0";
                            BillLocation.Checked = quote.bill_to_location_id == quote.sold_to_location_id;
                            ShipLocation.Checked = quote.ship_to_location_id == quote.sold_to_location_id;
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
        /// 保存并关闭
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_close_Click(object sender, EventArgs e)
        {

            var quote = new crm_quote();
            quote = AssembleModel<crm_quote>();
            quote = LocationDeal(quote);
            var bill = BillLocation.Checked;
            if (isAdd)
            {
                var result = new QuoteBLL().Insert(quote, GetLoginUserId());
                switch (result)
                {
                    case ERROR_CODE.SUCCESS:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('添加报价成功！');window.close();</script>");
                        break;
                    case ERROR_CODE.ERROR:
                        break;
                    case ERROR_CODE.PARAMS_ERROR:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写！');</script>");
                        break;
                    case ERROR_CODE.USER_NOT_FIND:
                        Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                        Response.Redirect("Login.aspx");
                        break;
                    default:
                        break;
                }


            }
            else
            {
                var result = new QuoteBLL().Update(quote, GetLoginUserId());
                switch (result)
                {
                    case ERROR_CODE.SUCCESS:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改报价成功！');window.close();</script>");
                        break;
                    case ERROR_CODE.ERROR:
                        break;
                    case ERROR_CODE.PARAMS_ERROR:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写！');</script>");
                        break;
                    case ERROR_CODE.USER_NOT_FIND:
                        Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                        Response.Redirect("Login.aspx");
                        break;
                    default:
                        break;
                }
            }
        }

        protected void save_open_quote_Click(object sender, EventArgs e)
        {
            var quote = new crm_quote();
            quote = AssembleModel<crm_quote>();
            quote = LocationDeal(quote);
            if (isAdd)
            {
                var result = new QuoteBLL().Insert(quote, GetLoginUserId());
                switch (result)
                {
                    case ERROR_CODE.SUCCESS:  //E:\DoneNOW\EMT.DoneNOW.Web\QuoteItem\QuoteItemManage.aspx
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('添加报价成功！');window.open('../QuoteItem/QuoteItemManage.aspx?quote_id=" + quote.id.ToString() + "','" + OpenWindow.QuoteItemManage + "','left=200,top=200,width=960,height=750', false);</script>");
                        break;
                    case ERROR_CODE.ERROR:
                        break;
                    case ERROR_CODE.PARAMS_ERROR:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写！');</script>");
                        break;
                    case ERROR_CODE.USER_NOT_FIND:
                        Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                        Response.Redirect("Login.aspx");
                        break;
                    default:
                        break;
                }
            }
            else
            {
                var result = new QuoteBLL().Update(quote, GetLoginUserId());
                switch (result)
                {
                    case ERROR_CODE.SUCCESS:
                        // ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改报价成功！');window.close();</script>");
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改报价成功！');window.open('../QuoteItem/QuoteItemManage.aspx?quote_id=" + quote.id.ToString() + "','" + OpenWindow.QuoteItemManage + "','left=200,top=200,width=960,height=750', false);</script>");
                        break;
                    case ERROR_CODE.ERROR:
                        break;
                    case ERROR_CODE.PARAMS_ERROR:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写！');</script>");
                        break;
                    case ERROR_CODE.USER_NOT_FIND:
                        Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                        Response.Redirect("Login.aspx");
                        break;
                    default:
                        break;
                }
            }
        }

        protected crm_quote LocationDeal(crm_quote quote)
        {
            try
            {
                // 账单地址和配送地址新增删除处理
                // 首先要整理称谓地址对象  与默认地址的相同更改校验
                // 校验地址必填信息
                // 然后判断新增还是修改进行操作
                var sold_location_id = Request.Params["sold_to_location_id"];

                var old_sold_location = new LocationBLL().GetLocation(long.Parse(sold_location_id));
                if (old_sold_location == null)
                {
                    return quote;
                }
                var sold_location = new crm_location()
                {
                    id = old_sold_location.id,
                    account_id = old_sold_location.account_id,
                    cate_id = old_sold_location.cate_id,
                    create_time = old_sold_location.create_time,
                    create_user_id = old_sold_location.create_user_id,
                    delete_time = old_sold_location.delete_time,
                    delete_user_id = old_sold_location.delete_user_id,
                    is_default = old_sold_location.is_default,
                    location_label = old_sold_location.location_label,
                    oid = old_sold_location.is_default,
                    additional_address = Request.Params["address2"],
                    address = Request.Params["address"],
                    city_id = string.IsNullOrEmpty(Request.Params["city_id"]) ? 0 : int.Parse(Request.Params["city_id"]),
                    country_id = old_sold_location.country_id,
                    district_id = string.IsNullOrEmpty(Request.Params["district_id"]) ? 0 : int.Parse(Request.Params["district_id"]),
                    postal_code = Request.Params["postal_code"],
                    province_id = string.IsNullOrEmpty(Request.Params["province_id"]) ? 0 : int.Parse(Request.Params["province_id"]),
                    town_id = old_sold_location.town_id,
                };
                if (sold_location.country_id != 0 && sold_location.province_id != 0 && sold_location.city_id != 0 && sold_location.district_id != 0 && (!string.IsNullOrEmpty(sold_location.address)))
                {
                    sold_location.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    sold_location.update_user_id = GetLoginUserId();
                    new LocationBLL().Update(sold_location, GetLoginUserId());
                }

                if (BillLocation.Checked)
                {
                    quote.bill_to_location_id = quote.sold_to_location_id;
                }
                else
                {
                    var bill_id = Request.Params["bill_to_location_id"];
                    var bill_location = new crm_location()
                    {
                        //id = long.Parse(bill_id),
                        account_id = quote.account_id,
                        additional_address = Request.Params["bill_address2"],
                        address = Request.Params["bill_address"],
                        city_id = string.IsNullOrEmpty(Request.Params["bill_city_id"]) ? 0 : int.Parse(Request.Params["bill_city_id"]),
                        country_id = 1,
                        district_id = string.IsNullOrEmpty(Request.Params["bill_district_id"]) ? 0 : int.Parse(Request.Params["bill_district_id"]),
                        is_default = 0,
                        province_id = string.IsNullOrEmpty(Request.Params["bill_province_id"]) ? 0 : int.Parse(Request.Params["bill_province_id"]),
                        postal_code = Request.Params["bill_postcode"],

                    };
                    // 地址必填项未填写暂时不处理？？？
                    if (bill_location.country_id != 0 && bill_location.province_id != 0 && bill_location.city_id != 0 && bill_location.district_id != 0 && (!string.IsNullOrEmpty(bill_location.address)))
                    {
                        if (!string.IsNullOrEmpty(bill_id))  // 用户界面上存在账单地址 此时代表和客户默认地址相同或者是在更改地址
                        {
                            if(bill_id== sold_location_id)
                            {
                                if (bill_location.city_id != sold_location.city_id || bill_location.city_id != sold_location.city_id || bill_location.district_id != sold_location.district_id || bill_location.address != sold_location.address || bill_location.additional_address != sold_location.additional_address || bill_location.postal_code != sold_location.postal_code)
                                {
                                    bill_location.id = new crm_location_dal().GetNextIdCom();
                                    if (new LocationBLL().Insert(bill_location, GetLoginUserId()))
                                    {
                                        quote.bill_to_location_id = bill_location.id;
                                    }
                                }
                            }
                            else
                            {
                                bill_location.id = long.Parse(bill_id);
                                new LocationBLL().Update(bill_location, GetLoginUserId());

                            }
                          
                           
                        }
                        else
                        {
                            bill_location.id = new crm_location_dal().GetNextIdCom();
                            if (new LocationBLL().Insert(bill_location, GetLoginUserId()))
                            {
                                quote.bill_to_location_id = bill_location.id;
                            }
                        }
                    }

                }

                if (ShipLocation.Checked)
                {
                    quote.ship_to_location_id = quote.sold_to_location_id;
                }
                else
                {
                    var ship_id = Request.Params["ship_to_location_id"];
                    var ship_location = new crm_location()
                    {
                        //id = long.Parse(bill_id),
                        account_id = quote.account_id,
                        additional_address = Request.Params["ship_address2"],
                        address = Request.Params["ship_address"],
                        city_id = string.IsNullOrEmpty(Request.Params["ship_city_id"]) ? 0 : int.Parse(Request.Params["ship_city_id"]),
                        country_id = 1,
                        district_id = string.IsNullOrEmpty(Request.Params["ship_district_id"]) ? 0 : int.Parse(Request.Params["ship_district_id"]),
                        is_default = 0,
                        province_id = string.IsNullOrEmpty(Request.Params["ship_province_id"]) ? 0 : int.Parse(Request.Params["ship_province_id"]),
                        postal_code = Request.Params["ship_postcode"],

                    };
                    // 地址必填项未填写暂时不处理？？？
                    if (ship_location.country_id != 0 && ship_location.province_id != 0 && ship_location.city_id != 0 && ship_location.district_id != 0 && (!string.IsNullOrEmpty(ship_location.address)))
                    {
                        if (!string.IsNullOrEmpty(ship_id))  // 用户界面上存在账单地址 此时代表和客户默认地址相同或者是在更改地址
                        {
                            if (ship_id == sold_location_id)
                            {
                                if (ship_location.city_id != sold_location.city_id || ship_location.city_id != sold_location.city_id || ship_location.district_id != sold_location.district_id || ship_location.address != sold_location.address || ship_location.additional_address != sold_location.additional_address || ship_location.postal_code != sold_location.postal_code)
                                {
                                    ship_location.id = new crm_location_dal().GetNextIdCom();
                                    if (new LocationBLL().Insert(ship_location, GetLoginUserId()))
                                    {
                                        quote.ship_to_location_id = ship_location.id;
                                    }
                                }
                            }
                            else
                            {
                                ship_location.id = long.Parse(ship_id);
                                new LocationBLL().Update(ship_location, GetLoginUserId());
                            }
                        }
                        else
                        {
                            ship_location.id = new crm_location_dal().GetNextIdCom();
                            if (new LocationBLL().Insert(ship_location, GetLoginUserId()))
                            {
                                quote.ship_to_location_id = ship_location.id;
                            }
                        }
                    }
                }





            }
            catch (Exception)
            {


            }
            return quote;


        }
    }
}