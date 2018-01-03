<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectAddOrEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectAddOrEdit" EnableEventValidation="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新建":"编辑" %>项目</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/NewConfigurationItem.css" rel="stylesheet" />
    <style>
        #useResource_daily_hours, #excludeHoliday, #excludeWeekend {
            vertical-align: middle;
        }

        #warnTime_off {
            vertical-align: middle;
            cursor: pointer;
        }

        #save {
            border-style: None;
            background-color: whitesmoke;
            flex: 0 1 auto;
            font-size: 12px;
            font-weight: bold;
            overflow: hidden;
            padding: 0 3px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">

                <span class="text1"><%=isAdd?"新建项目":"编辑项目-"+thisProject.name+$"({account.name})" %>  </span>
                <a href="###" class="collection"></a>
                <a href="###" class="help"></a>
            </div>
        </div>
        <div class="ButtonContainer">
            <ul id="btn">
                <li class="Button ButtonIcon NormalState" id="SaveButton" tabindex="0">
                    <span class="Icon Save"></span>
                    <span class="Text">
                        <asp:Button ID="save" runat="server" Text="保存" BorderStyle="None" OnClick="save_Click" /></span>
                </li>
                <%if (string.IsNullOrEmpty(isTemp))
                    { %>
                <li class="Button ButtonIcon NormalState" id="ImportFromTemplateButton" tabindex="0">
                    <span class="Icon" style="margin: 0; width: 0;"></span>
                    <span class="Text">从模板导入</span>
                </li>
                <%} %>
                <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel"></span>
                    <span class="Text">取消</span>
                </li>
            </ul>
        </div>
        <div class="DivScrollingContainer" style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 90px;">
            <div class="DivSectionWithHeader" style="max-width: 740px;">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle1">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">常规</span>
                </div>
                <div class="Content">
                    <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div>
                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                            <tbody>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">标题<span style="color: Red;">*</span>
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <input type="text" id="name" name="name" style="width: 250px;" value="<%=isAdd?"":thisProject.name %>"></span>
                                                        </div>
                                                    </td>
                                                    <td class="FieldLabel">业务范围
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <asp:DropDownList ID="line_of_business_id" runat="server" CssClass="txtBlack8Class" Width="264px"></asp:DropDownList>
                                                        </span>
                                                    </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">客户<span style="color: Red;">*</span>
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <input type="text" style="width: 250px;" id="account_id" value="<%=account==null?"":account.name %>" /></span>
                                                            <input type="hidden" name="account_id" id="account_idHidden" value="<%=account==null?"":account.id.ToString() %>" />
                                                            <a class="DataSelectorLinkIcon" id="AChoAcc" onclick="ChooseAccount()">
                                                                <img src="../Images/data-selector.png" /></a>
                                                        </div>
                                                    </td>
                                                    <%if (string.IsNullOrEmpty(isTemp))
                                                        { %>
                                                    <td class="FieldLabel">外部号码
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" id="external_id" name="external_id" value="<%=isAdd ? "" : thisProject.external_id %>" /></span>
                                                    </div>
                                                    </td>
                                                    <%} %>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">
                                                        <span>开始日期<span style="color: Red;">*</span></span>
                                                        <span style="margin-left: 31px;">结束日期<span style="color: Red;">*</span></span>
                                                        <span style="margin-left: 29px;">持续时间</span>
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <input type="text" style="width: 72px;" onclick="WdatePicker()" class="Wdate" id="start_date" name="start_date" value="<%=isAdd?DateTime.Now.ToString("yyyy-MM-dd"):((DateTime)thisProject.start_date).ToString("yyyy-MM-dd") %>" />
                                                                <input type="text" style="width: 72px;" onclick="WdatePicker()" class="Wdate" id="end_date" name="end_date" value="<%=isAdd?DateTime.Now.AddDays(1).ToString("yyyy-MM-dd"):((DateTime)thisProject.end_date).ToString("yyyy-MM-dd") %>" />
                                                                <input type="text" style="width: 70px;" id="duration" name="duration" value="<%=isAdd?"":((int)thisProject.duration).ToString() %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                                                                <span>天</span>
                                                            </span>
                                                        </div>
                                                    </td>
                                                    <%if (string.IsNullOrEmpty(isTemp))
                                                        { %>
                                                    <td class="FieldLabel">采购订单号
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" id="purchase_order_no" name="purchase_order_no" value="<%=isAdd?"":thisProject.purchase_order_no %>" /></span>
                                                    </div>
                                                    </td>
                                                    <%} %>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel">类型<span style="color: red;">*</span>
                                                        <div>
                                                            <asp:DropDownList ID="type_id" runat="server" Width="264px"></asp:DropDownList>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" class="FieldLabel">描述
                                                    <div>
                                                        <textarea style="min-height: 100px; width: 610px;" id="description" name="description"><%=isAdd?"":thisProject.description %></textarea>
                                                    </div>
                                                    </td>
                                                </tr>
                                                <%if (!string.IsNullOrEmpty(isTemp))
                                                    { %>
                                                <tr>
                                                    <td>
                                                        <div>
                                                            <asp:CheckBox ID="is_active" runat="server" />
                                                            <label>激活</label>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <%} %>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <!--状态,新增里没有  修改模板也没有-->
            <% if (!isAdd && string.IsNullOrEmpty(isTemp))
                {
            %>
            <div class="DivSectionWithHeader" style="max-width: 740px;">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle2">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">状态</span>
                </div>
                <div class="Content">
                    <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div>
                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                            <tbody>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">状态<span style="color: Red;">*</span>
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <asp:DropDownList ID="status_id" runat="server" CssClass="txtBlack8Class" Width="264px"></asp:DropDownList>
                                                            </span>
                                                        </div>
                                                    </td>
                                                    <td class="FieldLabel">
                                                        <span>修改时间<span style="color: red;">*</span></span>
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <input type="text" style="width: 126px;" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" class="Wdate" id="status_time" name="statustime" value="<%=isAdd ? "" : EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisProject.status_time).ToString("yyyy-MM-dd HH:mm:ss") %>" />
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" class="FieldLabel">状态说明
                                                    <span style="font-weight: normal;">(将状态更改为完成时必填)</span>
                                                        <div>
                                                            <textarea style="min-height: 100px; width: 610px;" id="status_detail" name="status_detail"><%=isAdd ? "" : thisProject.status_detail %></textarea>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <%} %>
            <div class="DivSectionWithHeader" style="max-width: 740px;">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle3">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">关联</span>
                </div>
                <div class="Content">
                    <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div>
                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                            <tbody>
                                                <%if (string.IsNullOrEmpty(isTemp))
                                                    { %>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">合同
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" id="contract_id" value="<%=contract == null ? "" : contract.name %>" disabled />
                                                            <input type="hidden" id="contract_idHidden" name="contract_id" value="<%=contract == null ? "" : contract.id.ToString() %>" />
                                                            <a class="DataSelectorLinkIcon" id="AChoossCon" onclick="ChooseContract()">
                                                                <img src="../Images/data-selector.png" /></a>
                                                            <a class="DataSelectorLinkIcon" id="AAddCon" onclick="AddContract()">
                                                                <img src="../Images/add.png" /></a>
                                                        </span>
                                                    </div>
                                                    </td>
                                                    <td class="FieldLabel">商机
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <select name="opportunity_id" id="opportunity_id" disabled style="width: 264px;">
                                                                <option value="" selected>请选择客户</option>
                                                            </select>
                                                        </span>
                                                    </div>
                                                    </td>
                                                </tr>
                                                <%} %>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">部门
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <asp:DropDownList ID="department_id" runat="server" Width="264px"></asp:DropDownList>
                                                        </span>
                                                    </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader" style="max-width: 740px;">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle4">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">团队成员</span>
                </div>
                <div class="Content">
                    <div class="DescriptionText">请为该项目添加项目成员和联系人。项目成员日工作量将被用于设定每个项目成员的日工作量（**小时/天）。一旦项目被创建，可以在团队成员页面添加、编辑和删除相关数据。</div>
                    <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div>
                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                            <tbody>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">项目主管
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <asp:DropDownList ID="owner_resource_id" runat="server"></asp:DropDownList>

                                                            <%-- <% EMT.DoneNOW.Core.sys_resource resource = null;
                                                                if ((!isAdd) && thisProject.owner_resource_id != null)
                                                                {
                                                                    resource = new EMT.DoneNOW.DAL.sys_resource_dal().FindNoDeleteById((long)thisProject.owner_resource_id);
                                                                }
                                                            %>
                                                            <input type="text" style="width: 250px;" id="owner_resource_id" value="<%=resource==null?"":resource.name %>">
                                                            <input type="hidden" name="owner_resource_id" id="owner_resource_idHidden" value="<%=resource==null?"":resource.id.ToString() %>" />--%>
                                                            <%--     <a class="DataSelectorLinkIcon">
                                                                <img src="../Images/data-selector.png" /></a>--%>
                                                        </span>
                                                    </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">项目成员和计费角色
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" id="inChosREsdep" />
                                                            <a class="DataSelectorLinkIcon" onclick="ChooseResDep()" id="AchoResDep">
                                                                <img src="../Images/data-selector.png" /></a>
                                                            <input type="hidden" id="resDepIds" />
                                                            <input type="hidden" id="resDepIdsHidden" name="resDepList" />
                                                        </span>
                                                    </div>
                                                        <div>
                                                            <select multiple="multiple" style="width: 264px; min-height: 80px;" id="resDepList">
                                                                <% if (!isAdd)
                                                                    {
                                                                        var resouList = new EMT.DoneNOW.DAL.pro_project_team_dal().GetResListByProId(thisProject.id);
                                                                        if (resouList != null && resouList.Count > 0)
                                                                        {
                                                                            var pptrDal = new EMT.DoneNOW.DAL.pro_project_team_role_dal();
                                                                            var syDal = new EMT.DoneNOW.DAL.sys_resource_dal();
                                                                            var srDal = new EMT.DoneNOW.DAL.sys_role_dal();

                                                                            foreach (var resou in resouList)
                                                                            {
                                                                                var teamRoleList = pptrDal.GetListTeamRole(resou.id);
                                                                                if (teamRoleList != null&&teamRoleList.Count>0)
                                                                                {
                                                                                    var thisResou = syDal.FindNoDeleteById((long)resou.resource_id);
                                                                                    if (thisResou == null)
                                                                                    {
                                                                                        continue;
                                                                                    }

                                                                                    foreach (var teamRole in teamRoleList)
                                                                                    {
                                                                                        var thisRole = srDal.FindNoDeleteById((long)teamRole.role_id);
                                                                                        if ( thisRole != null)
                                                                                        {
                                                                %>
                                                                <option><%=thisResou.name+$"({thisRole.name})" %></option>
                                                                <%
                                                                                    }
                                                                                    }
                                                                                   
                                                                                }
                                                                            }
                                                                        }
                                                                    }%>
                                                            </select>
                                                        </div>
                                                    </td>
                                                    <td class="FieldLabel">联系人
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" disabled id="textChoosAccount" value="请选择客户" />
                                                            <a class="DataSelectorLinkIcon DisabledState" id="AChoC" onclick="ChooseContact()">
                                                                <img src="../Images/data-selector.png" /></a>
                                                            <input type="hidden" id="contactID" />
                                                            <input type="hidden" id="contactIDHidden" name="conIds" />
                                                        </span>
                                                    </div>
                                                        <div>
                                                            <select multiple="multiple" style="width: 264px; min-height: 80px;" disabled id="conIds">
                                                                <%
                                                                    if (!isAdd)
                                                                    {

                                                                        var conList = new EMT.DoneNOW.DAL.pro_project_team_dal().GetConListByProId(thisProject.id);
                                                                        if (conList != null && conList.Count > 0)
                                                                        {
                                                                            var cDal = new EMT.DoneNOW.DAL.crm_contact_dal();
                                                                            foreach (var con in conList)
                                                                            {
                                                                                var thisContact = cDal.FindNoDeleteById((long)con.contact_id);
                                                                                if (thisContact != null)
                                                                                {%>
                                                                <option><%=thisContact.name %></option>
                                                                <%}
                                                                            }
                                                                        }

                                                                    }
                                                                %>
                                                            </select>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader" style="max-width: 740px; background: #efefef;">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle5">
                        <div class="Vertical" style="display: block;"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">项目成员日工作量</span>
                </div>
                <div class="Content" style="display: none;">
                    <div class="DescriptionText">设置项目成员期望每天工作的小时数，他可以根据团队成员进行调整。如果此任务没有主负责人，该值用于计算任务截止日期/时间</div>
                    <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div>
                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                            <tbody>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">总时间<span style="color: red;">*</span>
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <input type="text" style="width: 250px;" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" id="resource_daily_hours" name="resource_daily_hours" value="<%=isAdd?"":((decimal)thisProject.resource_daily_hours).ToString("#0.00") %>" />
                                                            </span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div style="width: 310px;">
                                                            <asp:CheckBox ID="useResource_daily_hours" runat="server" />

                                                            <label for="CapacityCalculation">
                                                                用工作量为固定工作任务计算时间
                                                            <span style="color: #666;">（当不启用此设置时，您能够手动调整固定工作任务的持续时间，持续时间不会自动计算）
                                                            </span>
                                                            </label>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader" style="max-width: 740px; background: #efefef;">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle6">
                        <div class="Vertical" style="display: block;"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">日程表设置</span>
                </div>
                <div class="Content" style="display: none;">
                    <div class="DescriptionText">启用“非工作日/节假日”可能会改变任务/问题的开始/结束日期。当“非工作日/节假日”启用时，任务/问题只会被安排在工作日。对于没有主负责人的任务/问题，非工作日和节假日将取决于已选区域，一旦为任务/问题分配了主负责人，非工作日和节假日将取决于主负责人所在区域。</div>
                    <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div>
                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                            <tbody>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">当调整任务/问题时不包括：
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <asp:CheckBox ID="excludeWeekend" runat="server" />

                                                            <label for="excludeWeekend">非工作日</label>
                                                            <span>(星期六和星期天)</span>
                                                        </span>
                                                    </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <asp:CheckBox ID="excludeHoliday" runat="server" />

                                                                <label for="excludeHoliday">节假日</label>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">区域
                                                    <span style="color: #666; font-weight: normal">(决定节假日和非工作日)</span>
                                                        <span style="color: red;">*</span>
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <asp:DropDownList ID="organization_location_id" runat="server" Width="264px"></asp:DropDownList>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="100%">
                                                        <div>
                                                            <asp:CheckBox ID="warnTime_off" runat="server" />
                                                            <label for="warnTime_off">当用户试图分配一个任务/问题时，如果主负责人已经审批的休假请求会影响工作按时完成，则显示一个警告</label>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader" style="max-width: 740px; background: #efefef;">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle7">
                        <div class="Vertical" style="display: block;"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">用户自定义字段</span>
                </div>
                <div class="Content" style="display: none;">
                    <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div>
                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                            <tbody>
                                                <% if (project_udfList != null && project_udfList.Count > 0)
                                                    {
                                                        foreach (var udf in project_udfList)
                                                        {

                                                            if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                                            {%>
                                                <tr>
                                                    <td>
                                                        <div class="clear">
                                                            <label><%=udf.name %></label>
                                                            <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=(!isAdd)&&project_udfValueList!=null&&project_udfValueList.Count>0?project_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
                                                        </div>

                                                    </td>
                                                </tr>
                                                <%}
                                                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                                                    {%>
                                                <tr>
                                                    <td>
                                                        <div class="clear">
                                                            <label><%=udf.name %></label>
                                                            <textarea name="<%=udf.id %>" rows="2" cols="20"><%=project_udfValueList!=null&&project_udfValueList.Count>0?project_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %></textarea>
                                                        </div>

                                                    </td>
                                                </tr>
                                                <%}
                                                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                                                    {%><tr>
                                                        <td>
                                                            <div class="clear">
                                                                <label><%=udf.name %></label>

                                                                <%

                                                                    string val = "";
                                                                    if (!isAdd)
                                                                    {
                                                                        object value = project_udfValueList.FirstOrDefault(_ => _.id == udf.id).value;
                                                                        if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                                                        {
                                                                            val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                                                        }
                                                                    }
                                                                %>
                                                                <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=val %>" />
                                                            </div>

                                                        </td>
                                                    </tr>
                                                <%}
                                                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                                                    {%>
                                                <tr>
                                                    <td>
                                                        <div class="clear">
                                                            <label><%=udf.name %></label>
                                                            <input type="text" name="<%=udf.id %>" class="sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=project_udfValueList!=null&&project_udfValueList.Count>0?project_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
                                                        </div>
                                                    </td>
                                                </tr>
                                                <%}
                                                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                                                    {%>

                                                <%}
                                                        }
                                                    } %>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader" style="max-width: 740px; background: #efefef;">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle8">
                        <div class="Vertical" style="display: block;"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">收益/成本</span>
                </div>
                <div class="Content" style="display: none;">
                    <div class="DescriptionText">根据这些字段更新预算</div>
                    <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div>
                                        <table cellpadding="0" cellspacing="0" style="width: 80%;" class="NewEditProject_CostTable">
                                            <thead>
                                                <tr>
                                                    <td></td>
                                                    <td>
                                                        <div>收入</div>
                                                    </td>
                                                    <td>
                                                        <div>成本</div>
                                                    </td>
                                                    <td></td>
                                                    <td>
                                                        <div>利润</div>
                                                    </td>
                                                    <td>
                                                        <div>利润率 %</div>
                                                    </td>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <div>工时</div>
                                                    </td>
                                                    <td class="NewEditProject_Content NewEditProject_Right">
                                                        <input type="text" class="NewEditProject_NumberField" id="labor_revenue" name="labor_revenue" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":((decimal)thisProject.labor_revenue).ToString("#0.00") %>" />
                                                    </td>
                                                    <td class="NewEditProject_Content NewEditProject_Right">
                                                        <input type="text" class="NewEditProject_NumberField" id="labor_budget" name="labor_budget" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":((decimal)thisProject.labor_budget).ToString("#0.00") %>" />
                                                    </td>
                                                    <td>
                                                        <div>=</div>
                                                    </td>
                                                    <td class="NewEditProject_Content">
                                                        <div class="NewEditProject_NumberField" id="labor_profit">0.00</div>
                                                    </td>
                                                    <td class="NewEditProject_Content">
                                                        <div class="NewEditProject_NumberField" id="div_labor_margin">0.00</div>
                                                        <input type="hidden" id="labor_margin" name="labor_margin" value="<%=isAdd?"0.00":((decimal)thisProject.labor_margin).ToString("#0.00") %>" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div>项目成本</div>
                                                    </td>
                                                    <td class="NewEditProject_Content NewEditProject_Right NewEditProject_ColumnTotal ">
                                                        <input type="text" class="NewEditProject_NumberField" id="cost_revenue" name="cost_revenue" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":((decimal)thisProject.cost_revenue).ToString("#0.00") %>" />
                                                    </td>
                                                    <td class="NewEditProject_Content NewEditProject_Right NewEditProject_ColumnTotal">
                                                        <input type="text" class="NewEditProject_NumberField" id="cost_budget" name="cost_budget" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":((decimal)thisProject.cost_budget).ToString("#0.00") %>" />
                                                    </td>
                                                    <td>
                                                        <div>=</div>
                                                    </td>
                                                    <td class="NewEditProject_Content NewEditProject_ColumnTotal">
                                                        <div class="NewEditProject_NumberField" id="cost_profit">0.00</div>
                                                    </td>
                                                    <td class="NewEditProject_Content NewEditProject_ColumnTotal">
                                                        <div class="NewEditProject_NumberField" id="div_cost_margin">0.00</div>
                                                        <input type="hidden" id="cost_margin" name="cost_margin" value="<%=isAdd?"0.00":((decimal)thisProject.cost_margin).ToString("#0.00") %>" />
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td>
                                                        <div>汇总</div>
                                                    </td>
                                                    <td class="NewEditProject_Content">
                                                        <div class="NewEditProject_NumberField" id="total_revenue">0.00</div>
                                                    </td>
                                                    <td class="NewEditProject_Content">
                                                        <div class="NewEditProject_NumberField" id="total_budget">0.00</div>
                                                    </td>
                                                    <td></td>
                                                    <td class="NewEditProject_Content">
                                                        <div class="NewEditProject_NumberField" id="total_profit">0.00</div>
                                                    </td>
                                                    <td class="NewEditProject_Content">
                                                        <div class="NewEditProject_NumberField" id="total_margin">0.00</div>
                                                    </td>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="NewEditProject_Spacer"></div>
                    <div class="NewEditProject_Inset">
                        <span class="NewEditProject_TextBold">报表其他值</span>
                        <br>
                        <span class="NewEditProject_Text NewEditProject_ColorGray">这些值为基准值，用来与当前项目的财务报表数据进行比较</span>
                        <table class="NewEditProject_AdditionalTable" cellspacing="0" cellpadding="0">
                            <colgroup>
                                <col class="NewEditProject_95pxWidth">
                                <col>
                                <col>
                                <col>
                                <col>
                            </colgroup>
                            <thead>
                                <tr>
                                    <td></td>
                                    <td>
                                        <div>收入</div>
                                    </td>
                                    <td>
                                        <div>销售成本</div>
                                    </td>
                                    <td></td>
                                    <td>
                                        <div>销售，常规和财务费用%</div>
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>最初估计
                                    </td>
                                    <td class="NewEditProject_Right">
                                        <input type="text" class="NewEditProject_Right NewEditProject_PaddingRight" id="original_revenue" name="original_revenue" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":((decimal)thisProject.original_revenue).ToString("#0.00") %>" />
                                    </td>
                                    <td class="NewEditProject_Right">
                                        <input type="text" class="NewEditProject_Right NewEditProject_PaddingRight" id="original_sales_cost" name="original_sales_cost" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":((decimal)thisProject.original_sales_cost).ToString("#0.00") %>" />
                                    </td>
                                    <td>
                                        <span>|</span>
                                    </td>
                                    <td class="NewEditProject_Right">
                                        <input type="text" class="NewEditProject_Right NewEditProject_PaddingRight" id="original_sgda" name="original_sgda" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":((decimal)thisProject.original_sgda).ToString("#0.00") %>" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4"></td>
                                    <td class="NewEditProject_ColorGray">% 从项目收益中扣除的管理费
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!--通知，编辑没有-->
            <% if (isAdd)
                { %>
            <div class="DivSectionWithHeader" style="max-width: 740px;">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle9">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">通知</span>
                </div>
                <div class="Content">
                    <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div>
                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                            <tbody>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">模板 
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <asp:DropDownList ID="template_id" runat="server" Width="264px"></asp:DropDownList>
                                                        </span>
                                                    </div>
                                                    </td>
                                                </tr>
                                                <tr>

                                                    <td class="FieldLabel" width="50%">发件人:
                                                    <span style="font-weight: normal; color: #4f4f4f;" id="From_Email"></span>
                                                        <div style="padding-bottom: 0;">
                                                            <span><a onclick="OpenSelectPage('To')">收件人:</a></span>
                                                            <span>
                                                                <a id="to_me" onclick="ToMe()">自己</a>
                                                                <a id="teamMember" style="margin-left: 5px;" onclick="ToTeamMember()">团队成员</a>
                                                                <a id="ProLead" style="margin-left: 5px;" onclick="ToProjectLead()">项目主管</a>
                                                            </span>
                                                        </div>
                                                        <div>
                                                            <span class="Value" id="To_Email"></span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">
                                                        <div style="padding-bottom: 0;">
                                                            <span><a onclick="OpenSelectPage('Cc')">抄送:</a></span>
                                                            <span>
                                                                <a id="cc_me" onclick="CcToMe()">自己</a>
                                                            </span>
                                                        </div>
                                                        <div>
                                                            <span class="Value" id="Cc_Email"></span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">
                                                        <div style="padding-bottom: 0;">
                                                            <span><a onclick="OpenSelectPage('Bcc')">密送:</a></span>

                                                        </div>
                                                        <div>
                                                            <span class="Value" id="Bcc_Email"></span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="100%">主题
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 610px;" id="subject" name="subject" value="" />
                                                        </span>
                                                    </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="100%">其他邮件文本
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <textarea style="min-height: 100px; width: 610px;" id="otherEmail" name="otherEmail"></textarea>
                                                        </span>
                                                    </div>
                                                        <input type="hidden" name="NoToMe" id="NoToMe" />
                                                        <input type="hidden" name="NoToTeamMem" id="NoToTeamMem" />
                                                        <input type="hidden" name="NoToProlead" id="NoToProlead" />

                                                        <input type="hidden" name="NoToContactIds" id="NoToContactIds" />
                                                        <input type="hidden" name="NoToResIds" id="NoToResIds" />
                                                        <input type="hidden" name="NoToDepIds" id="NoToDepIds" />
                                                        <input type="hidden" name="NoToWorkIds" id="NoToWorkIds" />
                                                        <input type="hidden" name="NoToOtherMail" id="NoToOtherMail" />

                                                        <input type="hidden" name="NoCcMe" id="NoCcMe" />
                                                        <input type="hidden" name="NoCcContactIds" id="NoCcContactIds" />
                                                        <input type="hidden" name="NoCcResIds" id="NoCcResIds" />
                                                        <input type="hidden" name="NoCcDepIds" id="NoCcDepIds" />
                                                        <input type="hidden" name="NoCcWorkIds" id="NoCcWorkIds" />
                                                        <input type="hidden" name="NoCcOtherMail" id="NoCcOtherMail" />

                                                        <input type="hidden" name="NoBccContactIds" id="NoBccContactIds" />
                                                        <input type="hidden" name="NoBccResIds" id="NoBccResIds" />
                                                        <input type="hidden" name="NoBccDepIds" id="NoBccDepIds" />
                                                        <input type="hidden" name="NoBccWorkIds" id="NoBccWorkIds" />
                                                        <input type="hidden" name="NoBccOtherMail" id="NoBccOtherMail" />



                                                        <input type="hidden" name="IsCopyProjectSet" id="IsCopyProjectSet" />
                                                        <input type="hidden" name="IsCopyCalendarItem" id="IsCopyCalendarItem" />
                                                        <input type="hidden" name="IsCopyProjectCharge" id="IsCopyProjectCharge" />
                                                        <input type="hidden" name="IsCopyTeamMember" id="IsCopyTeamMember" />
                                                        <input type="hidden" name="fromTempId" id="fromTempId" />

                                                        <input type="hidden" name="tempChoTaskIds" id="tempChoTaskIds" />
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%} %>
        </div>
        <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 100;" id="Nav2">
            <div>
                <input type="hidden" id="DivChooseTaskIds" />
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton"></div>
                    <div class="TitleBar">
                        <div class="Title">
                            <span class="text">从模板导入</span>
                        </div>
                    </div>
                    <div class="ScrollingContentContainer">
                        <div class="ScrollingContainer" style="height: 394px;" id="FirstStep2">

                            <div class="WizardProgressBar">
                                <div style="width: 25%;" class="Item Current">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择模板</div>
                                </div>
                                <%if (!string.IsNullOrEmpty(isFromTemp))
                                    { %>
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">常规信息</div>
                                </div>
                                <%} %>
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择日程表条目</div>
                                </div>
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择附加条目</div>
                                </div>
                            </div>
                            <div class="DivSectionWithHeader">
                                <div class="HeaderRow">
                                    <span class="lblNormalClass">选择模板</span>
                                </div>
                                <div class="Content">
                                    <div class="DescriptionText">选择要从其导入日程表条目的模板 </div>
                                    <table class="Neweditsubsection" style="width: 770px;" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div>
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <tbody>
                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">项目模板
                                                                <div>
                                                                    <span style="display: inline-block;">
                                                                        <asp:DropDownList ID="project_temp" runat="server" Width="320px"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="ButtonContainer Footer Wizard">
                                <ul>
                                    <li class="Button ButtonIcon MoveRight PushRight" id="down1_2">
                                        <span class="Icon Next"></span>
                                        <span class="Text">下一步</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <!--通过模板新增-->
                        <div class="ScrollingContainer" style="height: 394px; display: none;" id="AddStep2">

                            <div class="WizardProgressBar">
                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择模板</div>
                                </div>
                                <%if (!string.IsNullOrEmpty(isFromTemp))
                                    { %>
                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">常规信息</div>
                                </div>
                                <%} %>
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择日程表条目</div>
                                </div>
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择附加条目</div>
                                </div>
                            </div>
                            <div class="DivSectionWithHeader">
                                <div class="HeaderRow">
                                    <span class="lblNormalClass">常规信息</span>
                                </div>
                                <div class="Content">
                                    <div class="DescriptionText">此页面上值为选定模板的值，您可以修改。</div>
                                    <table class="Neweditsubsection" style="width: 770px;" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div style="height: 180px; overflow-y: auto;">
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <tbody>
                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">客户
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="text" style="width: 250px;" id="temp_account_id" value="<%=account==null?"":account.name %>" /></span>
                                                                            <input type="hidden" id="temp_account_idHidden" value="<%=account==null?"":account.id.ToString() %>" />
                                                                            <a class="DataSelectorLinkIcon" onclick="TempChooseAccount()">
                                                                                <img src="../Images/data-selector.png" /></a>
                                                                        </div>
                                                                    </td>
                                                                    <td class="FieldLabel">类型
                                                                        <div>
                                                                            <asp:DropDownList ID="temp_type_id" runat="server" Width="264px"></asp:DropDownList>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">标题<span style="color: Red;">*</span>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="text" style="width: 250px;" id="temp_name" /></span>
                                                                        </div>
                                                                    </td>
                                                                    <td class="FieldLabel">业务范围
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <asp:DropDownList ID="temp_line_of_business_id" runat="server" CssClass="txtBlack8Class" Width="264px"></asp:DropDownList>
                                                                            </span>
                                                                        </div>
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">
                                                                        <span>开始日期<span style="color: Red;">*</span></span>
                                                                        <span style="margin-left: 31px;">结束日期<span style="color: Red;">*</span></span>
                                                                        <span style="margin-left: 29px;">持续时间<span style="color: Red;">*</span></span>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="text" style="width: 72px;" onclick="WdatePicker()" class="Wdate" id="temp_start_date" />
                                                                                <input type="text" style="width: 72px;" onclick="WdatePicker()" class="Wdate" id="temp_end_date" />
                                                                                <input type="text" style="width: 70px;" id="temp_duration" />

                                                                            </span>
                                                                        </div>
                                                                    </td>
                                                                    <td class="FieldLabel" width="50%">部门
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <asp:DropDownList ID="temp_department_id" runat="server" Width="264px"></asp:DropDownList>
                                                        </span>
                                                    </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">项目主管
                                                                            <div>
                                                                                <span style="display: inline-block;">
                                                                                    <asp:DropDownList ID="temp_owner_resource_id" runat="server"></asp:DropDownList>

                                                                                </span>
                                                                            </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="4" class="FieldLabel">描述
                                                                        <div>
                                                                            <textarea style="min-height: 100px; width: 625px;" id="temp_description"></textarea>
                                                                        </div>
                                                                        <div class="CharacterInformation"><span class="CurrentCount" id="tempTextNum">0</span>/<span class="Maximum">1000</span></div>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <input type="hidden" id="temp_resource_daily_hours" />
                            <input type="hidden" id="temp_useResource_daily_hours" />
                            <input type="hidden" id="temp_excludeWeekend" />
                            <input type="hidden" id="temp_excludeHoliday" />
                            <input type="hidden" id="temp_organization_location_id" />
                            <input type="hidden" id="temp_warnTime_off" />
                            <div class="ButtonContainer Footer Wizard">
                                <ul>
                                    <li class="Button ButtonIcon MoveRight PushLeft" id="prev2_2">
                                        <span class="Icon Prev"></span>
                                        <span class="Text">上一步</span>
                                    </li>
                                    <li class="Button ButtonIcon MoveRight PushRight" id="down2_2">
                                        <span class="Icon Next"></span>
                                        <span class="Text">下一步</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="ScrollingContainer" style="height: 394px; display: none;" id="SecondStep2">

                            <div class="WizardProgressBar">
                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择模板</div>
                                </div>
                                <%if (!string.IsNullOrEmpty(isFromTemp))
                                    { %>
                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">常规信息</div>
                                </div>
                                <%} %>
                                <div style="width: 25%;" class="Item Current">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择日程表条目</div>
                                </div>
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择附加条目</div>
                                </div>
                            </div>
                            <div class="DivSectionWithHeader">
                                <div class="HeaderRow">
                                    <span class="lblNormalClass">选择日程表条目</span>
                                </div>
                                <div class="Content" style="padding-bottom: 12px;">
                                    <div class="DescriptionText">选择您要添加到此项目的任务/阶段</div>
                                    <table class="Neweditsubsection" style="width: 770px;" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div class="HeaderContainer" style="padding-bottom: 0;">
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <colgroup>
                                                                <col class="Interaction">
                                                                <col class="Nesting">
                                                                <col class="Text">
                                                            </colgroup>
                                                            <tbody>
                                                                <tr class="HeadingRow">
                                                                    <td class="Interaction">
                                                                        <input type="checkbox" style="vertical-align: middle;" id="CheckAll_2">
                                                                    </td>
                                                                    <td class="Nesting">
                                                                        <span>任务/阶段/问题</span>
                                                                    </td>
                                                                    <td class="Text">
                                                                        <span>前置条件</span>
                                                                    </td>
                                                                    <td style="width: 7px; border-right: none;"></td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="RowContainer" style="padding-bottom: 0;">
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <colgroup>
                                                                <col class="Interaction">
                                                                <col class="Nesting">
                                                                <col class="Text">
                                                            </colgroup>
                                                            <tbody id="choProTaskList">
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="ButtonContainer Footer Wizard">
                                <ul>
                                    <li class="Button ButtonIcon MoveRight PushLeft" id="prev3_2">
                                        <span class="Icon Prev"></span>
                                        <span class="Text">上一步</span>
                                    </li>
                                    <li class="Button ButtonIcon MoveRight PushRight" id="down3_2">
                                        <span class="Icon Next"></span>
                                        <span class="Text">下一步</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <input type="hidden" id="TempChooseTaskids" />
                        <div class="ScrollingContainer" style="height: 394px; display: none;" id="ThirdStep2">

                            <div class="WizardProgressBar">
                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择模板</div>
                                </div>
                                <%if (!string.IsNullOrEmpty(isFromTemp))
                                    { %>
                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">常规信息</div>
                                </div>
                                <%} %>
                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择日程表条目</div>
                                </div>
                                <div style="width: 25%;" class="Item Current">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择附加条目</div>
                                </div>
                            </div>
                            <div class="DivSectionWithHeader">
                                <div class="HeaderRow">
                                    <span class="lblNormalClass">选择日程表条目</span>
                                </div>
                                <div class="Content">
                                    <div class="DescriptionText">您可以复制日历条目、项目成本、项目成员和项目设置信息。为了保证任务和问题的主负责人和其他员工有效，需要选择复制项目成员。</div>
                                    <table class="Neweditsubsection" style="width: 770px;" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div>
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <tbody>
                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">从项目模板复制:
                                                                <div>
                                                                    <span style="display: inline-block;">
                                                                        <input type="checkbox" style="vertical-align: middle;" id="temp_CalendarItems" />
                                                                        <label for="CalendarItems">日历条目</label>
                                                                    </span>
                                                                </div>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="checkbox" style="vertical-align: middle;" id="temp_ProjectCharges">
                                                                                <label for="ProjectCharges">项目成本</label>
                                                                            </span>
                                                                        </div>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="checkbox" style="vertical-align: middle;" id="temp_TeamMembers">
                                                                                <label for="TeamMembers">项目成员</label>
                                                                            </span>
                                                                        </div>
                                                                        <%if (!string.IsNullOrEmpty(isFromTemp))
                                                                            { %>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="checkbox" style="vertical-align: middle;" id="temp_projectSet" />
                                                                                <label for="TeamMembers">项目设置</label>
                                                                            </span>
                                                                        </div>
                                                                        <%} %>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="ButtonContainer Footer Wizard">
                                <ul>
                                    <li class="Button ButtonIcon MoveRight PushLeft" id="prev4_2">
                                        <span class="Icon Prev"></span>
                                        <span class="Text">上一步</span>
                                    </li>
                                    <li class="Button ButtonIcon MoveRight PushRight" id="Finish_2">
                                        <span class="Icon" style="width: 0; margin: 0;"></span>
                                        <span class="Text">完成</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--黑色幕布-->
        <div id="BackgroundOverLay"></div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    var colors = ["#efefef", "white"];
    var index1 = 0; var index2 = 0; var index3 = 0; var index4 = 0; var index5 = 1; var index6 = 1; var index7 = 1; var index8 = 1; var index9 = 0;
    $(".Toggle1").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index1 % 2]);
        index1++;
    });
    $(".Toggle2").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index2 % 2]);
        index2++;
    });
    $(".Toggle3").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index3 % 2]);
        index3++;
    });
    $(".Toggle4").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index4 % 2]);
        index4++;
    });
    $(".Toggle5").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index5 % 2]);
        index5++;
    });
    $(".Toggle6").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index6 % 2]);
        index6++;
    });
    $(".Toggle7").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index7 % 2]);
        index7++;
    });
    $(".Toggle8").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index8 % 2]);
        index8++;
    });
    $(".Toggle9").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index9 % 2]);
        index9++;
    });
    $("#ImportFromTemplateButton").on("click", function () {
        $("#Nav2").show();
        $("#BackgroundOverLay").show();
    });
    $(".CancelDialogButton").on("click", function () {
        $("#Nav2").hide();
        $("#BackgroundOverLay").hide();
        $("#FirstStep").show();
        $("#SecondStep").hide();
        $("#ThirdStep").hide();
    });
    $("#down1").on("click", function () {
        $("#FirstStep").hide();
        $("#SecondStep").show();
    });
    $("#prev2").on("click", function () {
        $("#FirstStep").show();
        $("#SecondStep").hide();
    });
    $("#down2").on("click", function () {
        $("#SecondStep").hide();
        $("#ThirdStep").show();
    });
    $("#prev3").on("click", function () {
        $("#SecondStep").show();
        $("#ThirdStep").hide();
    });

    //缩进
    function Style() {
        for (i in $(".Spacer")) {
            var Width = $(".Spacer").eq(i).parent().attr('data-depth') * 22 + 'px';
            $(".Spacer").eq(i).width(Width).css('min-width', Width);
        }
    }
    Style();
    //选中及其子集
    //$(".RowContainer .HighImportance>.Interaction").on("mousedown", function (e) {
    //    debugger;
    //    var ev = window.event || e;
    //    var _this = $(this).parent();
    //    if (event.shiftKey == 1) {
    //    } else {
    //        _this.siblings().removeClass('Selected');
    //    }
    //    _this.addClass('Selected');
    //    var str = _this.find('.DataDepth').attr('data-depth');
    //    for (i in _this.nextAll()) {
    //        if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth')) {
    //            _this.addClass('Selected');
    //            _this.nextAll().eq(i).addClass('Selected');

    //        } else {
    //            return false;
    //        }
    //    }

    //});

    $(".RowContainer .HighImportance>.Interaction").on("click", function () {
        debugger;
        var _this = $(this).parent();
        _this.siblings().removeClass('Selected');
        _this.addClass('Selected');
        var str = _this.find('.DataDepth').attr('data-depth');
        for (i in _this.nextAll()) {
            if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth')) {
                _this.addClass('Selected');
                _this.nextAll().eq(i).addClass('Selected');

            } else {
                return false;
            }
        }
    });
    //缩小展开
 

    $("#CheckAll").on("click", function () {
        var _this = $(this);
        if (_this.is(":checked")) {
            $(".HighImportance").addClass('Selected');
        } else {
            $(".HighImportance").removeClass('Selected');
        }
    });


    $("#down1_2").on("click", function () {

        var project_temp = $("#project_temp").val();
        if (project_temp != undefined & project_temp != "" && project_temp != "0") {
              <%if (!string.IsNullOrEmpty(isFromTemp))
    { %>
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=GetSinProject&project_id=" + project_temp,
                dataType: 'json',
                success: function (data) {
                    if (data != "") {
                        $("#temp_name").val(data.name);
                        // $("#temp_account_idHidden").val(data.account_id);
                        $("#temp_line_of_business_id").val(data.line_of_business_id);

                        var tempStartDate = new Date(data.start_date);
                        var startDate = tempStartDate.getFullYear() + '-' + Number(tempStartDate.getMonth() + 1) + '-' + tempStartDate.getDate();
                        $("#temp_start_date").val(startDate);

                        var tempEndDate = new Date(data.end_date);
                        var endDate = tempEndDate.getFullYear() + '-' + Number(tempEndDate.getMonth() + 1) + '-' + tempEndDate.getDate();
                        $("#temp_end_date").val(endDate);


                        $("#temp_duration").val(data.duration);
                        $("#temp_department_id").val(data.department_id);
                        $("#temp_owner_resource_id").val(data.owner_resource_id);
                        $("#temp_description").text(data.description);
                        $("#tempTextNum").text(data.description.length);
                        $("#temp_resource_daily_hours").val(data.resource_daily_hours);
                        $("#temp_useResource_daily_hours").val(data.use_resource_daily_hours);
                        $("#temp_excludeWeekend").val(data.exclude_weekend);
                        $("#temp_excludeHoliday").val(data.exclude_holiday);
                        $("#temp_organization_location_id").val(data.organization_location_id);
                        $("#temp_warnTime_off").val(data.warn_time_off);

                    }
                },
            });
                                    <%}%>
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=GetTaskList&showType=Precondition&project_id=" + project_temp,
                success: function (data) {
                    if (data != "") {
                        $("#choProTaskList").html(data);
                    } else {
                        $("#choProTaskList").html("");
                    }
                },
            });
            $(".RowContainer .HighImportance>.Interaction").on("click", function () {
                debugger;
                var _this = $(this).parent();
                _this.siblings().removeClass('Selected');
                _this.addClass('Selected');
                var str = _this.find('.DataDepth').attr('data-depth');
                for (i in _this.nextAll()) {
                    if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth')) {
                        _this.addClass('Selected');
                        _this.nextAll().eq(i).addClass('Selected');

                    } else {
                        return false;
                    }
                }
            });
            $(".IconContainer").on('click', function () {
                $(this).find('.Vertical').toggle();
                var _this = $(this).parent().parent().parent();
                var str = _this.find('.DataDepth').attr('data-depth');
                console.log(str);
                for (i in _this.nextAll()) {
                    if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth') && $(this).find('.Vertical').css('display') == 'block') {
                        _this.nextAll().eq(i).hide();
                        _this.nextAll().eq(i).find('.Vertical').show();
                    } else if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth') && $(this).find('.Vertical').css('display') == 'none') {
                        _this.nextAll().eq(i).show();
                        _this.nextAll().eq(i).find('.Vertical').hide();
                    } else if (str >= _this.nextAll().eq(i).find('.DataDepth').attr('data-depth')) {
                        return false;
                    }
                }
            });

            $("#FirstStep2").hide();
          <%if (!string.IsNullOrEmpty(isFromTemp))
    { %>
            $("#AddStep2").show();

            <%}
    else
    {%>
            $("#SecondStep2").show();

          <%}%>
        } else {
            LayerMsg("请选择项目模板");
        }


    });
    $("#prev2_2").on("click", function () {
        $("#FirstStep2").show();
        $("#AddStep2").hide();
    });
    $("#down2_2").on("click", function () {

        var temp_name = $("#temp_name").val();
        if (temp_name == "") {
            LayerMsg("请填写标题！");
            return false;
        }
        var temp_start_date = $("#temp_start_date").val();
        if (temp_start_date == "") {
            LayerMsg("请填写开始时间！");
            return false;
        }
        var temp_end_date = $("#temp_end_date").val();
        if (temp_end_date == "") {
            LayerMsg("请填写结束时间！");
            return false;
        }
        var temp_duration = $("#temp_duration").val();
        if (temp_duration == "") {
            LayerMsg("请填写持续时间！");
            return false;
        }

        $("#AddStep2").hide();
        $("#SecondStep2").show();
    });
    $("#prev3_2").on("click", function () {
          <%if (!string.IsNullOrEmpty(isFromTemp))
    { %>
        $("#AddStep2").show();

        <%}
    else
    {%>
        $("#FirstStep2").show();

        <%}%>
        $("#SecondStep2").hide();
    });
    $("#down3_2").on("click", function () {
        // SecondStep2
        var ids = "";
        $("#SecondStep2 tr").each(function () {
            if ($(this).hasClass("Selected")) {
                ids += $(this).val() + ","
            }
        })
        if (ids == "") {
            LayerConfirm("未选择任何条目，是否继续", "确认", "取消", function () {
                debugger;

                $("#SecondStep2").hide();
                $("#ThirdStep2").show();
                $("#TempChooseTaskids").val("");
            }, function () { });
        } else {
            ids = ids.substring(0, ids.length - 1);
            $("#SecondStep2").hide();
            $("#ThirdStep2").show();
            $("#TempChooseTaskids").val(ids);
        }


    });
    $("#prev4_2").on("click", function () {
        $("#SecondStep2").show();
        $("#ThirdStep2").hide();
    });


