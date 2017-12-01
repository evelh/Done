using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// RoleAjax 的摘要说明
    /// </summary>
    public class RoleAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "role":
                    var role_id = context.Request.QueryString["role_id"];
                    GetRole(context, long.Parse(role_id));
                    break;
                case "GetRoleList":
                    var source_id = context.Request.QueryString["source_id"];
                    var showNull = context.Request.QueryString["showNull"];
                    GetRoleList(context, long.Parse(source_id),string.IsNullOrEmpty(showNull));
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
                case "GetResDepList":
                    var resDepIds = context.Request.QueryString["resDepIds"];
                    GetResDepList(context, resDepIds);
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
        public void GetRole(HttpContext context, long role_id)
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
        public void GetRoleList(HttpContext context, long resource_id, bool isShowNull = true)
        {
            // 查找出部门类型的角色
            var roleList = new sys_resource_department_dal().GetRolesBySource(resource_id, DEPARTMENT_CATE.DEPARTMENT);
            StringBuilder roles = new StringBuilder();
            if (isShowNull)
            {
                roles.Append("<option value='0'>     </option>");
            }
            
            if (roleList != null && roleList.Count > 0)
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

            string returnvalue = string.Empty;
            var result = new SysRoleInfoBLL().Delete(role_delete_id, LoginUserId, out returnvalue);
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
        public void Active(HttpContext context, long role_id)
        {

            var result = new SysRoleInfoBLL().ActiveRole(role_id, LoginUserId);
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
        public void No_Active(HttpContext context, long role_id)
        {

            var result = new SysRoleInfoBLL().NoAction(role_id, LoginUserId);
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
        public void Exclude(HttpContext context, long exclude_id)
        {

            var result = new SysRoleInfoBLL().Exclude(exclude_id, LoginUserId);
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

        public void GetResDepList(HttpContext context, string ids)
        {
            if (!string.IsNullOrEmpty(ids))
            {
                var thisList = new sys_resource_department_dal().FindListBySql<ResDep>($"SELECT srd.id,sr.`name` as roleName,res.`name` as resName,sd.`name` as depName from sys_resource_department  srd LEFT JOIN sys_role sr on srd.role_id = sr.id LEFT JOIN sys_resource res on srd.resource_id = res.id LEFT JOIN sys_department sd on srd.department_id = sd.id where srd.id in({ids})");
                if (thisList != null && thisList.Count > 0)
                {
                    StringBuilder resDepString = new StringBuilder();
                    foreach (var item in thisList)
                    {
                        resDepString.Append($"<option value='{item.id}'>{item.resName}({item.roleName})</option>");
                    }
                    context.Response.Write(resDepString.ToString());
                }
            }
        }

    }
    /// <summary>
    /// 用于显示角色和员工相关信息
    /// </summary>
    class ResDep
    {
        public long id;
        public string roleName;
        public string resName;
        public string depName;
    }
}