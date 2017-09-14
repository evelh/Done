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
            if (!int.TryParse(Request.QueryString["id"], out id))
            {
                id = 0;
            }
            ids = Convert.ToString(Request.QueryString["ids"]);
            if (!long.TryParse(Request.QueryString["type"], out type))
            {
                type = 0;
            }
            if (id == 0 && string.IsNullOrEmpty(ids)||type==0) {
                Response.Write("<script>alert('异常！');window.close();self.opener.location.reload();</script>");
            }
           
        }

        protected void Post_Click(object sender, EventArgs e)
        {
            string tt = Request.Form["post_date"].Trim().ToString();//获取时间
            //单个审批
            if (id != 0)
            {
               var result=aapbll.Post(id,Convert.ToInt32(tt),type,GetLoginUserId());
            }
            else
            {//批量审批
                if (!string.IsNullOrEmpty(ids))
                {
                    var idList = ids.Split(',');
                    foreach (var idi in idList)
                    {
                        var result=aapbll.Post(Convert.ToInt32(idi),Convert.ToInt32(tt),type,GetLoginUserId());
                    }
                }
            }

        }
    }
}