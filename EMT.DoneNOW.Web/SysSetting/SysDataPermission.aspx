<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysDataPermission.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.SysDataPermission" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
     <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>被保护数据权限设置</title>
</head>
<body style="background-color:white">
    <form id="form1" runat="server" method="post">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title" style="top:5px">
  <div class="TitleBarNavigationButton">
                    <a class="Button ButtonIcon NormalState" id="black"  href="../SysSetting/SysAdmin" target="PageFrame"><img src="../Images/move-left.png"/></a>
                </div>
            <span class="text2">受保护的数据的权限</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer header-title">
        <ul>
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <asp:Button ID="Save" runat="server" Text="保存"  BorderStyle="None" OnClick="Save_Click"/>
            </li>

            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <asp:Button ID="Cancle" runat="server" Text="取消"  BorderStyle="None" OnClick="Cancle_Click"/>
            </li>
        </ul>
    </div>
    <!--搜索内容-->
    <div class="GridContainer ">
        <div style="width: 100%; overflow: auto; height: 827px; z-index: 0;">
            <table class="dataGridBody" style="width:100%;border-collapse:collapse;">
                <tbody>
                    <tr class="dataGridHeader">
                        <td>
                            <a style="font-weight:bold;">员工姓名</a>
                        </td>
                        <td align="center">编辑保护数据</td>
                        <td align="center">查看保护数据</td>
                        <td align="center">编辑未保护数据</td>
                        <td align="center">查看未保护数据</td>
                    </tr>
                    <%foreach (var i in resourcelist)
                        {%>
                    <tr class="dataGridBody">
                        <td>
                            <span><%=i.name%></span>
                        </td>
                        <td align="center">
                        <span><input type="checkbox" id="<%="edit_protected_data"+i.id %>" name="<%="edit_protected_data"+i.id %>" style="vertical-align:middle;" <%if (i.edit_protected_data == 1)
                                  { %> checked="checked"
                            <%} %>/></span>                                                   
                        </td>
                        <td align="center">
                           <span><input type="checkbox" id="<%="view_protected_data"+i.id %>" name="<%="edit_protected_data"+i.id %>" style="vertical-align:middle;" <%if (i.view_protected_data == 1)
                                  { %> checked="checked"
                            <%} %>/></span>  
                        </td>
                        <td align="center">
                           <span><input type="checkbox" id="<%="edit_unprotected_data"+i.id %>" name="<%="edit_protected_data"+i.id %>" style="vertical-align:middle;" <%if (i.edit_unprotected_data == 1)
                                  { %> checked="checked"
                            <%} %>/></span>  
                        </td>
                        <td align="center">
                           <span><input type="checkbox" id="<%="view_unprotected_data"+i.id %>" name="<%="edit_protected_data"+i.id %>" style="vertical-align:middle;" <%if (i.view_unprotected_data == 1)
                                  { %> checked="checked"
                            <%} %>/></span>  
                        </td>
                        </tr>
                    <%} %>
                </tbody>
            </table>
        </div>
    </div>
        </div>
        <input id="data" type="hidden" name="data" value=""/>
    </form>
     <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/SysSettingRoles.js"></script>
    <script>
        $("#Save").click(function () {
            var data = [];
            data.push("{\"permission\":[");
             <% foreach (var i in resourcelist) {%>
            var id =<%=i.id%>;
            if ($("#<%="edit_protected_data" + i.id%>").is(':checked')) {
                var k1 = "yes";
            }
            else {
                var k1 ="no";
            }
            if ($("#<%="view_protected_data" + i.id%>").is(':checked')) {
                var k2 = "yes";
            } else {
                var k2 = "no";
            }
            if ($("#<%="edit_unprotected_data" + i.id%>").is(':checked')) {
                var k3 = "yes";
            } else {
                var k3 = "no";
            }
            if ($("#<%="view_unprotected_data" + i.id%>").is(':checked')) {
                var k4 = "yes";
            } else {
                var k4 = "no";
            }
            var ch = {"id":"id"+id,"edit_protected_data": k1,"view_protected_data": k2,"edit_unprotected_data": k3,"view_unprotected_data": k4 };
            var jsonArrayFinal = JSON.stringify(ch);
            data.push(jsonArrayFinal);
            <%}%>
            data.push("]}");
            $("#data").val(data);
        });
      
    </script>
</body>
</html>
