<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportOperation.aspx.cs" Inherits="EMT.DoneNOW.Web.ReportOperation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <link href="../Content/DynamicContent.css" rel="stylesheet" />
    <title>审批通过或者拒绝报表</title>
    <style>
        body {
            font-size: 12px;
            overflow: auto;
            background: white;
            left: 0;
            top: 0;
            position: relative;
            margin: 0;
        }

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

        .ExpenseDetail {
            padding: 10px;
            width: 100%;
        }

            .ExpenseDetail table {
                width: 100%;
            }

                .ExpenseDetail table .LeftTd {
                    width: 150px;
                    white-space: nowrap;
                }

        .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }

            .FieldLabels .label {
                font-weight: normal;
            }

        .ButtonBar ul li a span.Text, .contentButton a span.Text, a.buttons span.Text, input.button span.Text {
            font-size: 12px;
            font-weight: bold;
            line-height: 26px;
            padding: 0 1px 0 3px;
            color: #4F4F4F;
            vertical-align: top;
        }

        #Approval,#Refuse {
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            font-size: 12px;
            font-weight: bold;
            line-height: 24px;
            padding: 0 1px 0 3px;
            color: #4F4F4F;
            vertical-align: top;
        }

        span#errorSmall {
            color: red;
        }
        .grid {
    font-size: 12px;
    background-color: #FFF;
}
        .grid table {
    border-collapse: collapse;
    width: 100%;
    border-bottom-width: 1px;
    /* border-bottom-style: solid; */
}
        .grid thead tr td {
    background-color: #cbd9e4;
    border-color: #98b4ca;
    color: #64727a;
}
        .grid thead td {
    border-width: 1px;
    border-style: solid;
    font-size: 13px;
    font-weight: bold;
    height: 19px;
    padding: 4px 4px 4px 4px;
    word-wrap: break-word;
    vertical-align: top;
}
        .grid tbody td {
    border-width: 1px;
    border-style: solid;
    border-left-color: #F8F8F8;
    border-right-color: #F8F8F8;
    border-top-color: #e8e8e8;
    border-bottom-width: 0;
    padding: 4px 4px 4px 4px;
    vertical-align: top;
    word-wrap: break-word;
    font-size: 12px;
    color: #333;
}
        .grid a {
    color: #376597;
    text-decoration: none;
    font-size: 12px;
}
                 /*加载的css样式*/
#BackgroundOverLay{
    width:100%;
    height:100%;
    background: black;
    opacity: 0.6;
    z-index: 25;
    position: absolute;
    top: 0;
    left: 0;
    display: none;
}
#LoadingIndicator {
    width: 100px;
    height:100px;
    background-image: url(../Images/Loading.gif);
    background-repeat: no-repeat;
    background-position: center center;
    z-index: 30;
    margin:auto;
    position: absolute;
    top:0;
    left:0;
    bottom:0;
    right: 0;
    display: none;
}/*加载的css样式(结尾)*/
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="HeaderRow">
            <table>
                <tbody>
                    <tr>
                        <td><span>费用报表详情-<%=subRes==null?"":subRes.name %>提交</span></td>
                        <td align="right" class="helpLink"><a class="HelperLinkIcon" title=""></a></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar">
            <ul>
                <li><a class="ImgLink" id="Save" name="HREF_btnCancel">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text">
                        <asp:Button ID="Approval" runat="server" Text="审批通过" BorderStyle="None" OnClick="Approval_Click" /></span></a></li>
                <li style="margin-left:10px;"><a class="ImgLink" name="HREF_btnCancel">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text">
                        <asp:Button ID="Refuse" runat="server" Text="审批拒绝" BorderStyle="None" OnClick="Refuse_Click" /></span></a></li>
                <li style="margin-left: 14px;"><a class="ImgLink" id="HREF_btnCancel" name="HREF_btnCancel">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text" style="line-height: 24px;">取消</span></a></li>
            </ul>
        </div>

        <div class="Normal Section" id="AssignSectionHeader" style="margin-left:10px;">
            <div class="Heading" data-toggle-enabled="true">
                <div class="Toggle Collapse Toggle1">
                    <div class="Vertical"></div>
                    <div class="Horizontal"></div>
                </div>
                <div class="Left"><span class="Text">审批</span><span class="SecondaryText"></span></div>
                <div class="Spacer"></div>
            </div>
            <div class="Content">
                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                    <tbody>
                        <tr>
                            <td valign="top" class="FieldLabels" style="width: 300px; padding-right: 20px;">审批拒绝原因<span id="errorSmall">*</span>
                                <div>
                                    <textarea cols="45" rows="12" name="rejection_reason" id="rejection_reason" style="width: 250px; height: 140px; resize: none;"></textarea>
                                </div>
                            </td>
                            <td valign="top" class="FieldLabels">选择通知员工&nbsp;<span class="FieldLevelInstructions"><%=subRes==null?"":$"({subRes.name}将自动通知)" %></span><span id="errorSmall">*</span>
                                <div id="reshtml">
                                    
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>


            </div>
            <input type="hidden" id="notiIds" name="notiIds"/>
            <input type="hidden" id="refIds" name ="refIds"/>
        </div>

         <iframe runat="server" id="ShowReportDetail" style="width: 100%; height: 385px; border-width: 0px;"></iframe>

        <div id="BackgroundOverLay"></div>
        <div id="LoadingIndicator"></div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    var colors = ["#efefef", "white"];
    var index1 = 0;
    $(".Toggle1").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index1 % 2]);
        index1++;
    });
</script>
<script>
    $(function () {
        LoadRes();

        <%if (expList != null && expList.Count > 0)
    { %>
        $("#ShowReportDetail").attr("src","ExpenseReportDetail?id=<%=thisReport.id %>&isCheck=1");
        <%}%>
    })

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
                        resHtml += "<tr><td><input type='checkbox' value='" + resList[i].id + "' class='checkRes' /></td><td>" + resList[i].name + "</td><td><a href='mailto:" + resList[i].email + "'>" + resList[i].email + "</a></td></tr>";
                    }
                    resHtml += "</tbody></table></div>";

                    $("#reshtml").html(resHtml);
                }
            },
        });
    }

    function GetIds() {
        var ids = "";
        $(".checkRes").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length-1);
        }
        $("#notiIds").val(ids);
    }

    function GetRefIds(ids)
    {
        $("#refIds").val(ids);
    }

    $("#Approval").click(function () {
        GetIds();
        $("#BackgroundOverLay").show();
        $("#LoadingIndicator").show();
    });
    $("#Refuse").click(function () {
        var rejection_reason = $("#rejection_reason").val();
        if ($.trim(rejection_reason) == "") {
            LayerMsg("请填写拒绝原因");
            return false;
        }
        GetIds();
        $("#BackgroundOverLay").show();
        $("#LoadingIndicator").show();
        return true;
    })
</script>
