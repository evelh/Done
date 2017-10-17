using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using System;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Web;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteTemplateEdit : BasePage
    {
        public int id;
        public string op;
        protected string tempname;
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            if (!IsPostBack)
            {
                if(Session["cancel"]!=null&&(int)Session["cancel"]!=1)
                {
                    Cancel1();
                }
                Session["cancel"] = 0;
                QuoteTemplateBLL qtb = new QuoteTemplateBLL();
                if (Request.QueryString["op"] == null||string.IsNullOrEmpty(Request.QueryString["op"].ToString()))
                {                    
                    if (qtb.is_quote(id) == DTO.ERROR_CODE.ERROR)//判断报价模板是否被引用
                    {
                        Response.Write("<script>if(confirm('模板被报价引用，如果修改会影响到这些报价。你如果你不想影响这些报价，可以复制一个新的模板，然后对新模板进行修改。是否继续?')==true){}else{window.close();}</script>");
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
                    tempname = data.name;
                    //页眉
                    if (Session["page_head"] != null && !string.IsNullOrEmpty(Session["page_head"].ToString()))
                    {
                        this.head.Text = HttpUtility.HtmlDecode(Session["page_head"].ToString()).Replace("\"", "'");
                    }
                    else
                    {
                        if (string.IsNullOrEmpty(data.page_header_html))
                        {
                            Session["page_head"] = this.head.Text = " ";
                        }
                        else
                        {
                            Session["page_head"] = this.head.Text = HttpUtility.HtmlDecode(data.page_header_html).Replace("\"", "'");
                        }
                    }
                    //头部
                    if (Session["quote_head"] != null)
                    {
                        this.top.Text = HttpUtility.HtmlDecode(Session["quote_head"].ToString()).Replace("\"", "'");
                    }

                    else
                    {
                        if (string.IsNullOrEmpty(data.quote_header_html))
                        {
                            Session["quote_head"] = this.top.Text = " ";
                        }
                        else
                        {
                            Session["quote_head"] = this.top.Text = HttpUtility.HtmlDecode(data.quote_header_html).Replace("\"", "'");
                        }

                    }
                    //正文body

                    //正在进行中
                    string body_json = string.Empty;
                    if (Session["quote_body"] == null|| string.IsNullOrEmpty(Session["quote_body"].ToString()))
                    {
                        if (string.IsNullOrEmpty(data.body_html))
                        {
                            //Session["quote_body"] = ";
                            //填充默认
                            StringBuilder sb = new StringBuilder();
                            sb.Append("<table class='ReadOnlyGrid_Table'>");
                            sb.Append("<tr>");
                            sb.Append("<td class='ReadOnlyGrid_TableHeader' style='text-align: Left;' width='40px;'>序列号</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>数量</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Left;'>报价项名称</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>单价</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>单元折扣t</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>折后价</td><td class='ReadOnlyGrid_TableHeader' style='text-align: Right;'>总价</td>");
                            sb.Append("</tr>");
                            for (int i = 0; i < 8; i++)
                            {
                                sb.Append("<tr><td style='text - align: Left; '>[Quote Item:Number]</td><td class='ReadOnlyGrid_TableHeader' style='text - align: Left; '>[Quote Item:Quantity]</td><td class='ReadOnlyGrid_TableHeader' style='text - align: Left; '>[Quote Item:Name]<br/>[Quote Item:Item Description]</td><td class='ReadOnlyGrid_TableHeader' style='text - align: Left; '>[Quote Item:Unit Price]</td><td class='ReadOnlyGrid_TableHeader' style='text - align: Left; '>[Quote Item:Unit Discount]</td><td class='ReadOnlyGrid_TableHeader' style='text - align: Left; '>[Quote Item:Adjusted Unit Price]</td><td class='ReadOnlyGrid_TableHeader' style='text - align: Left; '>[Quote Item:Extended Price]</td></tr>");
                            }
                            sb.Append("</table>");
                            this.body.Text = sb.ToString();
                            sb.Clear();
                        }
                        else
                        {
                            Session["quote_body"] = HttpUtility.HtmlDecode(data.body_html).Replace("\"", "'");
                            body_json = Session["quote_body"].ToString();
                        }
                    }
                    else
                    {
                        body_json = Session["quote_body"].ToString();
                    }

                    if (!string.IsNullOrEmpty(body_json))
                    {
                        var quote_body = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.BODY>(body_json.Replace("'", "\""));//正文主体
                        int i = 0;//统计显示的列数
                        StringBuilder table = new StringBuilder();
                        table.Append("<table class='ReadOnlyGrid_Table'>");
                        table.Append("<tr>");
                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
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
                            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                            {
                                if (coulmn.Display == "yes" && coulmn.Column_Content != "报价项名称")
                                { table.Append("<td style='text-align: Left;' class='bord'>" + coulmn.Column_Content + "</td>"); }
                                if (coulmn.Display == "yes" && coulmn.Column_Content == "报价项名称")
                                {
                                    table.Append("<td style='text-align: Left;'class='bord'>" + quote_body.CUSTOMIZE_THE_ITEM_COLUMN[j].Display_Format + "</td>");
                                }
                                if (quote_body.GRID_OPTIONS[0].Show_vertical_lines == "yes")
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
                    if (Session["quote_foot"] != null)
                    {
                        this.bottom.Text = HttpUtility.HtmlDecode(Session["quote_foot"].ToString()).Replace("\"", "'");

                    }
                    else
                    {
                        if (string.IsNullOrEmpty(data.quote_footer_html))
                        {
                            Session["quote_foot"] = this.bottom.Text = " ";
                        }
                        else
                        {
                            Session["quote_foot"] = this.bottom.Text = HttpUtility.HtmlDecode(data.quote_footer_html).Replace("\"", "'");
                        }

                    }
                    //页脚
                    if (Session["page_foot"] != null)
                    {
                        this.foot.Text = HttpUtility.HtmlDecode(Session["page_foot"].ToString()).Replace("\"", "'");
                    }
                    else
                    {
                        if (string.IsNullOrEmpty(data.page_footer_html))
                        {
                            Session["page_foot"] = this.foot.Text = " ";
                        }
                        else
                        {
                            Session["page_foot"] = this.foot.Text = HttpUtility.HtmlDecode(data.page_footer_html).Replace("\"", "'");
                        }
                    }


                    if (Session["page_appendix"] == null || string.IsNullOrEmpty(Session["page_appendix"].ToString()))
                    {
                        if (string.IsNullOrEmpty(data.quote_footer_notes))
                        {
                            Session["page_appendix"] = " ";
                        }
                        else
                        {
                            Session["page_appendix"] = HttpUtility.HtmlDecode(data.quote_footer_notes).Replace("\"", "'");
                        }
                    }
                }
            }         

        }
        /// <summary>
        /// 保存并关闭该界面，跳到报价管理界面
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            save();
            if (Session["page_head"] != null)
            {
                Session.Remove("page_head");
            }
            if (Session["quote_head"] != null)
            {
                Session.Remove("quote_head");
            }
            if (Session["quote_body"] != null)
            {
                Session.Remove("quote_body");
            }
            if (Session["quote_foot"] != null)
            {
                Session.Remove("quote_foot");
            }
            if (Session["page_foot"] != null)
            {
                Session.Remove("page_foot");
            }
            if (Session["page_appendix"] != null)
            {
                Session.Remove("page_appendix");
            }
            Session["cancel"] = 1;
            //Response.Redirect("");//返回报价模板管理界面
            Response.Write("<script>window.close();self.opener.location.reload();</script>");

        }
        /// <summary>
        ///取消编辑，返回报价模板管理界面
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Session["cancel"] = 1;
            Cancel1();
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
            //Response.Redirect("");//返回报价模板管理界面
        }
        private void Cancel1() {
            if (Session["page_head"] != null)
            {
                Session.Remove("page_head");
            }
            if (Session["quote_head"] != null)
            {
                Session.Remove("quote_head");
            }
            if (Session["quote_body"] != null)
            {
                Session.Remove("quote_body");
            }
            if (Session["quote_foot"] != null)
            {
                Session.Remove("quote_foot");
            }
            if (Session["page_foot"] != null)
            {
                Session.Remove("page_foot");
            }
            if (Session["page_appendix"] != null)
            {
                Session.Remove("page_appendix");
            }
        }
        /// <summary>
        /// 取消
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Save_Click(object sender, EventArgs e)
        {
            save();
        }

        private void save() {
            QuoteTemplateBLL qtbll = new QuoteTemplateBLL();
            var sqt = qtbll.GetQuoteTemplate(id);
            if (sqt == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('获取数据错误！');history.go(-1);</script>");
            }
            //sys_quote_tmpl sqt = new sys_quote_tmpl();
            if (Session["page_head"] != null)
            {
                sqt.page_header_html = Session["page_head"].ToString();
            }
            if (Session["quote_head"] != null)
            {
                sqt.quote_header_html = Session["quote_head"].ToString();
            }
            if (Session["quote_body"] != null)
            {
                sqt.body_html = Session["quote_body"].ToString();
            }
            if (Session["quote_foot"] != null)
            {
                sqt.quote_footer_html= Session["quote_foot"].ToString();
            }
            if (Session["page_foot"] != null)
            {
                sqt.page_footer_html = Session["page_foot"].ToString();
            }
            if (Session["page_appendix"] != null)
            {
                sqt.quote_footer_notes= Session["page_appendix"].ToString();
            }

            //if (Session["copy"] != null)
            //{
            //    string name = Session["copy"].ToString();
            //    Session.Remove("copy");
            //    //保存副本
            //    //sqt.id = (int)(_dal.GetNextIdCom());
            //    sqt.is_system = 0;
            //    sqt.is_default = 0;
            //    sqt.name = name+sqt.name+Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //    var result = qtbll.Add(sqt, GetLoginUserId(), out id);
            //    if (result == ERROR_CODE.SUCCESS)                    // 
            //    {
            //        //id  获取副本插入时的id
            //        Response.Write("<script>alert('报价模板副本成功添加成功！');</script>");  //  刷新页面
            //    }
            //    else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            //    {
            //        Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
            //        Response.Redirect("Login.aspx");
            //    }
            //}
            //else
            //{
                //更新保存
                var result = qtbll.update(sqt, GetLoginUserId());
                if (result == ERROR_CODE.SUCCESS)                    // 更新用户成功，刷新前一个页面
                {
                    Response.Write("<script>alert('报价模板修改成功！');</script>");  //  关闭添加页面的同时，刷新父页面
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
            //}

        }
        //转PDF,还没有完成9-26
        protected void ToPdf_Click(object sender, EventArgs e)
        {
            var data = new QuoteTemplateBLL().GetQuoteTemplate(id);
            string savepath = string.Format("C:\\DoneNowNET" + "\\" + data.name + ".pdf");//最终保存
            string url = Request.Url.ToString();
            try
            {
                if (!string.IsNullOrEmpty(url) || !string.IsNullOrEmpty(savepath))
                {
                    Process p = new Process();
                    string dllstr = string.Format("C:\\Program Files (x86)\\wkhtmltopdf\\bin\\wkhtmltopdf.exe");
                    if (File.Exists(dllstr))
                    {
                        p.StartInfo.FileName = dllstr;
                        p.StartInfo.Arguments = " \"" + url + "\"  \"" + savepath + "\"";
                        p.StartInfo.UseShellExecute = false;
                        p.StartInfo.RedirectStandardInput = true;
                        p.StartInfo.RedirectStandardOutput = true;
                        p.StartInfo.RedirectStandardError = true;
                        p.StartInfo.CreateNoWindow = true;
                        p.Start();
                        p.WaitForExit();
                        try
                        {
                            FileStream fs = new FileStream(savepath, FileMode.Open);
                            byte[] file = new byte[fs.Length];
                            fs.Read(file, 0, file.Length);
                            fs.Close();
                            Response.Clear();
                            Response.AddHeader("content-disposition", "attachment; filename=" + data.name + ".pdf");//強制下載 
                            Response.ContentType = "application/octet-stream";
                            Response.BinaryWrite(file);
                        }
                        catch (Exception ee)
                        { 
                            throw new Exception(ee.ToString());
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
    }
}