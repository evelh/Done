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
    public partial class DuplicateTicket : BasePage
    {
        protected DuplicateTicketDto dto;
        protected SysSettingBLL setBll = new SysSettingBLL();
        protected List<d_general> stausList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.TICKET_STATUS);
        protected void Page_Load(object sender, EventArgs e)
        {
            var thisSet = setBll.GetSetById(SysSettingEnum.DUPLICATE_TICKET_HANDLING);

            if (thisSet != null&&!string.IsNullOrEmpty(thisSet.setting_value))
            {
                dto = new Tools.Serialize().DeserializeJson<DuplicateTicketDto>(thisSet.setting_value);
            }
            if (dto == null)
            {
                dto = new DuplicateTicketDto();
            }
            
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            DuplicateTicketDto pageDto = AssembleModel<DuplicateTicketDto>();

            if (!string.IsNullOrEmpty(Request.Form["isSameNo"]) && Request.Form["isSameNo"] == "on")
                pageDto.SameNo = true;
            else
                pageDto.SameNo = false;

            if (!string.IsNullOrEmpty(Request.Form["isSameAlertId"]) && Request.Form["isSameAlertId"] == "on")
                pageDto.SameAlertId = true;
            else
                pageDto.SameAlertId = false;

            if (!string.IsNullOrEmpty(Request.Form["isSameExter"]) && Request.Form["isSameExter"] == "on")
                pageDto.SameExter = true;
            else
                pageDto.SameExter = false;

            if (!string.IsNullOrEmpty(Request.Form["isSameTitleConfig"]) && Request.Form["isSameTitleConfig"] == "on")
                pageDto.SameTitleConfig = true;
            else
                pageDto.SameTitleConfig = false;

            if (!string.IsNullOrEmpty(Request.Form["isSameTitle"]) && Request.Form["isSameTitle"] == "on")
                pageDto.SameTitle = true;
            else
                pageDto.SameTitle = false;

            if (!string.IsNullOrEmpty(Request.Form["isSameConfig"]) && Request.Form["isSameConfig"] == "on")
                pageDto.SameConfig = true;
            else
                pageDto.SameConfig = false;

            pageDto.actionValue = Request.Form["SameAction"];
            if (pageDto.actionValue == "AsNote")
            {
                if (!string.IsNullOrEmpty(Request.Form["isFirstComplete"]) && Request.Form["isFirstComplete"] == "on")
                {
                    pageDto.NoteComplete = true;
                    if (!string.IsNullOrEmpty(Request.Form["isFirstCompleteStatusId"]))
                        pageDto.CompleteStatusId = int.Parse(Request.Form["isFirstCompleteStatusId"]);
                }
                else
                    pageDto.NoteComplete = false;
                if (!string.IsNullOrEmpty(Request.Form["isFirstOtherThanComplete"]) && Request.Form["isFirstOtherThanComplete"] == "on")
                {
                    pageDto.NoteNoComplete = true;
                    if (!string.IsNullOrEmpty(Request.Form["isFirstOtherThanCompleteStatusId"]))
                        pageDto.NoCompleteStatusId = int.Parse(Request.Form["isFirstOtherThanCompleteStatusId"]);
                }
                else
                    pageDto.NoteNoComplete = false;
                

            }
            else if (pageDto.actionValue == "AsInclide")
            {
                if (!string.IsNullOrEmpty(Request.Form["isSecondComplete"]) && Request.Form["isSecondComplete"] == "on")
                {
                    pageDto.IncidentComplete = true;
                    if (!string.IsNullOrEmpty(Request.Form["isSecondCompleteStatusId"]))
                        pageDto.CompleteStatusId = int.Parse(Request.Form["isSecondCompleteStatusId"]);
                }
                else
                    pageDto.IncidentComplete = false;
                if (!string.IsNullOrEmpty(Request.Form["isSecondOtherThanComplete"]) && Request.Form["isSecondOtherThanComplete"] == "on")
                {
                    pageDto.IncidentNoComplete = true;
                    if (!string.IsNullOrEmpty(Request.Form["isSecondOtherThanCompleteStatusId"]))
                        pageDto.NoCompleteStatusId = int.Parse(Request.Form["isSecondOtherThanCompleteStatusId"]);
                }
                else
                    pageDto.IncidentNoComplete = false;
            }
            else if (pageDto.actionValue == "NoAction")
            {

            }

            setBll.ChangeSetValue((long)SysSettingEnum.DUPLICATE_TICKET_HANDLING,new Tools.Serialize().SerializeJson(pageDto),LoginUserId) ;
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存成功!');self.opener.location.reload();window.close();</script>");


        }
    }
}