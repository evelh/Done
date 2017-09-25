using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    public partial class InvoiceTempEdit : BasePage
    {
        public int id;
        public string op;
        protected InvioceTempDto.TempContent tempinfo =new InvioceTempDto.TempContent();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            //id = 1457;
            if (!IsPostBack)
            {
                if (Session["cancel"] != null && (int)Session["cancel"] != 1)
                {
                    Session.Remove("tempinfo");
                }
                Session["cancel"] = 0;
                QuoteTemplateBLL qtb = new QuoteTemplateBLL();
                if (Request.QueryString["op"] == null || string.IsNullOrEmpty(Request.QueryString["op"].ToString()))
                {
                    if (qtb.invoice_used(id) == DTO.ERROR_CODE.ERROR)//判断报价模板是否被引用
                    {
                        Response.Write("<script>if(confirm('模板被发票引用，如果修改会影响到这些发票。你如果你不想影响这些发票，可以复制一个新的模板，然后对新模板进行修改。是否继续?')==true){}else{window.close();}</script>");
                        //复制一个报价模板
                        Session["copy"] = "(copy)";
                    }
                }
                //填充数据
                var data = qtb.GetQuoteTemplate(id);
                if (data == null)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('获取数据错误！');history.go(-1);</script>");
                }
                else
                {
                    var tempppp = Session["tempinfo"] as InvioceTempDto.TempContent;
                    if (tempppp == null || tempppp.id != id)
                    {
                        tempinfo.id = data.id;
                        tempinfo.name = data.name;
                        //五大部分
                        tempinfo.head = data.page_header_html;//页眉
                        tempinfo.top = data.quote_header_html;//头部
                        tempinfo.body = data.body_html;//主体
                        tempinfo.bottom = data.quote_footer_html;//底部
                        tempinfo.foot = data.page_footer_html;//页脚
                        //bottom税相关
                        tempinfo.tax_cat = data.show_tax_cate;
                        tempinfo.tax_group = data.show_each_tax_in_tax_group;
                        tempinfo.tax_sup = data.show_tax_cate_superscript;
                        //body分组
                        tempinfo.body_group_by = data.body_group_by_id == null ? 0 : (int)data.body_group_by_id;
                        tempinfo.body_itemize_id = data.body_itemize_id == null ? 0 : (int)data.body_itemize_id;
                        tempinfo.body_order_by = data.body_order_by_id == null ? 0 : (int)data.body_order_by_id;
                        tempinfo.show_labels_when_grouped = data.show_labels_when_grouped == null ? 0 : (int)data.show_labels_when_grouped;
                        //bottom 合计
                        if (data.tax_total_disp!=null||!string.IsNullOrEmpty(data.tax_total_disp))
                        tempinfo.Invoice_text = data.tax_total_disp.Replace("'", "\"");//正文主体
                        //底部备注
                        tempinfo.foot_note = data.quote_footer_notes;
                        Session["tempinfo"] = tempinfo;
                    }
                    else {
                        tempinfo = tempppp;
                    }
                    //页眉
                    if (!string.IsNullOrEmpty(tempinfo.head))
                    {
                        this.head.Text = HttpUtility.HtmlDecode(tempinfo.head).Replace("\"", "'");
                    }
                    //头部
                    if (!string.IsNullOrEmpty(tempinfo.top))
                    {
                        this.top.Text = HttpUtility.HtmlDecode(tempinfo.top).Replace("\"", "'");
                    }
                    //正文body 
                    if (string.IsNullOrEmpty(tempinfo.body))
                    {
                            //填充默认
                            StringBuilder sb = new StringBuilder();
                            sb.Append("<table class='ReadOnlyGrid_Table'>");
                            sb.Append("<tr>");
                            sb.Append("<td class='ReadOnlyGrid_TableHeader' style='text-align: Left;' width='40px;'>序列号</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>条目创建日期</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Left;'>类型</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>员工姓名</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>计费时间</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>数量</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>费率/成本</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>税率</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>税</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>计费总额</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>小时费率</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>角色</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>工作类型</td>");
                            sb.Append("</tr>");
                            for (int i = 0; i < 8; i++)
                            {
                            sb.Append("<tr><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td><td style='text-align:Left;'>占位</td></tr>");
                            }
                            sb.Append("</table>");
                            this.body.Text = sb.ToString();
                            sb.Clear();
                    }
                    else
                    {
                        var Invoice_Body = new EMT.Tools.Serialize().DeserializeJson<InvioceTempDto.Invoice_Body>(tempinfo.body.Replace("'", "\""));//正文主体
                        int i = 0;//统计显示的列数
                        StringBuilder table = new StringBuilder();
                        table.Append("<table class='ReadOnlyGrid_Table'>");
                        table.Append("<tr>");
                        foreach (var coulmn in Invoice_Body.GRID_COLUMN)//获取需要显示的列名
                        {
                            if (coulmn.Display == "yes")
                            {
                                table.Append("<td class='ReadOnlyGrid_TableHeader' style='text-align: Left; '>" + coulmn.Column_label + "</td>");
                                i++;
                            }
                        }
                        table.Append("</tr>");
                        for (int j = 0; j < 8; j++)
                        {
                            table.Append("<tr>");
                            foreach (var coulmn in Invoice_Body.GRID_COLUMN)//获取需要显示的列名
                            {
                                if (coulmn.Display == "yes" && coulmn.Column_Content != "条目描述")
                                { table.Append("<td style='text-align: Left;' class='bord'>" + coulmn.Column_Content + "</td>"); }
                                if (coulmn.Display == "yes" && coulmn.Column_Content == "条目描述")
                                {
                                    table.Append("<td style='text-align: Left;'class='bord'>" + Invoice_Body.CUSTOMIZE_THE_ITEM_COLUMN[j].Display_Format + "</td>");
                                }
                                if (Invoice_Body.GRID_OPTIONS[0].Show_vertical_lines == "yes")
                                {
                                    Response.Write("<style>.bord{border-left: 1px solid  #eaeaea;border-right: 1px solid #eaeaea;}</style>");
                                }
                            }
                            table.Append("</tr>");
                        }
                        table.Append("</table>");
                        this.body.Text = table.ToString();
                        table.Clear();
                    }
                    //底部
                    if (!string.IsNullOrEmpty(tempinfo.bottom))
                    {
                        this.bottom.Text = HttpUtility.HtmlDecode(tempinfo.bottom.ToString()).Replace("\"", "'");

                    }
                    //页脚
                    if (!string.IsNullOrEmpty(tempinfo.foot))
                    {
                        this.foot.Text = HttpUtility.HtmlDecode(tempinfo.foot.ToString()).Replace("\"", "'");
                    }
                }
            }
        }
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            save();
            Session.Remove("tempinfo");
            Session["cancel"] = 1;
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        protected void Save_Click(object sender, EventArgs e)
        {
            save();
        }
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Session["cancel"] = 1;
            Session.Remove("tempinfo");
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        private void save()
        {
            QuoteTemplateBLL qtbll = new QuoteTemplateBLL();
            var sqt = qtbll.GetQuoteTemplate(id);
            if (sqt == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('获取数据错误！');history.go(-1);</script>");
            }
            tempinfo = Session["tempinfo"] as InvioceTempDto.TempContent;
            if (tempinfo != null&&tempinfo.id == id)
            {
                sqt.page_header_html=tempinfo.head;//页眉
                sqt.quote_header_html=tempinfo.top;//头部
                sqt.body_html=tempinfo.body;//主体
                sqt.quote_footer_html=tempinfo.bottom;//底部
                sqt.page_footer_html=tempinfo.foot;//页脚
                //bottom税相关
                sqt.show_tax_cate=(SByte)tempinfo.tax_cat;
                sqt.show_each_tax_in_tax_group= (SByte)tempinfo.tax_group;
                sqt.show_tax_cate_superscript= (SByte)tempinfo.tax_sup;
                //body分组
                sqt.body_group_by_id = tempinfo.body_group_by;
                sqt.body_itemize_id = tempinfo.body_itemize_id;
                sqt.body_order_by_id = tempinfo.body_order_by;
                sqt.show_labels_when_grouped =(SByte)tempinfo.show_labels_when_grouped;
                //bottom 合计
                sqt.tax_total_disp =tempinfo.Invoice_text;
                //底部备注
                sqt.quote_footer_notes=tempinfo.foot_note;
            }
            if (Session["copy"] != null)
            {
                string name = Session["copy"].ToString();
                Session.Remove("copy");
                sqt.name = name + sqt.name + Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var result = qtbll.Add(sqt, GetLoginUserId(), out id);
                if (result == ERROR_CODE.SUCCESS)        
                {
                    //id  获取副本插入时的id
                    Response.Write("<script>alert('发票模板副本成功添加成功！');window.location.href =QuoteTemplateEdit.aspx?id=" + id + ";</script>");  //  刷新页面
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
            }
            else
            {
                //更新保存
                var result = qtbll.update(sqt, GetLoginUserId());
                if (result == ERROR_CODE.SUCCESS)                    // 更新用户成功，刷新前一个页面
                {
                    Response.Write("<script>alert('发票模板修改成功！');</script>"); //关闭添加页面的同时，刷新父页面
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
            }
        }
    }
}