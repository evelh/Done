<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteTemplateToPDF.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteTemplateToPDF" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div> <asp:Button ID="Button1" runat="server" Text="转PDF" OnClick="Button1_Click" />
            <table style='width:100%; border-collapse:collapse;font-size:12px;'><tbody><tr class='firstRow'><td width='100%' colspan='2' style='word-break: break-all;'><div style='width:100%;padding-bottom: 30px;'>[Miscellaneous: Primary Logo (Requires HTML)]</div></td></tr><tr><td width='50%' style='word-break: break-all;'><div style='padding-bottom: 30px;'><p>[公司名称：名称]</p><p>[公司名称：地址]</p><p>[公司名称：电话]</p><p>[公司名称：传真]</p><div>[客户：税编号、ACN、ABN、VAT等。]</div></div><div><div style='width: 70%; text-align: left;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px 5px 5px 5px;'>Bill To</div><div style='width: 70%;border-right: 1px solid black;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px 5px 5px 5px;'>[客户：名称]&nbsp;[发票：编号]</div></div></td><td width='50%' valign='bottom' style='word-break: break-all;'><div style='float:right;display: table;padding-left: 40px;'><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'></div><div style='text-align: left;display: table-cell;padding-left: 5px;'><div style='height: 70px;'><div style='width: 120px; text-align: center;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px 5px 5px 5px;'>Date</div><div style='width: 120px; text-align: center;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px 5px 5px 5px;border-right: 1px solid black;'>[发票：日期]</div></div></div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>Invoice Number:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：号码/编号]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>Invoice Date Range:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：日期范围始于] to [发票：日期范围至]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>Purchase Order Number:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：编号]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>Payment Terms:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：付款期限]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>Payment Due:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：付款期限截止日期]</div></div></div></td></tr></tbody></table>
        </div>       
    </form>
</body>
</html>
