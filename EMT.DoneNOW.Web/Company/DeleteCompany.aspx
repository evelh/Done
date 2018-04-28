<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeleteCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.DeleteCompany" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>删除客户</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <%--    <link rel="stylesheet" type="text/css" href="../Content/NewCompany.css" />--%>
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <style>
        td{
            text-align:left;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <%  
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
                <li id="close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    关闭</li>
            </ul>
        </div>
        <div class="text">该客户有以下关联信息，如果你确定删除该客户，请点击【删除客户】按钮</div>


        <div id="ComapnyDetail" style="margin-left: 40px;">
            <h4>公司简介</h4>
            <p><%=crm_account.name %></p>
            <p><%=country.First(_=>_.val.ToString()==location.country_id.ToString()).show  %></p>
            <p><%=addressdistrict.First(_=>_.val.ToString()==location.province_id.ToString()).show  %></p>
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
            <% if (!string.IsNullOrEmpty(crm_account.phone))
                { %>
            <p><%=crm_account.phone %></p>
            <%} %>
        </div>
     <%--   <div id="OutsourceManagement" style="margin-left: 40px;">
            <h4> 外部资源管理</h4>
        </div>
        <div id="OutsourceNetworks" style="margin-left: 40px;">
            <h4>外部网络</h4>
        </div>--%>
        <div id="Contacts" style="margin-left: 40px;">
            <h4>联系人</h4>
            <% if (contactList != null && contactList.Count > 0)
                { %>
            <table>
                <%foreach (var contact in contactList)
                    {%>
                <tr>
                    <td><%=contact.name %> - 电话号码：<%=contact.phone %></td>
                </tr>
                   <% } %>

            </table>
            <%}
            else
            {%>
              <p><span style="color:red;">无</span></p>
            <%} %>
        </div>
        <div id="PostedBillingItems" style="margin-left: 40px;">
            <h4>已提交计费项</h4>
        </div>
        <div id="Opportunities" style="margin-left: 40px;">
            <h4>商机</h4>
             <% if (opportunityList != null && opportunityList.Count > 0)
                { %>
            <table>
                <%foreach (var opportunity in opportunityList)
                    {%>
                <tr>
                    <td><%=opportunity.name %></td>
                </tr>
                   <% } %>

            </table>
            <%}
            else
            {%>
              <p><span style="color:red;">无</span></p>
            <%} %>
        </div>
        <div id="ToDos" style="margin-left: 40px;">
            <h4>待办</h4>
             <% if (todoList != null && todoList.Count > 0)
                { %>
            <table>
                <%foreach (var todo in todoList)
                    {%>
                <tr>
                    <td><%=todo.description %></td>
                </tr>
                   <% } %>

            </table>
            <%}
            else
            {%>
              <p><span style="color:red;">无</span></p>
            <%} %>
        </div>
        <div id="Activities" style="margin-left: 40px;">
            <h4>活动</h4>
        </div>
        <div id="ConfigurationItems" style="margin-left: 40px;">
            <h4>配置项</h4>
              <% if (insProList != null && insProList.Count > 0&&AllProductList!=null&&AllProductList.Count>0)
                { %>
            <table>
                <%foreach (var insPro in insProList)
                    {
                        var thisProduct = AllProductList.FirstOrDefault(_ => _.id == insPro.product_id);
                        if (thisProduct == null)
                        {
                            continue;
                        }
                        %>
                <tr>
                    <td><%=thisProduct.name %> - 参考号：<%=insPro.reference_number %></td>
                </tr>
                   <% } %>

            </table>
            <%}
            else
            {%>
              <p><span style="color:red;">无</span></p>
            <%} %>
        </div>
        <div id="Projects" style="margin-left: 40px;">
            <h4>项目</h4>
              <% if (projectList != null && projectList.Count > 0)
                { %>
            <table>
                <%foreach (var project in projectList)
                    {
                        %>
                <tr>
                    <td><%=project.name %></td>
                </tr>
                   <% } %>

            </table>
            <%}
            else
            {%>
              <p><span style="color:red;">这个客户没有关联项目</span></p>
            <%} %>
        </div>
        <div id="ExpenseReports" style="margin-left: 40px;">
            <h4>费用报告</h4>
        </div>
        <div id="Tickets" style="margin-left: 40px;">
            <h4>工单</h4>
               <% if (accTicketList != null && accTicketList.Count > 0)
                { %>
            <table>
                <%foreach (var accTicket in accTicketList)
                    {
                        %>
                <tr>
                    <td><%=accTicket.title %></td>
                </tr>
                   <% } %>

            </table>
            <%}
            else
            {%>
              <p><span style="color:red;">这个客户没有关联项目</span></p>
            <%} %>
        </div>
        <div id="ServiceDeskRecurringMasterTickets" style="margin-left: 40px;">
            <h4>服务台循环主工单</h4>
               <% if (accMasterTicketList != null && accMasterTicketList.Count > 0)
                { %>
            <table>
                <%foreach (var accTicket in accMasterTicketList)
                    {
                        %>
                <tr>
                    <td><%=accTicket.title %></td>
                </tr>
                   <% } %>

            </table>
            <%}
            else
            {%>
              <p><span style="color:red;">无</span></p>
            <%} %>
        </div>
        <div id="Notes" style="margin-left: 40px;">
            <h4>备注</h4>
        </div>
        <div id="Contracts" style="margin-left: 40px;">
            <h4>合同</h4>
        </div>
        <div id="Products" style="margin-left: 40px;">
            <h4>产品</h4>
        </div>
        <div id="PurchaseOrders" style="margin-left: 40px;">
            <h4>采购单</h4>
        </div>
        <div id="Services" style="margin-left: 40px;">
            <h4>服务</h4>
        </div>


    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    $("#close").click(function () {
        window.close();
    })
</script>
