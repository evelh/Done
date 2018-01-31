<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketView.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.TicketView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/Ticket.css" rel="stylesheet" />
    <title>查看工单</title>
    <style>
        .clickBtn {
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            font-size: 12px;
            font-weight: bold;
            line-height: 24px;
            padding: 0 1px 0 3px;
            color: #4F4F4F;
            vertical-align: top;
        }

        .AddNoteIcon {
            background: url(../Images/SmallIcon.png) no-repeat -1px -1px;
            height: 14px;
            width: 14px;
            float: left;
            margin-left: 10px;
            margin-top: 2px;
        }

        .ImgLink {
            background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);
        }
    </style>
</head>
<body>
    <!-- 上方 标题 按钮等 -->
    <div class="PageHeadingContainer" style="z-index: 1;">
        <div class="HeaderRow">
            <table>
                <tbody>
                    <tr>
                        <td><span>工单-<%=thisTicket.no %> - <%=thisTicket.title %><%=$"({thisAccount.name})" %></span></td>
                        <td align="right" class="helpLink"><a class="HelperLinkIcon" title=""></a></td>
                        <!--上一工单，下一工单的显示 跳转 --->
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar">
            <ul>
                <li style="margin-left: 14px;">
                    <a class="ImgLink" onclick="EditTicket()" style="background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);">
                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -23px 1px; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text" style="line-height: 24px;">修改</span>
                    </a>
                </li>

                <li>
                    <a class="ImgLink" onclick=""  style="background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);">
                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -86px -144px; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text" style="line-height: 24px;">接受</span>
                    </a>
                </li>

                <li>
                    <a class="ImgLink" onclick=""  style="background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);">
                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -277px 0px; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text" style="line-height: 24px;">转发</span>
                    </a>
                </li>

                <li id="ToolLi">
                    <a class="ImgLink" onclick=""  style="background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);">
                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -198px -144px; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text" style="line-height: 24px;">工具</span>

                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -182px -48px; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    </a>
                </li>
                <li class="DropDownButton" style="top: 72px; left: 214px;display:none;" id="Down2">
                    <div class="DropDownButtonDiv">
                        <div class="Group">
                            <div class="Content">
                                <div class="Button1" id="CopyButton" tabindex="0" onclick="CopyTicket()">
                                    <span class="Icon"></span>
                                    <span class="Text">复制</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Icon"></span>
                                    <span class="Text">合并到其他工单</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Icon"></span>
                                    <span class="Text">吸收合并其他工单</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Icon"></span>
                                    <span class="Text">复制到项目</span>
                                </div>
                                <%--<div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Text">发送问卷</span>
                                </div> ViewButton--%>
                                <div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Icon"></span>
                                    <span class="Text">取消与项目的关联关系</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Icon"></span>
                                    <span class="Text">生成发票</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Icon"></span>
                                    <span class="Text">查看报表</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="ShowTicketHistory()">
                                    <span class="Icon"></span>
                                    <span class="Text">工单历史</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Icon"></span>
                                    <span class="Text">客户服务详情</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="DeleteTicket()">
                                    <span class="Icon"></span>
                                    <span class="Text">删除</span>
                                </div>
                            </div>
                        </div>
                       
                        
                    </div>
                </li>

                <li>
                    <a class="ImgLink" onclick="CompleteEntry()"  style="background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);">
                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -6px -64px; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text" style="line-height: 24px;">完成</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <!-- 下左 快捷添加相应操作（编辑 查看会触发相应事件） -->
    <div class="QuickLaunchBar" style="top: 82px;">
        <div class="QuickLaunchButton TimeEntry DisabledState" id="" onclick="AddTimeEntry()">
            <div class="Text">工时<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/time.png) no-repeat;"></div>
        </div>
        <div class="QuickLaunchButton Note DisabledState" onclick="AddTicketNote('')">
            <div class="Text">备注<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/imgGridEdit.png) no-repeat;"></div>
        </div>
        <div class="QuickLaunchButton Attachment DisabledState" onclick="AddTicketAttachment()">
            <div class="Text">附件<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/attachment.png) no-repeat;"></div>
        </div>
        <div class="QuickLaunchButton Charge DisabledState" onclick="AddTicketCharge()">
            <div class="Text">成本<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></div>
        </div>
        <div class="QuickLaunchButton Expense DisabledState" onclick="AddTicketExpense()">
            <div class="Text">费用<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></div>
        </div>
        <div class="QuickLaunchButton ServiceCall DisabledState" id="z82b4699d4b024e3280de758dad30d4d7">
            <div class="Text">服务<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></div>
        </div>
        <div class="QuickLaunchButton ToDo DisabledState" id="z409ac334b1fb4a02b6ad33da1873766f">
            <div class="Text">待办<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></div>
        </div>
    </div>

    <div class="MessageBarContainer" style="margin-left: 45px; margin-top: 82px;">
        <div class="MessageBar Alert" id="AccountAlert">
            <div class="IconContainer">
                <div class="MessageBarIcon Alert" style="background-position: -1px -1px;"></div>
            </div>
            <% var alert = new EMT.DoneNOW.DAL.crm_account_alert_dal().FindAlert(thisAccount.id, EMT.DoneNOW.DTO.DicEnum.ACCOUNT_ALERT_TYPE.COMPANY_DETAIL_ALERT);%>
            <div class="Content FormatPreservation Left"><%=alert==null?"":alert.alert_text %></div>
        </div>
    </div>

    <div class="MainContainer InsightsEnabled" style="margin-left: 45px;">
        <div class="SecondaryContainer Left Active" id="">
            <div class="TabButtonContainer">
                <div>
                    <div class="TabButton EntityPageTabIcon Details Active">
                        <div class="Icon"></div>
                        <div class="Text">Details</div>
                    </div>
                </div>
                <div>
                    <div class="TabButton EntityPageTabIcon Insights" onclick="();">
                        <div class="Icon"></div>
                        <div class="Text">Insights</div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection">
                <div class="Content">
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label" onclick="">客户</span></div>
                        <div class="Value"><a class="Button ButtonIcon Link NormalState" tabindex="0" onclick="OpenAccount('<%=thisAccount==null?"":thisAccount.id.ToString() %>')"><%=thisAccount==null?"":thisAccount.name %></a></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">联系人</span></div>
                        <div class="Value">
                            <a class="Button ButtonIcon Link NormalState" style="float: left;" tabindex="0" onclick="OpenContact('<%=thisContact==null?"":thisContact.id.ToString() %>')"><%=thisContact==null?"":thisContact.name %></a><div class="InlineIconButton InlineIcon Note NormalState AddNoteIcon" onclick="AddTicketNote('ckContact')"></div>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">状态</span></div>
                        <div class="Value">
                            <div class="ColorBand ColorSwatch Color34">
                                <div class="Left ColorSample">
                                    <div class="TicketStatusIcon General"></div>
                                </div>
                                <div class="Right">
                                    <div class="BackgroundPatch ColorSample"></div>
                                    <% var ticketStatu = ticStaList.FirstOrDefault(_ => _.id == thisTicket.status_id); %>
                                    <div class="Text ColorSample"><%=ticketStatu==null?"":ticketStatu.name %></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label" id="z6bf29468ce3e490c94294ea8fc13ee02" onclick="">优先级</span></div>
                        <div class="Value">
                            <div class="ColorBand ColorSwatch Color9">
                                <div class="Left ColorSample">
                                    <div class="PriorityIcon General"></div>
                                </div>
                                <div class="Right">
                                    <div class="BackgroundPatch ColorSample"></div>
                                    <div class="Text ColorSample">
                                        <% if (thisTicket.priority != null)
                                            {
                                                var ticketPrior = priorityList.FirstOrDefault(_ => _.id == thisTicket.priority); %><%=ticketPrior==null?"":ticketPrior.name %> <%}%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection" id="z5855ad44526e4f5f847e31f3eb891274">
                <div class="Title Title1">
                    <div class="Text">工单信息</div>
                    <div class="Toggle">
                        <div class="InlineIcon ArrowUp"></div>
                    </div>
                </div>
                <div class="Content">
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">问题类型</span></div>
                        <div class="Value">
                            <% if (thisTicket.issue_type_id != null)
                                {
                                    var ticketIssue = issueTypeList.FirstOrDefault(_ => _.id == thisTicket.issue_type_id); %><%=ticketIssue==null?"":ticketIssue.name %> <%}%>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">子问题类型</span></div>
                        <div class="Value">
                            <% if (thisTicket.sub_issue_type_id != null)
                                {
                                    var ticketSubIssue = issueTypeList.FirstOrDefault(_ => _.id == thisTicket.sub_issue_type_id); %><%=ticketSubIssue==null?"":ticketSubIssue.name %> <%}%>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">工单来源</span></div>
                        <div class="Value">
                            <% if (thisTicket.source_type_id != null)
                                {
                                    var ticketSource = issueTypeList.FirstOrDefault(_ => _.id == thisTicket.source_type_id); %><%=ticketSource==null?"":ticketSource.name %> <%}%>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">截止日期</span></div>
                        <div class="Value"><%=thisTicket.estimated_end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.estimated_end_time).ToString("yyyy-MM-dd HH:mm:ss"):"" %></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">预估时间</span></div>
                        <div class="Value"><%=thisTicket.estimated_hours.ToString("#0.00")+'h' %></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">服务等级协议</span></div>
                        <div class="Value">
                            <% if (thisTicket.sla_id != null)
                                {
                                    var ticketSla = slaList.FirstOrDefault(_ => _.id == thisTicket.sla_id); %><%=ticketSla==null?"":ticketSla.name %> <%}%>
                        </div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection" id="z9fcc61f1a21d45f885647146cbd64097">
                <div class="Title Title2">
                    <div class="Text">分配信息</div>
                    <div class="Toggle">
                        <div class="InlineIcon ArrowUp"></div>
                    </div>
                </div>
                <div class="Content">
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">队列</span></div>
                        <div class="Value">
                            <div class="ColorBand ColorSwatch Color34">
                                <div class="Left ColorSample">
                                    <div class="ClientPortalVisibilityIcon Visible"></div>
                                </div>
                                <div class="Right">
                                    <div class="BackgroundPatch ColorSample"></div>
                                    <div class="Text ColorSample">
                                        <% if (thisTicket.department_id != null)
                                            {
                                                var ticketDep = depList.FirstOrDefault(_ => _.id == thisTicket.department_id); %><%=ticketDep==null?"":ticketDep.name %> <%}%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">主负责人</span></div>
                        <div class="Value">
                            <div class="PrimaryResource">
                                <div class="Left" style="float: left;">
                                    <img src="<%=priRes!=null&&priRes.avatar!=null?priRes.avatar:"" %>" style="width: 45px;" />
                                </div>
                                <div class="Right">
                                    <div class="Name"><a class="Button ButtonIcon Link NormalState" style="float: left;" tabindex="0"><%=priRes==null?"":priRes.name %></a></div>
                                    <div class="InlineIconButton InlineIcon Note NormalState AddNoteIcon" onclick="AddTicketNote('priRes')"></div>
                                    <% EMT.DoneNOW.Core.sys_role ticketRole = null;
                                        if (thisTicket.role_id != null)
                                        {
                                            ticketRole = new EMT.DoneNOW.DAL.sys_role_dal().FindNoDeleteById((long)thisTicket.role_id);
                                        }
                                    %>
                                    <br />
                                    <div class="Support"><span class="Text"><%=ticketRole==null?"":$"({ticketRole.name})" %></span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled" style="clear: both;">
                        <div class="LabelContainer">
                            <span class="Label">其他负责人</span><div class="InlineIconButton InlineIcon Note NormalState"></div>
                        </div>
                        <div class="Value">
                            <div class="ExpandableDataContainer">
                                <% if (ticketResList != null && ticketResList.Count > 0)
                                    {
                                        var srDal = new EMT.DoneNOW.DAL.sys_resource_dal();
                                        var srolDal = new EMT.DoneNOW.DAL.sys_role_dal();
                                        foreach (var ticketRes in ticketResList)
                                        {
                                            var thisRes = srDal.FindNoDeleteById((long)ticketRes.resource_id);
                                            var thisRole = srolDal.FindNoDeleteById((long)ticketRes.role_id);
                                            if (thisRes != null && thisRole != null)
                                            {
                                %>
                                <div class="SecondaryResource">
                                    <a class="Button ButtonIcon Link NormalState" style="float: left;" tabindex="0"><%=thisRes.name %></a><span class="RoleName" style="float: left;"><%=$"({thisRole.name})" %></span><div class="InlineIconButton InlineIcon Note NormalState AddNoteIcon" onclick="AddTicketNote('')"></div>
                                </div>
                                <br />
                                <%}
                                        }
                                    } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection" id="z7bbc9c27ae944f6fb150de7254c6e830">
                <div class="Title Title3">
                    <div class="Text">配置项信息</div>
                    <div class="Toggle">
                        <div class="InlineIcon ArrowUp"></div>
                    </div>
                </div>
                <div class="Content">
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">配置项</span></div>
                        <div class="Value">
                            <a class="Button ButtonIcon Link NormalState" tabindex="0" onclick="EditInsPro('<%=insPro==null?"":insPro.id.ToString() %>')">
                                <% EMT.DoneNOW.Core.ivt_product thisProduct = null;
                                    if (insPro != null)
                                    {
                                        thisProduct = new EMT.DoneNOW.DAL.ivt_product_dal().FindNoDeleteById(insPro.product_id);
                                    }
                                %>
                                <%=thisProduct==null?"":thisProduct.name %> </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection">
                <div class="Title Title4">
                    <div class="Text">计费信息</div>
                    <div class="Toggle">
                        <div class="InlineIcon ArrowUp"></div>
                    </div>
                </div>
                <div class="Content">
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">合同</span></div>
                        <div class="Value"><a class="Button ButtonIcon Link NormalState" tabindex="0" onclick="ViewContract('<%=thisContract==null?"":thisContract.id.ToString() %>')"><%=thisContract==null?"":thisContract.name %></a></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">服务/服务包</span></div>
                        <div class="Value"><%=thisService!=null?thisService.name:(thisServiceBun!=null?thisServiceBun.name:"") %></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">工作类型</span></div>
                        <div class="Value"><%=thisCostCode==null?"":thisCostCode.name %></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">采购订单号</span></div>
                        <div class="Value"><%=thisTicket.purchase_order_no %></div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection Collapsed">
                <div class="Title Title5">
                    <div class="Text">自定义信息</div>
                    <div class="Toggle">
                        <div class="InlineIcon ArrowUp"></div>
                    </div>
                </div>
                <div class="Content">
                    <% if (tickUdfList != null && tickUdfList.Count > 0)
                        {
                            foreach (var tickUdf in tickUdfList)
                            {
                    %>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label"><%=tickUdf.col_name %></span></div>
                        <div class="Value">
                            <%
                                EMT.DoneNOW.DTO.UserDefinedFieldValue thisValue = null;
                                if (ticketUdfValueList != null && ticketUdfValueList.Count > 0)
                                {
                                    thisValue = ticketUdfValueList.FirstOrDefault(_ => _.id == tickUdf.id);
                                }
                                if (tickUdf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT || tickUdf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT || tickUdf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)
                                { %>
                            <%=thisValue == null ? "" : thisValue.value.ToString() %>
                            <%}
                                else if (tickUdf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)
                                { %>
                            <%=thisValue == null ? "" : ((DateTime)thisValue.value).ToString("yyyy-MM-dd") %>
                            <%}
                                else if (tickUdf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)
                                {
                                    if (tickUdf.value_list != null && tickUdf.value_list.Count > 0 && thisValue != null && !string.IsNullOrEmpty(thisValue.ToString()))
                                    {
                                        var selectValue = tickUdf.value_list.FirstOrDefault(_ => _.val == thisValue.ToString());
                            %>
                            <%=selectValue==null?"":selectValue.show %>
                            <%
                                    }
                                } %>
                        </div>
                    </div>
                    <%
                            }
                        } %>
                </div>
            </div>
        </div>
        <div class="PrimaryContainer">
            <div>
                <div class="HeadingContainer" style="padding: 15px;">
                    <div class="IdentificationContainer ReadOnly">
                        <div class="Left" style="float: left;">
                            <div class="CategoryName ColorSwatch Color19 ColorSample">
                                <% if (thisTicket.cate_id != null)
                                    {
                                        var ticketCate = ticketCateList.FirstOrDefault(_ => _.id == thisTicket.cate_id); %><%=ticketCate==null?"":ticketCate.name %> <%}%>
                            </div>
                            <div class="TypeName">
                                <% if (thisTicket.ticket_type_id != null)
                                    {
                                        var ticketType = ticketTypeList.FirstOrDefault(_ => _.id == thisTicket.ticket_type_id); %><%=ticketType==null?"":ticketType.name %> <%}%>
                            </div>
                            <div class="IdentificationTextContainer">
                                <div class="IdentificationText"><%=thisTicket.no %></div>
                                <div class="CopyTextButton ButtonIcon CopyToClipboard NormalState CopyText">
                                    <div class="Icon" style="background: url(../Images/Icons.png) no-repeat -22px -145px;"></div>
                                    <div class="SourceText"><%=thisTicket.no %></div>
                                </div>
                                <div class="CopyTextButton ButtonIcon CopyLinkToClipboard NormalState">
                                    <div class="Icon" style="background: url(../Images/Icons.png) no-repeat -6px -145px;"></div>
                                    <div class="SourceText">
                                        <!--需要复制的链接 -->
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="Right" style="padding-top: 20px; margin-right: 10px;">
                            <div class="StopwatchContainer">
                                <div class="StopwatchTime"><span id="ShowWatchTime">00:00:00</span></div>
                                <div class="StopwatchButton StopwatchIcon Normal noplay Pause" id="PlayTimeDiv"></div>
                                <div class="StopwatchButton StopwatchIcon Normal Record" onclick="stop()" style="background: url(../Images/play.png) no-repeat -66px -1px;"></div>
                                <div class="StopwatchButton StopwatchIcon Normal Stop" onclick="Reset()" style="background: url(../Images/play.png) no-repeat -101px -1px;"></div>
                            </div>
                        </div>
                    </div>
                    <div class="Title">
                        <div class="Text"><%=thisTicket.title %></div>
                        <div class="CopyTextButton ButtonIcon CopyToClipboard NormalState" id="zc9d87df7327f4372b4b2fb9cf512f940" title="Copy “ticket number – ticket title” to clipboard">
                            <div class="Icon" style="background: url(../Images/Icons.png) no-repeat -22px -145px;"></div>
                            <div class="SourceText"><%=thisTicket.no %>-<%=thisTicket.title %></div>
                        </div>
                    </div>
                    <div class="Bundle" style="display: flex;">
                        <div>
                            <div class="Text Label">创建时间：</div>
                        </div>
                        <div>
                            <div class="Text"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisTicket.create_time).ToString("yyyy-MM-dd") %> <%=GetDiffDate(EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisTicket.create_time),DateTime.Now) %></div>
                        </div>
                        <div>
                            <div class="Text">-</div>
                        </div>
                        <div>
                            <div class="Text"><%=createRes==null?"":createRes.name %></div>
                        </div>
                        <div>
                            <div class="EntityHeadingIconButton">
                                <div class="InlineIconButton InlineIcon Note NormalState AddNoteIcon"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="Divider">
                    <div class="Line"></div>
                </div>
                <div class="BodyContainer">
                    <div class="Normal Section" id="z322039fc73d54e369d92b9bab8ea4bcf">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle1">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">描述</span></div>
                            <div class="Middle"></div>
                            <div class="Spacer"></div>
                            <div class="Right"></div>
                        </div>
                        <div class="Content">
                            <div class="EntityBodyEnhancedText"><span class="Content"><%=thisTicket.description %></span></div>
                        </div>
                    </div>
                    <div class="Normal Section Timeline">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle2">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">时间轴</span></div>
                            <div class="Middle"></div>
                            <div class="Spacer"></div>
                            <div class="Right"></div>
                        </div>
                        <div class="Content">
                            <div class="Timeline">
                                <div class="Bar Top VerticalSize3">
                                    <div class="Dot" style="left: calc(0% - 6px);">
                                        <div class="Pole VerticalSize3">
                                            <div class="Flag TargetAchieved Normal" id="z79439d23ded94c029599a3d7dd28627f">
                                                <div class="Banner">
                                                    <div class="Triangle"></div>
                                                </div>
                                                <div class="Text">First Response</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="z2f40dca2531745f9a9393bf1c13a3285">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayEventMet"></div>
                                                    <div class="Text Achieved">First Response</div>
                                                </div>
                                                <div class="DateTime">29/01/2018 01:57 PM</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Dot" style="left: calc(79% - 6px);">
                                        <div class="Pole VerticalSize2">
                                            <div class="Flag TargetAchieved Reverse" id="z084300357f8a4995a1d13e2ae0a6220b">
                                                <div class="Banner">
                                                    <div class="Triangle"></div>
                                                </div>
                                                <div class="Text">Resolution Plan</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="z7efe3f18ca5b4d3c83ca253200492b48">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayEventMet"></div>
                                                    <div class="Text Achieved">Resolution Plan</div>
                                                </div>
                                                <div class="DateTime">30/01/2018 09:06 AM</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Dot" style="left: calc(79% - 6px);">
                                        <div class="Pole VerticalSize1">
                                            <div class="Flag TargetAchieved Reverse" id="z5bc5fff464e34e689cdacf4990114637">
                                                <div class="Banner">
                                                    <div class="Triangle"></div>
                                                </div>
                                                <div class="Text">Resolution</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="z4f42c44b95244db284b0a5dd5f8709e9">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayEventMet"></div>
                                                    <div class="Text Achieved">Resolution</div>
                                                </div>
                                                <div class="DateTime">30/01/2018 09:06 AM</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Dot" style="left: calc(79% - 6px);">
                                        <div class="Pole VerticalSize0">
                                            <div class="Flag TargetAchieved Reverse" id="z3af3911af8374cd8a93aa6d8c31ef64f">
                                                <div class="Banner">
                                                    <div class="Triangle"></div>
                                                </div>
                                                <div class="Text">Complete</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="z99dd976fc2a44f6b800d37cd6ad488f9">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayEventMet"></div>
                                                    <div class="Text Achieved">Complete</div>
                                                </div>
                                                <div class="DateTime">30/01/2018 09:06 AM</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="OccurrenceProgress" style="width: 79%;"></div>
                                    <div class="SlaBarIndicator" style="width: 0%;"></div>
                                </div>
                                <div class="Divider"></div>
                                <div class="Bar Bottom">
                                    <div class="TimelineIcon TargetPointer" style="left: calc(81% - 3px);">
                                        <div class="TimelineIcon Target" id="z85414a86487245f1b11077ad0e2efce0"></div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="zf27d5431cf07427691d3372edca92c29">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayTargetMet"></div>
                                                    <div class="Text Achieved">First Response</div>
                                                </div>
                                                <div class="DateTime">30/01/2018 09:27 AM</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="TimelineIcon TargetPointer" style="left: calc(89% - 3px);">
                                        <div class="TimelineIcon Target" id="z554f2ecf460e4b6797ee7b5b38bebf80"></div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="z18fc40437a9e4a3cad5bc80e461c37f8">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayTargetMet"></div>
                                                    <div class="Text Achieved">Resolution Plan</div>
                                                </div>
                                                <div class="DateTime">30/01/2018 11:27 AM</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="TimelineIcon TargetPointer" style="left: calc(98% - 3px);">
                                        <div class="TimelineIcon Target" id="z1c4c3ca136d0466c8582986c7eb839a5"></div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="z22fcaf4e90e24ddab5975b2bee67ea0f">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayTargetMet"></div>
                                                    <div class="Text Achieved">Resolution</div>
                                                </div>
                                                <div class="DateTime">30/01/2018 01:27 PM</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="TimelineIcon TargetPointer" style="left: calc(100% - 3px);">
                                        <div class="TimelineIcon Target" id="z4b018c06499842449f9c2f0a5cdbb24b"></div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="zf8d2cfcad1fd4700817f7fd7fedebb41">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayTargetMet"></div>
                                                    <div class="Text Achieved">Complete</div>
                                                </div>
                                                <div class="DateTime">30/01/2018 01:54 PM</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="TargetProgress" style="width: 100%;"></div>
                                </div>
                                <div class="TicketSlaTimelineStart" id="zb096bdd4b355488ba8133fe9b0d2a513">
                                    <div class="TimelineIcon SlaStartLabel"></div>
                                </div>
                                <div class="ContextOverlayContainer" id="z480de0c322b14266a4d9366a92622169">
                                    <div class="TimelineContextOverlay ContextOverlay">
                                        <div class="Outline Arrow"></div>
                                        <div class="Arrow"></div>
                                        <div class="Content">
                                            <div class="Label">
                                                <div class="TimelineIcon OverlayTicketStart"></div>
                                                <div class="Text Normal">Ticket Created</div>
                                            </div>
                                            <div class="Label">
                                                <div class="TimelineIcon OverlaySla"></div>
                                                <div class="Text OverlaySla">SLA Start</div>
                                            </div>
                                            <div class="DateTime">29/01/2018 01:57 PM</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="Normal Section" id="z73ac32bdeec24f0e9d95588ae8919340">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle3">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">检查单</span></div>
                            <% if (ticketCheckList != null && ticketCheckList.Count > 0)
                                { %>
                            <div class="Middle"><span class="Text ItemCount"><span>(</span><span id="CompletedCount"><%=ticketCheckList.Where(_=>_.is_competed==1).ToList().Count %></span><span>/<%=ticketCheckList.Count %>)</span></span><a class="Button ButtonIcon Link NormalState" id="CheckMange" onclick="HideItem()" tabindex="0">隐藏完成条目</a></div>
                            <%} %>
                            <div class="Spacer"></div>
                            <div class="Right"></div>
                        </div>
                        <div class="Content">
                            <div class="Checklist">
                                <% if (ticketCheckList != null && ticketCheckList.Count > 0)
                                    {
                                        var srDal = new EMT.DoneNOW.DAL.sys_resource_dal();
                                        ticketCheckList = ticketCheckList.OrderBy(_ => _.sort_order).ToList();
                                        foreach (var ticketCheck in ticketCheckList)
                                        {
                                            var thisCreate = srDal.FindNoDeleteById(ticketCheck.create_user_id);
                                %>
                                <div class="ChecklistItem <%=ticketCheck.is_competed==1?"Completed":"" %>" data-val="<%=ticketCheck.id %>">
                                    <div class="ChecklistIcon CheckBox <%=ticketCheck.is_competed==1?"Checked":"Empty" %>">
                                        <div class="Icon" tabindex="0"></div>
                                    </div>
                                    <div class="Description"><span class="Title"><%=ticketCheck.sort_order==null?"":((decimal)ticketCheck.sort_order).ToString("#0") %></span><span class="Important"><%=ticketCheck.is_important==1?"!":"" %></span><span class="CompletedBy"><%=ticketCheck.is_competed==1?EMT.Tools.Date.DateHelper.ConvertStringToDateTime(ticketCheck.create_time).ToString("yyyy-MM-dd")+(thisCreate==null?"":thisCreate.name):"" %></span></div>
                                </div>
                                <%
                                        }
                                    } %>
                                <div class="AllItemsCompleted Hidden"></div>
                            </div>
                        </div>
                    </div>
                    <div class="Normal Section" id="zceee7ec547874037add9b9a8c87c44dd">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle4">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">解决方案</span></div>
                            <div class="Middle"></div>
                            <div class="Spacer"></div>
                            <div class="Right"></div>
                        </div>
                        <div class="Content">
                            <div class="EntityBodyEnhancedText"><span class="Content"><%=thisTicket.resolution %></span></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="AccessoryTabButtonBar">
                <div class="Button TicketButton SelectedState" id="z8479140f8ede469db9b4c2aa9717bea5">
                    <div class="Text">Activity</div>
                </div>
                <div class="Button TicketButton NormalState" id="z7b45f31108934400a8a2fedbb46de972">
                    <div class="Text">Charges &amp; Expenses (0)</div>
                </div>
                <div class="Button TicketButton NormalState" id="ze57643eeffa34687a4c5a43efabbdc18">
                    <div class="Text">Service Calls &amp; To-Dos (0)</div>
                </div>
                <div class="Spacer Small"></div>
            </div>
            <div class="TabContainer Active ActivityTabContainer">
                <div class="ActivityTabShell" id="z66e25f96af534e079844de5b415f4dfc">
                    <div class="LoadingIndicator"></div>
                    <%--<div class="Content">
                        <div class="ToolBar">
                            <div class="ToolBarItem Left ButtonGroupStart"><a class="Button ButtonIcon Time NormalState" id="zc1d534eee8a045aba876a8636414a64c" tabindex="0"><span class="Icon"></span><span class="Text">New Time Entry</span></a></div>
                            <div class="ToolBarItem Left"><a class="Button ButtonIcon Note Navigation NormalState" id="z063829063ee24c53a5e964e474538c35" tabindex="0"><span class="Icon"></span><span class="Text">New Note</span></a></div>
                            <div class="ToolBarItem Left ButtonGroupEnd"><a class="Button ButtonIcon Attachment Navigation NormalState" id="z9c876b59dbcb430687e56944c42eda8e" tabindex="0"><span class="Icon"></span><span class="Text">New Attachment</span></a></div>
                            <div class="ButtonGroupDivider"></div>
                            <div class="ToolBarItem Left ButtonGroupStart ButtonGroupEnd LockedWidth"><a class="Button ButtonIcon IconOnly Refresh NormalState" id="zdb655bb8bdbf423a99c1453a420ccb56" tabindex="0"><span class="Icon"></span><span class="Text"></span></a></div>
                            <div class="Spacer"></div>
                        </div>
                        <div class="QuickNote Starter" id="z5a800ff1e8144c8c80a31334e10bf0a3">
                            <div class="Avatar">
                                <div class="Initials ColorSwatch ColorSample Color4">ll</div>
                            </div>
                            <div class="Details">
                                <div class="Editor TextArea" data-editor-id="z8507795bdd3043a9a4fd6c1ad1325d43" data-rdp="z8507795bdd3043a9a4fd6c1ad1325d43">
                                    <div class="InputField">
                                        <textarea class="Medium" id="z8507795bdd3043a9a4fd6c1ad1325d43" name="Text" placeholder="Add a note..." data-val-length="Character limit (2000) exceeded" data-val-length-max="2000" data-val-editor-id="z8507795bdd3043a9a4fd6c1ad1325d43" data-val-position="0"></textarea>
                                    </div>
                                    <div class="CharacterInformation"><span class="CurrentCount">0</span>/<span class="Maximum">2000</span></div>
                                </div>
                                <div class="ButtonBar">
                                    <div class="Editor SingleSelect" data-editor-id="z34f11c636d8f4e4385a09bbd3adddbf4" data-rdp="z34f11c636d8f4e4385a09bbd3adddbf4">
                                        <div class="InputField">
                                            <select id="z34f11c636d8f4e4385a09bbd3adddbf4" name="NoteTypes">
                                                <option value="2" title="Task Detail">Task Detail</option>
                                                <option value="3" title="Task Notes">Task Notes</option>
                                                <option value="1" title="Task Summary" selected="selected">Task Summary</option>
                                            </select>
                                        </div>
                                    </div>
                                    <a class="Button ButtonIcon SuggestiveBackground DisabledState" id="ze5791323c1584d79b5df5c226ae47437" tabindex="0"><span class="Icon"></span><span class="Text">Save</span></a><a class="Button ButtonIcon NormalState" id="z4f4f15cb69394dfc90ca3cf4d0a8e405" tabindex="0"><span class="Icon"></span><span class="Text">Cancel</span></a>
                                </div>
                                <div class="OptionBar">
                                    <div class="OptionBarRow">
                                        <div class="OptionBarHalf">
                                            <div class="Editor CheckBox" data-editor-id="z328394d108d644a1b4bc839f84725b6e" data-rdp="z328394d108d644a1b4bc839f84725b6e">
                                                <div class="InputField">
                                                    <div>
                                                        <input id="z328394d108d644a1b4bc839f84725b6e" type="checkbox" value="true" name="IsInternal">
                                                    </div>
                                                    <div class="EditorLabelContainer">
                                                        <div class="Label">
                                                            <label for="z328394d108d644a1b4bc839f84725b6e">Internal Only</label>
                                                        </div>
                                                    </div>
                                                    <input id="z328394d108d644a1b4bc839f84725b6e_HiddenField" name="IsInternal" type="hidden" value="false">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="OptionBarHalf">
                                            <div class="Editor CheckBox" data-editor-id="z197c8a33a9f2493c966387184598875c" data-rdp="z197c8a33a9f2493c966387184598875c">
                                                <div class="InputField">
                                                    <div>
                                                        <input id="z197c8a33a9f2493c966387184598875c" type="checkbox" value="true" name="IsNotifyingContact">
                                                    </div>
                                                    <div class="EditorLabelContainer">
                                                        <div class="Label">
                                                            <label for="z197c8a33a9f2493c966387184598875c">Notify Ticket Contact<span class="SecondaryText">Mr. laoliu 139</span></label>
                                                        </div>
                                                    </div>
                                                    <input id="z197c8a33a9f2493c966387184598875c_HiddenField" name="IsNotifyingContact" type="hidden" value="false">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="OptionBarRow">
                                        <div class="OptionBarHalf">
                                            <div class="Editor CheckBox" data-editor-id="z2824c420ba444bd99d92529b5ec39394" data-rdp="z2824c420ba444bd99d92529b5ec39394">
                                                <div class="InputField">
                                                    <div>
                                                        <input id="z2824c420ba444bd99d92529b5ec39394" type="checkbox" value="true" name="IsNotifyingPrimaryResource">
                                                    </div>
                                                    <div class="EditorLabelContainer">
                                                        <div class="Label">
                                                            <label for="z2824c420ba444bd99d92529b5ec39394">Notify Primary Resource<span class="SecondaryText">Hong Li</span></label>
                                                        </div>
                                                    </div>
                                                    <input id="z2824c420ba444bd99d92529b5ec39394_HiddenField" name="IsNotifyingPrimaryResource" type="hidden" value="false">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="OptionBarHalf">
                                            <div class="Editor CheckBox" data-editor-id="z4464ac061e5246e594236233210682ad" data-rdp="z4464ac061e5246e594236233210682ad">
                                                <div class="InputField">
                                                    <div>
                                                        <input id="z4464ac061e5246e594236233210682ad" type="checkbox" value="true" name="IsNotifyingInternalContributors" title="This will send notification to all resources that: created this ticket, have edited this ticket, are Primary Resource on this ticket, are Secondary Resource on this ticket, have a time entry on this ticket, have a note on this ticket, have an attachment on this ticket, and/or have a charge on this ticket.">
                                                    </div>
                                                    <div class="EditorLabelContainer">
                                                        <div class="Label" title="This will send notification to all resources that: created this ticket, have edited this ticket, are Primary Resource on this ticket, are Secondary Resource on this ticket, have a time entry on this ticket, have a note on this ticket, have an attachment on this ticket, and/or have a charge on this ticket.">
                                                            <label for="z4464ac061e5246e594236233210682ad">Notify All Internal Ticket Contributors</label>
                                                        </div>
                                                    </div>
                                                    <input id="z4464ac061e5246e594236233210682ad_HiddenField" name="IsNotifyingInternalContributors" type="hidden" value="false">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="ActivityFilterBar" id="z4fd29825aacb4b10ac77eaaf6d152adf">
                            <div class="FilterBarRow">
                                <div class="FilterBarHalf">
                                    <div class="Editor CheckBox" data-editor-id="z02e456849e0f4ee3b7840f0f4ec012fd" data-rdp="z02e456849e0f4ee3b7840f0f4ec012fd">
                                        <div class="InputField">
                                            <div>
                                                <input id="z02e456849e0f4ee3b7840f0f4ec012fd" type="checkbox" value="true" name="AreSystemNotesVisible">
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="z02e456849e0f4ee3b7840f0f4ec012fd">Show System Notes</label>
                                                </div>
                                            </div>
                                            <input id="z02e456849e0f4ee3b7840f0f4ec012fd_HiddenField" name="AreSystemNotesVisible" type="hidden" value="false">
                                        </div>
                                    </div>
                                </div>
                                <div class="FilterBarHalf">
                                    <div class="Editor CheckBox" data-editor-id="z102c563bff7f4988b35cf8f86db2b9fe" data-rdp="z102c563bff7f4988b35cf8f86db2b9fe">
                                        <div class="InputField">
                                            <div>
                                                <input id="z102c563bff7f4988b35cf8f86db2b9fe" type="checkbox" value="true" name="IsBillingDataVisible">
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="z102c563bff7f4988b35cf8f86db2b9fe">Show Billing Data</label>
                                                </div>
                                            </div>
                                            <input id="z102c563bff7f4988b35cf8f86db2b9fe_HiddenField" name="IsBillingDataVisible" type="hidden" value="false">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="ActivityAdvancedOptions">
                            <a class="Button ButtonIcon Filter" id="z9c4661e773034f6eaf6f24751c957d8f"><span class="Icon"></span><span class="Text">Filter</span></a><div class="ContextOverlayContainer" id="zd158cb58b48f4afb94a8dbda8a2e8538">
                                <div class="ActivityFilterContextOverlay ContextOverlay">
                                    <div class="Outline Arrow"></div>
                                    <div class="Arrow"></div>
                                    <div class="Active LoadingIndicator"></div>
                                    <div class="Content"></div>
                                </div>
                                <div class="ActivityFilterContextOverlay ContextOverlay">
                                    <div class="Outline Arrow"></div>
                                    <div class="Arrow"></div>
                                    <div class="Active LoadingIndicator"></div>
                                    <div class="Content"></div>
                                </div>
                            </div>
                            <a class="Button ButtonIcon IconOnly Cancel DisabledState" id="z91e10bf21c8b4d12b1872f9ebb7adced" tabindex="0" title="Clear filters"><span class="Icon"></span><span class="Text"></span></a>
                            <input id="zf8922504443f4a1f9f5f7d2785bf0db5" type="text" value="" placeholder="Search..."><select id="zefd9896e85674d47a16f5fdcdb13ac09"><option value="OldestFirst" title="Oldest First">Oldest First</option>
                                <option value="NewestFirst" title="Newest First" selected="selected">Newest First</option>
                                <option value="NewestFirstWithEscalation" title="The &quot;Newest First with Escalation&quot; option will move a conversation to the start of the Activity feed when a reply is made to it">Newest First with Escalation</option>
                            </select>
                        </div>
                        <div class="QuickNote ConversationItem Reply" id="z34c75ffde4de4899b95d1707f3ca0bbd">
                            <div class="Avatar">
                                <div class="Initials ColorSwatch ColorSample Color4">ll</div>
                            </div>
                            <div class="Details">
                                <div class="Editor TextArea" data-editor-id="zf1f0799004604e71a0787c04393bc9db" data-rdp="zf1f0799004604e71a0787c04393bc9db">
                                    <div class="InputField">
                                        <textarea class="Medium" id="zf1f0799004604e71a0787c04393bc9db" name="Text" placeholder="Add a note..." data-val-length="Character limit (2000) exceeded" data-val-length-max="2000" data-val-editor-id="zf1f0799004604e71a0787c04393bc9db" data-val-position="0"></textarea>
                                    </div>
                                    <div class="CharacterInformation"><span class="CurrentCount">0</span>/<span class="Maximum">2000</span></div>
                                </div>
                                <div class="ButtonBar">
                                    <div class="Editor SingleSelect" data-editor-id="zeda08e57a87743bdb33dc72fc6807c62" data-rdp="zeda08e57a87743bdb33dc72fc6807c62">
                                        <div class="InputField">
                                            <select id="zeda08e57a87743bdb33dc72fc6807c62" name="NoteTypes">
                                                <option value="2" title="Task Detail">Task Detail</option>
                                                <option value="3" title="Task Notes">Task Notes</option>
                                                <option value="1" title="Task Summary" selected="selected">Task Summary</option>
                                            </select>
                                        </div>
                                    </div>
                                    <a class="Button ButtonIcon SuggestiveBackground DisabledState" id="z6e9674f3e4f1460590c05a81650f7d67" tabindex="0"><span class="Icon"></span><span class="Text">Save</span></a><a class="Button ButtonIcon NormalState" id="z9cbee3e2974943068f2909a94c9f3134" tabindex="0"><span class="Icon"></span><span class="Text">Cancel</span></a>
                                </div>
                                <div class="OptionBar">
                                    <div class="OptionBarRow">
                                        <div class="OptionBarHalf">
                                            <div class="Editor CheckBox" data-editor-id="z1a2f3ec7e5474cfe93ea395ea117c324" data-rdp="z1a2f3ec7e5474cfe93ea395ea117c324">
                                                <div class="InputField">
                                                    <div>
                                                        <input id="z1a2f3ec7e5474cfe93ea395ea117c324" type="checkbox" value="true" name="IsInternal">
                                                    </div>
                                                    <div class="EditorLabelContainer">
                                                        <div class="Label">
                                                            <label for="z1a2f3ec7e5474cfe93ea395ea117c324">Internal Only</label>
                                                        </div>
                                                    </div>
                                                    <input id="z1a2f3ec7e5474cfe93ea395ea117c324_HiddenField" name="IsInternal" type="hidden" value="false">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="OptionBarHalf">
                                            <div class="Editor CheckBox" data-editor-id="zd2d6251f69ad497cba1ba2d8c5b6abc5" data-rdp="zd2d6251f69ad497cba1ba2d8c5b6abc5">
                                                <div class="InputField">
                                                    <div>
                                                        <input id="zd2d6251f69ad497cba1ba2d8c5b6abc5" type="checkbox" value="true" name="IsNotifyingOriginalAuthor" title="Notify the person you are replying to">
                                                    </div>
                                                    <div class="EditorLabelContainer">
                                                        <div class="Label" title="Notify the person you are replying to">
                                                            <label for="zd2d6251f69ad497cba1ba2d8c5b6abc5">Notify</label>
                                                        </div>
                                                    </div>
                                                    <input id="zd2d6251f69ad497cba1ba2d8c5b6abc5_HiddenField" name="IsNotifyingOriginalAuthor" type="hidden" value="false">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="ContextOverlayContainer" id="ze18290e9e4c84920b99ca7cd87630d12">
                            <div class="ContextOverlay">
                                <div class="Active LoadingIndicator"></div>
                                <div class="Content"></div>
                            </div>
                            <div class="ContextOverlay">
                                <div class="Active LoadingIndicator"></div>
                                <div class="Content"></div>
                            </div>
                        </div>
                        <div class="Conversation" id="z988ba7ab91bb4b5d8ddf519a016bd325">
                            <div class="ConversationChunk">
                                <div class="ConversationFooter"></div>
                            </div>
                        </div>
                        <div class="NoDataMessage Active">No items to display</div>
                    </div>--%>
                </div>
            </div>
            <div class="TabContainer AccessoryTabContainer">
                <div class="AccessoryTabShell" id="zd9246c791c7041768fba9d569d925414">
                    <div class="LoadingIndicator"></div>
                    <div class="TransitionContainer"></div>
                    <div class="Content" id="zdaeb784a648341d2b3c73bf6c7cacb9f"></div>
                </div>
            </div>
        </div>
        <div class="SecondaryContainer Right">
            <div class="TabButtonContainer">
                <div>
                    <div class="TabButton EntityPageTabIcon Details" onclick="autotask.findPage().__toggleSecondaryContainer();">
                        <div class="Icon"></div>
                        <div class="Text">Details</div>
                    </div>
                </div>
                <div>
                    <div class="TabButton EntityPageTabIcon Insights Active">
                        <div class="Icon"></div>
                        <div class="Text">Insights</div>
                    </div>
                </div>
            </div>
            <div class="InsightContainer" id="z2f17c82a79b54ecf86b9d5d2999110b6">
                <div class="LoadingIndicator Transition Fade">
                    <div class="Icon"></div>
                </div>
                <div class="InsightShell Collapsed" id="za732b4150b1147c19e730b3785638172">
                    <div class="Title Title5">
                        <div class="Text">客户/联系人 </div>
                        <div class="Toggle">
                            <div class="InlineIcon ArrowUpSmall"></div>
                        </div>
                    </div>
                    <div class="ContentContainer">
                        <div class="LoadingIndicator"></div>
                        <div class="TransitionContainer Transition"></div>
                        <div class="Content">
                            <div class="LinkButton HighImportance ShowAccInfo"><a class="Button ButtonIcon Link NormalState" id="TranAccount"></a></div>
                            <div class="Bundle ShowAccInfo">
                                <div class="LinkButton ShowAccInfo">
                                    <a class="Button ButtonIcon Link NormalState" id="TranAccSit"></a>

                                </div>
                            </div>
                            <div class="NormalSpacer"></div>
                            <div class="Text Address ShowAccInfo" id="ShowAccAddress">

                                <div class="InsightIconButton">
                                    <div class="InlineIconButton InlineIcon Map NormalState"></div>
                                </div>
                            </div>
                            <div class="NormalSpacer"></div>
                            <div class="Text ShowAccInfo" id="AccPhone"></div>
                            <div class="Text ShowAccInfo"></div>
                            <div class="Text ShowAccInfo"></div>
                            <div class="NormalSpacer"></div>
                            <div class="LinkButton ShowAccInfo"><a class="Button ButtonIcon Link NormalState" id="AccTicketHref" tabindex="0"></a></div>
                            <div class="LinkButton ShowAccInfo">
                                <a class="Button ButtonIcon Link NormalState" id="ShowLastTicket" tabindex="0"></a>
                            </div>
                            <div class="Divider">
                                <div class="Line"></div>
                            </div>
                            <div class="Bundle">
                                <div class="LinkButton HighImportance ShowContactInfo"><a class="Button ButtonIcon Link NormalState" id="TranContact" tabindex="0"></a></div>
                                <div class="InsightIconButton" style="display: none;">
                                    <div class="InlineIconButton InlineIcon Note NormalState" id="zc52f76470ea54233a6c504a044665bef" title="Notify Contact: "></div>
                                </div>
                            </div>
                            <div class="Text"></div>
                            <div class="NormalSpacer"></div>
                            <div class="Text ShowContactInfo" id="ContactPhone"></div>
                            <div class="LinkButton ShowContactInfo"><a class="Button Mailto Link" href="mailto:"></a></div>
                            <div class="NormalSpacer"></div>
                            <div class="LinkButton ShowContactInfo"><a class="Button ButtonIcon Link NormalState" id="TranContactTicket" tabindex="0">All Open Tickets (11)</a></div>
                            <div class="LinkButton ShowContactInfo"><a class="Button ButtonIcon Link NormalState" id="z5e2301fad3194aebac208b89873bb85d" tabindex="0">Last 30 Days (2)</a></div>
                        </div>
                    </div>
                </div>
                <div class="InsightShell Collapsed">
                    <div class="Title Title6">
                        <div class="Text">工时汇总</div>
                        <div class="Toggle">
                            <div class="InlineIcon ArrowUpSmall"></div>
                        </div>
                    </div>
                    <div class="ContentContainer">
                        <div class="LoadingIndicator"></div>
                        <div class="TransitionContainer"></div>
                        <div class="Content" id="z9ac8e203dc7e4dfab0d0a982b4afeece">
                            <table class="Table" cellpadding="0">
                                <tbody>
                                    <tr class="TableRow">
                                        <td>
                                            <div class="Text LowImportance">实际工时</div>
                                        </td>
                                        <td>
                                            <div class="Text LowImportance">预估工时</div>
                                        </td>
                                    </tr>
                                    <tr class="TableRow">
                                        <td>
                                            <div class="Text HighImportance" title="5.00 worked hours">5h</div>
                                        </td>
                                        <td>
                                            <div class="Text HighImportance"><%=thisTicket.estimated_hours.ToString("#0.00")+'h' %></div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="NormalSpacer"></div>
                            <div class="ProgressBar">
                                <div class="Bar" title="250% of Estimated Hours worked">
                                    <div class="Progress IsGreaterThanZero Critical" style="width: 100.00%;"></div>
                                </div>
                                <div class="Text CriticalImportance">
                                    <div class="Text" style="display: inline;">2h 59m</div>
                                    Over Estimate
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="InsightShell Collapsed" id="z48d3540e2e584765910e8058b1be991f">
                    <div class="Title Title7">
                        <div class="Text">配置项</div>
                        <div class="Toggle">
                            <div class="InlineIcon ArrowUpSmall"></div>
                        </div>
                    </div>
                    <div class="ContentContainer">
                        <div class="LoadingIndicator"></div>
                        <div class="TransitionContainer Transition"></div>
                        <div class="Content" id="InsProInfoDiv">
                            <div class="Text LowImportance">名称</div>
                            <div class="LinkButton HighImportance"><a class="Button ButtonIcon Link NormalState" id="InsProName" tabindex="0"></a></div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">联系人</div>
                            <div class="Bundle">
                                <div class="LinkButton HighImportance"><a class="Button ButtonIcon Link NormalState" id="InsProContact" tabindex="0"></a></div>
                            </div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">安装</div>
                            <div class="Text HighImportance" id="InsProInstallTime"></div>
                            <div class="Bundle">
                                <div class="Text HighImportance" id="InsProInstallUser"></div>
                            </div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">保修期</div>
                            <div class="Text HighImportance" id="InsProWarnTime"></div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">供应商</div>
                            <div class="LinkButton HighImportance"><a class="Button ButtonIcon Link NormalState" id="InsProVendor" tabindex="0"></a></div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">服务水平协议</div>
                            <div class="Text CriticalImportance" id="InsProService"></div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">相关配置项</div>
                            <div class="Text HighImportance" id="InsProRelated">0</div>
                            <div class="NormalSpacer"></div>
                            <div class="Text">All Open Tickets (0)</div>
                            <div class="Text">Total Tickets (0)</div>
                        </div>
                        <div class="Content" id="NoInsProShow">
                            <div class="Text NoData VeryLowImportance">暂无配置项信息</div>
                        </div>
                    </div>
                </div>
                <div class="InsightShell Invisible" id="za4e05a3de99042b09d62b550b4b766bf" style="display: none;">
                    <div class="Title">
                        <div class="Text">商机</div>
                        <div class="Toggle">
                            <div class="InlineIcon ArrowUpSmall"></div>
                        </div>
                    </div>
                    <div class="ContentContainer">
                        <div class="LoadingIndicator"></div>
                        <div class="TransitionContainer"></div>
                        <div class="Content" id="z9f356c8974c1409b855378914d4caef6"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="BackgroundOverLay"></div>
    <div class="Dialog Large" style="margin-left: 400px; margin-top: -1100px; z-index: 100; height: 350px; width: 350px; display: none;" id="DeleteTicketDialog">
        <div>
            <div class="CancelDialogButton" id="CloseDeleteTicketReson"></div>
            <div class="Active ThemePrimaryColor TitleBar">
                <div class="Title"><span class="Text">消息</span><span class="SecondaryText"></span></div>
            </div>
            <div class="DialogHeadingContainer">
                <div class="ValidationSummary" id="">
                    <div class="CustomValidation Valid"></div>
                    <div class="FormValidation Valid">
                        <div class="ErrorContent">
                            <div class="TransitionContainer">
                                <div class="IconContainer">
                                    <div class="Icon"></div>
                                </div>
                                <div class="TextContainer"><span class="Count"></span><span class="Count Spacer"></span><span class="Message"></span></div>
                            </div>
                        </div>
                        <div class="ChevronContainer">
                            <div class="Up"></div>
                            <div class="Down"></div>
                        </div>
                    </div>
                </div>
                <div class="ButtonContainer">
                    <a class="Button ButtonIcon Save NormalState" id="SaveAndCloseRepeatButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">OK</span></a>
                </div>
            </div>

            <div class="ScrollingContentContainer">
                <div class="ScrollingContainer" id="" style="position: unset;">
                    <div class="Instructions">
                        <div class="InstructionItem">工单不能删除，原因参见以下说明：:</div>
                    </div>

                    <div class="Medium Section">
                        <div class="Heading">
                            <div class="Left"><span class="Text">Deletion Failed</span><span class="SecondaryText"></span></div>
                            <div class="Spacer"></div>
                        </div>
                        <div class="Content">
                            <div class="Normal Column">
                                <div class="StandardText">
                                    <%=thisTicket.no %> - <%=thisTicket.title %> (<%=thisAccount==null?"":thisAccount.name %>)						
                                </div>
                                <div class="CustomLayoutContainer">
                                    <div class="TicketDeletionDialog_Container">
                                        <ul class="TicketDeletionDialog_UnorderedList" id="DeletTicketReasonUl">
                                           
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<!--页面常规信息js操作 -->
<script>
    var backImg = ["up.png", "down.png"];
    var index1 = 0; var index2 = 0; var index3 = 0; var index4 = 0; var index5 = 0; var index6 = 0; var index7 = 0;
    $(".Title1").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index1 % 2] + ")");
        index1++;
    });
    $(".Title2").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index2 % 2] + ")");
        index2++;
    });
    $(".Title3").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index3 % 2] + ")");
        index3++;
    });
    $(".Title4").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index4 % 2] + ")");
        index4++;
    });
    $(".Title5").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index5 % 2] + ")");
        index5++;
    });
    $(".Title6").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index6 % 2] + ")");
        index6++;
    });
    $(".Title7").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index7 % 2] + ")");
        index7++;
    });

    var colors = ["#white", "white"];
    var color1 = 0; var color2 = 0; var color3 = 0;
    $(".Toggle1").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[color1 % 2]);
        color1++;
    });
    $(".Toggle2").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[color2 % 2]);
        color2++;
    });
    $(".Toggle3").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[color3 % 2]);
        color3++;
    });
    // ToolLi
    // Down2
    $("#ToolLi").on("mousemove", function () {
        $("#Down2").show();
        $(this).css("border-bottom", "1px solid white").css("background", "white");
    }).on("mouseout", function () {
        $("#Down2").hide();
        $(this).css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
    });
    $("#Down2").on("mousemove", function () {
        $(this).show();
        $("#ToolLi").css("border-bottom", "1px solid white").css("background", "white");
    }).on("mouseout", function () {
        $(this).hide();
        $("#ToolLi").css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
    });



    var hour, minute, second;//时 分 秒
    hour = minute = second = 0;//初始化
    //var millisecond = 0;//毫秒
    var int;
    function Reset()//重置
    {
        window.clearInterval(int);
        hour = minute = second = 0;
        //document.getElementById('timetext').value = '00时00分00秒000毫秒';
        $("#ShowWatchTime").html("00:00:00");
        $("#PlayTimeDiv").removeClass("noplay");
        $("#PlayTimeDiv").addClass("Play");
        stop();
    }

    function start()//开始
    {
        int = setInterval(timer, 1000);
    }

    function timer()//计时
    {

        second = second + 1;

        if (second >= 60) {
            second = 0;
            minute = minute + 1;
        }

        if (minute >= 60) {
            minute = 0;
            hour = hour + 1;
        }
        if (hour >= 24) {
            hour = 0;
        }
        $("#ShowWatchTime").html(Return2(hour) + ":" + Return2(minute) + ":" + Return2(second));
    }

    function stop()//暂停
    {
        window.clearInterval(int);
    }

    function Return2(num) {
        if (Number(num) < 10) {
            return "0" + num;
        }
        else {
            return num;
        }
    }

    $("#PlayTimeDiv").click(function () {
        if ($(this).hasClass("Play")) {
            $(this).removeClass("Play");
            $(this).addClass("noplay");
            start();
        }
        else {
            $(this).removeClass("noplay");
            $(this).addClass("Play");
            stop();
        }
    })

    var toId = "";
    var type = "in";

    function drag() {

        // var obj = $('#Drap .HighImportance');
        var obj = $('#Drap .Interaction');
        obj.bind('mousedown', DragStart);
        function DragStart(e) {
            var ol = obj.parent().offset().left;
            var ot = obj.parent().offset().top;
            deltaX = e.pageX - ol;
            deltaY = e.pageY - ot;
            $(this).trigger("click");
            $(document).bind({
                'mousemove': move,
                'mouseup': DragStop
            });
            return false;
        }
        function move(e) {


            $.each(obj.parent().siblings(), function (i) {
                var mX = obj.parent().siblings().eq(i).offset().left;
                var mY = obj.parent().siblings().eq(i).offset().top;
                if (e.pageX > mX && e.pageX < mX + obj.parent().siblings().eq(i).width() && e.pageY > mY && e.pageY < mY + obj.parent().siblings().eq(i).height()) {
                    obj.parent().css('cursor', 'move')
                    obj.css('cursor', 'move')
                    $('.border_left').show()
                    $('.border_right').show()
                    type = "in";
                    $('.border-line').hide()
                    $('.border_left').css({
                        "left": 0,
                        "top": obj.parent().siblings().eq(i).children('.Interaction').offset().top - $('.RowContainer').offset().top + obj.parent().siblings().eq(i).height() / 2 - 8,
                    })
                    $('.border_right').css({
                        "right": 0,
                        "top": obj.parent().siblings().eq(i).children('.Interaction').offset().top - $('.RowContainer').offset().top + obj.parent().siblings().eq(i).height() / 2 - 8,
                    })
                    $('.cover').show()
                    $('.cover').css({
                        "left": (e.pageX + $('.cover').width() + 10) - $('.RowContainer').offset().left,
                        "top": (e.pageY - $('.RowContainer').offset().top),
                        "display": 'block'
                    })

                    $('.cover').html(obj.parent().siblings().eq(i).find('.Num').html());
                    toId = obj.parent().siblings().eq(i).data("val");  // 代表将要放的位置的id

                } else {
                    obj.parent().css('cursor', 'none')
                }
                if (e.pageY > mY - 5 && e.pageY < mY + 5) {
                    type = "above";
                    $('.border-line').show()
                    $('.border-line').css({
                        'top': mY - $('.RowContainer').offset().top
                    })
                    $('.border_left').css({
                        "left": 0,
                        "top": mY - $('.RowContainer').offset().top - 6
                    })
                    $('.border_right').css({
                        "right": 0,
                        "top": mY - $('.RowContainer').offset().top - 6
                    })
                    //obj.css('border-top','1px solid #346a95')
                    if (e.pageY < mY) {
                        $('.cover').html(obj.parent().siblings().eq(i).find('.Num').html());
                        // toId = obj.data("val");
                    }
                }
            })

            // obj.css({
            //     "left": (e.pageX - deltaX),
            //     "top": (e.pageY - deltaY),
            //     "cursor":'move'
            // });


            return false;
        }
        function DragStop() {

            $('.cover').hide()
            $('.border_right').hide()
            $('.border_left').hide()
            $('.border-line').hide()
            obj.parent().css('cursor', '')
            obj.parent().find('.Interaction').css('cursor', '')
            $(document).unbind({
                'mousemove': move,
                'mouseup': DragStop,
                "cursor": 'pointer'
            });
            //DragTask();
        }
    }
    drag();
    $(".IconContainer").on('click', function () {
        if ($(this).hasClass("Selected")) {
            $(this).removeClass('Selected');

        }
        else {
            $(this).addClass('Selected');
        }
        $(this).find('.Vertical').toggle();
        var _this = $(this).parent().parent().parent();
        var str = _this.find('.DataDepth').attr('data-depth');

    });

    $(".CopyTextButton").click(function () {
        $(this).children().first().next().focus();
        $(this).children().first().next().select();
        if (document.execCommand('copy', false, null)) {

        }
    })

    $(".Dot").mouseover(function (event) {

        var Left = $(document).scrollLeft() + event.clientX;
        var Top = $(document).scrollTop() + event.clientY;

        var menuWidth = $(this).next().children().first().width();
        var menuHeight = $(this).next().children().first().height();
        var scrLeft = $(document).scrollLeft();
        var scrTop = $(document).scrollTop();


        $(this).next().children().first().css("left", menuWidth + scrLeft + 265 + "px");
        $(this).next().children().first().css("margin-top", Top - 145 + "px");
        $(this).next().children().first().show();

    })
    $(".Dot").mouseleave(function () {
        $(this).next().children().first().hide();
    })

    $(".Dot").mouseout(function () {
        $(this).next().children().first().hide();
    })
    // 隐藏完成的检查单
    function HideItem() {
        $(".Completed").hide();
        $("#CheckMange").text("显示完成条目");
        $("#CheckMange").removeAttr("onclick");
        $("#CheckMange").click(function () {
            ShowItem();
        })
    }
    // 显示完成的检查单
    function ShowItem() {
        $(".Completed").show();
        $("#CheckMange").text("隐藏完成条目");
        $("#CheckMange").removeAttr("onclick");
        $("#CheckMange").click(function () {
            HideItem();
        })
    }

    $(".TicketButton").click(function () {
        var obj = $(this);
        $(".TicketButton").each(function () {
            $(this).removeClass("SelectedState");
            if (!$(this).hasClass("NormalState")) {
                $(this).addClass("NormalState");
            }
        })
        obj.addClass("SelectedState");
    })

    function GetAccountInfo() {
        var account_id = '<%=thisAccount==null?"":thisAccount.id.ToString() %>';
        if (account_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=GetAccDetail&account_id=" + account_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $(".ShowAccInfo").show();

                        $("#TranAccount").click(function () {
                            OpenAccount(account_id);
                        })
                        $("#TranAccount").text(data.name);

                        $("#TranAccSit").click(function () {
                            OpenAccountSite(account_id);
                        });
                        $("#TranAccSit").text("站点配置");
                        $("#ShowAccAddress").html(data.address2 + "<br />" + data.provice + "&nbsp;" + data.city + "&nbsp;" + data.quXian + "&nbsp;" + "<br />" + data.address1);
                        $("#AccPhone").text(data.phone);
                        if (data.ticketNum != "" && Number(data.ticketNum) > 0) {
                            $("#AccTicketHref").click(function () {
                                OpenAccountTicket(account_id);
                            });

                        }
                        $("#AccTicketHref").text("打开工单（" + data.ticketNum + "）");
                        if (data.monthNum != "" && Number(monthNum) > 0) {
                            $("#ShowLastTicket").click(function () {
                                // OpenAccountTicket(account_idHidden);
                            });
                        }
                        // 

                    } else {
                        $(".ShowAccInfo").hide();
                        $("#TranAccount").removeAttr("onclcik");
                        $("#TranAccount").text("");
                        $("#TranAccSit").removeAttr("onclcik");
                        $("#AccPhone").text("");
                        $("#AccTicketHref").removeAttr("onclcik");
                        $("#ShowLastTicket").removeAttr("onclcik");
                    }
                },
            });
        }
        else {
            $(".ShowAccInfo").hide();
            $("#TranAccount").removeAttr("onclcik");
            $("#TranAccount").text("");
            $("#TranAccSit").removeAttr("onclcik");
            $("#AccPhone").text("");
            $("#AccTicketHref").removeAttr("onclcik");
            $("#ShowLastTicket").removeAttr("onclcik");
        }
    }
    // 获取到联系人信息
    function GetContactInfo() {
        var contact_id = '<%=thisContact==null?"":thisContact.id.ToString() %>';
        if (contact_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContactAjax.ashx?act=GetContactDetail&contact_id=" + contact_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $(".ShowContactInfo").show();

                        $("#TranContact").click(function () {
                            OpenContact(contact_id);
                        })
                        $("#TranContact").text(data.name);

                        $("#ContactPhone").text(data.phone);

                        if (data.ticketNum != "" && Number(data.ticketNum) > 0) {
                            $("#TranContactTicket").click(function () {
                                OpenContactTicket(contact_id);
                            });
                        }
                        $("#TranContactTicket").text("打开工单（" + data.ticketNum + "）");
                        if (data.monthNum != "" && Number(monthNum) > 0) {

                        }
                        // 

                    } else {
                        $(".ShowContactInfo").hide();
                        $("#ContactPhone").text("");

                        $("#TranContactTicket").removeAttr("onclcik");

                    }
                },
            });
        }
        else {
            // 隐藏联系人相关信息
            $(".ShowContactInfo").hide();
        }
    }
    // 获取到配置项信息
    function GetInsProInfo() {
        var installed_product_id = '<%=insPro==null?"":insPro.id.ToString() %>';
        if (installed_product_id != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ProductAjax.ashx?act=GetInsProDetail&insProId=" + installed_product_id,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#InsProInfoDiv").show();
                        $("#NoInsProShow").hide();
                        $("#InsProName").text(data.name);
                        $("#InsProName").click(function () {
                            EditInsPro(installed_product_id);
                        })

                        $("#InsProContact").text(data.contactName);
                        $("#InsProContact").click(function () {
                            OpenContact(data.contactId);
                        })
                        $("#InsProInstallTime").val(data.insTime);
                        $("#InsProInstallUser").val(data.insUser);
                        $("#InsProWarnTime").val(data.insWarnTime);
                        // InsProVendor
                        $("#InsProVendor").text(data.name);
                        $("#InsProVendor").click(function () {
                            OpenAccount(data.vendorId);
                        })

                    }
                    else {
                        $("#InsProInfoDiv").hide();
                        $("#NoInsProShow").show();
                        $("#InsProName").removeAttr("onclick");
                        $("#InsProContact").removeAttr("onclick");
                        $("#InsProName").text("");
                        $("#InsProContact").text("");
                        $("#InsProInstallTime").val("");
                        $("#InsProInstallUser").val("");
                        $("#InsProWarnTime").val("");
                        $("#InsProVendor").removeAttr("onclick");
                        $("#InsProVendor").text("");
                    }
                }
            })
        }
        else {
            $("#InsProInfoDiv").hide();
            $("#NoInsProShow").show();
            $("#InsProName").removeAttr("onclick");
            $("#InsProContact").removeAttr("onclick");
            $("#InsProName").text("");
            $("#InsProContact").text("");
            $("#InsProInstallTime").val("");
            $("#InsProInstallUser").val("");
            $("#InsProWarnTime").val("");
            $("#InsProVendor").removeAttr("onclick");
            $("#InsProVendor").text("");
        }
    }
    // 显示工单的告警信息
    function ShowTicketAlert() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=GetTicketAlert&ticket_id=<%=thisTicket==null?"":thisTicket.id.ToString() %>",
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.accountAlert != "") {
                        $("#AccountAlert").show();
                        $("#AccountAlert").children().first().next().text(data.accountAlert);
                    }
                    else {
                        $("#AccountAlert").hide();
                    }

                }
            },
        });


    }

