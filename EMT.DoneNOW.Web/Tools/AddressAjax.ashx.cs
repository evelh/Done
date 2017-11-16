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
    public class AddressAjax : BaseAjax
    {
        public override void AjaxProcess(HttpContext context)
        {
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
                case "location":
                    var locaId = context.Request.QueryString["location_id"];
                    GetLocation(context, long.Parse(locaId));
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
        public string DeleteLocation(HttpContext context, long location_id)
        {

            var location = new LocationBLL().GetAllQuoteLocation(location_id);
            if (location != null && location.Count > 0)
            {
                return "Occupy";
            }
            else
            {
                var delete_location = new crm_location_dal().GetLocationById(location_id);
                if (new LocationBLL().DeleteLocation(location_id, LoginUserId)) // 删除成功
                {
                    return "Success";
                }
                else
                {
                    return "Fail";
                }
            }
        }
        /// <summary>
        /// 根据地址ID去获取到地址信息
        /// </summary>
        private void GetLocation(HttpContext context, long location_id)
        {
            var location = new LocationBLL().GetLocation(location_id);
            if (location != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(location));
            }
        }


        #endregion

    }
}