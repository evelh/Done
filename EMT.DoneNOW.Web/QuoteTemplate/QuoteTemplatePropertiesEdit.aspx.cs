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
    public partial class QuoteTemplatePropertiesEdit : BasePage
    {
        public int id;
        protected QuoteTemplateBLL qtb = new QuoteTemplateBLL();
        protected sys_quote_tmpl data;
        public int k = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            data = qtb.GetQuoteTemplate(id);
            if (!IsPostBack)
            {                
                if (data == null)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('获取数据错误！');history.go(-1);</script>");
                }
                Bind();
            }
        }
        /// <summary>
        /// 绑定数据
        /// </summary>
        public void Bind()
        {


            #region 下拉框赋值

            var dic = new QuoteTemplateBLL().GetField();

            // 日期格式
            this.DateFormat.DataTextField = "show";
            this.DateFormat.DataValueField = "val";
            this.DateFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "DateFormat").Value;
            this.DateFormat.SelectedValue = data.date_display_format_id.ToString();
            this.DateFormat.DataBind();           
            //数字格式
            this.NumberFormat.DataTextField = "show";
            this.NumberFormat.DataValueField = "val";
            this.NumberFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "NumberFormat").Value;
            this.NumberFormat.SelectedValue = data.number_display_format_id.ToString();
            this.NumberFormat.DataBind();
            //货币格式（正数）
            this.CurrencyPositivePattern.DataTextField = "show";
            this.CurrencyPositivePattern.DataValueField = "val";
            this.CurrencyPositivePattern.DataSource = dic.FirstOrDefault(_ => _.Key == "CurrencyPositivePattern").Value;
            this.CurrencyPositivePattern.SelectedValue = data.currency_positive_format_id.ToString();
            this.CurrencyPositivePattern.DataBind();
            //货币格式（负数）
            this.CurrencyNegativePattern.DataTextField = "show";
            this.CurrencyNegativePattern.DataValueField = "val";
            this.CurrencyNegativePattern.DataSource = dic.FirstOrDefault(_ => _.Key == "CurrencyNegativePattern").Value;
            this.CurrencyNegativePattern.SelectedValue = data.currency_negative_format_id.ToString();
            this.CurrencyNegativePattern.DataBind();


            this.Name.Text = data.name;
            this.Description.Text = data.description;
            if (data.is_active != 1) {
                this.Active.Checked = false;
            }
            if (data.show_each_tax_in_tax_group == 1) {
                this.show_each_tax_in_tax_group.Checked = true;
            }
            if (data.show_each_tax_in_tax_period==1)
            {
                this.show_each_tax_in_tax_period.Checked = true;
                k = 1;
            }
            if (data.show_tax_cate==1)
            {
                this.show_tax_cate.Checked = true;
            }
            if (data.show_tax_cate_superscript==1)
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

            #endregion

        }



        protected void UPdateQuoteTemplate(object sender, EventArgs e)
        {
            data.name = this.Name.Text.Trim().ToString();
            if (this.Active.Checked) { data.is_active = 1; }
            else { data.is_active = 0; }
            data.description = this.Description.Text.Trim().ToString();
            data.paper_size_id = paper_size_id();
            data.page_number_location_id = page_number_location_id();
            data.currency_negative_format_id = Convert.ToInt32(this.CurrencyNegativePattern.SelectedValue.Trim().ToString());
            data.currency_positive_format_id = Convert.ToInt32(this.CurrencyPositivePattern.SelectedValue.Trim().ToString());
            data.number_display_format_id = Convert.ToInt32(this.NumberFormat.SelectedValue.Trim().ToString());
            data.date_display_format_id = Convert.ToInt32(this.DateFormat.SelectedValue.Trim().ToString());
            data.show_each_tax_in_tax_group = 1;
            data.show_tax_cate_superscript = 1;
            data.show_tax_cate = 1;
            data.show_each_tax_in_tax_period = 0;
            if (this.show_each_tax_in_tax_group.Checked)
            {
                data.show_each_tax_in_tax_group = 1;
            }
            if (this.show_each_tax_in_tax_period.Checked)
            {
                data.show_each_tax_in_tax_period = 1;
            }
            if (this.show_tax_cate.Checked)
            {
                data.show_tax_cate = 1;
            }
            if (this.show_tax_cate_superscript.Checked)
            {
                data.show_tax_cate_superscript = 1;
            }

            data.tax_total_disp = tax_total_disp();
            if (string.IsNullOrEmpty(data.name))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('模板名称未填写！');</script>");
            }

            //var user=Session["dn_session_user_info"] as sys_user;
            //qtbll.log(user);

            var result = qtb.update(data, GetLoginUserId());
            if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
            {
                //Response.Write("<script>alert('报价模板属性修改成功'); window.location.href = 'QuoteTemplateEdit.aspx?id ="+id+"&op= edit';</script>"); 
                //  关闭添加页面的同时，刷新父页面
                Response.Redirect("QuoteTemplateEdit.aspx?id=" + id + "&op=edit");
            }
            else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("Login.aspx");
            }
            else {
                Response.Write("<script>alert('报价模板属性修改成功');</script>");
            }

        }

        /// <summary>
        /// 获取前端税收自定义项，生成序列化json
        /// </summary>
        /// <returns></returns>

        private string tax_total_disp()
        {
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
            string jsonString = JsonConvert.SerializeObject(ttd);
            return jsonString;
            // Response.Write(jsonString);

        }
        /// <summary>
        /// 从前台check控件，获取页码位置的id编号
        /// </summary>
        /// <returns>id编号</returns>
        private int page_number_location_id()
        {
            int id = Convert.ToInt32(PAGE_NUMBER_LOCATION.NO);
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
        private int paper_size_id()
        {
            int id = Convert.ToInt32(PAGE_SIZE.LETTER);
            if (this.Letter.Checked)
            {
                id = Convert.ToInt32(PAGE_SIZE.LETTER);
            }
            else if (this.A4.Checked)
            {
                id = Convert.ToInt32(PAGE_SIZE.A4);
            }
            return id;
        }

        protected void Cancel(object sender, EventArgs e)
        {
            Response.Redirect("QuoteTemplateEdit.aspx?id="+id+"&op=edit");
        }
    }
}