</script>
<script>
    $(function () {
        start();
        GetAccountInfo();
        GetContactInfo();
        GetInsProInfo();
        ShowTicketAlert();
    })

    // 打开客户
    function OpenAccount(id) {
        if (id != "") {
            window.open("../Company/ViewCompany.aspx?id=" + id, "_blank", 'left=200,top=200,width=800,height=800', false);
        }

    }
    // 打开客户站点
    function OpenAccountSite(id) {
        window.open("../Company/CompanySiteManage.aspx?id=" + id, "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySiteConfiguration %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 打开客户的工单
    function OpenAccountTicket(id) {

    }
    // 打开联系人
    function OpenContact(id) {
        if (id != "") {
            window.open("../Contact/ViewContact.aspx?id=" + id, "_blank", 'left=200,top=200,width=600,height=800', false);
        }

    }
    // 添加工单的备注
    // 
    function AddTicketNote(type) {
        window.open("../ServiceDesk/TicketNote.aspx?ticket_id=<%=thisTicket.id %>&type=" + type, "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_NOTE %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 跳转到修改工单相关功能
    function EditTicket() {
        location.href = "TicketManage?id=<%=thisTicket.id %>";
    }
    // 添加工时
    function AddTimeEntry() {
        // 已完成工单是否可以新增工时
        <%if (thisTicket.status_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE)
    { %>
        $.ajax({
            type: "GET",
            url: "../Tools/GeneralAjax.ashx?act=GetSysSetting&sys_id=<%=(int)EMT.DoneNOW.DTO.SysSettingEnum.SDK_TICKET_ADD_LABOUR %>",
            async: false,
            success: function (data) {
                if (data != "") {
                    if (data.setting_value == "1") {
                        window.open("../ServiceDesk/TicketLabour.aspx?ticket_id=<%=thisTicket.id %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_LABOUR %>", 'left=200,top=200,width=600,height=800', false);
                    }
                }
            }
        })
        <%}
    else
    {%>
        window.open("../ServiceDesk/TicketLabour.aspx?ticket_id=<%=thisTicket.id %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_LABOUR %>", 'left=200,top=200,width=600,height=800', false);
        <%}%>


    }
    // 完成工单--添加工时，默认工单状态为完成
    function CompleteEntry() {
        window.open("../ServiceDesk/TicketLabour.aspx?ticket_id=<%=thisTicket.id %>&status_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_LABOUR %>", 'left=200,top=200,width=600,height=800', false);
    }

    // 新增工单附件
    function AddTicketAttachment() {
        window.open("../Activity/AddAttachment.aspx?objId=<%=thisTicket.id %>&objType=<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_OBJECT_TYPE.TASK %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_NOTE %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 新增工单费用
    function AddTicketExpense() {
        window.open("../Project/ExpenseManage.aspx?ticket_id=<%=thisTicket.id %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_EXPENSE %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 添加工单成本
    function AddTicketCharge() {

    }




    // 跳转到编辑配置项相关页面
    function EditInsPro(id) {
        if (id != "") {
            window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + id, "<%=(int)EMT.DoneNOW.DTO.OpenWindow.EditInstalledProduct %>", 'left=200,top=200,width=600,height=800', false);
        }
    }
    // 查看合同
    function ViewContract(contract_id) {
        if (contract_id != "") {
            window.open("../Contract/ContractView.aspx?id=" + contract_id, "_blank", 'left=200,top=200,width=600,height=800', false);
        }
    }
    // 点击进行检查单完成取消操作
    $(".ChecklistIcon").click(function () {
        var ckId = $(this).parent().data("val")
        var isCom = "1";
        if ($(this).hasClass("Checked")) {
            isCom = "0";
        }
        var obj = $(this);
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=ChangeCheckComplete&check_id=" + ckId + "&is_com=" + isCom,
            async: false,
            success: function (data) {
                if (data != "") {

                }
            }
        })
        var count = $("#CompletedCount").text();
        var isCom = obj.parent().hasClass("Completed");
        var creaInfo = obj.next().children().first().next().next().text();
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=GetCheckInfo&check_id=" + ckId,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    isCom = data.isCom;
                    creaInfo = data.creTime + data.creRes;
                }
            }
        })
        if (isCom) {
            if (!obj.parent().hasClass("Completed")) {
                obj.parent().addClass("Completed");
            }
            if (!obj.hasClass("Checked")) {
                obj.addClass("Checked");
                obj.removeClass("Empty");
            }
            obj.next().children().first().next().next().text(creaInfo);
            count = Number(count) + 1;

            if ($("#CheckMange").text() == "显示完成条目") {
                $(".Completed").hide();
            }
        }
        else {
            if (obj.parent().hasClass("Completed")) {
                obj.parent().removeClass("Completed");
            }

            if (obj.hasClass("Checked")) {
                obj.addClass("Empty");
                obj.removeClass("Checked");
            }
            obj.next().children().first().next().next().text("");
            count = Number(count) - 1;
        }
        $("#CompletedCount").text(count);

    })
    // 删除工单
    function DeleteTicket() {
        LayerConfirm("确认删除该工单吗？", "是", "否", function () {
            $("#BackgroundOverLay").show();
            $.ajax({
                type: "GET",
                url: "../Tools/TicketAjax.ashx?act=DeleteTicket&ticket_id=<%=thisTicket.id %>",
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.result) {
                            LayerMsg("删除成功！");
                            window.close();
                        }
                        else {
                            // todo 展示删除失败原因弹窗，为失败原因赋值
                            // DeletTicketReasonUl
                            // DeleteTicketDialog
                            if (data.reason != "") {
                                var failHtml = "";
                                var failArr = data.reason.split(';');
                                for (var i = 0; i < failArr.length; i++)
                                {
                                    if (failArr[i] != "") {
                                        failHtml += "<li>" + failArr[i]+"</li>";
                                    }
                                }
                                $("#DeletTicketReasonUl").html(failHtml);
                                $("#DeleteTicketDialog").show();
                            }
                        }
                    }
                }
            })

        }, function () {

        });
    }
    $("#SaveAndCloseRepeatButton").click(function () {
        $("#DeleteTicketDialog").hide();
        $("#BackgroundOverLay").hide();
    })

    $("#CloseDeleteTicketReson").click(function () {
        $("#DeleteTicketDialog").hide();
        $("#BackgroundOverLay").hide();
    })
    // 打开工单历史页面
    function ShowTicketHistory() {
        window.open("../ServiceDesk/TicketHistory.aspx?ticket_id=<%=thisTicket.id %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_LABOUR %>", 'left=200,top=200,width=600,height=800', false);
    }
</script>
