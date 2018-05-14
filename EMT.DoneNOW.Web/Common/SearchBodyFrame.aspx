<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchBodyFrame.aspx.cs" Inherits="EMT.DoneNOW.Web.SearchBodyFrame" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link rel="stylesheet" type="text/css" href="../Content/searchList.css" />
     <link href="../Content/ClassificationIcons.css" rel="stylesheet" />
    <title></title>
    <style>
        .searchcontent {
            width: 100%;
            height: 100%;
            min-width: 2200px;
        }

            .searchcontent table th {
                background-color: #cbd9e4;
                border-color: #98b4ca;
                color: #64727a;
                height: 28px;
                line-height: 28px;
                text-align: center;
            }

        .RightClickMenu, .LeftClickMenu {
            padding: 16px;
            background-color: #FFF;
            border: solid 1px #CCC;
            cursor: pointer;
            z-index: 999;
            position: absolute;
            box-shadow: 1px 1px 4px rgba(0,0,0,0.33);
        }

        .RightClickMenuItem {
            min-height: 24px;
            min-width: 100px;
        }

        .RightClickMenuItemIcon {
            padding: 1px 5px 1px 5px;
            width: 16px;
        }

        .RightClickMenuItemTable tr:first-child td:last-child {
            white-space: nowrap;
        }

        .RightClickMenuItemLiveLinks > span, .RightClickMenuItemText > span {
            font-size: 12px;
            font-weight: normal;
            color: #4F4F4F;
        }
        .DropDownMenu>ul>li{
            min-height: 24px;
            float: none;
            margin: 6px;
            background: linear-gradient(to bottom,#fff 0,#fff 100%);
            border: 0px solid #bcbcbc;
        }
          /*加载的css样式*/
#BackgroundOverLay{
    width:100%;
    height:100%;
    background: black;
    opacity: 0.6;
    z-index: 25;
    position: absolute;
    top: 0;
    left: 0;
    display: none;
}
#LoadingIndicator {
    width: 100px;
    height:100px;
    background-image: url(../Images/Loading.gif);
    background-repeat: no-repeat;
    background-position: center center;
    z-index: 30;
    margin:auto;
    position: absolute;
    top:0;
    left:0;
    bottom:0;
    right: 0;
    display: none;
}/*加载的css样式(结尾)*/
    </style>
