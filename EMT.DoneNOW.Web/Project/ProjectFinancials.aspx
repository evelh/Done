<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectFinancials.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectFinancials" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>项目财务</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link href="../Content/style.css" rel="stylesheet" />
    <link href="../Content/financials.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">项目财务</div>
        <div class="header-title">
            <ul>
                <li id="ClosePage">
                    <img src="../Images/print.png" /></li>
            </ul>
        </div>

        <table cellspacing="0" cellpadding="0" border="0" id="tblOutlineBox" style="margin-top: 0px; margin-left: 10px; width: 98%;">
            <tbody>
                <tr>
                    <td class="titleText" class="titleTd" valign="top" style="text-align: left">项目财务
                    </td>
                    <td class="subTitleText" style="text-align: right;" valign="top"><%=DateTime.Now.ToString("yyyy-MM-dd") %>
                    </td>
                </tr>
                <tr>
                    <td class="titleText" valign="top" style="text-align: left"><%=account?.name %></td>
                    <td class="subTitleText" style="text-align: right;" valign="top"><%=DateTime.Now.ToString("HH:mm") %></td>
                </tr>
                <tr>
                    <td class="titleText" valign="top" style="text-align: left"><%=project?.name %></td>
                    <td class="titleText" style="text-align: right;" valign="top">状态:<%=proStatusList.FirstOrDefault(_=>_.id==project?.status_id)?.name %></td>
                </tr>
                <tr>
                    <td class="titleText" valign="top" style="text-align: left">项目类型:&nbsp;<%=projectTypeList.FirstOrDefault(_=>_.id==project?.type_id)?.name %></td>
                    <td class="subTitleText" style="text-align: right;" valign="top"></td>
                </tr>
            </tbody>
        </table>

        <!-- project totals -->
        <table class="subTitleText Space" cellspacing="0" cellpadding="3" border="0" style="margin-left: 10px; width: 98%;">
            <tbody>
                <tr valign="bottom">
                    <td style="text-align: left;">项目概要			
                    </td>
                </tr>
            </tbody>
        </table>
        <table border="0" cellspacing="0" cellpadding="3" id="tblReport" style="border-collapse: collapse; margin-left: 10px; width: 98%;">
            <tbody>
                <tr>
                    <td class="headerRowText" colspan="3" style="text-align: center; width: 25%;">支出</td>
                    <td class="headerRowText" colspan="3" style="text-align: center; width: 25%;">收入</td>
                    <td class="headerRowText" colspan="2" style="text-align: center; width: 25%;">利润</td>
                    <td class="headerRowText" colspan="2" style="text-align: center; width: 25%;">预估</td>
                </tr>
                <tr height="20">

                    <td class="txtBlack8" colspan="2" style="white-space: nowrap;text-align:right;">已工作时间 : </td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((expPro?.Rows[0][0])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((expPro?.Rows[0][0])??0).ToString("#0.00") %></td>

                    <td class="txtBlack8" colspan="2" style="text-align: right;">已计费时间 : </td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((revPro?.Rows[0][0])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((revPro?.Rows[0][0])??0).ToString("#0.00") %></td>

                    <td class="txtBlack8" colspan="2" style="text-align: right;"></td>

                    <td class="txtBlack8" colspan="2" style="text-align: right;"></td>
                </tr>
                <tr height="20">

                    <td class="txtBlack8" colspan="2" style="text-align: right;">工时: </td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((expPro?.Rows[0][1])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((expPro?.Rows[0][1])??0).ToString("#0.00") %></td>

                    <td class="txtBlack8" colspan="2" style="text-align: right;">工时: </td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((revPro?.Rows[0][1])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((revPro?.Rows[0][1])??0).ToString("#0.00") %></td>

                    <td class="txtBlack8" style="text-align: right;">工时: </td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((profitPro?.Rows[0][0])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((profitPro?.Rows[0][0])??0).ToString("#0.00") %></td>

                    <td class="txtBlack8" style="text-align: right;">工时:</td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((profitPro?.Rows[0][0])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((profitPro?.Rows[0][0])??0).ToString("#0.00") %></td>
                </tr>
                <tr height="20">

                    <td class="txtBlack8" colspan="2" style="text-align: right;">成本: </td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((expPro?.Rows[0][2])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((expPro?.Rows[0][2])??0).ToString("#0.00") %></td>

                    <td class="txtBlack8" colspan="2" style="text-align: right;">成本: </td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((revPro?.Rows[0][2])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((revPro?.Rows[0][2])??0).ToString("#0.00") %></td>

                    <td class="txtBlack8" style="text-align: right;">成本: </td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((profitPro?.Rows[0][1])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((profitPro?.Rows[0][1])??0).ToString("#0.00") %></td>

                    <td class="txtBlack8"  style="text-align: right;" >成本和费用:</td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((yuguPro?.Rows[0][1])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((yuguPro?.Rows[0][1])??0).ToString("#0.00") %></td>
                </tr>
                <tr height="20">
                    <td class="txtBlack8" colspan="2"  style="text-align: right;" >费用:</td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((expPro?.Rows[0][3])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((expPro?.Rows[0][3])??0).ToString("#0.00") %></td>

                    <td class="txtBlack8" colspan="2"  style="text-align: right;" >费用: </td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((revPro?.Rows[0][3])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((revPro?.Rows[0][3])??0).ToString("#0.00") %></td>

                    <td class="txtBlack8"  style="text-align: right;" >费用:</td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((profitPro?.Rows[0][2])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((profitPro?.Rows[0][2])??0).ToString("#0.00") %></td>

                    <td class="txtBlack8"  style="text-align: right;"  colspan="2"></td>
                </tr>
                <tr height="20">

                    <td colspan="3"  style="text-align: right;" ></td>

                    <td class="txtBlack8" colspan="2"  style="text-align: right;" >里程碑: </td>
                    <td class="txtBlack8" style="text-align: left;<%=Convert.ToDecimal((revPro?.Rows[0][4])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((revPro?.Rows[0][4])??0).ToString("#0.00") %></td>
                    <td id="" colspan="2"></td>
                    <td id="" colspan="2"></td>
                </tr>
                <tr>

                    <td class="totalRowText" colspan="2"  style="text-align: right;" >总支出 :</td>
                    <td class="totalRowText" style="text-align: left;<%=Convert.ToDecimal((expPro?.Rows[0][4])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((expPro?.Rows[0][4])??0).ToString("#0.00") %></td>

                    <td class="totalRowText" colspan="2"  style="text-align: right;" >总收入:</td>
                    <td class="totalRowText" style="text-align: left;<%=Convert.ToDecimal((revPro?.Rows[0][5])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((revPro?.Rows[0][5])??0).ToString("#0.00") %></td>

                    <td class="totalRowText"  style="text-align: right;" >总利润:</td>
                    <td class="totalRowText" style="text-align: left;<%=Convert.ToDecimal((profitPro?.Rows[0][4])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((profitPro?.Rows[0][4])??0).ToString("#0.00") %></td>

                    <td class="totalRowText"  style="text-align: right;" >汇总:</td>
                    <td class="totalRowText" style="text-align: left;<%=Convert.ToDecimal((yuguPro?.Rows[0][2])??0)<0?"color:red;": "" %>"><%=Convert.ToDecimal((yuguPro?.Rows[0][2])??0).ToString("#0.00") %></td>
                </tr>
            </tbody>
        </table>

        <!-- task details -->
        <table class="subTitleText Space" cellspacing="0" cellpadding="3" border="0" style="margin-left: 10px; width: 98%;">
            <tbody>
                <tr valign="bottom">
                    <td style="text-align: left;">任务				
                    </td>
                </tr>
            </tbody>
        </table>
        <table border="0" cellspacing="0" cellpadding="3" id="tblReport" style="border-collapse: collapse; margin-left: 10px; width: 98%;">
            <tbody>
                <tr>
                    <td class="headerRowText" colspan="4">标题</td>
                    <td class="headerRowText">状态</td>
                    <td class="headerRowText" style="text-align: right;">预估时间</td>
                    <td class="headerRowText" style="text-align: right;">已工作时间</td>
                    <td class="headerRowText" style="text-align: right;">已计费时间</td>
                    <td class="headerRowText" style="text-align: right;">工时收入</td>
                    <td class="headerRowText" style="text-align: right;">工时成本</td>

                </tr>
                <!-- report output below -->
                <% if (taskTable != null && taskTable.Rows.Count > 0)
                    {
                        foreach (System.Data.DataRow thisRow in taskTable.Rows)
                        {
                            if (thisRow == taskTable.Rows[0])
                            {
                                continue;
                            }
                            %><tr style="text-align: right;height:20px;">
                            <td class="txtBlack8" colspan="4" style="text-indent: 60px;text-align: left;"><%=thisRow[0] %></td>
                            <td class="txtBlack8" style="text-align: left;"><%=thisRow[1] %></td>
                            <td class="txtBlack8" style="text-align: right;"><%=thisRow[2] %></td>
                            <td class="txtBlack8" style="text-align: right;"><%=thisRow[3] %></td>
                            <td class="txtBlack8" style="text-align: right;"><%=thisRow[4] %></td>
                            <td class="txtBlack8" style="text-align: right;"><%=thisRow[5] %></td>
                            <td class="txtBlack8" style="text-align: right;"><%=thisRow[6] %></td>
                        </tr>

                <%}%>
                <tr style="text-align: right;height:20px;">
                            <td class="txtBlack8" colspan="4" style="text-indent: 60px;text-align: left;"><%=taskTable.Rows[0][0] %></td>
                            <td class="txtBlack8" style="text-align: left;"><%=taskTable.Rows[0][1] %></td>
                            <td class="txtBlack8" style="text-align: right;"><%=taskTable.Rows[0][2] %></td>
                            <td class="txtBlack8" style="text-align: right;"><%=taskTable.Rows[0][3] %></td>
                            <td class="txtBlack8" style="text-align: right;"><%=taskTable.Rows[0][4] %></td>
                            <td class="txtBlack8" style="text-align: right;"><%=taskTable.Rows[0][5] %></td>
                            <td class="txtBlack8" style="text-align: right;"><%=taskTable.Rows[0][6] %></td>
                        </tr>
                   <% } %>

               

            </tbody>
        </table>
        <table class="subTitleText Space" cellspacing="0" cellpadding="3" border="0" style="margin-left: 10px; width: 98%;">
            <tbody>
                <tr valign="bottom">
                    <td style="text-align:left;">项目成本</td>
                </tr>
            </tbody>
        </table>
        <table border="0" cellspacing="0" cellpadding="3" id="tblReport" style="border-collapse: collapse; margin-left: 10px; width: 98%;">
            <tbody>
                <tr>
                    <%--<td class="headerRowText" width="1%"></td>--%>
                    <td class="headerRowText" style="text-align: center;">日期</td>
                    <td class="headerRowText" style="text-align: left;">成本名称</td>
                    <td class="headerRowText" style="text-align: left;">类别</td>
                    <td class="headerRowText" style="text-align: left;">采购订单号</td>
                    <td class="headerRowText" style="text-align: left;">发票编号</td>
                    <%--<td class="headerRowText" style="text-align: right;"> </td>--%>
                    <td class="headerRowText" style="text-align: right;">成本 </td>
                    <td class="headerRowText" style="text-align: right;">计费总额</td>
                    <td class="headerRowText" style="text-align: right;">收入</td>

                </tr>
                <% if (chargeTable != null && chargeTable.Rows.Count > 0)
                                                                             {
                                                                                 foreach (System.Data.DataRow thisRow in chargeTable.Rows)
                                                                                 {%>
                 <tr>
                    <%--<td class="txtBlack8" align="center"></td>--%>
                    <td class="txtBlack8" style="text-align: center;"><%=thisRow[0] %></td>
                    <td class="txtBlack8" style="text-align: left;"><%=thisRow[1] %></td>
                    <td class="txtBlack8" style="text-align: left;"><%=thisRow[2] %></td>
                    <td class="txtBlack8" style="text-align: left;"><%=thisRow[3] %></td>
                    <td class="txtBlack8" style="text-align: left;"><%=thisRow[4] %></td>
                    <%--<td class="txtBlack8" style="text-align: right;"></td>--%>
                    <td class="txtBlack8" style="text-align: right;"><%=thisRow[5] %></td>
                    <td class="txtBlack8" style="text-align: right;"><%=thisRow[6] %></td>
                    <td class="txtBlack8" style="text-align: right;"><%=thisRow[7] %></td>
                </tr>
                       <% }
                           }
                           else {%>
                  <tr>
                    <td colspan="8" style="color:red;text-align:center;">暂无相关数据</td>
                </tr>
                 <%          } %>
            </tbody>
        </table>
        <table class="subTitleText Space" cellspacing="0" cellpadding="3" border="0" style="margin-left: 10px; width: 98%;">
            <tbody>
                <tr valign="bottom">
                    <td style="text-align:left;">项目费用</td>
                </tr>
            </tbody>
        </table>
        <table border="0" cellspacing="0" cellpadding="3" id="tblReport" style="border-collapse: collapse; margin-left: 10px; width: 98%;">
            <tbody>
                <tr>
                    <%--<td class="headerRowText" width="1%"></td>--%>
                    <td class="headerRowText" style="text-align: center;">日期</td>
                    <td class="headerRowText" style="text-align: left;">员工</td>
                    <td class="headerRowText" style="text-align: left;">类型</td>
                    <td class="headerRowText" style="text-align: left;">描述或供应商</td>
                    <td class="headerRowText" style="text-align: right;">总额</td>
                    <td class="headerRowText" style="text-align: center;">收据</td>
                    <td class="headerRowText" style="text-align: center;">收费的 </td>
                    <td class="headerRowText" style="text-align: right;">收入</td>
                    
                </tr>
                     <% if (expenseTable != null && expenseTable.Rows.Count > 0)
                                                                                    {
                                                                                        foreach (System.Data.DataRow thisRow in expenseTable.Rows)
                                                                                        {%>
                 <tr class="ReportContentRow">
                    <%--<td class="txtBlack8" style="text-align: center;"></td>--%>
                    <td class="txtBlack8" style="text-align: center;"><%=thisRow[0] %></td>
                    <td class="txtBlack8" style="text-align: left;"><%=thisRow[1] %></td>
                    <td class="txtBlack8" style="text-align: left;"><%=thisRow[2] %></td>
                    <td class="txtBlack8" style="text-align: left;"><%=thisRow[3] %></td>
                    <td class="txtBlack8" style="text-align: right;"><%=thisRow[6] %></td>
                    <td class="txtBlack8" style="text-align: center;"><%=thisRow[4] %></td>
                    <td class="txtBlack8" style="text-align: center;"><%=thisRow[5] %></td>
                    <td class="txtBlack8" style="text-align: right;"><%=thisRow[7] %></td>
                </tr>
                       <% }
                           }
                           else {%>
                <tr>
                    <td colspan="8" style="color:red;text-align:center;">暂无相关数据</td>
                </tr>
                          <% } %>
            </tbody>
        </table>

        <% if (milepostTable != null && milepostTable.Rows.Count > 0) {
                %>
          <table class="subTitleText Space" cellspacing="0" cellpadding="3" border="0" style="margin-left: 10px; width: 98%;">
            <tbody>
                <tr valign="bottom">
                    <td style="text-align:left;">项目里程碑</td>
                </tr>
            </tbody>
        </table>
        <table border="0" cellspacing="0" cellpadding="3" id="tblReport" style="border-collapse: collapse; margin-left: 10px; width: 98%;">
            <tbody>
                <tr>
                    <td class="headerRowText" style="text-align: center;">里程碑名称</td>
                    <td class="headerRowText" style="text-align: center;">到期日</td>
                    <td class="headerRowText" style="text-align: right;">金额 </td>
                    <td class="headerRowText" style="text-align: right;">收入</td>
                    
                </tr>
                     <% foreach (System.Data.DataRow thisRow in milepostTable.Rows)  {%>
                 <tr class="ReportContentRow">
                    <td class="txtBlack8" style="text-align: center;"><%=thisRow[0] %></td>
                    <td class="txtBlack8" style="text-align: center;"><%=thisRow[1] %></td>
                    <td class="txtBlack8" style="text-align: right;"><%=thisRow[2] %></td>
                    <td class="txtBlack8" style="text-align: right;"><%=thisRow[3] %></td>
                </tr>
                       <% } %>
            </tbody>
        </table>
           <% } %>

    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#ClosePage").click(function () {
        $(".header").hide();
        $(".header-title").hide();
        window.print();
        $(".header").show();
        $(".header-title").show();

    })
</script>
