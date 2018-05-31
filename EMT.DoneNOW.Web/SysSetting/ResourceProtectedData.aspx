<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResourceProtectedData.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.ResourceProtectedData" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>被保护权限设置</title>
    <style>
        .ShowData{
                font-size: 12px;
    color: #4F4F4F;
    font-weight: bold;
    line-height: 15px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
           <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">被保护权限设置</span>
            <a href="###" class="help"></a>
        </div>
    </div>
     <!--按钮-->
    <div class="ButtonContainer header-title">
        <ul id="btn">
            <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                保存并关闭
            </li>
            <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                取消
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:10px;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                       员工姓名
                        <span class="errorSmall"></span>
                        <div>
                           <label><%=thisRes!=null?thisRes.name:"" %></label>
                        </div>
                    </td>
                </tr>
                <tr >
                    <td width="30%" class="FieldLabels">
                       
                        <div>
                            <span class="ShowData">编辑保护数据</span>
                             <label><input type="checkbox" id="ckEditPro" <%if (thisRes != null && thisRes.edit_protected_data == 1) {%> checked="checked" <% } %> /></label>
                        </div>
                    </td>
                </tr>
                  <tr >
                    <td width="30%" class="FieldLabels">
                        <div>
                            <span class="ShowData">查看保护数据</span>
                             <label><input type="checkbox" id="ckViewPro" <%if (thisRes != null && thisRes.view_protected_data == 1) {%> checked="checked" <% } %>  /></label>
                        </div>
                    </td>
                </tr>
                   <tr >
                    <td width="30%" class="FieldLabels">
                        <div>
                            <span class="ShowData">编辑非保护数据</span>
                             <label><input type="checkbox" id="ckEditUnPro" <%if (thisRes != null && thisRes.edit_unprotected_data == 1) {%> checked="checked" <% } %> /></label>
                        </div>
                    </td>
                </tr>
                   <tr >
                    <td width="30%" class="FieldLabels">
                        <div>
                            <span class="ShowData">查看非保护数据</span>
                             <label><input type="checkbox" id="ckViewUnPro" <%if (thisRes != null && thisRes.view_unprotected_data == 1) {%> checked="checked" <% } %> /></label>
                        </div>
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
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        if ($("#ckEditPro").is(":checked")) {
            $("#ckViewPro").prop("disabled", true);
            $("#ckEditUnPro").prop("disabled", true);
            $("#ckViewUnPro").prop("disabled", true);
        }
        if ($("#ckViewPro").is(":checked") || $("#ckEditUnPro").is(":checked")) {
            $("#ckViewUnPro").prop("disabled", true);
        }
    })

    $("#ckEditPro").click(function () {
        if ($(this).is(":checked")) {
            $("#ckViewPro").prop("disabled", true);
            $("#ckViewPro").prop("checked", true);
            $("#ckEditUnPro").prop("disabled", true);
            $("#ckEditUnPro").prop("checked", true);
            $("#ckViewUnPro").prop("disabled", true);
            $("#ckViewUnPro").prop("checked", true);
        }
        else {
            $("#ckEditUnPro").prop("disabled", false);
            $("#ckViewPro").prop("disabled", false);
        }
    })
    $("#ckViewPro").click(function () {
        if (!$("#ckViewPro").is(":checked") && !$("#ckEditUnPro").is(":checked")) {
            $("#ckViewUnPro").prop("disabled", false);
        }
        else {
            $("#ckViewUnPro").prop("disabled", true);
            $("#ckViewUnPro").prop("checked", true);
        }
    })
    $("#ckEditUnPro").click(function () {
        if (!$("#ckViewPro").is(":checked") && !$("#ckEditUnPro").is(":checked")) {
            $("#ckViewUnPro").prop("disabled", false);
        }
        else {
            $("#ckViewUnPro").prop("disabled", true);
            $("#ckViewUnPro").prop("checked", true);
        }
    })

    $("#SaveClose").click(function () {
        var isEdit, isView, isEditUn, isViewUn = 0;
        if ($("#ckEditPro").is(":checked")) {
            isEdit = 1;
        }
        if ($("#ckViewPro").is(":checked")) {
            isView = 1;
        }
        if ($("#ckEditUnPro").is(":checked")) {
            isEditUn = 1;
        }
        if ($("#ckViewUnPro").is(":checked")) {
            isViewUn = 1;
        }
        
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ResourceAjax.ashx?act=ChangeUserDataProtected&id=<%=thisRes!=null?thisRes.id.ToString():"" %>&isEdit=" + isEdit + "&isView=" + isView + "&isEditUn=" + isEditUn + "&isViewUn=" + isViewUn,
            dataType: 'json',
            success: function (data) {
                if (data) {
                    LayerMsg("保存成功");
                }
                setTimeout(function () { window.close(); }, 800);
            },
        });
     })
</script>
