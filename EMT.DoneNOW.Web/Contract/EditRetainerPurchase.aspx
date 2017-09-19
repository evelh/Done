<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditRetainerPurchase.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.EditRetainerPurchase" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <link href="../Content/reset.css" rel="stylesheet" />
  <link rel="stylesheet" href="../Content/LostOpp.css"/>
    <title>编辑预付时间</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
        <div class="Title">
          <span class="text1"><%if (rateId == 0) { %>新增<%} else { %>编辑<%} %>费率</span>
          <a href="###" class="help"></a>
        </div>
      </div>
      <div class="ButtonContainer header-title">
        <ul id="btn">
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
            <asp:Button ID="SaveClose" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="SaveClose_Click" />
          </li>
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
            <asp:Button ID="SaveNew" runat="server" Text="保存并新建" BorderStyle="None" OnClick="SaveNew_Click" />
          </li>
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
            <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClientClick="javascript:window.close();" />
          </li>
        </ul>
      </div>
    </form>
</body>
</html>
