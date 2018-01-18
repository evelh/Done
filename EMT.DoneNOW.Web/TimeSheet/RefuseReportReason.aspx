<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RefuseReportReason.aspx.cs" Inherits="EMT.DoneNOW.Web.TimeSheet.RefuseReportReason" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=thisReport.title %>-拒绝详情</title>
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

        .DivScrollingContainer {
            left: 0;
            overflow-x: auto;
            overflow-y: auto;
            position: fixed;
            right: 0;
            bottom: 0;
        }

        .FieldLabels, .workspace .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="HeaderRow">
            <table>
                <tbody>
                    <tr>
                        <td><span>费用报表=拒绝详情</span></td>
                        <td align="right" class="helpLink"><a class="HelperLinkIcon" title=""></a></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar">
            <ul>

                <li style="margin-left: 14px;"><a class="ImgLink" id="" name="" onclick="ClosePage()">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text" style="line-height: 24px;">关闭</span></a></li>


            </ul>
        </div>
        <div style="padding-left: 10px; padding-right: 10px; padding-bottom: 10px; top: 82px; color: #333333;" class="DivScrollingContainer">
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tbody>
                    <tr>
                        <td valign="bottom">
                            <div class="FieldLabels">拒绝原因</div>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <div style="padding-bottom: 21px;"><%=thisReport.rejection_reason %></div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <% if (expList != null && expList.Count > 0)
                { %>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tbody>
                    <tr>
                        <td valign="bottom" colspan="2">
                            <div class="FieldLabels">拒绝费用</div>
                        </td>
                    </tr>
                    <% foreach (var thisExp in expList)
                        {%>
                    <tr>
                        <td width="50%" align="left">
                            <div>
                                <%=thisExp.description %>
                            </div>
                        </td>
                        <td width="50%" align="left" style="white-space: nowrap;"><%=thisExp.amount.ToString("#0.00") %></td>
                    </tr>
                        <%} %>
                   
                </tbody>
            </table>
            <%} %>

        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    function ClosePage() {
        window.close();
    }
</script>
