using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteView :BasePage
    {
        public int id;
        private sys_quote_tmpl data =new sys_quote_tmpl();
        private QuoteBLL qd = new QuoteBLL();
        private List<sys_quote_tmpl> datalist = new List<sys_quote_tmpl>();
        protected void Page_Load(object sender, EventArgs e)
        {
            //从URL地址获取报价id
            id = Convert.ToInt32(Request.QueryString["id"]);
            id = 294;
            //获取所有的报价模板
            datalist = new QuoteTemplateBLL().GetAllTemplate();
            //获取该报价信息
            var qddata = qd.GetQuote(id);

            if (!IsPostBack)
            {
                //绑定数据，在下拉框展示报价模板
                this.quoteTemplateDropDownList.DataTextField = "name";
                this.quoteTemplateDropDownList.DataValueField = "id";
                this.quoteTemplateDropDownList.DataSource = datalist;
                this.quoteTemplateDropDownList.DataBind();
                this.quoteTemplateDropDownList.Items.Insert(0, new ListItem() { Value = "0", Text = "未选择报价模板" });
                bool k = false;
                if (!string.IsNullOrEmpty(qddata.quote_tmpl_id.ToString()))
                {
                    foreach (var list in datalist)
                    {
                        if (list.id == qddata.quote_tmpl_id)
                        {
                            k = true;
                            this.quoteTemplateDropDownList.SelectedValue = qddata.quote_tmpl_id.ToString();
                            initview(list);//使用报价单已选择的报价模板显示
                            //break;
                        }
                        if (list.is_default == 1) {
                            //判断是否为默认模板
                            data = list;
                        }
                    }
                }
                if (!k&&data.id>0)
                {
                    initview(data);//使用默认模板显示
                }
                if(!k&&data.id<=0) {
                    initview(datalist[0]);//使用数据库第一个模板显示,
                    //Response.Write("<script>alert("+datalist[0].id+");</script>");
                }

            }
        }

        private void initview(sys_quote_tmpl list) {
            string page_header = "";
            if (!string.IsNullOrEmpty(list.page_header_html)) {
                page_header = HttpUtility.HtmlDecode(list.page_header_html).Replace("\"", "'");//页眉
            }           
            string quote_header = "";
            if (!string.IsNullOrEmpty(list.quote_header_html))
            {
                quote_header = HttpUtility.HtmlDecode(list.quote_header_html).Replace("\"", "'");//头部
            }
            string quote_footer = "";
            if (!string.IsNullOrEmpty(list.quote_footer_html)) {
                quote_footer = HttpUtility.HtmlDecode(list.quote_footer_html).Replace("\"", "'");//底部
            }
            string page_footer = "";
            if (!string.IsNullOrEmpty(list.page_footer_html))
            {
                page_footer = HttpUtility.HtmlDecode(list.page_footer_html).Replace("\"", "'");//页脚
            }

            StringBuilder table = new StringBuilder();
            table.Append(page_header);
            table.Append(quote_header);
            table.Append("<table>");
            table.Append("<th>");

            if (!string.IsNullOrEmpty(list.body_html)) {
                var quote_body = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.BODY>(list.body_html.Replace("'", "\""));//正文主体
                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                {
                    if (coulmn.Display == "yes")
                    {
                        table.Append("<td>" + coulmn.Column_label + "</td>");
                    }
                }


            }
           
     
            
            





            table.Append("</table>");
            table.Append(quote_footer);
            table.Append(page_footer);
            this.table.Text = table.ToString();
            table.Clear();
        }
        //改变报价模板显示数据
        protected void quoteTemplateDropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            int select_id=Convert.ToInt32(this.quoteTemplateDropDownList.SelectedValue.ToString());
            data = new QuoteTemplateBLL().GetQuoteTemplate(select_id);
            initview(data);
        }
    }
}