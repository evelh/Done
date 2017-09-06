using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// OpportunityReasonAjax 的摘要说明
    /// </summary>
    public class OpportunityReasonAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var reason_id = context.Request.QueryString["id"];
            var general_table_id = context.Request.QueryString["GT_id"];
            switch (action)
            {
                case "active": Active(context, Convert.ToInt64(reason_id)); ; break;
                case "noactive": NoActive(context, Convert.ToInt64(reason_id)); ; break;
                case "delete": Delete(context, Convert.ToInt64(reason_id),Convert.ToInt64(general_table_id)); ; break;
                default: break;

            }
        }
        public void Delete(HttpContext context, long reason_id,long table_id)
        {
            //此处写复制逻辑
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                int n;//记录受影响的个数
                var result = new GeneralBLL().Delete_Validate(reason_id, user.id,table_id,out n);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    var kk = new GeneralBLL().Delete(reason_id, user.id, table_id);
                    if (kk == DTO.ERROR_CODE.SUCCESS)
                    {
                        context.Response.Write("删除成功！");
                    }
                    else {
                        context.Response.Write("删除失败！");
                    }
                }
                else if (result == DTO.ERROR_CODE.SYSTEM)
                {
                    context.Response.Write("系统默认不能删除！");
                }
                else if (result == DTO.ERROR_CODE.LOSS_OPPORTUNITY_REASON_USED) {
                    context.Response.Write("有"+n+ "个商机关联此丢失商机原因。不能删除!");
                }
                else if (result == DTO.ERROR_CODE.WIN_OPPORTUNITY_REASON_USED)
                {
                    context.Response.Write("有" + n + "个商机关联此关闭商机原因。不能删除!");
                }
                else
                {
                    context.Response.Write("删除失败！");
                }
            }
        }




        public void Active(HttpContext context, long reason_id)
        {
            //此处写复制逻辑
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                var result = new GeneralBLL().Active(reason_id, user.id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("激活成功！");
                }
                else if (result == DTO.ERROR_CODE.ACTIVATION)
                {
                    context.Response.Write("已经激活，无需此操作！");
                }
                else
                {
                    context.Response.Write("激活失败！");
                }
            }
        }
        public void NoActive(HttpContext context, long reason_id)
        {
            //此处写复制逻辑
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                var result = new GeneralBLL().NoActive(reason_id, user.id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("失活成功！");
                }
                else if (result == DTO.ERROR_CODE.NO_ACTIVATION)
                {
                    context.Response.Write("已经失活，无需此操作！");
                }
                else
                {
                    context.Response.Write("失活失败！");
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