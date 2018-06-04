using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System.Text;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class MergeAccount :BasePage
    {
        protected UserResourceBLL userBll = new UserResourceBLL();
        protected CompanyBLL accBll = new CompanyBLL();
        protected crm_account fromAccount;
        protected crm_account toAccount;
        protected bool isDel = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            long fromAccId = 0; long toAccId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["fromAccId"]))
                if (long.TryParse(Request.QueryString["fromAccId"], out fromAccId))
                    fromAccount = accBll.GetCompany(fromAccId);
            if (!string.IsNullOrEmpty(Request.QueryString["toAccId"]))
                if (long.TryParse(Request.QueryString["toAccId"], out toAccId))
                    toAccount = accBll.GetCompany(toAccId);
            if (!string.IsNullOrEmpty(Request.QueryString["isDel"]) && Request.QueryString["isDel"] == "1")
                isDel = true;

            if (fromAccount != null)
                liLeft.Text = GetDetailByAccount(fromAccount.id);
            if (toAccount != null)
                liRight.Text = GetDetailByAccount(toAccount.id);
        }

        protected void Merge_Click(object sender, EventArgs e)
        {
            long fromAccId = 0; long toAccId = 0;
            bool result = false;
            if (!string.IsNullOrEmpty(Request.Form["fromAccId"]) && !string.IsNullOrEmpty(Request.Form["toAccId"]))
                if (long.TryParse(Request.Form["fromAccId"], out fromAccId) && long.TryParse(Request.Form["toAccId"], out toAccId))
                    result = accBll.MergeAccount(fromAccId,toAccId,LoginUserId,!string.IsNullOrEmpty(Request.Form["ckDel"])&& Request.Form["ckDel"] =="on");
           
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');</script>");
            
            if(result)
                ClientScript.RegisterStartupScript(this.GetType(), "页面重载", $"<script>location.href='../SysSetting/MergeAccount?fromAccId={fromAccId.ToString()}&toAccId={toAccId.ToString()}';</script>");
            
        }

        protected string GetDetailByAccount(long accId)
        {
            StringBuilder html = new StringBuilder();
            crm_account thisAccount = accBll.GetCompany(accId);
            if (thisAccount == null)
                return "";
            // 
            html.Append("<div class='workspace'>");
            #region  客户信息-地址信息
            html.Append($"<p align='left' style='padding-left: 10px;' class='FieldLabels'>{thisAccount.name}");
            if(!string.IsNullOrEmpty(thisAccount.phone))
                html.Append($"<span style='font-weight:normal;'> {thisAccount.phone} </span ><br />");
            else
                html.Append($"<br />");

            var location = new LocationBLL().GetLocationByAccountId(accId);
            if (location != null)
            {
                if (!string.IsNullOrEmpty(location.address))
                    html.Append($"<span style='font-weight:normal;'>{location.address} </span ><br />");
                if (!string.IsNullOrEmpty(location.additional_address))
                    html.Append($"<span style='font-weight:normal;'>{location.additional_address} </span ><br />");
                var ddDal = new DAL.d_district_dal();
                var thisPro = ddDal.FindById(location.province_id);
                if(thisPro!=null)
                    html.Append($"<span style='font-weight:normal;'>{thisPro.name} </span >&nbsp;&nbsp;");
                var thisCity = ddDal.FindById(location.city_id);
                if (thisCity != null)
                    html.Append($"<span style='font-weight:normal;'>{thisCity.name} </span >&nbsp;&nbsp;");
                if (location.district_id != null)
                {
                    var thisDis = ddDal.FindById((long)location.district_id);
                    if (thisDis != null)
                        html.Append($"<span style='font-weight:normal;'>{thisDis.name} </span ><br />");
                }
                if (location.country_id != null)
                {
                    var thisCoun = new DAL.d_country_dal().FindById((long)location.country_id);
                    if (thisCoun != null)
                        html.Append($"<span style='font-weight:normal;'>{thisCoun.country_name_display} </span ><br />");
                }
                
            }
            html.Append("</p>");
            #endregion
            html.Append("<div style='padding-left: 10px;'><table cellspacing='0' cellpadding='4' border='0' class='FieldLabels'><tbody>");

            #region  联系人信息
            html.Append("<tr><td align='left'>客户</td></tr>");
            List<crm_contact> contactList = new ContactBLL().GetContactByCompany(accId);
            if (contactList != null && contactList.Count > 0)
                contactList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}-手机号 : &nbsp; {_.phone}</td></tr>");
                });
            #endregion

            #region  商机信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>商机</td></tr>");
            List<crm_opportunity> oppoList = new OpportunityBLL().GetOppoBySql($"SELECT id,name from crm_opportunity where delete_time =0 and account_id = {accId.ToString()} ");
            // and status_id not in ({(int)DicEnum.OPPORTUNITY_STATUS.LOST},{(int)DicEnum.OPPORTUNITY_STATUS.CLOSED},{(int)DicEnum.OPPORTUNITY_STATUS.IMPLEMENTED})
            if (oppoList != null && oppoList.Count > 0)
                oppoList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });

            #endregion

            #region  销售订单信息  销售订单没有name 使用商机name
            html.Append("<tr><td align='left' style='padding-top:20px;'>销售订单</td></tr>");
            List<crm_opportunity> saleList = accBll.GetBySql<crm_opportunity>($"SELECT s.id,p.name from crm_sales_order s INNER JOIN crm_opportunity p on s.opportunity_id = p.id where s.delete_time = 0 and p.delete_time =0 and p.account_id = {accId.ToString()} ");
            if (saleList != null && saleList.Count > 0)
                saleList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });

            #endregion


            #region  采购订单信息  
            html.Append("<tr><td align='left' style='padding-top:20px;'>采购订单</td></tr>");
            List<ivt_order> orderList = accBll.GetBySql<ivt_order>($"SELECT v.id from ivt_order v where v.delete_time = 0 and v.vendor_account_id = {accId.ToString()} ");
            html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>这个客户有{(orderList!=null? orderList.Count:0)}个采购订单</td></tr>");
            #endregion

            #region  待办信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>待办</td></tr>");
            List<com_activity> todoList = new ActivityBLL().GetToListBySql($"select id,name,description from com_activity where delete_time =0 and cate_id = {(int)DicEnum.ACTIVITY_CATE.TODO} and account_id = {accId.ToString()} and (status_id <> {(int)DicEnum.ACTIVITY_STATUS.COMPLETED} or status_id is null)");
            if (todoList != null && todoList.Count > 0)
                todoList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.description}</td></tr>");
                });
            #endregion

            #region  活动信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>活动</td></tr>");
            List<com_activity> actList = new ActivityBLL().GetToListBySql($"select id,name,description from com_activity where delete_time =0 and cate_id <> {(int)DicEnum.ACTIVITY_CATE.TODO} and account_id = {accId.ToString()} and (status_id <> {(int)DicEnum.ACTIVITY_STATUS.COMPLETED} or status_id is null)");
         
             html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>这个客户有{(actList != null ? actList.Count : 0)}个活动</td></tr>");

            #endregion

            #region  配置项信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>配置项</td></tr>");
            List<ivt_product> insProList = accBll.GetBySql<ivt_product>($"SELECT i.id,p.name from crm_installed_product i INNER JOIN ivt_product p on i.product_id = p.id and i.delete_time =0 and p.delete_time =0 and i.account_id = {accId.ToString()}");
            if (insProList != null && insProList.Count > 0)
                insProList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });
            #endregion

            #region 项目信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>项目</td></tr>");
            List<pro_project> proList = accBll.GetBySql<pro_project>($"SELECT id,name from pro_project where delete_time= 0 and account_id =  {accId.ToString()}");
            if (proList != null && proList.Count > 0)
                proList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });
            #endregion

            #region 费用信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>费用</td></tr>");
            List<sdk_expense> expList = accBll.GetBySql<sdk_expense>($"SELECT id from sdk_expense where delete_time= 0 and account_id =  {accId.ToString()}");
            html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>这个客户有{(expList != null ? expList.Count : 0)}个费用</td></tr>");
            #endregion

            #region 工单信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>工单</td></tr>");
            List<sdk_task> ticketList = accBll.GetBySql<sdk_task>($"SELECT id from sdk_task where type_id = 1809 and delete_time = 0 and account_id =  {accId.ToString()}");
            html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>这个客户有{(ticketList != null ? ticketList.Count : 0)}个工单</td></tr>");
            #endregion

            #region 调查问卷信息

            #endregion

            #region 任务或工单备注信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>任务或工单备注</td></tr>");
            List<sdk_task> taskList = accBll.GetBySql<sdk_task>($"SELECT id from sdk_task where type_id = 1807 and delete_time = 0 and account_id =  {accId.ToString()}");
            List<com_activity> taskNoteList = accBll.GetBySql<com_activity>($"SELECT * from com_activity where delete_time =0 and cate_id = 1500 and account_id = {accId.ToString()}");

            html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>这个客户有{((taskList != null ? taskList.Count : 0)+(taskNoteList != null ? taskNoteList.Count : 0))}个任务或工单备注</td></tr>");

            #endregion

            #region 备注信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>备注</td></tr>");
            List<com_activity> noteList = accBll.GetBySql<com_activity>($"SELECT * from com_activity where delete_time =0 and cate_id = 31 and account_id = {accId.ToString()}");
            if (noteList != null && noteList.Count > 0)
                noteList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });

            #endregion
            
            #region 合同信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>合同</td></tr>");
            List<ctt_contract> contractList = accBll.GetBySql<ctt_contract>($"SELECT id, name from ctt_contract where delete_time = 0 and account_id = { accId.ToString()}");
            if (contractList != null && contractList.Count > 0)
                contractList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });
            #endregion

            #region 附件信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>附件</td></tr>");
            List<com_attachment> attList = accBll.GetBySql<com_attachment>($"SELECT id from com_attachment where delete_time =0 and account_id = { accId.ToString()}");
            html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>这个客户有{(attList != null ? attList.Count : 0)}个附件</td></tr>");
            #endregion

            #region 服务信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>服务</td></tr>");
            List<ivt_service> serviceList = accBll.GetBySql<ivt_service>($"SELECT id,name from ivt_service where delete_time = 0 and vendor_account_id = { accId.ToString()}");
            if (serviceList != null && serviceList.Count > 0)
                serviceList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });
            #endregion
            

            html.Append("</tbody></table></div>");
            html.Append("</div>");

            return html.ToString();
        }
    }
}