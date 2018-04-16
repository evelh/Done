<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HolidaySet.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.HolidaySet" %>

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
    <div class="nav-title">
        <ul class="clear">
            <li class="boders">常规信息</li>
            <%if (!isAdd) { %>
            <li class="boders">节假日设置</li>
            <%} %>
        </ul>
    </div>
    <form id="form1" runat="server">
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 136px;">
            <div class="content clear" style="width:920px;">
                <div>
                    <table border="none" cellspacing="" cellpadding="">
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>名称<span style="color: red;">*</span></label>
                                    <input type="text" id="holidayName" name="holidayName" <%if (!isAdd)
                                        { %> value="<%=name %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>描述</label>
                                    <textarea id="description" name="description"><%if (!isAdd)
                                        { %><%=description %><%} %></textarea>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <%if (!isAdd) { %>
            <div class="content clear" style="width:920px;display:none;height:100%;">
                <div  style="width:100%;margin-top:3px;border-top:1px solid #e8e8fa;height:100%;">
                    <iframe id="showHoliday" src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.HOLIDAYS %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Holidays %>&con1239=<%=id %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
                </div>
            </div>
            <%} %>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js"></script>
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
            $("#form1").submit();
        })
        $("#Cancle").click(function () {
            window.close();
        })
    </script>
</body>
</html>
