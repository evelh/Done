<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContactGroupManage.aspx.cs" Inherits="EMT.DoneNOW.Web.Contact.ContactGroupManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link rel="stylesheet" type="text/css" href="../Content/multipleList.css" />
    <title><%=isAdd?"添加":"编辑" %>联系人组</title>
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
        <div class="header"><%=isAdd?"添加":"编辑" %>联系人组</div>
        <div class="header-title" style="width: 480px;">
            <ul>
                <li onclick="SaveClose()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>保存并关闭</li>
                <li onclick="javascript:window.close()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>取消</li>
            </ul>
        </div>
        <div class="DivSection NoneBorder">
            <div style="padding-right: 10px; padding-left: 10px; padding-bottom: 10px; padding-top: 10px">
                <span id="nameLabel" class="FieldLabel" style="font-weight: bold;">名称<font style="color: Red;"> *</font></span><br>
                <span id="nameTextbox" style="display: inline-block;">
                    <input name="name" type="text" maxlength="100" id="name" class="txtBlack8Class"  style="width: 300px;" value="<%=pageGroup!=null?pageGroup.name:"" %>" /></span>
            </div>
            <div style="padding-right: 10px; padding-left: 10px; padding-bottom: 10px; padding-top: 10px">
                <span class="txtBlack8Class">
                    <input id="activeCheckbox" type="checkbox" name="activeCheckbox" <%if (isAdd || (pageGroup != null && pageGroup.is_active == 1))
                        { %> checked="checked"<%} %> <%if (isAdd)
                        { %> disabled="disabled"<%} %> /><label for="activeCheckbox">激活</label></span>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script>
    function SaveClose() {
        var name = $("#name").val();
        if (name == "" || $.trim(name) == "") {
            LayerMsg("请填写名称");
            return false;
        }
        var isRepeat = "";
        $.ajax({
            type: "GET",
            url: "../Tools/ContactAjax.ashx?act=CheckGroupName&id=<%=pageGroup!=null?pageGroup.id.ToString():"" %>&name=" + name,
            async: false,
            dataType: "json",
            success: function (data) {
                if (!data) {
                    isRepeat = "1";
                }
            }
        })
        if (isRepeat == "1") {
            LayerMsg("名称重复，请重新输入！");
            return false;
        }
        var isCheck = "0";
        if ($("#activeCheckbox").is(":checked")) {
            isCheck = "1";
        }
        $.ajax({
            type: "GET",
            url: "../Tools/ContactAjax.ashx?act=GroupManage&id=<%=pageGroup!=null&&(!isAdd)?pageGroup.id.ToString():"" %>&name=" + name + "&isActive=" + isCheck,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("保存成功！");
                } else {
                    LayerMsg("保存失败！");
                }
                self.opener.location.reload();
                window.close();
            }
         })

    }
</script>
