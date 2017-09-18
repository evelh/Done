using EMT.DoneNOW.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class InvoiceTemplateAttr : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Bind();
        }
        public void Bind()
        {


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
    }
}