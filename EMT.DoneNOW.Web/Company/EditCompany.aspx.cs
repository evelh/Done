﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web
{
    public partial class EditCompany : BasePage
    {
        /// <summary>
        /// 客户自定义字段
        /// </summary>
        protected List<UserDefinedFieldDto> company_udfList = null;
        protected List<UserDefinedFieldValue> company_udfValueList = null; //company
        protected List<UserDefinedFieldDto> site_udfList = null; // 站点自定义
        protected List<UserDefinedFieldValue> site_udfValueList = null; // 
        protected crm_account account = null;
        protected List<crm_location> location_list = null;   // 用户的所有地址
        protected crm_location location;
        // protected crm_location defaultLocation = null;
        //protected List<crm_account> searchCompany = null;     // 查询出的所有没有父客户的客户
        protected List<crm_account> subCompanyList = null;
        protected Dictionary<string, object> dic = null;
        protected sys_bookmark thisBookMark;
        protected List<d_country> counList = new DAL.d_country_dal().FindAll().ToList();
        protected void Page_Load(object sender, EventArgs e)
        {
            thisBookMark = new IndexBLL().GetSingBook(Request.RawUrl, LoginUserId);
            var company_id = Convert.ToInt64(Request.QueryString["id"]);
            if (AuthBLL.GetUserCompanyAuth(LoginUserId,LoginUser.security_Level_id,company_id).CanEdit==false)  // 权限验证
            {
                Response.End();
                return;
            }
            try
            {
                company_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.COMPANY);
                company_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.COMPANY, company_id, company_udfList);
                site_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.SITE);
                site_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.SITE, company_id, site_udfList);
                account = new CompanyBLL().GetCompany(company_id);
                location_list = new LocationBLL().GetLocationByCompany(company_id);
                // defaultLocation = new LocationBLL().GetLocationByAccountId(company_id);
                //if (!IsPostBack)
                //{
                // var company_id = Convert.ToInt64(Request.QueryString["id"]);

                if (account != null)
                {
                    subCompanyList = new crm_account_dal().GetMyCompany(account.id);
                    //searchCompany = new crm_account_dal().GetSubCompanys();
                    #region 为下拉框获取数据源
                    dic = new CompanyBLL().GetField();

                    // 分类类别
                    classification.DataTextField = "show";
                    classification.DataValueField = "val";
                    classification.DataSource = dic.FirstOrDefault(_ => _.Key == "classification").Value;
                    classification.DataBind();
                    classification.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                    // 公司类型
                    CompanyType.DataTextField = "show";
                    CompanyType.DataValueField = "val";
                    CompanyType.DataSource = dic.FirstOrDefault(_ => _.Key == "company_type").Value;
                    CompanyType.DataBind();
                    CompanyType.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                    // 市场领域
                    MarketSegment.DataTextField = "show";
                    MarketSegment.DataValueField = "val";
                    MarketSegment.DataSource = dic.FirstOrDefault(_ => _.Key == "market_segment").Value;
                    MarketSegment.DataBind();
                    MarketSegment.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                    // 销售区域
                    TerritoryName.DataTextField = "show";
                    TerritoryName.DataValueField = "val";
                    TerritoryName.DataSource = dic.FirstOrDefault(_ => _.Key == "territory").Value;
                    TerritoryName.DataBind();
                    TerritoryName.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                    // 客户经理
                    AccountManger.DataTextField = "show";
                    AccountManger.DataValueField = "val";
                    AccountManger.DataSource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value;
                    AccountManger.DataBind();
                    AccountManger.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                    // 税区
                    TaxRegion.DataTextField = "show";
                    TaxRegion.DataValueField = "val";
                    TaxRegion.DataSource = dic.FirstOrDefault(_ => _.Key == "taxRegion").Value;
                    TaxRegion.DataBind();
                    TaxRegion.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                    // 竞争对手
                    Competitor.DataTextField = "show";
                    Competitor.DataValueField = "val";
                    Competitor.DataSource = dic.FirstOrDefault(_ => _.Key == "competition").Value;
                    Competitor.DataBind();
                    Competitor.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                    #endregion

                    company_name.Text = account.name;
                    //isactive.Checked = account.is_active == 1;
                    
                    CompanyNumber.Text = account.no;
                    Phone.Text = account.phone;
                    AlternatePhone1.Text = account.alternate_phone1;
                    AlternatePhone2.Text = account.alternate_phone2;
                    Fax.Text = account.fax;
                    WebSite.Text = account.web_site;
                    is_optoutSurvey.Checked = account.is_optout_survey == 1;
                    mileage.Text = account.mileage == null ? "" : account.mileage.ToString();// todo decmail? 保留两位小数点？？
                    stock_symbol.Text = account.stock_symbol;
                    sic_code.Text = account.sic_code;
                    stock_market.Text = account.stock_market;
                    weibo_url.Text = account.weibo_url;
                    wechat_mp_service.Text = account.wechat_mp_service;
                    wechat_mp_subscription.Text = account.wechat_mp_subscription;

                    CompanyType.SelectedValue = account.type_id == null ? "0" : account.type_id.ToString();
                    AccountManger.SelectedValue =  account.resource_id == null ? "0" : account.resource_id.ToString();
                    TerritoryName.SelectedValue = account.territory_id == null ? "0" : account.territory_id.ToString();
                    MarketSegment.SelectedValue = account.market_segment_id == null ? "0" : account.market_segment_id.ToString();
                    Competitor.SelectedValue = account.competitor_id == null ? "0" : account.competitor_id.ToString();
                    Tax_Exempt.Checked = account.is_tax_exempt == 1;
                    TaxRegion.SelectedValue = account.tax_region_id == null ? "0" : account.tax_region_id.ToString();
                    classification.SelectedValue = account.classification_id == null ? "0" : account.classification_id.ToString();
                    
                    if (Tax_Exempt.Checked)
                    {
                        TaxRegion.Enabled = true;
                    }
                    TaxId.Text = account.tax_identification;
                    if (account.parent_id != null)
                    {
                        var parCompany = new CompanyBLL().GetCompany((long)this.account.parent_id);
                        ParentComoanyName.Text = parCompany == null ? "" : parCompany.name;  //父客户
                    }
                    asset_value.Text = account.asset_value.ToString();

                    location = new LocationBLL().GetLocationByAccountId(account.id);
                    if (location != null)        // 如果该客户的地址是默认地址，不可更改为非默认，只能通过添加别的地址设置为默认这种方式去更改默认地址
                    {
                        country_idInit.Value = location.country_id.ToString();
                        province_idInit.Value = location.province_id.ToString();
                        city_idInit.Value = location.city_id.ToString();
                        district_idInit.Value = location.district_id.ToString();
                        address.Text = location.address;
                        AdditionalAddress.Text = location.additional_address;
                    }

                    var company_detail_alert = new EMT.DoneNOW.DAL.crm_account_alert_dal().FindAlert(account.id, EMT.DoneNOW.DTO.DicEnum.ACCOUNT_ALERT_TYPE.COMPANY_DETAIL_ALERT);
                    var new_ticket_alert = new EMT.DoneNOW.DAL.crm_account_alert_dal().FindAlert(account.id, EMT.DoneNOW.DTO.DicEnum.ACCOUNT_ALERT_TYPE.NEW_TICKET_ALERT);
                    var ticket_detail_alert = new EMT.DoneNOW.DAL.crm_account_alert_dal().FindAlert(account.id, EMT.DoneNOW.DTO.DicEnum.ACCOUNT_ALERT_TYPE.TICKET_DETAIL_ALERT);

                    if (company_detail_alert != null)
                    {
                        Company_Detail_Alert.Text = company_detail_alert.alert_text;
                    }
                    if (new_ticket_alert != null)
                    {
                        New_Ticket_Alert.Text = new_ticket_alert.alert_text;
                    }
                    if (ticket_detail_alert != null)
                    {
                        Ticket_Detail_Alert.Text = ticket_detail_alert.alert_text;
                    }
                }
                else
                {
                    Response.End();
                }
                //}
            }
            catch (Exception)
            {

                Response.End();
            }



        }

        /// <summary>
        /// 保存并关闭 修改客户的点击事件
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = new CompanyUpdateDto();
            param.general_update = AssembleModel<CompanyUpdateDto.General_Update>();
            // param.general_update.is_active = (sbyte)(isactive.Checked ? 1 : 0);
            param.general_update.is_optout_survey = (sbyte)(is_optoutSurvey.Checked ? 1 : 0);
            param.general_update.taxExempt = Tax_Exempt.Checked;
            param.additional_info = AssembleModel<CompanyUpdateDto.Additional_Info>();
            param.alerts = AssembleModel<CompanyUpdateDto.Alerts>();
            param.site_configuration = AssembleModel<CompanyUpdateDto.Site_Configuration>();


            if (company_udfList != null && company_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in company_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);

                }
                param.general_update.udf = list;
            }

            if (site_udfList != null && site_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in site_udfValueList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);

                }
                param.site_configuration.udf = list;
            }

            //try
            //{out string updateLocationContact,out string updateFaxPhoneContact
            string updateLocationContact = "";
            string updateFaxPhoneContact = "";
            var result = new CompanyBLL().Update(param, GetLoginUserId(), out updateLocationContact, out updateFaxPhoneContact);
            if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写');</script>");
            }
            else if (result == ERROR_CODE.CRM_ACCOUNT_NAME_EXIST)      // 用户名称已经存在，重新填写用户名称
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('客户已经存在');</script>");
            }
            else if (result == ERROR_CODE.PHONE_OCCUPY)      // 用户名称已经存在，重新填写用户名称
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('电话已有人在使用，请更换电话。');</script>");
                //Response.Write("<script>alert('电话已有人在使用，请更换电话。'); </script>");
            }
            else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("../Login.aspx");
            }
            else if (result == ERROR_CODE.SUCCESS)                    // 修改用户成功
            {
                if (updateLocationContact == "" && updateFaxPhoneContact == "")
                {
                    Response.Write("<script>alert('修改客户成功！');window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
                }
                else
                {
                    Response.Write("<script>alert('修改客户成功！');window.open('UpdateContact.aspx?account_id=" + param.general_update.id + "&updateLocationContact=" + updateLocationContact + "&updateFaxPhoneContact=" + updateFaxPhoneContact+"','" + (int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd + "','left= 200, top = 200, width = 960, height = 750', false);window.close();</script>");  //  
                    //Response.Redirect("UpdateContact.aspx?account_id=" + param.general_update.id + "&updateLocationContact=" + updateLocationContact + "&updateFaxPhoneContact=" + updateFaxPhoneContact);
                }

            }


        }

        /// <summary>
        /// 删除客户的点击事件
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void delete_Click(object sender, EventArgs e)
        {
            var id = Convert.ToInt64(Request.QueryString["id"]);
            Response.Redirect("deletecompany.aspx?id=" + id);
        }
    }
}