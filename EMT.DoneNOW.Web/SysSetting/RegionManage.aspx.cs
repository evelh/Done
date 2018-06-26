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
    public partial class RegionManage : BasePage
    {
        protected sys_organization_location location;
        protected List<sys_organization_location_workhours> hoursList;
        protected bool isAdd = true;
        protected List<d_country> counList = new DAL.d_country_dal().FindAll().ToList();
        protected List<d_general> holidayList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.HOLIDAY_SET);
        protected string[] weekArr = new string[] { "星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };
        protected LocationBLL locaBll = new LocationBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                location = locaBll.GetOrganization(id);
            if (location != null)
            {
                hoursList = locaBll.GetWorkHourList(location.id);isAdd = false;
            }
                
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var pageLocation = AssembleModel<sys_organization_location>();
            if (!string.IsNullOrEmpty(Request.Form["isDefault"]) && Request.Form["isDefault"] == "on")
                pageLocation.is_default = 1;
            else
                pageLocation.is_default = 0;
            if (Request.Form["HoursType"] == "yes")
                pageLocation.holiday_hours_type_id = (int)DTO.DicEnum.HOLIDAY_HOURS_TYPE.WORK;
            else
                pageLocation.holiday_hours_type_id = (int)DTO.DicEnum.HOLIDAY_HOURS_TYPE.NO_WORK;

            if (!isAdd)
            {
                if(location.is_default != 1)
                    location.is_default = pageLocation.is_default;
                location.name = pageLocation.name;
                location.country_id = pageLocation.country_id;
                location.province_id = pageLocation.province_id;
                location.city_id = pageLocation.city_id;
                location.district_id = pageLocation.district_id;
                location.address = pageLocation.address;
                location.additional_address = pageLocation.additional_address;
                location.postal_code = pageLocation.postal_code;
                location.holiday_set_id = pageLocation.holiday_set_id;
                location.holiday_hours_type_id = pageLocation.holiday_hours_type_id;

                if (hoursList!=null&& hoursList.Count > 0)
                {
                    foreach (var hours in hoursList)
                    {
                        hours.start_time = Request.Form[hours.id.ToString()+ "_start_time"];
                        hours.end_time = Request.Form[hours.id.ToString()+ "_end_time"];
                        hours.extended_start_time = Request.Form[hours.id.ToString()+ "_extended_start_time"];
                        hours.extended_end_time = Request.Form[hours.id.ToString()+ "_extended_end_time"];
                    }
                }
            }
            bool result = false;
            if (isAdd)
                result = locaBll.AddOrganization(pageLocation,LoginUserId);
            else
                result = locaBll.EditOrganization(location, hoursList, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');window.close();</script>");


        }
    }
}