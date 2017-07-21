using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.CRM;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web
{
    public partial class EditCompany : BasePage
    {
        /// <summary>
        /// 客户自定义字段
        /// </summary>
        protected List<UserDefinedFieldDto> company_udfList = null;
        protected List<UserDefinedFieldValue> company_udfValueList = null; //company
        protected crm_account account = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            var company_id = Convert.ToInt64(Request.QueryString["id"]);
            company_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.COMPANY);
            company_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.COMPANY, company_id, company_udfList);
            var company = new CompanyBLL().GetCompany(company_id);
            account = company;
            if (!IsPostBack)
            {
                // var company_id = Convert.ToInt64(Request.QueryString["id"]);
              
                if (company != null)
                {
                  
                    #region 为下拉框获取数据源
                    var dic = new CompanyBLL().GetField();

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

                    company_name.Text = company.name;
                    isactive.Checked = company.is_active == 1;
                    CompanyNumber.Text = company.no;
                    Phone.Text = company.phone;
                    AlternatePhone1.Text = company.alternate_phone1;
                    AlternatePhone2.Text = company.alternate_phone2;
                    Fax.Text = company.fax;
                    WebSite.Text = company.web_site;
                    is_optoutSurvey.Checked = company.is_optout_survey == 1;
                    mileage.Text = company.mileage == null ? "" : company.mileage.ToString();// todo decmail? 保留两位小数点？？
                    CompanyType.SelectedValue = company.type_id == null ? "0" : company.type_id.ToString();
                    AccountManger.SelectedValue = company.resource_id.ToString();
                    TerritoryName.SelectedValue = company.territory_id == null ? "0" : company.territory_id.ToString();
                    MarketSegment.SelectedValue = company.market_segment_id == null ? "0" : company.market_segment_id.ToString();
                    Competitor.SelectedValue = company.competitor_id == null ? "0" : company.competitor_id.ToString();
                    Tax_Exempt.Checked = company.is_tax_exempt == 1;
                    TaxRegion.SelectedValue = company.tax_region_id == null ? "0" : company.tax_region_id.ToString();
                    classification.SelectedValue=company.classification_id == null ? "0" : company.classification_id.ToString();
                    if (Tax_Exempt.Checked)
                    {
                        TaxRegion.Enabled = true;
                    }
                    TaxId.Text = company.tax_identification;
                    if (company.parent_id != null)
                    {
                        var parCompany = new CompanyBLL().GetCompany((long)account.parent_id);
                        ParentComoanyName.Text = parCompany == null ? "" : parCompany.name;  //父客户
                    }
                    asset_value.Text = company.asset_value.ToString();

                    var location = new LocationBLL().GetLocationByAccountId(company.id);
                    if (location != null)        // 如果该客户的地址是默认地址，不可更改为非默认，只能通过添加别的地址设置为默认这种方式去更改默认地址
                    {
                        country_id.SelectedValue = location.country_id == null ? "0" : location.country_id.ToString();
                        province_id.SelectedValue = location.provice_id.ToString();
                        city_id.SelectedValue = location.city_id.ToString();
                        district_id.SelectedValue = location.district_id == null ? "0" : location.district_id.ToString();
                        address.Text = location.address;
                        AdditionalAddress.Text = location.additional_address;
                    }
                }
                else
                {
                    Response.Write("<script>alert('客户不存在！');</script>");
                    Response.Redirect("index.aspx");
                }
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
            param.general_update.is_active = (sbyte)(isactive.Checked ? 1 : 0);
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
                        value = Request.Form[udf.id.ToString()] == null ? "" : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);

                }
                param.general_update.udf = list;
            }
            //try
            //{
            var result = new CompanyBLL().Update(param, "");
            if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
            {
                Response.Write("<script>alert('必填参数丢失，请重新填写'); </script>");
            }
            else if (result == ERROR_CODE.CRM_ACCOUNT_NAME_EXIST)      // 用户名称已经存在，重新填写用户名称
            {
                Response.Write("<script>alert('客户已存在。'); </script>");
            }
            else if (result == ERROR_CODE.PHONE_OCCUPY)      // 用户名称已经存在，重新填写用户名称
            {
                Response.Write("<script>alert('电话已有人在使用，请更换电话。'); </script>");
            }
            else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("Login.aspx");
            }
            //else if (result == ERROR_CODE.ERROR)                      //  出现相似名称,弹出新窗口，让用户决定修改还是新增
            //{
            //    Response.Write("<script>alert('含有相似名称的公司');</script>");
            //}
            else if (result == ERROR_CODE.SUCCESS)                    // 修改用户成功
            {
                Response.Write("<script>alert('修改客户成功！');window.close();</script>");  //  关闭添加页面的同时，刷新父页面
            }
            //}
            //catch (Exception)
            //{
            //    Response.Write("<script>alert('修改客户发生未知错误！');</script>");

            //}

        }

        /// <summary>
        /// 删除客户的点击事件
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void delete_Click(object sender, EventArgs e)
        {
            var id = Convert.ToInt64(Request.QueryString["id"]);
            Response.Redirect("deletecompany.aspx?id="+id);
        }
    }
}