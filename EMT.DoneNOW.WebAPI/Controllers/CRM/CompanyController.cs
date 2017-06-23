using EMT.DoneNOW.WebAPI.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using Newtonsoft.Json.Linq;

namespace EMT.DoneNOW.WebAPI.Controllers
{
    public class CompanyController : BaseCRMController
    {
        CompanyBLL _bll = new CompanyBLL();

        /// <summary>
        /// 获取客户相关的字典项
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("company/field")]
        public ApiResultDto Field()
        {
            var data = _bll.GetField();
            return ResultSuccess(data);
        }

        /// <summary>
        /// 查询客户信息
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("company/company")]
        public ApiResultDto Company([FromUri] long id)
        {
            return ResultSuccess(_bll.GetCompany(id));
        }

        [HttpPost]
        [Route("company/search")]
        public ApiResultDto SearchCompany([FromBody] JObject param)
        {
            List<crm_account> list = _bll.FindList(param);
            if (list == null)
                return ResultError(ERROR_CODE.PARAMS_ERROR);

            return ResultSuccess(list);
        }

        [HttpPost]
        [Route("company/add")]
        public ApiResultDto AddCompany([FromBody] JObject param)
        {
            return Result(_bll.Insert(param, GetToken()));
        }

        [HttpPost]
        [Route("company/edit")]
        public ApiResultDto UpdateCompany([FromBody] crm_account account)
        {
            return Result(_bll.Update(account, GetToken()));
        }

        [HttpGet]
        [Route("company/delete")]
        public ApiResultDto Delete(long id)
        {
            return ResultSuccess(_bll.DeleteCompany(id, GetToken()));
        }
    }
}
