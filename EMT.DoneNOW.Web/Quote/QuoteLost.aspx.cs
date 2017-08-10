using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.Tools;

namespace EMT.DoneNOW.Web.Quote
{
    public partial class QuoteLost : BasePage
    {
        protected DicEnum.SYS_CLOSE_OPPORTUNITY needReasonType;
        protected string lossReason = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            var type = new SysSettingBLL().GetValueById(SysSettingEnum.CRM_OPPORTUNITY_LOSS_REASON);
            int value = 0;
            if (!int.TryParse(type, out value))
                needReasonType = DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_NONE;
            else
                needReasonType = (DicEnum.SYS_CLOSE_OPPORTUNITY)value;

            if (needReasonType != DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_NONE)
            {
                var list = new GeneralBLL().GetDicValues(GeneralTableEnum.OPPORTUNITY_LOSS_REASON_TYPE);
                LossReasonList.DataTextField = "show";
                LossReasonList.DataValueField = "val";
                LossReasonList.DataSource = list;
                LossReasonList.DataBind();
                LossReasonList.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });
            }

            if (IsPostBack)
            {
                if (needReasonType == DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE_DETAIL)
                {
                    lossReason = DNRequest.GetQueryStringValue("LossReasonDetail", "");
                }
            }
        }

        protected void Finish_Click(object sender, EventArgs e)
        {
            long quoteId = DNRequest.GetQueryLong("id", 0);
            if (quoteId == 0)
            {
                Response.Write("<script>alert('请求错误！');window.close();</script>");
                return;
            }

            int reasonType = 0;
            lossReason = DNRequest.GetFormString("LossReasonDetail");
            if (needReasonType != DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_NONE)
            {
                if (DNRequest.GetFormString("LossReasonList") == "")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('请选择丢失商机原因！');</script>");
                    return;
                }
                int.TryParse(DNRequest.GetFormString("LossReasonList"), out reasonType);
            }
            if (needReasonType == DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE_DETAIL)
            {
                if (lossReason == "")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('请输入丢失商机原因详情！');</script>");
                    return;
                }
            }

            var rslt = new QuoteBLL().LossQuote(GetLoginUserId(), quoteId, reasonType, lossReason);
            if (!string.IsNullOrEmpty(rslt))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('{rslt}');</script>");
                return;
            }
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
    }
}