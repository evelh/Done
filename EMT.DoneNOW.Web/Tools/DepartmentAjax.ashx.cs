using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// DepartmentAjax 的摘要说明
    /// </summary>
    public class DepartmentAjax : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];            
            switch (action)
            {
                case "delete": var departmen_id = context.Request.QueryString["id"];
                    Delete(context, Convert.ToInt64(departmen_id));break;
                case "GetNameByIds":
                    var dIds = context.Request.QueryString["ids"];
                    GetNameByIds(context,dIds);
                    break;
                case "GetWorkType":   //
                    var dId = context.Request.QueryString["department_id"];
                    GetWorkType(context,long.Parse(dId));
                    break;
                default: break;

            }
        }
        public void Delete(HttpContext context, long departmen_id)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                string returnvalue = string.Empty;
                var result = new DepartmentBLL().Delete(departmen_id, res.id, out returnvalue);
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

        private void GetNameByIds(HttpContext context,string ids)
        {
            if (!string.IsNullOrEmpty(ids))
            {
                var depList = new sys_department_dal().GetDepartment($" and id in ({ids})");
                if (depList != null && depList.Count > 0)
                {
                    StringBuilder depStringBuilder = new StringBuilder();
                    depList.ForEach(_ => depStringBuilder.Append(_.name + ";"));
                    var depString = depStringBuilder.ToString();
                    if (!string.IsNullOrEmpty(depString))
                    {
                        context.Response.Write(depString);
                    }
                }
            }
          
        } 
        /// <summary>
        /// 根据部门获取相对应的工作类型
        /// </summary>
        private void GetWorkType(HttpContext context,long department_id)
        {
            var dccDal = new d_cost_code_dal();
            var workTypeList = dccDal.GetCostCodeByWhere((int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE, " and department_id ="+department_id);
            StringBuilder workTypeString = new StringBuilder();
            workTypeString.Append("<option value='0'>   </option>");
            if(workTypeList!=null&& workTypeList.Count > 0)
            {
                foreach (var workType in workTypeList)
                {
                    workTypeString.Append($"<option value='{workType.id}'>{workType.name}</option>");
                }
            }
            var thisSet = new SysSettingBLL().GetSetById(SysSettingEnum.ALL_USER_ASSIGN_NODE_TOTAASL);
            if (thisSet != null && thisSet.setting_value == "1")
            {
                var noDepWorkTypeList = dccDal.GetCostCodeByWhere((int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE, " and department_id is null");
                if(noDepWorkTypeList!=null&& noDepWorkTypeList.Count > 0)
                {
                    workTypeString.Append("<option value='0'>--------</option>");
                    foreach (var workType in noDepWorkTypeList)
                    {
                        workTypeString.Append($"<option value='{workType.id}'>{workType.name}</option>");
                    }
                }
            }
            context.Response.Write(workTypeString.ToString());
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