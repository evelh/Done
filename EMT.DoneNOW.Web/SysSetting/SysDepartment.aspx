<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysDepartment.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.SysDepartment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title>部门管理</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">部门简介</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul>
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <asp:Button ID="Save_Close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <asp:Button ID="Cancle" runat="server" Text="取消"  BorderStyle="None" OnClick="Cancle_Click"/>
            </li>
        </ul>
    </div>
    <!--切换按钮-->
    <div class="TabBar">
        <a class="Button ButtonIcon SelectedState">
            <span class="Text">简介</span>
        </a>
        <a class="Button ButtonIcon">
            <span class="Text">资源</span>
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
                        <td align="left" width="30%">
                            部门名称
                            <span style="color:red;">*</span>
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="department_name" runat="server"  style="width:300px;" class="txtBlack8Class"></asp:TextBox>
                                </span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" width="30%">
                            Department Primary Location
                            <span style="color:red;">*</span>
                            <div>
                                <span style="display: inline-block">
                                    <asp:DropDownList ID="location" runat="server" AutoPostBack="True" OnSelectedIndexChanged="location_SelectedIndexChanged"></asp:DropDownList>
                                </span>
                                <asp:HyperLink ID="HyperLink1" runat="server" ImageUrl="~/Images/add.png" NavigateUrl="~/Company/LocationManage.aspx">HyperLink</asp:HyperLink><%--<img src="../Images/add.png" style="cursor: pointer;"/>--%>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" width="30%">
                            Department Number
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="department_no" runat="server"></asp:TextBox>
                                </span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" width="30%">
                            Department Description
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="Description" runat="server" style="height: 142px; width: 300px; margin-top: 0px; margin-bottom: 0px;" TextMode="MultiLine"></asp:TextBox>
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
                        <td align="left" width="30%">
                            Department Primary Location
                            <div>
                                <span style="font-weight:normal;height:50px;">
                                   <asp:Literal ID="location_name" runat="server"></asp:Literal>
                                </span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" width="30%">
                            Department Time Zone
                            <div>
                                <span style="font-weight:normal;" class="lblNormalClass">
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
        <div class="ButtonCollectionBase" style="height:25px;">
            <ul>
                <li class="Button ButtonIcon NormalState" id="NewButton" tabindex="0">
                    <span class="Icon New"></span>
                    <span class="Text">新建</span>
                </li>
                <li class="Button ButtonIcon NormalState" id="SaveButton" tabindex="0">
                    <span class="Icon Save"></span>
                    <span class="Text">保存</span>
                </li>
                <li class="Button ButtonIcon NormalState" id="CancelButton1" tabindex="0">
                    <span class="Icon Cancel"></span>
                    <span class="Text">取消</span>
                </li>
            </ul>
        </div>
        <div class="GridContainer">
            <div style="height: 832px; width: 100%; overflow: auto; z-index: 0;">
                <table class="dataGridBody" style="width:100%;border-collapse:collapse;">
                    <tbody>
                        <tr class="dataGridHeader">
                            <td>
                                <span>Resource Name</span>
                                <img src="../Images/down.png" alt="">
                            </td>
                            <td>Role Name</td>
                            <td align="center" style="width:1%;">Default Department and Role</td>
                            <td align="center" style="width:1%;">Department Lead</td>
                            <td align="center" style="width:1%;">Active</td>
                        </tr>
                        <tr class="dataGridBody" style="cursor: pointer;">
                            <td>
                                <span>ds, liude (inactive)</span>
                            </td>
                            <td><span>Engineer</span></td>
                            <td align="center"><img src="../Images/check.png"/></td>
                            <td align="center"><img src="../Images/check.png" style="display: none;"/></td>
                            <td align="center"><img src="../Images/check.png"/></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="TabContainer" style="display: none;">
        <div class="ButtonCollectionBase" style="height:25px;">
            <ul>
                <li class="Button ButtonIcon NormalState" id="NewButton1" tabindex="0">
                    <span class="Icon New"></span>
                    <span class="Text">新建</span>
                </li>
            </ul>
        </div>
        <div class="GridContainer">
            <div style="height: 832px; width: 100%; overflow: auto; z-index: 0;">
                <table class="dataGridBody" style="width:100%;border-collapse:collapse;">
                    <tbody>
                    <tr class="dataGridHeader" style="height: 39px;">
                        <td>
                            <span>Work Type Name</span>
                            <img src="../Images/down.png" alt=""/>
                        </td>
                        <td>External Number</td>
                        <td>General Ledger Account</td>
                        <td align="center" style="width:1%;">Non-Billable</td>
                    </tr>
                    <tr class="dataGridBody" style="cursor: pointer;">
                        <td>
                            <span>work type test1</span>
                        </td>
                        <td><span>7</span></td>
                        <td></td>
                        <td align="center"></td>
                    </tr>
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
        $("#NewButton").on("mouseover",function(){
            $("#NewButton").css("background","#fff");
        });
        $("#NewButton").on("mouseout",function(){
            $("#NewButton").css("background","#f0f0f0");
        });
        $("#SaveButton").on("mouseover",function(){
            $("#SaveButton").css("background","#fff");
        });
        $("#SaveButton").on("mouseout",function(){
            $("#SaveButton").css("background","#f0f0f0");
        });
        $("#CancelButton1").on("mouseover",function(){
            $("#CancelButton1").css("background","#fff");
        });
        $("#CancelButton1").on("mouseout",function(){
            $("#CancelButton1").css("background","#f0f0f0");
        });
        $("#NewButton1").on("mouseover",function(){
            $("#NewButton1").css("background","#fff");
        });
        $("#NewButton1").on("mouseout",function(){
            $("#NewButton1").css("background","#f0f0f0");
        });
    </script>
</html>
