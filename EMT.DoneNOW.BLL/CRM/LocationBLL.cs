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

namespace EMT.DoneNOW.BLL.CRM
{
    public class LocationBLL
    {
        private readonly crm_location_dal _dal = new crm_location_dal();

        /// <summary>
        /// 获取到用户的默认地址
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public crm_location GetLocationByAccountId(long account_id)
        {
            return new crm_location_dal().GetLocationByAccountId(account_id);
        }


        /// <summary>
        /// 插入地址
        /// </summary>
        /// <param name="location"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool Insert(crm_location location , long user_id)
        {           
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (location.id == 0)
            {
                location.id = _dal.GetNextIdCom();
                location.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                location.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                location.create_user_id = user.id;
                location.update_user_id = user.id;
            }
            // 修改客户显示默认地址，默认地址不能主动移除
            var default_location = _dal.GetLocationByAccountId((long)location.account_id);
            if (location.is_default == 1&&default_location!=null)
            {
                new crm_location_dal().UpdateDefaultLocation((long)location.account_id, user); // 首先将原来的默认地址取消  操作日志在方法内插入
            }


            new crm_location_dal().Insert(location);       
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                oper_object_id = location.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(location),
                remark = "保存地址信息"
            });       // 插入日志
            return true;
        }


        /// <summary>
        /// 更改地址
        /// </summary>
        /// <param name="new_location"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool Update(crm_location new_location,long user_id)
        {
            crm_location old_location = new crm_location_dal().GetLocationById(new_location.id);  // 根据客户id去获取到客户的地址，然后判断地址是否修改
        
            if (!old_location.Equals(new_location))   // 代表用户更改了地址
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                new_location.update_user_id = user.id;
                new_location.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                new_location.additional_address = string.IsNullOrEmpty(new_location.additional_address) ? "" : new_location.additional_address;
                // 修改客户显示默认地址，默认地址不能主动移除
                if (new_location.is_default == 1&&old_location.is_default!=1)   //  默认地址不进行修改的时候，忽略不计
                {
                    new crm_location_dal().UpdateDefaultLocation((long)new_location.account_id, user); // 首先将原来的默认地址取消  操作日志在方法内插入
                }
               
                new crm_location_dal().Update(new_location);             // 更改地址信息
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                    oper_object_id = new_location.id,
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.CompareValue(old_location, new_location),
                    remark = "修改客户地址",
                });    // 插入更改日志
            }

            return true;
        }



        /// <summary>
        /// 获取到客户的所有地址
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<crm_location> GetLocationByCompany(long account_id)
        {
            return _dal.GetLocationByCompany(account_id);
        }

        /// <summary>
        /// 根据地址ID获取到地址
        /// </summary>
        /// <param name="location_id"></param>
        /// <returns></returns>
        public crm_location GetLocation(long location_id)
        {
            return _dal.GetLocationById(location_id);
        }


        public List<crm_location> GetAllQuoteLocation(long location_id)
        {
            return _dal.GetAllQuoteLocation(location_id);
        }


        public bool DeleteLocation(long location_id,long user_id)
        {
            return _dal.SoftDelete(_dal.GetLocationById(location_id), user_id);
        }

    }
}
