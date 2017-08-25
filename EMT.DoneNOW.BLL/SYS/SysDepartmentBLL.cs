using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
   public class SysDepartmentBLL
    {
        private readonly sys_department_dal _dal = new sys_department_dal();
        /// <summary>
        /// 获取地址下拉框
        /// </summary>
        /// <returns></returns>
        public Dictionary<long, string> GetDownList()
        {
            Dictionary<long, string> dic = new Dictionary<long, string>();
            return new sys_organization_location_dal().FindListBySql<sys_organization_location>($"select * from crm_location where delete_time=0").ToDictionary(d => d.id, d =>d.name);
        }
        /// <summary>
        /// 根据地址id获取时区//具体显示后期需要修改8-24
        /// </summary>
        /// <returns></returns>
        public string GetTime_zone(int id) {
            var location = new sys_organization_location_dal().FindById(id);
            if (location != null) {
                var timezone = new d_time_zone_dal().FindById(location.time_zone_id);
                if (timezone != null)
                {
                    return timezone.standard_name;
                }
            }
            return "";
        }
        public ERROR_CODE Insert(sys_department sd,long user_id) {
            sd.id= (int)(_dal.GetNextIdCom());
            sd.create_time=sd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            sd.create_user_id = user_id;
            sd.cate_id =(int)DEPARTMENT_CATE.DEPARTMENT;
            _dal.Insert(sd);
            return ERROR_CODE.SUCCESS;
        }
        public ERROR_CODE Update(sys_department sd, long user_id)
        {
            sd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            sd.update_user_id = user_id;
            sd.cate_id = (int)DEPARTMENT_CATE.DEPARTMENT;
            if (!_dal.Update(sd)) {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        public ERROR_CODE Delete(sys_department sd, long user_id)
        {
            sd.delete_user_id= user_id;
            sd.delete_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            sd.cate_id = (int)DEPARTMENT_CATE.DEPARTMENT;
            if (!_dal.Update(sd))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        ///通过id查找一个sys_department对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_department GetOne(int id) {
            return _dal.FindById(id);
        }
    }
}
