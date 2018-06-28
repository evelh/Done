using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.SLA
{
    public partial class SLAManage : BasePage
    {
        protected d_sla sla;
        protected List<sys_organization_location_workhours> hoursList;
        protected List<d_sla_item> itemList;
        protected bool isAdd = true;
        protected SLABLL bll = new SLABLL();
        protected List<sys_organization_location> locaList = new LocationBLL().GetAllOrganization();
        protected List<d_general> holidayList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.HOLIDAY_SET);
        protected string[] weekArr = new string[] { "星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                sla = bll.GetSlaById(id);
            if (sla != null)
            {
                itemList = bll.GetSLAItem(sla.id); hoursList = bll.GetWorkHourList(sla.id); isAdd = false;
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            d_sla pageSla = AssembleModel<d_sla>();
            if (!string.IsNullOrEmpty(Request.Form["isSetEnd"]) && Request.Form["isSetEnd"] == "on")
                pageSla.set_ticket_due_date = 1;
            else
                pageSla.set_ticket_due_date = 0;
            if (Request.Form["HoursType"] == "yes")
                pageSla.holiday_hours_type_id = (int)DTO.DicEnum.HOLIDAY_HOURS_TYPE.WORK;
            else
                pageSla.holiday_hours_type_id = (int)DTO.DicEnum.HOLIDAY_HOURS_TYPE.NO_WORK;

            if (!isAdd)
            {
                sla.name = pageSla.name;
                sla.description = pageSla.description;
                sla.first_response_goal_percentage = pageSla.first_response_goal_percentage;
                sla.resolution_plan_goal_percentage = pageSla.resolution_plan_goal_percentage;
                sla.location_id = pageSla.location_id;
                sla.resolution_goal_percentage = pageSla.resolution_goal_percentage;
                sla.set_ticket_due_date = pageSla.set_ticket_due_date;
                sla.holiday_hours_type_id = pageSla.holiday_hours_type_id;

                if (hoursList != null && hoursList.Count > 0&& sla.location_id==null)
                {
                    foreach (var hours in hoursList)
                    {
                        hours.start_time = Request.Form[hours.id.ToString() + "_start_time"];
                        hours.end_time = Request.Form[hours.id.ToString() + "_end_time"];
                        hours.extended_start_time = Request.Form[hours.id.ToString() + "_extended_start_time"];
                        hours.extended_end_time = Request.Form[hours.id.ToString() + "_extended_end_time"];
                    }
                }
            }

            bool result = false;
            if (isAdd)
                result = bll.AddSLA(pageSla, LoginUserId);
            else
                result = bll.EditSLA(sla, hoursList, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');window.close();</script>");

        }
    }
}