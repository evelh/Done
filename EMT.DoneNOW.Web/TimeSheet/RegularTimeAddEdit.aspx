<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegularTimeAddEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.TimeSheet.RegularTimeAddEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><%if (isAdd) { %>新增<%} else { %>编辑<%} %>常规工时</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style>
        .timeTable input{width:110px;margin-left:0;}
    </style>
</head>
<body>
    <div class="header">
        <%if (isAdd) { %>新增<%} else { %>编辑<%} %>常规工时
    </div>
    <div class="header-title" style="min-width: 700px;">
        <ul>
            <li id="SaveClose">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <input type="button" value="保存并关闭" />
            </li>
            <li id="SaveNew">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                <input type="button" value="保存并新建" />
            </li>
            <li id="Cancle">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <input type="button" value="取消" />
            </li>
        </ul>
    </div>
    <form id="form1" runat="server">
        <div class="nav-title">
            <ul class="clear">
                <li class="boders">常规</li>
                <li>通知</li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 136px;padding:3px 30px 10px 30px">
            <div class="content clear" style="width:100%;">
                <table border="none" cellspacing="" cellpadding="">
                    <%if (isAdd && showResource) { %>
                    <tr>
                        <td>
                            <div class="clear">
                                <label style="text-align:left;width:120px;">员工<span style="color: red;">*</span></label>
                                <asp:DropDownList ID="resource_id" runat="server" Width="160"></asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                    <%} %>
                    <tr>
                        <td>
                            <div class="clear">
                                <label style="text-align:left;width:120px;">种类<span style="color: red;">*</span></label>
                                <input type="hidden" id="subAct" name="subAct" />
                                <asp:Label ID="costCodeName" runat="server"></asp:Label>
                                <asp:DropDownList ID="cost_code_id" runat="server" Width="160"></asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                </table>
                <table class="timeTable" style="border:1px solid #979393;margin-top:12px;min-width:840px;" cellspacing="" cellpadding="">
                    <tr>
                        <td>
                            <div style="display: inline-block;position: absolute;margin-left: -48px;margin-top: 16px;">
                                <img src="../Images/move-left.png" style="width:26px;height:26px;padding:5px;" onclick="GotoPeriod('<%=startDate.AddDays(-7).ToString("yyyy-MM-dd") %>')" />
                            </div>
                            <span class="lblNormalClass" id="mondaySpan">星期一(<%=startDate.ToString("M-dd") %>)</span>
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="monday" runat="server" class="txtBlack8Class" type="text" maxlength="5" ></asp:TextBox>
                                    <asp:HiddenField ID="mondayNodes" runat="server" />
                                    <asp:HiddenField ID="mondayInter" runat="server" />
                                </span>
                            </div>
                        </td>
                        <td>
                            <span class="lblNormalClass" id="tuesdaySpan">星期二(<%=startDate.AddDays(1).ToString("M-dd") %>)</span>
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="tuesday" runat="server" class="txtBlack8Class" type="text" maxlength="5" ></asp:TextBox>
                                    <asp:HiddenField ID="tuesdayNodes" runat="server" />
                                    <asp:HiddenField ID="tuesdayInter" runat="server" />
                                </span>
                            </div>
                        </td>
                        <td>
                            <span class="lblNormalClass" id="wednesdaySpan">星期三(<%=startDate.AddDays(2).ToString("M-dd") %>)</span>
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="wednesday" runat="server" class="txtBlack8Class" type="text" maxlength="5" ></asp:TextBox>
                                    <asp:HiddenField ID="wednesdayNodes" runat="server" />
                                    <asp:HiddenField ID="wednesdayInter" runat="server" />
                                </span>
                            </div>
                        </td>
                        <td>
                            <span class="lblNormalClass" id="thursdaySpan">星期四(<%=startDate.AddDays(3).ToString("M-dd") %>)</span>
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="thursday" runat="server" class="txtBlack8Class" type="text" maxlength="5" ></asp:TextBox>
                                    <asp:HiddenField ID="thursdayNodes" runat="server" />
                                    <asp:HiddenField ID="thursdayInter" runat="server" />
                                </span>
                            </div>
                        </td>
                        <td>
                            <span class="lblNormalClass" id="fridaySpan">星期五(<%=startDate.AddDays(4).ToString("M-dd") %>)</span>
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="friday" runat="server" class="txtBlack8Class" type="text" maxlength="5" ></asp:TextBox>
                                    <asp:HiddenField ID="fridayNodes" runat="server" />
                                    <asp:HiddenField ID="fridayInter" runat="server" />
                                </span>
                            </div>
                        </td>
                        <td>
                            <span class="lblNormalClass" id="saturdaySpan">星期六(<%=startDate.AddDays(5).ToString("M-dd") %>)</span>
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="saturday" runat="server" class="txtBlack8Class" type="text" maxlength="5" ></asp:TextBox>
                                    <asp:HiddenField ID="saturdayNodes" runat="server" />
                                    <asp:HiddenField ID="saturdayInter" runat="server" />
                                </span>
                            </div>
                        </td>
                        <td>
                            <span class="lblNormalClass" id="sundaySpan">星期日(<%=startDate.AddDays(6).ToString("M-dd") %>)</span>
                            <div>
                                <span style="display: inline-block">
                                    <asp:TextBox ID="sunday" runat="server" class="txtBlack8Class" type="text" maxlength="5" ></asp:TextBox>
                                    <asp:HiddenField ID="sundayNodes" runat="server" />
                                    <asp:HiddenField ID="sundayInter" runat="server" />
                                </span>
                            </div>
                            <div style="display: inline-block;position: absolute;margin-left: 62px;margin-top: -39px;">
                                <img src="../Images/move-right.png" style="width:26px;height:26px;padding:5px;" onclick="GotoPeriod('<%=startDate.AddDays(7).ToString("yyyy-MM-dd") %>')" />
                            </div>
                        </td>
                    </tr>
                </table>
                <table style="margin:12px 0 12px 0;" border="none" cellspacing="" cellpadding="">
                    <tr><td><span style="float:left;" id="notes">工时说明&nbsp;&nbsp;星期一(<%=startDate.ToString("M-dd") %>)</span></td></tr>
                    <tr><td><textarea style="width:100%;height:200px;margin-left:0;" id="notesText"></textarea></td></tr>
                </table>
                <table border="none" cellspacing="" cellpadding="">
                    <tr><td><span style="float:left;" id="inter">内部说明&nbsp;&nbsp;星期一(<%=startDate.ToString("M-dd") %>)</span></td></tr>
                    <tr><td><textarea style="width:100%;height:200px;margin-left:0;" id="interText"></textarea></td></tr>
                </table>
            </div>
            <div class="content clear" style="width:900px;display:none;">
                <div id="FormContent" class="DivSection NoneBorder" style="padding-left: 0px;">
                    <div id="mnuNotify" style="position: relative; top: 0px; left: 0px; visibility: visible; display: block;">
                        <table class="searchareaborder" width="620px" cellspacing="0" cellpadding="0" border="0">
                            <tbody>
                                <tr>
                                    <td colspan="2">
                                        <table width="100%" cellspacing="0" cellpadding="0" border="0" >
                                            <tbody>
                                                <tr>
                                                    <td class="fieldLabels">
                                                        <div class="CheckBoxList">
                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                <input type="checkbox" id="CCMe" style="margin-top:10px;margin-left:0;" />
                                                                <label style="float:left;text-align:left;" for="CCMe">抄送给我<%="("+LoginUser.name+")" %></label>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <%if (isAdd && showResource) { %>
                                                    <td class="fieldLabels">
                                                        <div class="CheckBoxList">
                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                <input type="checkbox" id="callRes" style="margin-top:10px;margin-left:0;" />
                                                                <label style="float:left;text-align:left;" for="callRes" id="callName">li, li</label>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <%} %>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels" colspan="2">
                                        <span class="FieldLevelInstructions" style="float:left;">员工(<a style="color: #376597; cursor: pointer;" onclick="LoadRes()">加载</a>)</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels" colspan="2">
                                        <div id="reshtml" style="height: 170px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels" colspan="2">
                                        <span style="float:left;">其他邮件地址</span>
                                        <div>
                                            <input type="text" style="width: 100%;margin-left:0;" name="otherEmail" id="otherEmail" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels" colspan="2">
                                        <span style="float:left;margin-top:12px;">通知模板</span>
                                        <div>
                                            <asp:DropDownList ID="notify_tmpl_id" runat="server" Style="margin-left:0;" Width="100%"></asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels" colspan="2">
                                        <span style="float:left;margin-top:12px;">主题</span>
                                        <div>
                                            <input type="text" id="subject" name="subject" value="" style="width:100%;margin-left:0;" />
                                            <input type="hidden" name="resIds" id="resIds" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels" width="369px">
                                        <span style="float:left;margin-top:12px;">附加信息</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        <div>
                                            <textarea rows="6" style="width: 100%;margin-left:0;" name="body_text" id="AdditionalText"></textarea>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
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
            if (SaveCheck()) {
                $("#subAct").val("SaveClose");
                $("#form1").submit();
            }
        })
        $("#SaveNew").click(function () {
            if (SaveCheck()) {
                $("#subAct").val("SaveNew");
                $("#form1").submit();
            }
        })
        $("#Cancle").click(function () {
            window.close();
        })
        function SaveCheck() {
            <%if (isAdd && showResource) { %>
            if ($("#resource_id").val() == "") {
                LayerMsg("请选择员工");
                return false;
            }
            <%}%>
            <%if (isAdd) { %>
            if ($("#cost_code_id").val() == "") {
                LayerMsg("请选择种类");
                return false;
            }
            <%}%>
            if ($("#monday").val() == "" && $("#tuesday").val() == "" && $("#wednesday").val() == "" && $("#thursday").val() == ""
                && $("#friday").val() == "" && $("#saturday").val() == "" && $("#sunday").val() == "") {
                LayerMsg("请输入工时");
                return false;
            }
            return true;
        }
        var curtId = "monday";
        $(".txtBlack8Class").focus(function () {
            curtId = this.id;
            $("#notes").html("工时说明&nbsp;&nbsp;" + $("#" + this.id + "Span").text());
            $("#inter").html("内部说明&nbsp;&nbsp;" + $("#" + this.id + "Span").text());
            $("#notesText").val($("#" + this.id + "Nodes").val());
            $("#interText").val($("#" + this.id + "Inter").val());
        })
        $("#notesText").blur(function () {
            $("#" + curtId + "Nodes").val($("#notesText").val());
        })
        $("#interText").blur(function () {
            $("#" + curtId + "Inter").val($("#interText").val());
        })
        <%if (isAdd) { %>
        function GotoPeriod(date) {
            LayerConfirm("切换到其他周期将不会对当前周期进行保存，要切换到其他周期吗？", "确定", "取消", function () {
                window.location.href = "RegularTimeAddEdit?startDate=" + date;
            }, function () { });
        }
        <%}%>
        function LoadRes() {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ResourceAjax.ashx?act=GetResAndWorkGroup",
                success: function (data) {
                    if (data != "") {
                        var resList = JSON.parse(data);
                        var resHtml = "";
                        resHtml += "<div class='grid' style='overflow: auto;height: 147px;'><table width='100%' border='0' cellspacing='0' cellpadding='3'><thead><tr><td width='1%'></td><td width='33%'>员工姓名</td ><td width='33%'>邮箱地址</td></tr ></thead ><tbody>";// <input type='checkbox' id='checkAll'/>
                        for (var i = 0; i < resList.length; i++) {
                            resHtml += "<tr style='border-top: 1px solid #979393'><td><input type='checkbox' value='" + resList[i].id + "' class='" + resList[i].type + "' /></td><td>" + resList[i].name + "</td><td><a href='mailto:" + resList[i].email + "'>" + resList[i].email + "</a></td></tr>";
                        }
                        resHtml += "</tbody></table></div>";

                        $("#reshtml").html(resHtml);
                    }
                },
            });
        }
        function GetResID() {
            var ids = "";
            $(".checkRes").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ",";
                }
            })
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
            }
            $("#resIds").val(ids);
        }

    </script>
</body>
</html>