</head>
<body style="overflow-x: auto; overflow-y: auto;">
  <%="" %>
    <%if (isShowTitle) { %>
    <div class="TitleBar">
        <div class="Title" style="left:0;">
            <div class="TitleBarNavigationButton">
                <a class="Button ButtonIcon NormalState" id="goBack"><img src="../Images/move-left.png" /></a>
            </div>
            <span class="text1" id="opname"><%=title %></span>
        </div>
    </div>
    <%} %>
    <form id="form1">
        <div id="search_list">
            <input type="hidden" id="page_num" name="page_num" <%if (queryResult != null)
                {%>value="<%=queryResult.page %>"
                <%} %> />
            <input type="hidden" id="page_size" name="page_size" <%if (queryResult != null)
                {%>value="<%=queryResult.page_size %>"
                <%} %> />
            <input type="hidden" id="search_id" name="search_id" <%if (queryResult != null)
                {%>value="<%=queryResult.query_id %>"
                <%} %> />
            <input type="hidden" id="order" name="order" <%if (queryResult != null)
                {%>value="<%=queryResult.order_by %>"
                <%} %> />
            <input type="hidden" id="cat" name="cat" value="<%=catId %>" />
            <input type="hidden" id="type" name="type" value="<%=queryTypeId %>" />
            <input type="hidden" id="group" name="group" value="<%=paraGroupId %>" />
            <input type="hidden" id="id" name="id" value="<%=objId %>" />
            <input type="hidden" id="param1" value="<%=param1 %>" />
            <input type="hidden" id="param2" value="<%=param2 %>" />
            <input type="hidden" id="isCheck" name="isCheck" value="<%=isCheck %>" />
            <input type="hidden" id="loginUserId" name="isCheck" value="<%=LoginUserId %>" />
            <div id="conditions">
                <%foreach (var para in queryParaValue)
                    { %>
                <input type="hidden" name="<%=para.val %>" value="<%=para.show %>" />
                <%} %>
            </div>
        </div>
        <div class="contentboby">
            <div class="RightClickMenu" style="left: 10px; top: 36px; display: none;">
              <%if (CheckAuth("CTT_CONTRACT_ADD_SERVICE")) { %>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1199)">
                                    <span class="lblNormalClass">定期服务合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
              <%} %>
              <%if (CheckAuth("CTT_CONTRACT_ADD_TIME_MATERIALS")) { %>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1200)">
                                    <span class="lblNormalClass">工时及物料合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
              <%} %>
              <%if (CheckAuth("CTT_CONTRACT_ADD_FIXED_PRICE")) { %>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1201)">
                                    <span class="lblNormalClass">固定价格合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
              <%} %>
              <%if (CheckAuth("CTT_CONTRACT_ADD_BLOCK_HOURS")) { %>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1202)">
                                    <span class="lblNormalClass">预付时间合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
              <%} %>
              <%if (CheckAuth("CTT_CONTRACT_ADD_RETAINER")) { %>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1203)">
                                    <span class="lblNormalClass">预付费合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
              <%} %>
              <%if (CheckAuth("CTT_CONTRACT_ADD_PER_TICKET")) { %>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1204)">
                                    <span class="lblNormalClass">事件合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
              <%} %>
            </div>
            <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_MONTH_PROFIT_MARGIN || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_MONTH_PROFIT_MARGIN_BYDATE || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_CONTRACT_PROFIT || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_CONTRACT_PROFIT_BYDATE || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_CONTRACT_PROFIT_MARGIN || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_PROJECT_PROFIT || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_PROJECT_PROFIT_BYDATE || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_PROJECT_PROFIT_MARGIN || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_RES_WORKHOUR || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_RES_WORKHOUR_BYDATE || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_ACCOUNT_OVERVIEW || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_ACCOUNT_OVERVIEW_BYDATE)
                                                                                                       { %>    
            <p style="margin-top:10px;"><span id="FilterSpan">过滤方式</span><span id="FilterSelect"><select id="FilterPosted"><option value="ItemDate">条目日期</option><option value="BillDate">计费日期</option></select></span> <span style="margin-left:10px;" id="BillSpanName">是否计费</span><span id="BillSelectSpan"><select id="IsBilled"><option value=""></option><option value="1">计费</option><option value="0">不计费</option></select></span><%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_PROJECT_PROFIT || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_PROJECT_PROFIT_BYDATE || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_PROJECT_PROFIT_MARGIN) { var projectStatusList = new EMT.DoneNOW.DAL.d_general_dal().GetGeneralByTableId((int)EMT.DoneNOW.DTO.GeneralTableEnum.PROJECT_STATUS);%>
                <span style="margin-left:10px;">项目状态</span><span><select id="ProjectStatus"><option value=""></option><%if (projectStatusList != null && projectStatusList.Count > 0){ foreach (var projectStatus in projectStatusList) {%>  <option value="<%=projectStatus.id %>"><%=projectStatus.name %></option> <%} } %> </select></span>
                <%} %><span id="Apply" style="padding: 3px;border: 1px solid #bcbcbc;margin-left: 10px;background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);">应用</span></p>
            <%} else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE&&Request.QueryString["param1"]=="ShowPara"){ %>
            <p><span>到期时间</span><span><select id="DueTime"><option value=""></option><option value="0">今天</option><option value="7">7天内</option><option value="30" >30天内</option><option value="60">60天内</option><option value="-1">已过期</option></select></span><span style="display: inline-block;margin-left: 10px;"><input type="checkbox" id="CkIncludeMaster"/></span><span>包含定期服务工单</span></p>
            <%} %>
            <div class="contenttitle clear" style="border-bottom: 1px solid #e8e8fa; left: 0; top: 0; background: #fff; width: 100%;min-width:900px;">
                <ul class="clear fl">
                    <%if (!string.IsNullOrEmpty(addBtn))
    {
        if (addBtn.Equals("新增合同") && CheckAuth("CTT_CONTRACT_ADD"))
        {
                    %>
                    <li id="ToolsButton"><i style="background-image: url(../Images/new.png);"></i><span style="margin: 0;"><%=this.addBtn %></span><img src="../Images/dropdown.png" /></li>
                    <%
    }
    else if (addBtn == "审批并提交")
    {
  %>
                    <li onclick="Add()"><span style="margin: 0 10px;">审批并提交</span></li>
                     <li><a href="../Invoice/InvocieSearch" target="PageFrame" style="color:#333;text-decoration:none;"><span style="margin: 0 10px;">生成发票</span></a></li>
                               <%
    }
    else if (addBtn == "历史发票")
    {
  %>
                    <li onclick="Add()"><span style="margin: 0 10px;">邮件发票</span></li>
                     <li><a href="../Invoice/InvocieSearch" target="PageFrame" style="color:#333;text-decoration:none;"><span style="margin: 0 10px;">发票查询</span></a></li>
                    <%
    }
    else if (addBtn == "完成")
    {
                 %>
                    <li onclick="Add()"><span style="margin: 0 10px;">完成</span></li>
                    <%
    }
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_TEAM)
    {%>
                    <%if (CheckAuth("PRO_PROJECT_VIEW_TEAM_ADD"))
    { %>
                    <li onclick="Add()"><span style="margin: 0 10px;">新建</span></li><%} %>
                    <%if (CheckAuth("PRO_PROJECT_VIEW_TEAM_EMAIL_TEAM"))
    { %>
                    <li onclick="EmailProjetcTeam()"><span style="margin: 0 10px;">通知项目团队</span></li><%} %>
                    <li onclick=""><span style="margin: 0 10px;">工作量报表</span></li>
                    <li onclick=""><span style="margin: 0 10px;">查找员工</span></li>
                       <%if (CheckAuth("PRO_PROJECT_VIEW_TEAM_RECONLINE"))
    { %>
                    <li onclick="ReconcileProject()"><span style="margin: 0 10px;">查核内部团队</span></li><%} %>
                        <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_COST_EXPENSE)
    {%>
                       <li onclick="AddCost()"><span style="margin: 0 10px;">新增成本</span></li>
                       <li onclick="AddExpense()"><span style="margin: 0 10px;">新增费用</span></li>
                            <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_UDF)
    {%>
            <li class="Button ButtonIcon NormalState f1" id="options" tabindex="0">
                <span class="Icon" style="width: 0; margin: 0;"></span>
                <span class="Text">选项</span>
                <img src="../Images/dropdown.png" alt="" class="ButtonRightImg1" />
            </li>
         <li class="Button ButtonIcon NormalState f1" id="tools" tabindex="0">
                <span class="Icon" style="width: 0; margin: 0;"></span>
                <span class="Text">工具</span>
                <img src="../Images/dropdown.png" alt="" class="ButtonRightImg1" />
            </li>
                                <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_SEARCH)
    {%>
                    <li onclick="AddProject('<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.ACCOUNT_PROJECT %>','')"><span style="margin: 0 10px;">添加项目</span></li>
                    <li onclick="AddProject('<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.ACCOUNT_PROJECT %>','1')"><span style="margin: 0 10px;">从模板添加项目</span></li>
                    <li onclick="AddProject('<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.PROJECT_DAY %>','')"><span style="margin: 0 10px;">添加项目提案</span></li>
                    <%} 
                        else
                        { %>
                    <li onclick="Add()"><i style="background-image: url(../Images/new.png);"></i><span><%=this.addBtn %></span></li>
                    <%}
                        } else if(queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractService) {%>
                  <%if (CheckAuth("SEARCH_CONTRACTSERVICE_ADDSERVICE")) { %>
                  <li onclick="AddService()"><i style="background-image: url(../Images/new.png);"></i><span>新增服务</span></li>
                  <%} %>
                  <%if (CheckAuth("SEARCH_CONTRACTSERVICE_ADDSERVICEBUNDLE")) { %>
                  <li onclick="AddServiceBundle()"><i style="background-image: url(../Images/new.png);"></i><span>新增服务包</span></li>
                  <%} %>
                  <%if (CheckAuth("SEARCH_CONTRACTSERVICE_APPLYDISCOUNT")) { %>
                  <li onclick="ApplyDiscount()"><span>应用全部折扣</span></li>
                  <%} %>
                  <%}%>
                  <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_APPROVAL)
                      { %>
                    <li onclick="Approval()"><span style="margin: 0 10px;">通过</span></li>
                    <li onclick="ApprovalReject()"><span style="margin: 0 10px;">拒绝</span></li>
                  <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MYAPPROVE_EXPENSE_REPORT)
    { %>
                    <li  id="appSel"><span style="margin: 0 10px;">审批选中</span></li>
                     <li  id="rejSel"><span style="margin: 0 10px;">拒绝选中</span></li>
                    <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_SEARCH)
    {%>
                <li class="Button ButtonIcon NormalState f1" id="options" tabindex="0">
                <span class="Icon" style="width: 0; margin: 0;"></span>
                <span class="Text">新增</span>
                <img src="../Images/dropdown.png" alt="" class="ButtonRightImg1" />
            </li>
            <li class="Button ButtonIcon NormalState f1" id="export" tabindex="0">
                <span class="Icon" style="width: 0; margin: 0;"></span>
                <span class="Text">导出</span>
                <img src="../Images/dropdown.png" alt="" class="ButtonRightImg1" />
            </li>
                        <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_ACCOUNT_LIST)
    { %>
                    <li class="Button ButtonIcon NormalState f1" id="options" tabindex="0">
                <span class="Icon" style="width: 0; margin: 0;"></span>
                <span class="Text">新增</span>
                <img src="../Images/dropdown.png" alt="" class="ButtonRightImg1" />
            </li>
                    <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_SERVICE_LIST)
    { %>
                    <li onclick="AddServiceCall()">
                        <span class="Icon" style="width: 16px;margin-left: 5px;margin-top: 2px;background: url(../Images/Icons.png) no-repeat -294px -16px;height: 16px;display: -webkit-inline-box;"></span>
                        <span class="Text">新增服务预定</span>
                    </li>
                    <li onclick="AddTodo()">
                        <span class="Icon" style="width: 16px;margin-left: 5px;margin-top: 2px;background: url(../Images/Icons.png) no-repeat -6px -32px;height: 16px;display: -webkit-inline-box;"></span>
                        <span class="Text">新增待办</span>
                    </li>
                    <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_COST_EXPENSE)
    { %>
                    <li onclick="AddCharge()">
                        <span class="Icon" style="width: 16px;margin-left: 5px;margin-top: 2px;background: url(../Images/Icons.png) no-repeat -214px -16px;height: 16px;display: -webkit-inline-box;"></span>
                        <span class="Text">新增成本</span>
                    </li>
                    <li onclick="AddExpense()">   
                        <span class="Icon" style="width: 16px;margin-left: 5px;margin-top: 2px;background: url(../Images/Icons.png) no-repeat -310px -48px;height: 16px;display: -webkit-inline-box;"></span>
                        <span class="Text">新增费用</span>
                    </li>
                    <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE)
    { %>
                    <li onclick="Add()"><i style="background-image: url(../Images/new.png);"></i><span>新增服务</span></li>
                   <li onclick=""><i style="background-image: url(../Images/new.png);"></i><span>查看价格清单</span></li>
                     <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_BUNDLE)
    { %>
                    <li onclick="Add()"><i style="background-image: url(../Images/new.png);"></i><span>新增服务包</span></li>
                   <li onclick=""><i style="background-image: url(../Images/new.png);"></i><span>查看价格清单</span></li>
                    <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_REQUEST || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_PROBLEM || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_INCIDENT)
    {%>
                        <li onclick="Relation()" style="padding-left: 5px;"><span>关联</span></li>
                       <li onclick="Add()" style="padding-left: 5px;"><span>新增</span></li>
                        <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MASTER_SUB_TICKET_SEARCH)
    {%>
                        <li onclick="Forward()" style="padding-left: 5px;"><span>转发/修改</span></li>
                       <li onclick="DeleteChoose()" style="padding-left: 5px;"><span>删除</span></li>
                        <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALL_TICKET)
    {%>
                    <li onclick="ApplyTicket()" style="padding-left: 5px;"><span>关联工单</span></li>
                       <li onclick="AddTicket()" style="padding-left: 5px;"><span>新增工单</span></li>
                    <%} else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALL_SEARCH)
    {%>
                    <li onclick="Add()" style="padding-left: 5px;"><span>新增</span></li>
                       <li onclick="PrintView()" style="padding-left: 5px;"><span>打印预览</span></li>
                    <%} else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_MY_TICKET||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_VIEW) { %>
                    <li class="Button ButtonIcon NormalState f1" id="options" tabindex="0"> 
                    <span class="Icon" style="width: 0; margin: 0;"></span>
                    <span class="Text">新增</span>
                    <img src="../Images/dropdown.png" alt="" class="ButtonRightImg1" />  
                        <input type="hidden" id="toTicketId" />
                        <input type="hidden" id="toTicketIdHidden" />
                        <input type="hidden" id="AbsorbTicketIds" />
                        <input type="hidden" id="AbsorbTicketIdsHidden" />
            </li>
                    <%} %>
                    <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_ACCOUNT_PROFIT_MARGIN||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_MONTH_PROFIT_MARGIN||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_MONTH_PROFIT_MARGIN_BYDATE||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_CONTRACT_PROFIT||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_CONTRACT_PROFIT_BYDATE||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_CONTRACT_PROFIT_MARGIN||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_PROJECT_PROFIT||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_PROJECT_PROFIT_BYDATE||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_RES_WORKHOUR||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_RES_WORKHOUR_BYDATE||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_ACCOUNT_OVERVIEW||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_ACCOUNT_OVERVIEW_BYDATE||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_VIEW_PROJECT_PROFIT_MARGIN){ %> 
                    <li style="width:28px;" id="ReturnUpper"><i style="background: url(../Images/Icons.png) no-repeat -6px -11px;width: 16px;height: 21px;margin-left: 5px;"></i></li>
                    <%} %>

                    <li id="PrintLi" class="General"><i style="background-image: url(../Images/print.png);"></i></li>
                    <li id="SelectLi" class="General" onclick="javascript:window.open('../Common/ColumnSelector.aspx?type=<%=queryTypeId %>&group=<%=paraGroupId %>', 'ColumnSelect', 'left=200,top=200,width=820,height=470', false);"><i style="background-image: url(../Images/column-chooser.png);"></i></li>
                    <li id="ExportLi" class="General"><i style="background-image: url(../Images/export.png);"></i></li>
                    <li id="RefreshLi" style="display:none;" onclick="Refresh()"><i style="background-image: url(../Images/refresh.png);"></i></li>
                    <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.EXPENSE_REPORT)
                        { %>
                    <li class="right" style="float: right;line-height: 28px;border: 0px solid #bcbcbc;margin-right: 25px;">
	 <select name="IsPay" id="IsPay"  style="width:100px;height: 24px;">
         <option value="0" selected="">全部</option>
		<option value="1">已支付</option>
		<option value="2">未支付</option>
	 </select>
	</li>
                    <%}
                    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.DISPATCH_TICKET_SEARCH)
                    {  %>
                    <li style="background: white;border: 0px solid;">
                     <span style="font-size: 12px;color: #4F4F4F;"><span style="font-weight: bold;margin-top: 6px;">已调度</span><select id="isDiaodu" name="con2545" style="margin-left:6px;width:60px;"><option value=""></option><option value="1">是</option><option value="0">否</option></select></span>
                <span style="font-size: 12px;color: #4F4F4F;"><span style="font-weight: bold;margin-top: 6px;">工单编号/标题/客户名称/合同/项目</span><input type="text" name="con2745" id="con2745" style="height:20px;" /></span></li>
                    <li><input type="button" value="搜索" onclick="SearchTicket()" style="width:50px;"/></li>
                    <%} %>
                </ul>
                <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_UDF)
                    { %>
                <div class="DropDownMenu" id="D1" style=" background-color: #FFF;padding: 5px;border: 1px solid #BCBCBC;cursor: pointer;box-shadow: 1px 3px 4px rgba(0,0,0,0.33);position: fixed;top: 35px;border-top:white;display:none;">
                    <ul>
                        <%if (CheckAuth("SEARCH_PROJECT_EDIT_PROJECT"))
    { %> <li><span class='DropDownMenuItemText' onclick='EditProject()'>编辑项目</span></li> <%}%>
                         <%if (CheckAuth("PRO_PROJECT_VIEW_CALENDAR_ADD"))
    { %>
                        <li><span class='DropDownMenuItemText' onclick='AddProCalendar()'>新增项目日历条目</span></li><%}%>
                          <%if (CheckAuth("PRO_PROJECT_VIEW_NOTE_ADD"))
    { %>
                        <li><span class='DropDownMenuItemText' onclick='AddProjectNote()'>新增项目备注</span></li><%}%>
                         <%if (CheckAuth("PRO_PROJECT_VIEW_SUMMARY_COMPLETE"))
    { %>
                        <li><span class='DropDownMenuItemText' onclick='CompleteProject()'>完成项目</span></li><%}%>
                        <%if (CheckAuth("PRO_PROJECT_VIEW_SUMMARY_SAVE_TEMP"))
    { %>
                        <li><span class='DropDownMenuItemText' onclick='SaveAsTemp()'>保存为项目模板</span></li><%}%>
                        <%if (CheckAuth("PRO_PROJECT_DELETE"))
    { %>
                        <li><span class='DropDownMenuItemText' onclick='DeleteProject()'>删除项目</span></li><%}%>

                    </ul>
                </div>
                <div class="DropDownMenu" id="D2" style="background-color: #FFF;padding: 5px;border: 1px solid #BCBCBC;cursor: pointer;box-shadow: 1px 3px 4px rgba(0,0,0,0.33);position: fixed;top: 35px;border-top:white;display:none;margin-left: 84px;">
                     <ul>      <%if (CheckAuth("PRO_PROJECT_VIEW_UDF_COPY_OPPORTUNITY"))
    { %><li><span class='DropDownMenuItemText' onclick='CopyFromOppo()'>从商机复制</span></li><%}%></ul>
                </div>
                <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_SEARCH || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_ACCOUNT_LIST || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_TASK_TICKET||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_MY_TICKET||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_VIEW)
    { %>
                <div class="DropDownMenu" id="D1" style=" background-color: #FFF;padding: 5px;border: 1px solid #BCBCBC;cursor: pointer;box-shadow: 1px 3px 4px rgba(0,0,0,0.33);position: fixed;top: 35px;border-top:white;display:none;">
                    <ul>
                        <li><span class='DropDownMenuItemText' onclick="AddTicket('<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.SERVICE_REQUEST %>')">工单</span></li> 
                        <li><span class='DropDownMenuItemText' onclick="AddTicket('<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.INCIDENT %>')">事故工单</span></li> 
                        <li><span class='DropDownMenuItemText' onclick="AddTicket('<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.PROBLEM %>')">问题工单</span></li> 
                        <li><span class='DropDownMenuItemText' onclick="AddTicket('<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.CHANGE_REQUEST %>')">变更请求工单</span></li> 
                        <li><span class='DropDownMenuItemText' onclick="AddTicket('')">非定期工单</span></li> 
                    </ul>
                </div>
                <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MASTER_SUB_TICKET_SEARCH)
    {
        var holSet = new EMT.DoneNOW.DAL.sys_organization_location_dal().GetLocList();
                        %>
                <span style="font-size: 12px;color: #4F4F4F;margin-top: 13px;height: 22px;display: inline-block;"><span style="font-weight: bold;margin-top: 6px;">假期设置</span><select id="location" style="margin-left:6px;"><option></option><%if (holSet != null && holSet.Count > 0)
    {
        foreach (var set in holSet)
        {%><option value="<%=set.id %>"><%=set.name %></option><%}
    } %></select> </span>
                <%}
    else if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALL_TICKET)
    { %>
                <%--<span style="font-size: 12px;color: #4F4F4F;margin-top: 13px;height: 22px;display: inline-block;margin-right:20px;margin-left:80px;"><span style="font-weight: bold;margin-top: 6px;">条目是否分配</span><select id="isFenPei" style="margin-left:6px;"><option value="0">未分配</option><option value="1">已分配</option></select></span>
                <span style="font-size: 12px;color: #4F4F4F;margin-top: 13px;height: 22px;display: inline-block;margin-right:20px;"><span style="font-weight: bold;margin-top: 6px;">截止时间范围</span><select id="dueTime" style="margin-left:6px;"><option value="1">从今天开始+/-30天</option><option value=""></option></select></span>--%>
                <%} %>

              <div class="fl" id="addDiv" style="line-height:47px;margin-right:30px;">
              <%if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractService) { %>
                <span>显示数据</span><input type="text" name="serviceTime" style="margin-left:8px;" value="<%=searchTime.ToString("yyyy-MM-dd") %>" onclick="WdatePicker()" class="Wdate" />
                <a onclick="editTime()" style="width:16px;height:16px;"><img src="../Images/search.png" /></a>
              <%} %>
              </div>

                <%if (queryResult != null && queryResult.count > 0)
                    { %>
                <div class="page fl">

                    <%
                        int indexFrom = queryResult.page_size * (queryResult.page - 1) + 1;
                        int indexTo = queryResult.page_size * queryResult.page;
                        if (indexFrom > queryResult.count)
                            indexFrom = queryResult.count;
                        if (indexTo > queryResult.count)
                            indexTo = queryResult.count;
                    %>
                    <span>第<%=indexFrom %>-<%=indexTo %>&nbsp;&nbsp;总数&nbsp;<%=queryResult.count %></span>
                    <span>每页<%if (queryResult.page_size == 20)
                                {
                    %>&nbsp;20&nbsp;<%}
                                        else
                                        {
                    %><a href="#" onclick="ChangePageSize(20)">20</a><%}
                    %>|<%if (queryResult.page_size == 50)
                           {
                    %>&nbsp;50&nbsp;<%}
                                        else
                                        {
                    %><a href="#" onclick="ChangePageSize(50)">50</a><%}
                    %>|<%if (queryResult.page_size == 100)
                           { %>&nbsp;100&nbsp;<%}
                                                  else
                                                  { %><a href="#" onclick="ChangePageSize(100)">100</a><%} %></span>
                    <i style="padding:0px;" onclick="ChangePage(1)"><<</i>&nbsp;<i onclick="ChangePage(<%=queryResult.page-1 %>)"><</i>
                    <input type="text" style="width: 30px; text-align: center;height:30px;" value="<%=queryResult.page %>" />
                    <span style="margin-right:5px;">&nbsp;/&nbsp;<%=queryResult.page_count %></span>
                    <i style="padding:0px;" onclick="ChangePage(<%=queryResult.page+1 %>)">></i>&nbsp;<i onclick="ChangePage(<%=queryResult.page_count %>)">>></i>
                </div>
                <%} %>
            </div>

        </div>
    </form>
    <%if (queryResult != null) { %>

    <div class="searchcontent" id="searchcontent" style="min-width: <%=tableWidth%>px; overflow: hidden;">
        <table border="" cellspacing="0" cellpadding="0" style="overflow: scroll; width: 100%; height: 100%;" id="SearchTable">
            <tr>
                <%if (!string.IsNullOrEmpty(isCheck))
                    { %>
                <th style="padding-left: 4px;width:22px;max-width:22px;">
                    <input id="CheckAll" type="checkbox" /></th>

                <%} %>
                <%foreach (var para in resultPara)
                    {
                      if (para.visible != 1)
                        continue;
                      if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                          || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                          || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                        continue;
                      string orderby = null;
                      string order = null;
                      if (!string.IsNullOrEmpty(queryResult.order_by))
                      {
                        var strs = queryResult.order_by.Split(' ');
                        orderby = strs[0];
                        order = strs[1].ToLower();
                      }
                %>
                <th <%if (para.id != 0) { %>title="点击按此列排序" onclick="ChangeOrder('<%=para.name %>')" <%} %> width="<%=para.length*32 %>px" class="OrderTh">
                    <%=para.name %>
                    <%if (orderby != null && para.name.Equals(orderby))
                        { %><img src="../Images/sort-<%=order %>.png" />
                    <%} %></th>
                <%} %>
            </tr>
            <%               
                if (queryResult.count>0)
                {
                    var idPara = resultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);
                    foreach (var rslt in queryResult.result)
                    {
                        string id = "0";
                        if (idPara != null)
                            id = rslt[idPara.name].ToString();
            %>
           <%-- 如果是撤销审批，则不需要右键菜单--%>
            <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_CHARGES || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_MILESTONES || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_MILESTONES || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_SUBSCRIPTIONS)
                {%>
            <tr onclick="View(<%=id %>)" data-val="<%=id %>" class="dn_tr">
            <%}
    else
    { %>

            <tr onclick="ViewEntity('<%=id %>')" title="右键显示操作菜单" data-val="<%=id %>" class="dn_tr">

                <%} %>
                <%if (!string.IsNullOrEmpty(isCheck))
                    { %>
                <td style="width:22px;max-width:22px;" class="CheckTd">
                    <input type="checkbox" class="IsChecked" value="<%=id %>" /></td>

                <%} %>
                <%foreach (var para in resultPara)
                    {
                        if (para.visible != 1)
                            continue;
                        if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                            continue;
                %>
                <%if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.PIC)
                    {
                        string tooltip = null;
                        if (resultPara.Exists(_ => _.name.Equals(para.name + "tooltip")))
                            tooltip = para.name + "tooltip"; %>
                <td <%if (tooltip != null)
                    { %>title="<%=rslt[tooltip] %>"
                    <%} %> style="background: url(..<%=rslt[para.name] %>) no-repeat center;"></td>
                <%}
                    else if (catId==(int)(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_OTHER_SYSTEM_OPERLOG&&para.name == "详情")
                    {var stDal = new EMT.DoneNOW.DAL.sdk_task_dal();%>
                <td><%=stDal.GetContractSql(rslt[para.name].ToString()) %></td>
                    <%}
                    else
                    {
                        string url = null;
                        if(para.url!=null)
                        {
                            url = para.url.url;
                            if (para.url.parms!=null&&para.url.parms.Count!=0)
                            {
                                url += "?";
                                foreach(var urlPara in para.url.parms)
                                {
                                    if (rslt.ContainsKey(urlPara.value))
                                        url += urlPara.name + "=" + rslt[urlPara.value] + "&";
                                    else
                                        url += urlPara.name + "=" + urlPara.value + "&";
                                }
                            }
                            if(para.url.url=="/ContractProjectTicket" && rslt.ContainsKey("parent_type"))
                            {
                                if (rslt["parent_type"].ToString()=="contract")
                                {
                                    url = "/Contract/ContractView?id=" + rslt["contract_id"];
                                }
                                else if (rslt["parent_type"].ToString()=="project")
                                {
                                    url = "/Project/ProjectView?id=" + rslt["project_id"];
                                }
                                else if (rslt["parent_type"].ToString()=="ticket")
                                {
                                    url = "";
                                }
                            }
                        }
                        %>
              <%if (url == null) {
                      if (para.id == 0 && para.name == "操作") { %><td><input type="button" value="删除" onclick="Delete(<%=id%>)" /></td><%} else { %>
                <td><%=rslt[para.name] %></td><%} %>
              <%} else { %>
              <td><span><a onclick="javascript:OpenWindow('<%=url %>','_blank')" ><%=rslt[para.name] %></a></span> </td>
              <%} %>
                <%} %>
                <%} // foreach
                %>
            </tr>
            <%} // foreach
                } // else
            %>
        </table>
    </div>
     <%
         if (queryResult.count == 0)
         {
            %>
                <div id="noData" style="color: red;text-align:center;padding:10px 0;font-size:14px;font-weight:bold;">选定的条件未查找到结果</div>
            <%}%>
    <%} %>

    <div id="menu">
        <%if (contextMenu.Count > 0)
            { %>
        <ul style="width: 220px;" id="menuUl">
            <%foreach (var menu in contextMenu)
                { %>
            <li id="<%=menu.id %>" class="<%=menu.class_name %>" onclick="<%=menu.click_function %>"><i class="menu-i1"></i><%=menu.text %>
                <%if (menu.submenu != null)
                    { %>
                <i class="menu-i2">>></i>
                <ul id="menu-i2-right">
                    <%foreach (var submenu in menu.submenu)
                        { %>
                    <li onclick="<%=submenu.click_function %>"  id="<%=submenu.id %>" class="<%=submenu.class_name %>"><%=submenu.text %></li>
                    <%} %>
                </ul>
                <%} %>
            </li>
            <%} %>
        </ul>
        <%} %>
    </div>
    
 <!--弹框-->
    <div class="Dialog" id="accounttanchuan">
        <div>
            <div class="CancelDialogButton cancel_account"></div>
            <div class="TitleBar"></div>
            <div class="NoHeading Section">
                <div class="Content">
                    <div class="StandardText">分类图标：有<span id="accountcount"></span>个客户关联此客户类别。</div>
                    <div class="StandardText HighImportance">如果删除，则相关客户上的客户类别信息将会被清空。</div>
                    <div class="StandardText">您确定要删除此分类吗？</div>
                </div>
            </div>
            <div class="GridBar ButtonContainer">
                <a class="Button ButtonIcon NormalState" id="delete_account">
                    <span class="Text">是的，删除</span>
                </a>
                <a class="Button ButtonIcon NormalState" id="noactive_account">
                    <span class="Text">不，停用</span>
                </a>
                <a class="Button ButtonIcon NormalState cancel_account">
                    <span class="Text">取消</span>
                </a>
            </div>
        </div>
    </div>
    <!-- 拒绝费用审批理由填写 -->
    <div class="Dialog" style="margin-left: -370px; margin-top: -229px; z-index: 100; display: none;max-width:500px;height:320px;" id="RefuseExpenseReport">
         <div>
                <div class="DialogContentContainer">
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title">
                            <span class="text" style="margin-left: -18px;color:white;">拒绝原因</span>
                        </div>
                    </div>
                    <div class="DialogHeadingContainer">
                     
                        <div class="ButtonContainer" style="float:left;"><a class="Button ButtonIcon Save NormalState" id="rejectButton" tabindex="0"><span class="Text">拒绝</span></a></div>
                         <div class="ButtonContainer" ><a class="Button ButtonIcon Save NormalState" id="CloseButton" tabindex="0"><span class="Text">取消</span></a></div>
                    </div>
                    <div class="ScrollingContentContainer" style="position: unset;margin-top: 10px;">
                        <div class="ScrollingContainer" id="" style="top: 80px;">
                            <div class="Medium NoHeading Section">
                                <div class="Content">
                                    <div class="Normal Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="ajax303a00d30ad844dcb3e55c4b5a88de3c_0_Reason">拒绝原因</label><span class="Required" style="color:red;">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor TextArea" data-editor-id="" data-rdp="" style="top: 80px;">
                                            <div class="InputField">
                                                <textarea class="Medium" id="rejectReason" name="" placeholder="" style="border: solid 1px #D7D7D7; padding: 0px 0 5px 0;max-width:330px;min-height:175px;width:300px;"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
    </div>
        <%--加载--%>
