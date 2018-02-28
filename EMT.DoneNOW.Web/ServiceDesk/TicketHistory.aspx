<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketHistory.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.TicketHistory" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link rel="stylesheet" type="text/css" href="../Content/searchList.css" />
        <link rel="stylesheet" href="../Content/reset.css" />
    <title>工单历史</title>
    <style>
           .TitleBar {
            color: #fff;
            background-color: #346a95;
            display: block;
            font-size: 15px;
            font-weight: bold;
            height: 36px;
            line-height: 38px;
            margin: 0 0 10px 0;
        }

            .TitleBar > .Title {
                top: 1px;
                height: 36px;
                left: -1px;
                overflow: hidden;
                position: absolute;
                text-overflow: ellipsis;
                text-transform: uppercase;
                white-space: nowrap;
                width: 97%;
            }

        .text2 {
            margin-left: 5px;
        }

        .help {
            background-image: url(../Images/help.png);
            cursor: pointer;
            display: inline-block;
            height: 16px;
            position: absolute;
            right: 10px;
            top: 10px;
            width: 16px;
            border-radius: 50%;
        }
        /*保存按钮*/
        .ButtonContainer {
            padding: 0 10px 10px 10px;
            width: auto;
            height: 26px;
        }

            .ButtonContainer ul li .Button {
                margin-right: 5px;
                vertical-align: top;
            }

        li.Button {
            -ms-flex-align: center;
            align-items: center;
            background: #f0f0f0;
            background: -moz-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -webkit-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -ms-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%);
            border: 1px solid #d7d7d7;
            display: -ms-inline-flexbox;
            display: inline-flex;
            color: #4f4f4f;
            cursor: pointer;
            height: 24px;
            padding: 0 3px;
            position: relative;
            text-decoration: none;
        }
        .searchcontent {
            width: 100%;
            height: 100%;
            min-width: 2200px;
        }

            .searchcontent table th {
                background-color: #cbd9e4;
                border-color: #98b4ca;
                color: #64727a;
                height: 28px;
                line-height: 28px;
                text-align: center;
            }
            .ticketHistoryGridHeader {
    padding-left: 10px;
    padding-bottom: 10px;
    color: #666666;
    font-size: 12px;
    font-weight: bold;
    text-transform: uppercase;
}
            span.Icon {
    width: 16px;
    height: 16px;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">工单历史 - <%=thisTicket.no %> - <%=thisTicket.title %></span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <div class="ButtonContainer">
            <ul id="btn">
                <li class="Button ButtonIcon NormalState" id="SaveButton" tabindex="0">
                    <span class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -113px 0;"></span>
                    <span class="Text"></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="ReflashButton" tabindex="0">
                    <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -288px 0;"></span>
                    <span class="Text"></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></span>
                    <span class="Text" style="margin-left:5px;">取消</span>
                </li>
            </ul>
        </div>
        <div class="DivScrollingContainer General">
            <%if (thisTicket.sla_id != null)
                { %>
            <div id="slaDiv">
                <div style="padding-top: 10px; padding-bottom: 10px;" class="searchpanel">
                    <span class="ticketHistoryGridHeader">服务等级协议</span>
                </div>
                <div>
                    <iframe src="../Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_SLA_LIST %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TICKET_SLA_LIST %>&con1760=<%=thisTicket.id %>" scrolling="yes"  style="width:100%;height:250px;border-width: 0px;">
                        
                    </iframe>
                </div>
            </div>
            <%} %>
            <div id="ticketDiv">
                <div style="padding-top: 10px; padding-bottom: 10px;" class="searchpanel">
                    <span class="ticketHistoryGridHeader">工单历史</span>
                </div>
                <div>
                    <iframe src="../Project/TaskHistory?task_id=<%=thisTicket.id %>&fromTicket=1"  scrolling="yes"  style="width:100%;height:600px;border-width: 0px;"></iframe>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    $("#ReflashButton").click(function () {
        location.reload();
    })
    $("#CancelButton").click(function () {
        window.close();
    })
</script>
