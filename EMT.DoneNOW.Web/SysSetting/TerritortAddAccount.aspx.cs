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
            StringBuilder name = new StringBuilder();

            sys_resource_territory cat = new sys_resource_territory();
            foreach (ListItem item in this.AccountList.Items) {
                if (item.Selected)
                {
                    cat.territory_id = (int)id;
                    cat.resource_id = Convert.ToInt64(item.Value);
                    name.Append("{'id':'" + Convert.ToInt64(item.Value) + "','name':'" + (item.Text) + "'},");
                    STBLL.Insert(cat,GetLoginUserId());
                }                    
            }
            string k = name.ToString().TrimEnd(',');
            Response.Write("<script>window.opener.document.getElementById(\"txtId\").value=\"" + k + "\";window.opener.kkk();window.close();</script>");
        }
    }
}