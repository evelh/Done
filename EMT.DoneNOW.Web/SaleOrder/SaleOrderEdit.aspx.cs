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

namespace EMT.DoneNOW.Web.SaleOrder
{
    public partial class SaleOrderEdit : BasePage
    {
        protected crm_sales_order sale_order = null;
        protected List<UserDefinedFieldDto> sale_udfList = null;        // 销售订单的自定义字段
        protected List<UserDefinedFieldValue> sale_udfValueList = null; // 销售订单的自定义字段的值
        protected crm_opportunity opportunity = null;
        protected Dictionary<string, object> dic = new SaleOrderBLL().GetField();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var soid = Request.QueryString["id"];
                sale_order = new crm_sales_order_dal().GetSingleSalesOrderByWhere($" and id = {soid}");
                if(sale_order!=null)
                {
                    sale_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.SALES);
                    sale_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.SALES,sale_order.id,sale_udfList);
                    opportunity = new crm_opportunity_dal().GetOpportunityById(sale_order.opportunity_id);
                    if (!IsPostBack)
                    {
                        var contactList = new crm_contact_dal().GetContactByAccountId(opportunity.account_id);


                        #region 下拉赋值
                        status_id.DataTextField = "show";
                        status_id.DataValueField = "val";
                        status_id.DataSource = dic.FirstOrDefault(_ => _.Key == "sales_order_status").Value;
                        status_id.DataBind();
                        status_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                   
                        owner_resource_id.DataTextField = "show";
                        owner_resource_id.DataValueField = "val";
                        owner_resource_id.DataSource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value;
                        owner_resource_id.DataBind();
                        owner_resource_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                        // bill_country_id
                        bill_country_id.DataTextField = "show";
                        bill_country_id.DataValueField = "val";
                        bill_country_id.DataSource = dic.FirstOrDefault(_ => _.Key == "country").Value;
                        bill_country_id.DataBind();
                        bill_country_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                        bill_country_id.SelectedValue = "1";

                        ship_country_id.DataTextField = "show";
                        ship_country_id.DataValueField = "val";
                        ship_country_id.DataSource = dic.FirstOrDefault(_ => _.Key == "country").Value;
                        ship_country_id.DataBind();
                        ship_country_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                        ship_country_id.SelectedValue = "1";
                        // contact_id
                        contact_id.DataTextField = "name";
                        contact_id.DataValueField = "id";
                        contact_id.DataSource = contactList.Where(_=>_.is_active==1).ToList();
                        contact_id.DataBind();
                        contact_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                        if (sale_order.contact_id != null)
                        {
                            contact_id.SelectedValue = sale_order.contact_id.ToString();
                        }
                        
                        #endregion
                        bill_to_use_account_address.Checked = sale_order.bill_to_use_account_address == 1;
                        ship_to_use_account_address.Checked = sale_order.ship_to_use_account_address == 1;
                        ship_to_use_bill_to_address.Checked = sale_order.ship_to_use_bill_to_address == 1;

                        status_id.SelectedValue = sale_order.status_id.ToString();
                        owner_resource_id.SelectedValue = sale_order.owner_resource_id.ToString();
                    }
                }
                else
                {
                    Response.End();
                }

            }
            catch (Exception)
            {

                Response.End();
            }
        }

        private crm_sales_order GetSales()
        {
            var new_sale_order = AssembleModel<crm_sales_order>();
            new_sale_order.id = sale_order.id;

            return new_sale_order;
        }
        private List<UserDefinedFieldValue> GetUdfValue()
        {
            if (sale_udfList != null && sale_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in sale_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);

                }
                return list;
            }
            return null;
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetSales();
            param = LocationDeal(param);
            var result = new SaleOrderBLL().EditSaleOrder(param,GetUdfValue(),GetLoginUserId());
            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改销售订单成功！');window.close();</script>");
                    break;
                case ERROR_CODE.PARAMS_ERROR:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写！');</script>");
                    break;
                case ERROR_CODE.USER_NOT_FIND:
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                    break;          
                default:
                    break;
            }

        }

        protected void save_open_Click(object sender, EventArgs e)
        {
            var param = GetSales();
            param = LocationDeal(param);
            var result = new SaleOrderBLL().EditSaleOrder(param, GetUdfValue(), GetLoginUserId());
            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                    Response.Write("<script>alert('修改销售订单成功！');");
                    Response.Redirect("../SaleOrder/SaleOrderView.aspx?id=" + sale_order.id);

                    break;

                case ERROR_CODE.PARAMS_ERROR:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写！');</script>");
                    break;
                case ERROR_CODE.USER_NOT_FIND:
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                    break;
                default:
                    break;
            }
        }

        /// <summary>
        /// 对页面上的地址相关信息的处理
        /// </summary>
        /// <param name="sale"></param>
        /// <returns></returns>
        private crm_sales_order LocationDeal(crm_sales_order sale)
        {
            var location_id = Request.Form["location_id"];
            var location = new LocationBLL().GetLocation(long.Parse(location_id));
            if (location == null)
            {
                return sale;
            }

            if (bill_to_use_account_address.Checked)
            {
                sale.bill_to_location_id = location.id;
            }
            else
            {
                var bill_id = Request.Params["billLocationId"];
                var bill_location = new crm_location()
                {
                    account_id = opportunity.account_id,
                    additional_address = Request.Params["bill_address2"],
                    address = Request.Params["bill_address"],
                    city_id = string.IsNullOrEmpty(Request.Params["bill_city_id"]) ? 0 : int.Parse(Request.Params["bill_city_id"]),
                    country_id = 1,
                    district_id = string.IsNullOrEmpty(Request.Params["bill_district_id"]) ? 0 : int.Parse(Request.Params["bill_district_id"]),
                    is_default = 0,
                    province_id = string.IsNullOrEmpty(Request.Params["bill_province_id"]) ? 0 : int.Parse(Request.Params["bill_province_id"]),
                    postal_code = Request.Params["bill_postcode"],
                };
                if (bill_location.country_id != 0 && bill_location.province_id != 0 && bill_location.city_id != 0 && bill_location.district_id != 0 && (!string.IsNullOrEmpty(bill_location.address)))
                {
                    if (!string.IsNullOrEmpty(bill_id)) // 修改
                    {
                        bill_location.id = long.Parse(bill_id);
                        new LocationBLL().Update(bill_location, GetLoginUserId());
                    }
                    else         // 新增
                    {
                        bill_location.id = new crm_location_dal().GetNextIdCom();
                        new LocationBLL().Insert(bill_location, GetLoginUserId());
                    }
                    sale.bill_to_location_id = bill_location.id;

                }
                else
                {
                    sale.bill_to_location_id = this.sale_order.bill_to_location_id;
                }
                    
            }


            if (ship_to_use_account_address.Checked)
            {
                sale.ship_to_location_id = location.id;
            }
            else
            {
                var ship_id = Request.Params["shipLocationId"];
                var ship_location = new crm_location()
                {
                    account_id = opportunity.account_id,
                    additional_address = Request.Params["ship_address2"],
                    address = Request.Params["ship_address"],
                    city_id = string.IsNullOrEmpty(Request.Params["ship_city_id"]) ? 0 : int.Parse(Request.Params["ship_city_id"]),
                    country_id = 1,
                    district_id = string.IsNullOrEmpty(Request.Params["ship_district_id"]) ? 0 : int.Parse(Request.Params["ship_district_id"]),
                    is_default = 0,
                    province_id = string.IsNullOrEmpty(Request.Params["ship_province_id"]) ? 0 : int.Parse(Request.Params["ship_province_id"]),
                    postal_code = Request.Params["ship_postcode"],
                };
                if (ship_location.country_id != 0 && ship_location.province_id != 0 && ship_location.city_id != 0 && ship_location.district_id != 0 && (!string.IsNullOrEmpty(ship_location.address)))
                {
                    if (!string.IsNullOrEmpty(ship_id))
                    {
                        ship_location.id = long.Parse(ship_id);
                        new LocationBLL().Update(ship_location, GetLoginUserId());
                    }
                    else
                    {
                        ship_location.id = new crm_location_dal().GetNextIdCom();
                        new LocationBLL().Insert(ship_location, GetLoginUserId());
                    }
                    sale.ship_to_location_id = ship_location.id;
                }
                else
                {
                    sale.ship_to_location_id = this.sale_order.ship_to_location_id;
                }
            }

            if (ship_to_use_bill_to_address.Checked)
            {
                sale.ship_to_location_id = sale.bill_to_location_id;
            }
          



            return sale;
        }

    }
}