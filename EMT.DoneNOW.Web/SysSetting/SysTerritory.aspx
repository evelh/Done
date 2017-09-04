<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysTerritory.aspx.cs" Inherits="EMT.DoneNOW.Web.SysTerritory" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title>新增地域</title>
    <style>
    hr.separator {
        color: #b2d0f2;
        height: 1px;
    }
    .qqq{
        line-height:30px;
    }
    .qqq img{
        vertical-align: middle;
    }
</style>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增地域</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <asp:Button ID="Save_Close" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                <asp:Button ID="Save_New" runat="server" Text="保存并新建" BorderStyle="None" OnClick="Save_New_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
    <!--切换按钮-->
    <div class="TabBar">
        <a class="Button ButtonIcon SelectedState" id="tab1">
            <span class="Text">总结</span>
        </a>
        <a class="Button ButtonIcon" id="tab2">
            <span class="Text">资源</span>
        </a>
    </div>
    <div class="TabContainer Tab1">
        <div class="DivSection" style="border:none;padding-left:0;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            Name
                            <span class="errorSmall">*</span>
                            <div>
                                <asp:TextBox ID="Territory_Name" runat="server"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            Region
                            <div>
                                <asp:DropDownList ID="Region" runat="server"></asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            Description
                            <div>
                                <asp:TextBox ID="Territory_Description" runat="server"></asp:TextBox>
                            </div>
                        </td>

                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="TabContainer Tab2" style="display: none;">
        <div class="DivSection" style="border:none;padding-left:0;">
            <div class="ButtonCollectionBase" style="height:25px;">
                <ul>
                    <li class="Button ButtonIcon NormalState" id="NewButton1" tabindex="0">
                        <input type="button" id="New_Account" value="新增" style="border-style:None;"/>
                    </li>
                </ul>
            </div>
            <table>
                <tbody>
                    <tr colspan="2" class="ppp">
                        <hr class="separator" style="border-left: none;">
                    </tr>
                    <%foreach (var i in AccountList)
                        { %>
                    <tr class="qqq">
                        <td width="15" style="padding-left: 10px;">
                            <img class="delete" src="../Images/cancel.png" style="cursor: pointer;"/>
                            <input type="hidden" value="<%=i.id %>"/>
                        </td>
                        <td align="left" style="padding-top: 2px;padding-left: 10px;"><%=i.name %></td>
                    </tr>
                    <%} %>
                </tbody>
            </table> 
        </div>
    </div>
        </div>
        <input type="hidden" id="txtId" />
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
<%--    <script src="../Scripts/SysSettingRoles.js"></script>--%>
    <script>
        $("#SaveAndCloneButton").on("mouseover", function () {
            $("#SaveAndCloneButton").css("background", "#fff");
        });
        $("#SaveAndCloneButton").on("mouseout", function () {
            $("#SaveAndCloneButton").css("background", "#f0f0f0");
        });
        $("#SaveAndNewButton").on("mouseover", function () {
            $("#SaveAndNewButton").css("background", "#fff");
        });
        $("#SaveAndNewButton").on("mouseout", function () {
            $("#SaveAndNewButton").css("background", "#f0f0f0");
        });
        $("#CancelButton").on("mouseover", function () {
            $("#CancelButton").css("background", "#fff");
        });
        $("#CancelButton").on("mouseout", function () {
            $("#CancelButton").css("background", "#f0f0f0");
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
        //$.each($(".TabBar a"), function (i) {
        //    $(this).click(function () {
        //        $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
        //        $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
        //    })
        //});

        $.each($(".TabBar a"), function (i) {
            $(this).click(function () {
                var t = $("#Territory_Name").val();
                var r = $("#Region").val();
                if (t == null || t == '') {
                    alert("请填写地域名称后再跳转");

                    return false;

                }
                if (r == null || r <= 0) {
                    alert("请选择区域");

                    return false;
                } 
                $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
                $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
            })
        });

        $("#Save_Close").click(function () {
            var t = $("#Territory_Name").val();
            var r = $("#Region").val();
            if (t == null || t == '') {
                alert("请填写地域名称");
                return false;
            }
            if (r == null || r <= 0) {
                alert("请选择区域");
                return false;
            } });
        $("#Save_New").click(function () {
            var t = $("#Territory_Name").val();
            var r = $("#Region").val();
            if (t == null || t == '') {
                alert("请填写地域名称");
                return false;
            }
            if (r == null || r <= 0) {
                alert("请选择区域");
                return false;
            }
        });
        $("#New_Account").click(function () {
            window.open('TerritortAddAccount.aspx?id=<%=id%>', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TerritorySource %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        });
        function kkk() {
            returnValue = $("#txtId").val();
            console.log(returnValue);
            if (returnValue !== '' && returnValue !== undefined) {
                result = returnValue.replace(/'/g, '"');
                var obj = JSON.parse('[' + result + ']');
                for (var i = 0; i < obj.length; i++) {
                    $('.ppp').after(
                        $('<tr class="qqq">' +
                            '<td width="15" style="padding-left: 10px;">' +
                            '<img class="delete1" src="../Images/cancel.png" style="cursor: pointer;"/>' +
                            '<input type="hidden" value="' + obj[i].id + '"/>' +
                            '</td>' +
                            '<td align="left" style="padding-top: 2px;padding-left: 10px;">' + obj[i].name + '</td>' +
                            '</tr>')
                    )
                };
                $(".delete1").on("click", function () {
                    var name = $(this).parent().next().text();
                    var id = $(this).next().val();
                    var _this = $(this);
                    if (confirm('确认删除' + name + '?')) {
                        $.ajax({
                            type: "GET",
                            url: "../Tools/TerritoryAjax.ashx?act=delete&aid=" + id + "&tid=" +<%=id%>,
                                success: function (data) {
                                    if (data == "yes") {
                                        _this.parent().parent().remove();
                                    } else {
                                        alert("删除失败！");
                                    }
                                }
                            });
                        }
                    });
                }
        }

        $(".delete").on("click", function () {
            var name = $(this).parent().next().text();
            var id = $(this).next().val();
            var _this = $(this);
            if (confirm('确认删除' + name + '?')) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/TerritoryAjax.ashx?act=delete&aid=" + id + "&tid=" +<%=id%>,
                    success: function (data) {
                        if (data == "yes") {
                            _this.parent().parent().remove();
                        } else {
                            alert("删除失败！");
                        }
                    }
                });
            }
        });
    </script>
 </form>
</body>
</html>
