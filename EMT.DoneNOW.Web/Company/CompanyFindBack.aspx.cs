using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.CRM;


namespace EMT.DoneNOW.Web.Common
{
    public partial class CompanyFindBack : System.Web.UI.Page
    {
        public List<crm_account> accountList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            var id = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))        // 用于编辑的时候去除掉自己
            {
                accountList = new CompanyBLL().GetAccountByFindBack(Convert.ToInt64(id));
            }
            else
            {
                accountList = new CompanyBLL().GetAccountByFindBack(null);
            }
                
        }
    }
}