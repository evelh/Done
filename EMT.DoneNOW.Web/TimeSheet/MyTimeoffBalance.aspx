<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyTimeoffBalance.aspx.cs" Inherits="EMT.DoneNOW.Web.TimeSheet.MyTimeoffBalance" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>假期余额详情</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style>
        label{font-weight:500;}
    </style>
</head>
<body>
    <div class="header">员工关联休假策略</div>
    <div class="header-title" style="min-width: 400px;">
        <ul>
            <li id="Close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <input type="button" value="关闭" />
            </li>
        </ul>
    </div>
    <div style="margin:0 10px 10px 10px;">
        <div><span>显示该员工所有假期余额信息，直到明年年底。</span></div>
        <div style="border:1px solid #d3d3d3;padding:4px;margin-top:6px;">
            <div><label style="font-weight:600;">常规信息</label></div>
            <div style="margin-left:12px;">
                <label>当前余额(小时)</label><br />
                <label><%=balance %></label>
            </div>
        </div>
        <div style="border:1px solid #d3d3d3;padding:4px;margin-top:6px;">
            <div><label style="font-weight:600;">假期事件清单</label></div>
            <div style="margin-left:12px;">
                <label>使用表格的方式展示事件清单。</label>
            </div>
            <div style="width:100%;height:400px;">
                <iframe id="itemFrame" src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_MY_BALANCE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TimeoffMyBalance %>&con2746=<%=resourceId %>&con2747=<%=cateId %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
            </div>
        </div>
    </div>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script>
        $("#Close").click(function () {
            window.close();
        })
    </script>
</body>
</html>