</script>

<script>
    // ------finish 点击之后 禁用从模板获取
    $(function () {
        // display: block;
        var isFromTemp = '<%=isFromTemp %>';
        if (isFromTemp != "") {  // 从模板获取
            $("#Nav2").show();
            $("#BackgroundOverLay").show();
            $("#temp_description").keyup(function () {
                debugger;
                var thisValue = $(this).val();
                if (thisValue.length >= 1000) {
                    thisValue = thisValue.substring(0, 999);
                    $(this).val(thisValue);
                }
                else {
                    $("#tempTextNum").html(thisValue.length);
                }
            })
            //document.getElementById('temp_description').onkeydown = function () {
            //    if (this.value.length >= 1000) {
            //        event.returnValue = false;
            //    } else {
            //        $("#tempTextNum").text(this.value.length+1);
            //    }

            //} 
        }

        <%if (!isAdd)
    { %>
        <%if (taskList != null && taskList.Count > 0)
    {%>
        $("#start_date").prop("disabled", true);
             <%}%>

            $("#account_id").prop("disabled", true);
            $("#AChoAcc").removeAttr("onclick");
            $("#AChoAcc").removeClass("DisabledState");
            //$("#AChoossCon").removeAttr("onclick");
            $("#AAddCon").removeAttr("onclick");          // contract_id
            $("#contract_id").prop("disabled", true);
            //$("#AChoossCon").addClass("DisabledState");
            $("#AAddCon").addClass("DisabledState");
            //$("#AChoossCon").css("display", "none");
            $("#AAddCon").css("display", "none");
            $("#AChoC").css("display", "none");
            $("#AChoC").removeAttr("onclick");
            jiSuan();
            $("#AchoResDep").css("display", "none");
            $("#inChosREsdep").prop("disabled", true);
            $("#resDepList").prop("disabled", true);
            $("#conIds").prop("disabled", true);
            $("#textChoosAccount").val("");
            $("#opportunity_id").prop("disabled", false);
            $("#contract_id").prop("disabled", false);
            GetOppByAccount();
            var oppid = "<%=(!isAdd)&&thisProject.opportunity_id!=null?thisProject.opportunity_id.ToString():"" %>";
        if (oppid != "") {
            $("#opportunity_id").val(oppid);
        }
        <% }%>
    })

    $("#CancelButton").click(function () {
        window.close();
    })
    $("#save").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })

    $("#Finish_2").click(function () {
        $("#Nav2").hide();
        $("#BackgroundOverLay").hide();
        $("#ImportFromTemplateButton").hide();  // 完成之后隐藏从模板导入功能

        <%if (!string.IsNullOrEmpty(isFromTemp))
    { %> // 客户基本信息相关
        var temp_account_id = $("#temp_account_idHidden").val();
        if (temp_account_id != "") {
            $("#account_idHidden").val(temp_account_id);
            $("#account_id").val($("#temp_account_id").val());
        }
        var temp_type_id = $("#temp_type_id").val();
        if (temp_type_id != undefined && temp_type_id != "") {
            $("#type_id").val(temp_type_id);
        }

        var temp_name = $("#temp_name").val();
        $("#name").val(temp_name);

        var temp_line_of_business_id = $("#temp_line_of_business_id").val();
        if (temp_line_of_business_id != undefined && temp_line_of_business_id != "") {
            $("#line_of_business_id").val(temp_line_of_business_id);
        }

        $("#start_date").val($("#temp_start_date").val());
        $("#end_date").val($("#temp_end_date").val());
        $("#duration").val($("#temp_duration").val());
        var temp_department_id = $("#temp_department_id").val();
        if (temp_department_id != undefined && temp_department_id != "") {
            $("#department_id").val(temp_department_id);
        }

        var temp_owner_resource_id = $("#temp_owner_resource_id").val();
        if (temp_owner_resource_id != undefined && temp_owner_resource_id != "") {
            $("#owner_resource_id").val(temp_owner_resource_id);
        }

        var temp_description = $("#temp_description").val().trim();
        if (temp_description != "") {
            $("#description").val(temp_description);
        }
        if ($("#temp_projectSet").is(":checked")) {
            $("#IsCopyProjectSet").val("1");
            // 员工设置--日程表和项目成员工作量相关
            $("#resource_daily_hours").val(toDecimal2($("#temp_resource_daily_hours").val()));
            var dayHour = $("#temp_useResource_daily_hours").val();
            if (dayHour == "1") {
                $("#useResource_daily_hours").prop("checked", true);
            }
            else if (dayHour == "0") {
                $("#useResource_daily_hours").prop("checked", false);
            }
            var exWeek = $("#temp_excludeWeekend").val();
            if (exWeek == "1") {
                $("#excludeWeekend").prop("checked", true);
            }
            else if (exWeek == "0") {
                $("#excludeWeekend").prop("checked", false);
            }

            var exHol = $("#temp_excludeHoliday").val();
            if (exHol == "1") {
                $("#excludeHoliday").prop("checked", true);
            }
            else if (exHol == "0") {
                $("#excludeHoliday").prop("checked", false);
            }
            var loca_id = $("#temp_organization_location_id").val();
            if (loca_id != undefined && loca_id != "" && loca_id != "0") {
                $("#organization_location_id").val(loca_id);
            }
            var waOff = $("#temp_warnTime_off").val();
            if (waOff == "1") {
                $("#warnTime_off").prop("checked", true);
            }
            else if (waOff == "0") {
                $("#warnTime_off").prop("checked", false);
            }


        }
        <% }%>
        if ($("#temp_CalendarItems").is(":checked")) {
            $("#IsCopyCalendarItem").val("1");
        }
        if ($("#temp_ProjectCharges").is(":checked")) {
            $("#IsCopyProjectCharge").val("1");
        }
        if ($("#temp_TeamMembers").is(":checked")) {
            $("#IsCopyTeamMember").val("1");
            <%if (isAdd)
    { %>
            var resDepIdsHidden = $("#resDepIdsHidden").val();
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=GetProResDepIds&project_id=" + $("#project_temp").val() + "&ids=" + resDepIdsHidden,
                success: function (data) {
                    if (data != "") {
                        $("#resDepIdsHidden").val(data);
                        GetResDep();
                    }
                },
            });
            <%} %>
            //GetResDep();

        }
        $("#fromTempId").val($("#project_temp").val());
        $("#tempChoTaskIds").val($("#TempChooseTaskids").val());
    })

    $("#template_id").change(function () {
        GetInfoByTemp();
    })
    $("#owner_resource_id").change(function () {
        ToProjectLeadSum = 0;
    })

    $(".NewEditProject_NumberField").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && (!isNaN(thisValue))) {
            $(this).val(toDecimal2(thisValue));
        }
        else {
            $(this).val("0.00");
        }
        jiSuan();
    })

    $(".NewEditProject_PaddingRight").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && (!isNaN(thisValue))) {
            $(this).val(toDecimal2(thisValue));
        }
        else {
            $(this).val("0.00");
        }
    })
    $("#original_sgda").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && (!isNaN(thisValue))) {
            if (Number(thisValue) >= 100) {
                $(this).val("100.00");
            } else if (Number(thisValue <= 0)) {
                $(this).val("0.00");
            }
            else {
                $(this).val(toDecimal2(thisValue));
            }
        } else {
            $(this).val("0.00");
        }
    })

    function jiSuan() {
        // toDecimal2
        var labor_revenue = $("#labor_revenue").val();
        var labor_budget = $("#labor_budget").val();
        var labor_profit = 0;
        if (labor_revenue != "" && (!isNaN(labor_revenue)) && labor_budget != "" && (!isNaN(labor_budget))) {
            labor_profit = Number(labor_revenue) - Number(labor_budget);
            $("#labor_profit").html(toDecimal2(labor_profit));
            var this_labor_revenue = 1;
            var this_labor_profit = 0;
            if (labor_revenue != 0) {
                this_labor_revenue = labor_revenue;
                this_labor_profit = labor_profit;
            }
            var margin = (Number(this_labor_profit) * 100) / Number(this_labor_revenue);
            $("#div_labor_margin").html(toDecimal2(margin));
            $("#labor_margin").html(toDecimal2(margin));
        } else {
            $("#labor_profit").html("0.00");
            $("#div_labor_margin").html("0.00");
            $("#labor_margin").html("0.00");
        }

        var cost_revenue = $("#cost_revenue").val();
        var cost_budget = $("#cost_budget").val();
        var cost_profit = 0;
        if (cost_revenue != "" && (!isNaN(cost_revenue)) && cost_budget != "" && (!isNaN(cost_budget))) {
            cost_profit = Number(cost_revenue) - Number(cost_budget);
            $("#cost_profit").html(toDecimal2(cost_profit));
            var this_cost_revenue = 1;
            var this_cost_profit = 0;
            if (cost_revenue != 0) {
                this_cost_revenue = cost_revenue;
                this_cost_profit = cost_profit;
            }
            var margin = (Number(this_cost_profit) * 100) / Number(this_cost_revenue);
            $("#div_cost_margin").html(toDecimal2(margin));
            $("#cost_margin").html(toDecimal2(margin));
        } else {
            $("#cost_profit").html("0.00");
            $("#div_cost_margin").html("0.00");
            $("#cost_margin").html("0.00");
        }

        var totalRevenue = Number(labor_revenue) + Number(cost_revenue);
        $("#total_revenue").html(toDecimal2(totalRevenue));
        var totalBudget = Number(labor_budget) + Number(cost_budget);
        $("#total_budget").html(toDecimal2(totalBudget));
        var totalProfit = Number(labor_profit) + Number(cost_profit);
        $("#total_profit").html(toDecimal2(totalProfit));
        if (totalRevenue == 0) {
            totalRevenue = 1;
            totalProfit = 0;
        }
        var totalMargin = (Number(totalProfit) * 100) / Number(totalRevenue);
        $("#total_margin").html(toDecimal2(totalMargin));
    }
    // 从模板导入
    function ShowTemp(isFromTemp) {
        if (isFromTemp == "1") { // 页面开始就根据模板进行添加--四个页面

        }
        else {  // 页面加载后根据模板进行添加 -- 三个页面

        }
    }

    function ChooseAccount() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=account_id&callBack=GetDataByAccount", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByAccount() {
        // 获取商机信息，联系人信息为页面下拉框赋值  DisabledState
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "") {
            // 修改合同  -- 商机-- 联系人样式
            $("#AChoossCon").click(function () {
                ChooseContract();
            })
            $("#AChoossCon").removeClass("DisabledState");
            $("#AAddCon").click(function () {
                AddContract();
            })
            $("#AAddCon").removeClass("DisabledState");
            $("#contract_id").prop("disabled", false);
            $("#AChoC").removeClass("DisabledState");
            $("#opportunity_id").html("");
            $("#conIds").prop("disabled", false);
            $("#textChoosAccount").prop("disabled", false);
            $("#textChoosAccount").val("");
            $("#opportunity_id").prop("disabled", false);
            GetOppByAccount();

            ToTeamMember();
            ToTeamMemberSum = 0;

        } else {
            $("#AChoossCon").removeAttr("onclick");
            $("#AAddCon").removeAttr("onclick");// contract_id
            $("#contract_id").prop("disabled", true);
            $("#AChoossCon").addClass("DisabledState");
            $("#AAddCon").addClass("DisabledState");
            $("#AChoC").addClass("DisabledState");
        }

    }


    function GetOppByAccount() {
        debugger;
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "") {
            $("#opportunity_id").html("");
            $.ajax({
                type: "GET",
                url: "../Tools/OpportunityAjax.ashx?act=GetAccOpp&account_id=" + account_idHidden,
                async: false,
                //dataType:"json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        $("#opportunity_id").html(data);
                    }
                }
            })
        }
    }
    function TempChooseAccount() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=temp_account_id", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }

    // 选择合同
    function ChooseContract() {
        // 本公司或者父公司的合同
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "") {
            // 1。获取父客户ID

            $.ajax({
                type: "GET",
                url: "../Tools/CompanyAjax.ashx?act=property&property=parent_id&account_id=" + account_idHidden,
                async: false,
                //dataType:"json",
                success: function (data) {
                    debugger;
                    if (data != undefined && data != "" && data != null) {
                        account_idHidden += "," + data;
                    }
                }
            })
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACTMANAGE_CALLBACK %>&field=contract_id&con627=" + account_idHidden, "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>", 'left=200,top=200,width=600,height=800', false);


        } else {
            LayerMsg("请先选择客户");
        }
    }

    function GetDataByContract() {
        // 如果所选合同的开始日期在项目的开始日期之后，或者结束日期在项目的结束日期之前，则会提醒。选择确定，可以继续
    }
    function AddContract() {
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "") {
            // 获取父客户ID，有就传两个ID
            // 
        } else {
            LayerMsg("请先选择客户");
        }
    }
    // 查找
    function ChooseResDep() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&field=resDepIds&muilt=1&callBack=GetResDep", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function GetResDep() {
        debugger;
        var resDepIds = $("#resDepIdsHidden").val();
        if (resDepIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=GetResDepList&resDepIds=" + resDepIds,
                async: false,
                //dataType:"json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        $("#resDepList").html(data);
                        $("#resDepList option").dblclick(function () {
                            RemoveResDep(this);
                        })
                    }
                }

            })
        }
    }

    function RemoveResDep(val) {
        $(val).remove();
        var ids = "";
        $("#resDepList option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#resDepIdsHidden").val(ids);
    }

    // 选择联系人
    function ChooseContact() {
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_CALLBACK %>&field=contactID&muilt=1&callBack=GetContact&con628=" + account_idHidden, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactCallBack %>', 'left=200,top=200,width=600,height=800', false);

        } else {
            LayerMsg("请先选择客户");
        }
    }
    // 根据邮件模板获取通知相关信息
    function GetInfoByTemp() {
        var template_id = $("#template_id").val();
        if (template_id != undefined && template_id != "" && template_id != "0") {
            $.ajax({
                type: "GET",
                url: "../Tools/GeneralAjax.ashx?act=GetNotiTempEmail&temp_id=" + template_id,
                async: false,
                dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        $("#From_Email").html(data.from_other_email);
                        $("#subject").val(data.subject);
                    }
                }

            })
        }
    }

    var ToMeSum = 0;
    function ToMe() {
        var userEmail = GetMeEmail();
        if (userEmail != "") {

            if (ToMeSum == 0) {
                ToMeSum += 1;
                $("#NoToMe").val("1");
                var To_Email = $("#To_Email").html();
                if (To_Email != "") {
                    $("#To_Email").html(To_Email + ';' + userEmail);
                } else {
                    $("#To_Email").html(userEmail);
                }
            }
        }
    }
    function GetMeEmail() {
        <% var user = EMT.DoneNOW.BLL.UserInfoBLL.GetUserInfo(GetLoginUserId()); %>
        var userEmail = "";
        <% if (user != null)
    {%>
        userEmail = '<%=user.name %>';
        <%}%>
        return userEmail;
    }
    function GetLeadEmail() {
        var owner_resource_id = $("#owner_resource_id").val();
        var leadEma = "";
        if (owner_resource_id != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetInfo&id=" + owner_resource_id,
                async: false,
                dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        leadEma = data.name;
                    }
                }
            })
        }
        return leadEma;
    }

    var ToTeamMemberSum = 0;
    function ToTeamMember() {
        debugger;
        var memIDs = $("#resDepIdsHidden").val();
        if (memIDs != undefined && memIDs != "") {
            var menEmails = "";
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetResouList&ids=" + memIDs,
                async: false,
                //dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        menEmails = data;
                    }
                }
            })
            debugger;
            if (menEmails != "") {

                menEmails = menEmails.substring(0, menEmails.length - 1);
                var To_Email = $("#To_Email").html();
                if (To_Email != "") {

                    if (ToMeSum != 0) {
                        menEmails += ";" + GetMeEmail();
                    }
                    if (ToProjectLeadSum != 0) {
                        menEmails += ";" + GetLeadEmail();
                    }
                    $("#To_Email").html(menEmails);
                } else {
                    $("#To_Email").html(menEmails);
                }
            }

            // todo 联系人姓名
        }
        debugger;
        var conIds = $("#contactIDHidden").val();
        if (conIds != "") {

            $.ajax({
                type: "GET",
                url: "../Tools/ContactAjax.ashx?act=GetConName&ids=" + conIds,
                async: false,
                success: function (data) {
                    debugger;
                    if (data != "") {
                        var To_Email = $("#To_Email").html();
                        if (To_Email != "") {
                            $("#To_Email").html(To_Email + data);
                        } else {
                            data = data.substring(1, data.length);
                            $("#To_Email").html(data);
                        }
                        $("#NoToContactIds").val(conIds);
                    }
                }
            })
        }

        // alert(conText);
    }
    var ToProjectLeadSum = 0;
    function ToProjectLead() {
        var owner_resource_id = $("#owner_resource_id").val();
        if (owner_resource_id != "") {
            var resouEmail = "";
            resouEmail = GetLeadEmail();
            if (resouEmail != "") {
                if (ToProjectLeadSum == 0) {
                    ToProjectLeadSum += 1;
                    var NoToProlead = $("#NoToProlead").val();
                    var To_Email = $("#To_Email").html();
                    if (NoToProlead != "") {
                        var isadd = "";
                        var NoToProleadArr = NoToProlead.split(',');
                        for (i = 0; i < NoToProleadArr.length; i++) {
                            if (NoToProleadArr[i] == owner_resource_id) {
                                isadd = "1";
                                break;
                            }
                        }
                        if (isadd == "") {
                            $("#NoToProlead").val(NoToProlead + ',' + owner_resource_id);
                            if (To_Email != "") {
                                $("#To_Email").html(To_Email + ';' + resouEmail);
                            } else {
                                $("#To_Email").html(resouEmail);
                            }
                        }
                    } else {
                        $("#NoToProlead").val(owner_resource_id);
                        if (To_Email != "") {
                            $("#To_Email").html(To_Email + ';' + resouEmail);

                        } else {
                            $("#To_Email").html(resouEmail);
                        }
                    }
                }
            }
        }
    }

    var CcMeSum = 0;
    function CcToMe() {
        var userEmail = GetMeEmail();
        if (userEmail != "") {
            if (CcMeSum == 0) {
                CcMeSum += 1;
                $("#NoCcMe").val("1");
                var Cc_Email = $("#Cc_Email").html();
                if (Cc_Email != "") {
                    $("#Cc_Email").html(Cc_Email + ';' + userEmail);
                } else {
                    $("#Cc_Email").html(userEmail);
                }
            }
        }
    }
    function GetContact() {
        debugger;
        var contactIDHidden = $("#contactIDHidden").val();
        if (contactIDHidden != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContactAjax.ashx?act=GetConList&ids=" + contactIDHidden,
                success: function (data) {
                    if (data != "") {
                        $("#conIds").html(data);
                        $("#conIds option").dblclick(function () {
                            RemoveCon(this);
                        })

                    } else {
                        $("#conIds").html("");
                    }
                },
            });
        }
    }

    function RemoveCon(val) {
        $(val).remove();
        var ids = "";
        $("#conIds option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#contactIDHidden").val(ids);
    }

    function SubmitCheck() {
        var name = $("#name").val();
        if (name == "") {
            LayerMsg("请填写标题！");
            return false;
        }
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden == "") {
            LayerMsg("请通过查找带回选择客户！");
            return false;
        }
        var start_date = $("#start_date").val();
        if (start_date == "") {
            LayerMsg("请填写开始时间！");
            return false;
        }
        var end_date = $("#end_date").val();
        if (end_date == "") {
            LayerMsg("请填写结束时间！");
            return false;
        }
        if (new Date(start_date) > new Date(end_date)) {
            LayerMsg("开始时间要早于结束时间");
            return false;
        }
        var type_id = $("#type_id").val();
        if (type_id == "" || type_id == "0") {
            LayerMsg("请选择类型！");
            return false;
        }
        <% if (!isAdd)
    {%> // status_id
        var status_id = $("#status_id").val();
        if (status_id == "" || type_id == "0") {
            LayerMsg("请选择状态！");
            return false;
        }
        var status_time = $("#status_time").val();
        if (status_time == "") {
            LayerMsg("请填写修改时间！");
            return false;
        }
        if (status_id == '<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_STATUS.DONE %>') {
            var status_detail = $("#status_detail").val();
            if (status_detail == "") {
                LayerMsg("请填写修改说明！");
                return false;
            }
        }
        <%}%>
        debugger;
        var resource_daily_hours = $("#resource_daily_hours").val();
        if (resource_daily_hours == "") {
            LayerMsg("请填写总时间！");
            return false;
        }
        var organization_location_id = $("#organization_location_id").val();
        if (organization_location_id == "") {
            LayerMsg("请选择区域！");
            return false;
        }
        <% if (isAdd)
    {%>
        var template_id = $("#template_id").val();
        if (template_id == "") {
            LayerMsg("请选择模板！");
            return false;
        }
        <% }%>

        $("#start_date").prop("disabled", false);
        return true;
    }

    function OpenSelectPage(val) {
        var account_id = $("#account_idHidden").val();
        var url = "RecipientSelector?account_id=" + account_id + "&thisType=" + val;

        var NoContactIds = $("#No" + val + "ContactIds").val();
        if (NoContactIds != "") {
            url += "&conIds" + NoContactIds;
        }
        var NoResIds = $("#No" + val + "ResIds").val();
        if (NoResIds != "") {
            url += "&resouIds" + NoResIds;
        }
        var NoDepIds = $("#No" + val + "DepIds").val();
        if (NoDepIds != "") {
            url += "&depIds" + NoDepIds;
        }
        var NoWorkIds = $("#No" + val + "WorkIds").val();
        if (NoWorkIds != "") {
            url += "&workIds" + NoWorkIds;
        }
        var NoOtherMail = $("#No" + val + "OtherMail").val();
        if (NoOtherMail != "") {
            url += "&otherEmail" + NoOtherMail;
        }


        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.PROJECT_RECIPIENTSELECTOR %>', 'left=200,top=200,width=750,height=800', false);
    }

    function GetDataBySelectPage(val) {
        debugger;
        var thisEmailText = "";
        var NoContactIds = $("#No" + val + "ContactIds").val();
        var NoResIds = $("#No" + val + "ResIds").val();
        var NoDepIds = $("#No" + val + "DepIds").val();
        var NoWorkIds = $("#No" + val + "WorkIds").val();
        var NoOtherMail = $("#No" + val + "OtherMail").val();

        if (NoContactIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ContactAjax.ashx?act=GetConName&ids=" + NoContactIds,
                async: false,
                success: function (data) {
                    debugger;
                    if (data != "") {
                        thisEmailText += data;
                    }
                }
            })
        }
        if (NoResIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetResouList&isReSouIds=1&ids=" + NoResIds,
                async: false,
                //dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        thisEmailText += data;
                    }
                }
            })
        }
        if (NoDepIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/DepartmentAjax.ashx?act=GetNameByIds&ids=" + NoDepIds,
                async: false,
                //dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        thisEmailText += data;
                    }
                }
            })
        }
        if (NoWorkIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetWorkName&ids=" + NoWorkIds,
                async: false,
                success: function (data) {
                    debugger;
                    if (data != "") {
                        thisEmailText += data;
                    }
                }
            })
        }
        if (NoOtherMail != "") {
            thisEmailText = NoOtherMail;
        }
        if (val == "To") {
            if (ToMeSum != 0) {
                thisEmailText += GetMeEmail();
            }
            $("To_Email").html(thisEmailText);
        } else if (val == "Cc") {


            $("Cc_Email").html(thisEmailText);
        } else if (val == "Bcc") {
            $("Bcc_Email").html(thisEmailText);
        }
    }
</script>
