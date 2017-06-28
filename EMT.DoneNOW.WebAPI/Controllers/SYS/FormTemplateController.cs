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
    /// <summary>
    /// 表单模板操作
    /// </summary>
    public class FormTemplateController : BaseController
    {
        FormTemplateBLL _bll = new FormTemplateBLL();

        /// <summary>
        /// 获取表单模板相关的字典项
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("form_template/field")]
        public ApiResultDto Field()
        {
            var data = _bll.GetField();
            return ResultSuccess(data);
        }

        /// <summary>
        /// 获取表单模板列表
        /// </summary>
        /// <param name="param">分页，排序等信息</param>
        /// <returns></returns>
        [HttpPost]
        [Route("form_template/list")]
        public ApiResultDto GetAll(JObject param)
        {
            return ResultSuccess(_bll.GetAllFormTemplate(param));
        }

        /// <summary>
        /// 删除表单模板
        /// </summary>
        /// <param name="id">表单模板id</param>
        /// <returns></returns>
        [HttpGet]
        [Route("form_template/delete")]
        public ApiResultDto DeleteOpportunityTmpl(int id)
        {
            if (_bll.DeleteFormTmpl(id, GetToken()))
                return ResultSuccess(null);
            return ResultError(ERROR_CODE.PARAMS_ERROR);
        }

        /// <summary>
        /// 获取表单模板信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("form_template/form_template")]
        public ApiResultDto FormTemplate(int id)
        {
            return ResultSuccess(_bll.GetFormTmplInfo(id));
        }

        /// <summary>
        /// 新增商机表单模板
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("form_template/add")]
        public ApiResultDto AddOppFormTmpl(JObject param)
        {
            return Result(_bll.AddOpportunityTmpl(param, GetToken()));
        }

        /// <summary>
        /// 更新商机表单模板
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("form_template/update")]
        public ApiResultDto UpdateOppFormTmpl(JObject param)
        {
            return Result(_bll.UpdateOpportunityTmpl(param, GetToken()));
        }

        /// <summary>
        /// 获取一个用户可见的商机表单模板
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("form_template/opportunity_list")]
        public ApiResultDto GetUserOppFormTmplList()
        {
            return ResultSuccess(_bll.GetTemplateOpportunityByUser(GetToken()));
        }
    }
}
