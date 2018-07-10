<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DispatcherWorkshopView.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.DispatcherWorkshopView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/Dispatch.css" rel="stylesheet" />
    <title></title>
    <style>
        .HiddenToolTip {
            display: none;
        }
        /*黑色幕布*/
        #BackgroundOverLay {
            width: 100%;
            height: 100%;
            background: black;
            opacity: 0.6;
            z-index: 9999;
            position: absolute;
            top: 0;
            left: 0;
            display: none;
        }
        /*弹框*/
        .Dialog.Large {
            width: 876px;
            height: 450px;
            left: 50%;
            position: fixed;
            top: 50%;
            background-color: white;
            border: solid 4px #b9b9b9;
            display: none;
        }

        .Dialog > div {
        }

        .CancelDialogButton {
            background-image: url(../Images/cancel1.png);
            background-position: 0 -32px;
            border-radius: 50%;
            cursor: pointer;
            height: 32px;
            position: absolute;
            right: -14px;
            top: -14px;
            width: 32px;
            z-index: 1;
        }

        span.FieldLabel {
            font-weight: bold;
            padding-left: 10px;
        }

        #Nav2 .FieldLabel {
            padding-left: 0px;
        }

        #Nav3 .FieldLabel {
            padding-left: 0px;
        }
      
        #Nav4 .FieldLabel {
            padding-left: 0px;
        }

        .ButtonCollectionBase {
            padding-left: 0px;
        }

        .SingUserDiv {
            min-width: 628px;
            float: left;
        }

        .Grid2_Container .hovertask {
            width:100%;
            min-width: 200px;
            background-color: #FFAEB9;
        }

        .Grid2_Container .hoverCall {
            background-color: #FFFEC4;
        }

        .Grid2_Container .hoverAppoint {
            background-color: #FFE3E7;
        }

        .Grid2_Container .hoverTodo {
            background-color: #D1EBFF;
        }

        .Grid2_Container .R-ContainerUser {
            float: left;
            width: 500px;
        }

        .Grid2_Container .R-ContainerUse li {
            width: auto;
        }
         .BookmarkButton {
            cursor: pointer;
            display: inline-block;
            height: 16px;
            position: relative;
            width: 16px;
            float: right;
            margin-top: 8px;
        }

            .BookmarkButton.Selected div {
                border-color: #f9d959;
            }

            .BookmarkButton > .LowerLeftPart {
                border-right-width: 8px;
                border-bottom-width: 6px;
                border-left-width: 8px;
                top: 5px;
                -moz-transform: rotate(35deg);
                -webkit-transform: rotate(35deg);
                -ms-transform: rotate(35deg);
                transform: rotate(35deg);
            }

            .BookmarkButton > .LowerRightPart {
                border-right-width: 8px;
                border-bottom-width: 6px;
                border-left-width: 8px;
                top: 5px;
                -moz-transform: rotate(-35deg);
                -webkit-transform: rotate(-35deg);
                -ms-transform: rotate(-35deg);
                transform: rotate(-35deg);
            }

            .BookmarkButton > div.LowerLeftPart, .BookmarkButton > div.LowerRightPart, .BookmarkButton > div.UpperPart {
                border-left-color: transparent;
                border-right-color: transparent;
                border-style: solid;
                border-top: none;
                height: 0;
                position: absolute;
                width: 0;
            }

            .BookmarkButton > .UpperPart {
                border-bottom-width: 6px;
                border-left-width: 3px;
                border-right-width: 3px;
                left: 5px;
                top: 1px;
            }
    </style>
