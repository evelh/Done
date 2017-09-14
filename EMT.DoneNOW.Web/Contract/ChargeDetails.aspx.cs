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

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ChargeDetails : BasePage
    {
        protected ctt_contract_cost conCost = null;
        protected void Page_Load(object sender, EventArgs e)
        {

            try
            {
                conCost = new ctt_contract_cost_dal().FindNoDeleteById(long.Parse(Request.QueryString["id"]));
            }
            catch (Exception)
            {

                Response.End();
                Response.Write("<script>alert('成本不存在！');window.close();</script>");
            }
        }
    }
}