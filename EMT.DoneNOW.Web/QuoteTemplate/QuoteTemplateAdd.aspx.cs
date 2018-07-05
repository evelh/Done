using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using static EMT.DoneNOW.DTO.DicEnum;
using Newtonsoft.Json;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteTemplateAdd : BasePage
    {
        protected long id;
        protected sys_bookmark thisBookMark;
        protected void Page_Load(object sender, EventArgs e)
        {
            thisBookMark = new IndexBLL().GetSingBook(Request.RawUrl, LoginUserId);
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (!IsPostBack) {
                Bind();
                if (id > 0) {//修改
                    var data = new QuoteTemplateBLL().GetQuoteTemplate(id);
                    if (data == null)
                    {
                        Response.Write("<script>alert('获取相关数据失败，返回上一个页面');window.close();self.opener.location.reload();</script>");
                    }
                    else {
                        this.Name.Text = data.name;
                        this.Description.Text = data.description;
                        if (data.is_active == 1)
                        {
                            this.Active.Checked = true;
                        }
                        if (data.show_each_tax_in_tax_group == 1)
                        {
                            this.show_each_tax_in_tax_group.Checked = true;
                        }
                        if (data.show_each_tax_in_tax_period == 1)
                        {
                            this.show_each_tax_in_tax_period.Checked = true;
                        }
                        if (data.show_tax_cate == 1)
                        {
                            this.show_tax_cate.Checked = true;
                        }
                        if (data.show_tax_cate_superscript == 1)
                        {
                            this.show_tax_cate_superscript.Checked = true;
                        }

                        var data_tax = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.Tax_Total_Disp>(data.tax_total_disp);
                        this.SemiAnnualTotal.Text = data_tax.Semi_Annual_Total;
                        this.IncludingOptionalQuoteItems.Text = data_tax.Including_Optional_Quote_Items;
                        this.ItemTotal.Text = data_tax.Item_Total;
                        this.Subtotal.Text = data_tax.Subtotal;
                        this.Total.Text = data_tax.Total;
                        this.TotalTaxes.Text = data_tax.Total_Taxes;
                        this.YearlySubtotal.Text = data_tax.Yearly_Subtotal;
                        this.YearlyTotal.Text = data_tax.Yearly_Total;
                        this.ShippingTotal.Text = data_tax.Shipping_Total;
                        this.ShippingSubtotal.Text = data_tax.Shipping_Subtotal;
                        this.SemiAnnualSubtotal.Text = data_tax.Semi_Annual_Subtotal;
                        this.QuarterlySubtotal.Text = data_tax.Quarterly_Subtotal;
                        this.QuarterlyTotal.Text = data_tax.Quarterly_Total;
                        this.MonthlySubtotal.Text = data_tax.Monthly_Subtotal;
                        this.OptionalSubtotal.Text = data_tax.Optional_Subtotal;
                        this.OptionalTotal.Text = data_tax.Optional_Total;
                        this.MonthlyTotal.Text = data_tax.Monthly_Total;
                        this.OneTimeDiscountSubtotal.Text = data_tax.One_Time_Discount_Subtotal;
                        this.OneTimeDiscountTotal.Text = data_tax.One_Time_Discount_Total;
                        this.OneTimeSubtotal.Text = data_tax.One_Time_Subtotal;
                        this.OneTimeTotal.Text = data_tax.One_Time_Total;

                        switch (data.page_number_location_id)
                        {                            
                            case (int)PAGE_NUMBER_LOCATION.NO: this.showNO.Checked = true; break;
                            case (int)PAGE_NUMBER_LOCATION.BOTTOMLEFT: this.showLeft.Checked = true; break;
                            case (int)PAGE_NUMBER_LOCATION.BOTTOMCENTER: this.showCenter.Checked = true; break;
                            case (int)PAGE_NUMBER_LOCATION.BOTTOMRIGHT: this.showRight.Checked = true; break;

                        }

                        switch (data.paper_size_id)
                        {
                            case (int)PAGE_SIZE.LETTER: this.Letter.Checked = true; break;
                            case (int)PAGE_SIZE.A4: this.A4.Checked = true; break;
                        }

                    }
                }
            }         
        }
        public void Bind() {


            #region 下拉框赋值

            var dic = new QuoteTemplateBLL().GetField();

            // 日期格式
            this.DateFormat.DataTextField = "show";
            this.DateFormat.DataValueField = "val";
            this.DateFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "DateFormat").Value;
            this.DateFormat.DataBind();
            this.DateFormat.SelectedIndex = 0;
            //数字格式
            this.NumberFormat.DataTextField = "show";
            this.NumberFormat.DataValueField = "val";
            this.NumberFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "NumberFormat").Value;
            this.NumberFormat.DataBind();
            //货币格式（正数）
            this.CurrencyPositivePattern.DataTextField = "show";
            this.CurrencyPositivePattern.DataValueField = "val";
            this.CurrencyPositivePattern.DataSource = dic.FirstOrDefault(_ => _.Key == "CurrencyPositivePattern").Value;
            this.CurrencyPositivePattern.DataBind();
            //货币格式（负数）
            this.CurrencyNegativePattern.DataTextField = "show";
            this.CurrencyNegativePattern.DataValueField = "val";
            this.CurrencyNegativePattern.DataSource = dic.FirstOrDefault(_ => _.Key == "CurrencyNegativePattern").Value;
            this.CurrencyNegativePattern.DataBind();
            #endregion
           
        }



        protected void AddQuoteTemplate(object sender, EventArgs e)
        {
            //this.DateFormat.
            sys_quote_tmpl sqt = new sys_quote_tmpl();
            sqt.name = this.Name.Text.Trim().ToString();
            if (this.Active.Checked) { sqt.is_active = 1; }
            else { sqt.is_active = 0; }            
            sqt.description = this.Description.Text.Trim().ToString();
            sqt.paper_size_id = paper_size_id();
            sqt.page_number_location_id = page_number_location_id();
            sqt.create_user_id = LoginUserId;
            sqt.currency_negative_format_id=Convert.ToInt32(this.CurrencyNegativePattern.SelectedValue.Trim().ToString());
            sqt.currency_positive_format_id = Convert.ToInt32(this.CurrencyPositivePattern.SelectedValue.Trim().ToString());
            sqt.number_display_format_id = Convert.ToInt32(this.NumberFormat.SelectedValue.Trim().ToString());
            sqt.date_display_format_id = Convert.ToInt32(this.DateFormat.SelectedValue.Trim().ToString());
            sqt.cate_id = 1;
            if (this.show_each_tax_in_tax_group.Checked)
            {
                sqt.show_each_tax_in_tax_group = 1;
            }
            else {
                sqt.show_each_tax_in_tax_group = 0;
            }
            if (this.show_each_tax_in_tax_period.Checked)
            {
                sqt.show_each_tax_in_tax_period = 1;
            }
            else {
                sqt.show_each_tax_in_tax_period = 0;
            }
            if (this.show_tax_cate.Checked)
            {
                sqt.show_tax_cate = 1;
            }
            else {
                sqt.show_tax_cate = 0;
            }
            if (this.show_tax_cate_superscript.Checked)
            {
                sqt.show_tax_cate_superscript = 1;
            }
            else {
                sqt.show_tax_cate_superscript = 0;
            }

            sqt.tax_total_disp=tax_total_disp();
            // sqt.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

            QuoteTemplateBLL qtbll = new QuoteTemplateBLL();
            
            if (string.IsNullOrEmpty(sqt.name)) {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('模板名称未填写！');</script>");
            }
            if (id > 0) {
                var result = qtbll.update(sqt, GetLoginUserId());
                if (result == ERROR_CODE.SUCCESS) 
                {
                    Response.Write("<script>alert('报价模板属性修改成功');window.close();self.opener.location.reload();</script>"); 
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
                else
                {
                    Response.Write("<script>alert('报价模板属性修改成功');</script>");
                }
            }
            else {
                int id1;
                var result = qtbll.Add(sqt, GetLoginUserId(), out id1);
                if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    Response.Write("<script>alert('报价模板添加成功！');window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }

            }            

        }

        /// <summary>
        /// 获取前端税收自定义项，生成序列化json
        /// </summary>
        /// <returns></returns>

        private string  tax_total_disp() {
            QuoteTemplateAddDto.Tax_Total_Disp ttd = new DTO.QuoteTemplateAddDto.Tax_Total_Disp();
            //Response.Write(this.SemiAnnualTotal.Text.Trim().ToString());           

            ttd.Semi_Annual_Total = this.SemiAnnualTotal.Text.Trim().ToString();
            ttd.Including_Optional_Quote_Items = this.IncludingOptionalQuoteItems.Text.Trim().ToString();
            ttd.Item_Total = this.ItemTotal.Text.Trim().ToString();
            ttd.Subtotal = this.Subtotal.Text.Trim().ToString();
            ttd.Total = this.Total.Text.Trim().ToString();
            ttd.Total_Taxes = this.TotalTaxes.Text.Trim().ToString();
            ttd.Yearly_Subtotal = this.YearlySubtotal.Text.Trim().ToString();
            ttd.Yearly_Total = this.YearlyTotal.Text.Trim().ToString();
            ttd.Shipping_Total = this.ShippingTotal.Text.Trim().ToString();
            ttd.Shipping_Subtotal = this.ShippingSubtotal.Text.Trim().ToString();
            ttd.Semi_Annual_Subtotal = this.SemiAnnualSubtotal.Text.Trim().ToString();
            ttd.Quarterly_Total = this.QuarterlyTotal.Text.Trim().ToString();
            ttd.Quarterly_Subtotal = this.QuarterlySubtotal.Text.Trim().ToString();
            ttd.Monthly_Subtotal = this.MonthlySubtotal.Text.Trim().ToString();
            ttd.Optional_Subtotal = this.OptionalSubtotal.Text.Trim().ToString();
            ttd.Optional_Total = this.OptionalTotal.Text.Trim().ToString();
            ttd.Monthly_Subtotal = this.MonthlySubtotal.Text.Trim().ToString();
            ttd.Monthly_Total = this.MonthlyTotal.Text.Trim().ToString();
            ttd.One_Time_Total = this.OneTimeTotal.Text.Trim().ToString();
            ttd.One_Time_Subtotal = this.OneTimeSubtotal.Text.Trim().ToString();
            ttd.One_Time_Discount_Total = this.OneTimeDiscountTotal.Text.Trim().ToString();
            ttd.One_Time_Discount_Subtotal = this.OneTimeDiscountSubtotal.Text.Trim().ToString();
            string jsonString = new EMT.Tools.Serialize().SerializeJson(ttd);
           // string jsonString = JsonConvert.SerializeObject(ttd);
            return jsonString;
           // Response.Write(jsonString);

        }
        /// <summary>
        /// 从前台check控件，获取页码位置的id编号
        /// </summary>
        /// <returns>id编号</returns>
        private int page_number_location_id() {
            int id =(int)PAGE_NUMBER_LOCATION.NO;
            if (this.showNO.Checked)
            {
                id = Convert.ToInt32(PAGE_NUMBER_LOCATION.NO);
            }
            else if (this.showCenter.Checked)
            {
                id = Convert.ToInt32(PAGE_NUMBER_LOCATION.BOTTOMCENTER);
            }
            else if (this.showLeft.Checked)
            {
               id = Convert.ToInt32(PAGE_NUMBER_LOCATION.BOTTOMLEFT);
            }
            else if (this.showRight.Checked)
            {
                id = Convert.ToInt32(PAGE_NUMBER_LOCATION.BOTTOMRIGHT);
            }
            return id;

        }
        /// <summary>
        /// 从前台check控件，获取页面尺寸的id编号
        /// </summary>
        /// <returns>iD编号</returns>
        private int paper_size_id() {
            int id = Convert.ToInt32(PAGE_SIZE.LETTER);
            if (this.Letter.Checked)
            {
                id = Convert.ToInt32(PAGE_SIZE.LETTER);
            }
            else if (this.A4.Checked) {
                id = Convert.ToInt32(PAGE_SIZE.A4);
            }
            return id;
        }
    }
}