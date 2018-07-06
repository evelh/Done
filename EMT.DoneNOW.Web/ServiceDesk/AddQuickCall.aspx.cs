using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;


namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class AddQuickCall : BasePage
    {
        protected crm_account thisAccount = null;
        protected List<d_general> priorityList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_PRIORITY_TYPE);   // 工单优先级集合
        protected List<d_general> issueTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_ISSUE_TYPE);     // 工单问题类型
        protected List<d_general> sourceTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_SOURCE_TYPES);     // 工单来源
        protected List<d_general> ticketCateList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_CATE);     // 工单种类
        protected List<d_general> ticketTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_TYPE);     // 工单类型
        protected List<sys_department> depList = new sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE);
        protected List<d_cost_code> codeList = new d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE);
        protected List<UserDefinedFieldDto> tickUdfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
        protected List<UserDefinedFieldValue> ticketUdfValueList = null;
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList();
        protected List<sys_form_tmpl> tmplList;
        protected void Page_Load(object sender, EventArgs e)
        {
            tmplList = new FormTemplateBLL().GetTmplByType((int)DicEnum.FORM_TMPL_TYPE.QUICK_CALL, LoginUserId);
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            if (param == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "错误提示", $"<script>alert('必填参数丢失');</script>");
                return;
            }
            var result = new DispatchBLL().AddQuickCall(param, LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');window.close();</script>");
        }

        protected void save_add_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            if (param == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "错误提示", $"<script>alert('必填参数丢失');</script>");
                return;
            }
            var result = new DispatchBLL().AddQuickCall(param, LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');location.href='../ServiceDesk/TicketView.aspx?id={param.thisTicket.id.ToString()}';</script>");
        }

        private ServiceCallDto GetParam()
        {
            var param = new ServiceCallDto();
            var pageTicket = AssembleModel<sdk_task>();
            var startTime = Request.Form["startTime"];
            var endTime = Request.Form["endTime"];
            if (string.IsNullOrEmpty(startTime) || string.IsNullOrEmpty(endTime))
                return null;
            pageTicket.estimated_begin_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(startTime));
            pageTicket.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(endTime));
            param.thisTicket = pageTicket;

            var call = new sdk_service_call();
            call.start_time = (long)pageTicket.estimated_begin_time;
            call.end_time = (long)pageTicket.estimated_end_time;
            call.status_id = (int)DicEnum.SERVICE_CALL_STATUS.NEW;
            call.account_id = pageTicket.account_id;
            call.description = pageTicket.description;
            param.call = call;
            if (tickUdfList != null && tickUdfList.Count > 0)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in tickUdfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = string.IsNullOrEmpty(Request.Form[udf.id.ToString()]) ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.udfList = list;
            }
            var OtherResId = Request.Form["OtherResId"];
            if (!string.IsNullOrEmpty(OtherResId))
                param.resIds = new DispatchBLL().GetResByResDep(OtherResId);
            return param;
        }

    }
}