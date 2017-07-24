using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web
{
    public partial class SelectCallBack : BasePage
    {
        protected List<DictionaryEntryDto> company = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            company = new CompanyBLL().GetCompanyName(GetLoginUserId());
        }
    }
}