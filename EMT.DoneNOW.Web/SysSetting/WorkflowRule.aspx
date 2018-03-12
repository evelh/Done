<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WorkflowRule.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.WorkflowRule" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>工作流规则</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link rel="stylesheet" type="text/css" href="../Content/multiple-select.css"/>
    <style>
        .content label{width:100px;}
        .condition label{text-align:left;width:80px;}
        .condition td {width:400px;}
        .condition span{float:left;margin-left:15px;}
        .informationTitle{height:34px;font-size:16px;font-weight:600;}
    </style>
</head>
<body style="overflow:auto;">
    <div class="header">工作流规则
    </div>
    <div class="header-title">
        <ul>
            <li id="SaveClose">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <input type="button" value="保存并关闭" />
            </li>
            <li id="SaveNewAdd">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                <input type="button" value="保存并新建" />
            </li>
            <li id="Cancle">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <input type="button" value="取消" />
            </li>
        </ul>
    </div>
    <div class="nav-title">
        <ul class="clear">
            <li class="boders">常规</li>
            <li>通知</li>
        </ul>
    </div>
    <form id="form1" runat="server">
        <div>
            <div style="left: 0; overflow-x: auto; overflow-y: auto; right: 0;">
                <div class="content clear">
                    <div class="information clear">
                        <p class="informationTitle">常规信息</p>
                        <input type="hidden" id="ckids0" name="ckids0" />
                        <input type="hidden" id="ckids1" name="ckids1" />
                        <input type="hidden" id="ckids2" name="ckids2" />
                        <input type="hidden" id="ckids3" name="ckids3" />
                        <input type="hidden" id="ckids4" name="ckids4" />
                        <input type="hidden" id="ckids5" name="ckids5" />
                        <input type="hidden" id="action" name="action" />
                        <div>
                            <table border="none" cellspacing="" cellpadding="" style="width: 800px;">
                                <tr>
                                    <td style="width:300px; vertical-align:top;">
                                        <div class="clear">
                                            <label>工作流名称<span class="red">*</span></label>
                                            <input type="text" name="name" id="name" <%if (wfEdit != null) { %> value="<%=wfEdit.name %>"<%} %> />
                                        </div>
                                    </td>
                                    <td style="width:300px;">
                                        <div class="clear">
                                            <label>描述</label>
                                            <textarea name="description"><%if (wfEdit != null) { %><%=wfEdit.description %><%} %></textarea>
                                        </div>
                                    </td>
                                    <td style="vertical-align:top;">
                                        <div>
                                            <label>激活</label>
                                            <input type="checkbox" <%if (wfEdit == null||wfEdit.is_active==1) { %> checked="checked"<%} %> name="active" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="information clear" id="event0">
                        <p class="informationTitle">事件</p>
                        <div class="condition">
                            <table border="none" cellspacing="" cellpadding="" style="width: 400px;float:inherit;">
                                <tr>
                                    <td>
                                        <label style="text-align:right;">当对象</label>
                                        <select style="width:120px;" id="workflow_object_id" name="workflow_object_id">
                                            <option value=""></option>
                                            <option value="2416">工单</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                            <table border="none" cellspacing="" cellpadding="" style="width: 1000px;" id="eventDef0">
                            </table>
                        </div>
                    </div>
                    <div class="information clear" id="event1">
                        <p class="informationTitle">条件</p>
                        <div class="condition">
                            <table border="none" cellspacing="" cellpadding="" style="width: 400px;float:inherit;">
                                <tr>
                                    <td>
                                        <label style="text-align:right;width:120px;">满足以下条件</label>
                                    </td>
                                </tr>
                            </table>
                            <table border="none" cellspacing="" cellpadding="" style="width: 1000px;" id="eventDef1">
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;"></label>
                                        <select id="def1pro0" name="def1pro0" style="width:220px;" onchange="def1ProChange(0)"><option value="">(选择一个属性)</option></select>
                                        <select id="def1oper0" name="def1oper0" style="width:130px;" onchange="def1OperChange(0)"><option value="">(选择一个操作符)</option></select>
                                        <select id="def1val00" name="def1val00" style="width:180px;display:none;"></select>
                                        <input id="def1val01" name="def1val01" style="width:180px;display:none;" />
                                        <div id="mlt0" class="multiplebox">
                                            <input type="hidden" id="def1val02" name="def1val02" class="sl_cdt" />
							                <select id="mltslt0" multiple="multiple" style="display:none;">
				                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def1pro1" name="def1pro1" style="width:220px;" disabled="disabled" onchange="def1ProChange(1)"><option value="">(选择一个属性)</option></select>
                                        <select id="def1oper1" name="def1oper1" style="width:130px;" disabled="disabled" onchange="def1OperChange(1)"><option value="">(选择一个操作符)</option></select>
                                        <select id="def1val10" name="def1val10" style="width:180px;display:none;"></select>
                                        <input id="def1val11" name="def1val11" style="width:180px;display:none;" />
                                        <div id="mlt1" class="multiplebox">
                                            <input type="hidden" id="def1val12" name="def1val12" class="sl_cdt" />
							                <select id="mltslt1" multiple="multiple" style="display:none;">
				                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def1pro2" name="def1pro2" style="width:220px;" disabled="disabled" onchange="def1ProChange(2)"><option value="">(选择一个属性)</option></select>
                                        <select id="def1oper2" name="def1oper2" style="width:130px;" disabled="disabled" onchange="def1OperChange(2)"><option value="">(选择一个操作符)</option></select>
                                        <select id="def1val20" name="def1val20" style="width:180px;display:none;"></select>
                                        <input id="def1val21" name="def1val21" style="width:180px;display:none;" />
                                        <div id="mlt2" class="multiplebox">
                                            <input type="hidden" id="def1val22" name="def1val22" class="sl_cdt" />
							                <select id="mltslt2" multiple="multiple" style="display:none;">
				                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def1pro3" name="def1pro3" style="width:220px;" disabled="disabled" onchange="def1ProChange(3)"><option value="">(选择一个属性)</option></select>
                                        <select id="def1oper3" name="def1oper3" style="width:130px;" disabled="disabled" onchange="def1OperChange(3)"><option value="">(选择一个操作符)</option></select>
                                        <select id="def1val30" name="def1val30" style="width:180px;display:none;"></select>
                                        <input id="def1val31" name="def1val31" style="width:180px;display:none;" />
                                        <div id="mlt3" class="multiplebox">
                                            <input type="hidden" id="def1val32" name="def1val32" class="sl_cdt" />
							                <select id="mltslt3" multiple="multiple" style="display:none;">
				                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def1pro4" name="def1pro4" style="width:220px;" disabled="disabled" onchange="def1ProChange(4)"><option value="">(选择一个属性)</option></select>
                                        <select id="def1oper4" name="def1oper4" style="width:130px;" disabled="disabled" onchange="def1OperChange(4)"><option value="">(选择一个操作符)</option></select>
                                        <select id="def1val40" name="def1val40" style="width:180px;display:none;"></select>
                                        <input id="def1val41" name="def1val41" style="width:180px;display:none;" />
                                        <div id="mlt4" class="multiplebox">
                                            <input type="hidden" id="def1val42" name="def1val42" class="sl_cdt" />
							                <select id="mltslt4" multiple="multiple" style="display:none;">
				                            </select>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="information clear">
                        <p class="informationTitle">触发时间</p>
                        <div>
                            <div>
                                <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="information clear">
                        <p class="informationTitle">更新操作</p>
                        <div class="condition">
                            <table border="none" cellspacing="" cellpadding="" style="width: 400px;float:inherit;">
                                <tr>
                                    <td>
                                        <label style="text-align:right;width:120px;">执行以下更新操作</label>
                                    </td>
                                </tr>
                            </table>
                            <table border="none" cellspacing="" cellpadding="" style="width: 1000px;" id="eventDef2">
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;"></label>
                                        <select id="def2pro0" name="def2pro0" style="width:220px;" onchange="def2ProChange(0)"><option value="">(选择一个属性)</option></select>
                                        <span>=</span>
                                        <input id="def2val01" name="def2val01" style="width:76px;display:none;" />
                                        <select id="def2val00" name="def2val00" style="width:180px;"></select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def2pro1" name="def2pro1" style="width:220px;" disabled="disabled" onchange="def2ProChange(1)"><option value="">(选择一个属性)</option></select>
                                        <span>=</span>
                                        <input id="def2val11" name="def2val11" style="width:76px;display:none;" />
                                        <select id="def2val10" name="def2val10" style="width:180px;" disabled="disabled"></select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def2pro2" name="def2pro2" style="width:220px;" disabled="disabled" onchange="def2ProChange(2)"><option value="">(选择一个属性)</option></select>
                                        <span>=</span>
                                        <input id="def2val21" name="def2val21" style="width:76px;display:none;" />
                                        <select id="def2val20" name="def2val20" style="width:180px;" disabled="disabled"></select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def2pro3" name="def2pro3" style="width:220px;" disabled="disabled" onchange="def2ProChange(3)"><option value="">(选择一个属性)</option></select>
                                        <span>=</span>
                                        <input id="def2val31" name="def2val31" style="width:76px;display:none;" />
                                        <select id="def2val30" name="def2val30" style="width:180px;" disabled="disabled"></select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def2pro4" name="def2pro4" style="width:220px;" disabled="disabled" onchange="def2ProChange(4)"><option value="">(选择一个属性)</option></select>
                                        <span>=</span>
                                        <input id="def2val41" name="def2val41" style="width:76px;display:none;" />
                                        <select id="def2val40" name="def2val40" style="width:180px;" disabled="disabled"></select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="information clear">
                        <p class="informationTitle">其他操作</p>
                        <div>
                            <div>
                                <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="information clear">
                        <p class="informationTitle">待办</p>
                        <div>
                            <div>
                                <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="content clear" style="display: none;">
                    <div class="information clear">
                        <p class="informationTitle">动态接收人<span style="margin-left:22px;font-size:13px;cursor:pointer;color:#376597;" onclick="chooseNotifyRecipient()">全选</span></p>
                        <div>
                            <table border="none" cellspacing="" cellpadding="" style="width: 800px;" id="notifyRecipient">
                            </table>
                        </div>
                    </div>
                    <div class="information clear">
                        <p class="informationTitle">通知模板</p>
                        <div>
                            <table border="none" cellspacing="" cellpadding="" style="width: 800px;">
                                <tr>
                                    <td>
                                        <input type="checkbox" style="float:left;" id="useDefTmpl" name="useDefTmpl" />
                                        <label for="useDefTmpl" style="width:452px;text-align:left;">使用事件默认模板，如果没有模板模板，则用工作流规则定义的模板。</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="text-align:left;padding-left:15px;">通知模板</label>
                                        <select style="width:268px;" id="notifyTemp" name="notifyTemp"></select>
                                        <span style="margin-left:6px;padding-top:3px;float:left;width:17px;height:22px;"><i class="icon-dh" style="background-image:url(../Images/edit.png) !important;"></i></span>
                                        <span style="margin-left:6px;padding-top:3px;float:left;width:17px;height:22px;"><i class="icon-dh" style="background-image:url(../Images/add.png) !important;"></i></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="text-align:left;padding-left:15px;">通知标题</label>
                                        <input type="text" id="notify_subject" name="notify_subject" style="width:268px;" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/index.js"></script>
    <script src="../Scripts/common.js"></script>
    <script src="../Scripts/Common/multiple-select.js" type="text/javascript" charset="utf-8"></script>
    <script>
        $("#Cancle").click(function () {
            window.close();
        })
        $("#SaveClose").click(function () {
            if (checkForm()) {
                $("#action").val("SaveClose");
                $("#form1").submit();
            }
        })
        $("#SaveNewAdd").click(function () {
            if (checkForm()) {
                $("#action").val("SaveNew");
                $("#form1").submit();
            }
        })
        function checkForm() {
            if ($("#name").val() == "") {
                LayerMsg("请输入工作流名称！");
                return false;
            }
            return true;
        }
        var conditions;
        var updates;
        $("#workflow_object_id").change(function () { objChange(); })

        function objChange() {
            if ($("#workflow_object_id").val() == "") { return; }
            requestData("/Tools/WorkflowRuleAjax.ashx?act=getRuleFormInfo&objId=" + $("#workflow_object_id").val(), null, function (data) {
                if (data[0] != null) {
                    var str = "";
                    var cnt = data[0].length / 2;
                    if (data[0].length % 2 != 0)
                        cnt = parseInt(data[0].length / 2) + 1;
                    for (var i = 0; i < cnt; i++) {
                        str += "<tr>";
                        str += "<td><input type='checkbox' id='ck" + data[0][i].id + "' name='ck" + data[0][i].id + "' onclick='checkChange(0," + data[0][i].id + ")' /><label style='width:180px;' for='ck" + data[0][i].id + "' >" + data[0][i].description + "</label>";
                        if (data[0][i].data_type == 809) {
                            str += "<select id='slt" + data[0][i].id + "' name='slt" + data[0][i].id + "' >";
                            for (var j = 0; j < data[0][i].values.length; j++) {
                                str += "<option value='" + data[0][i].values[j].val + "'>" + data[0][i].values[j].show + "</option>";
                            }
                            str += "</select></td>";
                        } else if (data[0][i].data_type == 819) {
                            str += "<input type='text' style='width:60px;' id='ipt" + data[0][i].id + "' name='ipt" + data[0][i].id + "' />";
                            str += "<select style='width:105px;' id='slt" + data[0][i].id + "' name='slt" + data[0][i].id + "' >";
                            for (var j = 0; j < data[0][i].values.length; j++) {
                                str += "<option value='" + data[0][i].values[j].val + "'>" + data[0][i].values[j].show + "</option>";
                            }
                            str += "</select></td>";
                        } else {
                            str += "</td>";
                        }
                        if (i + cnt < data[0].length) {
                            str += "<td><input type='checkbox' id='ck" + data[0][i + cnt].id + "' name='ck" + data[0][i + cnt].id + "' onclick='checkChange(0," + data[0][i + cnt].id + ")' /><label style='width:180px;' for='ck" + data[0][i + cnt].id + "' >" + data[0][i + cnt].description + "</label>";
                            if (data[0][i + cnt].data_type == 809) {
                                str += "<select id='slt" + data[0][i + cnt].id + "' name='slt" + data[0][i + cnt].id + "' >";
                                for (var j = 0; j < data[0][i + cnt].values.length; j++) {
                                    str += "<option value='" + data[0][i + cnt].values[j].val + "'>" + data[0][i + cnt].values[j].show + "</option>";
                                }
                                str += "</select></td>";
                            } else if (data[0][i + cnt].data_type == 819) {
                                str += "<input type='text' style='width:60px;' id='ipt" + data[0][i + cnt].id + "' name='ipt" + data[0][i + cnt].id + "' />";
                                str += "<select style='width:105px;' id='slt" + data[0][i + cnt].id + "' name='slt" + data[0][i + cnt].id + "' >";
                                for (var j = 0; j < data[0][i + cnt].values.length; j++) {
                                    str += "<option value='" + data[0][i + cnt].values[j].val + "'>" + data[0][i + cnt].values[j].show + "</option>";
                                }
                                str += "</select></td>";
                            } else {
                                str += "</td>";
                            }
                        }
                        str += "</tr>";
                    }
                    document.getElementById("eventDef0").innerHTML = str;
                }
                if (data[1] != null) {
                    requestData("/Tools/WorkflowRuleAjax.ashx?act=getRuleFormConditonInfo&objId=" + $("#workflow_object_id").val(), null, function (data) {
                        conditions = data;
                        var str = "<option value=''>(选择一个属性)</option>";
                        for (var i = 0; i < conditions.length; i++) {
                            str += "<option value='" + conditions[i][0].description + "'>" + conditions[i][0].description + "</option>";
                        }
                        document.getElementById("def1pro0").innerHTML = str;
                        document.getElementById("def1pro1").innerHTML = str;
                        document.getElementById("def1pro2").innerHTML = str;
                        document.getElementById("def1pro3").innerHTML = str;
                        document.getElementById("def1pro4").innerHTML = str;

                        <%if (wfEdit!=null&&wfEdit.conditionJson != null) {
                        int idx = 0;
                        foreach (var cdt in wfEdit.conditionJson) {
                            EMT.DoneNOW.DTO.WorkflowConditionParaDto cdtPara = conditionParams[1].Find(_ => _.col_name.Equals((string)cdt["col_name"]) && ((string)cdt["operator"]).Equals(_.operator_type_id));
                            %>
                                    $("#def1pro<%=idx%>").val("<%=cdtPara.description%>");
                                    def1ProChange(<%=idx%>);
                                    $("#def1oper<%=idx%>").val("<%=cdtPara.operator_type_id%>");
                                    def1OperChange(<%=idx%>);
                        <%if (cdtPara.data_type == 809)
        { %>
                                    $("#def1val<%=idx%>0").val("<%=(string)cdt["value"]%>");
        <%}
        else if (cdtPara.data_type == 805 || cdtPara.data_type == 806) { %>
                                    $("#def1val<%=idx%>1").val("<%=(string)cdt["value"]%>");
        <%} else if (cdtPara.data_type == 810) { %>
                                    $("#def1val<%=idx%>2").val("<%=(string)cdt["value"]%>");
        <%}%>
                    <%
                            idx++;
                        } }%>
                    })
                } else {
                    conditions = null;
                }
                if (data[2] != null) {
                    updates = data[2];
                    var str = "<option value=''>(选择一个属性)</option>";
                    for (var i = 0; i < updates.length; i++) {
                        str += "<option value='" + updates[i].id + "'>" + updates[i].description + "</option>";
                    }
                    document.getElementById("def2pro0").innerHTML = str;
                    document.getElementById("def2pro1").innerHTML = str;
                    document.getElementById("def2pro2").innerHTML = str;
                    document.getElementById("def2pro3").innerHTML = str;
                    document.getElementById("def2pro4").innerHTML = str;
                } else { updates = null; }
                if (data[4] != null) {
                    for (var i = 0; i < data[4].length; i++) {
                        if (data[4][i].description == "动态接收人") {
                            var users = data[4][i].values;
                            var str = "";
                            for (var j = 0; j < users.length; j++) {
                                if (j % 4 == 0)
                                    str += "<tr>";
                                str += "<td><div><input class='notifyck' type='checkbox' id='notifyCk" + users[j].val + "' name='notifyCk" + users[j].val + "' /><label style='text-align:left;width:120px;' for='notifyCk" + users[j].val + "'>" + users[j].show + "</label></div></td>";
                                if (j % 4 == 3)
                                    str += "</tr>";
                            }
                            document.getElementById("notifyRecipient").innerHTML = str;
                            notifyck = 0;
                        }
                        if (data[4][i].description == "通知模板") {
                            var tmpls = data[4][i].values;
                            var str = "<option value=''>(选择通知模板)</option>";
                            for (var j = 0; j < tmpls.length; j++) {
                                str += "<option value='" + tmpls[j].val + "'>" + tmpls[j].show + "</option>";
                            }
                            document.getElementById("notifyTemp").innerHTML = str;
                        }
                    }
                }

                <%if (wfEdit != null) { %>
                $("#workflow_object_id").attr("disabled", "disabled");
                var evtId;
                    <%if (wfEdit.eventJson != null) {
            foreach (var evt in wfEdit.eventJson) {
                EMT.DoneNOW.DTO.WorkflowConditionParaDto cdtPara = conditionParams[0].Find(_ => _.col_name.Equals((string)evt["event"]));
            %>
                evtId =<%=cdtPara.id%>;
                $("#ck" + evtId).prop("checked", true);
                for (var i = 0; i < data[0].length; i++) {
                    if (data[0][i].id != evtId){ continue; }
                    if (data[0][i].data_type == 809) {
                        $("#slt" + evtId).val("<%=(string)evt["value"]%>");
                    } else if (data[0][i].data_type == 819) {
                        $("#slt" + evtId).val("<%=(string)evt["unit"]%>");
                        $("#ipt" + evtId).val("<%=(string)evt["value"]%>");
                    }
                    break;
                }
                    <%}}%>
                
                <%}%>
            })
        }

        var notifyck = 0;
        function chooseNotifyRecipient() {
            if (notifyck == 0) {
                $(".notifyck").attr("checked", "true");
                notifyck = 1;
            } else {
                $(".notifyck").removeAttr("checked");
                notifyck = 0;
            }
        }

        function checkChange(idx, ckid) {
            var ids = $("#ckids"+idx).val().split(",");
            var idRm = "";
            for (i = 0; i < ids.length; i++) {
                if (ids[i] != ckid) {
                    if (idRm == "")
                        idRm = ids[i];
                    else
                        idRm = idRm + "," + ids[i];
                }
            }
            if ($("#ck" + ckid).is(':checked') == true) {
                if (idRm == "")
                    idRm = ckid;
                else
                    idRm = idRm + "," + ckid;
            }

            $("#ckids"+idx).val(idRm);
        }

        function def1ProChange(idx) {
            if (conditions == null) { return; }
            var sltValue = $("#def1pro" + idx).val();
            if (sltValue == "") {
                document.getElementById("def1oper" + idx).innerHTML = "<option>(选择一个操作符)</option>";
                $("#def1val" + idx + "0").hide();
                $("#def1val" + idx + "1").hide();
                if (idx < 4 && $("#def1pro" + (idx + 1)).val() == "") {
                    $("#def1pro" + (idx + 1)).attr("disabled", "disabled");
                    $("#def1oper" + (idx + 1)).attr("disabled", "disabled");
                }
                if (idx > 0 && $("#def1pro" + (idx - 1)).val() == "") {
                    $("#def1pro" + idx).attr("disabled", "disabled");
                    $("#def1oper" + idx).attr("disabled", "disabled");
                }
            } else {
                var str = "";
                for (var i = 0; i < conditions.length; i++) {
                    if (conditions[i][0].description != sltValue) { continue; }
                    for (var j = 0; j < conditions[i].length; j++) {
                        str += "<option value='" + conditions[i][j].operator_type_id + "'>" + conditions[i][j].operatorName + "</option>";
                    }
                    break;
                }
                document.getElementById("def1oper" + idx).innerHTML = str;
                def1OperChange(idx);
                if (idx < 4) {
                    $("#def1pro" + (idx + 1)).removeAttr("disabled");
                    $("#def1oper" + (idx + 1)).removeAttr("disabled");
                }
            }
        }

        function def1OperChange(idx) {
            if ($("#def1oper" + idx).val() == "") { return; }
            var proValue = $("#def1pro" + idx).val();
            var operValue = $("#def1oper" + idx).val();
            for (var i = 0; i < conditions.length; i++) {
                if (conditions[i][0].description != proValue) { continue; }
                for (var j = 0; j < conditions[i].length; j++) {
                    if (operValue != conditions[i][j].operator_type_id) { continue; }
                    var cdt = conditions[i][j];
                    var sltVals = "";
                    if (cdt.values != null) {
                        for (var k = 0; k < cdt.values.length; k++) {
                            sltVals += "<option value='" + cdt.values[k].val+"'>" + cdt.values[k].show + "</option>";
                        }
                    }
                    if (cdt.data_type == 820) {
                        $("#def1val" + idx + "0").hide();
                        $("#def1val" + idx + "1").hide();
                        $("#mlt" + idx).hide();
                    } else if (cdt.data_type == 809) {
                        document.getElementById("def1val" + idx + "0").innerHTML = sltVals;
                        $("#def1val" + idx + "0").show();
                        $("#def1val" + idx + "1").hide();
                        $("#mlt" + idx).hide();
                    } else if (cdt.data_type == 805 || cdt.data_type == 806) {
                        $("#def1val" + idx + "0").hide();
                        $("#def1val" + idx + "1").show();
                        $("#mlt" + idx).hide();
                    } else if (cdt.data_type == 810) {
                        document.getElementById("mltslt" + idx).innerHTML = sltVals;
                        $("#def1val" + idx + "0").hide();
                        $("#def1val" + idx + "1").hide();
                        $("#mlt" + idx).show();
                        $("#mltslt" + idx).change(function () {
                            $("#def1val" + idx + "2").val($(this).val());
                        }).multipleSelect({
                            width: '100%'
                        })
                    }
                }
                break;
            }
        }

        function def2ProChange(idx) {
            if (updates == null) { return; }
            var sltValue = $("#def2pro" + idx).val();
            if (sltValue == "") {
                document.getElementById("def2val" + idx + "0").innerHTML = "";
                $("#def2val" + idx + "0").attr("disabled", "disabled");
                $("#def2val" + idx + "1").hide();
                if (idx < 4 && $("#def2pro" + (idx + 1)).val() == "") {
                    $("#def2pro" + (idx + 1)).attr("disabled", "disabled");
                }
                if (idx > 0 && $("#def2pro" + (idx - 1)).val() == "") {
                    $("#def2pro" + idx).attr("disabled", "disabled");
                }
            } else {
                var str = "";
                for (var i = 0; i < updates.length; i++) {
                    if (updates[i].id != sltValue) { continue; }
                    for (var j = 0; j < updates[i].values.length; j++) {
                        str += "<option value='" + updates[i].values[j].val + "'>" + updates[i].values[j].show + "</option>";
                    }
                    if (updates[i].data_type == 819) {
                        $("#def2val" + idx + "1").show();
                    }
                    break;
                }
                document.getElementById("def2val" + idx + "0").innerHTML = str;
                $("#def2val" + idx + "0").removeAttr("disabled");
                if (idx < 4) {
                    $("#def2pro" + (idx + 1)).removeAttr("disabled");
                }
            }
        }

        $.each($(".nav-title li"), function (i) {
            $(this).click(function () {
                $(this).addClass("boders").siblings("li").removeClass("boders");
                $(".content").eq(i).show().siblings(".content").hide();
            })
        });

        <%if (wfEdit != null) { %>
        $(document).ready(function () {
            $("#workflow_object_id").val("<%=wfEdit.workflow_object_id%>");
            objChange();
        })
        <%}%>
    </script>
</body>
</html>
