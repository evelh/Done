using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class TimeApproval : BasePage
    {
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList();
        protected sys_resource thisRes;
        protected string type = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["type"]) && Request.QueryString["type"] == "expense")
                type = "expense";
            long resId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["resId"]) && long.TryParse(Request.QueryString["resId"], out resId))
                thisRes = new UserResourceBLL().GetResourceById(resId);
        }
    }
}