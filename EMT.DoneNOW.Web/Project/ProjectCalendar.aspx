<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectCalendar.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectCalendar" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"添加":"修改" %>团队日历条目</title>
    <link href="../Content/DynamicContent.css" rel="stylesheet" />
    <style>
        .HeaderRow {
            background-color: #346a95;
            z-index: 100;
            height: 36px;
            padding-left: 10px;
            margin-bottom: 10px;
        }

            .HeaderRow table {
                width: 100%;
                border-collapse: collapse;
            }

            .HeaderRow span {
                color: #FFF;
                top: 10px;
                display: block;
                width: 85%;
                position: absolute;
                text-transform: uppercase;
                font-size: 15px;
                font-weight: bold;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

        .ButtonBar {
            font-size: 12px;
            padding: 0 10px 10px 10px;
            width: auto;
            background-color: #FFF;
        }

            .ButtonBar ul {
                list-style-type: none;
                padding: 0;
                margin: 0;
                height: 26px;
                width: 100%;
            }

                .ButtonBar ul li {
                    display: block;
                    float: left;
                }

         .ButtonBar ul li a, .ButtonBar ul li a:visited, .contentButton a, .contentButton a:link, .contentButton a:visited, a.buttons, input.button, .ButtonBar ul li a:visited {
            background: #d7d7d7;
            background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            border: 1px solid #bcbcbc;
            display: inline-block;
            color: #4F4F4F;
            cursor: pointer;
            padding: 0 5px 0 3px;
            position: relative;
            text-decoration: none;
            vertical-align: middle;
            height: 24px;
        }

        td {
            font-size: 12px;
        }

        .FieldLabels, .workspace .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }

        #save_close, #save_new {
            border-style: none;
            background-color: #dddddd;
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
        }
        .DivSection .FieldLabels div, .DivSection td[class="fieldLabels"] div, .DivSectionWithHeader td[class="fieldLabels"] div {
    margin-top: 1px;
    padding-bottom: 21px;
    font-weight: 100;
}
        #errorSmall{
            color:red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="HeaderRow">
            <table>
                <tr>
                    <td><span><%=isAdd?"添加":"修改" %>团队日历</span></td>
                    <td class="helpLink" style="text-align: right;"><a class="HelperLinkIcon">
                        <img src="/images/icons/context_help.png?v=41154" border="0" /></a></td>
                </tr>
            </table>
        </div>


        <div class="ButtonBar">
            <ul>
                <li><a class="ImgLink" id="HREF_btnSaveClose" name="HREF_btnSaveClose">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span><span class="Text">
                        <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" /></span></a></li>
                <%if (!isAdd)
                    { %>
                <li style="margin-left: 20px;"><a class="ImgLink" id="" name="HREF_btnSaveClose">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span><span class="Text">
                        <asp:Button ID="save_new" runat="server" Text="保存并新建" OnClick="save_new_Click" /></span></a></li>
                <%} %>
                <li style="margin-left: 20px;"><a class="ImgLink" id="btnCancel" name="HREF_btnCancel" title="Cancel">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text">取消</span></a></li>

            </ul>
        </div>
        <div style="left: 10px; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 85px;">
            <div class="DivScrollingContainer General">
                <div class="DivSection NoneBorder" style="padding-left: 0px">
                    <table width="98%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td colspan="2" valign="top" align="center">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr height="22">
                                                <td align="left" class="FieldLabels">类型		
			<div>
                <asp:DropDownList ID="publish_type_id" runat="server"></asp:DropDownList>
            </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="2" valign="top" align="center">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr height="22">
                                                <td class="FieldLabels" align="left">事件日期<span id="errorSmall">*</span>
                                                    <div>
                                                        <input type="text" name="EventDate" onclick="WdatePicker()" id="EventDate" value="<%=!isAdd?EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisCal.start_time).ToString("yyyy-MM-dd"):"" %>"><div id="ATGCalendar_DIV_myCal1" style="width: 220px; position: fixed; top: 0px; left: 0px; visibility: hidden; display: block; z-index: 100; border: 1px solid #d7d7d7; box-shadow: 1px 1px 4px #adadad; padding: 0px;" onmouseout="myCal1.MouseOver=false;" onmouseover="myCal1.MouseOver=true;">
                                                        </div>
                                                    </div>
                                                </td>

                                                <td class="FieldLabels" align="left">开始时间
			<div>
                <input type="text" name="StartTime" id="StartTime" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=!isAdd?EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisCal.start_time).ToString("HH:mm"):"08:00" %>">&nbsp;<img src="../Images/time.png" border="0" style="vertical-align: middle;" />
            </div>
                                                </td>

                                                <td class="FieldLabels" align="left">结束时间
			<div>
                <input type="text" name="EndTime" id="EndTime" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=!isAdd?EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisCal.end_time).ToString("HH:mm"):"18:00" %>" />&nbsp;<img src="../Images/time.png" border="0" style="vertical-align: middle;" />
            </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>

                            <tr>
                                <td>

                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabels">标题<span id="errorSmall">*</span>
                                                    <div>
                                                        <input type="text" name="name" id="name" style="width: 100%" maxlength="100" value="<%=isAdd?"":thisCal.name %>" size="60">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels">描述
					<div>
                        <textarea name="description" id="description" rows="6" style="width: 100%" maxlength="999"><%=isAdd?"":thisCal.description %></textarea>
                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>


    $("#save_close").click(function () {
        return SubmitCheck();
    })
    $("#save_new").click(function () {
        return SubmitCheck();
    })


    function SubmitCheck() {
        var publish_type_id = $("#publish_type_id").val();
        if (publish_type_id == "" || publish_type_id == undefined || publish_type_id == null || publish_type_id == "0") {
            LayerMsg("请选择类型");
            return false;
        }
        var EventDate = $("#EventDate").val();
        if (EventDate == "") {
            LayerMsg("请填写事件日期");
            return false;
        }
        var StartTime = $("#StartTime").val();
        if (StartTime == "") {
            LayerMsg("请填写开始时间");
            return false;
        }
        var EndTime = $("#EndTime").val();
        if (EndTime == "") {
            LayerMsg("请填写结束时间");
            return false;
        }
        StartTime = EventDate + " " + StartTime;
        EndTime = EventDate + " " + EndTime;
        var starString = StartTime.replace(/\-/g, "/");
        var endString = EndTime.replace(/\-/g, "/");
        var sdDate = new Date(starString);
        var edDate = new Date(endString);
        var diffMin = parseInt(edDate - sdDate) / 1000 / 60;
        if (diffMin <= 0) {
            LayerMsg("开始时间要早于结束时间");
            return false;
        }
        var name = $("#name").val();
        if (name == "") {
            LayerMsg("请填写标题");
            return false;
        }
        return true;

    }

    $("#btnCancel").click(function () {
        window.close();
    })
</script>
