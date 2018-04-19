<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResourceAssPolicy.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.ResourceAssPolicy" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>员工关联休假策略</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
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
    <div style="margin:10px;">
        <span>一个员工可以与多个休假策略相关联。生效日期和到期日期定义了策略何时生效。没有到期日的策略将一直有效，直到添加另一项策略为止。</span>
        <div style="border:1px solid #d3d3d3;">
            <div style="padding:6px 12px 0 12px;"><span style="margin:6px;">要调整策略或生效日期，请点击相应的单元格，到期日期不能修改。注意：此员工与休假策略的修改可能需要几分钟的时间（这取决于该员工相关策略的数量以及为其定义的休假类别）。</span></div>
            <div style="height:246px;padding:6px 12px 6px 12px;">
                <iframe id="itemFrame" src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_POLICY_ASSIGNMENT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.ResourcePolicyAssignment %>&con2672=<%=resourceId %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
            </div>
        </div>
    </div>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js"></script>
    <script>
        $("#Close").click(function () {
            window.close();
        })
    </script>
</body>
</html>
