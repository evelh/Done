using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Company
{
    public partial class CompanyReport : BasePage
    {
        protected crm_account account;
        protected crm_location accLocation;
        protected CompanyBLL comBll = new CompanyBLL();
        protected OpportunityBLL oppoBll = new OpportunityBLL();
        protected UserDefinedFieldsBLL udfBLL = new UserDefinedFieldsBLL();
        protected d_general_dal genDal = new d_general_dal();
        protected ivt_product_dal ipDal = new ivt_product_dal();
        protected List<crm_account> subAccountList ;
        protected List<crm_contact> contactList;
        protected List<crm_opportunity> oppoList;
        protected List<UserDefinedFieldDto> companyUdfList;
        protected List<UserDefinedFieldValue> companyUdfValueList;
        protected List<UserDefinedFieldDto> oppoUdfList;
        protected List<crm_installed_product> insProList;
        protected List<com_activity> todoList;
        protected List<com_activity> noteList;
        protected string countryName;
        protected string provinceName;
        protected string cityName;
        protected string districtName;
        protected List<d_general> oppoStaList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_STATUS);
        protected List<d_general> actTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.ACTION_TYPE);
        protected List<d_general> oppoSourceList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_SOURCE);
        protected List<d_general> oppoStageList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_STAGE);
        protected List<sys_resource> resList = new DAL.sys_resource_dal().FindAll().ToList();
        protected List<ivt_product> produList = new ivt_product_dal().GetProList();
        protected void Page_Load(object sender, EventArgs e)
        {
            var accountId = Request.QueryString["accountId"];
            if (!string.IsNullOrEmpty(accountId))
                account = comBll.GetCompany(long.Parse(accountId));
            if (account == null)
            {
                Response.Write("<script>alert('为获取到客户信息');window.close();</script>");
                return;
            }
            accLocation = new crm_location_dal().GetLocationByAccountId(account.id);
            if (accLocation != null)
            {
                var disDal = new d_district_dal();
                if (accLocation.country_id != null)
                {
                    var country = new DAL.d_country_dal().FindById((long)accLocation.country_id);
                    countryName = country!=null?country.country_name_display:"";
                }
                var province = disDal.FindById((long)accLocation.province_id);
                provinceName = province != null ? province.name : "";
                var city = disDal.FindById((long)accLocation.city_id);
                cityName = city != null ? city.name : "";
                var district = disDal.FindById((long)accLocation.district_id);
                districtName = district != null ? district.name : "";

            }
            subAccountList = new crm_account_dal().GetSubsidiariesById(account.id);
            contactList = new crm_contact_dal().GetContactByAccountId(account.id);
            oppoList = new crm_opportunity_dal().FindOpHistoryByAccountId(account.id);
            companyUdfList = udfBLL.GetUdf(DicEnum.UDF_CATE.COMPANY);
            companyUdfValueList = udfBLL.GetUdfValue(DicEnum.UDF_CATE.COMPANY, account.id, companyUdfList);
            insProList = new crm_installed_product_dal().GetInsProAccoByProName(account.id);
            todoList = new com_activity_dal().GetNoCompleteTodo(account.id);
            noteList = new com_activity_dal().GetNoteByAccount(account.id);
            oppoUdfList = udfBLL.GetUdf(DicEnum.UDF_CATE.OPPORTUNITY);


            //var arr = new string[][] { new string[] { "上海", "张耀", "1" }, new string[] { "北京", "张耀", "1" }, new string[] { "上海", "朱飞", "1" } };
            //var test = from i in Enumerable.Range(0, (int)arr.GetLongLength(0))
            //           from j in Enumerable.Range(0, (int)arr.GetLongLength(1))
            //           from k in Enumerable.Range(0, (int)arr.GetLongLength(2))
            //           select arr[i,j,k];

        }
    }
}