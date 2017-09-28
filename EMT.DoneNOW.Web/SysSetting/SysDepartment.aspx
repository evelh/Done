<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysDepartment.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.SysDepartment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>部门</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!--顶部-->
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1">部门</span>
                    <a href="###" class="help"></a>
                </div>
            </div>
            <!--按钮-->
            <div class="ButtonContainer header-title">
                <ul>
                    <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <asp:Button ID="Save_Close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="Save_Close_Click" />
                    </li>
                    <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                        <asp:Button ID="Cancle" runat="server" Text="取消" BorderStyle="None" OnClick="Cancle_Click" />
                    </li>
                </ul>
            </div>
            <!--切换按钮-->
            <div class="TabBar">
                <a class="Button ButtonIcon SelectedState">
                    <span class="Text">部门</span>
                </a>
                <a class="Button ButtonIcon">
                    <span class="Text">员工</span>
                </a>
                <a class="Button ButtonIcon">
                    <span class="Text">工作类型</span>
                </a>
            </div>
            <!--切换项-->
            <div class="TabContainer">
                <div class="DivSection Tab">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" ChildrenAsTriggers="True">
                        <ContentTemplate>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <asp:ScriptManager ID="ScriptManager1" runat="server">
                                </asp:ScriptManager>
                                <tbody>
                                    <tr>
                                        <td align="left" width="30%">部门名称
                            <span style="color: red;">*</span>
                                            <div>
                                                <span style="display: inline-block">
                                                    <asp:TextBox ID="department_name" runat="server" Style="width: 300px;" class="txtBlack8Class"></asp:TextBox>
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="standard_label">
                                            <span class="lblNormalClass">主区域<span style="color: red;">*</span></span>
                                            <div>
                                                <span style="display: inline-block">
                                                    <asp:DropDownList ID="location" runat="server"></asp:DropDownList>
                                                </span>
                                                <!--添加主要位置-->
                                                <img src="../Images/add.png" onclick="alert('后期开发！');" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" width="30%">部门编号
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="department_no" runat="server"></asp:TextBox>
                                </span>
                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" width="30%">描述
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="Description" runat="server" Style="height: 142px; width: 300px; margin-top: 0px; margin-bottom: 0px;" TextMode="MultiLine"></asp:TextBox>
                                </span>
                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            </div>
        <div class="DivSection">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td align="left" width="30%">主要办公位置
                            <div>
                                <span style="font-weight: normal; height: 50px;">
                                    <asp:Literal ID="location_name" runat="server"></asp:Literal>
                                </span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" width="30%">时区
                            <div>
                                <span style="font-weight: normal;" class="lblNormalClass">
                                    <asp:Literal ID="time_zone" runat="server"></asp:Literal>
                                </span>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>


            <div class="TabContainer" style="display: none;">
               <%-- <div class="ButtonCollectionBase header-title" style="height: 25px;">
                    <ul>
                        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                            <span class="Text">新建</span>
                        </li>
                        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                            <span class="Text">保存</span>
                        </li>
                        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                            <span class="Text">取消</span>
                        </li>
                    </ul>
                </div>--%>
                <div class="GridContainer">
                    <div style="height: 832px; width: 100%; overflow: auto; z-index: 0;">
                        <table class="dataGridBody" style="width: 100%; border-collapse: collapse;">
                            <tbody>
                                <tr class="dataGridHeader">
                                    <td>
                                        <span>员工姓名</span>
                                       <%-- <img src="../Images/down.png" alt="">--%>
                                    </td>
                                    <td>角色名称</td>
                                    <td align="center" style="width: 20%;">默认部门和角色</td>
                                    <td align="center" style="width: 20%;">部门主管</td>
                                    <td align="center" style="width: 20%;">激活</td>
                                </tr>

                                <%@ Import Namespace="System.Data" %>
                                <%foreach (DataRow tr in table.Rows)
                                    {%>
                                <tr class="dataGridBody" style="cursor: pointer;">
                                    <td align="center"><%=tr[1] %></td>
                                    <td align="center"><%=tr[2] %></td>
                                    <td align="center"><%=tr[3] %></td>
                                    <td align="center"><%=tr[4] %></td>
                                    <td align="center"><%=tr[5] %></td>
                                </tr>

                                <%}%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="TabContainer" style="display: none;">
               <%-- <div class="ButtonCollectionBase header-title" style="height: 25px;">
                    <ul>
                        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                            <span class="Text">新建</span>
                        </li>
                    </ul>
                </div>--%>
                <div class="GridContainer">
                    <div style="height: 832px; width: 100%; overflow: auto; z-index: 0;">
                        <table class="dataGridBody" style="width: 100%; border-collapse: collapse;">
                            <tbody>
                                <tr class="dataGridHeader" style="height: 39px;">
                                    <td style="width: 25%;">
                                        <span>工作类型名称</span>
                                        <%--<img src="../Images/down.png" alt="" />--%>
                                    </td>
                                    <td style="width: 25%;">外部码</td>
                                    <td style="width: 25%;">总账代码</td>
                                    <td align="center" style="width: 25%;">不计费的</td>
                                </tr>
                                <% foreach (DataRow tr in worktable.Rows)
                                    {%>
                                <tr class="dataGridBody" style="cursor: pointer;">
                                    <td><%=tr[1] %></td>
                                    <td><%=tr[2] %></td>
                                    <td><%=tr[3] %></td>
                                    <td align="center"><%=tr[4] %></td>
                                </tr>
                                <%} %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/SysSettingRoles.js"></script>
<script type="text/javascript">
    $("#Save_Close").click(function () {
        var name = $("#department_name").val();
        if (name == null || name == '') {
            alert("请填写部门名称");
            return false;
        }
    });
    $("#NewButton").on("mouseover", function () {
        $("#NewButton").css("background", "#fff");
    });
    $("#NewButton").on("mouseout", function () {
        $("#NewButton").css("background", "#f0f0f0");
    });
    $("#SaveButton").on("mouseover", function () {
        $("#SaveButton").css("background", "#fff");
    });
    $("#SaveButton").on("mouseout", function () {
        $("#SaveButton").css("background", "#f0f0f0");
    });
    $("#CancelButton1").on("mouseover", function () {
        $("#CancelButton1").css("background", "#fff");
    });
    $("#CancelButton1").on("mouseout", function () {
        $("#CancelButton1").css("background", "#f0f0f0");
    });
    $("#NewButton1").on("mouseover", function () {
        $("#NewButton1").css("background", "#fff");
    });
    $("#NewButton1").on("mouseout", function () {
        $("#NewButton1").css("background", "#f0f0f0");
    });
</script>
</html>
