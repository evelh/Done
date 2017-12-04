using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ExpenseDetail : BasePage
    {
        protected sdk_expense thisExp = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisExp = new sdk_expense_dal().FindNoDeleteById(long.Parse(id));
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}