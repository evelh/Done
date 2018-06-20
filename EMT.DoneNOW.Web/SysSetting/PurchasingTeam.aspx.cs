using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class PurchasingTeam : BasePage
    {
        protected PurchasingTeamDto dto;
        protected SysSettingBLL setBll = new SysSettingBLL();
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList();
        protected void Page_Load(object sender, EventArgs e)
        {
            var thisSet = setBll.GetSetById(SysSettingEnum.PURCHASING_TEAM);

            if (thisSet != null && !string.IsNullOrEmpty(thisSet.setting_value))
            {
                dto = new Tools.Serialize().DeserializeJson<PurchasingTeamDto>(thisSet.setting_value);
            }
            if (dto == null)
            {
                dto = new PurchasingTeamDto();
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            PurchasingTeamDto pageDto = AssembleModel<PurchasingTeamDto>();

            pageDto.ids = Request.Form["to[]"];
            pageDto.emails = Request.Form["emails"];
            setBll.ChangeSetValue((long)SysSettingEnum.PURCHASING_TEAM, new Tools.Serialize().SerializeJson(pageDto), LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存成功!');self.opener.location.reload();window.close();</script>");
        }
    }

    public class PurchasingTeamDto
    {
        public string ids=string.Empty;
        public string emails;
    }
}