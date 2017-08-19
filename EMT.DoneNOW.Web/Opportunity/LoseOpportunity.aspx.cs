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
using EMT.DoneNOW.BLL.CRM;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.Opportunity
{
    public partial class LoseOpportunity : BasePage
    {
        protected crm_opportunity opportunity = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var opportunity_id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(opportunity_id))
                {
                    opportunity = new crm_opportunity_dal().GetOpportunityById(long.Parse(opportunity_id));
                    if (opportunity != null)
                    {
                        var dic = new OpportunityBLL().GetField();
                        // 商机已经关闭，丢失提示信息
                        if (opportunity.status_id == (int)OPPORTUNITY_STATUS.CLOSED)
                        {
                            Response.Write("<script>alert('商机已关闭，继续则以前创建的已确认计费项和合同不会受影响！');</script>");
                            Response.Write("<script>if(!confirm('本操作将会改变商机状态，相关的销售订单将被取消，是否继续？')){close();window.close();}</script>");
                        }
                


                        #region 下拉框赋值
                        stage_id.DataTextField = "show";
                        stage_id.DataValueField = "val";
                        stage_id.DataSource = dic.FirstOrDefault(_ => _.Key == "opportunity_stage").Value;
                        stage_id.DataBind();
                        

                        resource_id.DataTextField = "show";
                        resource_id.DataValueField = "val";
                        resource_id.DataSource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value;
                        resource_id.DataBind();
                       
                        #endregion

                        stage_id.SelectedValue = opportunity.stage_id == null ? "0" : opportunity.stage_id.ToString();
                        resource_id.SelectedValue = opportunity.resource_id.ToString();

                    }
                    else
                    {
                        Response.End();
                    }
                }

            }
            catch (Exception)
            {
                Response.End();
            }
        }

        protected void finish_Click(object sender, EventArgs e)
        {
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