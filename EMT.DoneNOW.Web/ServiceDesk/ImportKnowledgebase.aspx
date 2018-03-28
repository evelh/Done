<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ImportKnowledgebase.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.ImportKnowledgebase" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" type="text/css" href="../Content/repository.css" />
     
        <style>
        a:hover{text-decoration: underline;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
            <div class="heard">
        <ul>
            <li>
                上传                
            </li>
            <li>
                <img src="../Images/cancel.png" alt="" />
                取消
            </li>
        </ul>
    </div>
    <div class="content" style="padding: 10px;"> 
        <p style="font-size: 12px;color: #666;line-height: 16px;">
            从csv文件中导入文章。文件布局应该是“文章标题、文章细节、类别（可选）”。如果您希望导入类别，将每个子类别与“大于”（例如，“硬件-打印机-激光”）分开。<a style='color:#376597;cursor: pointer'>下载导入模板</a>
        </p>

        <input type="file" id="file" name="file" value="选择文件" style="margin-top:30px;" />
        <p style="font-size: 12px;color: #666;font-weight: bold;margin-top:20px;">将所有文章导入：发布到</p>
        <select name="importPublish" id="importPublish" style="width:280px;"></select>

        <div style="margin-top:20px;font-size: 12px;">
            <input type="checkbox" id="active" name="active" style="float: left;margin-top:2px;margin-right:5px;" />
            激活
        </div>
        <p style="font-size: 12px;color: #666;font-weight: bold;margin-top:20px;">如果文章类别不存在：</p>
        <div style="font-size: 12px;">
            <p style="margin-top:10px;">
                <input type="radio" name="article1" id="article1" style="float: left;margin-top:2px;margin-right:5px" />
               导入到根目录
            </p>
            <p  style="margin-top:10px;">
                <input type="radio" name="article2" id="article2" style="float: left;margin-top:2px;margin-right:5px"/>
                创建新的目录
            </p>
            <p  style="margin-top:10px;">
                <input type="radio" name="article3" id="article3" style="float: left;margin-top:2px;margin-right:5px"/>
               不导入此文档
            </p>
        </div>
    </div>
    </form>
</body>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    //表单
    var inputControl = {
        file: "file",
        importPublish: "importPublish",
        active: "active",
        article1: "article1",
        article2: "article2",
        article3: "article3",
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

        if (!validateInput(inputControl.importPublish, "请选择导入对象")) {
            return false;
        }
        if (!validateInput(inputControl.parentcategory, "请选择父级类别")) {
            return false;
        }
    }
</script>
</html>
