using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.Tools;
using EMT.DoneNOW.Core;
using System.Web.SessionState;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// AddressAjax 的摘要说明
    /// </summary>
    public class AddressAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            //取得处理类型
            string action = DNRequest.GetQueryString("act");            
            switch (action)
            {
                case "country": //国家
                    GetCountryList(context);
                    break;
                case "province": //省
                    GetProviceList(context);
                    break;
                case "district": //行政区
                    GetDistrictList(context);
                    break;
                case "delete":
                    string location_id = DNRequest.GetQueryString("LocationId");
                    context.Response.Write(DeleteLocation(context, Convert.ToInt64(location_id)));
                    break;
                default:
                    context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
                    return;                 
            }

            
       

        }

        #region 获取地址信息
        private void GetCountryList(HttpContext context)
        {
            var list = new DistrictBLL().GetCountryList();
            var result = new ApiResultDto { code = 0, data = list };
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
            return;
        }

        private void GetProviceList(HttpContext context)
        {
            var list = new DistrictBLL().GetProvinceList();
            var result = new ApiResultDto { code = 0, data = list };
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
            return;
        }

        private void GetDistrictList(HttpContext context)
        {
            int parentId = EMT.Tools.Common.StrToInt(HttpContext.Current.Request["pid"], 1);
            var list = new DistrictBLL().GetDistrictList(parentId);
            var result = new ApiResultDto { code = 0, data = list };
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
            return;
        }
        #endregion



        #region 删除地址
        /// <summary>
        /// 删除地址
        /// </summary>
        /// <param name="location_id"></param>
        /// <returns></returns>
        public string DeleteLocation(HttpContext context,long location_id)
        {

            var location = new LocationBLL().GetAllQuoteLocation(location_id);
            if (location != null && location.Count > 0)
            {
                return "Occupy";
            }
            else
            {
                var res = context.Session["dn_session_user_info"];
                if (res != null)
                {
                    var user = res as sys_user;
                    var delete_location = new crm_location_dal().GetLocationById(location_id);
                    if (new LocationBLL().DeleteLocation(location_id, user.id)) // 删除成功
                    {
                        
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name==null?"":user.name,
                            phone = user.mobile_phone == null ? "" : user.mobile_phone,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CUSTOMER,
                            oper_object_id = location_id,
                            oper_type_id = (int)DicEnum.OPER_LOG_TYPE.DELETE,
                            oper_description = new crm_location_dal().AddValue(delete_location),
                            remark = "删除客户信息",
                        });

                        return "Success";
                    }
                    else
                    {
                        return "Fail";
                    }
                }
                else
                {
                    return "LoseUser";
                }
                             
            }
            
        }
        #endregion
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}