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
                #endregion
              
                if (!string.IsNullOrEmpty(id))
                {
                    quote = new crm_quote_dal().GetQuote(Convert.ToInt64(id));
                    if (quote != null)
                    {
                        isAdd = false;
                    }
                }

                if (!isAdd)
                {
                    account = new CompanyBLL().GetCompany(quote.account_id);
                    if (account != null)
                    {
                        //if (account.tax_region_id != null)
                        //{
                        //    tax_region_id.SelectedValue = account.tax_region_id.ToString();
                        //}
                        tax_region_id.SelectedValue = account.tax_region_id!=null?account.tax_region_id.ToString():"0";
                        payment_term_id.SelectedValue = quote.payment_term_id!=null? quote.payment_term_id.ToString():"0";
                        payment_type_id.SelectedValue = quote.payment_type_id != null ? quote.payment_type_id.ToString() : "0"; //shipping_type_id
                        shipping_type_id.SelectedValue = quote.shipping_type_id != null ? quote.shipping_type_id.ToString() : "0";
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

            if (isAdd)
            {
                var result = new QuoteBLL().Insert(quote, GetLoginUserId());
                switch (result)
                {
                    case ERROR_CODE.SUCCESS:
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改商机成功！');window.close();</script>");
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

            }
           

         
        }



    }
}