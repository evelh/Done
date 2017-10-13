using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using System.Text;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteAndInvoiceEmailTempl :BasePage 
    {
        protected QuoteAndInvoiceEmailTempBLL qibll = new QuoteAndInvoiceEmailTempBLL();//报价和发票的业务逻辑
        protected long type;
        protected int cate;//操作类型
        protected string typename;//操作类型名称
        protected long id;//修改id
        protected sys_quote_email_tmpl emailtempl = new sys_quote_email_tmpl();//邮件模板对象
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!long.TryParse(Request.QueryString["type"], out type))
            {
                //Response.Write("<script>alert('获取相关信息失败，返回上一页');window.close();</script>");
            }
            if (!long.TryParse(Request.QueryString["id"], out id))
            {
                id = 0;
            }
            switch (type) {
                case (int)QueryType.Quote_Email_Tmpl:
                    typename = "新增：报价邮件模板";
                    cate = 1;
                    break;
                case (int)QueryType.Invoice_Email_Tmpl:
                    cate = 2;
                    typename = "新增：发票邮件模板";
                    break;
                default: Response.Write("<script>alert('获取相关信息失败，返回上一页');window.close();</script>"); break;
            }
            if (!IsPostBack) {
                //绑定下列框的变量
                //报价邮件模板
                if (type == (int)QueryType.Quote_Email_Tmpl)
                {
                    //变量项
                    this.AlertVariableFilter.DataTextField = "show";
                    this.AlertVariableFilter.DataValueField = "val";
                    this.AlertVariableFilter.DataSource = qibll.GetVariableField(cate);
                    this.AlertVariableFilter.DataBind();
                    this.AlertVariableFilter.Items.Insert(0, new ListItem() { Value = "0", Text = "显示全部变量", Selected = true });
                    //对应的变量列表
                    var list = qibll.GetAllVariable(cate);
                    StringBuilder sb = new StringBuilder();
                    foreach (string va in list)
                    {
                        sb.Append("<option class='val' ondblclick='dbclick(this);'>" + va.Replace("'", "") + "</option>");
                    }
                    this.VariableList.Text = sb.ToString();
                }
                //发票邮件模板
                else if (type == (int)QueryType.Invoice_Email_Tmpl) {


                }
                //默认激活
                this.Active.Checked = true;
                //修改
                if (id > 0)
                {
                    typename = typename.Replace("新增", "修改");

                }
                //新增
                else {
                    emailtempl = qibll.GetEmailTemp(id);
                    if (emailtempl != null) {


                    }
                    else
                    {
                        Response.Write("<script>alert('获取相关信息失败，返回上一页');window.close();</script>");
                    }
                }

            }
        }
        protected void AlertVariableFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            StringBuilder sb = new StringBuilder();
            if (this.AlertVariableFilter.SelectedValue == "0")
            {
                sb.Clear();
                var list = new QuoteTemplateBLL().GetAllVariable();
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this);'>" + va.Replace("'", "") + "</option>");
                }
                this.VariableList.Text = sb.ToString();
            }
            else
            {
                int id = Convert.ToInt32(this.AlertVariableFilter.SelectedValue.ToString());
                sb.Clear();
                var list = new QuoteTemplateBLL().GetVariable(id);
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this);' >" + va.Replace("'", "") + "</option>");
                }
                this.VariableList.Text = sb.ToString();
            }
        }
    }
}