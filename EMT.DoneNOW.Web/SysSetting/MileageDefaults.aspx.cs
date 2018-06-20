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
    public partial class MileageDefaults : BasePage
    {
        protected SysSettingBLL setBll = new SysSettingBLL();
        protected MileageDefaultsDto dto;
        protected d_cost_code thisCode;
        protected void Page_Load(object sender, EventArgs e)
        {
            var thisSet = setBll.GetSetById(SysSettingEnum.MILEAGE_KILOMETRAGE_DEFAULTS);
            if (thisSet != null && !string.IsNullOrEmpty(thisSet.setting_value))
            {
                dto = new Tools.Serialize().DeserializeJson<MileageDefaultsDto>(thisSet.setting_value);
            }
            if (dto == null)
            {
                dto = new MileageDefaultsDto();
            }
            if (dto.costCodeId != null)
            {
                thisCode = new CostCodeBLL().GetCodeById((long)dto.costCodeId);
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            MileageDefaultsDto pageDto = AssembleModel<MileageDefaultsDto>();

            if (!string.IsNullOrEmpty(Request.Form["isCk"]) && Request.Form["isCk"] == "on")
                pageDto.isCheck = true;
            else
                pageDto.isCheck = false;

            setBll.ChangeSetValue((long)SysSettingEnum.MILEAGE_KILOMETRAGE_DEFAULTS, new Tools.Serialize().SerializeJson(pageDto), LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存成功!');self.opener.location.reload();window.close();</script>");
        }
    }
    public class MileageDefaultsDto
    {
        public long? costCodeId;
        public bool isCheck;
    }
}