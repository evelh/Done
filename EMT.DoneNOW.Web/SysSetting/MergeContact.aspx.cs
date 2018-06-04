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
    public partial class MergeContact : BasePage
    {
        protected CompanyBLL accBll = new CompanyBLL();
        protected ContactBLL conBll = new ContactBLL();
        protected crm_contact fromContact;
        protected crm_contact toContact;
        protected crm_account account;
        protected bool isDel = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            long fromConId = 0; long toConId = 0;long accountId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["fromConId"]))
                if (long.TryParse(Request.QueryString["fromConId"], out fromConId))
                    fromContact = conBll.GetContact(fromConId);
            if (!string.IsNullOrEmpty(Request.QueryString["toConId"]))
                if (long.TryParse(Request.QueryString["toConId"], out toConId))
                    toContact = conBll.GetContact(toConId);
            if (!string.IsNullOrEmpty(Request.QueryString["isDel"]) && Request.QueryString["isDel"] == "1")
                isDel = true;
            if (!string.IsNullOrEmpty(Request.QueryString["accountId"]))
                if (long.TryParse(Request.QueryString["accountId"], out accountId))
                    account = accBll.GetCompany(accountId);

            if (fromContact != null)
                liLeft.Text = GetDetailByContact(fromContact.id);
            if (toContact != null)
                liRight.Text = GetDetailByContact(toContact.id);


        }

        protected string GetDetailByContact(long conId)
        {
            StringBuilder html = new StringBuilder();
            crm_contact thisContact = conBll.GetContact(conId);
            if (thisContact == null)
                return "";
           
            html.Append("<div class='workspace'>");
     
            html.Append("<div style='padding-left: 10px;'><table cellspacing='0' cellpadding='4' border='0' class='FieldLabels'><tbody>");

      //

            #region  商机信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>商机</td></tr>");
            List<crm_opportunity> oppoList = new OpportunityBLL().GetOppoBySql($"SELECT id,name from crm_opportunity where delete_time =0 and contact_id = {conId.ToString()} ");
            // and status_id not in ({(int)DicEnum.OPPORTUNITY_STATUS.LOST},{(int)DicEnum.OPPORTUNITY_STATUS.CLOSED},{(int)DicEnum.OPPORTUNITY_STATUS.IMPLEMENTED})
            if (oppoList != null && oppoList.Count > 0)
                oppoList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });
            else
                html.Append($"<tr><td class='errorSmall' align='left' style='padding-left:10px;text-align:left;font-weight :normal;'>该联系人下没有商机</td></tr>");

            #endregion

            #region  销售订单信息  销售订单没有name 使用商机name
            html.Append("<tr><td align='left' style='padding-top:20px;'>销售订单</td></tr>");
            List<crm_opportunity> saleList = accBll.GetBySql<crm_opportunity>($"SELECT s.id,p.name from crm_sales_order s INNER JOIN crm_opportunity p on s.opportunity_id = p.id where s.delete_time = 0 and p.delete_time =0 and s.contact_id = {conId.ToString()} ");
            if (saleList != null && saleList.Count > 0)
                saleList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });
            else
                html.Append($"<tr><td class='errorSmall' align='left' style='padding-left:10px;text-align:left;font-weight :normal;'>该联系人下没有销售订单</td></tr>");

            #endregion


            #region  待办信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>待办</td></tr>");
            List<com_activity> todoList = new ActivityBLL().GetToListBySql($"select id,name,description from com_activity where delete_time =0 and cate_id = {(int)DicEnum.ACTIVITY_CATE.TODO} and contact_id = {conId.ToString()} and (status_id <> {(int)DicEnum.ACTIVITY_STATUS.COMPLETED} or status_id is null)");
            if (todoList != null && todoList.Count > 0)
                todoList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.description}</td></tr>");
                });
            else
                html.Append($"<tr><td class='errorSmall' align='left' style='padding-left:10px;text-align:left;font-weight :normal;'>该联系人下没有待办</td></tr>");
            #endregion

            #region  活动信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>活动</td></tr>");
            List<com_activity> actList = new ActivityBLL().GetToListBySql($"select id,name,description from com_activity where delete_time =0 and cate_id <> {(int)DicEnum.ACTIVITY_CATE.TODO} and contact_id = {conId.ToString()} and (status_id <> {(int)DicEnum.ACTIVITY_STATUS.COMPLETED} or status_id is null)");

            if (actList != null && actList.Count > 0)
                actList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.description}</td></tr>");
                });
            else
                html.Append($"<tr><td class='errorSmall' align='left' style='padding-left:10px;text-align:left;font-weight :normal;'>该联系人下没有活动</td></tr>");

            #endregion



            #region 工单信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>工单</td></tr>");
            List<sdk_task> ticketList = accBll.GetBySql<sdk_task>($"SELECT id from sdk_task where type_id = 1809 and delete_time = 0 and contact_id =  {conId.ToString()}");
            if (ticketList != null && ticketList.Count > 0)
                ticketList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.no}-{_.title}</td></tr>");
                });
            else
                html.Append($"<tr><td class='errorSmall' align='left' style='padding-left:10px;text-align:left;font-weight :normal;'>该联系人下没有工单</td></tr>");
            #endregion

            #region 调查问卷信息

            #endregion

            #region 任务信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>任务</td></tr>");
            List<sdk_task> taskList = accBll.GetBySql<sdk_task>($"SELECT t.id,t.title,p.name as description from sdk_task t INNER JOIN pro_project p where t.type_id = 1807 and t.delete_time = 0 and p.delete_time =0 and t.contact_id =   {conId.ToString()}");
            // 
            if (taskList != null && taskList.Count > 0)
                taskList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left:10px;'>项目:&nbsp;<span style='font-weight :normal;'>{_.description}</span> <br>&nbsp; &nbsp; 任务: &nbsp;< span style='font-weight :normal;'>{_.title}</span></td></tr>");
                });
            else
                html.Append($"<tr><td class='errorSmall' align='left' style='padding-left:10px;text-align:left;font-weight :normal;'>该联系人下没有任务</td></tr>");

            #endregion

            #region 联系人群组信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>联系人群组</td></tr>");
            List<crm_contact_group> groupList = accBll.GetBySql<crm_contact_group>($"SELECT ccg.* from crm_contact_group ccg INNER JOIN crm_contact_group_contact ccgc on ccg.id = ccgc.contact_group_id where ccg.delete_time =0 and ccgc.delete_time = 0 and ccgc.contact_id =  {conId.ToString()}");
            if (groupList != null && groupList.Count > 0)
                groupList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });
            else
                html.Append($"<tr><td class='errorSmall' align='left' style='padding-left:10px;text-align:left;font-weight :normal;'>该联系人下没有联系人群组</td></tr>");

            #endregion

            #region 合同信息
            html.Append("<tr><td align='left' style='padding-top:20px;'>合同</td></tr>");
            List<ctt_contract> contractList = accBll.GetBySql<ctt_contract>($"SELECT id, name from ctt_contract where delete_time = 0 and contact_id = { conId.ToString()}");
            if (contractList != null && contractList.Count > 0)
                contractList.ForEach(_ =>
                {
                    html.Append($"<tr><td style='padding-left: 10px; font-weight:normal;'>{_.name}</td></tr>");
                });
            else
                html.Append($"<tr><td class='errorSmall' align='left' style='padding-left:10px;text-align:left;font-weight :normal;'>该联系人下没有合同</td></tr>");
            #endregion

            html.Append("</tbody></table></div>");
            html.Append("</div>");

            return html.ToString();
        }

        protected void Merge_Click(object sender, EventArgs e)
        {
            long fromConId = 0; long toConId = 0;
            bool result = false;
            if (!string.IsNullOrEmpty(Request.Form["fromConId"]) && !string.IsNullOrEmpty(Request.Form["toConId"]))
                if (long.TryParse(Request.Form["fromConId"], out fromConId) && long.TryParse(Request.Form["toConId"], out toConId))
                    result = conBll.MergeContact(fromConId, toConId, LoginUserId, !string.IsNullOrEmpty(Request.Form["ckDel"]) && Request.Form["ckDel"] == "on");
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');</script>");
            if (result)
                ClientScript.RegisterStartupScript(this.GetType(), "页面重载", $"<script>location.href='../SysSetting/MergeContact?fromConId={fromConId.ToString()}&toConId={toConId.ToString()}';</script>");
        }
    }
}