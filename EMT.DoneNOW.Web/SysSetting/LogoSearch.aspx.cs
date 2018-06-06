using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class LogoSearch : BasePage
    {
        protected List<d_general> logoList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.SYSTEM_LOGO);
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}