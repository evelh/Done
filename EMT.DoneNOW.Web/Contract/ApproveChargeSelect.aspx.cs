using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class ApproveChargeSelect : BasePage
    {
        protected int id;
        protected string ids;
        protected long type;
        protected List<string> ids1 = new List<string>();//可以选择两个
        protected List<string> ids2 = new List<string>();//只能强制生成
        protected List<string> ids3 = new List<string>();//正常处理的一部分
        ApproveAndPostBLL aapbll = new ApproveAndPostBLL();
        protected List<ApprovePostDto.ChargesSelectList> list = new List<ApprovePostDto.ChargesSelectList>();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out id))
            {
                id = 0;
            }
            ids = Convert.ToString(Request.QueryString["ids"]);
            if (!long.TryParse(Request.QueryString["type"], out type))
            {
                type = 0;
            }
            if (id == 0 && string.IsNullOrEmpty(ids) || id != 0 && !string.IsNullOrEmpty(ids) || type == 0)
            {
                Response.Write("<script>alert('异常');window.close();self.opener.location.reload();</script>");
            }

            //单个id审批
            if (id != 0)
            {
                var result = aapbll.ChargeBlock(id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    list.Add(aapbll.charge(id));
                }
                else if (result == ERROR_CODE.NOTIFICATION_RULE_RATE_NULL)
                {
                    list.Add(aapbll.charge(Convert.ToInt32(id)));
                    this.Radio2.Enabled = false;
                    this.Label1.ForeColor = System.Drawing.Color.Gray;
                }
            }

            //批量审批
            if (!string.IsNullOrEmpty(ids))
            {
                var idList = ids.Split(',');
                foreach (var idi in idList)
                {
                    var result = aapbll.ChargeBlock(Convert.ToInt32(idi));
                    if (result == DTO.ERROR_CODE.SUCCESS)
                    {
                        list.Add(aapbll.charge(Convert.ToInt32(idi)));
                        ids1.Add(idi);
                    }
                    else if (result == ERROR_CODE.NOTIFICATION_RULE_RATE_NULL)
                    {
                        list.Add(aapbll.charge(Convert.ToInt32(idi)));
                        this.Radio2.Enabled = false;
                        this.Label1.ForeColor = System.Drawing.Color.Gray;
                    }
                    else {

                    }
                }
            }
            if (list == null || list.Count <= 0)
            {
                if (id > 0)
                {
                    Response.Redirect("../Contract/ContractPostDate.aspx?type=" + type + "&id=" + id);
                }
                else
                {
                    Response.Redirect("../Contract/ContractPostDate.aspx?type=" + type + "&ids=" + ids);
                }
            }
            else {
                string info = "<script>$('#default').show();</script>";
                if (!Page.ClientScript.IsStartupScriptRegistered("kkk"))
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "kkk", info);
                }
            }
        }
        #region 此处关闭10-9
        //protected void Post_Click(object sender, EventArgs e)
        //{
        //    //string tt = Request.Form["post_date"].Trim().ToString();//获取时间
        //    if (this.Radio1.Checked)
        //    {
        //        Response.Write("<script>window.close();</script>");
        //        //if (id != 0)
        //        //{
        //        //    //Response.Write("<script>window.close(); window.open('../Contract/ContractPostDate.aspx?type=" + type + "&id='" + id + ", '" + (int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate + "', 'left=0,top=0,location=no,status=no,width=900,height=750', false);</script>");
        //        //    //var result = aapbll.Post(Convert.ToInt32(id), Convert.ToInt32(tt), type, GetLoginUserId());
        //        //    //if (result == ERROR_CODE.ERROR)
        //        //    //{
        //        //    //    Response.Write("<script>alert('" + id + "审批失败！');</script>");
        //        //    //}
        //        //    //else
        //        //    //{
        //        //    //    Response.Write("<script>alert('审批成功！');window.close();self.opener.location.reload();</script>");
        //        //    //}
        //        //}
        //        //else
        //        //{
        //        //    foreach (var i in ids2)
        //        //    {
        //        //        var result = aapbll.Post(Convert.ToInt32(i), Convert.ToInt32(tt), type, GetLoginUserId());
        //        //        if (result == ERROR_CODE.ERROR)
        //        //        {
        //        //            Response.Write("<script>alert('" + i + "审批失败！');</script>");
        //        //        }
        //        //    }
        //        //    Response.Write("<script>alert('批量审批结束！');window.close();self.opener.location.reload();</script>");
        //        //}

        //    }
        //    else if (this.Radio2.Checked)
        //    {
        //        if (id != 0)
        //        {
        //            Response.Write("<script>window.close(); window.open('../Contract/ContractPostDate.aspx?type=" + type + "&id='" + id + "&op=post_a, '" + (int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate + "', 'left=0,top=0,location=no,status=no,width=900,height=750', false);</script>");

        //            //var result = aapbll.Post_Charges_a(Convert.ToInt32(id), Convert.ToInt32(tt), GetLoginUserId());
        //            //if (result == ERROR_CODE.ERROR)
        //            //{
        //            //    Response.Write("<script>alert('" + id + "审批失败！');</script>");
        //            //}
        //            //else
        //            //{
        //            //    Response.Write("<script>alert('审批成功！');window.close();self.opener.location.reload();</script>");
        //            //}
        //        }
        //        else
        //        {
        //            Response.Write("<script>window.close(); window.open('../Contract/ContractPostDate.aspx?type=" + type + "&ids='" + ids1.ToString() + "&op=post_a, '" + (int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate + "', 'left=0,top=0,location=no,status=no,width=900,height=750', false);</script>");
        //            //if (ids2.Count > 0)
        //            //{
        //            //    foreach (var i in ids2)
        //            //    {
        //            //        var result = aapbll.Post(Convert.ToInt32(i), Convert.ToInt32(tt), type, GetLoginUserId());
        //            //        if (result == ERROR_CODE.ERROR)
        //            //        {
        //            //            Response.Write("<script>alert('" + i + "审批失败！');</script>");
        //            //        }
        //            //    }
        //            //}
        //            //foreach (var ii in ids1)
        //            //{
        //            //    var result = aapbll.Post_Charges_a(Convert.ToInt32(id), Convert.ToInt32(tt), GetLoginUserId());
        //            //    if (result == ERROR_CODE.ERROR)
        //            //    {
        //            //        Response.Write("<script>alert('" + id + "审批失败！');</script>");
        //            //    }
        //            //}
        //            //Response.Write("<script>alert('批量审批结束！');window.close();self.opener.location.reload();</script>");
        //        }
        //    }
        //    else if (this.Radio3.Checked)
        //    {
        //        if (id != 0)
        //        {
        //            Response.Write("<script>window.close(); window.open('../Contract/ContractPostDate.aspx?type=" + type + "&id='" + id + "&op=post_b, '" + (int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate + "', 'left=0,top=0,location=no,status=no,width=900,height=750', false);</script>");
        //            //var result = aapbll.Post_Charges_b(Convert.ToInt32(id), Convert.ToInt32(tt), GetLoginUserId());
        //            //if (result == ERROR_CODE.ERROR)
        //            //{
        //            //    Response.Write("<script>alert('" + id + "审批失败！');</script>");
        //            //}
        //            //else
        //            //{
        //            //    Response.Write("<script>alert('审批成功！');window.close();self.opener.location.reload();</script>");
        //            //}
        //        }
        //        else
        //        {
        //            Response.Write("<script>window.close(); window.open('../Contract/ContractPostDate.aspx?type=" + type + "&ids='" + ids1.ToString() + "&op=post_b, '" + (int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate + "', 'left=0,top=0,location=no,status=no,width=900,height=750', false);</script>");
        //            //if (ids2.Count > 0)
        //            //{
        //            //    foreach (var i in ids2)
        //            //    {
        //            //        var result = aapbll.Post(Convert.ToInt32(i), Convert.ToInt32(tt), type, GetLoginUserId());
        //            //        if (result == ERROR_CODE.ERROR)
        //            //        {
        //            //            Response.Write("<script>alert('" + i + "审批失败！');</script>");
        //            //        }
        //            //    }
        //            //}
        //            //foreach (var ii in ids1)
        //            //{
        //            //    var result = aapbll.Post_Charges_b(Convert.ToInt32(id), Convert.ToInt32(tt), GetLoginUserId());
        //            //    if (result == ERROR_CODE.ERROR)
        //            //    {
        //            //        Response.Write("<script>alert('" + id + "审批失败！');</script>");
        //            //    }
        //            //}
        //            //Response.Write("<script>alert('批量审批结束！');window.close();self.opener.location.reload();</script>");
        //        }
        //    }
        //}
#endregion
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (this.Radio1.Checked)
            {
                Response.Write("<script>window.close();</script>");
            }
            else if (this.Radio2.Checked)
            {
                if (id != 0)
                {
                    Response.Redirect("../Contract/ContractPostDate.aspx?op=post_a&type=" + type + "&id=" + id);
                }
                else
                {
                    Response.Redirect("../Contract/ContractPostDate.aspx?op=post_a&type=" + type + "&ids=" + ids);
                }
            }
            else if (this.Radio3.Checked)
            {
                if (id != 0)
                {
                    Response.Redirect("../Contract/ContractPostDate.aspx?op=post_b&type=" + type + "&id=" + id);
                }
                else
                {
                    Response.Redirect("../Contract/ContractPostDate.aspx?op=post_b&type=" + type + "&ids=" + ids);
                }
            }
        }
    }
}