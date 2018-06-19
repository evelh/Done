using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System.Text.RegularExpressions;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class SystemSetting : BasePage
    {
        
        protected Dictionary<int, List<sys_system_setting>> setDic;
        protected List<d_general> moduleList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.SYSTEM_SETTING_MODULE);
        protected SysSettingBLL setBll = new SysSettingBLL();
        protected List<sys_system_setting> settingList;
        protected void Page_Load(object sender, EventArgs e)
        {
            settingList = setBll.GetAllSet();
            if(settingList!=null&& settingList.Count > 0)
            {
                setDic = settingList.GroupBy(_ => _.module_id).ToDictionary(_=>_.Key,_=>_.ToList());
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            setBll.SystemSet(param,LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存成功!');location.href='../SysSetting/SystemSetting.aspx';</script>");

        }

        protected Dictionary<long,string> GetParam()
        {
            Dictionary<long, string> dic = new Dictionary<long, string>();
            if(settingList!=null&& settingList.Count > 0)
            {
                Regex reg = new Regex(@"^[0-9]*$");
                foreach (var set in settingList)
                {
                    if(set.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.MUILT_CALLBACK|| set.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.CALLBACK)
                    {
                        continue;
                    }
                    else if(set.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.BOOLEAN)
                    {
                        if (!string.IsNullOrEmpty(Request.Form[set.id.ToString() + "Check"]) && Request.Form[set.id.ToString() + "Check"] == "on")
                            dic.Add(set.id,"1");
                        else
                            dic.Add(set.id, "0");
                    }
                    else if (set.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER)
                    {
                        if (!string.IsNullOrEmpty(Request.Form[set.id.ToString() + "Number"])&& reg.IsMatch(Request.Form[set.id.ToString() + "Number"]))
                            dic.Add(set.id, Request.Form[set.id.ToString() + "Number"]);
                    }
                    else
                    {
                        dic.Add(set.id, Request.Form[set.id.ToString()]);
                    }
                }
            }

            return dic;
        }
    }
}