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


namespace EMT.DoneNOW.Web
{
    public partial class QuoteTemplateEdit : BasePage
    {
        //public string ht;
        public int id;
        public string op;
        //public bool copy = false;
        protected void Page_Load(object sender, EventArgs e)
        {
           // Session.Timeout = 30;设置该页面的session过期时间
            id = Convert.ToInt32(Request.QueryString["id"]);
            if (!IsPostBack) {               
                QuoteTemplateBLL qtb = new QuoteTemplateBLL();
                if (Request.QueryString["op"] == null||string.IsNullOrEmpty(Request.QueryString["op"].ToString()))
                {
                    
                    if (qtb.is_quote(id) == DTO.ERROR_CODE.ERROR)//判断报价模板是否被引用
                    {
                        Response.Write("<script>if(window.confirm('模板被报价引用，如果修改会影响到这些报价。你如果你不想影响这些报价，可以复制一个新的模板，然后对新模板进行修改。是否继续？?')){}else{history.go(-1);}</script>");
                        //复制一个报价模板
                        Session["copy"] ="copy";
                    }
                }                           
                    //填充数据
                    var data = qtb.GetQuoteTenplate(id);
                    if (data == null)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('获取数据错误！');history.go(-1);</script>");
                    }
                //页眉
                if (Session["page_head"] != null)
                {
                    this.head.Text = HttpUtility.HtmlDecode(Session["page_head"].ToString()).Replace("\"", "'");
                }
                else {
                    if (string.IsNullOrEmpty(data.page_header_html))
                    {
                        Session["page_head"] = this.head.Text = "";
                    }
                    else {
                        Session["page_head"] = this.head.Text = HttpUtility.HtmlDecode(data.page_header_html).Replace("\"", "'");
                    }                                  
                }
                //头部
                if (Session["quote_head"] != null )
                {
                    this.top.Text = HttpUtility.HtmlDecode(Session["quote_head"].ToString()).Replace("\"", "'");
                }

                else {
                    if (string.IsNullOrEmpty(data.quote_header_html))
                    {
                        Session["quote_head"] = this.top.Text = "";
                    }
                    else {
                        Session["quote_head"] = this.top.Text = HttpUtility.HtmlDecode(data.quote_header_html);
                    }
                    
                }
                //正文body

                //正在进行中

                if (Session["quote_body"] == null) {

                    if (string.IsNullOrEmpty(data.body_html))
                    {
                        Session["quote_body"] = "";
                    }
                    else
                    {
                        Session["quote_body"] = HttpUtility.HtmlDecode(data.body_html).Replace("\"", "'");
                    }
                }

                //底部
                if (Session["quote_foot"] != null )
                {
                    this.bottom.Text = HttpUtility.HtmlDecode(Session["quote_foot"].ToString()).Replace("\"", "'");
                   
                }
                else {
                    if (string.IsNullOrEmpty(data.quote_footer_html))
                    {
                        Session["quote_foot"] = this.bottom.Text = "";
                    }
                    else {
                        Session["quote_foot"] = this.bottom.Text = HttpUtility.HtmlDecode(data.quote_footer_html).Replace("\"", "'");
                    }                  

                }
                //页脚
                if (Session["page_foot"] != null )
                {
                    this.foot.Text = HttpUtility.HtmlDecode(Session["page_foot"].ToString()).Replace("\"", "'");
                }
                else {
                    if (string.IsNullOrEmpty(data.page_footer_html))
                    {
                        Session["page_foot"] = this.foot.Text = "";
                    }
                    else {
                        Session["page_foot"] = this.foot.Text = HttpUtility.HtmlDecode(data.page_footer_html).Replace("\"", "'");
                    }
                }


                if (Session["page_appendix"] != null && !string.IsNullOrEmpty(Session["page_appendix"].ToString()))
                {
                 
                }
                else
                {
                    if (string.IsNullOrEmpty(data.quote_footer_notes))
                    {
                        Session["page_appendix"] ="";
                    }
                    else
                    {
                        Session["page_appendix"] = HttpUtility.HtmlDecode(data.quote_footer_notes).Replace("\"", "'");
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
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
            //Response.Redirect("");//返回报价模板管理界面
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
            var sqt = qtbll.GetQuoteTenplate(id);
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


            // Response.Write(sqt.id+","+sqt.page_header_html+","+ sqt.quote_header_html+","+ sqt.page_header_html+","+ sqt.body_html+","+ sqt.quote_footer_html+"," + sqt.page_footer_html);


            if (Session["copy"] != null)
            {
                Session.Remove("copy");
                //保存副本
                //sqt.id = (int)(_dal.GetNextIdCom());
                var result = qtbll.Add(sqt, GetLoginUserId(), out id);
                if (result == ERROR_CODE.SUCCESS)                    // 
                {
                    //id  获取副本插入时的id
                    Response.Write("<script>alert('报价模板副本成功添加成功！');window.location.href =QuoteTemplateEdit.aspx?id=" + id + ";</script>");  //  刷新页面
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
                    Response.Write("<script>alert('报价模板修改成功！');</script>");  //  关闭添加页面的同时，刷新父页面
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
            }


            //写一个窗口关闭事件


           
        }



    }
}