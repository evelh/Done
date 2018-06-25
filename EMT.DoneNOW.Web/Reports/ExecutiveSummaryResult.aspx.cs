using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using System.Text;
using System.Data;

namespace EMT.DoneNOW.Web.Reports
{
    public partial class ExecutiveSummaryResult : System.Web.UI.Page
    {
        protected CompanyBLL comBll = new CompanyBLL();
        protected UserResourceBLL userBll = new UserResourceBLL();
        protected DateTime startDate = DateTime.Now.AddMonths(-1);
        protected DateTime endDate = DateTime.Now;
        protected bool ContractByName = true;
        protected List<crm_account> accList;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["startDate"]))
                 DateTime.TryParse(Request.QueryString["startDate"],out startDate);
            if (!string.IsNullOrEmpty(Request.QueryString["endDate"]))
                DateTime.TryParse(Request.QueryString["endDate"], out endDate);
            if (!string.IsNullOrEmpty(Request.QueryString["displayType"]))
                ContractByName = false;

            var accountIds = Request.QueryString["accountIds"];
            if (!string.IsNullOrEmpty(accountIds))
            {
                accList = comBll.GetAccList(accountIds);
                if(accList!=null&& accList.Count > 0)
                {
                    if (!string.IsNullOrEmpty(Request.QueryString["searchResId"]))
                        accList = accList.Where(_ => _.resource_id.ToString() == Request.QueryString["searchResId"]).ToList();
                    if (!string.IsNullOrEmpty(Request.QueryString["searchTerrId"]))
                        accList = accList.Where(_ => _.territory_id.ToString() == Request.QueryString["searchTerrId"]).ToList();
                    
                }
            }
            if(accList!=null&& accList.Count > 0)
            {
                try
                {
                    liHtml.Text = GetHtml(accList);
                }
                catch (Exception msg)
                {
                    liHtml.Text ="发生系统错误，请重试！"+msg.Message;
                }
                
            }
            //else
            //{
            //    Response.Write("<script>alert('');window.close();</script>");
            //}
        }

        string GetHtml(List<crm_account> accountList)
        {
            StringBuilder htmlText = new StringBuilder();
            foreach (var account in accountList)
            {
                htmlText.Append($"<div style='margin-left: calc(50 % -300px); margin-top:20px;margin-bottom:200px;'>");

                htmlText.Append($"<table cellspacing='0' cellpadding='0' style='width: 600px;'><tr><td style='font-weight:600;'>{account.name}<br />");
                crm_location accLocation = new DAL.crm_location_dal().GetLocationByAccountId(account.id);
                if (accLocation != null)
                {
                    var disDal = new DAL.d_district_dal();
                    d_country country = null;
                    if (accLocation.country_id != null)
                        country = new DAL.d_country_dal().FindById((long)accLocation.country_id);
                    var province = disDal.FindById((long)accLocation.province_id);
                    var city = disDal.FindById((long)accLocation.city_id);
                    var district = disDal.FindById((long)accLocation.district_id);
                    htmlText.Append($"{country?.country_name_display}  {province?.name}  {city?.name}  {district?.name}");
                    htmlText.Append($"<br />{accLocation.address}  {accLocation.additional_address}");
                }
                htmlText.Append($"</td><td rowspan='3' style='text-align:center; vertical-align: middle;width:40 %;min-width:240px;'>");
                if (account.classification_id != null)
                {
                    var accClass = new DAL.d_account_classification_dal().FindNoDeleteById((long)account.classification_id);
                    htmlText.Append($"<img src='..{accClass?.icon_path}' />");
                }
                htmlText.Append("</td></tr>");
                sys_resource accMan = null;
                if (account.resource_id != null)
                    accMan = userBll.GetResourceById((long)account.resource_id);
                htmlText.Append($"<tr><td>{accMan?.name}<br /><br />{accMan.home_phone}</td></tr> ");
                htmlText.Append($"<tr><td>报表周期<br /><br />{startDate.ToString("yyyy-MM-dd")} - {endDate.ToString("yyyy-MM-dd")}</td></tr> ");

                #region 合同，项目 表格查询

                string contractSql = $@"select ifnull(contract_name,'汇总'),sum(dollars) from 
(select ifnull(contract_name, ' 无合同')contract_name, dollars, posted_date, account_id, account_manager_id, territory_id, contract_type_id
from v_posted_all a)t
where posted_date between '{startDate.ToString("yyyy-MM-dd")}' and '{endDate.ToString("yyyy-MM-dd")}' and account_id = {account.id.ToString()}
GROUP BY contract_name with ROLLUP
";
                if (!ContractByName)
                {
                    contractSql = $@"select ifnull(contract_type_name,'汇总'),sum(dollars) from 
(select dollars,posted_date,account_id,account_manager_id,territory_id,contract_type_id ,
ifnull((select name from d_general where id=a.contract_type_id),' 无合同')contract_type_name
from  v_posted_all a)t 
where posted_date between '{startDate.ToString("yyyy-MM-dd")}' and '{endDate.ToString("yyyy-MM-dd")}' and account_id={account.id.ToString()} 
GROUP BY contract_type_name with ROLLUP
";
                }
                htmlText.Append($"<tr><td colspan='2'><div style='width:100%;height:100%;'><br /><span class='Boild' style='font-size:11pt;'>财务回顾</span><br /><div style='padding-left:20px;'><br />");

                htmlText.Append($"<span class='Boild'>合同</span><div style='margin-right:20px;'><table  cellspacing ='0' cellpadding = '0' style = 'width:100%;' class='NoBoard'>");

                var contractTable = comBll.GetTable(contractSql);
                if(contractTable!=null&& contractTable.Rows.Count > 0)
                {
                    foreach (DataRow item in contractTable.Rows)
                    {
                        htmlText.Append($"<tr><td style='text-align:left;padding-left:10px;'>{item[0]}</td><td style ='text-align:right;' > {item[1]} </td></tr>");
                    }
                }
                htmlText.Append(" </table></div><br /><br /><br /><br />");
                htmlText.Append($"<span class='Boild'>项目</span><div style='margin-right:20px;'><table  cellspacing ='0' cellpadding = '0' style = 'width:100%;' class='NoBoard'>");
                var projectTable = comBll.GetTable($@"select ifnull(project_name,'汇总'),sum(dollars) from v_posted_all where posted_date between '{startDate.ToString("yyyy-MM-dd")}' and '{endDate.ToString("yyyy-MM-dd")}' and account_id={account.id.ToString()} and project_name is not null
GROUP BY project_name with ROLLUP
");
                if (projectTable != null && projectTable.Rows.Count > 0)
                {
                    foreach (DataRow item in projectTable.Rows)
                    {
                        htmlText.Append($"<tr><td style='text-align:left;padding-left:10px;'>{item[0]}</td><td style ='text-align:right;' > {item[1]} </td></tr>");
                    }
                }
                htmlText.Append($"</table></div><br /><br /></div>");
                #endregion

                #region 工单按照优先级汇总

                var priorityTicketTable = comBll.GetTable($@"select priority_type_name,count(1),round(avg(duaration_hours),2),round(avg(Business_Hours),2)
from(
select t.priority_type_id,(select name from d_general where id=t.priority_type_id)priority_type_name ,
f_get_sla_hours(null,(select id from sys_organization_location where is_default=1 and delete_time=0 limit 1),fs_unix2date(t.create_time), fs_unix2date(t.Date_Completed)  )Business_Hours,
(t.Date_Completed - t.create_time)/1000/3600 duaration_hours
from sdk_task t where type_id=1809 and status_id=1894 and recurring_ticket_id is null and  account_id={account.id.ToString()} and fs_unix2date(Date_Completed) between '{startDate.ToString("yyyy-MM-dd")}' and '{endDate.ToString("yyyy-MM-dd")}'
)t GROUP BY t.priority_type_name 
");
                if (priorityTicketTable != null && priorityTicketTable.Rows.Count > 0)
                {
                    htmlText.Append($"<span class'Boild' style='font-size:11pt;'>工单按优先级汇总</span><div style='padding: 20px;'><table cellspacing='0' cellpadding='0' style='width: 100 %; border-collapse:collapse;'>");
                    htmlText.Append("<tr><td> 优先级 </td><td>工单数</td><td>占比</td><td>平均耗时</td><td>平均耗时(工作时间)</td></tr>");
                    foreach (DataRow item in priorityTicketTable.Rows)
                    {
                        htmlText.Append($"<tr><td>{item[0]}</td><td>{item[1]}</td><td>{item[2]}</td><td>{item[3]}</td></tr>");
                    }
                    htmlText.Append($"</table></div>");
                }
                htmlText.Append($"</div></td></tr></table>");

                #endregion

                htmlText.Append("<br /><br />");

                var issuePriottyTable = comBll.GetTable($@"select Issue_Type_name ,Sub_Issue_Type_name ,sum(严重) ,sum(高) ,sum(中) ,sum(低),count(1)
from(
select Sub_Issue_Type_ID,(select name from d_general where id=Sub_Issue_Type_ID)Sub_Issue_Type_name,(select name from d_general where id=Issue_Type_ID)Issue_Type_name,
if(priority_type_id=1883,1,0)严重,if(priority_type_id=1884,1,0)高,if(priority_type_id=1885,1,0)中,if(priority_type_id=1886,1,0)低 
from sdk_task t where type_id=1809 and status_id=1894 and recurring_ticket_id is null and  account_id={account.id.ToString()} and fs_unix2date(Date_Completed) between '{startDate.ToString("yyyy-MM-dd")}' and '{endDate.ToString("yyyy-MM-dd")}'
 )t GROUP BY Issue_Type_name ,Sub_Issue_Type_name with ROLLUP
");
                if (issuePriottyTable != null && issuePriottyTable.Rows.Count > 0)
                {
                    htmlText.Append($"<span class'Boild' style='font-weight:600;'>工单按问题类型和优先级汇总</span><br /><br /><div><table cellspacing='0' cellpadding='0' style='width:600px;border-collapse:collapse'>");
                    htmlText.Append($"<tr><td>问题类型</td><td>子问题类型</td><td>严重</td><td>高</td><td>中</td><td>低</td><td>汇总</td></tr>");
                    foreach (DataRow item in issuePriottyTable.Rows)
                    {
                        htmlText.Append($"<tr><td>{item[0]}</td><td>{item[1]}</td><td>{item[2]}</td><td>{item[3]}</td><td>{item[4]}</td><td>{item[5]}</td><td>{item[6]}</td></tr>");
                    }
                    htmlText.Append($"</table></div>");
                }

                htmlText.Append($"</div>");
            }
            return htmlText.ToString();
        }
    }
}