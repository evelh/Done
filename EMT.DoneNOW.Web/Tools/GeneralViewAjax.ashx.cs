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
    /// GeneralViewAjax 的摘要说明
    /// </summary>
    public class GeneralViewAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var general_id = context.Request.QueryString["id"];
            var general_table_id = context.Request.QueryString["GT_id"];
            switch (action)
            {
                case "delete": Delete(context, Convert.ToInt64(general_id),Convert.ToInt64(general_table_id)); ; break;
                case "delete_validate": Delete_Validate(context, Convert.ToInt64(general_id), Convert.ToInt64(general_table_id)); ; break;

                default: break;

            }
            }
        public void Delete(HttpContext context, long general_id,long general_table_id)
        {
            //此处写复制逻辑
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user!= null)
            {                
                var result = new GeneralBLL().Delete(general_id, user.id,general_table_id);
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    context.Response.Write("删除成功！");
                }
                else if (result == DTO.ERROR_CODE.SYSTEM)
                {
                    context.Response.Write("系统默认不能删除！");
                } else{
                    context.Response.Write("删除失败！");
                }
            }
        }
        //删除数据前进行验证
        public void Delete_Validate(HttpContext context, long general_id, long general_table_id)
        {
            //此处写复制逻辑
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                int n;//记录受影响的个数
                var result = new GeneralBLL().Delete_Validate(general_id, user.id, general_table_id,out n);
                if (result == DTO.ERROR_CODE.SYSTEM)
                {
                    context.Response.Write("system");
                }
                else if (result == DTO.ERROR_CODE.MARKET_USED)
                {
                    context.Response.Write("有" + n + "个客户关联此市场领域。如果删除，则相关客户上的市场领域信息将会被清空，是否继续?");
                }
                else if (result == DTO.ERROR_CODE.TERRITORY_USED)
                {
                    context.Response.Write("有" + n + "个客户关联此客户地域。如果删除，则相关客户上的客户地域信息将会被清空，是否继续?");
                }
                else if (result == DTO.ERROR_CODE.COMPETITOR_USED) {
                    context.Response.Write("有" + n + "个客户关联此竞争对手。如果删除，则相关客户上的竞争对手信息将会被清空，是否继续?");
                }
                else if (result == DTO.ERROR_CODE.OPPORTUNITY_SOURCE_USED)
                {
                    context.Response.Write("有" + n + "个商机关联此商机来源。如果删除，则相关商机上的商机来源信息将会被清空，是否继续?");
                }
                else if (result == DTO.ERROR_CODE.OPPORTUNITY_STAGE_USED)
                {
                    context.Response.Write("被" + n + "个商机引用不能删除!");
                }
                else if (result == DTO.ERROR_CODE.ACTION_TYPE_USED)
                {
                    context.Response.Write("被" + n + "个活动引用不能删除!");
                }

                else if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    Delete(context, general_id, general_table_id);
                }
                else
                {
                    context.Response.Write("other");
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