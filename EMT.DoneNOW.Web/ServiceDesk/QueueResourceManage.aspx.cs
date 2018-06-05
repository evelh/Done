using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class QueueResourceManage : BasePage
    {
        protected bool isAdd = true;
        protected sys_department queue;
        protected sys_resource_department resDep;
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList();
        protected List<sys_role> roleList = new DAL.sys_role_dal().GetList();
        protected DepartmentBLL depBll = new DepartmentBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long queId = 0;long resDepId;
            if (!string.IsNullOrEmpty(Request.QueryString["queId"]))
                if (long.TryParse(Request.QueryString["queId"], out queId))
                    queue = depBll.GetQueue(queId);

            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                if (long.TryParse(Request.QueryString["id"], out resDepId))
                    resDep = new DAL.sys_resource_department_dal().FindById(resDepId);
            if (resDep != null)
            {
                isAdd = false;
                queue = depBll.GetQueue(resDep.department_id);
            }
                
            if (queue == null)
                Response.Write("<script>alert('未获取到相关队列信息');window.close();</script>");
        }
    }
}