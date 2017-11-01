<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectSummary.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectSummary" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="stylesheet" href="../Content/reset.css">
    <link rel="stylesheet" href="../Content/NewWorkType.css">
</head>
<body>
    <div class="ButtonContainer">
        <ul>
            <li class="Button ButtonIcon NormalState f1" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon" style="width: 0; margin: 0;"></span>
                <span class="Text">选项</span>
                <img src="../Images/dropdown.png" alt="" class="ButtonRightImg1">
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveButton" tabindex="0">
                <span class="Icon" style="width: 0; margin: 0;"></span>
                <span class="Text">标记</span>
            </li>
        </ul>
    </div>
    <div class="DropDownMenu" id="D1" style="top: 25px;">
        <ul>
            <li><span class="DropDownMenuItemText" onclick="EditProject('<%=thisProject.id %>')">编辑项目</span></li>
            <li><span class="DropDownMenuItemText">添加项目<%=isTemp?"模板":"" %>日历</span></li>
            <li><span class="DropDownMenuItemText">添加项目<%=isTemp?"模板":"" %>备注</span></li>
            <% if (thisProject.status_id != (int)EMT.DoneNOW.DTO.DicEnum.PROJECT_STATUS.DONE)
                { %>
            <li><span class="DropDownMenuItemText">完成项目</span></li>
            <%} %>

            <%// DISABLE 
                if (thisProject.status_id != (int)EMT.DoneNOW.DTO.DicEnum.PROJECT_STATUS.DISABLE)
                {%>
            <li onclick="DisProject('<%=thisProject.id %>')"><span class="DropDownMenuItemText">停用项目<%=isTemp?"模板":"" %></span></li>
            <%} %>
            <li><span class="DropDownMenuItemText">激活项目</span></li>
            <%if (!isTemp)
                { %>
            <li><span class="DropDownMenuItemText" onclick="SaveAsTemp()">保存项目模板</span></li>
            <%} %>
            <li><span class="DropDownMenuItemText" onclick="DeletePro()">删除项目<%=isTemp?"模板":"" %></span></li>
        </ul>
    </div>
    <div class="DivScrollingContainer General" style="top: 34px;">
        <div class="PageLevelInstructions">
        </div>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td style="vertical-align: top;">
                        <div class="DivSectionWithHeader">
                            <div class="Heading">
                                <span class="Text">摘要</span>
                            </div>
                            <div class="Content" style="padding-right: 8px;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tbody>
                                        <tr height="21">
                                            <% var account = new EMT.DoneNOW.BLL.CompanyBLL().GetCompany(thisProject.account_id); %>
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">客户名称
                                            </td>
                                            <td>
                                                <a style="cursor: pointer;" onclick="window.open('../Company/ViewCompany.aspx?id=<%=thisProject.account_id %>', '_blank', 'left=200,top=200,width=600,height=800', false);"><%=account==null?"":account.name %></a>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <% EMT.DoneNOW.Core.ctt_contract contract = null;
                                                if (thisProject.contract_id != null)
                                                {
                                                    contract = new EMT.DoneNOW.DAL.ctt_contract_dal().FindNoDeleteById((long)thisProject.contract_id);
                                                }
                                            %>
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">合同名称
                                            </td>
                                            <td>
                                                <a style="cursor: pointer;" onclick="window.open('../Contract/ContractView.aspx?id=<%=contract==null?"":contract.id.ToString() %>', '_blank', 'left=200,top=200,width=600,height=800', false);"><%=contract==null?"":contract.name %></a>
                                            </td>
                                        </tr>
                                        <tr height="21">

                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">合同类型
                                            </td>
                                            <td>
                                                <%
                                                    var genDal = new EMT.DoneNOW.DAL.d_general_dal();
                                                    if (contract != null)
                                                    {
                                                        var thisType = genDal.FindNoDeleteById(contract.type_id);
                                                %>
                                                <%=thisType==null?"":thisType.name %>
                                                <%} %>
                                               
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">部门
                                            </td>
                                            <td>
                                                <%if (thisProject.department_id != null)
                                                    {
                                                        var depart = new EMT.DoneNOW.DAL.sys_department_dal().FindNoDeleteById((long)thisProject.department_id);%>
                                                <%=depart==null?"":depart.name %>

                                                <%} %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">业务范围
                                            </td>
                                            <td>
                                                <%if (thisProject.line_of_business_id != null)
                                                    {
                                                        var business = genDal.FindNoDeleteById((long)thisProject.line_of_business_id);%>
                                                <%=business==null?"":business.name %>
                                                <%} %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">商机标题
                                            </td>
                                            <td>
                                                <%if (thisProject.opportunity_id != null)
                                                    {
                                                        var opp = new EMT.DoneNOW.DAL.crm_opportunity_dal().FindNoDeleteById((long)thisProject.opportunity_id);%>
                                                <a style="cursor: pointer;" onclick="window.open('../Opportunity/ViewOpportunity.aspx.aspx?id=<%=opp==null?"":opp.id.ToString() %>', '_blank', 'left=200,top=200,width=600,height=800', false);"><%=opp==null?"":opp.name %></a>
                                                <%} %> 
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">项目编号
                                            </td>
                                            <td>
                                                <%=thisProject.no %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">外部号码
                                            </td>
                                            <td><%=thisProject.external_id %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">项目类型
                                            </td>
                                            <td>
                                                <%
                                                    var proType = genDal.FindNoDeleteById((long)thisProject.type_id);
                                                %>
                                                <%=proType==null?"":proType.name %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="21" colspan="2">
                                                <hr>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">状态
                                            </td>
                                            <td>
                                                <% var proSta = genDal.FindNoDeleteById(thisProject.status_id);
                                                %>
                                                <%=proSta==null?"":proSta.name %>

                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">状态日期
                                            </td>
                                            <td>
                                                <% if (thisProject.status_time != null)
                                                    { %>
                                                <%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisProject.status_time).ToString("yyyy-MM-dd") %>
                                                <%} %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">状态信息
                                            </td>
                                            <td><%=thisProject.status_detail %>
                                            </td>
                                        </tr>
                                        <%
                                            var estHoyrs = proBLL.ESTIMATED_HOURS(thisProject.id); // 预估时间
                                            var workHours = proBLL.ProWorkHours(thisProject.id);   // 实际时间
                                            var proHours = proBLL.ProChaHours(thisProject.id);     // 变更单时间时间
                                            var proNum = proBLL.Provariance(thisProject.id);    // 项目的估算差异
                                            var taskPer = proBLL.CompleteTaskPercent(thisProject.id);  // 项目完成百分比

                                            var surplusTime = estHoyrs + proHours + proNum - workHours; // 剩余时间
                                            var timePer = (workHours * 100) / ((workHours + surplusTime) == 0 ? 1 : (workHours + surplusTime)); // 时间完成百分比
                                        %>

                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">预估时间（小时）
                                            </td>
                                            <td>
                                                <%=estHoyrs.ToString("#0.00") %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">实际时间（小时）
                                            </td>
                                            <td>
                                                <%=workHours.ToString("#0.00") %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">剩余时间（小时）
                                            </td>
                                            <td>
                                                <%=surplusTime.ToString("#0.00") %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">估算差异（小时）
                                            </td>
                                            <td>
                                                <%=proNum.ToString("#0.00") %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">完成时间 %
                                            </td>
                                            <td style="border: 1px solid #2c2c2c; width: 204px; min-width: 204px;">
                                                <div class="load" style="width: <%=timePer %>%; position: relative;"></div>
                                            </td>
                                        </tr>
                                        <tr height="5">

                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">完成任务 %
                                            </td>
                                            <td style="border: 1px solid #2c2c2c; width: 204px; min-width: 204px;">
                                                <div class="load" style="width: <%=taskPer %>%; position: relative;"></div>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">项目主管
                                            </td>
                                            <td>
                                                <%if (thisProject.owner_resource_id != null)
                                                    {
                                                        var resLead = new EMT.DoneNOW.DAL.sys_resource_dal().FindNoDeleteById((long)thisProject.owner_resource_id);%>
                                                <%=resLead==null?"":resLead.name %>
                                                <%    }%>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">客户所有人
                                            </td>
                                            <td>
                                                <% 
                                                    if (account != null && account.resource_id != null)
                                                    {
                                                        var accountManage = new EMT.DoneNOW.DAL.sys_resource_dal().FindNoDeleteById((long)account.resource_id);%>
                                                <%=accountManage==null?"":accountManage.name %>
                                                <%    } %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">开始日期
                                            </td>
                                            <td>
                                                <%=((DateTime)thisProject.start_date).ToString("yyyy-MM-dd") %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">结束日期
                                            </td>
                                            <td>
                                                <%=((DateTime)thisProject.end_date).ToString("yyyy-MM-dd") %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px; width: 200px;">持续时间
                                            </td>

                                            <td style="border: 1px solid #2c2c2c; width: 204px; min-width: 204px;">
                                                <%
                                                    decimal width = 0;
                                                    var days = 0;
                                                    if (DateTime.Now > ((DateTime)thisProject.end_date).AddDays(1))
                                                    {
                                                        width = 100;
                                                        days = (int)thisProject.duration;
                                                    }
                                                    else if (DateTime.Now < (DateTime)thisProject.start_date)
                                                    {
                                                        width = 0;
                                                        days = 0;
                                                    }
                                                    else
                                                    {
                                                        TimeSpan ts1 = new TimeSpan(((DateTime)thisProject.start_date).Ticks);
                                                        TimeSpan ts2 = new TimeSpan(DateTime.Now.Ticks);
                                                        TimeSpan ts = ts1.Subtract(ts2).Duration();
                                                        days = ts.Days;
                                                        width = ts.Days * 100 / ((decimal)thisProject.duration);
                                                    }

                                                %>
                                                <div class="load" style="width: <%=width %>%; position: relative; background-color: #808080; height: 10px;">
                                                    <span style="color: white; float: left;"><%=days %> 天</span>
                                                </div>
                                            </td>
                                            <td></td>
                                            <td class="FieldLabels" style="padding: 5px 0;">
                                                <span><%=(int)thisProject.duration %>天</span>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <%
                            var openTaskNum = 0;   // 活动任务
                            var overTaskNum = 0;   // 过期任务
                            var comTaskNum = 0;    // 已完成任务
                            var issuesNum = 0;
                            if (taskList != null && taskList.Count > 0)
                            {
                                var activeTask = taskList.Where(_ => _.status_id != (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList();
                                if (activeTask != null && activeTask.Count > 0)
                                {
                                    openTaskNum = activeTask.Count;
                                    var overTaskList = activeTask.Where(_ => _.estimated_end_date != null && ((DateTime)_.estimated_end_date < DateTime.Now)).ToList();
                                    if (overTaskList != null && overTaskList.Count > 0)
                                    {
                                        overTaskNum = overTaskList.Count;
                                    }
                                }
                                var comTaskList = taskList.Where(_ => _.status_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList();
                                if (comTaskList != null && comTaskList.Count > 0)
                                {
                                    comTaskNum = comTaskList.Count;
                                }
                                var issuesTask = taskList.Where(_ => _.type_id == (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_ISSUE).ToList();
                                if (issuesTask != null && issuesTask.Count > 0)
                                {
                                    issuesNum = issuesTask.Count;
                                }
                            }
                        %>
                     
                    </td>
                    <td width="330px" align="left" valign="top" style="min-width: 330px;">
                        <div class="DivSectionWithHeader DivSectionWithColor">
                            <div class="Heading">
                                <span class="Text">相关条目</span>
                            </div>
                            <div class="Content">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tbody>
                                        <tr height="24px">
                                            <td class="FieldLabels">活动任务
                                            </td>
                                            <td>

                                                <a><%=openTaskNum %></a>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">过期任务
                                            </td>
                                            <td>
                                                <a><%=overTaskNum %></a>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">已完成任务
                                            </td>
                                            <td>
                                                <a><%=comTaskNum %></a>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">问题
                                            </td>
                                            <td>
                                                <a><%=issuesNum %></a>
                                            </td>
                                        </tr>
                                        <%--         <tr height="24px">
                                             <td class="FieldLabels">关联工单
                                            </td>
                                             <td>
                                               <a><%="0" %></a>
                                             </td>
                                         </tr>--%>
                                        <tr height="24px">
                                        </tr>
                                        <%
                                            var costNum = 0;
                                            var rateNum = 0;
                                            var rateList = new EMT.DoneNOW.DAL.pro_project_team_dal().GetRateNum(thisProject.id);
                                            if (rateList != null && rateList.Count > 0)
                                            {
                                                rateNum = rateList.Count;
                                            }
                                            var noteNum = 0;
                                            var noteList = new EMT.DoneNOW.DAL.com_activity_dal().GetActiList($" and object_id = {thisProject.id} ");
                                            var annNum = 0;
                                            var annList = new EMT.DoneNOW.DAL.com_activity_dal().GetActiList($" and object_id = {thisProject.id} and announce=1 ");
                                            var ciNum = 0;
                                            var  ciList= new EMT.DoneNOW.DAL.ctt_contract_cost_dal().GetCostByProId(thisProject.id," and create_ci=1");
                                            if (ciList != null && ciList.Count > 0)
                                            {
                                                ciNum = ciList.Count;
                                            }
                                            var caleNum = 0;
                                            var caleList = new EMT.DoneNOW.DAL.pro_project_calendar_dal().GetCalByPro(thisProject.id);
                                            var costList = new EMT.DoneNOW.DAL.ctt_contract_cost_dal().GetCostByProId(thisProject.id);
                                            if (costList != null && costList.Count > 0)
                                            {
                                                costNum = costList.Count;
                                            }
                                            if (noteList != null && noteList.Count > 0)
                                            {
                                                noteNum = noteList.Count;
                                            }
                                            if (caleList != null && caleList.Count > 0)
                                            {
                                                caleNum = caleList.Count;
                                            }
                                            if (annList != null && annList.Count > 0)
                                            {
                                                annNum = annList.Count;
                                            }
                                        %>

                                        <tr height="24px">
                                            <td class="FieldLabels">成本
                                            </td>
                                            <td>
                                                <a><%=costNum %></a>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">费率
                                            </td>
                                            <td>
                                                <a><%=rateNum %></a>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">备注
                                            </td>
                                            <td>
                                                <a><%=noteNum %></a>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">日历
                                            </td>
                                            <td>
                                                <a><%=caleNum %></a>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">公告
                                            </td>
                                            <td>
                                                <a><%=annNum %></a>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">配置项
                                            </td>
                                            <td>
                                                <a><%=ciNum %></a>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </td>
                  
                </tr>
                <tr>
                      <td colspan="2">

                        <div class="DivSectionWithHeader">
                            <div class="Heading">
                                <span class="Text">公告</span>
                            </div>
                            <div class="Content" style="padding-right: 8px;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tbody>
                                        <% if (annList != null && annList.Count > 0)
                                            {
                                                annList = annList.OrderByDescending(_ => _.start_date).ToList();
                                                var sysresList = new EMT.DoneNOW.DAL.sys_resource_dal().GetDictionary();
                                                foreach (var ann in annList)
                                                {%>
                                        <tr height="20">
                                            <td width="65%" valign="top" class="FieldLabels" style="font-size: 12px;color: #4F4F4F;font-weight: bold;"><%=ann.name %></td>
                                            <td width="20%" valign="top" class="FieldLabels" style="font-size: 12px;color: #4F4F4F;font-weight: bold;"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(ann.start_date).ToString("yyyy-MM-dd") %></td>
                                              <% var thisRes = sysresList.FirstOrDefault(_ => _.val == ann.create_user_id.ToString()); %>
                                            <td width="15%" align="left" valign="top" class="FieldLabels" style="font-size: 12px;color: #4F4F4F;font-weight: bold;"><%=thisRes==null?"":thisRes.show %></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" style="padding-left: 10px; padding-right: 10px;">
                                              
                                                <div style="color: #4F4F4F;"><%=ann.description %></div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="21" colspan="3">
                                                <%if (annList.IndexOf(ann) != annList.Count-1)
                                                 { %>
                                                <hr />
                                                <%} %>
                                            </td>
                                        </tr>
                                        <%}
                                            }%>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </td>
                </tr>
            </tbody>
        </table>


    </div>


      


</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(".f1").on("mouseover", function () {
        $(this).css("background", "white");
        $(this).css("border-bottom", "none");
        $("#D1").show();
    });
    $(".f1").on("mouseout", function () {
        $("#D1").hide();
        $(this).css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("border-bottom", "1px solid #BCBCBC");
    });
    $("#D1").on("mouseover", function () {
        $(this).show();
        $(".f1").css("background", "white");
        $(".f1").css("border-bottom", "none");
    });
    $("#D1").on("mouseout", function () {
        $(this).hide();
        $(".f1").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".f1").css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".f1").css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".f1").css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".f1").css("border-bottom", "1px solid #BCBCBC");
    });
    $(".DropDownMenuItemText").on("mouseover", function () {
        $(this).parent().css("background", "#E9F0F8");
    });
    $(".DropDownMenuItemText").on("mouseout", function () {
        $(this).parent().css("background", "#FFF");
    });

