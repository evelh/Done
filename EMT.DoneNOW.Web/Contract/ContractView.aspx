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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="Left">
            <div class="HeaderRow">
                <span>菜单</span>
            </div>
            <ul class="ButtonBarVert">
                <li class="MenuLink"><a href="ContractSummary.aspx?id=<%=contract.id %>">摘要</a></li>
                <li class="MenuLink"><a href="ContractView.aspx?type=InternalCost&id=<%=contract.id %>">内部成本</a></li>
                <li class="MenuLink"><a href="ContractView.aspx?type=item&id=<%=contract.id %>">配置项</a></li>
                <li class="MenuLink">例外因素-未实现</li>
                <li class="MenuLink"><a href="ContractView.aspx?type=charge&id=<%=contract.id %>">成本</a></li>
                <li class="MenuLink"><a href="ContractView.aspx?type=defaultCost&id=<%=contract.id %>">默认成本</a></li>
                <li class="MenuLink">备注-未实现</li>
                <% if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.TIME_MATERIALS
                        ||contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER
                        ||contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.FIXED_PRICE) { %>
                <li class="MenuLink"><a href="ContractView.aspx?type=roleRate&id=<%=contract.id %>">费率</a></li>
                <%} %>
                <% if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) { %>
                <li class="MenuLink">服务-未实现</li>
                <%} %>
                <% if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.FIXED_PRICE) { %>
                <li class="MenuLink">里程碑-未实现</li>
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
                <li class="MenuLink">采购工单-未实现</li>
                <%} %>
                <% if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS
                        ||contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER
                        ||contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.PER_TICKET) { %>
                <li class="MenuLink">通知规则-未实现</li>
                <%} %>
                <% if (contract.type_id != (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.PER_TICKET) { %>
                <li class="MenuLink">项目管理-未实现</li>
                <%} %>
                <li class="MenuLink">工单-未实现</li>
                <li class="MenuLink"><a href="ContractView.aspx?type=udf&id=<%=contract.id %>">自定义字段</a></li>
            </ul>
        </div>
        <div class="Right">
             <div class="HeaderRow">
                 <asp:Label ID="ShowTitle" runat="server" Text="Label"></asp:Label>
            </div>
            <iframe runat="server" id="viewContractIframe" width="100%" height="92%" frameborder="0" marginheight="0" marginwidth="0" style="overflow: scroll;"></iframe>
            <iframe runat="server" id="second" width="100%" height="0" frameborder="0" marginheight="0" marginwidth="0" style="overflow: scroll;"></iframe>
        </div>
    </form>


</body>
</html>
