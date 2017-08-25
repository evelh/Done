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

namespace EMT.DoneNOW.Web.Opportunity
{
    public partial class CloseOpportunity : BasePage
    {
        protected crm_opportunity opportunity = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                opportunity = new crm_opportunity_dal().GetOpportunityById(long.Parse(id));
                if (opportunity != null)
                {

                }
            }
            catch (Exception)
            {

                Response.End();
            }
        }
    }
}