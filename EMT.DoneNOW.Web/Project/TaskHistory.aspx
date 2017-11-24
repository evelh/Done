<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskHistory.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.TaskHistory" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="PageContentContainer">
            <div class="PageHeadingContainer">
                <div class="Active ThemePrimaryColor TitleBar EntityPage">
                    <div class="TitleBarItem Title"><span class="Text">任务历史</span><span class="SecondaryText">(<%=thisTask.no %> - <%=thisTask.title %>)</span></div>
                </div>
                <div class="ValidationSummary" id="zdf46c5e1b4a04571b221cb11c323342b">
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
                <div class="ButtonContainer"><a class="Button ButtonIcon IconOnly Print NormalState" id="z81fb31c58114440294da124cfc896dc6" tabindex="0" title="Print"><span class="Icon"></span><span class="Text"></span></a><a class="Button ButtonIcon IconOnly Refresh NormalState" id="zbbe66a341b0e498cabd5b6a03558909f" tabindex="0" title="Refresh"><span class="Icon"></span><span class="Text"></span></a></div>
            </div>
            <div class="DynamicGridContainer">
                <div class="Grid Small" id="ProjectTaskHistoryGrid">
                    <div class="HeaderContainer">
                        <table cellpadding="0">
                            <colgroup>
                                <col class="Normal DateTime" data-persistence-key="Date" data-unique-css-class="U0">
                                <col class="Normal Text" data-persistence-key="Action" data-unique-css-class="U1">
                                <col class=" Text DynamicSizing" data-persistence-key="Details" data-unique-css-class="U2" style="width: auto;">
                                <col class="Normal Text" data-persistence-key="Person" data-unique-css-class="U3">
                            </colgroup>
                            <tbody>
                                <tr class="HeadingRow">
                                    <td class=" DateTime">
                                        <div class="Standard">
                                            <div class="Heading">操作时间</div>
                                        </div>
                                    </td>
                                    <td class="Normal Text">
                                        <div class="Standard">
                                            <div class="Heading">操作</div>
                                        </div>
                                    </td>
                                    <td class=" Text Dynamic">
                                        <div class="Standard">
                                            <div class="Heading">详情</div>
                                        </div>
                                    </td>
                                    <td class="Normal Text">
                                        <div class="Standard">
                                            <div class="Heading">联系人</div>
                                        </div>
                                    </td>
                                    <td class="ScrollBarSpacer" style="width: 17px;"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="ScrollingContentContainer">
                        <div class="NoDataMessage">No items to display</div>
                        <div class="RowContainer BodyContainer">
                            <table cellpadding="0">
                                <colgroup>
                                    <col class="Normal DateTime">
                                    <col class="Normal Text">
                                    <col class=" Text DynamicSizing" style="width: auto;">
                                    <col class="Normal Text">
                                </colgroup>
                                <tbody>
                                    <%if (logList != null && logList.Count > 0)
                                        {
                                            logList = logList.OrderByDescending(_ => _.oper_time).ToList();
                                            var resList = new EMT.DoneNOW.DAL.sys_resource_dal().GetDictionary();
                                            foreach (var thisLog in logList)
                                            { %>
                                            <tr class="D" >
                                        <td class="DateTime  U0"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisLog.oper_time).ToString("yyyy-MM-dd HH:mm:ss") %></td>
                                        <td class="Text Normal U1">Status Changed</td>
                                        <td class="Text  U2">Status changed from Waiting Approval to Change Order</td>
                                        <td class="Text Normal U3">
                                            <%if (resList != null && resList.Count > 0)
                                                {
                                                    var thisRes = resList.FirstOrDefault(_ => _.val == thisLog.user_id.ToString()); %>
                                           <%=thisRes==null?"":thisRes.show %>
                                            <%} %>
                                            </td>
                                    </tr>
                                    <%}} %>
                            
                                  
                                </tbody>
                            </table>
                            <div class="ContextOverlayContainer" id="ProjectTaskHistoryGrid_ContextOverlay">
                                <div class="ContextOverlay">
                                    <div class="Outline Arrow"></div>
                                    <div class="Arrow"></div>
                                    <div class="Active LoadingIndicator"></div>
                                    <div class="Content"></div>
                                </div>
                                <div class="ContextOverlay">
                                    <div class="Outline Arrow"></div>
                                    <div class="Arrow"></div>
                                    <div class="Active LoadingIndicator"></div>
                                    <div class="Content"></div>
                                </div>
                            </div>
                            <div class="DragIndicator">
                                <div class="Bar"></div>
                                <div class="LeftArrow"></div>
                                <div class="RightArrow"></div>
                            </div>
                            <div class="DragStatus"></div>
                        </div>
                    </div>
                    <div class="FooterContainer"></div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
