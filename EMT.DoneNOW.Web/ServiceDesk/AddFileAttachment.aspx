<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddFileAttachment.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.AddFileAttachment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="../Content/repository.css" />

    <title></title>
</head>
<body style="min-width: 400px;">
    <form id="form1" runat="server">
            <div class="heard">
        <ul>
            <li onclick="Submit()">
                <img src="../Images/save.png" alt="" />
                保存并关闭
            </li>
            <li>
                <img src="../Images/save.png" alt=""  />
                保存新增                
            </li>
            <li>
                <img src="../Images/cancel.png" alt=""  />
                取消
            </li>
        </ul>
    </div>
    <div class="content" style="padding: 10px;"> 
        <p style="font-size: 12px;font-weight: bold;color: #4F4F4F;width: 320px;">类型</p>
        <select name="Active" id="Active" style="width: 320px;height: 24px;">
            <option value=""></option>
            <option value="3">Internal Users &amp; Named Company</option>
            <option value="4">Internal Users &amp; Named Classification</option>
            <option value="5">Internal Users &amp; Named Territory</option>
       
        
        </select>
         <p style="font-size: 12px;font-weight: bold;color: #4F4F4F;width:320px;margin-top:10px;">文件<span style="color: red;margin-left: 5px;">*</span></p>
        <input type="file" name="file"  />
        <p style="font-size: 12px;font-weight: bold;color: #4F4F4F;width:320px;margin-top:10px;">名称<span style="color: red;margin-left: 5px;">*</span></p>
        <input type="text" name="name" id="name"  style="width: 320px;box-sizing: border-box;height: 24px;"  />
        
    </div>
    </form>
</body>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    //表单
    var inputControl = {
        name: "name",
        Active: "Active",
        file: "file",
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
        console.log($("#" + inputControl.Active).val())
        if ($("#" + inputControl.Active).val() == "") {
            layer.msg("请选择类型");
            return false;
        }
        if (!validateInput(inputControl.name, "请填写名称")) {
            return false;
        }
        if (!validateInput(inputControl.file, "请选择文件")) {
            return false;
        }
    }
</script>
</html>
