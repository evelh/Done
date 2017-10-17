<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InteralCostAddOrEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.InteralCostAddOrEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"修改" %>内部成本</title>
    <link rel="stylesheet" href="../Content/reset.css" />
    <style>
        body {
            overflow: hidden;
        }
        /*顶部内容和帮助*/
        .TitleBar {
            color: #fff;
            background-color: #346a95;
            display: block;
            font-size: 15px;
            font-weight: bold;
            height: 36px;
            line-height: 38px;
            margin: 0 0 10px 0;
        }

            .TitleBar > .Title {
                top: 0;
                height: 36px;
                left: 10px;
                overflow: hidden;
                position: absolute;
                text-overflow: ellipsis;
                text-transform: uppercase;
                white-space: nowrap;
                width: 97%;
            }

        .help {
            background-image: url(../Images/help.png);
            cursor: pointer;
            display: inline-block;
            height: 16px;
            position: absolute;
            right: 10px;
            top: 10px;
            width: 16px;
            border-radius: 50%;
        }
        /*保存按钮*/
        .ButtonContainer {
            padding: 0 10px 10px 10px;
            width: auto;
            height: 26px;
        }

            .ButtonContainer ul li .Button {
                margin-right: 5px;
                vertical-align: top;
            }

        li.Button {
            -ms-flex-align: center;
            align-items: center;
            background: #f0f0f0;
            background: -moz-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -webkit-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -ms-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%);
            border: 1px solid #d7d7d7;
            display: -ms-inline-flexbox;
            display: inline-flex;
            color: #4f4f4f;
            cursor: pointer;
            height: 24px;
            padding: 0 3px;
            position: relative;
            text-decoration: none;
        }

        .Button > .Icon {
            display: inline-block;
            flex: 0 0 auto;
            height: 16px;
            margin: 0 3px;
            width: 16px;
        }

        .Ok {
            background-image: url("../Images/save.png");
        }

        .Cancel {
            background-image: url("../Images/cancel.png");
        }

        .Button > .Text {
            flex: 0 1 auto;
            font-size: 12px;
            font-weight: bold;
            overflow: hidden;
            padding: 0 3px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        /*每一页*/
        .DivSection table {
            border-right: 0;
            padding-right: 0;
            border-top: 0;
            padding-left: 0;
            margin: 0;
            border-left: 0;
            border-bottom: 0;
        }

        td {
            font-size: 12px;
        }

        .FieldLabels, .workspace .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }

            .FieldLabels img {
                cursor: pointer;
            }

            .FieldLabels div {
                padding-top: 3px;
                padding-bottom: 20px;
            }

        .errorSmall {
            font-size: 12px;
            color: #E51937;
            margin-left: 3px;
            text-align: center;
        }

        input[type=text] {
            height: 22px;
            padding: 0 6px;
        }

        input[type="text"]:disabled, select:disabled, textarea:disabled {
            background-color: #f0f0f0;
            color: #6d6d6d;
            margin-right: 1px;
        }


        .step2LeftSelectWidth {
            width: 292px;
        }

        select {
            height: 24px;
            padding: 0;
        }

        .contentButton {
            line-height: 22px;
        }

            div.ButtonBar img.ButtonImg, .contentButton img.ButtonImg {
                margin: 4px 3px 0 3px;
            }

        .ButtonBar ul li img {
            border: 0;
        }

        .ButtonBar ul li a span.Text, .contentButton a span.Text, a.buttons span.Text, input.button span.Text {
            font-size: 12px;
            font-weight: bold;
            line-height: 26px;
            padding: 0 1px 0 3px;
            color: #4F4F4F;
            vertical-align: top;
        }

        .DivSection td[class="fieldLabels"] input[type=radio], .DivSection td[class="FieldLabels"] input[type=radio], .DivSection td[class="fieldLabels"] input[type=checkbox], .DivSection td[class="FieldLabels"] input[type=checkbox], .WizardSection td[class="fieldLabels"] input[type=radio], .WizardSection td[class="FieldLabels"] input[type=radio], .WizardSection td[class="fieldLabels"] input[type=checkbox], .WizardSection td[class="FieldLabels"] input[type=checkbox] {
            margin-right: 0;
            vertical-align: middle;
            margin-top: -2px;
            margin-bottom: 1px;
        }

        a:link, a:visited, .dataGridBody a:link, .dataGridBody a:visited {
            color: #376597;
            font-size: 12px;
            text-decoration: none;
        }

        .DivSection td {
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">内部成本-<%=contract.name %></span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <div class="ButtonContainer">
            <ul id="btn">
                <li class="Button ButtonIcon NormalState" id="OkButton" tabindex="0">
                    <span class="Icon Ok"></span>
                    <span class="Text">
                        <asp:Button ID="save" runat="server" Text="保存" OnClick="save_Click" Style="border: none; background: transparent; outline: none; cursor: pointer; font-weight: bold; color: #666;" /></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel"></span>
                    <span class="Text">取消</span>
                </li>
            </ul>
        </div>
        <div class="DivSection" style="border: none; padding-left: 0; margin-left: 20px;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="30%" class="FieldLabels">员工<span class="errorSmall">*</span>
                            <div style="font-weight: normal;">
                                <%
                                    EMT.DoneNOW.Core.sys_resource resource = null;
                                    if (!isAdd)
                                    {
                                        resource = new EMT.DoneNOW.DAL.sys_resource_dal().FindNoDeleteById(intCost.resource_id);
                                    }

                                %>
                                <input type="text" name="" id="resource_id" style="width: 278px; margin-right: 4px;" value="<%=resource==null?"":resource.name %>" />
                                <input type="hidden" name="resource_id" id="resource_idHidden" value="<%=isAdd?"":intCost.resource_id.ToString() %>" />
                                <img id="selectResource" src="../Images/data-selector.png" style="vertical-align: middle;" />
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td width="30%" class="FieldLabels">角色名称<span class="errorSmall">*</span>
                            <div>
                                <select name="role_id" id="role_id" class="step2LeftSelectWidth">
                                </select>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td width="30%" class="FieldLabels">小时成本（费率）<span class="errorSmall">*</span>
                            <div>
                                <input type="text" name="rate" id="rate" style="width: 278px; margin-right: 4px;" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isAdd?"":intCost.rate.ToString("#0.00") %>" />
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
    $(function () {
    <% if (!isAdd)
    { %>
      $("#resource_id").prop("disabled", true);
      $("#role_id").prop("disabled", true);
      GetRolesById();
      $("#role_id").val(<%=intCost.role_id %>);
    <%}
    else
    { %>
    $("#selectResource").click(function () {
        ResourceSelect();
    })
    <% }%>

    })
    $("#CancelButton").click(function () {
        window.close();
    })

    $("#save").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    $("#rate").blur(function () {
        var rate = $(this).val();
        if (!isNaN(rate)) {
            $(this).val(toDecimal2(rate));
        }
        else {
            $(this).val("");
        }
    })

    // 员工查找带回
    function ResourceSelect() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_CALLBACK %>&field=resource_id&callBack=GetRolesById", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ResourceSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 根据员工id获取到该员工所属的角色
    // sys_resource_department 员工和角色的关系表
    // 只选择类型为部门的角色  
    function GetRolesById() {
        var source_id = $("#resource_idHidden").val();
        if (source_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                // dataType: "json",
                url: "../Tools/RoleAjax.ashx?act=GetRoleList&source_id=" + source_id,
                success: function (data) {
                    if (data != "") {
                        $("#role_id").html(data);
                    }
                },
            });
        }
    }

    function SubmitCheck() {

        var resource_idHidden = $("#resource_idHidden").val();
        if (resource_idHidden == "") {
            alert("请通过查找带回选择员工！");
            return false;
        }// role_id  
        var role_id = $("#role_id").val();
        if (role_id == "0") {
            alert("请选择员工角色！");
            return false;
        }
        var rate = $("#rate").val();
        if (rate == "0") {
            alert("请填写费率！");
            return false;
        }
        debugger;
        var int_cost_id = '<%=intCost==null?"":intCost.id.ToString() %>';
        var contract_id = '<%=contract.id %>';
        var isSave = ""; // 是否可以保存
        $.ajax({
            type: "GET",
            async: false,
            dataType: "json",
            url: "../Tools/ContractAjax.ashx?act=CheckResRole&contract_id=" + contract_id + "&resource_id=" + resource_idHidden + "&role_id=" + role_id,
            success: function (data) {
                if (data != "") {
                    if (data.id == int_cost_id) {

                    } else {
                        isSave = "1";
                    }
                } else {
                    isSave = "";
                }
            },
        });
        if (isSave != "") {
            alert("合同内员工角色唯一，请检查后重试");
            return false;
        }
        return true;
    }

</script>
