using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class TicketModify : BasePage
    {
        protected bool isSingle;      // 判断一个还是多个工单
        protected List<sdk_task> ticketList = null;
        protected sdk_task thisTicket = null;   // 
        protected crm_account thisAccount = null;
        protected List<d_general> issueTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_ISSUE_TYPE);     // 工单问题类型
        protected List<sys_department> depList = new sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE);
        protected List<d_general> ticketCateList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_CATE);     // 工单种类
        protected List<d_general> ticStaList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_STATUS);          // 工单状态集合
        protected List<d_general> priorityList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_PRIORITY_TYPE);   // 工单优先级集合
        protected List<UserDefinedFieldDto> udfTaskPara = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
        protected List<UserDefinedFieldValue> udfValue = null;
        protected sys_resource thisUser = null;
        protected ctt_contract thisContract;
        protected d_cost_code thisWorkType;
        protected sys_resource thisPriRes;
        protected sys_role thisRole;
        protected sys_resource_department proResDep = null; // 工单的主负责人
        protected d_general sys_email = new d_general_dal().FindNoDeleteById((int)DicEnum.SUPPORT_EMAIL.SYS_EMAIL);
        protected string ticketResIds = "";
        #region 确定页面属性是否有多个值
        protected bool isManyTitle;
        protected bool isManydesc;
        protected bool isManyDep;
        protected bool isManyissType;
        protected bool isManyTicketCate;
        protected bool isManyEstHour;
        protected bool isManyDueTime;
        protected bool isManyAccount;
        protected bool isManyContract;
        protected bool isManyPri;
        protected bool isManyStatus;
        protected bool isManySerivce;
        protected bool isManyPrio;
        protected bool isManyWork;
        protected bool isManySubIssType;
        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var ticketIds = Request.QueryString["ticketIds"];
                var sdDal = new sdk_task_dal();
                if (!string.IsNullOrEmpty(ticketIds))
                    ticketList = sdDal.GetTicketByIds(ticketIds);
                if (ticketList != null && ticketList.Count > 0)
                {
                    if (ticketList.Count == 1)
                        isSingle = true;
                    else
                        isSingle = false;
                    thisTicket = ticketList[0];
                }
                else
                {
                    Response.Write("<script>alert('未查询到相关工单信息！');window.close();</script>");
                    return;
                }
                var udfBLL = new UserDefinedFieldsBLL();
                if (thisTicket == null)
                    Response.Write("<script>alert('未查询到相关工单信息！');window.close();</script>");
                else
                {
                    thisAccount = new CompanyBLL().GetCompany(thisTicket.account_id);
                    thisUser = new sys_resource_dal().FindNoDeleteById(LoginUserId);
                    #region 获取相关属性是否可以更改
                    if (ticketList.Any(_ => _.id != thisTicket.id))
                        isManyTitle = true;
                    else
                        isManyTitle = false;
                    if (ticketList.Any(_ => _.id != thisTicket.id))
                        isManydesc = true;
                    else
                        isManydesc = false;
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.department_id != thisTicket.department_id))
                        isManyDep = true;
                    else
                        isManyDep = false;
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.issue_type_id != thisTicket.issue_type_id))
                        isManyissType = true;
                    else
                        isManyissType = false;
                    if (ticketList.Any(_ => _.id != thisTicket.id && (_.owner_resource_id != thisTicket.owner_resource_id&&_.role_id!=thisTicket.role_id)))
                        isManyPri = true;
                    else
                    {
                        isManyPri = false;
                        if (thisTicket.owner_resource_id != null && thisTicket.role_id != null)
                        {
                            thisPriRes = new sys_resource_dal().FindNoDeleteById((long)thisTicket.owner_resource_id);
                            thisRole = new sys_role_dal().FindNoDeleteById((long)thisTicket.role_id);
                            var resDepList = new sys_resource_department_dal().GetResDepByResAndRole((long)thisTicket.owner_resource_id, (long)thisTicket.role_id);
                            if (resDepList != null && resDepList.Count > 0)
                            {
                                proResDep = resDepList[0];
                            }
                        }
                            
                    }
                    
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.cate_id != thisTicket.cate_id))
                        isManyTicketCate = true;
                    else
                        isManyTicketCate = false;
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.estimated_hours != thisTicket.estimated_hours))
                        isManyEstHour = true;
                    else
                        isManyEstHour = false;
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.estimated_end_time != thisTicket.estimated_end_time))
                        isManyDueTime = true;
                    else
                        isManyDueTime = false;
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.account_id != thisTicket.account_id))
                        isManyAccount = true;
                    else
                        isManyAccount = false;
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.contract_id != thisTicket.contract_id))
                        isManyContract = true;
                    else
                    {
                        isManyContract = false;
                        if (thisTicket.contract_id != null)
                            thisContract = new ctt_contract_dal().FindNoDeleteById((long)thisTicket.contract_id);
                    }
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.status_id != thisTicket.status_id))
                        isManyStatus = true;
                    else
                        isManyStatus = false;
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.service_id != thisTicket.service_id))
                        isManySerivce = true;
                    else
                        isManySerivce = false;
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.priority_type_id != thisTicket.priority_type_id))
                        isManyPrio = true;
                    else
                        isManyPrio = false;
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.cost_code_id != thisTicket.cost_code_id))
                        isManyWork = true;
                    else
                    {
                        isManyWork = false;
                        if (thisTicket.cost_code_id != null)
                            thisWorkType = new d_cost_code_dal().FindNoDeleteById((long)thisTicket.cost_code_id);
                    }
                    
                    if (ticketList.Any(_ => _.id != thisTicket.id && _.sub_issue_type_id != thisTicket.sub_issue_type_id))
                        isManySubIssType = true;
                    else
                        isManySubIssType = false;
                    // protected bool isManyStatus;
                    #endregion

                    udfValue = udfBLL.GetUdfValue(DicEnum.UDF_CATE.TASK, thisTicket.id, udfTaskPara);
                    if (udfTaskPara != null && udfTaskPara.Count > 0)
                    {
                        foreach (var udfTask in udfTaskPara)
                        {
                            var thisValue = "";
                            if (udfValue.FirstOrDefault(_ => _.id == udfTask.id) != null)
                                thisValue = udfValue.FirstOrDefault(_ => _.id == udfTask.id).value.ToString();
                            var count = new UserDefinedFieldsBLL().GetSameValueCount(DicEnum.UDF_CATE.TASK, ticketIds, udfTask.col_name, thisValue.ToString());
                            if (count > 1&&(!isSingle))
                                udfValue.FirstOrDefault(_ => _.id == udfTask.id).value = "多个值-保持不变";
                        }
                    }

                    var otherResList = new sdk_task_resource_dal().GetTaskResByTaskId(thisTicket.id);
                    if (otherResList != null && otherResList.Count > 0)
                    {
                        foreach (var item in otherResList)
                        {
                            if (item.resource_id != null && item.role_id != null)
                            {
                                var resDepList = new sys_resource_department_dal().GetResDepByResAndRole((long)item.resource_id, (long)item.role_id);
                                if (resDepList != null && resDepList.Count > 0)
                                    ticketResIds += resDepList[0].id + ",";
                            }

                        }

                        if (ticketResIds != "")
                            ticketResIds = ticketResIds.Substring(0, ticketResIds.Length - 1);
                    }
                }

                if (IsPostBack)
                {
                   
                    var stDal = new sdk_task_dal();
                    var ticBll = new TicketBLL();
                    var accBll = new CompanyBLL();
                    var notiResIds = new System.Text.StringBuilder();
                    foreach (var tic in ticketList)
                    {
                        var ticket = stDal.FindNoDeleteById(tic.id);
                        if (ticket == null)
                            continue;
                        var user = UserInfoBLL.GetUserInfo(LoginUserId);

                        #region 获取相关参数

                        #region 标题，描述，队列，主负责人
                        var pageTitle = ticket.title;
                        if (!isManyTitle)
                            pageTitle = Request.Form["title"];
                        var pageDesc = ticket.description;
                        if (!isManydesc)
                            pageDesc = Request.Form["description"];

                        var pageDepIdString = Request.Form["department_id"];
                        var pagePriResIdString = Request.Form["pri_res"];
                        if (string.IsNullOrEmpty(pageDepIdString) && string.IsNullOrEmpty(pagePriResIdString))
                        {
                            Response.Write("<script>alert('队列和主负责人请填写其中一项！');</script>");
                            return;
                        }
                        long? pageDepId;
                        if (!string.IsNullOrEmpty(pageDepIdString) && pageDepIdString != "0")
                            pageDepId = long.Parse(pageDepIdString);
                        else if (string.IsNullOrEmpty(pageDepIdString))
                            pageDepId = null;
                        else
                            pageDepId = ticket.department_id;

                        long? pagePriResId;
                        if (!string.IsNullOrEmpty(pagePriResIdString) && pagePriResIdString != "0")
                            pagePriResId = long.Parse(pagePriResIdString);
                        else if (string.IsNullOrEmpty(pagePriResIdString))
                            pagePriResId = null;
                        else
                            pagePriResId = ticket.owner_resource_id;
                        #endregion

                        #region 种类,预估时间，到期时间，合同名称
                        var pageCateId = ticket.cate_id;
                        var pageCateIdString = Request.Form["ticket_cate"];
                        if (!string.IsNullOrEmpty(pageCateIdString) && pageCateIdString != "0")
                            pageCateId = int.Parse(pageCateIdString);
                        else if (string.IsNullOrEmpty(pagePriResIdString))
                        {
                            Response.Write("<script>alert('请选择工单种类！');</script>");
                            return;
                        }
                        else
                            pageCateId = ticket.cate_id;

                        var estHours = ticket.estimated_hours;
                        var pageEstHours = Request.Form["est_hours"];
                        if (!string.IsNullOrEmpty(pageEstHours) && pageEstHours.Trim() != "多个值-保持不变")
                            estHours = decimal.Parse(pageEstHours);
                        var dueTime = ticket.estimated_end_time;
                        var pageDueTime = Request.Form["due_time"];
                        if (!string.IsNullOrEmpty(pageDueTime) && pageDueTime.Trim() != "多个值-保持不变")
                            dueTime = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(pageDueTime));
                        var contractName = ticket.contract_id;
                        var pageContract = Request.Form["contractName"];
                        if (!string.IsNullOrEmpty(pageContract) && pageContract != "0")
                            contractName = long.Parse(pageContract);
                        else if (string.IsNullOrEmpty(pageContract))
                            contractName = null;
                        #endregion

                        #region 状态，服务包，优先级，工作类型，问题类型，子问题类型
                        var pageStatusId = ticket.status_id;
                        var pageStuatusIdString = Request.Form["statusId"];
                        if (!string.IsNullOrEmpty(pageStuatusIdString) && pageStuatusIdString != "0")
                            pageStatusId = int.Parse(pageStuatusIdString);
                        else if (string.IsNullOrEmpty(pageStuatusIdString))
                        {
                            Response.Write("<script>alert('请选择工单状态！');</script>");
                            return;
                        }

                        var pageServiceId = ticket.service_id;
                        var pageServiceIdString = Request.Form["serviceId"];
                        if (!string.IsNullOrEmpty(pageServiceIdString) && pageServiceIdString != "0")
                            pageServiceId = int.Parse(pageServiceIdString);
                        else if (string.IsNullOrEmpty(pageServiceIdString))
                            pageServiceId = null;

                        var pagePrioId = ticket.priority_type_id;
                        var pagePrioIdString = Request.Form["priorityId"];
                        if (!string.IsNullOrEmpty(pagePrioIdString) && pagePrioIdString != "0")
                            pagePrioId = int.Parse(pagePrioIdString);
                        else if (string.IsNullOrEmpty(pagePrioIdString))
                        {
                            Response.Write("<script>alert('请选择工单优先级！');</script>");
                            return;
                        }

                        var workTypeId = ticket.cost_code_id;
                        var pageWorkTypeId = Request.Form["workTypeId"];
                        if (!string.IsNullOrEmpty(pageWorkTypeId) && pageWorkTypeId != "0")
                            workTypeId = long.Parse(pageWorkTypeId);
                        else if (string.IsNullOrEmpty(pageWorkTypeId))
                            contractName = null;

                        var pageIssId = ticket.issue_type_id;
                        var pageIssIdString = Request.Form["IssueType"];
                        if (!string.IsNullOrEmpty(pageIssIdString) && pageIssIdString != "0")
                            pageIssId = int.Parse(pageIssIdString);
                        else if (string.IsNullOrEmpty(pageIssIdString))
                        {
                            Response.Write("<script>alert('请选择问题类型！');</script>");
                            return;
                        }

                        var pageSubIssId = ticket.sub_issue_type_id;
                        var pageSubIssIdString = Request.Form["SubIssueType"];
                        if (!string.IsNullOrEmpty(pageSubIssIdString) && pageSubIssIdString != "0")
                            pageSubIssId = int.Parse(pageSubIssIdString);
                        else if (string.IsNullOrEmpty(pageSubIssIdString))
                        {
                            Response.Write("<script>alert('请选择子问题类型！');</script>");
                            return;
                        }
                        #endregion

                        #region 自定义字段相关
                        var thisUdfValue = udfBLL.GetUdfValue(DicEnum.UDF_CATE.TASK, tic.id, udfTaskPara);
                        if (udfTaskPara != null && udfTaskPara.Count > 0)
                        {
                            var list = new List<UserDefinedFieldValue>();
                            foreach (var udf in udfTaskPara)
                            {
                                var new_udf = new UserDefinedFieldValue() { id=udf.id};
                                var thisvv = Request.Form[udf.id.ToString()];
                                if (udf.data_type == (int)DicEnum.UDF_DATA_TYPE.LIST)
                                {
                                    if (thisvv == "0")
                                        new_udf.value = thisUdfValue.FirstOrDefault(_ => _.id == udf.id) == null ? "" : thisUdfValue.FirstOrDefault(_ => _.id == udf.id).value;
                                    else
                                        new_udf.value = thisvv == "" ? null : thisvv;
                                }
                                else
                                {
                                    if (thisvv == "多个值-保持不变")
                                        new_udf.value = thisUdfValue.FirstOrDefault(_ => _.id == udf.id) == null ? "" : thisUdfValue.FirstOrDefault(_ => _.id == udf.id).value;
                                    else
                                        new_udf.value = thisvv == "" ? null : thisvv;
                                }
                                list.Add(new_udf);
                            }
                            udfBLL.UpdateUdfValue(DicEnum.UDF_CATE.TASK, udfTaskPara, ticket.id, list, user, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK);
                        }
                        #endregion

                        #endregion

                        #region 修改工单
                        ticket.title = pageTitle;
                        ticket.description = pageDesc;
                        ticket.department_id = pageDepId;
                        long? roleId = null;
                        if (pagePriResId != null)
                        {
                            var resDep = new sys_resource_department_dal().FindById((long)pagePriResId);
                            if (resDep != null)
                            {
                                pagePriResId = resDep.resource_id;
                                roleId = resDep.role_id;
                            }
                            else
                            {
                                pagePriResId = null;
                                roleId = null;
                            }
                                
                        }
                        ticket.owner_resource_id = pagePriResId;
                        ticket.role_id = roleId;
                        ticket.cate_id = pageCateId;
                        ticket.estimated_hours = estHours;
                        ticket.estimated_end_time = dueTime;
                        ticket.contract_id = contractName;
                        ticket.status_id = pageStatusId;
                        ticket.service_id = pageServiceId;
                        ticket.priority_type_id = pagePrioId;
                        ticket.cost_code_id = workTypeId;
                        ticket.issue_type_id = pageIssId;
                        ticket.sub_issue_type_id = pageSubIssId;

                        ticBll.EditTicket(ticket,LoginUserId);
                        #endregion

                        #region 生成备注
                        ticBll.AddModifyTicketNote(ticket.id,LoginUserId);
                        #endregion


                        #region 单个工单时 修改其他员工相关
                        if (isSingle)
                        {
                            var OtherResId = Request.Form["OtherResId"];
                            ticBll.TicketResManage(ticket.id, OtherResId,LoginUserId);
                        }
                        #endregion

                        #region 获取需要发送邮件的员工的Id
                        if (CkPriRes.Checked && ticket.owner_resource_id != null)
                            notiResIds.Append(ticket.owner_resource_id + ",");
                        if(CKcreate.Checked)
                            notiResIds.Append(ticket.create_user_id + ",");
                        if (CKaccMan.Checked)
                        {
                            var thisAccount = accBll.GetCompany(ticket.account_id);
                            if(thisAccount!=null&&thisAccount.resource_id!=null)
                                notiResIds.Append(thisAccount.resource_id + ",");

                        }
                        #endregion
                    }
                   

                    #region 通知相关
                    if (CCMe.Checked)
                        notiResIds.Append(LoginUserId + ",");
                    var resIds = Request.Form["resIds"];
                    if (!string.IsNullOrEmpty(resIds))
                        notiResIds.Append(resIds + ",");
                    var notify_id = Request.Form["notify_id"];
                    if(!string.IsNullOrEmpty(notify_id)&& notify_id != "0")
                    {

                    }
                    #endregion
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功');self.opener.location.reload();window.close();</script>");



                }

            }
            catch (Exception msg)
            {
                Response.Write("<script>alert('"+msg.Message+"！');window.close();</script>");
            }
        }
    }
}