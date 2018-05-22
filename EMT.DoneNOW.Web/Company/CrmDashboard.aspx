<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CrmDashboard.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.CrmDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/crmDashboard.css" rel="stylesheet" />
    <title></title>
    <style>
        li{
            list-style:none;
        }
        .OnlyImageButton{
                background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
    border: 1px solid #bcbcbc;
    display: inline-block;
    color: #4F4F4F;
    cursor: pointer;
    padding: 0 5px 0 3px;
    position: relative;
    text-decoration: none;
    vertical-align: middle;
    height: 22px;
    margin-left:-4px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">CRM仪表板-<span id="SelectTypeSpan"></span></div>
        <div class="header-title" style="width: 480px;">
            <ul>
                <li style="height:26px;"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;" class="icon-1"></i>
                    新增
                    <i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                        <li onclick="AddAccount()"><a >客户</a></li>
                        <li onclick="AddTodo()"><a >待办</a></li>
                        <li onclick="AddNote()"><a >备注</a></li>
                        <li onclick="AddContact()"><a >联系人</a></li>
                        <li onclick="AddOpportunity()"><a >商机</a></li>
                    </ul>
                </li>
                <li style=" background: linear-gradient(to bottom,#fff 0,#fff 100%);border: 0px;">
                    <span>显示：</span>
                    <select id="queryType" style="height:24px">
            <%if (terrList != null && terrList.Count > 0)
                {%>
            <option value="T|0">全部地域</option>
            <%
                    foreach (var terr in terrList)
                    {%>
            <option value="T|<%=terr.id %>"><%=terr.name %></option>
            <%
                    }%>
            <option disabled="disabled">----------</option>
                   <%} %>
            <%if (resList != null && resList.Count > 0)
                {%>
            <option value="R|0">全部员工</option>
                  <%  foreach (var res in resList)
                    {%>
            <option value="R|<%=res.id %>"><%=res.name %></option>
            <%
                    }} %>

        </select>
                </li>
                <li style=" background: linear-gradient(to bottom,#fff 0,#fff 100%);border: 0px;">
                    <input type="text" style="height:19px;background: linear-gradient(to bottom,#fff 0,#fff 100%);border: 1px solid #CCCCCC;" name="crtName" size="16" id="AccountName" value="" placeholder="查找客户"  />
                   <a class="OnlyImageButton" onclick="SearchAccount()"><img src="../Images/search.png" /></a>
                </li>
            </ul>
        </div>
    
        <table width="1024px" cellspacing="0" cellpadding="0" border="0" style="margin-top: 10px;">
            <tbody>
                <tr>
                    <td colspan="2">
                        <div class="PageLevelInstructions" style="margin-left:10px;margin-bottom:10px;">
                            <span><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">
				按地域过滤时，此页面上的数字基于该地区的员工，而不是与该地区的公司关联。
				</font></font></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="68%" align="center" valign="top">
                        <!--Begin "Sales Alert" set-->
                        <div class="DivSectionWithHeader">
                            <div class="Heading">
                                <span class="Text"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">我的CRM摘要</font></font></span>
                            </div>
                            <div class="Content">


                                <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" align="right" width="30%" class="FieldLabels RightAlign"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">
						 销售警报
						</font></font>
                                                <br>
                                                <img src="../Images/dashboard_salesalert.png"  width="50" height="50"/>
                                            </td>
                                            <td valign="top" width="70%" style="padding-left: 15px;">
                                                <table width="100%" cellspacing="0" cellpadding="3" border="0" class="LinkList">

                                                    <tbody>
                                                        <tr>
                                                            <td width="99%"><font><font>待办：</font></font>
                                                                <% if (resourceId != null && resourceId != 0)
                                                                    { %>
                                                                <a class="PrimaryLink" onclick="showMyTodayToDos('<%=resourceId.ToString() %>')"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">今天（<%=todayTodoCount %>）</font></font></a><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"> | </font></font>
                                                                <%} %>
                                                                <a class="PrimaryLink" id="errorSmall" onclick="showMyOverdueToDos('<%=resourceId!=null&&resourceId!=0?resourceId.ToString():"" %>');"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">逾期（<%=overdueTodoCount %>）</font></font></a></td>

                                                        </tr>
                                                        <tr>
                                                            <td width="99%">
                                                                 <% if (resourceId != null && resourceId != 0)
                                                                     { %>
                                                                <a onclick="showAssignedToOthersToDos('<%=resourceId %>')" style="color: #376597;"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">我分配给他人的打开待办（<%=myAsignToOtherCount %>）</font></font></a>
                                                                 <%}
                                                                 else
                                                                 { %>
                                                                  <span><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">我分配给他人的打开待办（<%=myAsignToOtherCount %>）</font></font></span>
                                                                <%} %>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="99%"><a onclick="showOverdueOpportunities('<%=resourceId!=null&&resourceId!=0?resourceId.ToString():(!string.IsNullOrEmpty(terResIds)?terResIds:(terrId!=null?"0":"")) %>');" style="color: #376597;"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">需要更新的商机（<%=needEditOppoCount %>）</font></font></a></td>
                                                        </tr>
                                                        <tr>
                                                            <td width="99%"><font><font>工单：</font></font><a class="PrimaryLink" style="color: #376597;" onclick="showYesterdayCustomerST();"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">昨天（<%=yesTicketCount %>）</font></font></a><font><font> | </font></font><a class="PrimaryLink" style="color: #376597;" onclick="showTodayCustomerST();"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">今日（<%=todayTicketCount %>）</font></font></a></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <!--End "Sales Alert" set-->
                                <!--Begin "My Sales Metrics this Month" set-->
                                <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" align="right" width="30%" style="padding-top: 10px;" class="FieldLabels RightAlign"><font style="vertical-align: inherit;"></font>
                                                <font style="vertical-align: inherit;"><font style="vertical-align: inherit;">
						本月
						 </font><br /><font style="vertical-align: inherit;">
						销售指标</font></font>
                                                <br>
                                                <img src="../Images/dashboard_salesmetrics.png"  width="50" height="50"/>
                                            </td>
                                            <td valign="top" width="70%" style="padding-left: 15px; padding-top: 10px;">
                                                <table width="220" cellspacing="0" cellpadding="3" border="0" class="LinkList">

                                                    <tbody>
                                                        <tr>
                                                            <td width="1%" align="right"></td>
                                                            <td width="79%"><a style="color: #376597;" onclick="showLostSales();"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">丢失的商机（<%=monthLostOppo %>）</font></font></a></td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"></td>
                                                            <td><a style="color: #376597;" onclick="showOpptnToClose();"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">待关闭的商机（<%=monthCloseOppo %>）</font></font></a></td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"></td>
                                                            <td><a style="color: #376597;" onclick="showClosedSales();"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">已关闭的商机（<%=monthClosedOppo %>）</font></font></a></td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"></td>
                                                            <td><a style="color: #376597;" onclick="showMyPipelineReport();"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">管道报告</font></font></a></td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right"></td>

                                                            <td><a style="color: #376597;" onclick="showMyLeadStatusReport();"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">铅状态报告</font></font></a></td>

                                                        </tr>

                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <!--End "My Sales Metrics this Month" set-->

                                <!--Begin "Sales Quota Performance" set-->
                                <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" align="right" width="30%" style="padding-top: 10px;" class="FieldLabels RightAlign"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">本月
									
							 </font><br />
                                                <font style="vertical-align: inherit;">
							
							销售指标</font></font>
                                                <br />
                                                <font style="vertical-align: inherit;"><font style="vertical-align: inherit;">评估</font></font>
                                                <br />
                                                <font style="vertical-align: inherit;"></font>
                                                <br>
                                                <img src="../Images/dashboard_salesmetrics.png"  width="50" height="50"/>
                                            </td>
                                            <td valign="top" width="70%" style="padding-left: 15px; padding-top: 10px;">
                                                <table width="417" cellspacing="0" cellpadding="3" border="0">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <% var amountPercentage = (monthAmount*100 / (quotaAmount == 0 ? 1 : quotaAmount));
                                                                    var amountColor = "#D11632";
                                                                    if (amountPercentage > 50&&amountPercentage<=75)
                                                                    {
                                                                        amountColor = "#fff799";
                                                                    }
                                                                    else if (amountPercentage > 75)
                                                                    {
                                                                        amountColor = "#02A64F";
                                                                    }
                                                                    // #02A64F 绿    #fff799 黄  #D11632 红
                                                                    %>
                                                                <table border="0" width="100%">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td colspan="3" class="labels"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">总额</font></font></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <table border="1px" class="SalesQuota" bordercolor="#d3d3d3" cellpadding="3" cellspacing="3" width="100%" style="border-collapse: collapse; margin-bottom: 5px;">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td align="center" width="20%" title=""><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=monthAmount.ToString("#0.00") %></font></font></td>
                                                                                            <td width="25%">
                                                                                                <table bgcolor="<%=amountColor %>" width="<%=amountPercentage>50?100:(amountPercentage*100/50) %>%" height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="15%">
                                                                                                <%if (amountPercentage > 50)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=amountColor %>" width="<%=amountPercentage>75?100:((amountPercentage-50)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %>
                                                                                                </td>
                                                                                            <td width="15%">
                                                                                                 <%if (amountPercentage > 75)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=amountColor %>" width="<%=amountPercentage>100?100:((amountPercentage-75)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %>
                                                  
                                                                                            </td>
                                                                                            <td align="center" style="padding-left: 5px;" class="" width="25%" title="销售配额"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=quotaAmount.ToString("#0.00") %></font></font></td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                <table border="0" width="100%">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td colspan="3" class="labels"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">专业的服务</font></font></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                 <% 
                                                                                     var prodessPercentage = (prodessAmount*100 / (quotaProdess == 0 ? 1 : quotaProdess));
                                                                                     var prodessColor = "#D11632";
                                                                                     if (prodessPercentage > 50&&prodessPercentage<=75)
                                                                                     {
                                                                                         prodessColor = "#fff799";
                                                                                     }
                                                                                     else if (prodessPercentage > 75)
                                                                                     {
                                                                                         prodessColor = "#02A64F";
                                                                                     }
                                                                                     // #02A64F 绿    #fff799 黄  #D11632 红
                                                                    %>
                                                                                <table border="1px" class="SalesQuota" bordercolor="#d3d3d3" cellpadding="3" cellspacing="3" width="100%" style="border-collapse: collapse; margin-bottom: 5px;">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td align="center" width="20%" title="本月总共关闭的机会"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=prodessAmount.ToString("#0.00") %></font></font></td>
                                                                                            <td width="25%">
                                                                                                 <table bgcolor="<%=prodessColor %>" width="<%=prodessPercentage>50?100:(prodessPercentage*100/50) %>%" height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="15%">
                                                                                                 <%if (prodessPercentage > 50)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=prodessColor %>" width="<%=prodessPercentage>75?100:((prodessPercentage-50)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %>

                                                                                            </td>
                                                                                            <td width="15%">
                                                                                                <%if (prodessPercentage > 75)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=prodessColor %>" width="<%=prodessPercentage>100?100:((prodessPercentage-75)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %></td>
                                                                                            <td align="center" style="padding-left: 5px;" class="" width="25%" title="销售配额"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=quotaProdess.ToString("#0.00") %></font></font></td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                <table border="0" width="100%">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td colspan="3" class="labels"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">培训费用</font></font></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                 <% var trainsPercentage = (trainsAmount*100 / (quotaTrains == 0 ? 1 : quotaTrains));
                                                                    var trainsColor = "#D11632";
                                                                    if (trainsPercentage > 50&&trainsPercentage<=75)
                                                                    {
                                                                        trainsColor = "#fff799";
                                                                    }
                                                                    else if (trainsPercentage > 75)
                                                                    {
                                                                        trainsColor = "#02A64F";
                                                                    }
                                                                    // #02A64F 绿    #fff799 黄  #D11632 红
                                                                    %>
                                                                                <table border="1px" class="SalesQuota" bordercolor="#d3d3d3" cellpadding="3" cellspacing="3" width="100%" style="border-collapse: collapse; margin-bottom: 5px;">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td align="center" width="20%" title="本月总共关闭的机会"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=trainsAmount.ToString("#0.00") %></font></font></td>
                                                                                            <td width="25%">
                                                                                               
                                                                                                <table bgcolor="<%=trainsColor %>" width="<%=trainsPercentage>50?100:(trainsPercentage*100/50) %>%" height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="15%">
                                                   <%if (trainsPercentage > 50)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=trainsColor %>" width="<%=trainsPercentage>75?100:((trainsPercentage-50)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %></td>
                                                                                            <td width="15%">
                                                                                               <%if (trainsPercentage > 75)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=trainsColor %>" width="<%=trainsPercentage>100?100:((trainsPercentage-75)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %></td>
                                                                                            <td align="center" style="padding-left: 5px;" class="" width="25%" title="销售配额"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=quotaTrains.ToString("#0.00") %></font></font></td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                <table border="0" width="100%">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td colspan="3" class="labels"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">硬件费用</font></font></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                 <% var hardwarePercentage = (hardwareAmount*100 / (quotaHardware == 0 ? 1 : quotaHardware));
                                                                    var hardwareColor = "#D11632";
                                                                    if (hardwarePercentage > 50&&hardwarePercentage<=75)
                                                                    {
                                                                        hardwareColor = "#fff799";
                                                                    }
                                                                    else if (hardwarePercentage > 75)
                                                                    {
                                                                        hardwareColor = "#02A64F";
                                                                    }
                                                                    // #02A64F 绿    #fff799 黄  #D11632 红
                                                                    %>
                                                                                <table border="1px" class="SalesQuota" bordercolor="#d3d3d3" cellpadding="3" cellspacing="3" width="100%" style="border-collapse: collapse; margin-bottom: 5px;">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td align="center" width="20%" title="本月总共关闭的机会"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=hardwareAmount.ToString("#0.00") %></font></font></td>
                                                                                            <td width="25%">
                                                                                                
 <table bgcolor="<%=hardwareColor %>" width="<%=hardwarePercentage>50?100:(hardwarePercentage*100/50) %>%" height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="15%">
                                                                                                 <%if (hardwarePercentage > 50)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=hardwareColor %>" width="<%=hardwarePercentage>75?100:((hardwarePercentage-50)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %></td>
                                                                                            <td width="15%">
                                                                                                    <%if (hardwarePercentage > 75)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=hardwareColor %>" width="<%=hardwarePercentage>100?100:((hardwarePercentage-75)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %></td>
                                                                                            <td align="center" style="padding-left: 5px;" class="" width="25%" title="销售配额"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=quotaHardware.ToString("#0.00") %></font></font></td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                <table border="0" width="100%">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td colspan="3" class="labels"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">每月用户费用</font></font></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                 <% var monthPercentage = (monthFeeAmount*100 / (quotaMonthFee == 0 ? 1 : quotaMonthFee));
                                                                    var monthColor = "#D11632";
                                                                    if (monthPercentage > 50&&monthPercentage<=75)
                                                                    {
                                                                        monthColor = "#fff799";
                                                                    }
                                                                    else if (monthPercentage > 75)
                                                                    {
                                                                        monthColor = "#02A64F";
                                                                    }
                                                                    // #02A64F 绿    #fff799 黄  #D11632 红
                                                                    %>
                                                                                <table border="1px" class="SalesQuota" bordercolor="#d3d3d3" cellpadding="3" cellspacing="3" width="100%" style="border-collapse: collapse; margin-bottom: 5px;">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td align="center" width="20%" title="本月总共关闭的机会"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=monthFeeAmount.ToString("#0.00") %></font></font></td>
                                                                                            <td width="25%">
                                                                                                
 <table bgcolor="<%=monthColor %>" width="<%=monthPercentage>50?100:(monthPercentage*100/50) %>%" height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="15%">
                                                                                             <%if (monthPercentage > 50)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=monthColor %>" width="<%=monthPercentage>75?100:((monthPercentage-50)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %>    
                                                                                            </td>
                                                                                            <td width="15%">
                                                                                               <%if (monthPercentage > 75)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=monthColor %>" width="<%=monthPercentage>100?100:((monthPercentage-75)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %></td>
                                                                                            <td align="center" style="padding-left: 5px;" class="" width="25%" title="销售配额"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=quotaMonthFee.ToString("#0.00") %></font></font></td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td>
                                                                <table border="0" width="100%">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td colspan="3" class="labels"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">其他费用</font></font></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                 <% var otherPercentage = (otherAmount*100 / (quotaOther == 0 ? 1 : quotaOther));
                                                                    var otherColor = "#D11632";
                                                                    if (otherPercentage > 50&&otherPercentage<=75)
                                                                    {
                                                                        otherColor = "#fff799";
                                                                    }
                                                                    else if (otherPercentage > 75)
                                                                    {
                                                                        otherColor = "#02A64F";
                                                                    }
                                                                    // #02A64F 绿    #fff799 黄  #D11632 红
                                                                    %>
                                                                                <table border="1px" class="SalesQuota" bordercolor="#d3d3d3" cellpadding="3" cellspacing="3" width="100%" style="border-collapse: collapse; margin-bottom: 5px;">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td align="center" width="20%" title="本月总共关闭的机会"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=otherAmount.ToString("#0.00") %></font></font></td>
                                                                                            <td width="25%">
                                                                                               
 <table bgcolor="<%=otherColor %>" width="<%=otherPercentage>50?100:(otherPercentage*100/50) %>%" height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="15%">
                                                                                                 <%if (otherPercentage > 50)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=otherColor %>" width="<%=otherPercentage>75?100:((otherPercentage-50)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %></td>
                                                                                            <td width="15%">
                                                                                                <%if (otherPercentage > 75)
                                                                                                    { %>
                                                                                                 <table bgcolor="<%=otherColor %>" width="<%=otherPercentage>100?100:((otherPercentage-75)*100/25) %>%"  height="16px">
                                                                                                    <tbody>
                                                                                                        <tr>
                                                                                                            <td title=""></td>
                                                                                                        </tr>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                                <%} %></td>
                                                                                            <td align="center" style="padding-left: 5px;" class="" width="25%" title="销售配额"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=quotaOther.ToString("#0.00") %></font></font></td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>

                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <!--End "My Sales Metrics this Month" set-->


                                <!--Begin "My Call Metrics this Month" set-->
                                <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" align="right" width="30%" style="padding-top: 10px;" class="FieldLabels RightAlign"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">
						
								本月活动指标
							</font></font>
                                                <br>
                                                <img src="../Images/dashboard_callmetrics.png"  width="50" height="50"/>
                                            </td>
                                            <td valign="top" width="70%" style="padding-left: 15px; padding-top: 10px;">
                                                <table width="220" cellspacing="0" cellpadding="3" border="0">
                                                    <tbody>
                                                        <tr>


                                                            <td width="99%"><a style="color: #376597;" onclick="callSummaryReport();"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">通话摘要报告</font></font></a></td>

                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <% if (updateOppoNoteCount > 0)
                                                    { %>
                                                <table width="220" cellspacing="0" cellpadding="3" border="0" style="padding-top: 4px;">

                                                    <tbody>
                                                        <tr style="height: 18px; vertical-align: top;">
                                                            <td width="70%"><a style="color: #376597;" onclick="showActions('0')"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">商机更新（<%=updateOppoNoteCount %>）</font></font></a></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <%} %>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </td>
                    <!--End "My Call Metrics this Month" set-->

                    <!--Begin "Account Spotlight" set-->
                    <td width="32%" align="center" valign="top">
                        <div class="DivSectionWithHeader">
                            <div class="Heading">
                                <span class="Text"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">聚光灯</font></font></span>
                            </div>
                            <div class="Content">
                                <table cellspacing="3" cellpadding="0" border="0" width="100%" class="SingleLine">

                                    <tbody>
                                        <tr>
                                            <td width="70%"><a style="color: #376597;" onclick="showMyCustomerList('<%=resourceId!=null&&resourceId!=0?resourceId.ToString():"" %>','<%=terrId!=null&&terrId!=0?terrId.ToString():"" %>');"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">公司</font></font></a></td>
                                            <td width="30%" align="right"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"><%=accountCount %></font></font></td>
                                        </tr>
                                        <tr>
                                            <td width="70%">
                                                <a style="color: #376597;" onclick="showActiveOpportunities();"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">积极的机会</font></font></a>
                                            </td>
                                            <td width="30%" align="right"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"><%=activeOppoCount %></font></font></td>
                                        </tr>
                                        <tr>
                                            <td width="70%">
                                                <a style="color: #376597;" onclick="showNewOpportunitiesThisMonth();"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">本月新的机会</font></font></a>
                                            </td>
                                            <td width="30%" align="right"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"><%=newOppoMonthCount %></font></font></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="DivSectionWithHeader">
                            <div class="Heading">
                                <span class="Text"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">区域</font></font></span>
                            </div>
                            <div class="Content">
                                <table width="100%" cellspacing="3" cellpadding="0" border="0" class="SingleLine">

                                    <tbody>
                                        <% if (terrAccDic != null && terrAccDic.Count > 0)
                                            {
                                                foreach (var terrAcc in terrAccDic)
                                                {
                                                    var thisTerr = terrList.FirstOrDefault(_ => _.id == terrAcc.Key);
                                                    if (thisTerr == null)
                                                    {
                                                        continue;
                                                    }
                                                     %>
                                        <tr>
                                            <td width="70%">

                                                <a style="color: #376597;" onclick="showAccountsOfTerritory ('<%=terrAcc.Key %>')"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"><%=thisTerr.name %></font></font></a>

                                            </td>
                                            <td width="30%" align="right"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"><%=terrAcc.Value %></font></font></td>
                                        </tr>
                                        <%
                                                }
                                               } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="DivSectionWithHeader">
                            <div class="Heading">
                                <span class="Text"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">分类</font></font></span>
                            </div>
                            <div class="Content">
                                <table width="100%" cellspacing="3" cellpadding="0" border="0" class="SingleLine">
                                    <tbody>
                                        <% if (accClassList != null && accClassList.Count > 0)
                                            {
                                                foreach (var accCalss in accClassList)
                                                {  %>
                                        <tr>
                                            <td width="10%">
                                                <%if (!string.IsNullOrEmpty(accCalss.icon_path)){ %>
                                                <img src="..<%=accCalss.icon_path %>" border="0" />
                                                <%} %>
                                            </td>
                                            <td width="60%">
                                                <a style="color: #376597;" onclick="showKeyAccounts('<%=accCalss.id %>','<%=resourceId!=null&&resourceId!=0?resourceId.ToString():"" %>','<%=terrId!=null&&terrId!=0?terrId.ToString():"" %>')"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"><%=accCalss.name %></font></font></a>
                                            </td>
                                            <td width="30%" align="right"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"><%=classAccDic[accCalss.id] %></font></font></td>
                                        </tr>
                                        <%
                                                }
                                               } %>

                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="DivSectionWithHeader">
                            <div class="Heading">
                                <span class="Text"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">
						积极的机会
					</font></font></span><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"> 
					
						（</font></font><a style="text-transform: capitalize;color: #376597;" onclick="showStagesReport();"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">图表</font></font></a><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">）
					
				</font></font>
                            </div>
                            <div class="Content">
                                <table width="100%" cellspacing="3" cellpadding="0" border="0" class="SingleLine">

                                    <tbody>
                                        <% if (oppoStageList != null && oppoStageList.Count > 0)
                                            {
                                                oppoStageList = oppoStageList.OrderBy(_ =>_.id).ToList();
                                                foreach (var oppoStage in oppoStageList)
                                                {
                                                    var count = 0;
                                                    decimal totalMoney = 0;
                                                    if (activeOppoList != null && activeOppoList.Count > 0)
                                                    {
                                                        var thisStageOppo = activeOppoList.Where(_ => _.stage_id == oppoStage.id).ToList();
                                                        if (thisStageOppo.Count > 0)
                                                        {
                                                            count = thisStageOppo.Count;
                                                            totalMoney = thisStageOppo.Sum(_ => { return oppBLl.ReturnOppoRevenue(_.id); });
                                                        }
                                                    }

                                                    %>
                                        <tr>
                                            <td width="70%" valign="top">
                                                <a  onclick="showProposalsOnStage ('<%=oppoStage.id.ToString() %>','<%=resourceId!=null&&resourceId!=0?resourceId.ToString():(!string.IsNullOrEmpty(terResIds)?terResIds:(terrId!=null?"0":"")) %>')" style="color: #376597;"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"><%=oppoStage.name %></font></font></a>
                                            </td>
                                            <td width="10%" valign="top"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"><%=count %></font></font></td>
                                            <td width="20%" valign="top" align="right"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=totalMoney.ToString("#0.00") %></font></font></td>
                                        </tr>
                                        <%
                                                } } %>
                                      

                                        <tr>
                                            <td width="70%" valign="top"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">总</font></font></td>
                                            <td width="10%" valign="top"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"><%=activeOppoList != null ? activeOppoList.Count : 0 %></font></font></td>
                                            <% decimal totalAllMoney = 0;
                                                if (activeOppoList != null && activeOppoList.Count > 0) {
                                                    totalAllMoney = activeOppoList.Sum(_ => { return oppBLl.ReturnOppoRevenue(_.id); }); 
                                                }%>
                                            <td width="20%" valign="top" align="right"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">¥<%=totalAllMoney.ToString("#0.00") %></font></font></td>
                                        </tr>

                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!--End "My Opportunity Pipeline" set-->
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        $("#queryType").val('<%=queryType %>');
        var selectTypeSpan = $("#queryType").find("option:selected").text();
        $("#SelectTypeSpan").text(selectTypeSpan);
    })

    $("#queryType").change(function () {
        location.href = "CrmDashboard?queryType="+$(this).val();
    })

    function showMyTodayToDos(resId) {
        location.href = "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TODOS %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Todos %>&group=112&con662=" + resId +"&con661_l=<%=DateTime.Now.ToString("yyyy-MM-dd") %>&con661_h=<%=DateTime.Now.AddDays(1).ToString("yyyy-MM-dd") %>";
    }

    function showMyOverdueToDos(resId) {
        if ( resId != "" && resId != 0) {
            location.href = "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TODOS %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Todos %>&group=112&con662=" + resId + "&con661_h=<%=DateTime.Now.ToString("yyyy-MM-dd") %>&con665=<%=(int)EMT.DoneNOW.DTO.DicEnum.ACTIVITY_STATUS.NOT_COMPLETED %>";
        }
    }

    function showAssignedToOthersToDos(resId) {
        location.href = "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TODOS %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Todos %>&group=112&param1=3014&param2=" + resId + "&param3=3013&param4=1&con662=" + resId;
    }
    function showOverdueOpportunities(resIds) {
        if (resIds == 0) {
            resIds = "''";
        }
        location.href = "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OPPORTUNITY %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Opportunity %>&group=9&con274=" + resIds+"&con271=<%=(int)EMT.DoneNOW.DTO.DicEnum.OPPORTUNITY_STATUS.ACTIVE %>&con276_h=<%=DateTime.Now.ToString("yyyy-MM-dd") %>";
    }
    // 昨天创建的工单
    function showYesterdayCustomerST() {

    }
    // 今天创建的工单
    function showTodayCustomerST() {

    }

    function showMyCustomerList(resIds, terrId) {
        var where = "";
        if (resIds != "") {
            where += "&param1=82&param2=" + resIds;
        }
        if (terrId != "") {
            where += "&param1=74&param2=" + terrId;
        }
        location.href = "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Company %>&group=11&con17=" + resIds + "&isShow=Search" + where;
    }

    function showAccountsOfTerritory(terrId) {
        location.href = "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Company %>&group=11&isShow=Search&param1=74&param2=" + terrId;
    }
    function showKeyAccounts(accClasssId, resIds, terrId) {
        var where = "";
        if (resIds != "") {
            where += "&param1=82&param2=" + resIds;
        }
        if (terrId != "") {
            where += "&param1=74&param2=" + terrId;
        }
        location.href = "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Company %>&group=11&isShow=Search&param3=80&param4=" + accClasssId + where;
    }
    // 显示相关商机
    function showProposalsOnStage(stageId, resIds) {
        if (resIds == 0) {
            resIds = "''";
        }
        location.href = "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OPPORTUNITY %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Opportunity %>&group=9&con274=" + resIds + "&con271=<%=(int)EMT.DoneNOW.DTO.DicEnum.OPPORTUNITY_STATUS.ACTIVE %>&con269=" + stageId;
    }

    function SearchAccount() {
        var AccountName = $("#AccountName").val();
        if (AccountName == "") {
            LayerMsg("先填写搜索条件！");
            return;
        }
        location.href = "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Company %>&group=11&con70=" + AccountName;
    }

    function AddAccount() {
        window.open("../Company/AddCompany.aspx", windowObj.company + windowType.add, 'left=0,top=0,width=900,height=750,resizable=yes', false);
    }
    function AddTodo() {
        window.open("../Activity/Todos.aspx", windowObj.todos + windowType.add, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
    }
    function AddNote() {
        window.open("../Activity/Notes.aspx", windowObj.notes + windowType.add, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
    }
    function AddContact() {
        window.open("../Contact/AddContact.aspx", windowObj.contact + windowType.add, 'left=0,top=0,width=900,height=750,resizable=yes', false);
    }
    function AddOpportunity() {
        window.open("../Opportunity/OpportunityAddAndEdit.aspx", windowObj.opportunity + windowType.add, 'left=0,top=0,width=900,height=750,resizable=yes', false);
    }
</script>
