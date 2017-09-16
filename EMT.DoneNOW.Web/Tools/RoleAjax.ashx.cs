using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// RoleAjax 的摘要说明
    /// </summary>
    public class RoleAjax : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "role":
                    var role_id = context.Request.QueryString["role_id"];
                    GetRole(context,long.Parse(role_id));
                    break;
                case "GetRoleList":
                    var source_id= context.Request.QueryString["source_id"];
                    GetRoleList(context,long.Parse(source_id));
                    break;
                case "delete":
                    var role_delete_id = context.Request.QueryString["id"];
                    Delete(context, Convert.ToInt64(role_delete_id)); break;
                case "Exclude":
                    var exclude_id = context.Request.QueryString["id"];
                    Exclude(context, Convert.ToInt64(exclude_id)); break;
                case "Active":
                    var active_id = context.Request.QueryString["id"];
                    Active(context, Convert.ToInt64(active_id)); break;
                case "No_Active":
                    var noactive_id = context.Request.QueryString["id"];
                    No_Active(context, Convert.ToInt64(noactive_id)); break;
                default:
                    context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
                    break;
            }

        }
        /// <summary>
        /// 获取到这个角色相关的信息返回到页面
        /// </summary>
        /// <param name="context"></param>
        /// <param name="role_id"></param>
        public void GetRole(HttpContext context,long role_id)
        {
            var role = new sys_role_dal().FindSignleBySql<sys_role>($"select * from sys_role where id = {role_id} and delete_time = 0");
            if (role != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(role));
            }
        }
        /// <summary>
        /// 根据员工id，查询出员工的角色
        /// </summary>
        /// <param name="context"></param>
        /// <param name="resource_id"></param>
        public void GetRoleList(HttpContext context, long resource_id)
        {
            // 查找出部门类型的角色
            var roleList = new sys_resource_department_dal().GetRolesBySource(resource_id, DEPARTMENT_CATE.DEPARTMENT);
            StringBuilder roles = new StringBuilder("<option value='0'>     </option>");
            if (roleList!=null&& roleList.Count > 0)
            {
                var rDal = new sys_role_dal();
                foreach (var role in roleList)
                {
                    var thisRole = rDal.FindNoDeleteById(role.role_id);
                    if (thisRole != null)
                    {
                        roles.Append("<option value='" + thisRole.id + "'>" + thisRole.name + "</option>");
                    }
                    
                }
            }
            context.Response.Write(roles);

        }
        public void Delete(HttpContext context, long role_delete_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                string returnvalue = string.Empty;
                var result = new SysRoleInfoBLL().Delete(role_delete_id, res.id, out returnvalue);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("删除成功！");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    context.Response.Write(returnvalue);
                }
                else
                {
                    context.Response.Write("删除失败！");
                }
            }

        }
        public void Active(HttpContext context, long role_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                var result = new SysRoleInfoBLL().ActiveRole(role_id, res.id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("激活成功！");
                }
                else if (result == DTO.ERROR_CODE.ACTIVATION)
                {
                    context.Response.Write("已是激活状态，无需此操作！");
                }
                else
                {
                    context.Response.Write("激活失败！");
                }
            }

        }
        public void No_Active(HttpContext context, long role_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                var result = new SysRoleInfoBLL().NoAction(role_id, res.id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("停用成功！");
                }
                else if (result == DTO.ERROR_CODE.NO_ACTIVATION)
                {
                    context.Response.Write("已是停用状态，无需此操作！");
                }
                else
                {
                    context.Response.Write("停用失败！");
                }
            }

        }
        public void Exclude(HttpContext context, long exclude_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                var result = new SysRoleInfoBLL().Exclude(exclude_id, res.id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("从全部当前激活的合同中排除成功！");
                }
                else if (result == DTO.ERROR_CODE.CONTRACT_NO_ACTIVE)
                {
                    context.Response.Write("当前不存在已经激活的合同！");
                }
                else
                {
                    context.Response.Write("从全部当前激活的合同中排除失败！");
                }
            }

        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}