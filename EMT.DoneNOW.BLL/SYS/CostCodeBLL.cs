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
            if (!CheckCodeName(code.name))
                return false;
            code.id = _dal.GetNextIdCom();
            code.create_time = code.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            code.create_user_id = code.update_user_id = userId;
          
            _dal.Insert(code);
            OperLogBLL.OperLogAdd<d_cost_code>(code, code.id, userId, OPER_LOG_OBJ_CATE.D_COST_CODE, "");
            return true;
        }

        /// <summary>
        /// 根据名称获取相关代码
        /// </summary>
        public d_cost_code GetCodeByName(string name)
        {
            return _dal.FindSignleBySql<d_cost_code>($"SELECT * from d_cost_code where name = '{name}'");
        }
        /// <summary>
        /// 根据id获取相关代码
        /// </summary>
        public d_cost_code GetCodeById(long id)
        {
            return _dal.FindNoDeleteById(id);
        }
        /// <summary>
        /// 校验代码名称是否重复
        /// </summary>
        public bool CheckCodeName(string name,long id=0)
        {
            d_cost_code thisCode = GetCodeByName(name);
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
            if (!CheckCodeName(code.name,code.id))
                return false;
            code.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            code.update_user_id = userId;
            _dal.Update(code);
            OperLogBLL.OperLogUpdate<d_cost_code>(code, oldCode, code.id, userId, OPER_LOG_OBJ_CATE.D_COST_CODE, "");
            return true;
        }
    }
}
