using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    public partial class InvoiceTemplateAttr : BasePage
    {
        protected int id;
        private QuoteTemplateBLL temp = new QuoteTemplateBLL();
        protected string op;
        protected sys_bookmark thisBookMark;
        protected void Page_Load(object sender, EventArgs e)
        {
            thisBookMark = new IndexBLL().GetSingBook(Request.RawUrl, LoginUserId);
            id = Convert.ToInt32(Request.QueryString["id"]);
            if(!string.IsNullOrEmpty(Request.QueryString["op"]))
            op = Request.QueryString["op"];            
            if (!IsPostBack) {
                Bind();
                if (id > 0) {
                    var tem = temp.GetQuoteTemplate(id);
                    this.Name.Text = tem.name;
                    if (tem.description != null)
                        this.Description.Text = tem.description;
                    if (tem.is_active != 1)
                        this.Active.Checked = false;
                    this.DateFormat.SelectedValue = tem.date_display_format_id.ToString();
                    this.NumberFormat.SelectedValue = tem.number_display_format_id.ToString();
                    this.CurrencyPositivePattern.SelectedValue = tem.currency_positive_format_id.ToString();
                    this.CurrencyNegativePattern.SelectedValue = tem.currency_negative_format_id.ToString();
                    this.Payment_terms.SelectedValue = tem.payment_term_id.ToString();
                    switch (tem.page_number_location_id)
                    {
                        case (int)PAGE_NUMBER_LOCATION.NO: this.showNO.Checked = true; break;
                        case (int)PAGE_NUMBER_LOCATION.BOTTOMLEFT: this.showLeft.Checked = true; break;
                        case (int)PAGE_NUMBER_LOCATION.BOTTOMCENTER: this.showCenter.Checked = true; break;
                        case (int)PAGE_NUMBER_LOCATION.BOTTOMRIGHT: this.showRight.Checked = true; break;

                    }
                    switch (tem.paper_size_id)
                    {
                        case (int)PAGE_SIZE.LETTER: this.Letter.Checked = true; break;
                        case (int)PAGE_SIZE.A4: this.A4.Checked = true; break;
                    }
                }
            }
        }
        public void Bind()
        {
            #region 下拉框赋值
            var dic = temp.GetField();
            // 日期格式
            this.DateFormat.DataTextField = "show";
            this.DateFormat.DataValueField = "val";
            this.DateFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "DateFormat").Value;
            this.DateFormat.DataBind();
            this.DateFormat.SelectedIndex = 0;
            //时间显示格式TimeFormat
            this.TimeFormat.DataTextField = "show";
            this.TimeFormat.DataValueField = "val";
            this.TimeFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "TimeFormat").Value;
            this.TimeFormat.DataBind();
            this.TimeFormat.SelectedIndex = 0;
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
            //支付条款  Payment_terms
            this.Payment_terms.DataTextField = "show";
            this.Payment_terms.DataValueField = "val";
            this.Payment_terms.DataSource = dic.FirstOrDefault(_ => _.Key == "Payment_terms").Value;
            this.Payment_terms.DataBind();

            #endregion

        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            sys_quote_tmpl data = new sys_quote_tmpl();
            if (id > 0)
                data = temp.GetQuoteTemplate(id);
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
            data.payment_term_id = Convert.ToInt32(this.Payment_terms.SelectedValue.Trim().ToString());
            data.show_each_tax_in_tax_group = 1;
            data.show_tax_cate_superscript = 1;
            data.show_tax_cate = 1;
            data.show_each_tax_in_tax_period = 0;
            data.cate_id = 2;
            if (id > 0) {
                var result = temp.update(data, GetLoginUserId());
                if (result == ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('发票模板属性修改成功');window.close();self.opener.location.reload();</script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
                else
                {
                    Response.Write("<script>alert('发票模板属性修改失败！');</script>");
                }
            } else {
                var result = temp.Add(data, GetLoginUserId(), out id);
                if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    Response.Write("<script>alert('发票模板添加成功！');window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
            }
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
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();</script>");
        }
    }
}