<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractMilestone.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractMilestone" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><%if (milestoneId > 0) { %>编辑<%} else { %>新增<%} %>里程碑</title>
    <link rel="stylesheet" href="../Content/reset.css"/>
    <link rel="stylesheet" href="../Content/LostOpp.css"/>
</head>
<body>
    <div class="TitleBar">
        <div class="Title">
            <span class="text1"><%if (milestoneId > 0) { %>编辑<%} else { %>新增<%} %>里程碑</span>
        </div>
    </div>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
