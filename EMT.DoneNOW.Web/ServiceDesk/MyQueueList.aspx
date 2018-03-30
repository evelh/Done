<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyQueueList.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.MyQueueList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/MyQueue.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/repository.css" />
    <title></title>
    <style>
       
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="LeftDiv">
            <div class="header">我的工作区和队列</div>
            <div class="header-title">
                <ul>
                    <li id="RefreshLi" onclick="RefreshPage()"><img  src="../Images/refresh.png"/></li>
                </ul>
            </div>
            <div class="DivScrollingContainer" style="top: 75px">
                <div id="serviceDeskSideBar">
                    <div class="relatedheard">
                        <div class="toogle">-</div>
                        <div class="title">我的工作区</div>
                    </div>
                    <div id="DIVMyWorkspace" style="position: relative; display: block; visibility: visible; top: 0px; left: 0px;margin-left:25px;">
                        <ul class="ButtonBarVert">
                            <li class="MenuLink Select"  onclick="SearchTicket('open')"><a>活动工单<%=dic["open"] %></a></li>
                            <li class="MenuLink" onclick="SearchTicket('over')"><a>过期工单<%=dic["over"] %></a></li>
                            <li class="MenuLink" onclick="SearchTicket('my')"><a>我创建的的工单<%=dic["my"] %></a></li>
                            <li class="MenuLink" onclick="SearchTicket('complete')"><a>完成工单<%=dic["complete"] %></a></li>
                            <li class="MenuLink" onclick="SearchTicket('change')"><a>变更申请单<%=dic["change"] %></a></li>
                            <li class="MenuLink" onclick="SearchTicket('call')"><a >服务预定</a></li>
                        </ul>
                    </div>
                    <div class="relatedheard">
                        <div class="toogle">-</div>
                        <div class="title">队列-所有工单</div>
                    </div>
                    <div id="DIVQueues" style="position: relative; display: block; visibility: visible; top: 0px; left: 0px;margin-left:25px;">
                        <ul class="ButtonBarVert">
                            <asp:Literal ID="liAllTicket" runat="server"></asp:Literal>
                        </ul>
                    </div>
                    <div class="relatedheard">
                        <div class="toogle">-</div>
                        <div class="title">队列-未分配工单</div>
                    </div>
                    <div id="DIVUnassignedTickets" style="position: relative; display: block; visibility: visible; top: 0px; left: 0px;margin-left:25px;">
                        <ul class="ButtonBarVert">
                            <asp:Literal ID="liNoResTicket" runat="server"></asp:Literal>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="RightDiv">
            <iframe style="left: 0; overflow-x: auto; overflow-y: hidden; right: 0; bottom: 0; height: auto;width:100%;height:100%;" id="ifSearchTicket">

            </iframe>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    function RefreshPage() {

    }

    $(".toogle").click(function () {
        $(this).parent().next().toggle();
        if ($(this).html() == '+') {
            $(this).html('-')
        }
        else {
            $(this).html('+')
        }
    })
    $(".MenuLink").click(function () {
        $(".MenuLink").removeClass("Select");
        if (!$(this).hasClass("Select")) {
            $(this).addClass("Select");
        }
    })

    function SearchTicket(searchType) {
        if (searchType == "open") {// MY_QUEUE_ACTIVE
            $("#ifSearchTicket").attr("src","../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_ACTIVE %>&group=215&isCheck=1");
        }
        else if (searchType == "over"){
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_ACTIVE %>&group=230&param1=2733&param2=2&isCheck=1");
        }
        else if (searchType == "my") {
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_MY_TICKET %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_MY_TICKET %>&isCheck=1");
        }
        else if (searchType == "complete") {
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_ACTIVE %>&group=230&param1=2733&param2=3&isCheck=1&");
        }
        else if (searchType == "change") {
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_CHANGE_APPROVEL %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_CHANGE_APPROVEL %>");
        }
        else if (searchType == "call") {
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALL_SEARCH %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.SERVICE_CALL_SEARCH %>");
        }
        else if (searchType.indexOf("dep_") != -1) {
            var depArr = searchType.split('_');
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_VIEW %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_VIEW %>&param1=2669&param2=" + depArr[1] +"&isCheck=1&param3=2670&param4=2");
        }
        else if (searchType.indexOf("noRes_") != -1) {
            var depArr = searchType.split('_');
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_VIEW %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_VIEW %>&param1=2669&param2=" + depArr[1] +"&isCheck=1&param3=2670&param4=0");
        }
    } 

</script>
