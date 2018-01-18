<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectView.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <title>查看项目</title>
     <style>
        body {
            font-family: Arial,Helvetica,Tahoma,sans-serif;
            font-size: 12px;
        }

        .HeaderRow {
            background-color: #346a95;
            z-index: 100;
            height: 36px;
            padding-left: 10px;
            margin-bottom: 10px;
        }

        .HeaderRow span {
            color: #FFF;
            top: 10px;
            display: block;
            width: 85%;
            position: absolute;
            text-transform: uppercase;
            font-size: 15px;
            font-weight: bold;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .Left {
            width: 160px;
        }

        .ButtonBarVert {
            padding-left: 16px;
            padding-right: 16px;
        }

        .MenuLink {
            color: #4F4F4F;
            font-size: 12px;
            text-decoration: none;
            cursor: pointer;
            margin-bottom: 11px;
            padding: 2px 2px 5px 2px;
        }

            .MenuLink:hover {
                background-color: #E9F0F8;
            }

        .Right {
            position: absolute;
            left: 160px;
            right: 0;
            top: 0;
            bottom: 0;
            border-left: 1px solid #d3d3d3;
        }
        a{
            color:black;
            text-decoration-line:none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="Left">
            <div class="HeaderRow">
                <span>菜单</span>
            </div>
            <ul class="ButtonBarVert">
                <%if (CheckAuth("PRO_PROJECT_VIEW_SUMMARY"))
                    { %>
                <li class="MenuLink"><a href="ProjectView.aspx?id=<%=thisProject.id %>">摘要</a></li>
                <%} %>
                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE"))
                    { %>
                <li class="MenuLink"><a href="ProjectView.aspx?id=<%=thisProject.id %>&type=Schedule">日程表</a></li>   <%} %>
                   <%if (CheckAuth("PRO_PROJECT_TEAM"))
                    { %>
                <li class="MenuLink"><a href="ProjectView.aspx?id=<%=thisProject.id %>&type=Team">团队</a></li> <%} %>
                  <%if (CheckAuth("PRO_PROJECT_COST_EXPENSE"))
                    { %>
                 <li class="MenuLink"><a href="ProjectView.aspx?id=<%=thisProject.id %>&type=Cost">成本费用</a></li><%} %>
                 <%if (CheckAuth("PRO_PROJECT_NOTE"))
                    { %>
                 <li class="MenuLink"><a href="ProjectView.aspx?id=<%=thisProject.id %>&type=Note">备注</a></li><%} %>
                 <%if (CheckAuth("PRO_PROJECT_VIEW__RATE_SEARCH"))
                    { %>
                 <li class="MenuLink"><a href="ProjectView.aspx?id=<%=thisProject.id %>&type=Rate">费率</a></li><%} %>
                  <%if (CheckAuth("PRO_PROJECT_CALENDAR"))
                    { %>
                 <li class="MenuLink"><a href="ProjectView.aspx?id=<%=thisProject.id %>&type=Calendar">日历条目</a></li><%} %>
                 <%if (CheckAuth("PRO_PROJECT_ATTACH"))
                    { %>
                 <li class="MenuLink"><a href="ProjectView.aspx?id=<%=thisProject.id %>&type=Attach">附件</a></li><%} %>
                  <%if (CheckAuth("PRO_PROJECT_UDF"))
                    { %>
                     <li class="MenuLink"><a href="ProjectView.aspx?id=<%=thisProject.id %>&type=UDF">自定义字段</a></li><%} %>
                  <li class="MenuLink"><a>工单(暂未实现)</a></li>
            </ul>
        </div>
        <div class="Right">
             <div class="HeaderRow">
                 <asp:Label ID="ShowTitle" runat="server" Text="Label"></asp:Label>
            </div>
            <iframe runat="server" id="viewProjectIframe" name="viewProjectIframe" width="100%" height="92%" frameborder="0" marginheight="0" marginwidth="0" style="overflow: scroll;"></iframe>
            <iframe runat="server" id="second" width="100%" height="0" frameborder="0" marginheight="0" marginwidth="0" style="overflow: scroll;"></iframe>
        </div>
    </form>


</body>
</html>
