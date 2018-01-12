<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExpenseReportManage.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ExpenseReportManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"修改" %>费用报表</title>
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="HeaderRow">
            <table>
                <tbody>
                    <tr>
                        <td><span><%=isAdd?"新增":"修改" %>费用报表</span></td>
                        <td align="right" class="helpLink"><a class="HelperLinkIcon" title=""></a></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar">
            <ul>
               <li><a class="ImgLink" id="Save" name="HREF_btnCancel">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text">
                        <asp:Button ID="Save_Close" runat="server" Text="Button" BorderStyle="None" OnClick="Save_Close_Click" /></span></a></li>
               <li><a class="ImgLink" id="HREF_btnCancel" name="HREF_btnCancel">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text">取消</span></a></li>
            </ul>
        </div>
        <div style="padding-left: 10px;">
            <table border="0" cellpadding="0" cellspacing="0" width="350px">
                <tbody>
                    <tr>
                        <td class="FieldLabels" colspan="2">费用报表名称<span id="errorSmall">*</span></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div style="padding-bottom: 11px">
                                <input type="text" id="title" value="<%=thisReport!=null?thisReport.title:"" %>" name="title" style="width: 280px" maxlength="100" /></div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">周期结束日期<span id="errorSmall">*</span></td>
                        <td class="FieldLabels">预付现金总额</td>
                    </tr>
                    <tr>
                        <td width="160px">
                            <input type="text" name="end_date" id="end_date" size="12" value="<%=thisReport!=null&&thisReport.end_date!=null?((DateTime)thisReport.end_date).ToString("yyyy-MM-dd"):DateTime.Now.ToString("yyyy-MM-dd")%>" style="width: 80px; margin-right: 4px;" onclick="WdatePicker()" />
                           
                        </td>
                        <td>
                            <input type="text" name="cash_advance_amount" id="cash_advance_amount" size="12" maxlength="12"  value="<%=thisReport!=null&&thisReport.cash_advance_amount!=null?((decimal)thisReport.cash_advance_amount).ToString("#0.00"):"" %>" style="width: 120px;" /></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    function SubmtCheck() {
        var title = $("#title").val();
        if (title == "") {
            LayerMsg("请填写费用报表名称！");
            return false;
        }
        var end_date = $("#end_date").val();
        if (end_date == "") {
            LayerMsg("请填写周期结束日期！");
            return false;
        }
        return true;
    }
</script>
