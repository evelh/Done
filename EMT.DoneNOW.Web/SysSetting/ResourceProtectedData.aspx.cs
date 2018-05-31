using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class ResourceProtectedData : BasePage
    {
        protected sys_resource thisRes;              // 员工信息
        protected UserResourceBLL userBll = new UserResourceBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long objId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                long.TryParse(Request.QueryString["id"], out objId);
            if (objId != 0)
                thisRes = userBll.GetResourceById(objId);

            if (thisRes == null)
            {
                Response.Write("<script>alert('未获取到相关员工信息');window.close();</script>");
            }
        }
    }
}