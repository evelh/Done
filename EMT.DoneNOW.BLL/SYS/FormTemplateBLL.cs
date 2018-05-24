using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;

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
            return _dal.FindListBySql(_dal.QueryStringDeleteFlag($"SELECT * FROM sys_form_tmpl WHERE form_type_id={DicEnum.FORM_TMPL_TYPE.OPPORTUNITY}"));
        }

        /// <summary>
        /// 获取字典项
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            // TODO: 获取部门列表
            dic.Add("template_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.FORM_TEMPLATE_TYPE)));          // 表单模板类型
            dic.Add("range_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.FORM_TEMPLATE_RANGE_TYPE)));    // 表单模板应用范围

            return dic;
        }

        /// <summary>
        /// 删除表单模板
        /// </summary>
        /// <param name="tmplId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteFormTmpl(int tmplId, long userId)
        {
            long time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //long userId = CachedInfoBLL.GetUserInfo(token).id;
            var tmpl = _dal.FindById(tmplId);
            if (tmpl == null)
                return false;
            bool delRslt = false;
            switch (tmpl.form_type_id)  // 判断表单类型
            {
                case (int)DicEnum.FORM_TMPL_TYPE.OPPORTUNITY:
                    delRslt = DeleteOpportunityFormTmpl(tmplId, userId);
                    break;
                default:
                    break;
            }
            if (!delRslt)
                return false;

            tmpl.delete_time = time;
            tmpl.delete_user_id = userId;
            return _dal.SoftDelete(tmpl, userId);
        }

        /// <summary>
        /// 新增商机表单模板
        /// </summary>
        /// <param name="param"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddOpportunityTmpl(JObject param, long userId)
        {
            sys_form_tmpl formTmpl = param.ToObject<sys_form_tmpl>();
            sys_form_tmpl tmplFind = _dal.GetSingle(_dal.QueryStringDeleteFlag($"SELECT * FROM sys_form_tmpl WHERE speed_code='{formTmpl.speed_code}'")) as sys_form_tmpl;
            if (tmplFind != null)   // speed_code重复
                return false;

            formTmpl.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            formTmpl.create_user_id = userId;//CachedInfoBLL.GetUserInfo(token).id;
            formTmpl.update_time = formTmpl.create_time;
            formTmpl.update_user_id = formTmpl.create_user_id;
            formTmpl.form_type_id = (int)DicEnum.FORM_TMPL_TYPE.OPPORTUNITY;
            formTmpl.id = (int)_dal.GetNextIdSys();
            _dal.Insert(formTmpl);

            sys_form_tmpl_opportunity opportunityTmpl = param.ToObject<sys_form_tmpl_opportunity>();
            opportunityTmpl.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            opportunityTmpl.create_user_id = formTmpl.create_user_id;
            opportunityTmpl.update_time = opportunityTmpl.create_time;
            opportunityTmpl.update_user_id = opportunityTmpl.create_user_id;
            opportunityTmpl.id = (int)_dal.GetNextIdSys();
            //opportunityTmpl.form_tmpl_id = formTmpl.id;
            new sys_form_tmpl_opportunity_dal().Insert(opportunityTmpl);

            return true;
        }

        /// <summary>
        /// 更新商机表单模板
        /// </summary>
        /// <param name="param"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool UpdateOpportunityTmpl(JObject param, long userId)
        {
            sys_form_tmpl formTmpl = param.ToObject<sys_form_tmpl>();
            if (formTmpl == null || formTmpl.speed_code.Equals(""))
                return false;
            sys_form_tmpl tmplFind = _dal.FindById(formTmpl.id); // 查询到的修改之前的数据
            if (tmplFind == null || formTmpl.form_type_id != tmplFind.form_type_id) // form_type不可修改
                return false;

            sys_form_tmpl_opportunity opportunityTmpl = param.ToObject<sys_form_tmpl_opportunity>();
            formTmpl.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            formTmpl.update_user_id = userId;//CachedInfoBLL.GetUserInfo(token).id;
            opportunityTmpl.update_time = formTmpl.update_time;
            opportunityTmpl.update_user_id = formTmpl.update_user_id;
            _dal.Update(formTmpl);
            new sys_form_tmpl_opportunity_dal().Update(opportunityTmpl);

            //var user = CachedInfoBLL.GetUserInfo(token);// 获取到用户信息之后，将更改的数据内容存储到数据库中
            //var user = new UserInfoDto() { id=1,dbid=1,name="zhufei_test",department_id=1,email="liuhai_dsjt@shdsjt.cn",mobile= "18217750743" ,security_Level_id=2};
            //var old_val = new sys_form_tmpl() { id = (int)_dal.GetNextIdSys(), create_time = 123, create_user_id = 1, tmpl_name = "1",remark="备注" };
            //var new_val = new sys_form_tmpl() { id = (int)_dal.GetNextIdSys(), create_time = 321, create_user_id = 1, form_type_id = 1, tmpl_name = "2" ,};
            //var description = _dal.CompareValue(old_val, new_val);
            //if (user != null)
            //{
            //    sys_oper_log log = new sys_oper_log()
            //    {
            //        user_cate = "用户",
            //        user_id = user.id,
            //        name = user.name,
            //        phone = user.mobile == null ? "" : user.mobile,
            //        oper_time =  Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.FROMOPPORTUNITY,// 商机对应id d_general表中定义
            //        oper_object_id = new_val.id,// 操作对象ID
            //        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,// 800 增  801 删  802 改
            //        oper_description = description,
            //        remark = ""
            //    };
            //    new sys_oper_log_dal().Insert(log);
            //}


            //// 新增时添加日志的测试
            //var val = new sys_form_tmpl() { id = (int)_dal.GetNextIdSys(), create_time = 123, create_user_id = 1, form_type_id = 1, tmpl_name = "1" };
            //var content = _dal.AddValue(val);
            //var addLog = new sys_oper_log()
            //{
            //    user_cate = "用户",
            //    user_id = user.id,
            //    name = "",
            //    phone = user.mobile == null ? "" : user.mobile,
            //    oper_time =  Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.FROMOPPORTUNITY,// 商机对应id d_general表中定义
            //    oper_object_id = val.id,// 操作对象ID
            //    oper_type_id = (int)OPER_LOG_TYPE.ADD,
            //    oper_description = content,
            //    remark = ""

            //};
            //new sys_oper_log_dal().Insert(addLog);


            return true;
        }

        /// <summary>
        /// 获取表单模板信息
        /// </summary>
        /// <param name="tmplId"></param>
        /// <returns></returns>
        public object GetFormTmplInfo(int tmplId)
        {
            var tmpl = _dal.FindById(tmplId);
            switch (tmpl.form_type_id)  // 判断表单类型
            {
                case (int)DicEnum.FORM_TMPL_TYPE.OPPORTUNITY:
                    return GetOpportunityFormTmpl(tmplId);
                default:
                    return null;
            }
        }

        /// <summary>
        /// 获取商机表单模板信息
        /// </summary>
        /// <param name="tmplId">表单模板id</param>
        /// <returns></returns>
        private FormTmplOpportunityDto GetOpportunityFormTmpl(int tmplId)
        {
            var tmplDto = new sys_form_tmpl_opportunity_dal().GetSingle($"SELECT * FROM sys_form_tmpl_opportunity WHERE form_tmpl_id={tmplId}") as FormTmplOpportunityDto;
            if (tmplDto == null)
                return null;
            var tmpl = _dal.FindById(tmplId);
            //tmplDto.id = tmpl.id;
            tmplDto.form_type_id = tmpl.form_type_id;
            tmplDto.range_type_id = tmpl.range_type_id;
            tmplDto.range_department_id = tmpl.range_department_id;
            tmplDto.speed_code = tmpl.speed_code;
            tmplDto.remark = tmpl.remark;
            tmplDto.tmpl_name = tmpl.tmpl_name;
            tmplDto.tmpl_is_active = tmpl.is_active;

            return tmplDto;
        }

        /// <summary>
        /// 删除商机表单模板
        /// </summary>
        /// <param name="tmplId"></param>
        /// <param name="userid"></param>
        /// <returns></returns>
        private bool DeleteOpportunityFormTmpl(int tmplId, long userid)
        {
            var dal = new sys_form_tmpl_opportunity_dal();
            var oppTmpl = dal.GetSingle(dal.QueryStringDeleteFlag($"SELECT * FROM sys_form_tmpl_opportunity WHERE form_tmpl_id={tmplId}")) as sys_form_tmpl_opportunity;
            if (oppTmpl == null)
                return false;
            oppTmpl.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            oppTmpl.delete_user_id = userid;

            return dal.SoftDelete(oppTmpl,userid);
        }

        /// <summary>
        /// 根据商机模板的form_tmpl_id获取商机模板信息
        /// </summary>
        /// <param name="formTmplId">表单模板id</param>
        /// <returns></returns>
        public sys_form_tmpl_opportunity GetOpportunityTmpl(long formTmplId)
        {
            var tmpl = _dal.FindSignleBySql<sys_form_tmpl_opportunity>(_dal.QueryStringDeleteFlag($"SELECT * FROM sys_form_tmpl_opportunity WHERE delete_time = 0 and form_tmpl_id={formTmplId}"));
            return tmpl;
        }

        /// <summary>
        /// 获取一个用户可见的商机表单模板（包括该用户个人可见模板、该用户所在部门可见模板和所有人可见模板）
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<sys_form_tmpl> GetTemplateOpportunityByUser(long userId)
        {
            // TODO: 获取用户部门，得到该部门可见的表单模板
            string sql = $"SELECT * FROM sys_form_tmpl WHERE form_type_id={(int)DicEnum.FORM_TMPL_TYPE.OPPORTUNITY} AND (range_type_id={(int)DicEnum.RANG_TYPE.ALL} OR (create_user_id={userId} AND range_type_id={(int)DicEnum.RANG_TYPE.OWN}))";   // TODO: 部门可见的模板
            return _dal.FindListBySql(_dal.QueryStringDeleteFlag(sql));
        }
        /// <summary>
        /// 模板的快速代码是否通过校验  true 通过校验
        /// </summary>
        public bool CheckTempCode(string code,long id = 0)
        {
            if (string.IsNullOrEmpty(code))
                return false;
            sys_form_tmpl temp = _dal.GetByCode(code);
            if (temp == null)
                return true;
            if (temp != null && temp.id == id)
                return true;
            return false;
        }

        /// <summary>
        /// 通过Id 获取模板
        /// </summary>
        public sys_form_tmpl GetTempById(long id)
        {
            return _dal.FindNoDeleteById(id);
        }

        /// <summary>
        /// 新增商机模板
        /// </summary>
        public bool AddOpportunityTmpl(sys_form_tmpl tmpl,sys_form_tmpl_opportunity tmplOppo,long userId)
        {
            if (!AddFormTmpl(tmpl, userId))
                return false;
            tmplOppo.id = _dal.GetNextIdCom();
            tmplOppo.form_tmpl_id = tmpl.id;
            tmplOppo.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            tmplOppo.create_user_id = userId;
            tmplOppo.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            tmplOppo.update_user_id = userId;
            new sys_form_tmpl_opportunity_dal().Insert(tmplOppo);
            return true;
        }
        /// <summary>
        /// 编辑商机模板
        /// </summary>
        public bool EditOpportunityTmpl(sys_form_tmpl tmpl, sys_form_tmpl_opportunity tmplOppo, long userId)
        {
            if (!EditFormTmpl(tmpl, userId))
                return false;
            tmplOppo.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            tmplOppo.update_user_id = userId;
            new sys_form_tmpl_opportunity_dal().Update(tmplOppo);
            return true;
        }

        /// <summary>
        /// 新增模板
        /// </summary>
        public bool AddFormTmpl(sys_form_tmpl tmpl,long userId)
        {
            if (!CheckTempCode(tmpl.speed_code))
                return false;
            tmpl.id = _dal.GetNextIdCom();
            tmpl.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            tmpl.create_user_id = userId;
            tmpl.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            tmpl.update_user_id = userId;
            _dal.Insert(tmpl);
            return true;
        }
        /// <summary>
        /// 编辑模板
        /// </summary>
        public bool EditFormTmpl(sys_form_tmpl tmpl, long userId)
        {
            var oldTemp = _dal.FindNoDeleteById(tmpl.id);
            if (oldTemp == null)
                return false;
            if (!CheckTempCode(tmpl.speed_code,tmpl.id))
                return false;
            tmpl.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            tmpl.update_user_id = userId;
            _dal.Update(tmpl);
            //OperLogBLL.OperLogAdd<sys_form_tmpl>();
            return true;
        }
        /// <summary>
        /// 激活/失活 模板
        /// </summary>
        public bool ActiveTmpl(long id,bool isActive,long userId)
        {
            var tmpl = _dal.FindNoDeleteById(id);
            if (tmpl == null)
                return false;
            sbyte active = (sbyte)(isActive ? 1 : 0);
            if(tmpl.is_active!= active)
            {
                tmpl.is_active = active;
                tmpl.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                tmpl.update_user_id = userId;
                _dal.Update(tmpl);
            }
            return true;
        }
        /// <summary>
        /// 删除模板
        /// </summary>
        public bool DeleteTmpl(long id,long userId)
        {
            var tmpl = _dal.FindNoDeleteById(id);
            if (tmpl == null)
                return true;
            _dal.SoftDelete(tmpl,userId);
            if (tmpl.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.OPPORTUNITY)
            {
                var oppoTmp = GetOpportunityTmpl(tmpl.id);
                if (oppoTmp != null)
                    new sys_form_tmpl_opportunity_dal().SoftDelete(oppoTmp,userId);
            }
            else if (tmpl.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.PROJECT_NOTE)
            {

            }
            else if (tmpl.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.QUICK_CALL)
            {

            }
            else if (tmpl.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.QUOTE)
            {

            }
            else if (tmpl.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.RECURRING_TICKET)
            {

            }
            else if (tmpl.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.SERVICE_CALL)
            {

            }
            else if (tmpl.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.TASK_NOTE)
            {

            }
            else if (tmpl.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.TASK_TIME_ENTRY)
            {

            }
            else if (tmpl.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.TICKET)
            {

            }
            else if (tmpl.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.TICKET_NOTE)
            {

            }
            else if (tmpl.form_type_id == (int)DicEnum.FORM_TMPL_TYPE.TICKET_TIME_ENTRY)
            {

            }

            return true;
        }


    }
}
