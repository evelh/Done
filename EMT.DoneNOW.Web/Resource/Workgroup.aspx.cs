using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.Resource
{
    public partial class Workgroup : BasePage
    {
        protected UserResourceBLL userBll = new UserResourceBLL();
        protected bool isAdd = true;
        protected sys_workgroup thisGroup;
        protected List<sys_workgroup_resouce> groupResList;
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList();
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                if (long.TryParse(Request.QueryString["id"], out id))
                    thisGroup = userBll.GetGroup(id);
            if (thisGroup != null)
            {
                isAdd = false; groupResList = userBll.GetGroupResList(thisGroup.id);
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            sys_workgroup pageGroup = AssembleModel<sys_workgroup>();
            if (!string.IsNullOrEmpty(Request.Form["isActive"]) && Request.Form["isActive"] == "on")
                pageGroup.status_id = 1;
            else
                pageGroup.status_id = 0;
           
            if (!isAdd)
            {
                thisGroup.name = pageGroup.name;
                thisGroup.status_id = pageGroup.status_id;
                thisGroup.description = pageGroup.description;
            }
            var result = false;
            if (isAdd)
                result = userBll.AddGroup(pageGroup, LoginUserId);
            else
                result = userBll.EditGroup(thisGroup, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');window.close();</script>");
        }
    }
}