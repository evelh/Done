using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class SystemSetting : BasePage
    {
        
        protected Dictionary<int, List<sys_system_setting>> setDic;
        protected List<d_general> moduleList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.SYSTEM_SETTING_MODULE);
        protected SysSettingBLL setBll = new SysSettingBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            List<sys_system_setting> settingList = setBll.GetAllSet();
            if(settingList!=null&& settingList.Count > 0)
            {
                setDic = settingList.GroupBy(_ => _.module_id).ToDictionary(_=>_.Key,_=>_.ToList());
            }
        }
    }
}