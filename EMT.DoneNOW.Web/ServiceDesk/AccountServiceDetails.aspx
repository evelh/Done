<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountServiceDetails.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.AccountServiceDetails" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>客户服务详情</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1">复制工单到项目</span>
                </div>
            </div>
            
             <div class="ButtonContainer header-title" style="margin:0;">
                <ul id="btn">
                    <li id="saveClose"><i style="background-image: url(../Images/print.png);" class="icon-1"></i>
                       
                    </li>
                    <li id="Close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <input type="button" value="关闭" style="width: 30px;" />
                    </li>
                </ul>
            </div>
            <div>
                <iframe scrolling="yes"  style="width:100%;height:600px;border-width: 0px;" src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.ACCOUNT_SERVICE_DETAILS %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.ACCOUNT_SERVICE_DETAILS %>&con2469=<%=thisAccount.id %>">
                    
                </iframe>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#Close").click(function () {
        window.close();
    })
</script>