</script>
<script>
    $(function () {
        $("#Nav2").hide();
    })
    function EditProject(project_id) {
        window.open("ProjectAddOrEdit.aspx?id=" + project_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.PROJECT_EDIT %>', 'left=200,top=200,width=600,height=800', false);
    }

    function DisProject(project_id) {
        debugger;
        if (project_id != undefined && project_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=DisProject&project_id=" + project_id,
                success: function (data) {
                    debugger;
                    if (data == "True") {
                        LayerMsg("停用项目成功");
                    } else if (data == "False") {
                        LayerMsg("停用项目失败");
                    }
                    history.go(0);
                },
            });
        }
    }

    function SaveAsTemp() {
        window.parent.location.href = "ProjectView?type=ScheduleTemp&id=<%=thisProject.id %>";
    }
    function DeletePro() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=DeletePro&project_id=<%=thisProject.id %>",
            dataType:"json",
            success: function (data) {
                if (data != "") {
                    if (data.result == "True") {
                        LayerMsg("删除项目成功！");
                    } else if (data.result == "False") {
                        LayerMsg("该项目不能被删除，因为有一个或多个时间条目，费用，费用，服务预定，备注，附件，里程碑！");
                    }
                }
                window.close();
                self.parent.location.reload();
            },
        });
    }
</script>
