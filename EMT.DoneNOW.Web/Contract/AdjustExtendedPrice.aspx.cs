using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web
{
    public partial class AdjustExtendedPrice : BasePage
    {
        private int id;
        private long type;
        protected string name;
        protected decimal period_price;
        ApproveAndPostBLL aapbll = new ApproveAndPostBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out id))
            {
                id = 0;
            }
            if (!long.TryParse(Request.QueryString["type"], out type))
            {
                type = 0;
            }
            if (id == 0 || type == 0)
            {
                Response.Write("<script>alert('异常！');window.close();self.opener.location.reload();</script>");
            }
            if (!IsPostBack) {
                decimal extend;//总价
                name = aapbll.GetAdjustExtend(id, type, out extend);
                Extended_Price.Text = extend.ToString();
            }               
        }
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            string kk = this.Extended_Price.Text.Trim().ToString();
                period_price = Convert.ToDecimal(kk);
                var result = aapbll.UpdateExtendedPrice(id, period_price, GetLoginUserId(),type);
                if (result == ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>window.close();self.opener.location.reload();</script>");
                }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
    }
}