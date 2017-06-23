using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.WebAPI.Controllers
{
    public class BaseController : ApiController
    {

        public ApiResultDto ResultSuccess(object data)
        {
            return new ApiResultDto { code = (int)ERROR_CODE.SUCCESS, msg = "成功", data = data };
        }

        public ApiResultDto ResultError(ERROR_CODE code)
        {
            return new ApiResultDto { code = (int)code };   // TODO: msg
        }

        public ApiResultDto Result(ERROR_CODE code, object data = null)
        {
            if (code == ERROR_CODE.SUCCESS)
                return ResultSuccess(data);

            return ResultError(code);
        }

        public ApiResultDto Result(bool result, object data = null)
        {
            if (result)
                return ResultSuccess(data);

            return ResultError(ERROR_CODE.ERROR);
        }

        protected string GetToken()
        {
            return ActionContext.Request.Headers.Where(h => h.Key.ToLower().Equals("token")).FirstOrDefault().Value.First();
        }
    }
}
