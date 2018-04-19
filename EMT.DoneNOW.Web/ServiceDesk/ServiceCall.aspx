<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ServiceCall.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.ServiceCall" %>

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
        #pnlTab_1 td {
            text-align: left;
        }

        #pnlTab_2 td {
            text-align: left;
        }

        .FieldLabel, .workspace .FieldLabel, TABLE.FieldLabel TD, span.fieldlabel span label {
            font-size: 12px;
            color: #4F4F4F;
            margin-left: 15px;
        }

        .errorSmallClass, .errorsmallClass {
            font-size: 12px;
            color: #f00;
            margin-left: 3px;
        }

        label {
            font-weight: 500;
        }

        .content label {
            width: 200px;
            text-align: left;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="SerivceCallId" name="SerivceCallId" value="<%=thisCall!=null?thisCall.id.ToString():"" %>" />
        <input type="hidden" id="SaveType" name="SaveType" value=">" />
        <input type="hidden" id="AppTicketIds" name="AppTicketIds" />
        <input type="hidden" id="AppTicketIdsHidden" name="AppTicketIdsHidden" />
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
                    <asp:Button ID="work_book" runat="server" Text="生成工作说明书" OnClick="work_book_Click" />
                </li>
                <%} %>
                <li id="Close">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <input type="button" id="CloseButton" value="取消" />
                </li>
            </ul>
        </div>
        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="">常规</li>
                <li id="">通知</li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 132px;">
            <div class="content clear">
                <div style="height: 100%; width: 100%;">
                    <div id="pnlTab_1" style="height: 100%; width: 100%; display: block;">
                        <div id="generalTab" style="position: static;">
                            <div class="Tab" id="GeneralDiv" style="width: 100%; overflow: auto;">
                                <table class="searchpanel" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse; margin-top: 15px; margin-bottom: 10px;">
                                    <tbody>
                                        <tr valign="top">
                                            <td>
                                                <div style="padding-left: 10px;">
                                                    <table class="tableTransparent" cellspacing="0" cellpadding="0" align="Center" border="0" style="border-collapse: collapse;">
                                                        <tbody>
                                                            <tr>
                                                                <td style="width: 287px;"><span class="FieldLabel" style="font-weight: bold;">客户名称</span><span class="errorSmallClass" style="font-weight: bold;">*</span></td>
                                                                <td style="width: 179px;"><span class="FieldLabel" style="font-weight: bold; margin-left: 0px;">客户地址</span></td>
                                                                <td style="width: 419px;"></td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="top">
                                                                    <div class="WrapField">
                                                                        <span id="accountPicker" style="display: inline-block;">
                                                                            <input name="" type="text" id="accountId" class="txtBlack8Class" style="width: 200px;" value="<%=thisAccount==null?"":thisAccount.name %>" />
                                                                            &nbsp;<span style="display: none;">
                                                                                <input name="account_id" type="hidden" id="accountIdHidden" value="<%=thisAccount==null?"":thisAccount.id.ToString() %>" />

                                                                            </span>
                                                                            <img id="accountPicker_img" src="../Images/data-selector.png" border="0" style="cursor: pointer; width: 19px; height: 20px; display: inline-block;" onclick="CallBackAccount()" />&nbsp;
                                                                        </span>
                                                                    </div>
                                                                </td>
                                                                <td><span class="lblNormalClass" style="font-weight: normal;" id="AccountAddress"></span></td>
                                                                <td align="left" valign="top"></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="padding-left: 10px;">
                                                    <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                        <tbody>
                                                            <tr>
                                                                <td style="width: 200px;"><span class="FieldLabel" style="font-weight: bold;">开始时间</span><span class="errorSmallClass" style="font-weight: bold;">*</span></td>
                                                                <td style="width: 190px;"><span class="FieldLabel" style="font-weight: bold;">结束时间</span><span class="errorSmallClass" style="font-weight: bold;">*</span></td>
                                                                <td style="width: 200px;"><span class="FieldLabel" style="font-weight: bold;"></span><span class="errorSmallClass" style="font-weight: bold;"></span></td>
                                                                <td style="width: 190px;"><span class="FieldLabel" style="font-weight: bold;"></span><span class="errorSmallClass" style="font-weight: bold;"></span></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <div class="WrapField">
                                                                        <span>
                                                                            <input name="startTime" type="text" id="startTime" class="txtBlack8Class" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" value="<%=isAdd ? (DateTime.Now.ToString("yyyy-MM-dd")+" 08:00:00"):EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisCall.start_time).ToString("yyyy-MM-dd HH:mm:ss") %>" />
                                                                        </span>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="WrapField">
                                                                        <span id="tStartTime">
                                                                            <input name="endTime" type="text" value="<%=isAdd ? (DateTime.Now.ToString("yyyy-MM-dd")+" 09:00:00"):EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisCall.end_time).ToString("yyyy-MM-dd HH:mm:ss") %>" id="endTime" class="txtBlack8Class" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" />&nbsp;
                                                                        </span>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="WrapField">
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="WrapField">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="4"><span class="FieldLabel" style="font-weight: bold;">描述</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="4" style="width: 570px;">
                                                                    <div class="WrapField">
                                                                        <span id="descriptionSpan" style="display: inline-block;">
                                                                            <textarea name="description" id="description" class="txtBlack8Class" maxlength="2000" style="height: 42px; width: 570px;"><%=thisCall!=null?thisCall.description:"" %></textarea></span>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="4"><span class="FieldLabel" style="font-weight: bold;">状态</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="top" colspan="4">
                                                                    <span id="Status">
                                                                        <select name="status_id" id="status_id" class="txtBlack8Class">
                                                                            <% if (statusList != null && statusList.Count > 0)
                                                                                {
                                                                                    foreach (var status in statusList)
                                                                                    { %>
                                                                            <option value="<%=status.id %>" <%if (thisCall != null && thisCall.status_id == status.id)
                                                                                { %> selected="selected" <%} %>><%=status.name %></option>
                                                                            <%}
                                                                                } %>
                                                                        </select>
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table cellspacing="0" cellpadding="0" border="0" style="width: 100%; border-collapse: collapse;">
                                </table>
                            </div>

                            <div class="header" style="left: 0; overflow-x: auto; overflow-y: hidden; position: fixed; right: 0; bottom: 0; top: 450px;">条目</div>
                            <input type="hidden" id="ChooseIds" name="ChooseIds" />
                            <div style="left: 0; overflow-x: auto; overflow-y: hidden; position: fixed; right: 0; bottom: 0; top: 490px; height: auto;">
                                <iframe src="" style="width: 100%; height: 100%;" id="TicketSearch"></iframe>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            <div class="content clear" style="display: none;">
                <input type="hidden" id="notifyConIds" name="notifyConIds" />
                <input type="hidden" id="notifyResIds" name="notifyResIds" />
                <div id="pnlTab_2" style="height: 100%; width: 100%;">
                    <div id="notificationTab" style="position: static;">
                        <div class="Tab" id="NotificationDiv" style="width: 100%; overflow: auto;">
                            <div id="ServiceControlNotification_mainPanel">
                                <table id="ServiceControlNotification_notificationCheckboxTable" cellspacing="0" cellpadding="10" border="0" style="border-collapse: collapse; max-width: 500px;">
                                    <tbody>
                                        <tr>
                                            <td class="checkboxPadding"><span><span class="txtBlack8Class">
                                                <input id="ckAccMan" type="checkbox" name="ckAccMan" style="vertical-align: middle;" /><label style="vertical-align: middle;">客户经理</label></span></span></td>
                                            <td class="checkboxPadding"><span id=""><span class="txtBlack8Class">
                                                <input id="ckCreater" type="checkbox" name="ckCreater" style="vertical-align: middle;" /><label style="vertical-align: middle;">服务预定创建人</label></span></span></td>
                                        </tr>
                                        <tr>
                                            <td class="checkboxPadding"><span><span class="txtBlack8Class">
                                                <input id="CkCCMe" type="checkbox" name="CkCCMe" style="vertical-align: middle;" /><label style="vertical-align: middle;">抄送给我</label></span></span></td>
                                            <td class="checkboxPadding"><span><span class="txtBlack8Class">
                                                <input id="ckTicketCon" type="checkbox" name="ckTicketCon" style="vertical-align: middle;" /><label style="vertical-align: middle;">工单联系人</label></span></span></td>
                                        </tr>
                                        <tr>
                                            <td class="checkboxPadding"><span><span class="txtBlack8Class">
                                                <input id="ckPriRes" type="checkbox" name="ckPriRes" style="vertical-align: middle;" /><label style="vertical-align: middle;">工单主负责人</label></span></span></td>
                                            <td class="checkboxPadding"><span><span class="txtBlack8Class">
                                                <input id="ckOtherRes" type="checkbox" name="ckOtherRes" style="vertical-align: middle;" /><label style="vertical-align: middle;">工单其他负责人</label></span></span></td>
                                        </tr>
                                        <tr>
                                            <td class="checkboxPadding"><span><span class="txtBlack8Class">
                                                <input id="ckChangeApp" type="checkbox" name="ckChangeApp" style="vertical-align: middle;" /><label style="vertical-align: middle;">变更审批人</label></span></span></td>
                                            <td class="checkboxPadding" colspan="2"><span><span class="txtBlack8Class">
                                                <input id="ckSendFromSys" type="checkbox" name="ckSendFromSys" style="vertical-align: middle;" /><label style="vertical-align: middle;">从系统邮箱发送</label></span></span></td>
                                        </tr>
                                        <tr valign="top">
                                            <td style="padding-left: 10px;">
                                                <table style="width: 100%;" cellspacing="0" cellpadding="0">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <span class="lblNormalClass" style="font-weight: bold;">联系人</span>
                                                                <span class="txtBlack8Class">(<a href="#" id="" onclick="GetConByAccount()">加载</a>)</span>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <div class="InnerGrid" style="background-color: White; height: 180px; border: 1px solid #D7D7D7; margin-bottom: 10px;">
                                                    <span id="" style="display: inline-block; height: 112px; width: 382px;">
                                                        <div id="" class="GridContainer">

                                                            <div id="" style="height: 154px; width: 100%; overflow: auto; z-index: 0;">
                                                                <div class='grid' style='overflow: auto; height: 147px;'>
                                                                    <table width='100%' border='0' cellspacing='0' cellpadding='3'>
                                                                        <thead>
                                                                            <tr>
                                                                                <td width='1%'></td>
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
                                                    </span>
                                                </div>
                                            </td>
                                            <td id="ServiceControlNotification_employeeCell" style="padding-left: 10px;">
                                                <table style="width: 100%;" cellspacing="0" cellpadding="0">
                                                    <tbody>
                                                        <tr>
                                                            <td nowrap="">
                                                                <span id="ServiceControlNotification_employeesLabel" class="lblNormalClass" style="font-weight: bold;">员工</span>
                                                                <span class="txtBlack8Class">(<a href="#" id="" onclick="LoadRes()">加载</a>)</span>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <div class="InnerGrid" style="background-color: White; height: 180px; margin-right: -11px;">
                                                    <span id="ctrlNotification_dgEmployees" style="display: inline-block; height: 112px; width: 382px;"><span></span>
                                                        <div id="reshtml" style="width: 350px; height: 150px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                                                        </div>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="padding-left: 10px;">
                                                <table cellspacing="0" cellpadding="0" width="100%" style="padding-top: 3px;" class="PaddingBottomForTd">
                                                    <tbody>
                                                        <tr id="" style="padding-top: 8px;">
                                                            <td style="width: 80px;">
                                                                <span id="" class="lblNormalClass" style="font-weight: bold; display: block; padding-right: 6px; white-space: nowrap;">其他邮件地址</span>
                                                            </td>
                                                            <td>
                                                                <span id="" class="stretchTextBox" style="display: inline-block;">
                                                                    <input name="notifyOthers" type="text" id="notifyOthers" class="txtBlack8Class" style="width: 523px;" /></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 80px;">
                                                                <span class="lblNormalClass" style="font-weight: bold; display: block; padding-right: 6px; white-space: nowrap;">模板</span>
                                                            </td>
                                                            <td>
                                                                <span id="" style="display: inline-block;">
                                                                    <select name="notifyTempId" id="notifyTempId" class="txtBlack8Class" style="width: 524px;">
                                                                        <%if (tempList != null && tempList.Count > 0)
                                                                            {
                                                                                foreach (var temp in tempList)
                                                                                {  %>
                                                                        <option value="<%=temp.id %>"><%=temp.name %></option>
                                                                        <%
                                                                                }
                                                                            } %>
                                                                    </select>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 80px;">
                                                                <span class="lblNormalClass" style="font-weight: bold; display: block; padding-right: 6px;">主题</span>
                                                            </td>
                                                            <td>
                                                                <span class="stretchTextBox" style="display: inline-block;">
                                                                    <input name="notifyTitle" type="text" value="" id="notifyTitle" class="txtBlack8Class" style="width: 523px;" /></span>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td style="width: 80px; vertical-align: top;">
                                                                <span class="lblNormalClass" style="font-weight: bold; display: block; padding-right: 6px;">其他<br />
                                                                    邮件文本</span>
                                                            </td>
                                                            <td style="padding-bottom: 0px; vertical-align: top;">
                                                                <span id="" class="stretchTextArea" style="display: inline-block;">
                                                                    <textarea name="notifyAppText" id="notifyAppText" class="txtBlack8Class" rows="3" style="width: 523px;"></textarea></span>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <table id="ServiceControlNotification_notificationHeader" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse; padding-right: 0px; padding-left: 0px; padding-bottom: 0px; margin-bottom: 5px; margin-top: 5px; width: 100%; padding-top: 0px;">
                                                    <tbody>
                                                        <tr>
                                                            <td id="ServiceControlNotification_editNotifyDefaultSettingLinkCell" valign="top" colspan="2" style="text-align: left; padding-top: 10px; padding-bottom: 10px;">
                                                                <span style="text-align: left; padding-left: 520px;"><a href="#" id="" class="txtBlack8Class">Edit Default Settings</a></span>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="../Scripts/common.js"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/NewContact.js"></script>
