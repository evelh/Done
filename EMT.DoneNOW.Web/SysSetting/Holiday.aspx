<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Holiday.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.Holiday" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><%if (isAdd)
               { %>新增<%}
                         else
                         { %>编辑<%} %></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
    <div class="header">
        <%if (isAdd)
            { %>新增<%}
                      else
                      { %>编辑<%} %>
    </div>
    <div class="header-title" style="min-width: 700px;">
        <ul>
            <li id="SaveClose">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <input type="button" value="保存并关闭" />
            </li>
            <li id="Cancle">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <input type="button" value="取消" />
            </li>
        </ul>
    </div>
    <form id="form1" runat="server">
        <div style="width:400px;margin-top:20px">
            <table border="none" cellspacing="" cellpadding="" style="border:0;">
                <tr>
                    <td>
                        <div class="clear" style="margin-bottom:5px;">
                            <label>名称<span style="color: red;">*</span></label>
                            <input type="text" id="holidayName" name="holidayName" <%if (!string.IsNullOrEmpty(name))
                                { %> value="<%=name %>" <%} %> />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear" style="margin-bottom:5px;">
                            <label>日期<span style="color: red;">*</span></label>
                            <input type="text" class="Wdate" onclick="WdatePicker()" id="hd" name="hd" <%if (date != null)
                                { %> value="<%=date.Value.ToString("yyyy-MM-dd") %>" <%} %> />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear" style="margin-bottom:5px;">
                            <label>说明<span style="color: red;">*</span></label>
                            <select name="type" style="width:172px;">
                                <option value="1">工作日设置为休息日</option>
                                <option value="2">休息日设置为工作日</option>
                            </select>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js"></script>
    <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script>
        $.each($(".nav-title li"), function (i) {
            $(this).click(function () {
                $(this).addClass("boders").siblings("li").removeClass("boders");
                $(".content").eq(i).show().siblings(".content").hide();
            })
        });
        $("#SaveClose").click(function () {
            if ($("#holidayName").val() == "") {
                LayerMsg("请输入名称");
                return;
            }
            if ($("#hd").val() == "") {
                LayerMsg("请输入日期");
                return;
            }
            $("#form1").submit();
        })
        $("#Cancle").click(function () {
            window.close();
        })
    </script>
</body>
</html>
