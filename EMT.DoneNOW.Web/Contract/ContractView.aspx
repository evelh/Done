<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractView.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <p><a href="ContractView.aspx?type=cost&id=<%=contract.id %>">内部成本</a> </p>
        <p><a href="ContractView.aspx?type=item&id=<%=contract.id %>">配置项</a> </p>
        <p></p>
        <p></p>
        <p></p>
        <div>
           <iframe runat="server" id="viewContractIframe" width="1280" height="300" frameborder="0" marginheight="0" marginwidth="0" style="overflow:scroll;"></iframe>
             <iframe runat="server" id="second" width="1280" height="600" frameborder="0" marginheight="0" marginwidth="0" style="overflow:scroll;"></iframe>
        </div>
    </form>
</body>
</html>
