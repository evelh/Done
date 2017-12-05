<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectCalendarShow.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectCalendarShow" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style>
        .NoteSection {
            border: 1px solid #d3d3d3;
            padding: 10px 10px 10px 10px;
            background-color: #F0F5FB;
        }

        .FieldLabels, .workspace .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }

        .NotePrintRowText {
            color: #333;
            padding-left: 10px;
            font-size: 12px;
        }

        a:link, a:visited, .dataGridBody a:link, .dataGridBody a:visited {
            color: #376597;
            font-size: 12px;
            text-decoration: none;
        }

        A:visited {
            color: #376597;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
         <div>
            <iframe runat="server" id="ShowCalendarList" style="width: 100%; height: 385px; border-width: 0px;"></iframe>
            <input type="hidden" id="canlendar_id" />
        </div>
             <div>
            <div class="NoteSection">
                <table align="center" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td class="FieldLabels" style="width:1%;">
                                <nobr>标题:</nobr>
                            </td>
                            <td width="25%" colspan="5" class="NotePrintRowText" nowrap="" id="calendarTitle"></td>
                            <td align="right" valign="middle" width="10%" rowspan="2">
                                <div class="contentButton">
                                    <a class="OnlyImageButton" id="HREF_btnPrint" name="HREF_btnPrint" href="javascript:btnPrint.punch(true);">
                                        <img title="Print" onmouseout="btnPrint.normal();" name="IMG_btnPrint" src="https://ww6.autotask.net/graphics/icons/buttonbar/print.png?v=41661" border="0"></a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="100" class="FieldLabels">
                                <nobr>事件日期</nobr>
                            </td>
                            <td style="width: 25%;" class="NotePrintRowText" id="eventDate"></td>
                           
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div style="min-width:600px; width:100%;overflow-x: auto; ">
            <table width="95%" border="0" cellspacing="0" style="margin-left: 10px; margin-top: 10px; padding-right: 10px; padding-left: 10px;">
                <tbody>
                    <tr>
                        <td id="txtBlack8">
                            <br />
                            <span id="calendarDes"></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>


    function ShowCandeldarDetail(id) {
        debugger;
        if (id != undefined && id != "" && id != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=GetSinCal&cal_id=" + id,
                async: false,
                dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        $("#calendarTitle").html(data.name);
                        
                        $("#calendarDes").html(data.description);
                        var eventDate = data.start_time;
                        if (eventDate != null && eventDate != undefined && eventDate != "")
                        {
                            var date = new Date(eventDate);
                            $("#eventDate").html(date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate());
                        } else {
                            $("#eventDate").html("");
                        }
                        
                    } else {
                        $("#calendarTitle").html("");
                        $("#eventDate").html("");
                        $("#calendarDes").html("");

                    }
                }
            })


        } else {
            $("#calendarTitle").html("");
            $("#eventDate").html("");
            $("#calendarDes").html("");
           
        }
    }
</script>
