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
        [HttpGet]
        [Route("company/field")]
        public ApiResultDto Field()
        {
            var data = _bll.GetField();
            return ResultSuccess(data);
        }
        
        [HttpGet]
        [Route("company/company")]
        public ApiResultDto Company([FromUri] long? id)
        {
            if (id == null)
                return ResultSuccess(_bll.GetList());
            else
                return ResultSuccess(_bll.GetCompany((long)id));
        }

        [HttpPost]
        [Route("company/search")]
        public ApiResultDto SearchCompany([FromBody] JObject param)
        {
            CompanyConditionDto condition = param.ToObject<CompanyConditionDto>();

            return ResultSuccess(_bll.FindList(condition));
        }

        [HttpPost]
        [Route("company/company")]
        public ApiResultDto AddCompany([FromBody] JObject param)
        {
            return Result(_bll.Insert(param));
        }

        [HttpDelete]
        [Route("company/company")]
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
