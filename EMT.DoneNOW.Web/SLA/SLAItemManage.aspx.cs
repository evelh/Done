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
    public partial class SLAItemManage :BasePage
    {
        protected d_sla sla;
        protected d_sla_item slaItem;
        protected bool isAdd = true;
        protected SLABLL bll = new SLABLL();
        
        protected List<d_general> priorityList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_PRIORITY_TYPE);    // 工单优先级集合
        protected List<d_general> issueTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_ISSUE_TYPE);      // 工单问题类型
        protected List<d_general> ticketCateList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_CATE);         // 工单种类
        protected List<d_general> ticketTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_TYPE);         // 工单类型
        protected List<d_general> timeframeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.SLA_TIMEFRAME);        // 计时方法
        protected List<d_general> targetTypeList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.SLA_TARGET_TYPE);     // 完成时间的默认类型
        
        protected void Page_Load(object sender, EventArgs e)
        {
            long slaId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["slaId"]) && long.TryParse(Request.QueryString["slaId"], out slaId))
                sla = bll.GetSlaById(slaId);
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                slaItem = bll.GetSLAItemById(id);
            if (slaItem != null)
            {
                sla = bll.GetSlaById(slaItem.sla_id);
                isAdd = false;
            }

            if (sla == null)
            {
                Response.Write("<script>alert('未获取到相关SLA信息');window.close();</script>");
            }
            
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var pageItem = AssembleModel<d_sla_item>();
            pageItem.sla_id = sla.id;

            if (!string.IsNullOrEmpty(Request.Form["isActive"]) && Request.Form["isActive"] == "on")
                pageItem.is_active = 1;
            else
                pageItem.is_active = 0;
            if (!string.IsNullOrEmpty(Request.Form["firstResponse"]))
                pageItem.first_response_target_type_id = int.Parse(Request.Form["firstResponse"]);
            else
                pageItem.first_response_target_type_id = (int)DicEnum.SLA_TARGET_TYPE.BY_TIME;
            if (!string.IsNullOrEmpty(Request.Form[pageItem.first_response_target_type_id.ToString() + "_firstResponse_value"]))
                pageItem.first_response_target_hours = decimal.Parse(Request.Form[pageItem.first_response_target_type_id.ToString() + "_firstResponse_value"]);

            if (!string.IsNullOrEmpty(Request.Form["resoluPlan"]))
                pageItem.resolution_plan_target_type_id = int.Parse(Request.Form["resoluPlan"]);
            else
                pageItem.resolution_plan_target_type_id = (int)DicEnum.SLA_TARGET_TYPE.BY_TIME;
            if (!string.IsNullOrEmpty(Request.Form[pageItem.resolution_plan_target_type_id.ToString() + "_resoluPlan_value"]))
                pageItem.resolution_plan_target_hours = decimal.Parse(Request.Form[pageItem.resolution_plan_target_type_id.ToString() + "_resoluPlan_value"]);

            if (!string.IsNullOrEmpty(Request.Form["resolution"]))
                pageItem.resolution_target_type_id = int.Parse(Request.Form["resolution"]);
            else
                pageItem.resolution_target_type_id = (int)DicEnum.SLA_TARGET_TYPE.BY_TIME;
            if (!string.IsNullOrEmpty(Request.Form[pageItem.resolution_target_type_id.ToString() + "_resolution_value"]))
                pageItem.resolution_target_hours = decimal.Parse(Request.Form[pageItem.resolution_target_type_id.ToString() + "_resolution_value"]);


            if (!isAdd)
            {
                slaItem.priority_id = pageItem.priority_id;
                slaItem.issue_type_id = pageItem.issue_type_id;
                slaItem.sub_issue_type_id = pageItem.sub_issue_type_id;
                slaItem.ticket_cate_id = pageItem.ticket_cate_id;
                slaItem.ticket_type_id = pageItem.ticket_type_id;
                slaItem.sla_timeframe_id = pageItem.sla_timeframe_id;
                slaItem.is_active = pageItem.is_active;
                slaItem.first_response_target_type_id = pageItem.first_response_target_type_id;
                slaItem.resolution_plan_target_type_id = pageItem.resolution_plan_target_type_id;
                slaItem.resolution_target_type_id = pageItem.resolution_target_type_id;

                slaItem.first_response_target_hours = pageItem.first_response_target_hours;
                slaItem.resolution_plan_target_hours = pageItem.resolution_plan_target_hours;
                slaItem.resolution_target_hours = pageItem.resolution_target_hours;
            }

            bool result = false;
            if (isAdd)
                result = bll.AddItem(pageItem, LoginUserId);
            else
                result = bll.EditItem(slaItem, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');window.close();</script>");


        }
    }
}