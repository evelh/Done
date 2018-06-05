using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class AdjustResourceGoal :BasePage
    {
        protected sys_resource_availability resAva;  // 员工工作时间
        protected sys_resource thisRes;              // 员工信息
        protected UserResourceBLL userBll = new UserResourceBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long objId = 0;long resId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                long.TryParse(Request.QueryString["id"],out objId);
            if (!string.IsNullOrEmpty(Request.QueryString["resId"]))
                long.TryParse(Request.QueryString["resId"], out resId);
            if (objId != 0)
                resAva = userBll.GetResourceAvailabilityById(objId);
            if(resId!=0)
                resAva = userBll.GetAvailabilityByResId(objId);
            if (resAva != null)
                thisRes = userBll.GetResourceById(resAva.resource_id);

            if (thisRes == null || resAva == null)
            {
                Response.Write("<script>alert('未获取到相关员工信息');window.close();</script>");
            }
        }
    }
}