<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractView.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <title>查看合同</title>
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
    float:right;
    margin-top: 8px;
}
             .BookmarkButton.Selected div {
    border-color: #f9d959;
}
        .BookmarkButton>.LowerLeftPart {
    border-right-width: 8px;
    border-bottom-width: 6px;
    border-left-width: 8px;
    top: 5px;
    -moz-transform: rotate(35deg);
    -webkit-transform: rotate(35deg);
    -ms-transform: rotate(35deg);
    transform: rotate(35deg);
}
        .BookmarkButton>.LowerRightPart {
    border-right-width: 8px;
    border-bottom-width: 6px;
    border-left-width: 8px;
    top: 5px;
    -moz-transform: rotate(-35deg);
    -webkit-transform: rotate(-35deg);
    -ms-transform: rotate(-35deg);
    transform: rotate(-35deg);
}
        .BookmarkButton>div.LowerLeftPart, .BookmarkButton>div.LowerRightPart, .BookmarkButton>div.UpperPart {
    border-left-color: transparent;
    border-right-color: transparent;
    border-style: solid;
    border-top: none;
    height: 0;
    position: absolute;
    width: 0;
}
        .BookmarkButton>.UpperPart {
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
                <li class="MenuLink"><a href="ContractView.aspx?id=<%=contract.id %>">摘要</a></li>
                <li class="MenuLink"><a href="ContractView.aspx?type=InternalCost&id=<%=contract.id %>">内部成本</a></li>
                <li class="MenuLink"><a href="ContractView.aspx?type=item&id=<%=contract.id %>">配置项</a></li>
                <li class="MenuLink"><a href="ContractView.aspx?type=exclusions&id=<%=contract.id %>">例外因素</a></li>
                <li class="MenuLink"><a href="ContractView.aspx?type=charge&id=<%=contract.id %>">成本</a></li>
                <li class="MenuLink"><a href="ContractView.aspx?type=defaultCost&id=<%=contract.id %>">默认成本</a></li>
              <li class="MenuLink"><a href="ContractView.aspx?type=note&id=<%=contract.id %>">备注</a></li>
                <% if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.TIME_MATERIALS
                        ||contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER
                        ||contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.FIXED_PRICE) { %>
                <li class="MenuLink"><a href="ContractView.aspx?type=roleRate&id=<%=contract.id %>">费率</a></li>
                <%} %>
                <% if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) { %>
                <li class="MenuLink"><a href="ContractView.aspx?type=service&id=<%=contract.id %>">服务</a></li>
                <%} %>
                <% if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.FIXED_PRICE) { %>
                <li class="MenuLink"><a href="ContractView.aspx?type=milestone&id=<%=contract.id %>">里程碑</a></li>
                <%} %>
                <% if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER) { %>
                <li class="MenuLink"><a href="ContractView.aspx?type=block&id=<%=contract.id %>">预付费管理</a></li>
                <%} %>
                <% if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS)
                { %>
                <li class="MenuLink"><a href="ContractView.aspx?type=blockTime&id=<%=contract.id %>">预付时间</a></li>
                <li class="MenuLink"><a href="ContractView.aspx?type=rate&id=<%=contract.id %>">预付时间系数</a></li>
                <%} %>
                <% if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.PER_TICKET) { %>
                <li class="MenuLink"><a href="ContractView.aspx?type=blockTicket&id=<%=contract.id %>">事件</a></li>
                <%} %>
                <% if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS
                        ||contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER
                        ||contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.PER_TICKET) { %>
                <li class="MenuLink"><a href="ContractView.aspx?type=rule&id=<%=contract.id %>">通知发送规则</a></li>
                <%} %>
                <% if (contract.type_id != (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.PER_TICKET) { %>
                <li class="MenuLink"><a href="ContractView.aspx?type=project&id=<%=contract.id %>">项目</a></li>
                <%} %>
                
                <li class="MenuLink"><a href="ContractView.aspx?type=ticket&id=<%=contract.id %>">工单</a></li>
                <li class="MenuLink"><a href="ContractView.aspx?type=udf&id=<%=contract.id %>">自定义字段</a></li>
                 
            </ul>
        </div>
        <div class="Right">
             <div class="HeaderRow" <% if (Request.QueryString["type"] == "ticket")
                { %>  style="display:none;" <%} %>>
                 <asp:Label ID="ShowTitle" runat="server" Text="Label"></asp:Label>
                 <div id="bookmark" class="BookmarkButton <%if (thisBookMark != null)
                { %>Selected<%} %> " onclick="ChangeBookMark()">
                <div class="LowerLeftPart"></div>
                <div class="LowerRightPart"></div>
                <div class="UpperPart"></div>
            </div>
            </div> 
            <iframe runat="server" id="viewContractIframe" name="viewContractIframe" width="100%" height="92%" frameborder="0" marginheight="0" marginwidth="0" style="overflow: scroll;"></iframe>
            <iframe runat="server" id="second" width="100%" height="0" frameborder="0" marginheight="0" marginwidth="0" style="overflow: scroll;"></iframe>
        </div>
    </form>


</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    <%
    var type = Request.QueryString["type"]; ;
    if (type == "item" || type == "service") {%>
    $("#viewContractIframe").css("height", "45%");
    $("#second").css("height", "48%");
    <%} %>

    function ChangeBookMark() {
        //$("#bookmark").removeAttr("click");
        var url = '<%=Request.Url.LocalPath %>?id=<%=contract?.id %>';
         var title = '查看合同:<%=contract?.name %>';
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
