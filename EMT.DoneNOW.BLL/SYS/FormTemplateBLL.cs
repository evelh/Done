﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;

namespace EMT.DoneNOW.BLL
{
    public class FormTemplateBLL
    {
        private readonly sys_form_tmpl_dal _dal = new sys_form_tmpl_dal();

        /// <summary>
        /// 获取所有的表单模板列表
        /// </summary>
        /// <param name="param">分页、排序等信息</param>
        /// <returns></returns>
        public List<sys_form_tmpl> GetAllFormTemplate(JObject param)
        {
            // TODO: param取得分页和排序信息
            return _dal.FindListBySql(_dal.QueryStringDeleteFlag($"SELECT * FROM sys_form_tmpl WHERE form_type_id={DictionaryEnum.FORM_TEMPLATE_TYPE_OPPORTUNITY}"));
        }

        /// <summary>
        /// 删除表单模板
        /// </summary>
        /// <param name="tmplId"></param>
        /// <returns></returns>
        public bool DeleteFormTmpl(int tmplId)
        {
            var tmpl = _dal.FindById(tmplId);
            return _dal.SoftDelete(tmpl);
        }

        /// <summary>
        /// 新增商机表单模板
        /// </summary>
        /// <param name="param"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        public bool AddOpportunityTmpl(JObject param, string token)
        {
            sys_form_tmpl formTmpl = param.ToObject<sys_form_tmpl>();
            sys_form_tmpl tmplFind = _dal.GetSingle(_dal.QueryStringDeleteFlag($"SELECT * FROM sys_form_tmpl WHERE speed_code='{formTmpl.speed_code}'")) as sys_form_tmpl;
            if (tmplFind != null)   // speed_code重复
                return false;

            formTmpl.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            formTmpl.create_user_id = CachedInfoBLL.GetUserInfo(token).id;
            formTmpl.update_time = formTmpl.create_time;
            formTmpl.update_user_id = formTmpl.create_user_id;
            formTmpl.id = (int)_dal.GetNextIdSys();
            _dal.Insert(formTmpl);

            sys_form_tmpl_opportunity opportunityTmpl = param.ToObject<sys_form_tmpl_opportunity>();
            opportunityTmpl.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            opportunityTmpl.create_user_id = formTmpl.create_user_id;
            opportunityTmpl.update_time = opportunityTmpl.create_time;
            opportunityTmpl.update_user_id = opportunityTmpl.create_user_id;
            opportunityTmpl.id = (int)_dal.GetNextIdSys();
            opportunityTmpl.form_tmpl_id = formTmpl.id;
            new sys_form_tmpl_opportunity_dal().Insert(opportunityTmpl);

            return true;
        }

        /// <summary>
        /// 更新商机表单模板
        /// </summary>
        /// <param name="param"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        public bool UpdateOpportunityTmpl(JObject param, string token)
        {
            sys_form_tmpl formTmpl = param.ToObject<sys_form_tmpl>();
            if (formTmpl == null || formTmpl.speed_code.Equals(""))
                return false;
            sys_form_tmpl tmplFind = _dal.FindById(formTmpl.id);
            if (tmplFind == null || formTmpl.form_type_id != tmplFind.form_type_id) // form_type不可修改
                return false;

            sys_form_tmpl_opportunity opportunityTmpl = param.ToObject<sys_form_tmpl_opportunity>();
            formTmpl.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            formTmpl.update_user_id = CachedInfoBLL.GetUserInfo(token).id;
            opportunityTmpl.update_time = formTmpl.update_time;
            opportunityTmpl.update_user_id = formTmpl.update_user_id;
            _dal.Update(formTmpl);
            new sys_form_tmpl_opportunity_dal().Update(opportunityTmpl);

            return true;
        }

        /// <summary>
        /// 获取商机表单模板信息
        /// </summary>
        /// <param name="tmplId">表单模板id</param>
        /// <returns></returns>
        public FormTmplOpportunityDto GetOpportunityFormTmpl(int tmplId)
        {
            var tmplDto = new sys_form_tmpl_opportunity_dal().GetSingle($"SELECT * FROM sys_form_tmpl_opportunity WHERE form_tmpl_id={tmplId}") as FormTmplOpportunityDto;
            if (tmplDto == null)
                return null;
            var tmpl = _dal.FindById(tmplId);
            tmplDto.id = tmpl.id;
            tmplDto.form_type_id = tmpl.form_type_id;
            tmplDto.range_type_id = tmpl.range_type_id;
            tmplDto.range_department_id = tmpl.range_department_id;
            tmplDto.speed_code = tmpl.speed_code;
            tmplDto.remark = tmpl.remark;
            tmplDto.tmpl_name = tmpl.tmpl_name;
            tmplDto.tmpl_is_active = tmpl.tmpl_is_active;

            return tmplDto;
        }

        /// <summary>
        /// 根据商机模板的form_tmpl_id获取商机模板信息
        /// </summary>
        /// <param name="formTmplId">表单模板id</param>
        /// <returns></returns>
        public sys_form_tmpl_opportunity GetOpportunityTmpl(int formTmplId)
        {
            var tmpl = _dal.GetSingle(_dal.QueryStringDeleteFlag($"SELECT * FROM sys_form_tmpl_opportunity WHERE form_tmpl_id={formTmplId}")) as sys_form_tmpl_opportunity;
            return tmpl;
        }

        /// <summary>
        /// 获取一个用户可见的商机表单模板
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        public List<sys_form_tmpl> GetTemplateOpportunityByUser(string token)
        {
            // TODO: 获取用户部门，得到该部门可见的表单模板
            var userinfo = CachedInfoBLL.GetUserInfo(token);
            long oppGeneId = new GeneralBLL().GetGeneralId("表单模板类型", "Opportunity");    // 商机表单模板类型id
            string sql = $"SELECT * FROM sys_form_tmpl WHERE form_type_id={DictionaryEnum.FORM_TEMPLATE_TYPE_OPPORTUNITY} AND (range_type_id={DictionaryEnum.FORM_TEMPLATE_RANG_TYPE_ALL} OR (create_user_id={userinfo.id} AND range_type_id={DictionaryEnum.FORM_TEMPLATE_RANG_TYPE_OWN}))";   // TODO: 部门可见的模板
            return _dal.FindListBySql(_dal.QueryStringDeleteFlag(sql));
        }
    }
}
