﻿using System;
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
    public class ContactController : BaseCRMController
    {
        ContactBLL _bll = new ContactBLL();

        /// <summary>
        /// 获取联系人相关的字典项
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("contact/field")]
        public ApiResultDto Field()
        {
            var data = _bll.GetField();
            return ResultSuccess(data);
        }

        /// <summary>
        /// 查询客户信息
        /// </summary>
        /// <param name="id">客户id</param>
        /// <returns></returns>
        [HttpGet]
        [Route("contact/contact")]
        public ApiResultDto Contact([FromUri] long id)
        {
            return ResultSuccess(_bll.GetContact(id));
        }

        /// <summary>
        /// 客户搜索
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("contact/search")]
        public ApiResultDto SearchContact([FromBody] JObject param)
        {
            List<crm_contact> list = _bll.FindList(param);
            return ResultSuccess(list);
        }

        [HttpPost]
        [Route("contact/add")]
        public ApiResultDto AddContact([FromBody] crm_contact contact)
        {
            return Result(_bll.Insert(contact, GetToken()));
        }

        [HttpPost]
        [Route("contact/update")]
        public ApiResultDto UpdateContact([FromBody] crm_contact contact)
        {
            return Result(_bll.Update(contact, GetToken()));
        }

        [HttpGet]
        [Route("contact/delete")]
        public ApiResultDto Delete(long id)
        {
            return ResultSuccess(_bll.DeleteContact(id, GetToken()));
        }
    }
}
