<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WorkEntry.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.WorkEntry" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style>
        .FieldLabels, .workspace .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }

        .DivSection .FieldLabels div, .DivSection td[class="fieldLabels"] div, .DivSectionWithHeader td[class="fieldLabels"] div {
            margin-top: 1px;
            padding-bottom: 21px;
            font-weight: 100;
        }

        .DivSection {
            border: 1px solid #d3d3d3;
            margin: 0 10px 10px 10px;
            padding: 12px 28px 4px 28px;
        }

        .searchareaborder td {
            text-align: left;
        }

        #errorSmall {
            color: red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增":"修改" %>工时</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>

                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    关闭</li>
            </ul>
        </div>
        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="general">常规信息</li>
                <li id="accountUDF">通知</li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 145px;">
            <div class="DivSection" style="margin-left: 0px; margin-right: 0px; width: 1080px; border: 1px solid #d3d3d3; margin: 0px 0px 22px 44px;">
                <table class="searchareaborder" width="100%" border="0" cellspacing="0" cellpadding="0" id="Table3">
                    <tbody>
                        <tr>
                            <td colspan="2">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tbody>
                                        <tr>
                                            <td align="right" class="FieldLabels" style="width: 10%; text-align: left; padding-left: 15px;">员工<span id="errorSmall">*</span>
                                                <div>
                                                    <asp:DropDownList ID="resource_id" runat="server" Width="300px"></asp:DropDownList>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels" width="200px" style="padding-left: 15px; text-align: left;">显示
				<div>
                    <select name="ShowTaskType" tabindex="2" id="ShowTaskType" size="1" style="width: 164px;">
                        <option value="showMe">我的任务</option>
                        <option value="showMeDep">我的任务和部门任务</option>
                        <option value="all">所有任务</option>

                    </select>
                </div>
                            </td>
                            <td align="left" style="vertical-align: middle; padding-bottom: 3px; text-align: center;">
                                <input type="checkbox" tabindex="3" id="chkShowCompletedTasks" style="margin: 0 3px 0 -500px;" />显示完成的任务
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="DivSection" style="margin-left: 0px; margin-right: 0px; width: 1080px; border: 1px solid #d3d3d3; margin: 0px 0px 22px 44px;">
                <table class="searchareaborder" width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td class="FieldLabels" width="398px">客户名称<span id="errorSmall">*</span>
                                <div>
                                    <select name="account_id" size="1" style="width: 300px;" id="account_id" tabindex="4">
                                    </select>
                                </div>
                            </td>
                            <td rowspan="6" valign="bottom" style="padding-left: 20px; padding-bottom: 19px;">
                                <div id="tblStartStop" name="tblStartStop" style="position: relative; visibility: visible; display: block; background-color: rgb(240, 245, 251); border: 1px solid rgb(211, 211, 211); padding: 20px; width: 330px;">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td width="200px" class="FieldLabels" style="white-space: nowrap;">开始时间
							<div>
                                <input type="text" size="8" name="startTime" id="startTime" onclick="WdatePicker({ dateFmt: 'HH:mm' })"  value="<%=thisWorkEntry!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisWorkEntry.start_time).ToString("HH:mm"):DateTime.Now.ToString("HH:mm") %>"/>&nbsp;<img src="../Images/time.png" border="0" style="vertical-align: middle; margin-bottom: 2px;" />
                            </div>
                                                </td>
                                                <td class="FieldLabels" style="white-space: nowrap;">工作时长
							<div>
                                <input style="text-align: right; color: #6d6d6d;" type="text" name="hours_worked" id="hours_worked" disabled="disabled" value="<%=thisWorkEntry!=null&&thisWorkEntry.hours_worked!=null?((long)thisWorkEntry.hours_worked).ToString("#0.00"):"0.00" %>"/>
                            </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" style="white-space: nowrap;">结束时间
							<div>
                                <input type="text" name="endTime" id="endTime" size="8" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=thisWorkEntry!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisWorkEntry.end_time).ToString("HH:mm"):DateTime.Now.ToString("HH:mm") %>"/>&nbsp;<img src="../Images/time.png" border="0" style="vertical-align: middle; margin-bottom: 2px;" />
                            </div>
                                                </td>
                                                <td class="FieldLabels" style="white-space: nowrap;">偏移量
							<div>
                                <input style="text-align: right;" type="text" name="offset_hours" id="offset_hours" value="<%=thisWorkEntry==null?"0.00":thisWorkEntry.offset_hours.ToString("#0.00") %>" class="decimal2" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                            </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels">日期
							<div>
                                <input type="text" value="<%=thisWorkEntry!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisWorkEntry.start_time).ToString("yyyy-MM-dd"):DateTime.Now.ToString("yyyy-MM-dd") %>" name="tmeDate" id="tmeDate" style="color: #6d6d6d; width: 78px;" onclick="WdatePicker()" />
                            </div>
                                                </td>
                                                <td class="FieldLabels">计费时长
							<div>
                                <input style="text-align: right; color: #6d6d6d;" type="text" name="hours_billed" id="hours_billed" disabled="disabled" value="<%=thisWorkEntry!=null&&thisWorkEntry.hours_billed!=null?((long)thisWorkEntry.hours_billed).ToString("#0.00"):"0.00" %>" />
                            </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" style="padding-right: 5px; vertical-align: middle; padding-bottom: 19px;">剩余时间
							<span id="errorSmall">*</span>
                                                </td>
                                                <td class="FieldLabels" style="vertical-align: middle;">
                                                    <div>
                                                        <input style="text-align: right;" type="text" name="remain_hours" id="remain_hours" class="decimal2" value="<%=v_task!=null&&v_task.remain_hours!=null?((decimal)v_task.remain_hours).ToString("#0.00"):"0.00" %>" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td name="offsetStartStopRow" class="FieldLabels" style="visibility: visible; padding-right: 5px;">估算差异: 
                                                </td>
                                                <td name="offsetStartStopRow" class="FieldLabels" id="startStopEstimatedHoursOffsetDisplay" style="visibility: visible; font-weight: normal; color: rgb(51, 51, 51); text-align: right; padding-right: 8px;"><%
                                                                                                                                                                                                                                                                 if (v_task != null)
                                                                                                                                                                                                                                                                 {
                                                                                                                                                                                                                                                                     var esHours = v_task.remain_hours == null ? 0 : (decimal)v_task.remain_hours + v_task.worked_hours == null ? 0 : (decimal)v_task.worked_hours - v_task.change_Order_Hours == null ? 0 : (decimal)v_task.change_Order_Hours - v_task.estimated_hours == null ? 0 : (decimal)v_task.estimated_hours;
                                                %><%=esHours.ToString("#0.00") %><%                                                                                                                                                                                                                                            }


                                                %></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">项目名称<span id="errorSmall">*</span>
                                <div>
                                    <select name="project_id" tabindex="5" style="width: 300px;" id="project_id">
                                        <option value=""></option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">任务标题<span id="errorSmall">*</span>
                                <div>
                                    <select name="task_id" style="width: 300px;" id="task_id">
                                        <option value=""></option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="398px" border="0" cellspacing="0" cellpadding="0">
                                    <tbody>
                                        <tr>

                                            <td class="FieldLabels" nowrap="" width="200px">合同
					<div nowrap="">
                        <input type="text" id="contract_id" tabindex="7" style="width: 150px;" value="<%=thisContract==null?"":thisContract.name %>" readonly="">
                        <input type="hidden" name="contract_id" id="contract_idHidden" value="<%=thisContract==null?"":thisContract.id.ToString() %>" />
                        <a title="Contract Search" onclick="ChooseContract()">
                            <img tabindex="8" src="../Images/data-selector.png" border="0" style="vertical-align: middle"></a>

                    </div>
                                            </td>

                                            <td class="FieldLabels">服务/服务包<div>
                                                <select id="service_id" tabindex="9" name="service_id" style="width: 100%;" disabled="disabled">
                                                </select>
                                            </div>
                                            </td>

                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="398px" cellpadding="0" cellspacing="0" border="0">
                                    <tbody>
                                        <tr>

                                            <td class="FieldLabels" width="200px">工作类型<span id="errorSmall">*</span>
                                                <div>
                                                    <asp:DropDownList ID="cost_code_id" runat="server" Width="164px">
                                                        <asp:ListItem Value="" Text=""></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </td>

                                            <td valign="middle" style="padding-bottom: 3px">
                                                <asp:CheckBox ID="isBilled" runat="server" Checked="false" />不计费
                                            </td>

                                            <td valign="middle" style="padding-bottom: 3px">
                                                <asp:CheckBox ID="ShowOnInv" runat="server" Checked="true" />显示在发票上
                                            </td>

                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="398px" cellpadding="0" cellspacing="0" border="0">
                                    <tbody>
                                        <tr>
                                            <td class="FieldLabels" width="200px">角色名称<span id="errorSmall">*</span>
                                                <div>
                                                    <select name="role_id" id="role_id" style="width: 164px">
                                                    </select>
                                                </div>
                                            </td>
                                            <!--draw status-->
                                            <td class="FieldLabels">状态
				<div>
                    <asp:DropDownList ID="status_id" runat="server"></asp:DropDownList>
                </div>

                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>
            <div class="DivSection" style="margin-left: 0px; margin-right: 0px; width: 1080px; border: 1px solid #d3d3d3; margin: 0px 0px 22px 44px;" id="tblTextFields" name="tblTextFields">



                <table class="searchareaborder" width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td valign="top" align="center">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0" id="Table6">
                                    <tbody>
                                        <tr>
                                            <td width="50%" class="FieldLabels">工时说明&nbsp;<span id="sumNotes1" class="FieldLabels"></span><span id="errorSmall">*</span></td>
                                            <td width="50%" style="text-align: right"><span title="Click to Expand" style="cursor: pointer;" onclick="javaScript:objPage.ViewAll('workSummary1','Summary Notes');">
                                                <img style="vertical-align: middle;" src="../Images/zoom-in.png?v=41154"></span></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="FieldLabels">
                                                <div>
                                                    <textarea name="workSummary1" tabindex="19" isrequired="1" maxlength="20000" istext="1" validationcaption="Summary notes" rows="9" style="width: 98%" id="workSummary1"><%=thisWorkEntry!=null?thisWorkEntry.summary_notes:"" %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="50%" class="FieldLabels">内部说明&nbsp;<span id="intNotes1"></span></td>
                                            <td width="50%" style="text-align: right"><span title="Click to Expand" style="cursor: pointer;" onclick="javaScript:objPage.ViewAll('workNotes1','Internal Notes');">
                                                <img style="vertical-align: middle;" src="/graphics/icons/content/zoom-in.png?v=41154"></span></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="FieldLabels">
                                                <div>
                                                    <textarea name="workNotes1" istext="1" tabindex="20" maxlength="20000" rows="6" style="width: 98%;" id="workNotes1"><%=thisWorkEntry==null?"":thisWorkEntry.internal_notes %></textarea>
                                                </div>
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
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>

    $(function () {
        debugger;
        GetCompanyList();
     <%if (thisProjetc != null)
    { %>
        var isHasAcc = $("#account_id option[value='<%=thisProjetc.account_id %>']").val();
        if (isHasAcc == undefined) {
            <% if (thisAccount != null)
    {%>
            $("#account_id").append("<option value='<%=thisAccount.id.ToString() %>'><%=thisAccount.name %></option>");
            <%}%>
        }

        //alert($("#account_id option[value=''").val());
        $("#account_id").val(<%=thisProjetc.account_id %>);
        GetProByAccount();
        var isHasPro = $("#project_id option[value='<%=thisProjetc.id %>']").val();
        if (isHasPro == undefined) {
            <% if (thisProjetc != null)
    {%>
            $("#project_id").append("<option value='<%=thisProjetc.id.ToString() %>'><%=thisProjetc.name %></option>");
            <%}%>
        }

        $("#project_id").val(<%=thisProjetc.id %>);
        GetTaskByProject();
          <%if (thisTask != null)
    {%>
        var isHasTas = $("#task_id option[value='<%=thisTask.id %>']").val();
        if (isHasTas == undefined) {

            $("#task_id").append("<option value='<%=thisTask.id.ToString() %>'><%=thisTask.title %></option>");

        }

        $("#task_id").val(<%=thisTask.id %>);
        <%}%>

     <%}%>
        GetRoleByRes();

       <% if (!isAdd)
    {
        if (thisWorkEntry.role_id != null) { 
        %>
        $("#role_id").val(<%=thisWorkEntry.role_id %>);
        <%}
        if (thisWorkEntry.service_id != null)
        {%>
        GetServiceByContractID();
        $("#service_id").val(<%=thisWorkEntry.service_id %>);
        <%}
    }%>
    })

    $("#resource_id").change(function () {
        GetRoleByRes();
        GetCompanyList();
    })

    $("#ShowTaskType").change(function () {
        GetCompanyList();
    })
    $("#chkShowCompletedTasks").click(function () {
        GetCompanyList();
    })
    // 根据选择的权限查找相应的客户信息
    function GetCompanyList() {
        debugger;
        // GetAccByRes
        var resId = $("#resource_id").val();
        var showType = $("#ShowTaskType").val();
        var isShowCom = $("#chkShowCompletedTasks").is(":checked");
        if (resId != null && resId != "" && resId != "0") {
            var url = "../Tools/CompanyAjax.ashx?act=GetAccByRes&resource_id=" + resId + "&showType=" + showType;
            if (isShowCom == "true") {
                url = url + "&isShowCom=1";
            }
            var accSelect = "<option value=''> </option>";
            $.ajax({
                type: "GET",
                url: url,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        debugger;
                        // var obj = JSON.parse(data);
                        for (var i = 0; i < data.length; i++) {
                            accSelect += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
            $("#account_id").html(accSelect);
        }

        GetProByAccount();
    }

    $("#account_id").change(function () {
        GetProByAccount();
    })
    // 根据客户获取对应项目
    function GetProByAccount() {
        var account_id = $("#account_id").val();
        var proSelectHtml = "<option value=''> </option>";
        if (account_id != "" && account_id != "0") {
            var resId = $("#resource_id").val();
            var showType = $("#ShowTaskType").val();
            var isShowCom = $("#chkShowCompletedTasks").is(":checked");
            var url = "../Tools/ProjectAjax.ashx?act=GetProByRes&resource_id=" + resId + "&showType=" + showType + "&account_id=" + account_id;
            if (isShowCom == "true") {
                url = url + "&isShowCom=1";
            }
            $.ajax({
                type: "GET",
                url: url,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            proSelectHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
        }
        $("#project_id").html(proSelectHtml);
        GetTaskByProject();
    }

    $("#project_id").change(function () {
        GetTaskByProject();
        ChooseContractByProject();
    })
    // 根据项目获取相应任务
    function GetTaskByProject() {
        var project_id = $("#project_id").val();
        var taskSelectHtml = "<option value=''> </option>";
        if (project_id != "" && project_id != "0") {
            var resId = $("#resource_id").val();
            var showType = $("#ShowTaskType").val();
            var isShowCom = $("#chkShowCompletedTasks").is(":checked");
            var url = "../Tools/ProjectAjax.ashx?act=GetTaskByRes&resource_id=" + resId + "&showType=" + showType + "&project_id=" + project_id;
            if (isShowCom == "true") {
                url = url + "&isShowCom=1";
            }
            $.ajax({
                type: "GET",
                url: url,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            taskSelectHtml += "<option value='" + data[i].id + "'>" + data[i].title + "</option>";
                        }
                    }
                }
            })
        }
        $("#task_id").html(taskSelectHtml);
    }
    // 合同的查找带回
    function ChooseContract() {
        // contract_idHidden
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACTMANAGE_CALLBACK %>&con626=1&field=contract_id&callBack=GetServiceByContractID";
        var account_id = $("#account_id").val();
        if (account_id != "" && account_id != "0") {
            url += "&con627=" + account_id;
        }
        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 通过项目关联合同信息
    function ChooseContractByProject() {
        var project_id = $("#project_id").val();
        if (project_id != "" && project_id != "0") {
            var contract_id = "";
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=GetSinProject&project_id=" + project_id,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        contract_id = data.contract_id;
                    }
                }
            })

            if (contract_id != "" && contract_id != undefined && contract_id != null) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=property&property=name&contract_id=" + contract_id,
                    async: false,
                    //dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            $("#contract_idHidden").val(contract_id);
                            $("#contract_id").val(data);
                        }
                    }
                })
            }
        }
    }
    // 通过合同，生成服务包信息
    function GetServiceByContractID() {
        var serHtml = "<option value=''> </option>";
        var contract_id = $("#contract_idHidden").val();
        if (contract_id != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ServiceAjax.ashx?act=GetSerList&contract_id=" + contract_id,
                async: false,
                //dataType: "json",
                success: function (data) {
                    if (data != "") {
                        serHtml += data;
                        $("#service_id").prop("disabled", false);
                    }
                }
            })
        } else {
            $("#service_id").prop("disabled", true);
        }
        $("#service_id").html(serHtml);
    }
    $("#isBilled").click(function () {
        if ($(this).is(":checked")) {
            $("#ShowOnInv").prop("checked", false);
            $("#ShowOnInv").prop("disabled", false);
        } else {
            $("#ShowOnInv").prop("checked", true);
            $("#ShowOnInv").prop("disabled", true);
        }
    })

    function GetRoleByRes() {
        var resId = $("#resource_id").val();
        if (resId != "" && resId != "0" && resId != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=GetRoleList&source_id=" + resId,
                async: false,
                success: function (data) {
                    if (data != "") {
                        $("#role_id").html(data);
                    } else {
                        $("#role_id").html("<option value=''>  </option>");
                    }
                }
            })
        } else {
            $("#role_id").html("<option value=''>  </option>");
        }
    }

    $("#tmeDate").blur(function () {
        var thisValue = $(this).val();
        if (thisValue == "") {
            thisValue = '<%=DateTime.Now.ToString("yyyy-MM-dd") %>';
        }
        $("#sumNotes1").html(thisValue);
        $("#intNotes1").html(thisValue);

    })

    $(".decimal2").blur(function () {
        var value = $(this).val();
        if (!isNaN(value) && value != "") {
            $(this).val(toDecimal2(value));
        } else {
            $(this).val("");
        }
    })

    $("#startTime").blur(function () {
        var thisValue = JiSuanBillHour();
        if (thisValue == "0") {
            $(thisValue).val("");
        } else {
            JiSuanWorkHours();
        }
    })
    $("#endTime").blur(function () {
        var thisValue = JiSuanBillHour();
        if (thisValue == "0") {
            $(thisValue).val("");
        } else {
            JiSuanWorkHours();
        }
    })
    $("#offset_hours").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && (!isNaN(thisValue))) {
            var bills = $("#hours_billed").val();
            if (bills != "" && (!isNaN(bills))) {
                var newBills = Number(bills) + Number(thisValue);
                $("#hours_billed").val(toDecimal2(newBills));
            } else {
                $("#hours_billed").val(toDecimal2(thisValue));
            }
        }
    })

    // 计算计费时间  0代表时间不对  1代表执行成功
    function JiSuanBillHour() {
        // hours_billed
        // 根据系统设置进行判断如何取整
        debugger;
        var startDate = $("#startTime").val();
        var endDate = $("#endTime").val();
        var dayDate = $("#tmeDate").val();
        if (startDate != "" && endDate != "" && dayDate != "") {
            startDate = dayDate + " " + startDate;
            endDate = dayDate + " " + endDate;
            var starString = startDate.replace(/\-/g, "/");
            var endString = endDate.replace(/\-/g, "/");
            var sdDate = new Date(starString);
            var edDate = new Date(endString);
            var diffMin = parseInt(edDate - sdDate) / 1000 / 60;
            if (diffMin < 0) {
                <% var idCrosNight = new EMT.DoneNOW.BLL.SysSettingBLL().GetValueById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_ALLOW_CROSS_NIGHT);
    if (idCrosNight != "1")
    {%>
                LayerMsg("结束时间要大于开始时间");
                return "0";
                 <%}
                 %>
            }
            // 
            var minValue = '<%=new EMT.DoneNOW.BLL.SysSettingBLL().GetValueById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_WORKENTRY_BILL_ROUND) %>';

            var mins = Math.ceil(diffMin / Number(minValue));
            var bills = mins * (Number(minValue) / 60);
            if (bills < 0) {
                bills = 24 + bills;
            }
            if (bills == 0) {
                if (diffMin < 0) {
                    bills = 24;
                }
            }

            var billOff = $("#offset_hours").val();
            if (billOff != "" && (!isNaN(billOff))) {
                bills = bills + Number(billOff);
            }
            $("#hours_billed").val(toDecimal2(bills));


            return "1";
        } else {
            $("#hours_billed").val("0.00");
            return "";
        }
    }


    function JiSuanWorkHours() {
        var startDate = $("#startTime").val();
        var endDate = $("#endTime").val();
        var dayDate = $("#tmeDate").val();
        if (startDate != "" && endDate != "" && dayDate != "") {
            startDate = dayDate + " " + startDate;
            endDate = dayDate + " " + endDate;
            var starString = startDate.replace(/\-/g, "/");
            var endString = endDate.replace(/\-/g, "/");
            var sdDate = new Date(starString);
            var edDate = new Date(endString);
            var diffMin = parseInt(edDate - sdDate) / 1000 / 60;
            var minValue = '<%=new EMT.DoneNOW.BLL.SysSettingBLL().GetValueById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_WORKENTRY_WORK_ROUND) %>';

            var mins = Math.ceil(diffMin / Number(minValue));
            var bills = mins * (Number(minValue) / 60);
            if (bills < 0) {
                bills = 24 + bills;
            }
            if (bills == 0) {
                if (diffMin < 0) {
                    bills = 24;
                }
            }
            $("#hours_worked").val(toDecimal2(bills));
        } else {
            $("#hours_worked").val("0.00");
        }
    }

    function SubmitCheck() {
        // account_id
        var resource_id = $("#resource_id").val();
        if (resource_id == "" || resource_id == null || resource_id == "0") {
            LayerMsg("请选择员工！");
            return false;
        }
        var account_id = $("#account_id").val();
        if (account_id == "" || account_id == null || account_id == "0") {
            LayerMsg("请选择客户！");
            return false;
        }
        var project_id = $("#project_id").val();
        if (project_id == "" || project_id == null || project_id == "0") {
            LayerMsg("请选择项目！");
            return false;
        }
        var task_id = $("#task_id").val();
        if (task_id == "" || task_id == null || task_id == "0") {
            LayerMsg("请选择任务！");
            return false;
        }
        var cost_code_id = $("#cost_code_id").val();
        if (cost_code_id == "" || cost_code_id == null || cost_code_id == "0") {
            LayerMsg("请选择工作类型！");
            return false;
        }
        var role_id = $("#role_id").val();
        if (role_id == "" || role_id == null || role_id == "0") {
            LayerMsg("请选择角色！");
            return false;
        }
        var startTime = $("#startTime").val();
        if (startTime == "" || startTime == null) {
            LayerMsg("请填写开始时间！");
            return false;
        }// tmeDate
        var endTime = $("#endTime").val();
        if (endTime == "" || endTime == null) {
            LayerMsg("请填写结束时间！");
            return false;
        }
        var tmeDate = $("#tmeDate").val();
        if (tmeDate == "" || tmeDate == null) {
            LayerMsg("请填写日期！");
            return false;
        }
        var remain_hours = $("#remain_hours").val();
        if (remain_hours == "" || remain_hours == null) {
            LayerMsg("请填写剩余时间！");
            return false;
        }
        var workSummary1 = $("#workSummary1").val();
        if (workSummary1 == "" || workSummary1 == null) {
            var noteValue = '<%=new EMT.DoneNOW.BLL.SysSettingBLL().GetValueById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_REQUIRED_SUMMAY_NOTE) %>';
            if (noteValue == "1") {
                LayerMsg("请填写剩余时间！");
                return false;
            }
        }
        // workSummary1

        return true;
    }

    $("#save_close").click(function () {
        if (!SubmitCheck()) {

            return false;
        }
        return true;
    })
</script>
