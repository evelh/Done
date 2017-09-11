<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountClassView.aspx.cs" Inherits="EMT.DoneNOW.Web.AccountClassView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/ClassificationIcons.css" rel="stylesheet" />
    <title></title>
        <style type="text/css">
      #menu { position: absolute;z-index: 999;display: none;}
#menu ul{margin: 0 ;padding: 0;position: relative;width: 150px;border: 1px solid gray;background-color: #F5F5F5;padding: 10px 0;}
#menu ul li{padding-left: 20px;height: 25px;line-height: 25px;cursor:pointer;}
#menu ul li ul {display: none; position: absolute;right:-150px;top: -1px;background-color: #F5F5F5;min-height: 90%;}
#menu ul li ul li:hover{background: #e5e5e5;}
#menu ul li:hover{background: #e5e5e5;}
#menu ul li:hover ul {display: block;}
#menu ul li .menu-i1{width: 20px;height: 100%;display: block;float: left;}
#menu ul li .menu-i2{width: 20px;height: 100%;display: block;float: right;}
#menu ul .disabled{color: #AAAAAA;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <div class="TitleBarNavigationButton">
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/SysSetting/SysAdmin.aspx" class="buttons"><img src="../Images/move-left.png"/></asp:HyperLink>
            </div>
            <span class="text1">客户类别</span>
            <a href="###" class="collection"></a>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="AddButton" onclick="creat()" tabindex="0">
                <span class="Icon Add"></span>
                <span class="Text">新增客户类别</span>
            </li>
        </ul>
    </div>
    <div class="ScrollingContainer ContainsGrid Active" style="top: 82px; bottom: 0;">
        <div class="Grid Small">
            <div class="HeaderContainer">
                <table cellpadding="0">
                    <tbody>
                        <tr class="HeadingRow">
                            <td class="Interaction DragEnabled" style="width:58px;">
                                <div class="Standard"></div>
                            </td>
                            <td class="Context" style="width:23px;">
                                <div class="Standard"></div>
                            </td>
                            <td class="XL Text" style="width:190px;">
                                <div class="Standard">
                                    <div class="Heading">名称</div>
                                </div>
                            </td>
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading">描述</div>
                                </div>
                            </td>
                            <td class="Boolean" style="width:70px;">
                                <div class="Standard">
                                    <div class="Heading">激活</div>
                                </div>
                            </td>
                            <td class="Boolean" style="width:70px;">
                                <div class="Standard">
                                    <div class="Heading">系统</div>
                                </div>
                            </td>
                            <td style="width:6px;"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="RowContainer BodyContainer Active" style="top: 27px; bottom: 0px;">
                <table cellpadding="0">
                    <tbody>
                        <%foreach (var td in aclist)
                            { %>
                       <tr title="右键显示操作菜单" data-val="<%=td.id %>" class="dn_tr">
                            <td class="Interaction U0" style="width:59px;">                                 
                                <div style="text-align:center;">
                                    <div class="Decoration Icon DragHandle prev">
                                        <img src="../Images/prev.png" />
                                    </div>
                                    <div class="Decoration Icon DragHandle next">
                                        <img src="../Images/next.png" />
                                    </div>
                                    <div class="Text Sort">1</div>
                                </div>
                            </td>
                            <td class="Image U2" style="width:29px;">
                                <img src="<%=td.icon_path %>" />
                            </td>
                            <td class="Text XL U3" style="width:192px;">
                               <%=td.name %>
                            </td>
                            <td class="Text U4" style="width:auto;">
                                <%=td.remark %>
                            </td>
                            <td  class="Boolean U5" style="width:72px;text-align:center">
                                 <%if (Convert.ToInt32(td.status_id) > 0)
                                     {%>
                                    <img src="../Images/check.png" />
                                 <%} %>
                            </td>
                            <td  class="Boolean U6" style="width:72px;text-align:center">
                                 <%if (Convert.ToInt32(td.is_system) > 0)
                                     {%>
                                    <img src="../Images/check.png" />
                                 <%} %>                               
                            </td>
                        </tr>

                        <%} %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
            <%--右键菜单--%>
 <div id="menu">
        <%if (contextMenu.Count > 0) { %>
		<ul style="width:220px;">
            <%foreach (var menu in contextMenu) { %>
            <li id="<%=menu.id %>" onclick="<%=menu.click_function%>"><i class="menu-i1"></i><%=menu.text %>
            </li>
            <%} %>
		</ul>
        <%} %>
	</div>
</div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/ClassificationIcons.js"></script>
    <script src="../Scripts/Common/SearchBody.js" type="text/javascript" charset="utf-8"></script>
    <script>
        function create() {
            window.open('AccountClass.aspx', window, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open('AccountClass.aspx?id=' + entityid, window, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }


        function Delete() {
            if (confirm('删除操作将不能恢复，是否继续?')) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/AccountClassAjax.ashx?act=delete_validate&id=" + entityid,
                    success: function (data) {
                        if (data == "system") {
                            alert("系统默认不能删除！");
                            return false;
                        } else if (data == "other") {
                            alert("其他原因使得删除失败！");
                        } else {
                            if (confirm(data)) {
                                if (confirm(data)) {
                                    $.ajax({
                                        type: "GET",
                                        url: "../Tools/AccountClassAjax.ashx?act=delete&id=" + entityid,
                                        success: function (data) {
                                            alert(data);
                                        }
                                     });
                                 } else {
                                     return false;
                                 }
                            }
                        }
                    }
                });
            }
            window.location.reload();
        }
        function Active() {
                $.ajax({
                    type: "GET",
                    url: "../Tools/AccountClassAjax.ashx?act=active&id=" + entityid,
                    success: function (data) {
                        alert(data);
                    }
                });
            window.location.reload();
        }
        function NoActive() {
                $.ajax({
                    type: "GET",
                    url: "../Tools/AccountClassAjax.ashx?act=noactive&id=" + entityid,
                    success: function (data) {
                        alert(data);
                    }
                });
            window.location.reload();
        }
    </script>
</body>
</html>
