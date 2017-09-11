using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
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
        protected List<sys_udf_group_field> GetGroupudf = new List<sys_udf_group_field>();
        private ConfigTypeBLL ctbll = new ConfigTypeBLL();
        private GeneralBLL configtypebll = new GeneralBLL();
        private d_general configtype = new d_general();
        protected void Page_Load(object sender, EventArgs e)
        {
            id =Convert.ToInt64(Request.QueryString["id"]);
            if (!IsPostBack) {
                GetAlludf = ctbll.GetAlludf();
                if (id > 0) {//修改数据
                    configtype = configtypebll.GetSingleGeneral(id);
                    this.Config_name.Text = configtype.name;
                    if (configtype.is_active > 0) {
                        this.Active.Checked = true;
                    }
                    if (configtype.ext1 != null && !string.IsNullOrEmpty(configtype.ext1.ToString())) {
                        GetGroupudf = ctbll.GetUdfGroup(Convert.ToInt32(configtype.ext1.ToString()));
                    }                   

                }
            }

        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            string t = Request.Form["UDFdata"].ToString();
            t = t.Replace("[,", "[").Replace(",]", "]");
            var tt = new EMT.Tools.Serialize().DeserializeJson<ConfigUserDefinedFieldDto>(t);



        }

        protected void Cancel_Click(object sender, EventArgs e)
        {

        }
    }
}