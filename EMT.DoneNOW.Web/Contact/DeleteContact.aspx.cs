using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class DeleteContact : BasePage
    {
        protected crm_contact crm_contact = null;
        protected Dictionary<string, object> dic = null;
        protected ContactBLL contactBll = new ContactBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
          
        }
    }
}