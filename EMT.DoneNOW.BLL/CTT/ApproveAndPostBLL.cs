using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 审批并提交
    /// </summary>
    public class ApproveAndPostBLL
    {
        private readonly crm_account_deduction_dal _dal = new crm_account_deduction_dal();
        /// <summary>
        ///单条审批
        /// </summary>
        /// <param name="id">里程碑id</param>
        /// <param name="date">提交日期</param>
        /// <param name="type">审批类型</param>
        /// <returns></returns>
        public ERROR_CODE Post(int id, int date, long type)
        {
            crm_account_deduction cad = new crm_account_deduction();
            //审批里程碑
            if (type == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_MILESTONES)
            {
                cad.id = (int)(_dal.GetNextIdCom());
                cad.type_id = (int)ACCOUNT_DEDUCTION_TYPE.MILESTONES;
                cad.object_id = id;
                string ddd=DateTime.ParseExact(date.ToString(), "yyyyMMdd", CultureInfo.CurrentCulture).ToString("yyyy-MM-dd");
                //cad.posted_date =Convert.ToDateTime(date);//日期
            }

            return ERROR_CODE.SUCCESS;
        }
    }
}
