<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExecutiveSummaryResult.aspx.cs" Inherits="EMT.DoneNOW.Web.Reports.ExecutiveSummaryResult" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
     <style>
        td {
            border: 1px solid black;
        }

        body {
            font-size: 10pt;
            font-size: 12px;
            background: #fff;
            left: 0;
            position: relative;
            top: 0;
            min-width: 700px;
        }

        .Boild {
            font-weight: 600;
        }
        .NoBoard td{
            border:0px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Literal ID="liHtml" runat="server"></asp:Literal>
    </form>
</body>
</html>
