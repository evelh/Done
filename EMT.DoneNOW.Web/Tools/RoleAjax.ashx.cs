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
            var role = new sys_role_dal().FindSignleBySql<sys_role>($"select * from sys_role where id = {role_id} ");
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

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}