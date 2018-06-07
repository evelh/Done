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
    public partial class WorkgroupResource : BasePage
    {
        protected UserResourceBLL userBll = new UserResourceBLL();
        protected bool isAdd = true;
        protected sys_workgroup thisGroup;
        protected sys_workgroup_resouce thisGroupRes;
        protected List<sys_workgroup_resouce> groupResList;
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList();
        protected void Page_Load(object sender, EventArgs e)
        {
            long groupId = 0;long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                if (long.TryParse(Request.QueryString["id"], out id))
                    thisGroupRes = userBll.GetGroupResource(id);
            if (!string.IsNullOrEmpty(Request.QueryString["groupId"]))
                if (long.TryParse(Request.QueryString["groupId"], out groupId))
                    thisGroup = userBll.GetGroup(groupId);
            if (thisGroupRes != null)
            {
                isAdd = false;
                thisGroup = userBll.GetGroup(thisGroupRes.workgroup_id);
            }
            if (thisGroup == null)
            {
                Response.Write("<script>alert('未获取到工作组信息');window.close();</script>");
                return;
            }
            groupResList = userBll.GetGroupResList(thisGroup.id);
            if(resList!=null&& resList.Count > 0)
            {
                if (thisGroupRes != null)
                    resList = resList.Where(_ => _.is_active != 0 || _.id == thisGroupRes.resource_id).ToList();
                else
                    resList = resList.Where(_ => _.is_active != 0).ToList();
            }

            if(groupResList!=null&& groupResList.Count > 0&& resList != null && resList.Count > 0)
            {
                foreach (var groupRes in groupResList)
                {
                    if (thisGroupRes != null && thisGroupRes.id == groupRes.id)
                        continue;
                    var thisRes = resList.FirstOrDefault(_=>_.id==groupRes.resource_id);
                    if (thisRes != null)
                        resList.Remove(thisRes);
                }
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            sys_workgroup_resouce pageGroupResource = AssembleModel<sys_workgroup_resouce>();
            if (!string.IsNullOrEmpty(Request.Form["isLead"]) && Request.Form["isLead"] == "on")
                pageGroupResource.is_leader = 1;
            else
                pageGroupResource.is_leader = 0;
            pageGroupResource.workgroup_id = thisGroup.id;
            if (!isAdd)
            {
                thisGroupRes.resource_id = pageGroupResource.resource_id;
                thisGroupRes.is_leader = pageGroupResource.is_leader;
            }
            var result = false;
            if (isAdd)
                result = userBll.AddGroupResource(pageGroupResource, LoginUserId);
            else
                result = userBll.EditGroupResource(thisGroupRes, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');setTimeout(function (){{self.opener.location.href = 'Workgroup?id={(thisGroup!=null?thisGroup.id.ToString():"")}&type=res';window.close(); }}, 800);</script>");
        }
    }
}