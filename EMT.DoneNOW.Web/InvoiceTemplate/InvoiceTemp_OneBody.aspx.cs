using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    public partial class InvoiceTempBody : BasePage
    {
        protected List<d_general> GeneralList = null;
       protected  GeneralBLL gbll = new GeneralBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
           
            GeneralList = gbll.GetGeneralList(140);

        }
    }
}