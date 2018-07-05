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
         .BookmarkButton {
            cursor: pointer;
            display: inline-block;
            height: 16px;
            position: relative;
            width: 16px;
            float: right;
            margin-top: 8px;
        }

            .BookmarkButton.Selected div {
                border-color: #f9d959;
            }

            .BookmarkButton > .LowerLeftPart {
                border-right-width: 8px;
                border-bottom-width: 6px;
                border-left-width: 8px;
                top: 5px;
                -moz-transform: rotate(35deg);
                -webkit-transform: rotate(35deg);
                -ms-transform: rotate(35deg);
                transform: rotate(35deg);
            }

            .BookmarkButton > .LowerRightPart {
                border-right-width: 8px;
                border-bottom-width: 6px;
                border-left-width: 8px;
                top: 5px;
                -moz-transform: rotate(-35deg);
                -webkit-transform: rotate(-35deg);
                -ms-transform: rotate(-35deg);
                transform: rotate(-35deg);
            }

            .BookmarkButton > div.LowerLeftPart, .BookmarkButton > div.LowerRightPart, .BookmarkButton > div.UpperPart {
                border-left-color: transparent;
                border-right-color: transparent;
                border-style: solid;
                border-top: none;
                height: 0;
                position: absolute;
                width: 0;
            }

            .BookmarkButton > .UpperPart {
                border-bottom-width: 6px;
                border-left-width: 3px;
                border-right-width: 3px;
                left: 5px;
                top: 1px;
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
                <li class="MenuLink" onclick="javascript:location.href='ProjectView.aspx?id=<%=thisProject.id %>';"><a >摘要</a></li>
                <%} %>
                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE"))
                    { %>
                <li class="MenuLink" onclick="javascript:location.href='ProjectView.aspx?id=<%=thisProject.id %>&type=Schedule';"><a >日程表</a></li>   <%} %>
                   <%if (CheckAuth("PRO_PROJECT_TEAM"))
                    { %>
                <li class="MenuLink" onclick="javascript:location.href='ProjectView.aspx?id=<%=thisProject.id %>&type=Team';"><a>团队</a></li> <%} %>
                  <%if (CheckAuth("PRO_PROJECT_COST_EXPENSE"))
                    { %>
                 <li class="MenuLink"  onclick="javascript:location.href='ProjectView.aspx?id=<%=thisProject.id %>&type=Cost';"><a>成本费用</a></li><%} %>
                 <%if (CheckAuth("PRO_PROJECT_NOTE"))
                    { %>
                 <li class="MenuLink"  onclick="javascript:location.href='ProjectView.aspx?id=<%=thisProject.id %>&type=Note';"><a>备注</a></li><%} %>
                 <%if (CheckAuth("PRO_PROJECT_VIEW__RATE_SEARCH"))
                    { %>
                 <li class="MenuLink"  onclick="javascript:location.href='ProjectView.aspx?id=<%=thisProject.id %>&type=Rate';"><a>费率</a></li><%} %>
                  <%if (CheckAuth("PRO_PROJECT_CALENDAR"))
                    { %>
                 <li class="MenuLink"  onclick="javascript:location.href='ProjectView.aspx?id=<%=thisProject.id %>&type=Calendar';"><a>日历条目</a></li><%} %>
                 <%if (CheckAuth("PRO_PROJECT_ATTACH"))
                    { %>
                 <li class="MenuLink"  onclick="javascript:location.href='ProjectView.aspx?id=<%=thisProject.id %>&type=Attach';"><a>附件</a></li><%} %>
                  <%if (CheckAuth("PRO_PROJECT_UDF"))
                    { %>
                     <li class="MenuLink"  onclick="javascript:location.href='ProjectView.aspx?id=<%=thisProject.id %>&type=UDF';"><a>自定义字段</a></li><%} %>
                  <li class="MenuLink" onclick="javascript:location.href='ProjectView.aspx?id=<%=thisProject.id %>&type=ticket';"><a>工单</a></li>
            </ul>
        </div>
        <div class="Right">
             <div class="HeaderRow">
                 <asp:Label ID="ShowTitle" runat="server" Text="Label"></asp:Label>
                 <div id="bookmark" class="BookmarkButton <%if (thisBookMark != null)
                { %>Selected<%} %> "
                onclick="ChangeBookMark()">
                <div class="LowerLeftPart"></div>
                <div class="LowerRightPart"></div>
                <div class="UpperPart"></div>
            </div>
            </div>
            <iframe runat="server" id="viewProjectIframe" name="viewProjectIframe" width="100%" height="92%" frameborder="0" marginheight="0" marginwidth="0" style="overflow: scroll;"></iframe>
            <iframe runat="server" id="second" width="100%" height="0" frameborder="0" marginheight="0" marginwidth="0" style="overflow: scroll;"></iframe>
        </div>
    </form>


</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script>
    function ChangeBookMark() {
        var url = '<%=Request.Url.LocalPath + "?id=" + thisProject?.id %>';
         var title = '查看项目:<%=thisProject?.name %>';
        var isBook = $("#bookmark").hasClass("Selected");
        $.ajax({
            type: "GET",
            url: "../Tools/IndexAjax.ashx?act=BookMarkManage&url=" + url + "&title=" + title,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    if (isBook) {
                        $("#bookmark").removeClass("Selected");
                    } else {
                        $("#bookmark").addClass("Selected");
                    }
                }
            }
        })
     }
</script>
