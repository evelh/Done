using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using static EMT.DoneNOW.DTO.DicEnum;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class crm_location_dal : BaseDAL<crm_location>
    {
        /// <summary>
        /// 通过客户id去获取默认地址
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public crm_location GetLocationByAccountId(long account_id)
        {
            return FindSignleBySql<crm_location>($"SELECT * from crm_location where account_id = {account_id} and delete_time = 0 and is_default = 1 " );
        }

        /// <summary>
        /// 取消该用户的默认地址
        /// </summary>
        /// <returns></returns>
        public int UpdateDefaultLocation(long account_id,UserInfoDto user)
        {
            string sql = $"UPDATE crm_location set is_default = 0 where account_id = {account_id} and is_default = 1";
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                oper_object_id = account_id,
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = @"{""is_default"":""1→0""}",  // {"is_default":"1→0"},
                remark = "修改客户默认地址",
            });
            return ExecuteSQL(sql);
        }

        /// <summary>
        /// 根据ID获取到未删除的地址信息
        /// </summary>
        /// <returns></returns>
        public crm_location GetLocationById(long location_id)
        {
            return FindSignleBySql<crm_location>($"select * from crm_location where id = {location_id} and delete_time = 0 ");
        }

        /// <summary>
        /// 获取到用户的所有未删除的地址
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<crm_location> GetLocationByCompany(long account_id)
        {
            return FindListBySql($"select * from crm_location where account_id = {account_id} and delete_time = 0  order by province_id,city_id,district_id ");
        }
    }
}
