<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfigType.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigType" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>配置项类型</title>
    <style>
        .Edit {
            cursor: pointer;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
            <!--顶部-->
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1">配置项类型</span>
                    <a href="###" class="help"></a>
                </div>
            </div>
            <!--按钮-->
            <div class="ButtonContainer header-title">
                <ul id="btn">
                    <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="Save_Close_Click" />
                    </li>
                    <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                        <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click" />
                    </li>
                </ul>
            </div>
            <!--切换项-->
            <div class="TabContainer" style="min-width: 700px;">
                <div class="DivSection" style="border: none; padding-left: 0;">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td width="50%" class="FieldLabels">配置项类型名称
                            <span class="errorSmall">*</span>
                                    <div style="padding-bottom: 10px;">
                                        <asp:TextBox ID="Config_name" runat="server" Style="width: 268px;"></asp:TextBox>
                                        <asp:CheckBox ID="Active" runat="server" />
                                        <span class="lblNormalClass" style="font-weight: normal;">激活</span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="FieldLabels">
                                    <div style="padding-bottom: 10px;">
                                        <span>Select the user-defined fields used by this Configuration Item Type:</span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="FieldLabels">
                                    <div style="padding-bottom: 10px;">
                                        <span style="font-weight: bold;">用户自定义字段</span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div style="width: 100%; margin-bottom: 10px;">
                    <div class="ButtonContainer">
                        <ul>
                            <li class="Button ButtonIcon NormalState" id="NewButton" tabindex="0">
                                <span class="Icon New"></span>
                                <span class="Text">新建</span>
                            </li>
                        </ul>
                    </div>
                    <div style="height: auto;">
                        <div style="width: 100%; overflow: hidden; position: absolute; z-index: 99; height: 40px;">
                            <table class="dataGridHeader" style="width: 100%; border-collapse: collapse; background: #fff;">
                                <tbody>
                                    <tr style="height: 24px;">
                                        <td align="center" style="width: 27px; background-color: #cbd9e4;"></td>
                                        <td align="center" style="width: 46px; background-color: #cbd9e4;">include</td>
                                        <td style="width: 200px; background-color: #cbd9e4;">
                                            <span>自定义字段名称</span>
                                        </td>
                                        <td align="center" style="width: 57px; background-color: #cbd9e4;">
                                            <span>必填</span>
                                        </td>
                                        <td align="center" style="width: 60px; background-color: #cbd9e4;">
                                            <span>保护 </span>
                                        </td>
                                        <td align="right" style="background-color: #cbd9e4;">
                                            <span>排序号
                                            </span>
                                        </td>
                                        <td style="width: 8.5px; visibility: hidden;"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div style="width: 100%; overflow: auto; z-index: 0; height: 700px;">
                            <table class="dataGridBody" cellspacing="0" style="width: 100%; border-collapse: collapse;">
                                <tbody>
                                    <tr class="dataGridHeader" style="height: 28px;">
                                        <td align="center" style="width: 27px;"></td>
                                        <td align="center" style="width: 1%;">include</td>
                                        <td style="width: 200px;">
                                            <span>自定义字段名称</span>
                                        </td>
                                        <td align="center" style="width: 57px;">
                                            <span>必填</span>
                                        </td>
                                        <td align="center" style="width: 60px;">
                                            <span>保护 </span>
                                        </td>
                                        <td align="right">
                                            <span>排序号
                                            </span>
                                        </td>
                                    </tr>
                                    <%foreach (var tr in GetAlludf)
                                        { %>
                                    <%foreach (var td in GetGroupudf)
                                        { %>

                                    <%} %>
                                    <tr class="dataGridBody">
                                        <td align="center">
                                            <img src="../Images/edit.png" class="Edit" />
                                        </td>
                                        <td style="text-align: center"></td>
                                        <td>
                                            <span class="www"><%=tr.col_comment %></span>
                                            <input type="hidden" value="<%=tr.id %>" />
                                        </td>
                                        <td align="center">
                                            <%if (tr.is_required > 0)
                                                { %>
                                            <img src="../Images/check.png" />
                                            <%} %>
                                        </td>
                                        <td align="center" class="check">
                                            <%if (tr.is_protected > 0)
                                                { %>
                                            <img src="../Images/check.png" />
                                            <%} %>
                                        </td>
                                        <td align="right">
                                            <span class="qqq"><%=tr.sort_order %></span>
                                        </td>
                                    </tr>
                                    <%} %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" id="UDFdata" name="UDFdata" />
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script>
            $(".Edit").on("click", function () {
                if ($(".dataGridBody").hasClass("rrr") == true) {
                    return;
                }
                var _this = $(this);
                _this.parent().parent().hide();
                var qqq = _this.parent().parent().find(".qqq").html();
                var www = _this.parent().parent().find(".www").html();
                var prote = _this.parent().parent().find(".check").html();
                var checked1 = '';
                var checked2 = '';
                if (_this.parent().parent().children().eq(1).find("img").length > 0) {
                    checked1 = "checked";
                }
                if (_this.parent().parent().children().eq(3).find("img").length > 0) {
                    checked2 = "checked";
                }
                var editor = $(
                    '<tr class="dataGridBody rrr">' +
                    '<td align="center">' +
                    '<img src="../Images/edit.png" alt="">' +
                    '</td>' +
                    '<td align="center">' +
                    '<span class="txtBlack8Class">' +
                    '<input type="checkbox" ' + checked1 + ' id="ch1">' +
                    '</span>' +
                    '</td>' +
                    '<td>' +
                    '<span>' + www + '</span>' +
                    '</td>' +
                    '<td align="center">' +
                    '<span class="txtBlack8Class">' +
                    '<input type="checkbox" ' + checked2 + ' id="ch2" disabled>' +
                    '</span>' +
                    '</td>' +
                    '<td align="center">' + prote +
                    '</td>' +
                    '<td align="right">' +
                    '<span class="txtBlack8Class">' +
                    '<input id="sort" class="eee" type="text" style="width: 150px;text-align:right;" disabled value=' + qqq + '>' +
                    '</span>' +
                    '</td>' +
                    '</tr>');
                var btn = $(
                    '<li class="Button ButtonIcon NormalState" id="OkButton" tabindex="0">' +
                    '<span class="Icon Ok"></span>' +
                    '<span class="Text" >Ok</span > ' +
                    '</li> ' +
                    '<li class="Button ButtonIcon NormalState" id= "CancelButton1" tabindex= "0"> ' +
                    '<span class="Icon Cancel" ></span > ' +
                    '<span class="Text">取消</span> ' +
                    '</li>');
                $("#OkButton").remove();
                $("#CancelButton1").remove();
                $("#NewButton").after(btn);
                _this.parent().parent().siblings("tr").remove(".rrr");
                _this.parent().parent().siblings("tr").show();
                _this.parent().parent().after(editor);
                $("#ch1").on("change",function(){
                    if ($("#ch1").is(':checked')) {
                        $("#ch2").removeAttr("disabled");
                        $("#sort").removeAttr("disabled");
                    } else {
                        $("#ch2").prop("disabled", "disabled");
                        $("#sort").prop("disabled", "disabled");
                    }
                });
                $("#OkButton").on("click", function () {
                    var eee = editor.find("input[type='text']").val();
                    if ($("#ch1").is(':checked')) {
                        _this.parent().parent().children().eq(1).html('');
                        _this.parent().parent().children().eq(1).append("<img src=\"../Images/check.png\" />");
                    } else {
                        _this.parent().parent().children().eq(1).html('');
                    }
                    if ($("#ch2").is(':checked')) {
                        _this.parent().parent().children().eq(3).html('');
                        _this.parent().parent().children().eq(3).append("<img src=\"../Images/check.png\" />");
                    } else {
                        _this.parent().parent().children().eq(3).html('');
                    }
                    _this.parent().parent().find(".qqq").html(eee);
                    _this.parent().parent().show();
                    editor.remove();
                    $("#OkButton").remove();
                    $("#CancelButton1").remove();
                });
                $("#CancelButton1").on("click", function () {
                    $("#OkButton").remove();
                    $("#CancelButton1").remove();
                    _this.parent().parent().show();
                    editor.remove()
                });
            });
            function save_deal() {
                var vendor = [];
                vendor.push("{\"UDFGROUP\":[");
                $(".dataGridBody").each(function () {
                    var _this = $(this);
                    if (_this.children().eq(1).find("img").length > 0) {
                        var id = _this.find("input[type='hidden']").val();
                        var is_required = 0;
                        if (_this.children().eq(3).find("img").length > 0) {
                            is_required = 1;
                        }
                        var sort_order = _this.find(".qqq").html();
                        var k = { "id": id, "is_required": is_required, "sort_order": sort_order };
                        var json = JSON.stringify(k);
                        console.log("delete:" + json);
                        vendor.push(json);
                    }

                });
                console.log(vendor);
                vendor.push("]}");
                $("#UDFdata").val('');
                $("#UDFdata").val($('<div/>').text(vendor).html());
            }
        </script>
    </form>
</body>
</html>
