<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewContactTemplate.aspx.cs" Inherits="EMT.DoneNOW.Web.Contact.NewContactTemplate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>保存模板</title>
    <style>
        li {
            list-style: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">保存模板</div>
        <div class="header-title" style="width: 480px;">
            <ul>
                <li onclick="SaveClose()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -128px -32px;" class="icon-1"></i>保存并关闭</li>
                <li onclick="javascript:window.close()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <div class="DivSection NoneBorder" style="padding: 0;margin-left:10px;">
            <span id="TemplateLabel" class="FieldLabel" style="font-weight: bold;">模板名称<font style="color: Red;"> *</font></span>
            <div>
                <div id="pnlDataSelector" style="padding-bottom: 0px">
                </div>
                <span id="TemplateNameATTextEdit" style="display: inline-block;">
                    <input type="text" maxlength="100" id="name" class="txtBlack8Class" style="width: 300px;" value="<%=thisTemp!=null?thisTemp.name:"" %>" /></span>
            </div>
            <span id="TemplateDescriptionLabel" class="FieldLabel" style="font-weight: bold;">描述</span>
            <div>
                <span id="" style="display: inline-block;">
                    <textarea name="" id="description" class="txtBlack8Class" maxlength="1000" style="height: 60px; width: 300px;"><%=thisTemp!=null?thisTemp.description:"" %></textarea></span>
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
        if (name == "") {
            LayerMsg("请填写名称！");
            return;
        }
        var isRepeat = "";

        $.ajax({
            type: "GET",
            url: "../Tools/ContactAjax.ashx?act=CheckTempName&name=" + name +"&tempId=<%=thisTemp!=null?thisTemp.id.ToString():"" %>",
            async: false,
            dataType: "json",
            success: function (data) {
                if (!data) {
                    isRepeat = "1";
                }
            }
        })

        if (isRepeat == "1") {
            LayerMsg("名称重复，请更改模板名称！");
            return;
        }

        var description = $("#description").val();
        <%if (isHasPar)
    { %>
        window.opener.SaveNewByName(name, description,"1");
        window.close();
        <%}
    else
    { %>
        $.ajax({
            type: "GET",
            url: "../Tools/ContactAjax.ashx?act=SaveActionTempShort&name=" + name + "&description=" + description+ "&tempId=<%=thisTemp!=null?thisTemp.id.ToString():"" %>",
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("保存成功！");
                }
                else {
                    LayerMsg("保存失败！");
                }
            }
        })
        setTimeout(function () {self.opener.location.reload();window.close(); },800);
        <%} %>
       
    }
</script>
