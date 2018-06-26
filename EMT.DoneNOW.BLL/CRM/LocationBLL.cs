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
            }
            location.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            location.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            location.create_user_id = user.id;
            location.update_user_id = user.id;
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

            new_location.oid = old_location.oid;
            new_location.create_user_id = old_location.create_user_id;
            new_location.create_time = old_location.create_time;
            new_location.update_user_id = old_location.update_user_id;
            new_location.update_time = old_location.update_time;
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
            var location = _dal.GetLocationById(location_id);
            var result= _dal.SoftDelete(location, user_id);
            OperLogBLL.OperLogDelete<crm_location>(location,location.id,user_id,OPER_LOG_OBJ_CATE.CUSTOMER,"删除客户");
            return result;
        }



        /// <summary>
        /// 新增区域
        /// </summary>
        public bool AddOrganization(sys_organization_location location,long userId)
        {
            if (OrganizationManage(location, userId))
                OrganizationHours(location.id, null, userId);
            else
                return false;
            return true;
        }
        /// <summary>
        /// 编辑区域
        /// </summary>
        public bool EditOrganization(sys_organization_location location,List<sys_organization_location_workhours> hoursList, long userId)
        {
            if (OrganizationManage(location, userId))
                OrganizationHours(location.id, hoursList, userId);
            else
                return false;
            return true;
        }

        public void OrganizationHours(long locationId,List<sys_organization_location_workhours> hoursList,long user_id)
        {
            sys_organization_location_workhours_dal solwDal = new sys_organization_location_workhours_dal();
            long timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp();
            if (hoursList != null&& hoursList.Count > 0)
            {
                foreach (var hours in hoursList)
                {
                    hours.update_time = timeNow;
                    hours.update_user_id = user_id;
                    solwDal.Update(hours);
                }
            }
            else
            {
                for (int i = 1; i < 8; i++)
                {
                    sys_organization_location_workhours hours = new sys_organization_location_workhours() {
                        id = solwDal.GetNextIdCom(),
                        create_time = timeNow,
                        update_time = timeNow,
                        create_user_id = user_id,
                        update_user_id = user_id,
                        location_id = locationId,
                        weekday =  (sbyte)(i==7?0:i),
                        start_time = (i == 7||i==6)?"":"09:00",
                        end_time = (i == 7||i == 6)?"":"18:00",
                    };
                    solwDal.Insert(hours);
                }
            }
        }


        /// <summary>
        /// 区域管理
        /// </summary>
        public bool OrganizationManage(sys_organization_location location,long user_id)
        {
            sys_organization_location_dal solDal = new sys_organization_location_dal();

           
            var defaultLoca = GetDefaultOrganization();
            if (location.is_default == 1)
            {
                if (defaultLoca != null && defaultLoca.id != location.id)
                {
                    defaultLoca.is_default = 0;
                    OrganizationManage(defaultLoca, user_id);
                }
            }
            else
            {
                if (defaultLoca == null)
                {
                    return false;
                }
            }
            if (location.id == 0)
            {
                location.id = solDal.GetNextIdCom();
                location.create_time = location.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                location.create_user_id = location.update_user_id = user_id;
                solDal.Insert(location);
            }
            else
            {
                var oldLocaton = GetOrganization(location.id);
                if (oldLocaton == null)
                    return false;
                location.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                location.update_user_id = user_id;
                solDal.Update(location);
            }

            return true;
        }
        /// <summary>
        /// 获取相关区域
        /// </summary>
        public sys_organization_location GetOrganization(long id)
        {
            return new sys_organization_location_dal().FindNoDeleteById(id);
        }

        /// <summary>
        /// 获取默认区域
        /// </summary>
        public sys_organization_location GetDefaultOrganization()
        {
            return new sys_organization_location_dal().FindSignleBySql<sys_organization_location>($"SELECT * from sys_organization_location where is_default = 1 and delete_time = 0");
        }

        /// <summary>
        /// 根据区域获取相关时间
        /// </summary>
        public List<sys_organization_location_workhours> GetWorkHourList(long id)
        {
            return new sys_organization_location_workhours_dal().FindListBySql($"SELECT * from sys_organization_location_workhours where delete_time = 0 and location_id = {id} order by id");
        }

    }
}
