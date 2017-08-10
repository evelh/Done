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
    }
}
