<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractNoteShow.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractNoteShow" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><%=thisTask!=null?"任务备注":"" %></title>
    <style>
            .header {
    height: 40px;
    line-height: 40px;
    background: #346A95;
    padding: 0 10px;
    font-size: 18px;
    color: #FFFFFF;
}
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
        <%if (thisTask != null){ %>
        <div class="header">项目任务备注-<%=thisTask.no %><%=thisAccount!=null?"-"+thisAccount.name:"" %></div>
        <%} %>
        <div>
            <input type="hidden" id="AddNoteType" value="<%=thisContract!=null?"contract":(thisTask!=null?"task":"") %>"/>
            <iframe runat="server" id="ShowNoteList" style="width: 100%; height: 385px; border-width: 0px;"></iframe>
            <input type="hidden" id="note_id" />
            <input type="hidden" id="contract_id" value="<%=thisContract!=null?thisContract.id.ToString():"" %>"/>
        </div>
        <div>
            <div class="NoteSection">
                <table align="center" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td width="100" class="FieldLabels">
                                <nobr>标题:</nobr>
                            </td>
                            <td width="25%" colspan="5" class="NotePrintRowText" nowrap="" id="NoteTitle"></td>
                            <td align="right" valign="middle" width="10%" rowspan="2">
                                <div class="contentButton">
                                    <a class="OnlyImageButton" id="HREF_btnPrint" name="HREF_btnPrint" href="javascript:btnPrint.punch(true);">
                                        <img title="Print" onmouseout="btnPrint.normal();" src="../Images/print.png" border="0" /></a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="100" class="FieldLabels">
                                <nobr>提交人</nobr>
                            </td>
                            <td style="width: 25%;" class="NotePrintRowText" id="CreateName"></td>
                            <td style="width: 15%; text-align: right;" class="FieldLabels">类型:</td>
                            <td style="width: 20%;" class="NotePrintRowText" id="NoteType"></td>
                            <td style="width: 15%; text-align: right;" class="FieldLabels">提交日期: </td>
                            <td style="width: 20%;" class="NotePrintRowText" id="CreateDate"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div style="min-width:600px; width:100%;overflow-x: auto; ">
            <table width="95%" border="0" cellspacing="0" style="margin-left: 10px; margin-top: 10px; padding-right: 10px; padding-left: 10px;">
                <tbody>
                    <tr>
                        <td>
                            <!-- inner table for formatting -->
                            <table border="0" cellspacing="0" cellpadding="">
                                <tbody id="ThisNoteAtt">
                                </tbody>
                            </table>
                            <!-- inner table for formatting -->
                        </td>
                    </tr>
                    <tr>
                        <td id="txtBlack8">
                            <br />
                            <span id="noteDes" style="font-size:10pt;"></span>
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
    function ShowNoteDetail(note_id) {
        if (note_id != undefined && note_id != "" && note_id != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/ActivityAjax.ashx?act=GetNoteInfo&note_id=" + note_id,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#NoteTitle").html(data.title);
                        $("#CreateName").html(data.createUser);
                        $("#CreateDate").html(data.createDate);
                        $("#NoteType").html(data.type);
                        $("#noteDes").html(data.description);
                        ShowNoteAtt(note_id);
                    } else {
                        $("#NoteTitle").html("");
                        $("#CreateName").html("");
                        $("#CreateDate").html("");
                        $("#NoteType").html("");
                        $("#noteDes").html("");
                        $("#ThisNoteAtt").html("");

                    }
                }
            })


        } else {
            $("#NoteTitle").html("");
            $("#CreateName").html("");
            $("#CreateDate").html("");
            $("#NoteType").html("");
            $("#noteDes").html("");
            $("#ThisNoteAtt").html("");
        }
    }

    function ShowNoteAtt(note_id) {
        $("#ThisNoteAtt").html("");
        $.ajax({
            type: "GET",
            url: "../Tools/ActivityAjax.ashx?act=GetNoteAtt&note_id=" + note_id,
            async: false,
            dataType: "json",
            success: function (data) {
                debugger;
                if (data != "") {
                    var attHtml = "<tr><td colspan='" + data.length + "' class='FieldLabels' style='white-space: nowrap; text - align:left;'>备注附件</td></tr>";
                    attHtml += "<tr>";
                    for (var i = 0; i < data.length; i++) {
                        var imgUrl = "";
                        if (data[i].type_id == '<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.ATTACHMENT %>') {
                            imgUrl = "attachment.png";
                        } else if (data[i].type_id == '<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.URL %>') {
                            imgUrl = "url.png";
                        }
                        else if (data[i].type_id == '<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.FILE_LINK %>') {
                            imgUrl = "file.png";
                        }
                        else if (data[i].type_id == '<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.FOLDER_LINK %>') {
                            imgUrl = "folder.png";
                        }

                        attHtml += "<td  style='padding- left: 10px; padding - top: 10px; width: 50px; vertical - align: top; text - align:center;'><a target= '_new' href= '../Activity/OpenAttachment.aspx?id=" + data[i].id + "' ><img src='../Images/" + imgUrl + "' ><br />" + data[i].title + "</a></td>";
                    }
                    attHtml += "</tr>";

                    $("#ThisNoteAtt").html(attHtml);
                } else {
                    $("#ThisNoteAtt").html("");
                }
            }
        })
    }
</script>

