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

namespace EMT.DoneNOW.WebAPI.Controllers.CRM
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
            return ResultSuccess(_bll.GetCompany((long)id));
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
        [Route("company/company")]
        public ApiResultDto AddCompany([FromBody] JObject param)
        {
            return Result(_bll.Insert(param));
        }

        [HttpPost]
        [Route("company/edit")]
        public ApiResultDto UpdateCompany([FromBody] crm_account account)
        {
            return Result(_bll.Update(account));
        }

        [HttpGet]
        [Route("company/delete")]
        public ApiResultDto Delete(long id)
        {
            return ResultSuccess(_bll.DeleteCompany(id));
        }

        /*
        // POST: api/Company
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/Company/5
        public void Put(int id, [FromBody]string value)
        {
        }
        */
    }
}
