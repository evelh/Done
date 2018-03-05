<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditServiceAlert.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.EditServiceAlert" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>编辑服务</title>
    <style>
        
    </style>
</head>
<body>
    <div>
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">编辑服务</span>
            </div>
        </div>
        <div class="ButtonContainer header-title" style="margin: 0;">
            <ul id="btn">
                <li id="saveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <input type="button" value="保存并关闭" style="width: 68px;" />
                </li>
                <li id="Close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <input type="button" value="取消" style="width: 30px;" />
                </li>
            </ul>
        </div>
        <div style="padding-left:10px;">
            <%if (msg1)
                { %>
            <p id="msg1">您正在更改服务的单元价格，如果这些服务被定期服务合同或服务包引用，则这些合同/服务包将不会更新。</p>
            <%} %>
            <%if (msg2)
                { %>
            <p id="msg2">您正在更改服务的供应商/单位成本，如果您想将这些更改应用于包含此服务的现有合同，请在下面进行相应的选择。</p> <%} %>
            <table>
                <tbody>
                    <tr>
                        <td valign="top">
                            <input type="checkbox" name="chkUpdateNonPosted" id="chkUpdateNonPosted" />
                        </td>
                        <td style="padding-bottom: 10px;">更新现有合同中的未审批并提交的服务的供应商/单位成本，从以下日期起生效：<br />
                            <input type="text" name="EffectiveDate" id="EffectiveDate" size="12"  value="07/02/2018" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <span name="updatePostedServices" id="updatePostedServices">
                                <input type="checkbox" name="chkUpdate" id="chkUpdate" />
                            </span>
                        </td>
                        <td valign="middle">
                            <span>同时更新已审批并提交的服务的供应商/单位成本</span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $("#Close").click(function () {
        window.close();
    })

    $("#saveClose").click(function () {
        window.opener.document.getElementById("isUpdate").value = "1";
        if ($("#chkUpdateNonPosted").is(":checked"))
        {
            window.opener.document.getElementById("isUpdateNoAppCost").value = "1";
            window.opener.document.getElementById("updateDate").value = $("#EffectiveDate").val();
        }
        else
        {
            window.opener.document.getElementById("isUpdateNoAppCost").value = "";
            window.opener.document.getElementById("updateDate").value = "";
        }
        if ($("#chkUpdate").is(":checked"))
        {
            window.opener.document.getElementById("isUpdateAppCost").value = "1";
        }
        else
        {
            window.opener.document.getElementById("isUpdateAppCost").value = "";
        }
        // window.opener.document.getElementById("form1").submit();
        $("#form1", window.opener.document).submit();
        window.close();
    })

</script>
