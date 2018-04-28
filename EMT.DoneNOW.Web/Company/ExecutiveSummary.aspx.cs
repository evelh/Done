using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;


namespace EMT.DoneNOW.Web.Company
{
    public partial class ExecutiveSummary : System.Web.UI.Page
    {
        protected crm_account account;
        protected crm_location accLocation;
        protected CompanyBLL comBll = new CompanyBLL();
        protected string countryName;
        protected string provinceName;
        protected string cityName;
        protected string districtName;
        protected sys_resource accMan;
        protected DateTime startDate;
        protected DateTime endDate;
        protected decimal contractMoney;
        protected decimal projectMoney;
        protected d_account_classification accClass;
        protected void Page_Load(object sender, EventArgs e)
        {
            var accountId = Request.QueryString["accountId"];
            if (!string.IsNullOrEmpty(accountId))
                account = comBll.GetCompany(long.Parse(accountId));
            if (account == null)
            {
                Response.Write("<script>alert('未获取到客户信息');window.close();</script>");
                return;
            }
            accLocation = new DAL.crm_location_dal().GetLocationByAccountId(account.id);
            if (accLocation != null)
            {
                var disDal = new DAL.d_district_dal();
                if (accLocation.country_id != null)
                {
                    var country = new DAL.d_country_dal().FindById((long)accLocation.country_id);
                    countryName = country != null ? country.country_name_display : "";
                }
                var province = disDal.FindById((long)accLocation.province_id);
                provinceName = province != null ? province.name : "";
                var city = disDal.FindById((long)accLocation.city_id);
                cityName = city != null ? city.name : "";
                var district = disDal.FindById((long)accLocation.district_id);
                districtName = district != null ? district.name : "";

            }
            if (account.resource_id != null)
                accMan = new DAL.sys_resource_dal().FindNoDeleteById((long)account.resource_id);
            startDate = DateTime.Parse(DateTime.Now.AddMonths(-1).ToString("yyyy-MM") + "-01");
            endDate = startDate.AddMonths(1).AddDays(-1);

            contractMoney = new DAL.crm_account_deduction_dal().GetContractSum(account.id,startDate,endDate);
            projectMoney = new DAL.crm_account_deduction_dal().GetProjectSum(account.id, startDate, endDate);
            if (account.classification_id != null)
                accClass = new DAL.d_account_classification_dal().FindNoDeleteById((long)account.classification_id);

        }
   
    }
}