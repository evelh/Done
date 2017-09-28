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
    public partial class ApproveChargeSelect :BasePage
    {
        protected int id;
        protected string ids;
        protected long type;
        protected List<string> ids1=new List<string> ();//合同预付费不足够
        protected List<string> ids2=new List<string> ();//正常处理
        ApproveAndPostBLL aapbll = new ApproveAndPostBLL();
        protected List<ApprovePostDto.ChargesSelectList> list=new List<ApprovePostDto.ChargesSelectList> ();
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
                if (id != 0)
                {
                    var result = aapbll.ChargeBlock(id);
                    if (result == DTO.ERROR_CODE.SUCCESS)
                    {
                        list.Add(aapbll.charge(id));
                    }
                }
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
                    else if (result == ERROR_CODE.ERROR)
                    {
                        ids2.Add(idi);
                    }
                    else {

                    }
                    }
                }
                if (list == null || list.Count <= 0)
                {
                    string myScript = @"$('#default').hide();$('#postdate').show();";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "MyScript", myScript, true);
                }           
        }
        protected void Post_Click(object sender, EventArgs e)
        {
            string tt = Request.Form["post_date"].Trim().ToString();//获取时间
            if (this.Radio1.Checked)
            {
                if (id != 0)
                {
                    var result = aapbll.Post(Convert.ToInt32(id), Convert.ToInt32(tt),type, GetLoginUserId());
                    if (result == ERROR_CODE.ERROR)
                    {
                        Response.Write("<script>alert('" + id + "审批失败！');</script>");
                    }
                    else
                    {
                        Response.Write("<script>alert('审批成功！');window.close();self.opener.location.reload();</script>");
                    }
                }
                else
                {
                    foreach (var i in ids2)
                    {
                        var result = aapbll.Post(Convert.ToInt32(i), Convert.ToInt32(tt), type, GetLoginUserId());
                        if (result == ERROR_CODE.ERROR)
                        {
                            Response.Write("<script>alert('" + i + "审批失败！');</script>");
                        }
                    }
                    Response.Write("<script>alert('批量审批结束！');window.close();self.opener.location.reload();</script>");
                }
                
            }
            else if (this.Radio2.Checked)
            {
                if (id != 0)
                {
                    var result = aapbll.Post_Charges_a(Convert.ToInt32(id), Convert.ToInt32(tt), GetLoginUserId());
                    if (result == ERROR_CODE.ERROR)
                    {
                        Response.Write("<script>alert('" + id + "审批失败！');</script>");
                    }
                    else
                    {
                        Response.Write("<script>alert('审批成功！');window.close();self.opener.location.reload();</script>");
                    }
                }
                else
                {
                    if (ids2.Count > 0)
                    {
                        foreach (var i in ids2)
                        {
                            var result = aapbll.Post(Convert.ToInt32(i), Convert.ToInt32(tt), type, GetLoginUserId());
                            if (result == ERROR_CODE.ERROR)
                            {
                                Response.Write("<script>alert('" + i + "审批失败！');</script>");
                            }
                        }
                    }
                    foreach (var ii in ids1)
                    {
                        var result = aapbll.Post_Charges_a(Convert.ToInt32(id), Convert.ToInt32(tt), GetLoginUserId());
                        if (result == ERROR_CODE.ERROR)
                        {
                            Response.Write("<script>alert('" + id + "审批失败！');</script>");
                        }
                    }
                    Response.Write("<script>alert('批量审批结束！');window.close();self.opener.location.reload();</script>");
                }
            }
            else if (this.Radio3.Checked)
            {
                if (id != 0)
                {
                    var result = aapbll.Post_Charges_b(Convert.ToInt32(id), Convert.ToInt32(tt), GetLoginUserId());
                    if (result == ERROR_CODE.ERROR)
                    {
                        Response.Write("<script>alert('" + id + "审批失败！');</script>");
                    }
                    else
                    {
                        Response.Write("<script>alert('审批成功！');window.close();self.opener.location.reload();</script>");
                    }
                }
                else
                {
                    if (ids2.Count > 0)
                    {
                        foreach (var i in ids2)
                        {
                            var result = aapbll.Post(Convert.ToInt32(i), Convert.ToInt32(tt), type, GetLoginUserId());
                            if (result == ERROR_CODE.ERROR)
                            {
                                Response.Write("<script>alert('" + i + "审批失败！');</script>");
                            }
                        }
                    }
                    foreach (var ii in ids1)
                    {
                        var result = aapbll.Post_Charges_b(Convert.ToInt32(id), Convert.ToInt32(tt), GetLoginUserId());
                        if (result == ERROR_CODE.ERROR)
                        {
                            Response.Write("<script>alert('" + id + "审批失败！');</script>");
                        }
                    }
                    Response.Write("<script>alert('批量审批结束！');window.close();self.opener.location.reload();</script>");
                }
            }
            else {
                if (id != 0)
                {
                    var result = aapbll.Post(Convert.ToInt32(id), Convert.ToInt32(tt), type, GetLoginUserId());
                    if (result == ERROR_CODE.ERROR)
                    {
                        Response.Write("<script>alert('" + id + "审批失败！');</script>");
                    }
                    else
                    {
                        Response.Write("<script>alert('审批成功！');window.close();self.opener.location.reload();</script>");
                    }
                }
                else
                {
                    foreach (var i in ids2)
                    {
                        var result = aapbll.Post(Convert.ToInt32(i), Convert.ToInt32(tt), type, GetLoginUserId());
                        if (result == ERROR_CODE.ERROR)
                        {
                            Response.Write("<script>alert('" + i + "审批失败！');</script>");
                        }
                    }
                    Response.Write("<script>alert('批量审批结束！');window.close();self.opener.location.reload();</script>");
                }
            }           
        }
    }
}