<script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $(function () {
        <%if (isAdd)
    { %>
        GetTicketByAccountId();
        <%}%>
    <%if (thisAccount != null)
    { %>
        GetDataByAccount();
        <% }%>

        <%if (isCop)
    { %>
        $("#status_id").val("<%=(int)EMT.DoneNOW.DTO.DicEnum.SERVICE_CALL_STATUS.NEW %>");
        <%} %>
    })
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
    function GetConByAccount() {
        var html = "";
        var accountIdHidden = $("#accountIdHidden").val();
        if (accountIdHidden != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContactAjax.ashx?act=GetContacts&account_id=" + accountIdHidden,
                success: function (data) {
                    if (data != "") {
                        html = data;
                    }
                },
            });
        }
        $("#conhtml").html(html);
    }
    $("#notifyTempId").change(function () {
        var thisTempId = $(this).val();
        if (thisTempId != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/GeneralAjax.ashx?act=GetNotiTempEmail&temp_id=" + thisTempId,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.subject != "" && data.subject != null && data.subject != undefined) {
                            $("#notifyTitle").val(data.subject);
                        }
                    }
                },
            });
        }
    })
    function GetConIds() {
        var ids = "";
        $(".checkCon").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ','
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#notifyConIds").val(ids);
    }

    function GetResIds() {
        var ids = "";
        $(".checkRes").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ',';
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#notifyResIds").val(ids);
    }

    function GetTicketByAccountId() {
        var serviceId = $("#SerivceCallId").val();
        var url = "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALL_TICKET %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.SERVICE_CALL_TICKET %>&isCheck=1";
        if (serviceId != "") {
            url += "&con2127=" + serviceId;
        }
        else {
            url += "&show=1";
            var accountId = $("#accountIdHidden").val();
            if (accountId != "") {
                url += "&con2681=" + accountId;
            } else {
            <%if (isAdd)
    { %>
                $("#TicketSearch").attr("src", "");
                return;
            <% }%>
            }
        }


        $("#TicketSearch").attr("src", url);

    }

    function CallBackAccount() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=accountId&callBack=GetDataByAccount", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByAccount() {
        // 获取客户地址
        // 填充联系人下拉框
        var accountId = $("#accountIdHidden").val();
        if (accountId != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=GetAccDetail&account_id=" + accountId,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        var AddHtml = "";
                        if (data.address1 != "") {
                            AddHtml += data.address1 + "<br />";
                        }
                        if (data.provice != "" || data.city != "" || data.postalCode != "") {
                            if (data.provice != "") {
                                AddHtml += data.provice + " ";
                            }
                            if (data.city != "") {
                                AddHtml += data.city + " ";
                            }
                            if (data.postalCode != "" && data.postalCode != null) {
                                AddHtml += data.postalCode + " ";
                            }
                            AddHtml += "<br />";
                        }
                        $("#AccountAddress").html(AddHtml);
                    }
                },
            });


        } else {
            $("#accountAddress").html("");
        }


        GetTicketByAccountId();
    }

    // 查找带回工单 - 带回的工单关联 服务预定
    function ApplyChooseTicket() {
        var SerivceCallId = $("#SerivceCallId").val();
        //if (SerivceCallId == "") {
        //    LayerMsg("请先保存当前服务预定！");
        //    return;
        //}

        //  SerivceCallId 服务预定Id
        var accountIdHidden = $("#accountIdHidden").val();
        if (accountIdHidden == "") {
            LayerMsg("请通过查找带回选择客户");
            return;
        }
        var startTime = $("#startTime").val();
        if (startTime == "") {
            LayerMsg("请填写开始时间");
            return;
        }
        var endTime = $("#endTime").val();
        if (endTime == "") {
            LayerMsg("请填写结束时间");
            return;
        }
        var status_id = $("#status_id").val();
        if (status_id == "") {
            LayerMsg("请选择状态");
            return;
        }
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALL_TICKET %>&field=AppTicketIds&callBack=GetDataByChooseIds&con2127=" + SerivceCallId + "&con2700=2&muilt=1", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);

    }

    function GetDataByChooseIds() {
        var SerivceCallId = $("#SerivceCallId").val();
        var AppTicketIds = $("#AppTicketIdsHidden").val();
        if (AppTicketIds != "") {
                <%if (isAdd)
    { %>
            LayerConfirm("关联选择的工单/任务将会保存服务预定，是否继续？", "是", "否", function () {
                if (SubmitCheck()) {
                    $("#form1").submit();
                }

            }, );
                <%}
    else
    { %>
                if (SubmitCheck()) {
                    $("#form1").submit();
                }
                <%} %>


        }

    }

    $("#save_close").click(function () {
        $("#SaveType").val("save_close");
        return SubmitCheck();
    })
    $("#save_new").click(function () {
        $("#SaveType").val("save_new");
        return SubmitCheck();
    })
    $("#work_book").click(function () {
        $("#SaveType").val("work_book");
        return SubmitCheck();
    })

    function SubmitCheck() {
        var iframe2 = $("#TicketSearch")[0];
        var ids = iframe2.contentWindow.GetCkIds();
        $("#ChooseIds").val(ids);
        var accountIdHidden = $("#accountIdHidden").val();
        if (accountIdHidden == "") {
            LayerMsg("请通过查找带回选择客户");
            return false;
        }
        var startTime = $("#startTime").val();
        if (startTime == "") {
            LayerMsg("请填写开始时间");
            return false;
        }
        var endTime = $("#endTime").val();
        if (endTime == "") {
            LayerMsg("请填写结束时间");
            return false;
        }
        var status_id = $("#status_id").val();
        if (status_id == "") {
            LayerMsg("请选择状态");
            return false;
        }
        var ChooseIds = $("#ChooseIds").val();
        var AppTicketIds = $("#AppTicketIdsHidden").val();
        if (ChooseIds == "" && AppTicketIds == "") {
            LayerConfirm("当前服务预定无关联工单，在调度工作室中，选中“显示无负责人的服务预定”，才能看到该服务预定信息，是否继续？", "是", "否", function () {
                $("#form1").submit();
            }, function () { });
            return false;
        }
        if (AppTicketIds != "") {
            ChooseIds = "," + AppTicketIds;
        }
        var ChooseIdsArr = ChooseIds.split(',');
        if (ChooseIdsArr.length > 1) {
            LayerConfirm("当前服务预定选择了多个工单/任务，这些工单/任务的待调度时间将会置为空，是否继续？", "是", "否", function () {
                $("#form1").submit();
            }, function () { });
            return false;
        }
        if (!CheckTickRes()) {
            return false;
        }

        return true;
    }
    // 对工单负责人进行校验
    function CheckTickRes() {
        var ChooseIds = $("#ChooseIds").val();
        var AppTicketIds = $("#AppTicketIdsHidden").val();
        if (ChooseIds == "") {
            ChooseIds = AppTicketIds;
        }
        else {
            if (AppTicketIds != "") {
                ChooseIds += "," + AppTicketIds;
            }
        }
        var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();
        var result = "";
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=CheckTicketResTime&ids=" + ChooseIds + "&start=" + startTime + "&end=" + endTime,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.hasRes) {
                        if (data.resList.length != undefind && data.resList.length > 1) {
                            var resName = "";
                            for (var i = 0; i < data.resList.length; i++) {
                                resName += data.resList[i].name + ',';
                            }
                            if (resName != "") {
                                result = "1";
                                LayerConfirm("以下负责人在同时段有其他任务：" + resName + "是否继续？", "是", "否", function () {
                                    $("#form1").submit();
                                }, function () { });
                            }
                        }
                    }
                    else {
                        LayerConfirm("当前服务预定无负责人，在调度工作室中，选中“显示无负责人的服务预定”，才能看到该服务预定信息，是否继续？", "是", "否", function () {
                            $("#form1").submit();
                        }, function () { });
                        result = "1";
                    }
                }
            },
        });
        if (result != "") {
            return false;
        }
        else {
            return true;
        }
    }
    $("#Close").click(function () {
        window.close();
    })

    function CheckTicket() {
        var ticketIds = '<%=ticketIds %>';
        if (ticketIds != "") {
            // window.frames['TicketSearch'].CheckPageTicket(ticketIds)
            var iframe2 = $("#TicketSearch")[0];
            iframe2.contentWindow.CheckPageTicket(ticketIds);
        }
    } 
</script>
