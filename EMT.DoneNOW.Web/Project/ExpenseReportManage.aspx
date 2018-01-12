<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExpenseReportManage.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ExpenseReportManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="HeaderRow">
            <table>
                <tbody>
                    <tr>
                        <td><span></span></td>
                        <td align="right" class="helpLink"><a class="HelperLinkIcon" title="" href=""></a></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar">
            <ul>
                <li>
                    <a class="ImgLink" href="javascript:btnSaveClose.punch(true);" id="HREF_btnSaveClose" name="HREF_btnSaveClose" title="Save &amp; Close">
                        <span class="Text"></span></a><span style="margin-left: 3px; margin-right: 3px;"></span>

                </li>
                <li>

                    <a class="ImgLink" href="javascript:btnCancel.punch(true);" id="HREF_btnCancel" name="HREF_btnCancel" title="Cancel">
                        <span class="Text">Cancel</span></a><span style="margin-left: 3px; margin-right: 3px;"></span>

                </li>
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
                            <input type="text" name="ex_caa" size="12" maxlength="12"  value="<%=thisReport!=null&&thisReport.cash_advance_amount!=null?((decimal)thisReport.cash_advance_amount).ToString("#0.00"):"" %>" style="width: 120px;" /></td>
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

</script>
