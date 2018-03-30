<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Newsubcategory.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.Newsubcategory" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <link rel="stylesheet" type="text/css" href="../Content/repository.css" />
    <title>知识库目录</title>
    <style>
        .header {
            height: 40px;
            line-height: 40px;
            background: #346A95;
            padding: 0 10px;
            font-size: 18px;
            color: #FFFFFF;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">知识库目录</div>
        <div class="heard">
            <ul>
                <li onclick="SaveClose()">
                    <img src="../Images/save.png" alt="" />
                    保存并关闭
                </li>
                <li onclick="SaveAdd()">
                    <img src="../Images/save.png" alt="" />
                    保存新增                
                </li>
                <li onclick="javascript:window.close();">
                    <img src="../Images/cancel.png" alt="" />
                    取消
                </li>
            </ul>
        </div>
        <div class="content" style="padding: 10px;">
            <input type="hidden" name="cateId" id="cateId" value="<%=thisCate!=null?thisCate.id.ToString():"" %>" />
            <p style="font-size: 12px; font-weight: bold; color: #4F4F4F; width: 100%;">名称<span style="color: red; margin-left: 5px;">*</span></p>
            <input type="text" id="name" name="name" style="width: 250px; box-sizing: border-box; height: 24px;" value="<%=thisCate!=null?thisCate.name:"" %>" />
            <p style="font-size: 12px; font-weight: bold; color: #4F4F4F; width: 100%; margin-top: 10px;">父级类别</p>
            <select name="parentcategory" id="parentcategory" style="width: 250px; height: 24px;">
                <%foreach (var i in cateList)
                    {
                        var temp = "";
                        for (int j = 0; j < i.leaval; j++)
                        {
                            temp += "&nbsp;&nbsp;&nbsp;";
                        }
                %>
                <option value="<%=i.id%>" <%if (chooseParentId == i.id)
                    { %>
                    selected="selected" <%} %>><%=temp %><%=i.name+"&nbsp;("+i.articleCnt+")"%></option>
                <%}%>
            </select>
        </div>
    </form>
</body>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    //表单
    var inputControl = {
        name: "name",
        parentcategory: "parentcategory",
    }
    function validateInput(name, errorMsg) {
        if ($("#" + name).val() == "") {
            layer.msg(errorMsg);
            return false;
        }
        else {
            return true;
        }
    }

    function Submit() {

        if (!validateInput(inputControl.name, "请填写名称")) {
            return false;
        }
        if (!validateInput(inputControl.parentcategory, "请选择父级类别")) {
            return false;
        }
        return true;
    }
    function SaveClose() {
        if (Submit()) {
            var cateId = $("#cateId").val();
            var parentId = $("#parentcategory").val();
            var name = $("#name").val();

            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/KnowledgeAjax.ashx?act=KnowMenuManage&id=" + cateId + "&parentId=" + parentId + "&name=" + $.trim(name),
                dataType:"json",
                success: function (data) {
                    if (data != "") {
                        if (data.result) {
                            LayerMsg("保存成功！");
                            setTimeout(function () { self.opener.location.reload(); window.close(); }, 800);
                        }
                        else {
                            LayerMsg("保存失败！"+data.reason);
                        }
                    }
                },
            });
        }

    }
    function SaveAdd() {
        if (Submit()) {
            var cateId = $("#cateId").val();
            var parentId = $("#parentcategory").val();
            var name = $("#name").val();

            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/KnowledgeAjax.ashx?act=KnowMenuManage&id=" + cateId + "&parentId=" + parentId + "&name=" + $.trim(name),
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.result) {
                            LayerMsg("保存成功！");
                            setTimeout(function () { self.opener.location.reload(); location.href = "Newsubcategory?parentId=" + parentId; }, 800);
                        }
                        else {
                            LayerMsg("保存失败！" + data.reason);
                        }
                    }
                },
            });
        }
    }
</script>
</html>
