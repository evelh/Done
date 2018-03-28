<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Editsubcategory.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.Editsubcategory" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="../Content/repository.css" />

    <title></title>
</head>
<body>
    <form id="form1" runat="server">
           <div class="heard">
        <ul>
           <li>
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

        <p style="font-size: 12px;font-weight: bold;color: #4F4F4F;width: 100%;">名称<span style="color: red;margin-left: 5px;">*</span></p>
        <input type="text" id="name" name="name" style="width: 250px;box-sizing: border-box;height: 24px;" />
        <p style="font-size: 12px;font-weight: bold;color: #4F4F4F;width: 100%;margin-top:10px;">父级类别</p>
        <select name="parentcategory" id="parentcategory" style="width: 250px;height: 24px;">

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
    }
</script>
</html>