<div id="BackgroundOverLay"></div>
<div id="LoadingIndicator"></div>
     <%--加载结束--%>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/Common/SearchBody.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
        <% if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Opportunity
            || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityCompanyView
            || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityContactView)
        {
            %>
        function EditOpp() {
            <%--window.open("../Opportunity/OpportunityAddAndEdit.aspx?opportunity_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityEdit %>', 'left=0,top=0,location=no,status=no,width=750,height=750', false);--%>
            OpenWindow("../Opportunity/OpportunityAddAndEdit.aspx?opportunity_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityEdit %>');
        }
        function ViewOpp() {
            OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + entityid, '_blank');
        }
        function View(id) {
            OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + id, '_blank');
        }
        function ViewCompany() {
            OpenWindow("../Company/ViewCompany.aspx?type=todo&id=" + entityid, '_blank');
        }
        function AddQuote() {
            window.open("../Quote/QuoteAddAndUpdate.aspx",'<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteAdd %>', 'left=0,top=0,width=750,height=750', false);
        }
        function DeleteOpp() {
            $.ajax({
                type: "GET",
                url: "../Tools/OpportunityAjax.ashx?act=delete&id=" + entityid,
                success: function (data) {
                    alert(data);
                }
            })
        }
        <%if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Opportunity)
        { %>
        function Add() {
            OpenWindow("../Opportunity/OpportunityAddAndEdit.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>');
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityCompanyView)
        { %>
        function Add() {
            OpenWindow('../Opportunity/OpportunityAddAndEdit.aspx?oppo_account_id=<%=objId%>', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>');
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityContactView)
        { %>
        function Add() {
            OpenWindow("../Opportunity/OpportunityAddAndEdit.aspx?oppo_contact_id=<%=objId%>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>');
        }
        <%}%>
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.QuoteTemplate)
        {
            %>
        function Add() {
            OpenWindow("../QuoteTemplate/QuoteTemplateAdd.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteTemplateAdd %>');
        }
        function Edit() {
            OpenWindow("../QuoteTemplate/QuoteTemplateEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteTemplateEdit %>');
        }
        function View(id) {
            OpenWindow("../QuoteTemplate/QuoteTemplateEdit.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteTemplateEdit %>');
         }
        function Copy() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=copy&id=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "error") {
                        alert("报价模板，复制失败！");
                    } else {
                        alert("报价模板复制成功，点击确定进入编辑界面！");
                        OpenWindow("../QuoteTemplate/QuoteTemplateEdit.aspx?id=" + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteTemplateEdit %>');
                    }                    
                }
            })
        }
        function Delete() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=delete&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        function Default() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=default&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        function Active() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=active&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        function NoActive() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=noactive&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        <%
        }
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ProuductInventory)
        {%>//产品库存管理
        function Add() {
            parent.parent.parent.openkk();
        }
        function Edit() {
            window.open("../Product/ProductStock.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Inventory %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Transfer() {
            window.open("../Product/TransferProductStock.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.InventoryTransfer %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Order() {
            alert("暂未实现");
        }
        function Delete() {
            if (confirm("删除后无法恢复，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/InventoryAjax.ashx?act=delete&id=" + entityid,
                    async: false,
                    success: function (data) {
                        alert(data);
                        parent.parent.parent.refrekkk();
                    }
                })
            }

        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.InternalCost)
        {%>
        function Edit() {
            var contract_id = <%=Request.QueryString["id"] %> ;
            if (contract_id != undefined && contract_id != "") {
                window.open("../Contract/InteralCostAddOrEdit.aspx?contract_id=" + contract_id + "&cost_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConIntCostEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            }
        }

        function Delete() {
            if (confirm("如果删除此内部成本，则此员工和角色的所有尚未提交的工时表将使用管理模块中为该资源配置的内部成本。您要继续吗？")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=delete&cicid=" + entityid,
                    async: false,
                    success: function (data) {
                        if (data == "True") {
                            alert('删除成功');
                            history.go(0);
                        } else {
                            alert("删除失败");
                        }

                    }
                })
            }
        }

        function Add() {
            var contract_id = <%=Request.QueryString["id"] %> ;
            if (contract_id != undefined && contract_id != "") {
                window.open("../Contract/InteralCostAddOrEdit.aspx?contract_id=" + contract_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            }
        }

        function View() {

        }

         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Resource)
        {%>//员工
        function View(id) {
            window.open("../SysSetting/SysUserEdit.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Resource %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }

        function Add() {
            window.open("../SysSetting/SysUserAdd.aspx?", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Resource %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open("../SysSetting/SysUserEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Resource %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Copy() {

        }
        function k() {
            alert("暂未实现");
        }
        function Delete() { }

        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Role)
        {%>//角色
        function View(id) {
            window.open("../SysSetting/SysRolesAdd.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Role %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }

        function Add() {
            window.open("../SysSetting/SysRolesAdd.aspx?", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Role %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open("../SysSetting/SysRolesAdd.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Role %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            //if (confirm("删除后无法恢复，是否继续?")) {
            //    $.ajax({
            //        type: "GET",
            //        url: "../Tools/RoleAjax.ashx?act=delete&id=" + entityid,
            //        async: false,
            //        success: function (data) {
            //            alert(data);
            //        }
            //    })
            //}

        }
        function Active() {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=Active&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        function Inactive() {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=No_Active&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        //从全部激活的合同中排除
        function Exclude() {
            if (confirm("从全部当前激活的合同中排除?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/RoleAjax.ashx?act=Exclude&id=" + entityid,
                    async: false,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            }
        }

        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Department)
        {%>//部门
        function View(id) {
            window.open("../SysSetting/SysDepartment.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Department %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }

        function Add() {
            window.open("../SysSetting/SysDepartment.aspx?", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Department %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open("../SysSetting/SysDepartment.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Department %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            if (confirm("删除后无法恢复，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/DepartmentAjax.ashx?act=delete&id=" + entityid,
                    async: false,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            }
        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Prouduct)
        {%>//产品
        function Add() {
            window.open("../Product/ProductAdd.aspx?", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductView %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open("../Product/ProductAdd.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProuductEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function View(id) {
            window.open("../Product/ProductAdd.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProuductEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            if (confirm("删除后无法恢复，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ProductAjax.ashx?act=DeleteProduct&product_id=" + entityid,
                    async: false,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            }
        }

        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Relation_ConfigItem)
        {%>
        function view() {

        }
        function Edit() {
            window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EditInstalledProduct %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Norelation() {
            var contract_id = <%=Request.QueryString["id"] %>;
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=RelieveIP&InsProId=" + entityid + "&contract_id=" + contract_id,
                success: function (data) {
                    if (data == "True") {
                        alert("解除绑定成功");
                    }
                    else {
                        alert("解除绑定失败");
                    }
                    // history.go(0);

                    parent.location.reload();
                }
            })
        }
        function Delete() {
            if (confirm("删除后无法恢复，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ProductAjax.ashx?act=deleteIP&iProduct_id=" + entityid,
                    success: function (data) {
                        if (data == "True") {
                            alert('删除成功');
                        } else if (data == "False") {
                            alert('删除失败');
                        }
                        history.go(0);
                    }
                })
            }
        }

        function Add() {
            var contract_id = <%=Request.QueryString["id"] %>;
            window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?contract_id=" + contract_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EditInstalledProduct %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Norelation_ConfigItem)
        {%>
        function view() {

        }
        function Edit() {
            window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EditInstalledProduct %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Relation() {
            var contract_id = <%=Request.QueryString["contract_id"] %>;
            var isopen = "";
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContractAjax.ashx?act=isService&contract_id=" + contract_id,
                success: function (data) {
                    if (data != "") {
                        isopen = data;
                    }
                }
            })


            if (isopen == "") {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=RelationIP&InsProId=" + entityid + "&contract_id=" + contract_id,
                    success: function (data) {
                        if (data == "True") {
                            alert('关联成功');
                        } else if (data == "False") {
                            alert('关联失败');
                        }
                        parent.location.reload();

                    }
                })
            }
            else {
                // 打开窗口
                window.open("../ConfigurationItem/RelatiobContract.aspx?insProId=" + entityid + "&contractId=" + contract_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.RelationContract %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            }
        }
        function Delete() {
            if (confirm("删除后无法恢复，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ProductAjax.ashx?act=deleteIP&iProduct_id=" + entityid,
                    success: function (data) {
                        if (data == "True") {
                            alert('删除成功');
                        } else if (data == "False") {
                            alert('删除失败');
                        }
                        history.go(0);
                    }
                })
            }
        }


         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.CONFIGITEM)
        {%>//配置项类型
        function View(id) {
            window.open("../ConfigurationItem/ConfigType.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConfigItemType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Add() {
            window.open("../ConfigurationItem/ConfigType.aspx?", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConfigItemType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
          }
          function Edit() {
              window.open("../ConfigurationItem/ConfigType.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConfigItemType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
          }
          function Delete() {
              if (confirm('删除操作将不能恢复，是否继续?')) {
                  $.ajax({
                      type: "GET",
                      url: "../Tools/ConfigItemTypeAjax.ashx?act=delete_validate&id=" + entityid,
                      success: function (data) {
                          if (data == "system") {
                              alert("系统默认不能删除！");
                          } else if (data == "other") {
                              alert("其他原因使得删除失败！");
                          } else {
                              alert(data);
                          }
                      }
                  });
              }
              window.location.reload();
          }
          function Active() {
              $.ajax({
                  type: "GET",
                  url: "../Tools/ConfigItemTypeAjax.ashx?act=Active&id=" + entityid,
                  async: false,
                  success: function (data) {
                      alert(data);
                      history.go(0);
                  }
              })
              window.location.reload();
          }
          function Inactive() {
              $.ajax({
                  type: "GET",
                  url: "../Tools/ConfigItemTypeAjax.ashx?act=No_Active&id=" + entityid,
                  async: false,
                  success: function (data) {
                      alert(data);
                      history.go(0);
                  }
              })
              window.location.reload();
          }
       <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.SECURITYLEVEL)
        {%>//安全等级
        function View(id) {
            window.open('../SysSetting/SysUserSecurityLevel.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SecurityLevel%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Copy() {
            $.ajax({
                type: "GET",
                url: "../Tools/SecurityLevelAjax.ashx?act=copy&id=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "error") {
                        alert("安全等级复制失败！");
                    } else {
                        alert("安全等级复制成功，点击确定进入编辑界面！");
                        window.open('../SysSetting/SysUserSecurityLevel.aspx?id=' + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SecurityLevel%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                        history.go(0);
                    }
                }
            })
        }
        function Edit() {
            window.open('../SysSetting/SysUserSecurityLevel.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SecurityLevel%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Active() {
            $.ajax({
                type: "GET",
                url: "../Tools/SecurityLevelAjax.ashx?act=active&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
            window.location.reload();
        }
        function Delete() {
            if (confirm('删除操作将不能恢复，是否继续?')) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/SecurityLevelAjax.ashx?act=delete&id=" + entityid,
                    async: false,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            }
            window.location.reload();
        }
        function Inactive() {
            $.ajax({
                type: "GET",
                url: "../Tools/SecurityLevelAjax.ashx?act=noactive&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
            window.location.reload();
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.MILESTONE)
        {%>//里程碑状态
        function View(id) {
            window.open('../SysSetting/ContractMilestone.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractMilestone%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Add() {
            window.open('../SysSetting/ContractMilestone.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractMilestone%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open('../SysSetting/ContractMilestone.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractMilestone%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Active() {
            $.ajax({
                type: "GET",
                url: "../Tools/GeneralViewAjax.ashx?act=active&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            });
        }
        function Delete() {
            if (confirm('删除操作将不能恢复，是否继续?')) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid,
                    async: false,
                    success: function (data) {
                        if (data == "system") {
                            alert("系统状态不能删除！");
                        } else if (data == "other") {
                            alert("其他原因使得删除失败！");
                        } else if (data=="success"){
                            alert("删除成功！");
                            history.go(0);
                        } else {
                            alert(data);
                            history.go(0);
                        }
                    }
                });
            }
        }
        function Inactive() {
            $.ajax({
                type: "GET",
                url: "../Tools/GeneralViewAjax.ashx?act=noactive&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            });
        }
       <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.REVOKE_CHARGES)
        {%>//撤销审批成本
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            //$("#BackgroundOverLay").show();
            //$("#LoadingIndicator").show();
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ReverseAjax.ashx?act=CHARGES&ids=" + ids,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            } else {
                alert("请选择需要审批的数据！");
            }
        }
       <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.REVOKE_RECURRING_SERVICES)
        {%>//撤销定期服务审批
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            //$("#BackgroundOverLay").show();
            //$("#LoadingIndicator").show();
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ReverseAjax.ashx?act=Recurring_Services&ids=" + ids,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            } else {
                alert("请选择需要审批的数据！");
            }
        }
       <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.REVOKE_MILESTONES)
        {%>//撤销里程碑审批
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ReverseAjax.ashx?act=Milestones&ids=" + ids,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            } else {
                alert("请选择需要审批的数据！");
            }
        }
       <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.REVOKE_SUBSCRIPTIONS)
        {%>//撤销订阅审批
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            //$("#BackgroundOverLay").show();
            //$("#LoadingIndicator").show();
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ReverseAjax.ashx?act=Subscriptions&ids=" + ids,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            } else {
                alert("请选择需要审批的数据！");
            }
        }
            <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_MILESTONES)
        {%>//审批里程碑
        //审批并提交(批量)
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&ids=' + ids, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            } else {
                alert("请选择需要审批的数据！");
            }
        }
        //审批并提交
        function Post() {
            window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //查看里程碑详情
        function Miledetail() {
            window.open('../Contract/ContractMilestoneDetail.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractMilestone%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //查看合同详情
        function ContractDetail() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=ContractDetails&id=" + entityid + "&type=" + <%=queryTypeId%>,
                success: function (data) {
                    window.open('../Contract/ContractView.aspx?&id=' + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConChargeDetails%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                }
            });
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_SUBSCRIPTIONS)
        {%>//审批订阅
        //审批并提交(批量)
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&ids=' + ids, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            } else {
                alert("请选择需要审批的数据！");
            }
        }
        //审批并提交
        function Post() {
            window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //恢复初始值
        function Restore_Initiall() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=init&id=" + entityid + "&type=" + <%=queryTypeId%>,
                async: false,
                success: function (data) {
                    alert(data);
                }
            });
            window.location.reload();
        }
        //调整总价
        function AdjustExtend() {
            window.open('../Contract/AdjustExtendedPrice.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdjust%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_RECURRING_SERVICES)
        {%>//审批定期服务
        //审批并提交(批量)
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&ids=' + ids, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            } else {
                alert("请选择需要审批的数据！");
            }
        }
        //审批并提交
        function Post() {
            window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //查看合同详情
        function ContractDetail() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=ContractDetails&id=" + entityid + "&type=" + <%=queryTypeId%>,
                success: function (data) {
                    window.open('../Contract/ContractView.aspx?&id=' + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConChargeDetails%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                }
            });
        }
        //恢复初始值
        function Restore_Initiall() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=init&id=" + entityid + "&type=" + <%=queryTypeId%>,
                async: false,
                success: function (data) {
                    alert(data);
                }
            });
            window.location.reload();
        }
        //调整总价
        function AdjustExtend() {
            window.open('../Contract/AdjustExtendedPrice.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdjust%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);

        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_CHARGES)
        {%>//审批成本
        //审批并提交(批量)
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                window.open('../Contract/ApproveChargeSelect.aspx?type=' +  <%=queryTypeId%>  + '&ids=' + ids, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractChargeSelect%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            } else {
                alert("至少选择一项！");
            }
        }
        //生成发票
      <%--  function ToInvoice() {
            $("#PageFrame").attr("src", "Invoice/InvocieSearch");
           <%-- window.open('../Invoice/InvocieSearch.aspx','<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdjust%>','left=0,top=0,location=no,status=no,width=900,height=750',false);--%>
        //审批并提交
        function Post() {
            window.open('../Contract/ApproveChargeSelect.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdjust%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //查看合同详情
        function ContractDetail() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=ContractDetails&id=" + entityid + "&type=" + <%=queryTypeId%>,
                success: function (data) {
                    window.open('../Contract/ContractView.aspx?&id=' + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConChargeDetails%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);  
                }
            });    
        }

        // 查看项目详情
        function ProjectDetail() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=GetProjectId&id=" + entityid + "&type=" + <%=queryTypeId%>,
                success: function (data) {
                    if (data != "") {
                        window.open('../Project/ProjectView.aspx?&id=' + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.PROJECT_VIEW%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                    }
                    
                }
            });  
        }
        //查看工单详情
        function TicketDetail() {

        }
        //设置为可计费
        function Billing() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=billing&id=" + entityid + "&type=" + <%=queryTypeId%>,
                    success: function (data) {
                        alert(data);
                    }
                });
                window.location.reload();
            }
            //设置为不可计费
            function NoBilling() {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ApproveAndPostAjax.ashx?act=nobilling&id=" + entityid + "&type=" + <%=queryTypeId%>,
                    async: false,
                    success: function (data) {
                        alert(data);
                    }
                });
                window.location.reload();
            }
            //恢复初始值
            function Restore_Initiall() {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ApproveAndPostAjax.ashx?act=init&id=" + entityid + "&type=" + <%=queryTypeId%>,
                    async: false,
                    success: function (data) {
                        alert(data);
                    }
                });
                window.location.reload();
            }
            //调整总价
            function AdjustExtend() {
                window.open('../Contract/AdjustExtendedPrice.aspx?type=' + <%=queryTypeId%> + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdjust%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);

            }
 <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.CONTRACT_DEFAULT_COST)
        { %>
        function Edit() {
            window.open('../Contract/AddDefaultCharge.aspx?contract_id=' + <%=Request.QueryString["id"] %> + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConDefCostEdit%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=deleteDefaultCost&cdcID=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "True") {
                        alert("删除成功");
                    }
                    else {
                        alert("删除失败");
                    }
                    history.go(0);
                }
            })
        }
        function Add() {
            debugger;
            var contract_id = '<%=Request.QueryString["id"] %>';
            //var isAdd = "";
            //if (contract_id != "" && (!isNaN(contract_id))) {
            //    $.ajax({
            //        type: "GET",
            //        url: "../Tools/ContractAjax.ashx?act=GetDefaultCost&contract_id=" + contract_id,
            //        async: false,
            //        success: function (data) {
            //            if (data != "") {
            //                isAdd = "1";
            //            }
            //        }
            //    })
            //}
            //if (isAdd != "") {
            //    alert("该合同已经拥有默认成本，不可重复添加！");
            //    return false;
            //}

            window.open('../Contract/AddDefaultCharge.aspx?contract_id=' + <%=Request.QueryString["id"] %>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConDefCostAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function View() {

        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.CONTRACT_RATE)
        {%>

        function Add() {
            window.open('../Contract/AddContractRate.aspx?contract_id=' + <%=Request.QueryString["id"] %>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConRateAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {

            window.open('../Contract/AddContractRate.aspx?contract_id=' + <%=Request.QueryString["id"] %>+"&rate_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConRateEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }

        function Delete() {
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=DeleteRate&rateId=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "True") {
                        alert("删除成功");
                    }
                    else {
                        alert("删除失败");
                    }
                    history.go(0);
                }
            })
        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ACCOUNTTYPE)
        { %>//客户类别
        function Add() {
            window.open('../SysSetting/AccountClass.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ACCOUNTTYPE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open('../SysSetting/AccountClass.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ACCOUNTTYPE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function View(id) {
            window.open('../SysSetting/AccountClass.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ACCOUNTTYPE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            if (confirm('删除操作将不能恢复，是否继续?')) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/AccountClassAjax.ashx?act=delete_validate&id=" + entityid,
                    success: function (data) {
                        if (data == "system") {
                            alert("系统默认不能删除！");
                            return false;
                        } else if (data == "other") {
                            alert("其他原因使得删除失败！");
                        } else if (data == "success") {
                            alert("删除成功！");
                            history.go(0);
                        } else if (data == "error") {
                            alert("删除失败！");
                        } else {
                            $("#accountcount").text(data);
                            $("#BackgroundOverLay").show();
                            $("#accounttanchuan").addClass("Active");
                            $("#delete_account").on("click", function () {                               
                                //点击删除
                                $.ajax({
                                    type: "GET",
                                    url: "../Tools/AccountClassAjax.ashx?act=delete&id=" + entityid,
                                    success: function (data) {
                                        if (data == "success") {
                                            alert("删除成功！");
                                            history.go(0);
                                        } else if (data == "error") {
                                            alert("删除失败！");
                                        }
                                    }
                                });
                                $("#BackgroundOverLay").hide();
                                $("#accounttanchuan").removeClass("Active");
                            });   
                             
                            //选择停用
                            $("#noactive_account").on("click", function () {
                                NoActive();
                                $("#BackgroundOverLay").hide();
                                $("#accounttanchuan").removeClass("Active");
                            });

                            //取消
                            $(".cancel_account").on("click", function () {
                                $("#BackgroundOverLay").hide();
                                $("#accounttanchuan").removeClass("Active");
                            });
                        }
                    }
                });
            }
        }
        function Active() {
            $.ajax({
                type: "GET",
                url: "../Tools/AccountClassAjax.ashx?act=active&id=" + entityid,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            });
        }
        function NoActive() {
            $.ajax({
                type: "GET",
                url: "../Tools/AccountClassAjax.ashx?act=noactive&id=" + entityid,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            });
        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OPPPORTUNITYWINREASON)
        { %>//关闭商机
        function Add() {           
            window.open('../Opportunity/OpportunityWinReasons.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITYWIN %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);               
        }
        function Edit() {
            window.open('../Opportunity/OpportunityWinReasons.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITYWIN %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('确认删除?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/OpportunityReasonAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.OPPORTUNITY_WIN_REASON_TYPE%>",//GT_id 表示当前操作的类型
                        success: function (data) {
                            if (data == "system") {
                                alert("系统默认不能删除！");
                                return false;
                            } else if (data == "other") {
                                alert("其他原因使得删除失败！");
                            } else if (data == "success") {
                                alert("删除成功！");
                                history.go(0);
                            } else if (data == "error") {
                                alert("删除失败！");
                            } else {
                                alert(data);
                                history.go(0);
                            }
                        }
                });
            }
        }
          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OPPPORTUNITYLOSSREASON)
        { %>//丢失商机
          function Add() {
              window.open('../Opportunity/OpportunityLossReason.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITYLOSS %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
          function View(id) {
              window.open('../Opportunity/OpportunityLossReason.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITYLOSS %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
          }
          function Edit() {
              window.open('../Opportunity/OpportunityLossReason.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITYLOSS %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('确认删除?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/OpportunityReasonAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.OPPORTUNITY_LOSS_REASON_TYPE%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                             return false;
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             alert(data);
                             history.go(0);
                         }
                     }
                 });
             }
          }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Market)
        { %>//市场
         function Edit() {
             window.open('../SysSetting/SysMarket.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.MARKET_SEGMENT %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/SysMarket.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.MARKET_SEGMENT %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/SysMarket.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.MARKET_SEGMENT %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.MARKET_SEGMENT%>",//GT_id 表示当前操作的类型
                       success: function (data) {
                           if (data == "system") {
                               alert("系统默认不能删除！");
                           } else if (data == "other") {
                               alert("其他原因使得删除失败！");
                           } else if (data == "success") {
                               alert("删除成功！");
                               history.go(0);
                           } else if (data == "error") {
                               alert("删除失败！");
                           } else {
                               if (confirm(data)) {
                                   $.ajax({
                                       type: "GET",
                                       url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.MARKET_SEGMENT%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                   });
                               }
                           }
                       }
                });
            }
        }
          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ACCOUNTREGION)
        { %>//区域
         function Edit() {
             window.open('../SysSetting/SysRegion.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.REGION %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/SysRegion.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.REGION %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/SysRegion.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.REGION %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.REGION%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.REGION%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                 });
                             }
                         }
                     }
                 });
             }
         }
          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Territory)
        { %>//地域
         function Edit() {
             window.open('../SysSetting/SysTerritory.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TERRITORY %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/SysTerritory.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TERRITORY %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
           }
           function View(id) {
               window.open('../SysSetting/SysTerritory.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TERRITORY %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.TERRITORY%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.TERRITORY%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                 });
                             }
                         }
                     }
                 });
             }
         }

          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.COMPETITOR)
        { %>//竞争对手
         function Edit() {
             window.open('../SysSetting/SysCompetitor.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.COMPETITOR %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/SysCompetitor.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.COMPETITOR %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/SysCompetitor.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.COMPETITOR %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
           }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.COMPETITOR%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.COMPETITOR%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                 });
                             }
                         }
                     }
                 });
             }
         }

          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OPPORTUNITYSOURCE)
        { %>//商机来源
         function Edit() {
             window.open('../Opportunity/OpportunityLeadSource.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_SOURCE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../Opportunity/OpportunityLeadSource.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_SOURCE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../Opportunity/OpportunityLeadSource.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_SOURCE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.OPPORTUNITY_SOURCE%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.OPPORTUNITY_SOURCE%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                 });
                             }
                         }
                     }
                 });
             }
         }

          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.SUFFIXES)
        { %>//后缀
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.NAME_SUFFIX%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.NAME_SUFFIX%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                 });
                             }
                         }
                     }
                 });
             }
         }
         function Edit() {
             window.open('../SysSetting/Suffixes.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/Suffixes.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/Suffixes.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }


          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ACTIONTYPE)
        { %>//活动类型
         function Delete() {
                 if (confirm('删除操作将不能恢复，是否继续?')) {
                     $.ajax({
                         type: "GET",
                         url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.ACTION_TYPE%>",//GT_id 表示当前操作的类型
                       success: function (data) {
                           if (data == "system") {
                               alert("系统默认不能删除！");
                           } else if (data == "other") {
                               alert("其他原因使得删除失败！");
                           } else if (data == "success") {
                               alert("删除成功！");
                               history.go(0);
                           } else if (data == "error") {
                               alert("删除失败！");
                           } else {
                               if (confirm(data)) {
                                   $.ajax({
                                       type: "GET",
                                       url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.ACTION_TYPE%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                   });
                               }
                           }
                       }
                     });
                 }
             }
         function Edit() {
             window.open('../SysSetting/ActionType.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Add() {
            window.open('../SysSetting/ActionType.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/ActionType.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OPPORTUNITYAGES)
        { %>
         function Delete() {
             //商机阶段
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: '../Tools/GeneralViewAjax.ashx?act=delete_validate&id='+ entityid + '&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.OPPORTUNITY_STAGE%>',//GT_id 表示当前操作的类型
                       success: function (data) {
                           if (data == "system") {
                               alert("系统默认不能删除！");
                           } else if (data == "other") {
                               alert("其他原因使得删除失败！");
                           } else if (data == "success") {
                               alert("删除成功！");
                               history.go(0);
                           } else if (data == "error") {
                               alert("删除失败！");
                           }
                           else {
                               alert(data);
                               history.go(0);
                           }
                       }
                });
            }
         }
         function Edit() {
             window.open('../Opportunity/OpportunityStage.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../Opportunity/OpportunityStage.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../Opportunity/OpportunityStage.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.CONFIGSUBSCRIPTION)
        {%>

         function Add() {
             window.open("../ConfigurationItem/SubscriptionAddOrEdit.aspx?insProId=" + <%=Request.QueryString["id"] %>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SubscriptionEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }

         function Edit() {
             window.open("../ConfigurationItem/SubscriptionAddOrEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SubscriptionEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Update() {

         }
         function Cancel()
         {
             if (confirm("你选择取消此订阅,将导致该订阅的所有未计费项被立即取消,通常在该客户永久注销的前提下操作, 该操作无法恢复确定无论如何都要取消此订阅?")) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=2&sid=" + entityid,
                     async: false,
                     success: function (data) {
                         if (data == "ok") {
                             alert('取消成功');
                             history.go(0);
                         } else if (data == "Already") {
                             alert('已经取消');
                         }
                         else {
                             alert("取消失败");
                         }

                     }
                 })
             }

         }
         function Invalid() {
             if (confirm("你选择注销(搁置)此订阅,,该订阅的计费项将继续计费,该订阅的关联支持服务将被停止,该操作通常发生在客户发生欠费或者该客户的服务被暂停,你确定无法如何都要注销此订阅?")) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=0&sid=" + entityid,
                     async: false,
                     success: function (data) {
                         if (data == "ok") {
                             alert('停用成功');
                             history.go(0);
                         } else if (data == "Already") {
                             alert('已经停用');
                         }
                         else {
                             alert("停用失败");
                         }

                     }
                 })
             }
         }
         function Delete() {
             if (confirm("你选择注销(搁置)此订阅,,该订阅的计费项将继续计费,该订阅的关联支持服务将被停止,该操作通常发生在客户发生欠费或者该客户的服务被暂停,你确定无法如何都要注销此订阅?")) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=0&sid=" + entityid,
                     async: false,
                     success: function (data) {
                         if (data == "ok") {
                             alert('停用成功');
                             history.go(0);
                         } else if (data == "Already") {
                             alert('已经停用');
                         }
                         else {
                             alert("停用失败");
                         }

                     }
                 })
             }
         }

        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractUDF)
        { %>
        function Edit() {
          window.open("../Contract/ContractUdf.aspx?contractId=" + $("#id").val() + "&colName=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SubscriptionEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function View(id) {
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractBlock
        || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractBlockTime
        || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractBlockTicket)
        { %>
        function Edit() {
          window.open("../Contract/EditRetainerPurchase.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConBlockEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=868', false);
        }
        function Add() {
          window.open("../Contract/AddRetainerPurchase.aspx?id=" + $("#id").val(), '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConBlockAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=868', false);
        }
        function SetActive() {

            $.ajax({
              type: "GET",
              url: "../Tools/ContractAjax.ashx?act=SetBlockActive&blockId=" + entityid,
              async: false,
              success: function (data) {
                if (data == "True") {
                  alert("设置成功");
                  history.go(0);
                } else {
                  alert("设置失败！已审批预付不可修改");
                }
              }
            })
        }
        function SetInactive() {

          $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=SetBlockInactive&blockId=" + entityid,
            async: false,
            success: function (data) {
              if (data == "True") {
                alert("设置成功");
                history.go(0);
              } else {
                alert("设置失败！已审批预付不可修改");
              }
            }
          })
        }
        function Delete() {
          if (confirm("预付费用关联了一个合同成本，如果删除，则相关的合同成本也会删除，是否继续?")) {
            $.ajax({
              type: "GET",
              url: "../Tools/ContractAjax.ashx?act=DeleteBlock&blockId=" + entityid,
              async: false,
              success: function (data) {
                alert("删除成功");
                history.go(0);
              }
            })
          }
        }
        function View(id) {
        }
        <%} else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractRate) { %>
        function Edit() {
            window.open("../Contract/RoleRate.aspx?contractId=" + $("#id").val() + "&id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConRateEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Add() {
            window.open("../Contract/RoleRate.aspx?contractId=" + $("#id").val(), '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConRateAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            if (confirm("修改将会影响本合同的未提交工时表，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=DeleteRate&rateId=" + entityid,
                    async: false,
                    success: function (data) {
                      history.go(0);
                    }
                })
            }
        }
        <%} else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractMilestone) { %>
        function Edit() {
            window.open("../Contract/ContractMilestone.aspx?contractId=" + $("#id").val() + "&id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConMilestoneEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Add() {
            window.open("../Contract/ContractMilestone.aspx?contractId=" + $("#id").val(), '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConMilestoneAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            if (confirm("确定要删除此里程碑吗?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=DeleteMilestone&milestoneId=" + entityid,
                    async: false,
                    success: function (data) {
                      if (data == "True") {
                            alert('删除成功');
                            history.go(0);
                        } else {
                            alert("删除失败，已计费状态下不能删除");
                        }
                    }
                })
            }
        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractType)
        { %>//合同类别
            function Delete() {
                if (confirm('删除操作将不能恢复，是否继续?')) {
                    $.ajax({
                        type: "GET",
                        url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.CONTRACT_CATE%>",//GT_id 表示当前操作的类型
                         success: function (data) {
                             if (data== "system") {
                                 alert("系统默认不能删除！");
                             } else if (data == "other") {
                                alert("其他原因使得删除失败！");
                             } else if (data == "success") {
                                 alert("删除成功！");
                                 history.go(0);
                             } else if (data == "error") {
                                 alert("删除失败！");
                             }
                                 else {
                                 if (confirm(data)) {
                                     $.ajax({
                                         type: "GET",
                                         url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.CONTRACT_CATE%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if(data=="error") {
                                               alert("删除失败！");
                                           }
                                       }
                                     });
                                 }
                             }
                         }
                    });
                }
            }
        function Edit() {
            window.open('../SysSetting/ContractType.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/ContractType.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/ContractType.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         <%} 
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.SUFFIXES)
        { %>//姓名后缀
         function Edit() {
             window.open('../SysSetting/Suffixes.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/Suffixes.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/Suffixes.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.NAME_SUFFIX%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         }
                     }
                 });
             }

              <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Line_Of_Business)
        { %>//general表的通用处理（10-17，还未配置查询）
             function Edit() {
                 window.open('../SysSetting/GeneralAdd.aspx?id=' + entityid + '&type=' +<%=queryTypeId%>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.GeneralAddAndEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
             }
             function Add() {
                 window.open('../SysSetting/GeneralAdd.aspx?type=' +<%=queryTypeId%>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.GeneralAddAndEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/GeneralAdd.aspx?id=' + id + 'type=' +<%=queryTypeId%>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.GeneralAddAndEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid,
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid,
                                     success: function (data) {
                                         alert(data);
                                         if (data == "success") {
                                             alert("删除成功！");
                                             history.go(0);
                                         } else if (data == "error") {
                                             alert("删除失败！");
                                         }
                                     }
                                 });
                             }
                         }
                     }
                 });
             }
         }
               <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Quote_Email_Tmpl||queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Invoice_Email_Tmpl)
        { %>//报价和发票的邮件模板（10-17，还未配置查询）
         function Edit() {
             window.open('../SysSetting/QuoteAndInvoiceEmailTempl.aspx?id=' + entityid + '&type=' +<%=queryTypeId%>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EmailTemp %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/QuoteAndInvoiceEmailTempl.aspx?type=' +<%=queryTypeId%>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EmailTemp %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/QuoteAndInvoiceEmailTempl.aspx?id=' + id + 'type=' +<%=queryTypeId%>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EmailTemp %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
        <%}%>
        function openopenopen() {
            alert("暂未实现");
         }

             
    </script>
  <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
  <script type="text/javascript" src="../Scripts/Search/<%=(EMT.DoneNOW.DTO.QueryType)queryTypeId %>.js"></script>
    <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_MY_TICKET || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_VIEW||catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_VIEW)
        { %>
    <script type="text/javascript" src="../Scripts/Search/my_queue_active.js"></script>
    <%} %>
</body>
</html>
