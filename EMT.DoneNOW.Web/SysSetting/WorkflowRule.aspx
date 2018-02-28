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
    <style>
        .content label{width:100px;}
        .condition label{text-align:left;width:80px;}
        .condition td {width:400px;}
    </style>
</head>
<body>
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
            <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0;">
                <div class="content clear">
                    <div class="information clear">
                        <p class="informationTitle">常规信息</p>
                        <input type="hidden" id="ckids0" name="ckids0" />
                        <input type="hidden" id="ckids1" name="ckids1" />
                        <input type="hidden" id="ckids2" name="ckids2" />
                        <input type="hidden" id="ckids3" name="ckids3" />
                        <input type="hidden" id="ckids4" name="ckids4" />
                        <input type="hidden" id="ckids5" name="ckids5" />
                        <div>
                            <table border="none" cellspacing="" cellpadding="" style="width: 800px;">
                                <tr>
                                    <td style="width:300px; vertical-align:top;">
                                        <div class="clear">
                                            <label>工作流名称<span class="red">*</span></label>
                                            <input type="text" name="name" id="name" value="" />
                                        </div>
                                    </td>
                                    <td style="width:300px;">
                                        <div class="clear">
                                            <label>工作流名称<span class="red">*</span></label>
                                            <textarea name="description"></textarea>
                                        </div>
                                    </td>
                                    <td style="vertical-align:top;">
                                        <div>
                                            <label>激活</label>
                                            <input type="checkbox" checked="checked" name="active" />
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
                                        <select id="def1pro0" style="width:220px;" onchange="def1ProChange(0)"><option>(选择一个属性)</option></select>
                                        <select id="def1oper0" style="width:130px;"><option>(选择一个操作符)</option></select>
                                        <select id="def1val00" style="width:140px;display:none;"></select>
                                        <input id="def1val01" style="width:120px;display:none;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def1pro1" style="width:220px;" disabled="disabled"><option>(选择一个属性)</option></select>
                                        <select id="def1oper1" style="width:130px;" disabled="disabled"><option>(选择一个操作符)</option></select>
                                        <select id="def1val10" style="width:140px;display:none;"></select>
                                        <input id="def1val11" style="width:120px;display:none;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def1pro2" style="width:220px;" disabled="disabled"><option>(选择一个属性)</option></select>
                                        <select id="def1oper2" style="width:130px;" disabled="disabled"><option>(选择一个操作符)</option></select>
                                        <select id="def1val20" style="width:140px;display:none;"></select>
                                        <input id="def1val21" style="width:120px;display:none;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def1pro3" style="width:220px;" disabled="disabled"><option>(选择一个属性)</option></select>
                                        <select id="def1oper3" style="width:130px;" disabled="disabled"><option>(选择一个操作符)</option></select>
                                        <select id="def1val30" style="width:140px;display:none;"></select>
                                        <input id="def1val31" style="width:120px;display:none;" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label style="width:48px;text-align:right;">并且</label>
                                        <select id="def1pro4" style="width:220px;" disabled="disabled"><option>(选择一个属性)</option></select>
                                        <select id="def1oper4" style="width:130px;" disabled="disabled"><option>(选择一个操作符)</option></select>
                                        <select id="def1val40" style="width:140px;display:none;"></select>
                                        <input id="def1val41" style="width:120px;display:none;" />
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
                        <div>
                            <div>
                                <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                                </table>
                            </div>
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
                </div>
            </div>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/index.js"></script>
    <script src="../Scripts/common.js"></script>
    <script>
        var conditions;
        $("#workflow_object_id").change(function () {
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
                    })
                } else {
                    conditions = null;
                }
            })
        })

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
            } else {
                var str = "";
                for (var i = 0; i < conditions.length; i++) {
                    if (conditions[i][0].description != sltValue) { continue; }
                    for (var j = 0; j < conditions[i].length; j++) {
                        str += "<option value='" + conditions[i][j].operator_type_id + "'>" + conditions[i][j].operatorName + "</option>";
                    }
                }
                document.getElementById("def1oper" + idx).innerHTML = str;
            }
        }

        $.each($(".nav-title li"), function (i) {
            $(this).click(function () {
                $(this).addClass("boders").siblings("li").removeClass("boders");
                $(".content").eq(i).show().siblings(".content").hide();
            })
        });
    </script>
</body>
</html>
