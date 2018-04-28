using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.Opportunity
{
    public partial class LoseOpportunity : BasePage
    {
        protected crm_opportunity opportunity = null;
        protected crm_account account = null;
        protected sys_system_setting lostSetting = new SysSettingBLL().GetSetById(SysSettingEnum.CRM_OPPORTUNITY_LOSS_REASON);
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var dic = new OpportunityBLL().GetField();
                #region 下拉框赋值
                stage_id.DataTextField = "show";
                stage_id.DataValueField = "val";
                stage_id.DataSource = dic.FirstOrDefault(_ => _.Key == "opportunity_stage").Value;
                stage_id.DataBind();


                resource_id.DataTextField = "show";
                resource_id.DataValueField = "val";
                resource_id.DataSource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value;
                resource_id.DataBind();


                //opportunity_id.DataTextField = "name";
                //opportunity_id.DataValueField = "id";
                //opportunity_id.DataSource = new crm_opportunity_dal().FindOpHistoryByAccountId(opportunity.account_id);
                //opportunity_id.DataBind();

                loss_reason_type_id.DataTextField = "show";
                loss_reason_type_id.DataValueField = "val";
                loss_reason_type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "oppportunity_loss_reason_type").Value;
                loss_reason_type_id.DataBind();
                loss_reason_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                // competition  competitor_id
                competitor_id.DataTextField = "show";
                competitor_id.DataValueField = "val";
                competitor_id.DataSource = dic.FirstOrDefault(_ => _.Key == "competition").Value;
                competitor_id.DataBind();
                competitor_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                #endregion

                var account_id = Request.QueryString["account_id"];

                var opportunityId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(opportunityId))
                {
                    if (string.IsNullOrEmpty(account_id))
                    {
                        if (!IsPostBack)
                        {
                            opportunity_id.Enabled = false;
                        }
                    }
                    opportunity = new crm_opportunity_dal().GetOpportunityById(long.Parse(opportunityId));
                    if (opportunity != null)
                    {
                        account = new CompanyBLL().GetCompany(opportunity.account_id);
                        account_id = account.id.ToString();
                    }
                }
                if (!string.IsNullOrEmpty(account_id))
                {
                    account = new CompanyBLL().GetCompany(long.Parse(account_id));
                    var oppoList = new crm_opportunity_dal().FindOpHistoryByAccountId(long.Parse(account_id));
                    if (oppoList != null && oppoList.Count > 0)
                    {
                        opportunity_id.DataTextField = "name";
                        opportunity_id.DataValueField = "id";
                        opportunity_id.DataSource = oppoList;
                        opportunity_id.DataBind();
                    }
                    else
                    {
                        Response.Write("<script>alert('该客户还没有商机！');window.close();</script>");
                    }
                    if (string.IsNullOrEmpty(opportunityId))
                    {
                        opportunity = oppoList[0];
                    }
                    opportunity_id.SelectedValue = opportunity.id.ToString();
                }
                if (opportunity == null)
                    Response.End();
                // 商机已经关闭，丢失提示信息
                if (!IsPostBack)
                {
                    if (opportunity.status_id == (int)OPPORTUNITY_STATUS.CLOSED)
                    {
                        Response.Write("<script>alert('商机已关闭，继续则以前创建的已确认计费项和合同不会受影响！');</script>");
                        Response.Write("<script>if(!confirm('本操作将会改变商机状态，相关的销售订单将被取消，是否继续？')){window.close();}</script>");
                    }
                }
         

                stage_id.SelectedValue = opportunity.stage_id == null ? "0" : opportunity.stage_id.ToString();
                resource_id.SelectedValue = opportunity.resource_id.ToString();
                opportunity_id.SelectedValue = opportunity.id.ToString();
                competitor_id.SelectedValue = opportunity.competitor_id == null ? "0" : opportunity.competitor_id.ToString();





            }
            catch (Exception)
            {
                Response.End();
            }
        }

        protected void finish_Click(object sender, EventArgs e)
        {
            var thisOppo = AssembleModel<crm_opportunity>();
            opportunity.stage_id = thisOppo.stage_id;
            opportunity.resource_id = thisOppo.resource_id;
            opportunity.primary_product_id = thisOppo.primary_product_id;
            opportunity.competitor_id = thisOppo.competitor_id;
            opportunity.loss_reason_type_id = thisOppo.loss_reason_type_id;
            opportunity.loss_reason = thisOppo.loss_reason;
            var actual_closed_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (!string.IsNullOrEmpty(Request.Form["lostTime"]))
                opportunity.actual_closed_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(Request.Form["lostTime"]));
            //else
            //    opportunity.actual_closed_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

            // opportunity.resource_id = thisOppo.resource_id;
            // opportunity.resource_id = thisOppo.resource_id;
            LoseOpportunityDto dto = new LoseOpportunityDto()
            {
                opportunity = this.opportunity,
                notify = AssembleModel<com_notify_email>(),
                notifyTempId = !string.IsNullOrEmpty(Request.Form["notify_tmpl_id"]) ? int.Parse(Request.Form["notify_tmpl_id"]) : 0,
            };
            var result = new OpportunityBLL().LoseOpportunity(dto, GetLoginUserId());
            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>document.getElementsByClassName('Workspace1')[0].style.display = 'none';document.getElementsByClassName('Workspace4')[0].style.display = 'none';document.getElementsByClassName('Workspace5')[0].style.display = '';</script>");
                    break;
                case ERROR_CODE.ERROR:
                    break;
                case ERROR_CODE.PARAMS_ERROR:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写');</script>");
                    break;
                case ERROR_CODE.USER_NOT_FIND:
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                    break;
                default:
                    break;
            }
        }
    }
}