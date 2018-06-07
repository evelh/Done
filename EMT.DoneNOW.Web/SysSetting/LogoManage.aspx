<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogoManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.LogoManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server"  enctype="multipart/form-data">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1"><%=thisGeneral!=null?thisGeneral.name:"" %></span>
                <a href="###" class="help"></a>
            </div>
        </div>
          <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                    
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
                       选择图片 <span style="color:red;">*</span>
                        <span class="errorSmall"></span>
                        <div>
                           <input type="file" name="file" id="file" />
                        </div>
                    </td>
                </tr>
                
            </tbody>
        </table>
    </div>
    </form>
</body>
</html>
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="../Scripts/common.js"></script>
<script>
    $("#file").change(function () {
        debugger;
        var f = document.getElementById("file").files;
        if (f[0].size > Number(10 * 1024 * 1024)) {
            LayerMsg("上传文件不能大于10M!");
            $(this).val("");
            return;
        }
    })
</script>
