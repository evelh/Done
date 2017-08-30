using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.CRM;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.SaleOrder
{
    public partial class SaleOrderView : BasePage
    {
        protected crm_sales_order sale_order = null;
        protected crm_opportunity opportunity = null;
        protected crm_account account = null;
        protected crm_contact contact = null;
        protected Dictionary<string, object> dic = new SaleOrderBLL().GetField();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var sid = Request.QueryString["id"];
            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}