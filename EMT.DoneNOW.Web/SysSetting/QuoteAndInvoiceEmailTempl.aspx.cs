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
    public partial class QuoteAndInvoiceEmailTempl : BasePage
    {
        protected QuoteAndInvoiceEmailTempBLL qibll = new QuoteAndInvoiceEmailTempBLL();//报价和发票的业务逻辑
        protected long type;
        protected int cate;//操作类型
        protected string typename;//操作类型名称
        protected long id;//修改id
        protected sys_quote_email_tmpl emailtempl = new sys_quote_email_tmpl();//邮件模板对象
        protected string BodyContent;//主体部分内容
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
            switch (type)
            {
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
            if (!IsPostBack)
            {
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
                else if (type == (int)QueryType.Invoice_Email_Tmpl)
                {


                }
                //默认激活
                this.Active.Checked = true;
                //默认选择html
                this.Html.Checked = true;
                //修改
                if (id > 0)
                {
                    typename = typename.Replace("新增", "修改");
                    emailtempl = qibll.GetEmailTemp(id);
                    if (emailtempl != null)
                    {
                        this.Name.Text = emailtempl.name;
                        if (!string.IsNullOrEmpty(emailtempl.description))
                        {
                            this.Description.Text = emailtempl.description;
                        }
                        if (emailtempl.status_id > 0)
                        {
                            this.Active.Checked = true;
                        }
                        else
                        {
                            this.Active.Checked = false;
                        }
                        if (emailtempl.email_attached_pdf > 0)
                        {
                            this.AttachPdf.Checked = true;
                        }
                        else
                        {
                            this.AttachPdf.Checked = false;
                        }
                        this.SendFromFirstName.Text = emailtempl.sender_first_name;
                        this.SendFromLastName.Text = emailtempl.sender_last_name;
                        this.SendFromEmail.Text = emailtempl.email_from_address;
                        this.CC.Text = emailtempl.email_cc_address;
                        this.BCC.Text = emailtempl.email_bcc_address;
                        if (emailtempl.is_account_owner_bcc > 0)
                        {
                            this.BccAccountManager.Checked = true;
                        }
                        else
                        {
                            this.BccAccountManager.Checked = false;
                        }
                        this.Email_Subject.Text = emailtempl.subject;
                        if (emailtempl.is_html_format == 1)
                        {
                            this.PlainText.Checked = false;
                            this.Html.Checked = true;
                            if (!string.IsNullOrEmpty(emailtempl.html_body))
                            {
                                BodyContent = HttpUtility.HtmlDecode(emailtempl.html_body).Replace("\"", "'");
                            }
                        }
                        else if (emailtempl.is_html_format == 2)
                        {
                            this.Html.Checked = false;
                            this.PlainText.Checked = true;
                            if (!string.IsNullOrEmpty(emailtempl.text_body))
                            {
                                BodyContent = HttpUtility.HtmlDecode(emailtempl.text_body).Replace("\"", "'");
                            }
                        }

                    }
                    else
                    {
                        Response.Write("<script>alert('获取相关信息失败，返回上一页');window.close();</script>");
                    }
                }
                //新增
                else
                {

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

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (id > 0)
            {
                emailtempl = qibll.GetEmailTemp(id);
            }
            //收集数据
            string bodydata = Request.Form["data"].Trim().ToString().Replace("\"", "'");
            emailtempl.name = this.Name.Text.Trim().ToString();
            emailtempl.description = this.Description.Text.Trim();
            if (this.Active.Checked)
            {
                emailtempl.status_id = 1;
            }
            else
            {
                emailtempl.status_id = 0;
            }
            if (this.AttachPdf.Checked)
            {
                emailtempl.email_attached_pdf = 1;
            }
            else
            {
                emailtempl.email_attached_pdf = 0;
            }
            emailtempl.sender_first_name = this.SendFromFirstName.Text.Trim();
            emailtempl.sender_last_name = this.SendFromLastName.Text.Trim();
            emailtempl.email_from_address = this.SendFromEmail.Text.Trim();
            emailtempl.email_cc_address = this.CC.Text.Trim();
            emailtempl.email_bcc_address = this.BCC.Text.Trim();
            if (this.BccAccountManager.Checked)
            {
                emailtempl.is_account_owner_bcc = 1;
            }
            else
            {
                emailtempl.is_account_owner_bcc = 0;
            }
            emailtempl.subject = this.Email_Subject.Text.Trim();
            if (this.Html.Checked)
            {
                emailtempl.is_html_format = 1;
                emailtempl.html_body = bodydata;
            }
            else if (this.PlainText.Checked)
            {
                emailtempl.is_html_format = 2;
                emailtempl.text_body = bodydata;
            }
            switch (type)
            {
                case (int)QueryType.Quote_Email_Tmpl:
                    emailtempl.cate_id = 1;
                    break;
                case (int)QueryType.Invoice_Email_Tmpl:
                    emailtempl.cate_id = 2;
                    break;
            }
            if (id > 0)//修改
            {
                var result = qibll.Update(emailtempl, GetLoginUserId());



            }
            else//新增
            {
                var result = qibll.Insert(emailtempl, GetLoginUserId());


            }

        }
    }
}