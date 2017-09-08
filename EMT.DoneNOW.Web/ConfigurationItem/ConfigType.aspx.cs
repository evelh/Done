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
    public partial class ConfigType :BasePage
    {
        protected long id;//配置项id
        protected List<sys_udf_field> GetAlludf = new List<sys_udf_field>();
        protected ConfigTypeBLL ctbll = new ConfigTypeBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            id =Convert.ToInt64(Request.QueryString["id"]);
            if (!IsPostBack) {
                GetAlludf = ctbll.GetAlludf();
            }


        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {

        }

        protected void Cancel_Click(object sender, EventArgs e)
        {

        }
    }
}