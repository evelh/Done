<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddContractRate.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.AddContractRate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><%=isAdd?"新增":"删除" %>预付时间系数</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/Roles.css" rel="stylesheet" />
    <style>
        .thisRadio{
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
         <div class="TitleBar">
        <div class="Title">
            <span class="text1"><%=isAdd?"新增":"删除" %>预付时间系数</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon SaveAndClone"></span>
                <span class="Text">
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" /></span>
            </li>
            <%if (roleList != null && roleList.Count > 1)
                { %>
            <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                <span class="Icon SaveAndNew"></span>
                <span class="Text">
                    <asp:Button ID="save_new" runat="server" Text="保存并新增" BorderStyle="None" OnClick="save_new_Click" /></span>
            </li>
            <%} %>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <span class="Icon Cancel"></span>
                <span class="Text">取消</span>
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                        角色名称
                        <div>
                            <asp:DropDownList ID="role_id" runat="server" Width="255px"></asp:DropDownList>
                         
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div style="padding-bottom: 10px; font-weight: bold;">
                         合同上如果没有设置超时费率：
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div style="padding-bottom: 6px;">
                            <asp:RadioButton CssClass="thisRadio" ID="rbRoleRate" GroupName="defaultOrContractRate" runat="server" />
                           使用角色小时费率
                        </div>
                        <div style="padding-left: 18px;">
                            <input type="text" name="role_hourly_rate" id="role_hourly_rate" style="width:80px;text-align: right;" disabled value="" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div style="padding-bottom: 6px;">
                            <asp:RadioButton CssClass="thisRadio" ID="rbContractRate" GroupName="defaultOrContractRate" runat="server" Checked="true" />
                            使用合同角色小时费率
                        </div>
                        <div style="padding-left: 18px;">
                            <input type="text" class="thisNumber" name="contract_hourly_rate" id="contract_hourly_rate" style="width:80px;text-align: right;" value="<%=(!isAdd)&&conRate.rate!=null?((decimal)conRate.rate).ToString("#0.00"):"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"
数字/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        预付时间系数
                        <div>
                            <input type="text"  class="thisNumber" style="width:100px;text-align: right;" name="block_hour_multiplier" id="block_hour_multiplier" value="<%=(!isAdd)&&conRate.block_hour_multiplier!=null?((decimal)conRate.block_hour_multiplier).ToString("#0.00"):"" %>" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"
数字 />
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#CancelButton").click(function () {
        window.close();
    })
    $(function () {
        GetDataByRole();
    })

    var editSum = 1;
    <% if (!isAdd)
    {%>
    editSum = 0;
    <%}%>

    $("#role_id").change(function () {
        GetDataByRole();
    });
    $(".thisNumber").blur(function () {
        var value = $(this).val();
        if (value != "" && (!isNaN(value))) {
            value = toDecimal2(value);
            $(this).val(value);

        }
        else {
            $(this).val("0.00");
        }
    })

    function GetDataByRole() {
        var role_id = $("#role_id").val();
        if (role_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/RoleAjax.ashx?act=role&role_id=" + role_id,
                success: function (data) {
                    if (data != "") {
                        // hourly_rate
                        if (data.hourly_rate != undefined && data.hourly_rate != undefined != "") {
                            $("#role_hourly_rate").val(toDecimal2(data.hourly_rate));
                            if (Number(editSum) >= 1) {
                                $("#contract_hourly_rate").val(toDecimal2(data.hourly_rate));
                                $("#rbRoleRate").prop("checked", true);
                            }
                        }
                        else {
                            $("#role_hourly_rate").val("0.00");
                        }
                       
                        editSum += 1;
                    }
                },
            });
        }
    }

    $("#save_close").click(function () {
        $("#role_hourly_rate").removeAttr("disabled");
        if (!sunmirCheck()) {
            return false;
        }
        return true;
    })

    $("#save_new").click(function () {
        $("#role_hourly_rate").removeAttr("disabled");
        if (!sunmirCheck()) {
            return false;
        }
        return true;
    })

    function sunmirCheck(){
        var role_id = $("#role_id").val();
        if (role_id == "0" || role_id == "") {
            alert("请选择角色！");
            return false;
        }

        if ($("#rbRoleRate").is(":checked")) {
            var role_hourly_rate = $("#role_hourly_rate").val();
            if (role_hourly_rate == "") {
                alert("角色小时费率丢失，请重新选择");
                return false;
            }
        }
        if ($("#rbContractRate").is(":checked")) {
            var contract_hourly_rate = $("#contract_hourly_rate").val();
            if (contract_hourly_rate == "") {
                alert("请填写合同角色小时费率");
                return false;
            }
        }
        var block_hour_multiplier = $("#block_hour_multiplier").val();
        if (block_hour_multiplier=""){
            alert("请填写预付时间系数");
            return false;
        }

        return true;
    }
</script>
