using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public  class CostCodeBLL
    {
        private d_cost_code_dal _dal = new d_cost_code_dal();
        public bool AddCode(d_cost_code code,long userId)
        {
            // code.id
            if (!CheckCodeName(code.name,code.cate_id))
                return false;
            code.id = _dal.GetNextIdCom();
            code.create_time = code.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            code.create_user_id = code.update_user_id = userId;
          
            _dal.Insert(code);
            OperLogBLL.OperLogAdd<d_cost_code>(code, code.id, userId, OPER_LOG_OBJ_CATE.D_COST_CODE, "");
            return true;
        }
        public bool AddCodeRule(d_cost_code_rule code, long userId)
        {
           
            code.id = _dal.GetNextIdCom();
            code.create_time = code.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            code.create_user_id = code.update_user_id = userId;
            new d_cost_code_rule_dal().Insert(code);
            // OperLogBLL.OperLogAdd<d_cost_code>(code, code.id, userId, OPER_LOG_OBJ_CATE.D_COST_CODE, "");
            return true;
        }

        /// <summary>
        /// 根据名称获取相关代码
        /// </summary>
        public d_cost_code GetCodeByName(string name,long cate_id)
        {
            return _dal.FindSignleBySql<d_cost_code>($"SELECT * from d_cost_code where name = '{name}' and cate_id={cate_id}");
        }
        /// <summary>
        /// 根据id获取相关代码
        /// </summary>
        public d_cost_code GetCodeById(long id)
        {
            return _dal.FindNoDeleteById(id);
        }
        /// <summary>
        /// 根据总账Id 获取相关的工作类型的物料代码
        /// </summary>
        public List<d_cost_code> GetWorkCodeByLedger(long id)
        {
            return _dal.FindListBySql<d_cost_code>($"SELECT * from d_cost_code where cate_id ={(int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE} and delete_time = 0 and general_ledger_id = {id}");
        }
        /// <summary>
        /// 获取费用规则相关
        /// </summary>
        public d_cost_code_rule GetCodeRuleById(long id)
        {
            return new d_cost_code_rule_dal().FindNoDeleteById(id);
        }
        /// <summary>
        /// 根据为物料代码获取相关规则
        /// </summary>
        public List<d_cost_code_rule> GetRuleListByCodeId(long codeId)
        {
            return _dal.FindListBySql<d_cost_code_rule>($"SELECT * from d_cost_code_rule where delete_time = 0 and cost_code_id = {codeId}");
        }


        /// <summary>
        /// 校验代码名称是否重复
        /// </summary>
        public bool CheckCodeName(string name,long cateId,long id=0)
        {
            d_cost_code thisCode = GetCodeByName(name, cateId);
            if (thisCode != null && thisCode.id != id)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 编辑物料代码
        /// </summary>
        public bool EditCode(d_cost_code code, long userId)
        {
            d_cost_code oldCode = GetCodeById(code.id);
            if (oldCode == null)
                return false;
            if (!CheckCodeName(code.name,code.cate_id,code.id))
                return false;
            code.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            code.update_user_id = userId;
            _dal.Update(code);
            OperLogBLL.OperLogUpdate<d_cost_code>(code, oldCode, code.id, userId, OPER_LOG_OBJ_CATE.D_COST_CODE, "");
            return true;
        }

        /// <summary>
        /// 编辑物料代码
        /// </summary>
        public bool EditCodeRule(d_cost_code_rule code, long userId)
        {
            d_cost_code_rule oldCode = GetCodeRuleById(code.id);
            if (oldCode == null)
                return false;
            
            code.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            code.update_user_id = userId;
            new d_cost_code_rule_dal().Update(code);
            // OperLogBLL.OperLogUpdate<d_cost_code>(code, oldCode, code.id, userId, OPER_LOG_OBJ_CATE.D_COST_CODE, "");
            return true;
        }
        /// <summary>
        /// 是否可以删除物料代码校验
        /// </summary>
        public bool DeleteCodeCheck(long id)
        {
            d_cost_code code = GetCodeById(id);
            if (code == null)
                return true;
            // 报价项，成本，工单，产品。费用，工时
            List<crm_quote_item> quoteItem = _dal.FindListBySql<crm_quote_item>($"SELECT * from crm_quote_item where object_id ={id.ToString()} and delete_time = 0");
            if (quoteItem != null && quoteItem.Count > 0)
                return false;
            List<ctt_contract_cost> costList = _dal.FindListBySql<ctt_contract_cost>($"SELECT * from ctt_contract_cost where cost_code_id ={id.ToString()} and delete_time = 0");
            if (costList != null && costList.Count > 0)
                return false;
            List<sdk_task> taskList = _dal.FindListBySql<sdk_task>($"SELECT * from sdk_task where cost_code_id ={id.ToString()} and delete_time = 0");
            if (taskList != null && taskList.Count > 0)
                return false;
            List<ivt_product> productList = _dal.FindListBySql<ivt_product>($"SELECT * from ivt_product where cost_code_id ={id.ToString()} and delete_time = 0");
            if (productList != null && productList.Count > 0)
                return false;
            List<sdk_expense> expenList = _dal.FindListBySql<sdk_expense>($"SELECT * from sdk_expense where cost_code_id ={id.ToString()} and delete_time = 0");
            if (expenList != null && expenList.Count > 0)
                return false;
            List<sdk_work_entry> entryList = _dal.FindListBySql<sdk_work_entry>($"SELECT * from sdk_work_entry where cost_code_id ={id.ToString()} and delete_time = 0");
            if (entryList != null && entryList.Count > 0)
                return false;
           
            return true;
        }

        public bool DeleteCode(long codeId,long userId)
        {
            if (!DeleteCodeCheck(codeId))
                return false;
            d_cost_code thisCode = GetCodeById(codeId);
            _dal.SoftDelete(thisCode,userId);
            OperLogBLL.OperLogDelete<d_cost_code>(thisCode, thisCode.id, userId, OPER_LOG_OBJ_CATE.D_COST_CODE, "");
            return true;
        }

    }
}
