<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ApproveChargeSelect.aspx.cs" Inherits="EMT.DoneNOW.Web.ApproveChargeSelect" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
       <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
     <link rel="stylesheet" type="text/css" href="../Content/style.css" />
        <style>
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
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
<div id="default" style="display:none">
            <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">潜在超支</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
  <div class="ButtonContainer header-title">
        <ul id="btn">
            <li>
                <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="继续"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
        </ul>
    </div>
    <div style="padding: 0 10px 12px 10px;">
       下列成本关联预付费合同，但是不足以预付成本，选择：取消、自动生成预付费（必须设置了自动生成预付费—通知规则中设置订购（purchase）数量/金额）、强制生成（不够的部分单独生成一个条目
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div>
                             <asp:RadioButton ID="Radio1" runat="server" GroupName="post" Checked="True"/> 取消
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div>
                            <asp:RadioButton ID="Radio2" runat="server" GroupName="post"/><asp:Label ID="Label1" runat="server" Text="自动生成预付费"></asp:Label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div>
                            <asp:RadioButton ID="Radio3" runat="server" GroupName="post"/> 强制生成
                        </div>
                    </td>                    
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div class="GridContainer" style="height: auto;">
                            <div style="width: 100%; overflow: auto; z-index: 0;height:500px;">
                                <table class="dataGridBody" cellspacing="0" style="width:100%;border-collapse:collapse;">
                                    <tbody>
                                    <tr class="dataGridHeader" style="height: 28px;">
                                        <td style="width: auto;">
                                            <span>成本名称</span>
                                        </td>
                                        <td align="right" style="width: auto;">
                                            <span>客户</span>
                                        </td>
                                        <td style="width: 100px;text-align: right;">
                                            <span>计费金额</span>
                                        </td>
                                    </tr>
                                        <%if(list!=null&&list.Count>0) foreach (var i in list)
                                            {%>
                                    <tr class="dataGridBody">
                                        <td style="width: auto;">
                                            <span><%=i.costname %></span>
                                        </td>
                                        <td align="right" style="width: auto;">
                                            <span><%=i.accountname %></span>
                                        </td>
                                        <td style="width: 100px;text-align: right;">
                                            <span><%=i.extendprice %></span>
                                        </td>
                                    </tr>
                                        <%} %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>          
</div>
</div>        <%--加载--%>
<div id="BackgroundOverLay"></div>
<div id="LoadingIndicator"></div>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
    </form>
</body>
</html>
