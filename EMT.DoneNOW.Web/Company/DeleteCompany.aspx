<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeleteCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.DeleteCompany" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>删除客户</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <%--    <link rel="stylesheet" type="text/css" href="../Content/NewCompany.css" />--%>
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css" />
</head>
<body>
    <form id="form1" runat="server">

        <%  var account = GetAccount();
            var location = GetDefaultLocation();
            var taxRegion = dic.FirstOrDefault(_ => _.Key == "taxRegion").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var classification = dic.FirstOrDefault(_ => _.Key == "classification").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var sys_resource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var competition = dic.FirstOrDefault(_ => _.Key == "competition").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var market_segment = dic.FirstOrDefault(_ => _.Key == "market_segment").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var district = dic.FirstOrDefault(_ => _.Key == "district").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var territory = dic.FirstOrDefault(_ => _.Key == "territory").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var company_type = dic.FirstOrDefault(_ => _.Key == "company_type").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var sufix = dic.FirstOrDefault(_ => _.Key == "sufix").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var action_type = dic.FirstOrDefault(_ => _.Key == "action_type").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var country = dic.FirstOrDefault(_ => _.Key == "country").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;//district
            var addressdistrict = dic.FirstOrDefault(_ => _.Key == "addressdistrict").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
        %>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="Delete" runat="server" Text="删除客户" BorderStyle="None" OnClick="Delete_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="tianjia" runat="server" Text="关闭" BorderStyle="None" /></li>
            </ul>
        </div>
        <div class="text">该客户有以下关联信息，如果你确定删除该客户，请点击【删除客户】按钮</div>


        <div id="ComapnyDetail" style="margin-left: 40px;">
            <h4>1 .   公司简介</h4>
            <p><%=account.name %></p>
            <p><%=country.First(_=>_.val.ToString()==location.country_id.ToString()).show  %></p>
            <p><%=addressdistrict.First(_=>_.val.ToString()==location.provice_id.ToString()).show  %></p>
            <p><%=addressdistrict.First(_=>_.val.ToString()==location.city_id.ToString()).show  %></p>
            <p><%=addressdistrict.First(_=>_.val.ToString()==location.district_id.ToString()).show  %></p>
            <% if (!string.IsNullOrEmpty(location.address))
                { %>
            <p><%=location.address %></p>
            <%} %>

            <% if (!string.IsNullOrEmpty(location.additional_address))
                { %>
            <p><%=location.additional_address %></p>
            <%} %>
            <% if (!string.IsNullOrEmpty(account.phone))
                { %>
            <p><%=account.phone %></p>
            <%} %>
        </div>
        <div id="OutsourceManagement" style="margin-left: 40px;">
            <h4>2.  外部资源管理</h4>
        </div>
        <div id="OutsourceNetworks" style="margin-left: 40px;">
            <h4>3.  外部网络</h4>
        </div>
        <div id="Contacts" style="margin-left: 40px;">
            <h4>4.  联系人</h4>
        </div>
        <div id="PostedBillingItems" style="margin-left: 40px;">
            <h4>5.  已提交计费项</h4>
        </div>
        <div id="Opportunities" style="margin-left: 40px;">
            <h4>6.  商机</h4>
        </div>
        <div id="ToDos" style="margin-left: 40px;">
            <h4>7.  待办</h4>
        </div>
        <div id="Activities" style="margin-left: 40px;">
            <h4>8.  活动</h4>
        </div>
        <div id="ConfigurationItems" style="margin-left: 40px;">
            <h4>9.  配置项</h4>
        </div>
        <div id="Projects" style="margin-left: 40px;">
            <h4>10.  项目</h4>
        </div>
        <div id="ExpenseReports" style="margin-left: 40px;">
            <h4>11.  费用报告</h4>
        </div>
        <div id="Tickets" style="margin-left: 40px;">
            <h4>12.  工单</h4>
        </div>
        <div id="ServiceDeskRecurringMasterTickets" style="margin-left: 40px;">
            <h4>13.  服务台循环主工单</h4>
        </div>
        <div id="Notes" style="margin-left: 40px;">
            <h4>14.  备注</h4>
        </div>
        <div id="Contracts" style="margin-left: 40px;">
            <h4>15.  合同</h4>
        </div>
        <div id="Products" style="margin-left: 40px;">
            <h4>16.  产品</h4>
        </div>
        <div id="PurchaseOrders" style="margin-left: 40px;">
            <h4>17.  采购单</h4>
        </div>
        <div id="Services" style="margin-left: 40px;">
            <h4>18.  服务</h4>
        </div>


    </form>
</body>
</html>
