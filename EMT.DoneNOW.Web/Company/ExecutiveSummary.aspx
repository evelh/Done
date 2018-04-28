<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExecutiveSummary.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.ExecutiveSummary" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style>
        td{
            border:1px solid black;
        }
        body{
            font-size:10pt;
             font-size: 12px;
    background: #fff;
    left: 0;
    position: relative;
    top: 0;
    min-width: 700px;
        }
        .Boild{
            font-weight:600;
        }
    </style>
</head>
<body>
    
        <div style="margin-left: calc(50% - 300px);margin-top:20px;">
            <table cellspacing="0"  cellpadding="0" style="width:600px;">
                <tr>
                    <td style="font-weight:600;"><%=account.name %>
                        <br />
                        <%=countryName+" "+provinceName+" "+cityName+" "+districtName %>
                        <%if (accLocation != null)
                            { %>
                        <%=accLocation.address+" "+accLocation.additional_address %>
                        <%} %>
                        <br />
                        <br />  <br />
                    </td>
                    <td rowspan="3" style="text-align: center;vertical-align: middle;width:40%;"><img src="..<%=accClass!=null?accClass.icon_path:"" %>" /></td>
                </tr>
                <tr>
                    <td><%=accMan!=null?accMan.name:"" %>
                        <br />
                        <br />
                        <%=accMan!=null?accMan.home_phone:"" %></td>
                </tr>
                <tr>
                    <td>报表周期
                        <br />
                       <%=startDate.ToString("yyyy-MM-dd") %> - <%=endDate.ToString("yyyy-MM-dd") %> </td>
                </tr>
                <tr>
                   <td colspan="2">
                       <div style="width:100%;height:100%;">
                           <br />
                           <span class="Boild" style="font-size:11pt;">财务回顾</span>
                           <br />
                           <div style="padding-left:20px;">
                               <br />
                               <span  class="Boild">合同</span>
                               <br />
                               <span>周期总价：</span><span style="text-align:right;margin-right:20px;float:right;">￥<%=contractMoney.ToString("#0.00") %></span>
                               <br />
                               <span  class="Boild">项目</span>
                               <br />
                               <span>周期总价：</span><span style="text-align:right;margin-right:20px;float:right;">￥<%=projectMoney.ToString("#0.00") %></span>
                               <br />
                           </div>
                       </div>
                   </td>
                </tr>
            </table>
        </div>
    
</body>
</html>
