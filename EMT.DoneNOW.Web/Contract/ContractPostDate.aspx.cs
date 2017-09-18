using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class ContractPostDate : BasePage
    {
        private int id;
        private string ids;
        private long type;
        ApproveAndPostBLL aapbll = new ApproveAndPostBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!int.TryParse(Request.QueryString["id"], out id))
            //{
            //    id = 0;
            //}
            //ids = Convert.ToString(Request.QueryString["ids"]);
            //if (!long.TryParse(Request.QueryString["type"], out type))
            //{
            //    type = 0;
            //}
            //if (id == 0 && string.IsNullOrEmpty(ids)||type==0) {
            //    Response.Write("<script>alert('异常！');window.close();self.opener.location.reload();</script>");
            //}
        }
        protected void Post_Click(object sender, EventArgs e)
        {
            string tt = Request.Form["post_date"].Trim().ToString();//获取时间
            //单个审批
            if (id != 0)
            {
                if (type == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_CHARGES) {
                    var result1 = aapbll.ChargeBlock(id);
                        if (result1==DTO.ERROR_CODE.SUCCESS||result1==DTO.ERROR_CODE.NOTIFICATION_RULE_RATE_NULL)
                        {
                        //打开新窗口
                        int rate_null = 1;
                        if (result1 == DTO.ERROR_CODE.NOTIFICATION_RULE_RATE_NULL) {
                            rate_null = 0;
                        }
                        Response.Write("<script>window.open('Contract/ApproveChargeSelect.aspx?rate_null="+ rate_null + "&date=" + tt +"&id='"+id+", '"+(int)EMT.DoneNOW.DTO.OpenWindow.ContractChargeSelect+ ", 'left=0,top=0,location=no,status=no,width=900,height=750', false);</script>");



                        }
                        else
                        {
                        var result = aapbll.Post(id, Convert.ToInt32(tt), type, GetLoginUserId());
                        if (result == DTO.ERROR_CODE.SUCCESS)
                        {
                            Response.Write("<script>alert('审批成功！');window.close();self.opener.location.reload();</script>");
                        }
                        else
                        {
                            Response.Write("<script>alert('审批失败！');window.close();self.opener.location.reload();</script>");
                        }
                    }
                } else {
                    var result = aapbll.Post(id, Convert.ToInt32(tt), type, GetLoginUserId());
                    if (result == DTO.ERROR_CODE.SUCCESS)
                    {
                        Response.Write("<script>alert('审批成功！');window.close();self.opener.location.reload();</script>");
                    }
                    else
                    {
                        Response.Write("<script>alert('审批失败！');window.close();self.opener.location.reload();</script>");
                    }
                }              
            }
            else
            {//批量审批                

                if (!string.IsNullOrEmpty(ids))
                {
                    var idList = ids.Split(',');
                    if (type == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_CHARGES)
                    {
                        foreach (var idi in idList)
                        {
                            var result1 = aapbll.ChargeBlock(id);
                            if (result1 == DTO.ERROR_CODE.SUCCESS || result1 == DTO.ERROR_CODE.NOTIFICATION_RULE_RATE_NULL)
                            {
                                //如果成本关联预付费合同，则需要从预付费中扣除费用。系统需要判断预付费是否足够，如果不够可以选择：取消、自动生成预付费、强制生成（不够的部分单独生成一个条目）
                                //打开新窗口
                                int rate_null = 1;
                                if (result1 == DTO.ERROR_CODE.NOTIFICATION_RULE_RATE_NULL)
                                {
                                    rate_null = 0;
                                }


                                Response.Write("<script>window.open('ApproveChargeSelect.aspx?rate_null=" + rate_null + "&date="+ tt+ "&id='" + id + ", '" + (int)EMT.DoneNOW.DTO.OpenWindow.ContractChargeSelect + ", 'left=0,top=0,location=no,status=no,width=900,height=750', false);</script>");


                            }
                            else
                            {
                                var result = aapbll.Post(Convert.ToInt32(idi), Convert.ToInt32(tt), type, GetLoginUserId());
                                if (result != DTO.ERROR_CODE.SUCCESS)
                                {
                                    Response.Write("<script>alert('" + idi + "审批失败！');</script>");
                                }
                            }
                        }
                    }
                    else
                    {                       
                        foreach (var idi in idList)
                        {
                            var result = aapbll.Post(Convert.ToInt32(idi), Convert.ToInt32(tt), type, GetLoginUserId());
                            if (result != DTO.ERROR_CODE.SUCCESS)
                            {
                                Response.Write("<script>alert('" + idi + "审批失败！');</script>");
                            }
                        }
                    }
                    Response.Write("<script>alert('批量审批结束！');window.close();self.opener.location.reload();</script>");
                }
                else {
                    Response.Write("<script>alert('数据获取失败！');window.close();self.opener.location.reload();</script>");
                }
            }
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
    }
}