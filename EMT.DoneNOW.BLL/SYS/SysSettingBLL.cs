using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 系统设置
    /// </summary>
    public class SysSettingBLL
    {
        private sys_system_setting_dal dal = new sys_system_setting_dal();

        /// <summary>
        /// 根据系统设置表的id值获取配置的value
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public string GetValueById(SysSettingEnum id)
        {
            return dal.FindById((long)id).setting_value;
        }

        /// <summary>
        /// 根据ID获取到系统设置
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_system_setting GetSetById(SysSettingEnum id)
        {
            return dal.FindById((long)id);
        }
        /// <summary>
        /// 改变系统设置的值
        /// </summary>
        public void ChangeSetValue(long setId,string setValue,long userId)
        {
            var thisSet = dal.FindById(setId);
            if (thisSet == null)
                return;
            if (thisSet.setting_value != setValue)
            {
                var oldSet = dal.FindById(setId);
                thisSet.setting_value = setValue;
                dal.Update(thisSet);
                OperLogBLL.OperLogUpdate<sys_system_setting>(thisSet, oldSet, thisSet.id, userId,DicEnum.OPER_LOG_OBJ_CATE.SERVICE_CALL, "编辑系统设置");
            }
        }
    }
}
