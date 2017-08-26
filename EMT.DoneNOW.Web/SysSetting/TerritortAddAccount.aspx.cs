using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class TerritortAddAccount : BasePage
    {
        public long id;
        private SysTerritoryBLL STBLL = new SysTerritoryBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (!IsPostBack) {
                this.AccountList.DataTextField = "name";
                this.AccountList.DataValueField = "id";
                this.AccountList.DataSource = STBLL.GetAccount(id);
                this.AccountList.DataBind();
            }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();</script>");
        }

        protected void Save_Click(object sender, EventArgs e)
        {
            StringBuilder json = new StringBuilder();
            crm_account_territory cat = new crm_account_territory();
            foreach (ListItem item in this.AccountList.Items) {
                if (item.Selected)
                {
                    cat.territory_id = (int)id;
                    cat.account_id = Convert.ToInt64(item.Value);
                    json.Append("{aid:" + item.Value + ",text:" + item.Text +"},");
                    STBLL.Insert(cat,GetLoginUserId());
                }                    
            }
            Response.Write("<script> window.returnValue="+json.ToString().TrimEnd(',')+ ";window.close();</script>");
        }
    }
}