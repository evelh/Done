using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.Tools;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// AddressAjax 的摘要说明
    /// </summary>
    public class AddressAjax : IHttpHandler
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

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}