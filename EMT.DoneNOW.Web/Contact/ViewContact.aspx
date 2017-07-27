<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewContact.aspx.cs" Inherits="EMT.DoneNOW.Web.Contact.ViewContact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
       <title>查看联系人</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
</head>
<body>
    <form id="form1" runat="server">
         <%  
             var defaultLocation = locationBLL.GetLocationByAccountId(account.id);
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
           <div class="header">
            <i>
                <ul>
                    <li>活动</li>
                    <li>待办</li>
                    <li>备注</li>
                    <li><a href="ViewCompany.aspx?id=<%=account.id %>&type=opportunity"  target="view_window">商机</a></li>                      
                    <li>联系人组</li>
                    <li>工单</li>                 
                    <li>配置项</li> 
                </ul>
            </i>
            COMPANY-<%=account.name %>
        </div>
    </form>
</body>
</html>
