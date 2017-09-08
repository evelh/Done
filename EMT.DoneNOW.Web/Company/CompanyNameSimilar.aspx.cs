using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Company
{
    public partial class CompanyNameSimilar : BasePage
    {
        protected List<crm_account> nameSimilarList = null;
        protected string duplicateReason = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var ids = Request.QueryString["ids"];
                duplicateReason = Request.QueryString["reason"];
                if (!string.IsNullOrEmpty(ids))
                {                 
                    nameSimilarList = new crm_account_dal().GetCompanyByIds(ids);
                }
                switch (duplicateReason)
                {
                    case "name":
                        duplicateReason = "名称";
                        break;
                    default:
                        duplicateReason = "";
                        break;
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}