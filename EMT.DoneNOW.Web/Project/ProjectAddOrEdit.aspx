﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectAddOrEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectAddOrEdit" %>

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
                <li class="Button ButtonIcon NormalState" id="ImportFromTemplateButton" tabindex="0">
                    <span class="Icon" style="margin: 0; width: 0;"></span>
                    <span class="Text">从模板导入</span>
                </li>
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
                                                            <a class="DataSelectorLinkIcon" onclick="ChooseAccount()">
                                                                <img src="../Images/data-selector.png" /></a>
                                                        </div>
                                                    </td>
                                                    <td class="FieldLabel">外部号码
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" id="external_id" name="external_id" value="<%=isAdd?"":thisProject.external_id %>" /></span>
                                                    </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">
                                                        <span>开始日期<span style="color: Red;">*</span></span>
                                                        <span style="margin-left: 31px;">结束日期<span style="color: Red;">*</span></span>
                                                        <span style="margin-left: 29px;">持续时间</span>
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <input type="text" style="width: 72px;" onclick="WdatePicker()" class="Wdate" id="start_date" name="start_date" value="<%=isAdd?DateTime.Now.ToString("yyyy-MM-dd"):((DateTime)thisProject.start_date).ToString("yyyy-MM-dd") %>" />
                                                                <input type="text" style="width: 72px;" onclick="WdatePicker()" class="Wdate" id="end_date" name="end_date" value="<%=isAdd?DateTime.Now.ToString("yyyy-MM-dd"):((DateTime)thisProject.end_date).ToString("yyyy-MM-dd") %>" />
                                                                <input type="text" style="width: 70px;" id="duration" name="duration" value="<%=isAdd?"":((int)thisProject.duration).ToString() %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                                                                <span>天</span>
                                                            </span>
                                                        </div>
                                                    </td>
                                                    <td class="FieldLabel">采购订单号
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" id="purchase_order_no" name="purchase_order_no" value="<%=isAdd?"":thisProject.purchase_order_no %>" /></span>
                                                    </div>
                                                    </td>
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
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <!--状态,新增里没有-->
            <% if (!isAdd)
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
                                                                <input type="text" style="width: 72px;" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" class="Wdate" id="status_time" name="status_time" value="<%=isAdd ? "" : EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisProject.status_time).ToString("yyyy-MM-dd") %>" />
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
                                                <tr>
                                                    <td class="FieldLabel" width="50%">合同
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" id="contract_id" value="<%=contract==null?"":contract.name %>" disabled />
                                                            <input type="hidden" id="contract_idHidden" name="contract_id" value="<%=contract==null?"":contract.id.ToString() %>" />
                                                            <a class="DataSelectorLinkIcon" onclick="ChooseContract()">
                                                                <img src="../Images/data-selector.png" /></a>
                                                            <a class="DataSelectorLinkIcon" onclick="AddContract()">
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
                                                            <% EMT.DoneNOW.Core.sys_resource resource = null;
                                                                if ((!isAdd) && thisProject.owner_resource_id != null)
                                                                {
                                                                    resource = new EMT.DoneNOW.DAL.sys_resource_dal().FindNoDeleteById((long)thisProject.owner_resource_id);
                                                                }
                                                            %>
                                                            <input type="text" style="width: 250px;" id="owner_resource_id" value="<%=resource==null?"":resource.name %>">
                                                            <input type="hidden" name="owner_resource_id" id="owner_resource_idHidden" value="<%=resource==null?"":resource.id.ToString() %>" />
                                                            <a class="DataSelectorLinkIcon">
                                                                <img src="../Images/data-selector.png" /></a>
                                                        </span>
                                                    </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">项目成员和计费角色
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" />
                                                            <a class="DataSelectorLinkIcon">
                                                                <img src="../Images/data-selector.png" /></a>
                                                        </span>
                                                    </div>
                                                        <div>
                                                            <select multiple="multiple" style="width: 264px; min-height: 80px;" id="resDepList">
                                                                <% if (!isAdd)
                                                                    {
                                                                        var resouList = new EMT.DoneNOW.DAL.pro_project_team_dal().GetResListBuProId(thisProject.id);
                                                                        if (resouList != null && resouList.Count > 0)
                                                                        {
                                                                            var pptrDal = new EMT.DoneNOW.DAL.pro_project_team_role_dal();
                                                                            var syDal = new EMT.DoneNOW.DAL.sys_resource_dal();
                                                                            var srDal = new EMT.DoneNOW.DAL.sys_role_dal();

                                                                            foreach (var resou in resouList)
                                                                            {
                                                                                var teamRole = pptrDal.FindNoDeleteById(resou.id);
                                                                                if (teamRole != null)
                                                                                {
                                                                                    var thisResou = syDal.FindNoDeleteById((long)resou.resource_id);
                                                                                    var thisRole = srDal.FindNoDeleteById((long)teamRole.role_id);
                                                                                    if (thisResou != null && thisRole != null)
                                                                                    {
                                                                %>
                                                                <option><%=thisResou.name+$"({thisRole.name})" %></option>
                                                                <%
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
                                                            <input type="text" style="width: 250px;" disabled value="请选择客户" />
                                                            <a class="DataSelectorLinkIcon DisabledState">
                                                                <img src="../Images/data-selector.png" /></a>
                                                        </span>
                                                    </div>
                                                        <div>
                                                            <select multiple="multiple" style="width: 264px; min-height: 80px;" disabled id="conIds">
                                                                <%
                                                                    if (!isAdd)
                                                                    {

                                                                        var conList = new EMT.DoneNOW.DAL.pro_project_team_dal().GetConListBuProId(thisProject.id);
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
                                                                <input type="text" style="width: 250px;" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" id="resource_daily_hours" name="resource_daily_hours" value="<%=isAdd?"":thisProject.resource_daily_hours.ToString("#0.00") %>" />
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
                                    <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=project_udfValueList!=null&&project_udfValueList.Count>0?project_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
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
                                                        <input type="text" class="NewEditProject_NumberField" id="labor_revenue" name="labor_revenue"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":thisProject.labor_revenue.ToString("#0.00") %>" />
                                                    </td>
                                                    <td class="NewEditProject_Content NewEditProject_Right">
                                                        <input type="text" class="NewEditProject_NumberField" id="labor_budget" name="labor_budget"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":thisProject.labor_budget.ToString("#0.00") %>" />
                                                    </td>
                                                    <td>
                                                        <div>=</div>
                                                    </td>
                                                    <td class="NewEditProject_Content">
                                                        <div class="NewEditProject_NumberField" id="labor_profit">0.00</div>
                                                    </td>
                                                    <td class="NewEditProject_Content">
                                                        <div class="NewEditProject_NumberField" id="labor_margin">0.00</div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div>项目成本</div>
                                                    </td>
                                                    <td class="NewEditProject_Content NewEditProject_Right NewEditProject_ColumnTotal ">
                                                        <input type="text" class="NewEditProject_NumberField" id="cost_revenue" name="cost_revenue"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":thisProject.cost_revenue.ToString("#0.00") %>" />
                                                    </td>
                                                    <td class="NewEditProject_Content NewEditProject_Right NewEditProject_ColumnTotal">
                                                        <input type="text" class="NewEditProject_NumberField"  id="cost_budget" name="cost_budget"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":thisProject.cost_budget.ToString("#0.00") %>" />
                                                    </td>
                                                    <td>
                                                        <div>=</div>
                                                    </td>
                                                    <td class="NewEditProject_Content NewEditProject_ColumnTotal">
                                                        <div class="NewEditProject_NumberField"  id="cost_profit">0.00</div>
                                                    </td>
                                                    <td class="NewEditProject_Content NewEditProject_ColumnTotal">
                                                        <div class="NewEditProject_NumberField"  id="cost_margin">0.00</div>
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
                                        <input type="text" class="NewEditProject_Right NewEditProject_PaddingRight" id="original_revenue" name="original_revenue"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":thisProject.original_revenue.ToString("#0.00") %>" />
                                    </td>
                                    <td class="NewEditProject_Right">
                                        <input type="text" class="NewEditProject_Right NewEditProject_PaddingRight" id="original_sales_cost" name="original_sales_cost"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":thisProject.original_sales_cost.ToString("#0.00") %>" />
                                    </td>
                                    <td>
                                        <span>|</span>
                                    </td>
                                    <td class="NewEditProject_Right">
                                        <input type="text" class="NewEditProject_Right NewEditProject_PaddingRight" id="original_sgda" name="original_sgda"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"0.00":thisProject.original_sgda.ToString("#0.00") %>" />
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
                                                    <%
                                                        var user_id = GetLoginUserId();
                                                        var user = EMT.DoneNOW.BLL.UserInfoBLL.GetUserInfo(user_id);
                                                        %>
                                                    <td class="FieldLabel" width="50%">发件人:
                                                    <span style="font-weight: normal; color: #4f4f4f;"><%=user!=null?user.email:"" %></span>
                                                        <div style="padding-bottom: 0;">
                                                            <span><a >收件人:</a></span>
                                                            <span>
                                                                <a id="to_me">自己</a>
                                                                <a id="teamMember" style="margin-left: 5px;">团队成员</a>
                                                                <a id="ProLead" style="margin-left: 5px;">项目主管</a>
                                                            </span>
                                                        </div>
                                                        <div>
                                                            <span class="Value">li, li; li, li</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">
                                                        <div style="padding-bottom: 0;">
                                                            <span><a href="#">抄送:</a></span>
                                                            <span>
                                                                <a id="cc_me">自己</a>
                                                            </span>
                                                        </div>
                                                        <div>
                                                            <span class="Value">li, li;</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="50%">
                                                        <div style="padding-bottom: 0;">
                                                            <span><a href="#">密送:</a></span>
                                                          
                                                        </div>
                                                        <div>
                                                            <span class="Value">No Record</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="100%">主题
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 610px;" value="New Project Created: [Project: Name] - [Project: Account]" />
                                                        </span>
                                                    </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel" width="100%">其他邮件文本
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <textarea style="min-height: 100px; width: 610px;"></textarea>
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
            <%} %>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
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
</script>

<script>
    $(function () {

    })

    $("#CancelButton").click(function () {
        window.close();
    })

    function ChooseAccount() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=account_id&callBack=GetDataByAccount", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactLocationSelect %>", 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByAccount() {
        // 获取商机信息，联系人信息为页面下拉框赋值  DisabledState
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "") {

        } else {

        }

    }


    function ChooseContract() {
         // 本公司或者父公司的合同
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "") {
            

        } else {
            alert("请先选择客户");
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
            alert("请先选择客户");
        }
    }

    function SubmitCheck() {
        var name = $("#name").val();
        if (name == "") {
            alert("请填写标题！");
            return false;
        }
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden == "") {
            alert("请通过查找带回选择客户！");
            return false;
        }
        var start_date = $("#start_date").val();
        if (start_date == "") {
            alert("请填写开始时间！");
            return false;
        }
        var end_date = $("#end_date").val();
        if (end_date == "") {
            alert("请填写结束时间！");
            return false;
        }
        if (new Date(start_date) > new Date(end_date)) {
            alert("开始时间要早于结束时间");
            return false;
        }
        var type_id = $("#type_id").val();
        if (type_id == "" || type_id == "0") {
            alert("请选择类型！");
            return false;
        }
        <% if (!isAdd)
        {%> // status_id
        var status_id = $("#status_id").val();
        if (status_id == "" || type_id == "0") {
            alert("请选择状态！");
            return false;
        }
        var status_time = $("#status_time").val();
        if (status_time == "" ) {
            alert("请填写修改时间！");
            return false;
        }
        if (status_id == '<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_STATUS.DONE %>') {
            var status_detail = $("#status_detail").val();
            if (status_detail == "") {
                alert("请填写修改说明！");
                return false;
            } 
        }
        <%}%>
        var resource_daily_hours = $("#resource_daily_hours").val();
        if (resource_daily_hours == "") {
            alert("请填写总时间！");
            return false;
        }
        var organization_location_id = $("#organization_location_id").val();
        if (organization_location_id == "") {
            alert("请选择区域！");
            return false;
        }
        <% if (isAdd)
        {%>
        var template_id = $("#template_id").val();
        if (template_id == "") {
            alert("请选择模板！");
            return false;
        }
        <% }%>

        return true;
    }
</script>