</head>
<body scroll="NO" style="margin: 0px; padding: 0px; height: 100%; width: 100%; overflow: hidden;">
    <div class="heard-title">
        <span class='TitleContainer'>调度工作室
            <a class='SecondaryTitle'>
                <%=weekArr[(int)DateTime.Now.DayOfWeek] %>- <%=DateTime.Now.ToString("yyyy-MM-dd") %>
            </a>
        </span>
         <div id="bookmark" class="BookmarkButton <%if (thisBookMark != null)
                { %>Selected<%} %> "
                onclick="ChangeBookMark()">
                <div class="LowerLeftPart"></div>
                <div class="LowerRightPart"></div>
                <div class="UpperPart"></div>
            </div>
        <div class="UpperPart"></div>
        
    </div>
    <input type="hidden" id="isSingle" value="<%=isSingResPage?"1":"" %>" />
    <div class="ButtonCollectionBase">
        <div class="Buttonleft" style="margin-left:10px;">
            <div class="newbtn">
                <img src="../Images/new.png" alt="" />
                <span>新增</span>
                <img src="../Images/down.png" alt="" />
                <div class="SelectBox">
                    <div class="SelectBox-Whiteline"></div>
                    <p onclick="AddAppiont()">约会</p>
                    <p onclick="QuickAddCall()">快速新增服务预定</p>
                    <p onclick="AddCall()">服务预定</p>
                    <p onclick="AddTodo()">待办</p>
                </div>
            </div>
            <div class="btntext" style="display:none;">Workload Report</div>
             <%if (resIds == LoginUserId.ToString()&&isSingResPage)
                { %>
            <div class="btntext" style="" onclick="window.open('MyInCompleteItem','MyNoComplete','left=200,top=200,width=410,height=800',false);">查看我的条目</div>
            <%} %>
        </div>
        <div class="ButtonRight">
            <% if (!isSingResPage)
                { %>
            <div class="vivews">
                <span>视图</span>
                <select class="txtBlack8Class" name="" id="SelectView">
                    <option selected="selected" value=""></option>
                    <% if (viewList != null && viewList.Count > 0)
    {
        foreach (var view in viewList)
        {%>
                    <option value="<%=view.id %>" <%if (chooseView != null && chooseView.id == view.id)
    { %>
                        selected="selected" <%} %>><%=view.name %></option>
                    <%
        }
    } %>
                    <option value="">---------------------------</option>
                    <%if (chooseView != null)
    { %>
                    <option value="SaveThis">保存当前视图</option>
                    <%} %>
                    <option value="New">保存为新的视图</option>
                    <option value="Manage">管理已保存的视图</option>
                </select>
            </div>
            <%}
    else
    {%>
           
    <%}%>
            <div class="daysElm">
                <ul>
                    <li <%if (dateType == (int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.ONE_DAY_VIEW)
                        {%>class="ShowdatsElm"
                        <%} %>>1</li>
                    <li <%if (dateType == (int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW)
                        {%>class="ShowdatsElm"
                        <%} %>>5</li>
                    <li <%if (dateType == (int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.FIVE_DAY_WORK_VIEW)
                        {%>class="ShowdatsElm"
                        <%} %>>7</li>
                    <li <%if (dateType == (int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW_FROM_SELECTED_DAY)
                        {%>class="ShowdatsElm"
                        <%} %>>7+</li>
                </ul>
            </div>
            <div class="dateElm">
                <a class="dateElm-pev" onclick="ChangeFilter('<%=chooseDate.AddDays(-1).ToString("yyyy-MM-dd") %>')">< </a>
                <input type="text" id="ShowDate" class="Wdate" onclick="WdatePicker()" value="<%=chooseDate.ToString("yyyy-MM-dd") %>" />
                <a class="dateElm-next" onclick="ChangeFilter('<%=chooseDate.AddDays(1).ToString("yyyy-MM-dd") %>')">> </a>
            </div>
        </div>
    </div>
    <div class="FilterDiv">
        <% if (!isSingResPage)
            { %>
        <div id="pnlWorkgroupSelector">
            <span style="font-weight: bold; padding-right: 4px;">工作组</span>
            <select size="4" name="" id="WorksSelect" class="" style="height: 34px; width: 148px; padding: 0px 0px 0px 3px;">
            </select>
            <input type="hidden" id="workIds" value="" />
            <input type="hidden" id="workIdsHidden" value="<%=workIds %>" />
            <img style="margin-left: 5px; cursor: pointer;" src="../Images/data-selector.png" alt="" onclick="ChooseGroup()" />
        </div>
      
        <div id="pnlResourceSelector">
            <span style="font-weight: bold; padding-right: 4px;">员工</span>
            <select size="4" name="" id="ResSelect" class="" style="height: 34px; width: 148px; padding: 0px 0px 0px 3px;">
            </select>
            <input type="hidden" id="resIds" value="" />
            <input type="hidden" id="resIdsHidden" value="<%=resIds %>" />
            <img style="margin-left: 5px; cursor: pointer;" src="../Images/data-selector.png" alt="" onclick="ChooseRes()" />
        </div>
           <%}else{%>
         <div id="pnlResourceSelector">
            <span style="font-weight: bold; padding-right: 4px;">员工</span>
            <select name="" id="resource_id" class="" style="height: 20px; width: 148px; padding: 0px 0px 0px 3px;">
                <%if (AllResList != null && AllResList.Count > 0)
                    {foreach (var thisRes in AllResList)
                        { %>
                <option value="<%=thisRes.id %>" <% if(resList!=null&&resList.Any(_=>_.id==thisRes.id)){ %> selected="selected" <%} %> ><%=thisRes.name %></option>
                <% }
                  } %>
            </select>
        </div>
        <%} %>
        <div id="checkSelector"> <% if (!isSingResPage)
                                     { %>
            <p>
                <input id="ckNoRes" type="checkbox" name="" /><span>显示无负责人的服务预定</span>
            </p>
            <%} %>
            <p>
                <input id="ckShowCancel" type="checkbox" name="" /><span>显示已取消服务预定</span>
            </p>
        </div>
    </div>
    <div style="margin: 0 10px 10px 10px;">
        <div class="Grid1_Container">
            <div class="ContainerLeft">
                <div class="ContainerDays">
                    <div class="Days-1"></div>
                    <div class="Days-2"></div>
                    <div class="Days-3">个人</div>
                </div>
                <!--用户列-->
                <div class="ContainerUserScroll">
                    <div style="width:100%;height:auto;position:relative;">
                    <ul class="ContainerUser">
                        <asp:Literal ID="liUser" runat="server"></asp:Literal>
                    </ul>
                     <asp:Literal ID="liGroup" runat="server"></asp:Literal>
                        </div>
                </div>
               
            </div>
            <div class="ContainerRight">
                <!--时间列-->
                <div class="R-ContainerDays-Total">
                    <ul class="R-ContainerDays">
                        <asp:Literal ID="liTime" runat="server"></asp:Literal>
                    </ul>
                </div>
                <!--任务列-->
                <div class="R-ContainerUser-Total" onscroll="OnScrollHAW(this)">
                    <asp:Literal ID="liTicket" runat="server"></asp:Literal>
                </div>

            </div>
        </div>

        <div class="Grid2_Container" style="display: none;">
            <div class="ContainerTop">
                <div class="ContainerTop-One">
                    <div class="ContainerDays">
                        <div class="Days-1">
                        </div>
                        <%if (!isSingResPage)
                            { %>
                        <div class="Days-2">
                        </div>
                        <div class="Days-3">
                        </div>
                        <%} %>
                        <div class="Days-4"></div>
                    </div>
                </div>
                <div class="ContainerTop-Two">
                    <%--<div class="Days-1">
                        <div class="border"></div>
                        <%=weekArr[(int)chooseDate.DayOfWeek] %>- <%=chooseDate.ToString("yyyy-MM-dd") %>
                    </div>--%>
                     <asp:Literal ID="liSingUserShow" runat="server"></asp:Literal>
                  
                    <div class="ContainerTop-UserLine" style="clear: both;"></div>
                </div>
            </div>
            <div class="ContainerBottom">
                <div class="ContainerBottom-One">
                    <div class="Hover-t"></div>
                    <ul class="Hover">
                        <% for (int i = 0; i < 24; i++)
                            {   %>
                        <li style="height: 60px;">
                            <a><%=i.ToString("#00") %></a>
                            <a><%=i>=12?"PM":"AM" %></a>
                        </li>
                        <%} %>
                    </ul>
                </div>
                <div class="ContainerBottom-Two"  onscroll="OnScrollH(this)">
                    
                    <div class="HouverTaskA">   
                        <asp:Literal ID="liSingUserContent" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <div id="menu">
        <div class="SelectBox" style="position: none; display: block;">
            <p onclick="QuickAddCall()">新增快速服务预定</p>
            <p onclick="AddCall()">新增服务预定</p>
            <p onclick="AddAppiont()">新增约会</p>
            <p onclick="AddTodo()">新增待办</p>
        </div>
    </div>
    <div id="OtherMenu" style="position: absolute; display: none;">
        <div class="SelectBox" style="position: none; display: block;">
            <p class="AppiontMenu otherMenu" onclick="EditAppoint()">编辑约会</p>
            <p class="AppiontMenu otherMenu" onclick="DeleteAppoint()">删除约会</p>

            <p class="TodoMenu otherMenu" onclick="EditTodo()">编辑待办</p>
            <p class="TodoMenu otherMenu" onclick="ShowTodo()">查看待办</p>
            <p class="TodoMenu otherMenu" onclick="ShowContact()">查看联系人</p>
            <p class="TodoMenu otherMenu" onclick="DoneTodo()">完成待办</p>
            <p class="TodoMenu otherMenu" onclick="TodoShowAccount()">查看客户</p>
            <p class="TodoMenu otherMenu" onclick="DeleteTodo()">删除待办</p>

            <p class="CallMenu otherMenu" onclick="EditCall()">编辑服务预定</p>
            <p class="CallMenu otherMenu" onclick="CallShowAccount()">查看客户</p>
            <p class="CallMenu otherMenu" onclick="">生成工作说明书</p>
            <p class="CallMenu otherMenu" onclick="DoneCall()">完成服务预定</p>
            <p class="CallMenu otherMenu" onclick="CopyCall()">再次调度（复制）</p>
            <p class="CallMenu otherMenu" onclick="DeleteCall()">删除服务预定</p>
        </div>
    </div>
    <div class="WzTtDiV"></div>
    <div class="loading">
        <div class="loadimg">
            <img src="../Images/Loading.gif" alt="" />
            <p>加载中...</p>
        </div>
    </div>
    <div id="BackgroundOverLay"></div>
    <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 99999; width: 400px; height: 400px;" id="Nav1">
        <div class="CancelDialogButton" onclick="CanCallRoleDialog()"></div>
        <div class="heard-title" style="height: 30px;">选择员工角色</div>
        <div id="" class="ButtonCollectionBase" style="height: 27px; margin-top: 5px;">
            <span id="" class="ButtonBase" style="cursor: pointer;">
                <div class="ButtonCollectionBase">
                    <div class="Buttonleft">
                        <div class="btntext" onclick="ToChangeCall()">继续</div>
                    </div>
                </div>
            </span>
        </div>
        <table cellpadding="0" cellspacing="0" border="0" style="width: 100%; background-color: white; padding-left: 14px;">
            <tbody>
                <tr>
                    <td colspan="2">
                        <div style="overflow: hidden; padding-bottom: 20px; margin-top: -4px">
                            <span class="FieldLabel">客户</span><br>
                            <span id="CallRoleAccountName" style="font-weight: normal;" class="FieldLabel">abcdefg</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="overflow: hidden; padding-bottom: 20px;">
                            <span class="FieldLabel">工单标题</span><br>
                            <span id="CallRoleTicketTitle" style="font-weight: normal;" class="FieldLabel">abcdefg</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="PageLevelInstruction" style="padding-left: 10px; padding-right: 10px;">
                        <span>必须为该员工选择一个角色</span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-left: 10px; padding-top: 3px;">
                        <select id="ResRoleList" name="ResRoleList" class="txtBlack8Class" style="width: 200px;">
                        </select>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 99999; width: 400px; height: 400px;" id="Nav2">
        <div class="CancelDialogButton" onclick="CanCallRoleDialog()"></div>
        <div class="heard-title" style="height: 30px;">调度服务预定</div>
        <div id="" class="ButtonCollectionBase" style="height: 27px; margin-top: 5px;">
            <span id="" class="ButtonBase" style="cursor: pointer;">
                <div class="ButtonCollectionBase">
                    <div class="Buttonleft">
                        <div class="btntext" onclick="SaveChangeCall()">保存并关闭</div>
                    </div>
                </div>
            </span>
        </div>
        <input type="hidden" id="ChooseRoleId" value="" />
        <table cellpadding="0" cellspacing="0" border="0" style="width: 100%; background-color: white; padding-left: 14px;">
            <tbody>
                <tr>
                    <td colspan="2">
                        <div style="overflow: hidden; padding-bottom: 20px; margin-top: -4px">
                            <span class="FieldLabel" style="padding-left: 10px;">客户</span><br>
                            <span id="accountName" style="font-weight: normal; padding-left: 10px;" class="FieldLabel"></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="overflow: hidden; padding-bottom: 20px;">
                            <span class="FieldLabel" style="padding-left: 10px;">描述</span><br>
                            <span id="callDescption" style="font-weight: normal; padding-left: 10px;" class="FieldLabel"></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="PageLevelInstruction" style="padding-left: 10px; padding-right: 10px;">
                        <span class="FieldLabel">开始时间</span><br />
                        <span>
                            <input type="text" id="CallStartTime" onclick="WdatePicker({ dateFmt: 'HH:mm' })" style="width: 100px;" /></span>&nbsp;&nbsp;&nbsp;<span id="CallStartDate"></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-left: 10px; padding-top: 3px;">
                        <span class="FieldLabel">持续时间</span><br />
                        <span>
                            <input type="text" id="CallDurationTime" style="width: 100px;" class="ToDecimal2" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" /></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-left: 10px; padding-top: 3px;">
                        <span class="FieldLabel">结束时间</span><br />
                        <span id="CallEndTimeSpan" style="width: 100px;"></span>&nbsp;&nbsp;&nbsp;<span id="CallEndDate"></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-left: 10px; padding-top: 3px;">
                        <span class="FieldLabel">通知</span><br />
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 99999; width: 400px; height: 400px;" id="Nav3">
        <div class="CancelDialogButton" onclick="CanCallRoleDialog()"></div>
        <div class="heard-title" style="height: 30px;">调度约会</div>
        <div id="" class="ButtonCollectionBase" style="height: 27px; margin-top: 5px;">
            <span id="" class="ButtonBase" style="cursor: pointer;">
                <div class="ButtonCollectionBase">
                    <div class="Buttonleft">
                        <div class="btntext" onclick="SaveChangeAppiont()">保存并关闭</div>
                    </div>
                </div>
            </span>
        </div>
        <table cellpadding="0" cellspacing="0" border="0" style="width: 100%; background-color: white; padding-left: 14px;">
            <tbody>
                <tr>
                    <td colspan="2">
                        <div style="overflow: hidden; padding-bottom: 20px; margin-top: -4px">
                            <span class="FieldLabel" style="padding-left: 10px;">标题</span><br>
                            <span id="AppiontTitle" style="font-weight: normal; padding-left: 10px;" class="FieldLabel"></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="overflow: hidden; padding-bottom: 20px;">
                            <span class="FieldLabel" style="padding-left: 10px;">描述</span><br>
                            <span id="AppiontDescption" style="font-weight: normal; padding-left: 10px;" class="FieldLabel"></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="PageLevelInstruction" style="padding-left: 10px; padding-right: 10px;">
                        <span class="FieldLabel">开始时间</span><br />
                        <span>
                            <input type="text" id="AppiontStartTime" onclick="WdatePicker({ dateFmt: 'HH:mm' })" style="width: 100px;" /></span>&nbsp;&nbsp;&nbsp;<span id="AppiontStartDate"></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-left: 10px; padding-top: 3px;">
                        <span class="FieldLabel">持续时间</span><br />
                        <span>
                            <input type="text" id="AppiontDurationTime" class="ToDecimal2" style="width: 100px;" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" /></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-left: 10px; padding-top: 3px;">
                        <span class="FieldLabel">结束时间</span><br />
                        <span id="AppiontEndTimeSpan" style="width: 100px;"></span>&nbsp;&nbsp;&nbsp;<span id="AppiontEndDate"></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-left: 10px; padding-top: 3px;">
                        <span class="FieldLabel">通知</span><br />
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 99999; width: 400px; height: 400px;" id="Nav4">
        <div class="CancelDialogButton" onclick="CanCallRoleDialog()"></div>
        <div class="heard-title" style="height: 30px;">调度待办</div>
        <div id="" class="ButtonCollectionBase" style="height: 27px; margin-top: 5px;">
            <span id="" class="ButtonBase" style="cursor: pointer;">
                <div class="ButtonCollectionBase">
                    <div class="Buttonleft">
                        <div class="btntext" onclick="SaveChangeTodo()">保存并关闭</div>
                    </div>
                </div>
            </span>
        </div>
        <table cellpadding="0" cellspacing="0" border="0" style="width: 100%; background-color: white; padding-left: 14px;">
            <tbody>
                <tr>
                    <td colspan="2">
                        <div style="overflow: hidden; padding-bottom: 20px; margin-top: -4px">
                            <span class="FieldLabel" style="padding-left: 10px;">客户</span><br>
                            <span id="TodoAccount" style="font-weight: normal; padding-left: 10px;" class="FieldLabel"></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="overflow: hidden; padding-bottom: 20px;">
                            <span class="FieldLabel" style="padding-left: 10px;">类型</span><br>
                            <span id="TodoActicity" style="font-weight: normal; padding-left: 10px;" class="FieldLabel"></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="PageLevelInstruction" style="padding-left: 10px; padding-right: 10px;">
                        <span class="FieldLabel">开始时间</span><br />
                        <span>
                            <input type="text" id="TodoStartTime" onclick="WdatePicker({ dateFmt: 'HH:mm' })" style="width: 100px;" /></span>&nbsp;&nbsp;&nbsp;<span id="TodoStartDate"></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-left: 10px; padding-top: 3px;">
                        <span class="FieldLabel">持续时间</span><br />
                        <span>
                            <input type="text" id="TodoDurationTime" class="ToDecimal2" style="width: 100px;" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" /></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-left: 10px; padding-top: 3px;">
                        <span class="FieldLabel">结束时间</span><br />
                        <span id="TodoEndTimeSpan" style="width: 100px;"></span>&nbsp;&nbsp;&nbsp;<span id="TodoEndDate"></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-left: 10px; padding-top: 3px;">
                        <span class="FieldLabel">通知</span><br />
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/Dispatch.js"></script>
<script>
    $(function () {
        GetRes();
        GetGroup();
        <%if (isShowNoRes)
    { %>
        $("#ckNoRes").prop("checked", true);
        <%} %>
         <%if (isShowCanCall)
    { %>
        $("#ckShowCancel").prop("checked", true);
        <%} %>

        <%if (dateType == (int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.ONE_DAY_VIEW||isSingResPage)
    { %>
        $(".Grid1_Container").hide();
        $(".Grid2_Container").show();
        $("body").trigger("resize");
        $('.UserContainer').bind("contextmenu", ShowContextMenu);
        $('.UserContainer').children(".hovertask").bind("contextmenu", ShowContextAppMenu);

        <%}
    else
    { %>
        $(".Grid1_Container").show();
        $(".Grid2_Container").hide();


        <%} %>

        <%if (isSingResPage)
    { %>
        console.log($(".HouverTaskA").eq(0).width());
        $(".ContainerTop-User").hide();
        $(".DaysList").eq(1).hide();
        $(".DaysList").eq(0).css('width', $(".HouverTaskA").eq(0).width());
        // $('.ContainerTop-Two').children().css('width', $(".HouverTaskA").width())
        $.each($('.DaysList .Days-1'), function (i) {
            var ob = $('.HouverTask').eq(i).children('li').eq(1).find('.HouverTaskItem');
            var x = $('.HouverTask').length;
            if (ob.length > 1) {
                x += ob.length;
                localStorage.setItem('xE', x)
                $('.HouverTask').eq(i).css('width', 100 / x * ob.length + '%')
                $('.DaysList .Days-1').eq(i).css('width', 100 / x * ob.length + '%')
                ob.css('width', 98 / ob.length + '%')
                //console.log($('.ContainerBottom-Two').width() / x)

            } else {
                var xE = localStorage.getItem('xE');
                $('.HouverTask').eq(i).css('width', 100 / xE + '%')
                $('.DaysList .Days-1').eq(i).css('width', 100 / xE + '%')
            }
        })
        <%} %>
    })





</script>
<script>
    $(function () {
     

    })
    var oldDatevalue = '<%=chooseDate.ToString("yyyy-MM-dd") %>';
    $("#ShowDate").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != oldDatevalue) {
            oldDatevalue = thisValue;
            ChangeFilter("");
        }
    })
    function ChooseGroup() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.WORKGROUP_CALLBACK %>&field=workIds&muilt=1&callBack=ChangeGroupData", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function ChangeGroupData() {
        GetGroup();
        ChangeFilter("");
    }
    function GetGroup() {
        var workIds = $("#workIdsHidden").val();
        var workHtml = "";
        if (workIds != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ResourceAjax.ashx?act=GetWorkList&ids=" + workIds,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            workHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                },
            });
        }
        $("#WorksSelect").html(workHtml);
        $("#WorksSelect option").dblclick(function () {
            RemoveGroup(this);
        })
    }
    function RemoveGroup(val) {
        $(val).remove();
        var ids = "";
        $("#WorksSelect option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#workIdsHidden").val(ids);
        ChangeFilter("");
    }

    function ChooseRes() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_CALLBACK %>&field=resIds&muilt=1&callBack=ChangeResData", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function ChangeResData() {
        GetRes();
        ChangeFilter("");
    }
    function GetRes() {
        var resIds = $("#resIdsHidden").val();
        var resHtml = "";
        if (resIds != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ResourceAjax.ashx?act=GetResList&ids=" + resIds,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            resHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                },
            });
        }
        $("#ResSelect").html(resHtml);
        $("#ResSelect option").dblclick(function () {
            RemoveResDep(this);
        })
    }
    function RemoveResDep(val) {
        $(val).remove();
        var ids = "";
        $("#ResSelect option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#resIdsHidden").val(ids);
        ChangeFilter("");
    }
    $("#ckNoRes").click(function () {
        ChangeFilter("");
    })
    $("#ckShowCancel").click(function () {
        ChangeFilter("");
    })
    $(".ToDecimal2").blur(function () {
        var thisValue = $(this).val();
        thisValue = toDecimal2(thisValue);
        $(this).val(thisValue);
    })

    function ChangeFilter(chooseDate) {
        $('.loading').show();
        var workIds = $("#workIdsHidden").val();
        var resIds = $("#resIdsHidden").val();
        var isNoRes = "";
        if ($("#ckNoRes").is(":checked")) {
            isNoRes = "1";
        } else {
            isNoRes = "0";
        }
        var ckShowCancel = "";
        if ($("#ckShowCancel").is(":checked")) {
            ckShowCancel = "1";
        } else {
            ckShowCancel = "0";
        }
        var modeId = $(".ShowdatsElm").eq(0).text();
        if (modeId == "1") {
            modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.ONE_DAY_VIEW %>';
        }
        else if (modeId == "5") {
            modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW %>';
        }
        else if (modeId == "7") {
            modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.FIVE_DAY_WORK_VIEW %>';
        }
        else if (modeId == "7+") {
            modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW_FROM_SELECTED_DAY %>';
        }
        if (modeId == "") {
            return;
        }
        var SelectView = $("#SelectView").val();
        var ShowDate = $("#ShowDate").val();
        if (chooseDate != "" && chooseDate != null && chooseDate != undefined) {
            ShowDate = chooseDate;
        }
        <%if (isSingResPage)
    { %>
        var resource_id = $("#resource_id").val();
        location.href = "../ServiceDesk/DispatcherWorkshopView?resIds=" + resource_id + "&showCanCall=" + ckShowCancel + "&modeId=" + modeId + "&chooseDate=" + ShowDate +"&isSingResPage=1";
        <%}
    else
    { %>
        location.href = "../ServiceDesk/DispatcherWorkshopView?viewId=" + SelectView + "&resIds=" + resIds + "&workIds=" + workIds + "&showNoRes=" + isNoRes + "&showCanCall=" + ckShowCancel + "&modeId=" + modeId + "&chooseDate=" + ShowDate;
        <%} %>
    }
    $("#resource_id").change(function () {
        ChangeFilter('');
    })

    $("#SelectView").change(function () {
        var thisValue = $(this).val();
        if (thisValue == "New") {
            var workIds = $("#workIdsHidden").val();
            var resIds = $("#resIdsHidden").val();
            var isNoRes = "";
            if ($("#ckNoRes").is(":checked")) {
                isNoRes = "1";
            }
            var ckShowCancel = "";
            if ($("#ckShowCancel").is(":checked")) {
                ckShowCancel = "1";
            }
            var modeId = $(".ShowdatsElm").eq(0).text();
            if (modeId == "1") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.ONE_DAY_VIEW %>';
            }
            else if (modeId == "5") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW %>';
            }
            else if (modeId == "7") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.FIVE_DAY_WORK_VIEW %>';
            }
            else if (modeId == "7+") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW_FROM_SELECTED_DAY %>';
            }
            if (modeId == "") {
                return;
            }
            window.open("../ServiceDesk/DispatchViewList.aspx?isAdd=1&workIds=" + workIds + "&resIds=" + resIds + "&isShowNoRes=" + isNoRes + "&isShowCalls=" + ckShowCancel + "&modeId=" + modeId, '_blank', 'left=200,top=200,width=600,height=800', false);
        }
        else if (thisValue == "Manage") {
            window.open("../ServiceDesk/DispatchViewList.aspx", '_blank', 'left=200,top=200,width=600,height=800', false);
        }
        else if (thisValue == "SaveThis") {
            $('.loading').show();
            var thisViewId = '<%=chooseView==null?"":chooseView.id.ToString() %>';
            if (thisViewId == "") {
                return;
            }
            var workIds = $("#workIdsHidden").val();
            var resIds = $("#resIdsHidden").val();
            var isNoRes = "";
            if ($("#ckNoRes").is(":checked")) {
                isNoRes = "1";
            }
            var ckShowCancel = "";
            if ($("#ckShowCancel").is(":checked")) {
                ckShowCancel = "1";
            }
            var modeId = $(".ShowdatsElm").eq(0).text();
            if (modeId == "1") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.ONE_DAY_VIEW %>';
            }
            else if (modeId == "5") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW %>';
            }
            else if (modeId == "7") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.FIVE_DAY_WORK_VIEW %>';
            }
            else if (modeId == "7+") {
                modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW_FROM_SELECTED_DAY %>';
            }
            if (modeId == "") {
                return;
            }
            var showDate = $("#ShowDate").val();
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/DispatchAjax.ashx?act=EditSearchViewDispatch&id=" + thisViewId + "&modeId=" + modeId + "&resIds=" + resIds + "&workIds=" + workIds + "&ckNoRes=" + isNoRes + "&ckShowCancel=" + ckShowCancel,
                dataType: "json",
                success: function (data) {
                    if (data) {
                        LayerMsg("保存成功");
                    } else {
                        LayerMsg("保存失败");
                    }
                    setTimeout(function () { location.href = "../ServiceDesk/DispatcherWorkshopView.aspx?viewId=" + thisViewId + "&chooseDate=" + showDate; }, 800);
                },
            });
        }
        else if (thisValue != "") {
            $('.loading').show();
            location.href = "../ServiceDesk/DispatcherWorkshopView.aspx?viewId=" + thisValue;
        }
        else {

        }
    })
    function ChangeBookMark() {
        var url = '/ServiceDesk/DispatchCalendar';
         var title = '调度工作室';
        var isBook = $("#bookmark").hasClass("Selected");
        $.ajax({
            type: "GET",
            url: "../Tools/IndexAjax.ashx?act=BookMarkManage&url=" + url + "&title=" + title,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    if (isBook) {
                        $("#bookmark").removeClass("Selected");
                    } else {
                        $("#bookmark").addClass("Selected");
                    }
                }
            }
        })
     }
</script>
