<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskServiceCall.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.TaskServiceCall" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %>服务预定</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/index.css" />
    <link rel="stylesheet" href="../Content/style.css" />
    <style>
        td {
            text-align: left;
        }

        .AddItemToTicketTopSection td[class="Popup_TitleCell"] span {
            font-size: 16px;
            font-weight: Bold;
        }

        .Popup_Title {
            font-size: 19px;
            color: #4F4F4F;
        }

        .FieldLabel, .workspace .FieldLabel, TABLE.FieldLabel TD, span.fieldlabel span label {
            font-size: 12px;
            color: #4F4F4F;
        }

        .txtBlack8Class {
            font-size: 12px;
            color: #333;
            font-weight: normal;
        }

        input[type=checkbox] {
            margin: 0 3px 0 0;
            padding-top: 1px;
        }

        .DivSection, .DivSectionOnly {
            border: 1px solid #d3d3d3;
            margin: 0 10px 10px 10px;
            padding: 12px 28px 4px 28px;
        }

        .AddItemToTicketTopSection {
            color: #4F4F4F;
            padding: 10px;
            background-repeat: no-repeat;
            background-position: left;
            padding-left: 40px;
            border: none;
        }

        .AddServiceCallTitleImage {
            background-image: url(../Images/ico_service_call.png);
        }

        .service_render_label {
            vertical-align: middle;
            text-align: left;
            width: 60px;
            font-size: 8pt;
        }

        .dataGridHeader a:link, .dataGridHeader a:visited, .dataGridHeader a:hover, .dataGridBody .dataGridHeader a, .dataGridBody .dataGridHeader a:link, .dataGridBody .dataGridHeader a:visited, .dataGridBody .dataGridHeader a:hover {
            color: #64727a;
        }

        .SectionLevelInstruction span {
            font-size: 12px;
            color: #666;
            line-height: 16px;
        }

        .GridBottomBorder, .GridContainer {
            border-color: #98b4ca;
        }

        .GridContainer {
            margin: 0 10px 10px 10px;
        }

        .DivSection div, .DivSectionWithHeader .Content div {
            padding-bottom: 10px;
        }

        #dgServiceCallExisting_dgServiceCallExisting_divgrid {
            margin-left: 0;
        }

        .dataGridBody, .dataGridAlternating, .dataGridGroupBreak, .dataGridBodyHighlight {
            border-bottom-color: #98b4ca;
            border-right-color: #98b4ca;
        }

        .dataGridBody, .dataGridAlternating, .dataGridGroupBreak, .dataGridBodyHighlight {
            background-color: white;
            border-left-width: 0;
            border-bottom-width: 1px;
            border-bottom-style: solid;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: middle;
            padding: 10px 0 4px 0;
            vertical-align: top;
            word-wrap: break-word;
            border-right-width: 1px;
            border-right-style: solid;
        }

        .dataGridHeader {
            border-left: outset 1px;
            border-right: outset 1px;
            border-bottom: outset 1px;
            font-size: 9px;
            font-weight: bold;
            color: #555;
            text-decoration: none;
            height: 25px;
            background-color: buttonface;
            vertical-align: top;
        }

        .dataGridBody td:first-child, .dataGridAlternating td:first-child, .dataGridBodyHover td:first-child, .dataGridAlternatingHover td:first-child, .dataGridDisabled td:first-child, .dataGridDisabledHover td:first-child {
            border-left-color: #98b4ca;
        }

        .dataGridBody .dataGridHeader td {
            border-bottom-color: #98b4ca;
        }

        .dataGridHeader td, .dataGridHeader th, tr.dataGridHeader td, tr.dataGridHeader th {
            border-right-width: 1px;
            border-right-style: solid;
            font-size: 13px;
            font-weight: bold;
            height: 19px;
            padding: 4px;
            vertical-align: top;
            word-wrap: break-word;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
            border-color: #98b4ca;
            background-color: #cbd9e4;
            color: #64727a;
        }

        .dataGridAlternating td, .dataGridBodyHover td, .dataGridAlternatingHover td, .dataGridDisabled td, .dataGridDisabledHover td {
            border-width: 1px;
            border-style: solid;
            border-left-color: #F8F8F8;
            border-right-color: #F8F8F8;
            border-top-color: #e8e8e8;
            border-bottom-width: 0;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: top;
            padding: 4px;
            word-wrap: break-word;
        }

        .dataGridHeader a, .dataGridHeader a:link, .dataGridHeader a:visited, .dataGridHeader a:hover, .dataGridBody .dataGridHeader a, .dataGridBody .dataGridHeader a:link, .dataGridBody .dataGridHeader a:visited, .dataGridBody .dataGridHeader a:hover {
            font-size: 13px;
            text-decoration: none;
        }

        textarea {
            resize: vertical;
        }

        .grid thead tr td {
            background-color: #cbd9e4;
            border-color: #98b4ca;
            color: #64727a;
        }

        .grid {
            font-size: 12px;
            background-color: #FFF;
        }

            .grid thead td {
                border-width: 1px;
                border-style: solid;
                font-size: 13px;
                font-weight: bold;
                height: 19px;
                padding: 4px 4px 4px 4px;
                word-wrap: break-word;
                vertical-align: top;
            }

            .grid table {
                border-collapse: collapse;
                width: 100%;
                border-bottom-width: 1px;
                /*border-bottom-style: solid;*/
            }

            .grid tbody td {
                border-width: 1px;
                border-style: solid;
                border-left-color: #F8F8F8;
                border-right-color: #F8F8F8;
                border-top-color: #e8e8e8;
                border-bottom-width: 0;
                padding: 4px 4px 4px 4px;
                vertical-align: top;
                word-wrap: break-word;
                font-size: 12px;
                color: #333;
            }

        .Section > .Heading > .Toggle.Collapse > .Vertical {
            display: none;
        }

        .Section > .Heading > .Toggle > .Vertical {
            background-color: #888;
            height: 8px;
            left: 6px;
            position: absolute;
            top: 3px;
            width: 2px;
        }

        .Section > .Heading > .Toggle > .Horizontal {
            background-color: #888;
            height: 2px;
            left: 3px;
            /*position: absolute;*/
            top: 6px;
            width: 8px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增":"编辑" %>服务预定</div>
        <div class="header-title">
            <ul>
                <li id="SaveClose">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" />
                </li>
                <li id="SaveNew">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_new" runat="server" Text="保存并新增" OnClick="save_new_Click" />
                </li>
                <% if (false)  /* 说明书，优先级较低，暂时不做 */
                    {%>
                <li id="WorkBook">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="work_book" runat="server" Text="生成工作说明书" />
                </li>
                <%} %>
                <li id="Close">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <input type="button" id="CloseButton" value="取消" />
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 100px;">


            <div class="DivSection AddItemToTicketTopSection AddServiceCallTitleImage">
                <table cellspacing="0" cellpadding="0" border="0" style="height: 44px; border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td class="Popup_TitleCell"><span title="<%=thisTicket!=null?thisTicket.no+" - "+thisTicket.title:"" %>" class="Popup_Title" style="width: 750px;"><%=thisTicket!=null?thisTicket.no+" - "+thisTicket.title:"" %></span></td>
                        </tr>
                        <tr>
                            <td class="Popup_SubtitleCell"><span title="<%=thisAccount!=null?thisAccount.name:"" %>" class="Popup_Subtitle" style="width: 765px;"><%=thisAccount!=null?thisAccount.name:"" %></span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="DivSection">

                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold;">为此工单新建服务预定...</span>
                </div>
                <div class="Content" id="NewCall">
                    <%if (isAdd)
                        { %>
                    <div>
                        <span id="chkAddToNewServiceCall" class="txtBlack8Class" style="margin-left: 11px;"><span class="txtBlack8Class">
                            <input id="ckNewCall" type="checkbox" name="ckNewCall" checked="checked" style="vertical-align: middle;" /></span></span><span class="lblNormalClass" style="font-weight: normal;">创建一个新的服务预定</span>
                    </div>
                    <%} %>
                    <table class="service_render_table_detailPanel" cellspacing="0" border="0" style="border-collapse: collapse; margin-left: 10px; margin-right: 10px;">
                        <tbody>
                            <tr>
                                <td colspan="5"><span class="lblNormalClass" style="font-weight: bold;"></span></td>
                            </tr>
                            <tr>
                                <td class="service_render_tablecell_label" valign="top"><span class="FieldLabel" style="font-weight: bold; width: 80px;">开始时间<font style="color: Red;"> *</font></span></td>
                                <td class="service_render_tablecell_label" valign="top"><span class="FieldLabel" style="font-weight: bold; width: 80px;"></span></td>
                                <td class="service_render_tablecell_label" valign="top"><span class="FieldLabel" style="font-weight: bold; width: 80px;">结束时间<font style="color: Red;"> *</font></span></td>
                                <td class="service_render_tablecell_label" valign="top"><span class="FieldLabel" style="font-weight: bold; width: 80px;"></span></td>
                                <td rowspan="5" style="width: 33%; vertical-align: top; padding-left: 10px;">
                                    <table class="service_call_render_resource_table" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                        <tbody>
                                            <tr>
                                                <td><span class="FieldLabel" style="font-weight: bold;">员工</span></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="hidden" name="_ctl26" value="8916"></td>
                                            </tr>
                                            <% if (resList != null && resList.Count > 0)
                                                {
                                                    foreach (var res in resList)
                                                    { %>
                                            <tr>
                                                <td><span id=""><span class="txtBlack8Class">
                                                    <input id="" type="checkbox" name="" style="vertical-align: middle;" class="ckRes" value="<%=res.id %>" <%if (isAdd || (serResList != null && serResList.Count > 0 && serResList.Any(_ => _.resource_id == res.id)))
                                                        { %>
                                                        checked="checked" <%} %> /><label style="vertical-align: middle;"><%=res.name %></label></span></span><%if (res.id == thisTicket.owner_resource_id)
                                                                                                                                                                  { %><span class="FieldLevelInstruction">(主负责人)</span> <%} %></td>
                                            </tr>
                                            <%  }
                                                } %>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="service_render_tablecell_date">
                                    <div>
                                        <span id="dStartDate" style="display: inline-block;">
                                            <input name="startDate" type="text" value="<%=thisCall!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisCall.start_time).ToString("yyyy-MM-dd HH:mm"):(DateTime.Now.ToString("yyyy-MM-dd")+" 08:00") %>" id="startDate" class="txtBlack8Class" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm' })" style="width: 120px;" />
                                        </span>
                                    </div>
                                </td>
                                <td class="service_render_tablecell_date">
                                    <div>
                                        <span id="tStartTime" style="display: inline-block;"></span>
                                    </div>
                                </td>
                                <td class="service_render_tablecell_date">
                                    <div>
                                        <span id="dEndDate" style="display: inline-block;">
                                            <input name="endDate" type="text" value="<%=thisCall!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisCall.end_time).ToString("yyyy-MM-dd HH:mm"):(DateTime.Now.ToString("yyyy-MM-dd")+" 09:00") %>" id="endDate" class="txtBlack8Class" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm' })" style="width: 120px;" />
                                        </span>
                                    </div>
                                </td>
                                <td class="service_render_tablecell_date">
                                    <div>
                                        <span id="tEndTime" style="display: inline-block;"></span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" colspan="4" style="padding-top: 10px;"><span class="service_render_label" style="font-weight: bold;">工单剩余时间:</span><span class="lblNormalClass" style="font-weight: normal; vertical-align: middle;">&nbsp;0.00</span><br />
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" colspan="4" style="padding-top: 10px;"><span class="FieldLabel" style="font-weight: bold;">描述:</span><br>
                                    <div>
                                        <span id="descriptionSpan" class="txtBlack8Class" style="display: inline-block;">
                                            <textarea name="description" id="description" class="txtBlack8Class" style="height: 80px; width: 480px;"><%=thisCall!=null?thisCall.description:"" %></textarea></span>
                                    </div>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td align="left" valign="top" colspan="4"><span class="FieldLabel" style="font-weight: bold;">状态:</span><br />
                                    <span id="Status">
                                        <select name="status_id" id="status_id" class="txtBlack8Class">
                                            <%if (statusList != null && statusList.Count > 0)
                                                {
                                                    foreach (var statu in statusList)
                                                    { %>
                                            <option value="<%=statu.id %>" <%if (thisCall != null && statu.id == thisCall.status_id)
                                                { %>
                                                selected="selected" <%} %>><%=statu.name %></option>
                                            <%  }
                                                } %>
                                        </select>
                                    </span>
                                    <br />
                                    <br />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <input type="hidden" id="resIds" name="resIds" />
            <input type="hidden" id="callIds" name="callIds" />
            <%if (isAdd)
                { %>
            <div class="DivSectionWithHeader DivSection">
                <div class="HeaderRow" style="margin-left: -18px;">
                    <span class="lblNormalClass" style="font-weight: bold;">将此工单添加到客户的服务预定中...</span>
                </div>
                <div class="Content">
                    <div class="SectionLevelInstruction">
                        <span class="lblNormalClass" style="font-weight: normal;">选择你想要加入任务或工单的服务预定.</span>
                    </div>
                    <table class="service_render_table_addTicketToServicecall" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td align="left">
                                    <div>
                                        <span id="chkLimitSCDates" class="lblNormalClass"><span class="txtBlack8Class">
                                            <input id="LimtDays" type="checkbox" name="LimtDays" checked="checked" style="vertical-align: middle;" /><label style="vertical-align: middle;">从今天起限制开始日期+ 30天 </label>
                                        </span></span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <span id="" class="datagrid" style="display: inline-block; width: 100%;">
                                        <div id="" class="GridContainer" style="margin-left: 0px;">
                                            <div id="" style="max-width: 500px;">
                                                <table class="dataGridBody" id="" style="width: 100%; border-collapse: collapse;">
                                                    <tbody>
                                                        <tr class="dataGridHeader">
                                                            <td align="center" style="width: 1%;"></td>
                                                            <td align="center" style="width: 120px; min-width: 82px;"><a id="" style="font-weight: bold; width: 110px;">开始时间</a></td>
                                                            <td align="center" style="width: 120px; min-width: 82px;"><a id="" style="font-weight: bold; width: 110px;">结束时间</a></td>
                                                            <%--   <td align="left"><a id="" style="font-weight: bold;"></a>&nbsp;</td>
                                                        <td><a id=""  style="font-weight: bold;"> </a></td>--%>
                                                            <td align="left"><a id="" style="font-weight: bold;">状态</a></td>
                                                        </tr>

                                                        <% if (pageCallList != null && pageCallList.Count > 0)
                                                            {
                                                                foreach (var pageCall in pageCallList)
                                                                {    %>
                                                        <tr id="" class="dataGridBody AllCall <%=pageCall.isLimtThri ? "isLimtThri" : "" %>">
                                                            <td style="vertical-align: middle; text-align: center;">
                                                                <span class="txtBlack8Class">
                                                                    <input id="" type="checkbox" name="" style="margin-left: 5px;" checked="checked" value="<%=pageCall.id.ToString() %>" class="ckCallId <%=pageCall.isLimtThri ? "ckThrid" : "" %>" />
                                                                </span>
                                                            </td>
                                                            <td align="center" style="width: 110px;"><span id="" style="width: 110px;"><%=pageCall.startDate %></span></td>
                                                            <td align="center" style="width: 110px;"><span id="" style="width: 110px;"><%=pageCall.endDate %></span></td>
                                                            <%-- <td align="left"><span id=""></span></td>
                                                        <td>
                                                            <span id=""></span>
                                                        </td>--%>
                                                            <td align="left"><span id="" class="ColorSwatch Color34 ColorText"><%=pageCall.statusName %></span></td>
                                                        </tr>
                                                        <%}
                                                            } %>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%} %>
            <input type="hidden" id="notifyResIds" name="notifyResIds"/>
            <input type="hidden" id="notifyConIds" name="notifyConIds"/>
            
            <div class="Normal Section DivSection information clear" style="border: 1px solid #d3d3d3; margin: 0 10px 10px 10px; padding: 4px 0 4px 0;">
                <p class="informationTitle"><i class=""></i>指派给</p>
                <div class="Content">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div id="mnuNotify" style="position: relative; top: 0px; left: 0px; visibility: visible; display: block; padding-left: 35px;">
                                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                            <tbody>
                                                <tr>
                                                    <td>

                                                        <table class="searchareaborder" width="738px" cellspacing="0" cellpadding="0" border="0" style="width: 500px;">
                                                            <tbody>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <table cellspacing="0" cellpadding="0" border="0" style="margin-left: 0px; width: 75%;">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="369px" class="fieldLabels" style="padding-left: 35px;">
                                                                                        <div class="CheckBoxList">
                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="ckAccMan" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">客户经理<%=accMan!=null?"("+accMan.name+")":"" %></span>
                                                                                            </div>
                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="CCMe" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">抄送给我</span>
                                                                                            </div>
                                                                                             <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="CkPriRes" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">主负责人</span>
                                                                                            </div>
                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                
                                                                                            </div>
                                                                                        </div>
                                                                                    </td>

                                                                                    <td class="fieldLabels" width="357px" style="padding-left: 10px">
                                                                                        <div class="CheckBoxList">
                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="CKcreate" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">服务预定创建人 <%=callCreater!=null?$"({callCreater.name})":"" %></span>
                                                                                            </div>
                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="CKTicketCon" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">工单联系人<%=ticketCon==null?"":$"({ticketCon.name})" %></span>
                                                                                            </div>
                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="CkTicketOther" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">工单的其他负责人</span>
                                                                                            </div>
                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="Cksys" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">使用系统邮箱发送</span>
                                                                                            </div>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" width="369px" style="padding-left: 30px;"><span style="margin-left: -19px;">联系人<a onclick="loadCon()">(加载联系人)</a></span>
                                                                        <div style="margin-left: -18px;">
                                                                            <div id="" style="width: 350px; height: 170px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                                                                                <div class='grid' style='overflow: auto; height: 147px;'>
                                                                                    <table width='100%' border='0' cellspacing='0' cellpadding='3'>
                                                                                        <thead>
                                                                                            <tr>
                                                                                                <td width='1%'>
                                                                                                    <%--<input type='checkbox' id='checkAll' />--%>
                                                                                                </td>
                                                                                                <td width='33%'>联系人姓名</td>
                                                                                                <td width='33%'>邮箱地址</td>
                                                                                            </tr>
                                                                                        </thead>
                                                                                        <tbody id="conhtml">
                                                                                        </tbody>
                                                                                    </table>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                    </td>
                                                                    <td class="FieldLabels"><span>员工</span>
                                                                        <span class="FieldLevelInstructions">(<a style="color: #376597; cursor: pointer;" onclick="LoadRes()">加载员工</a>)</span>
                                                                        <div id="reshtml" style="width: 350px; height: 170px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                                                                        </div>
                                                                    </td>

                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" colspan="2" style="padding-top: 9px;"><span class="mytitle">其他邮件地址</span>
                                                                        <div>
                                                                            <input type="text" style="width: 726px;" name="otherEmail" id="otherEmail" />
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" colspan="2" style="padding-top: 9px;">
                                                                        <span class="mytitle">通知模板</span>
                                                                        <div>
                                                                            <select id="notify_id" name="notify_id" style="width:727px;">
                                                                                 <%if (tempList != null && tempList.Count > 0)
                                                                            {foreach (var temp in tempList){  %>
                                                                        <option value="<%=temp.id %>"><%=temp.name %></option>
                                                                        <%
                                                                                } } %>
                                                                            </select>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" colspan="2" style="padding-top: 9px;"><span class="mytitle">主题</span>
                                                                        <div>
                                                                            <input type="text" id="subjects" name="subjects" value="" style="width: 726px" />
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" width="369px" style="padding-top: 9px;"><span class="mytitle">附加信息</span></td>

                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2" class="FieldLabels">
                                                                        <div>
                                                                            <textarea rows="6" style="width: 726px" name="AdditionalText" id="AdditionalText"></textarea>
                                                                        </div>
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                    <td colspan="2" style="text-align: right;"><a href="#" class="PrimaryLink" onclick="defaultSettings();">修改默认设置</a>&nbsp;&nbsp;</td>
                                                                </tr>

                                                            </tbody>
                                                        </table>
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
        </div>
    </form>
</body>
</html>
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="../Scripts/common.js"></script>
<script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/index.js"></script>
<script>
    var colors = ["#efefef", "white"];
    var index1 = 0; var index2 = 0; var index3 = 0;
    $(".Toggle1").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index1 % 2]);
        index1++;
    });
    $(function () {
        if ($("#LimtDays").is(":checked")) {
            $(".AllCall").hide();
            $(".isLimtThri").show();
        }
        else {
            $(".AllCall").show();
        }
    })

    $("#LimtDays").click(function () {
        if ($(this).is(":checked")) {
            $(".AllCall").hide();
            $(".isLimtThri").show();
        }
        else {
            $(".AllCall").show();
        }
    })
    // 获取员工Id
    function GetResId() {
        var ids = "";
        $(".ckRes").each(function () {
            if ($(this).is(":checked")) {
                var thisValue = $(this).val();
                if (thisValue != "" && thisValue != null && thisValue != undefined) {
                    ids += thisValue + ',';
                }
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#resIds").val(ids);
    }
    // 获取选择的服务预定的ID
    function GetCallIds() {
        var ids = "";
        if ($("#LimtDays").is(":checked")) {
            $(".ckThrid").each(function () {
                if ($(this).is(":checked")) {
                    var thisValue = $(this).val();
                    if (thisValue != "" && thisValue != null && thisValue != undefined) {
                        ids += thisValue + ',';
                    }
                }
            })
        }
        else {
            $(".ckCallId").each(function () {
                if ($(this).is(":checked")) {
                    var thisValue = $(this).val();
                    if (thisValue != "" && thisValue != null && thisValue != undefined) {
                        ids += thisValue + ',';
                    }
                }
            })
        }
        $("#callIds").val(ids);
    }
    $("#save_close").click(function () {
        return SubmitCheck();
    })

    $("#save_new").click(function () {
        return SubmitCheck();
    })
    function SubmitCheck() {
        GetResId();
        GetCallIds();
        GetContratID();
        GetNotiResID();
        <%if (isAdd)
    { %>
        if ($("#ckNewCall").is(":checked")) {
            <%} %>
            var startDate = $("#startDate").val();
            if (startDate == "") {
                LayerMsg("请填写开始时间！");
                return false;
            }
            var endDate = $("#endDate").val();
            if (endDate == "") {
                LayerMsg("请填写结束时间！");
                return false;
            }
            var status_id = $("#status_id").val();
            if (status_id == "") {
                LayerMsg("请选择正确的状态！");
                return false;
            }
             <%if (isAdd)
    { %>
        }
         <%} %>
    }

    $("#ckNewCall").click(function () {
        if ($(this).is(":checked")) {
            $("#NewCall input").prop("disabled", false);
            $("#NewCall select").prop("disabled", false);
            $("#NewCall textarea").prop("disabled", false);
        }
        else {
            $("#NewCall input").prop("disabled", true);
            $("#NewCall select").prop("disabled", true);
            $("#NewCall textarea").prop("disabled", true);
            $(this).prop("disabled", false)
        }
    })


    $("#Close").click(function () {
        window.close();
    })

    function loadCon() {
          $.ajax({
              type: "GET",
              async: false,
              url: "../Tools/ContactAjax.ashx?act=GetContacts&account_id=<%=thisAccount.id %>",
            success: function (data) {
                if (data != "") {
                    $("#conhtml").html(data);
                }
            },
          });
    }
    function LoadRes() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ResourceAjax.ashx?act=GetResAndWorkGroup",
            success: function (data) {
                if (data != "") {
                    var resList = JSON.parse(data);
                    var resHtml = "";
                    resHtml += "<div class='grid' style='overflow: auto;height: 147px;'><table width='100%' border='0' cellspacing='0' cellpadding='3'><thead><tr><td width='1%'></td><td width='33%'>员工姓名</td ><td width='33%'>邮箱地址</td></tr ></thead ><tbody>";// <input type='checkbox' id='checkAll'/>
                    for (var i = 0; i < resList.length; i++) {
                        resHtml += "<tr><td><input type='checkbox' value='" + resList[i].id + "' class='" + resList[i].type + "' /></td><td>" + resList[i].name + "</td><td><a href='mailto:" + resList[i].email + "'>" + resList[i].email + "</a></td></tr>";
                    }
                    resHtml += "</tbody></table></div>";

                    $("#reshtml").html(resHtml);
                }
            },
        });
    }
    function GetNotiResID() {
        var ids = "";
        $(".checkRes").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#notifyResIds").val(ids);
    }
    function GetContratID() {
        var ids = "";
        $(".checkCon").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#notifyConIds").val(ids);
    }
</script>
