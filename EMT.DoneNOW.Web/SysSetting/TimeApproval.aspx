<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TimeApproval.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.TimeApproval" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link rel="stylesheet" type="text/css" href="../Content/multipleList.css" />
    <title><%=string.IsNullOrEmpty(type)?"工时":"费用" %>审批设置</title>
    <style>
        li {
            list-style: None;
        }
        .errorSmallClass {
            color: red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=string.IsNullOrEmpty(type)?"工时":"费用" %>审批设置 - <span id="userNameSpan"></span></div>
        <div class="header-title" style="width: 480px;">
            <ul>
                <li onclick="SaveClose()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>保存并关闭</li>
                <li onclick="javascript:window.close()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>取消</li>
            </ul>
        </div>
        <div style="padding-right: 10px; padding-left: 10px; padding-bottom: 10px; padding-top: 10px; vertical-align: middle">
            <span id="ContactGroupLabel" class="FieldLabel" style="font-weight: bold;">审批人：</span>
            <span class="errorSmallClass">*</span>&nbsp;
			<span id="ddlContactGroups" style="display: inline-block;">
                <select id="ResourceSelect" name="ResourceId" class="txtBlack8Class" style="width: 300px;">
                    <option value=""></option>
                    <%if (resList != null && resList.Count > 0)
                        {
                            foreach (var res in resList)
                            {%>
                    <option value="<%=res.id %>" <%if (thisRes != null && thisRes.id == res.id)
                        { %>
                        selected="selected" <%} %>><%=res.name %></option>
                    <%}
                        } %>
                </select>
            </span>
        </div>
        <div id="contactSelectSection" style="padding: 5px">
            <span>
                <table id="_ctl1_ContainerTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td valign="middle" style="align: center;">
                                <table id="_ctl1_LeftListBoxTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td><span id="_ctl1_LeftListBoxLabel" class="lblNormalClass" style="font-weight: bold;"></span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <select size="15" name="from[]" id="multiselect" class="form-control" multiple="multiple" style="height: 300px; width: 285px;">
                                                    <option class="aa" value="11">1</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td valign="middle" style="align: center; padding-left: 10px; padding-right: 10px;">
                                <table id="_ctl1_MiddleButtonTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <%if (string.IsNullOrEmpty(type))
                                            { %>
                                        <tr>
                                            <td>
                                                <button type="button" id="multiselect_rightSelected1" class="btn btn-block"><i class="glyphicon glyphicon-chevron-right"></i>作为第一级添加</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="height: 20px;"></div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <button type="button" id="multiselect_rightSelected2" class="btn btn-block"><i class="glyphicon glyphicon-chevron-right"></i>作为第二级添加</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="height: 20px;"></div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <button type="button" id="multiselect_rightSelected3" class="btn btn-block"><i class="glyphicon glyphicon-chevron-right"></i>作为第三级添加</button>
                                            </td>
                                        </tr>
                                        <%}else{ %>
                                           <tr>
                                            <td>
                                                <button type="button" id="multiselect_rightSelected" class="btn btn-block"><i class="glyphicon glyphicon-chevron-right"></i></button>
                                            </td>
                                        </tr>
                                        <%} %>
                                        <tr>
                                            <td>
                                                <div style="height: 20px;"></div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <button type="button" id="Remove" class="btn btn-block"><i class="glyphicon glyphicon-chevron-left"></i><%=type=="expense"?"":"移除" %></button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td valign="middle" style="align: center;">
                                <table id="_ctl1_RightListBoxTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td><span id="_ctl1_RightListBoxLabel" class="lblNormalClass" style="font-weight: bold;"></span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <select size="15" name="to[]" id="multiselect_to" class="form-control" multiple="multiple" style="height: 300px; width: 285px;">
                                                    <option class="bb" value="22">2</option>
                                                </select></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </span>

        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/multiselect.min.js" type="text/javascript" charset="utf-8"></script>
<script>
    jQuery(document).ready(function ($) {
        //$('#multiselect').multiselect({
        //    sort: false
        //});
        $("#ResourceSelect").trigger("change");
    });

    $("#ResourceSelect").change(function () {
        var thisRes = $(this).val();
        if (thisRes != "") {
            var thisName = $("#ResourceSelect option:selected").text();
            $("#userNameSpan").text(thisName);
            $("#multiselect").html("");
            $("#multiselect_to").html("");
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetResApproval&resId=" + thisRes+"&type=<%=type %>",
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.noAppro != "") {
                            for (var i = 0; i < data.noAppro.length; i++) {
                                $("#multiselect").append("<option class='" + (data.noAppro[i].is_active == 1 ? "" : "unActive") + "' value='" + data.noAppro[i].id + "'>" + data.noAppro[i].name + "</option>");
                            }
                        }
                        if (data.appro != "") {
                            for (var i = 0; i < data.appro.length; i++) {
                                var tierName = "";
                                var thisValue = data.appro[i].id;
                                <%if (string.IsNullOrEmpty(type)) {%>
                                thisValue += "-" + data.appro[i].tier;
                                if (data.appro[i].tier == "1") {
                                    tierName = "[Level1]";
                                }
                                else if (data.appro[i].tier == "2") {
                                    tierName = "[Level2]";
                                }
                                else if (data.appro[i].tier == "3") {
                                    tierName = "[Level3]";
                                }
                            <%} %>
                                $("#multiselect_to").append("<option class='" + data.appro[i].isActive + "' value='" + thisValue + "'>" + data.appro[i].name + tierName + "</option>");
                            }
                        }
                    }
                    
                }
            })

        }
        else {
            $("#multiselect").html("");
            $("#multiselect_to").html("");
            $("#userNameSpan").text("");
        }
    })
    $("#multiselect_rightSelected1").click(function () {
        AddType('1');
    })
    $("#multiselect_rightSelected2").click(function () {
        AddType('2');
    })
    $("#multiselect_rightSelected3").click(function () {
        AddType('3');
    })

    function AddType(tier) {
        $("#multiselect option:selected").each(function () {
            var tierName = "";
            if (tier == "1") {
                tierName = "[Level1]";
            }
            else if (tier == "2") {
                tierName = "[Level2]";
            }
            else if (tier == "3") {
                tierName = "[Level3]";
            }
            $("#multiselect_to").append("<option class='" + $(this).prop("class") + "' value='" + $(this).val() + "-" + tier + "'>" + $(this).text() + tierName + "</option>");
            $(this).remove();
        });
    }
    

    $("#multiselect_rightSelected").click(function () {
        $("#multiselect option:selected").each(function () {
            var thisValue = $(this).val();
            var valueArr = thisValue.split('-');
            var thisText = $(this).text();
            var textArr = thisText.split('[');
            $("#multiselect_to").append("<option class='" + $(this).prop("class") + "' value='" + valueArr[0] + "'>" + textArr[0] + "</option>");
            $(this).remove();
        });
    });

    $("#Remove").click(function () {
        $("#multiselect_to option:selected").each(function () {
            var thisValue = $(this).val();
            var valueArr = thisValue.split('-');
            var thisText = $(this).text();
            var textArr = thisText.split('[');
            $("#multiselect").append("<option class='" + $(this).prop("class") + "' value='" + valueArr[0] + "'>" + textArr[0] + "</option>");
            $(this).remove();
        });
    });

    function SaveClose() {
        var ResourceSelect = $("#ResourceSelect").val();
        if (ResourceSelect == "") {
            LayerMsg("请选择相关员工！");
            return;
        }
        var chooseIds = "";
        $("#multiselect_to option").each(function () {
            chooseIds += $(this).val() + ',';
        })
        if (chooseIds != "") {
            chooseIds = chooseIds.substring(0, chooseIds.length - 1);
        }
        $.ajax({
            type: "GET",
            url: "../Tools/ResourceAjax.ashx?act=ApprovalManage&toResIds=" + chooseIds + "&resId=" + ResourceSelect+"&type=<%=type %>",
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("保存成功！");
                }
                setTimeout(function () { self.opener.location.reload(); window.close(); }, 800);
            }
        })

    }
</script>
