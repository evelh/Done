<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportView.aspx.cs" Inherits="EMT.DoneNOW.Web.TimeSheet.ReportView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>我的费用报表</title>
    <style>
         body {
            font-size: 12px;
            overflow: auto;
            background: white;
            left: 0;
            top: 0;
            position: relative;
            margin: 0;
        }

        .HeaderRow {
            background-color: #346a95;
            z-index: 100;
            height: 36px;
            padding-left: 10px;
            margin-bottom: 10px;
        }

            .HeaderRow table {
                width: 100%;
                border-collapse: collapse;
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

        .ButtonBar {
            font-size: 12px;
            padding: 0 10px 10px 10px;
            width: auto;
            background-color: #FFF;
        }

            .ButtonBar ul {
                list-style-type: none;
                padding: 0;
                margin: 0;
                height: 26px;
                width: 100%;
            }

                .ButtonBar ul li {
                    display: block;
                    float: left;
                }

                    .ButtonBar ul li a, .ButtonBar ul li a:visited, .contentButton a, .contentButton a:link, .contentButton a:visited, a.buttons, input.button, .ButtonBar ul li a:visited {
                        background: #d7d7d7;
                        background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
                        border: 1px solid #bcbcbc;
                        display: inline-block;
                        color: #4F4F4F;
                        cursor: pointer;
                        padding: 0 5px 0 3px;
                        position: relative;
                        text-decoration: none;
                        vertical-align: middle;
                        height: 24px;
                    }
                    TABLE#tblOutlineBox {
    background-color: #fff;
    padding: 5px;
    color: menutext;
    border-width: 1px;
    border-style: solid;
    border-color: #BBB #BBBBBB #BBB #BBBBBB;
    font-size: 8pt;
    font-weight: bold;
    margin-top: 0;
    margin-bottom: 0;
}
#titleText {
    color: #000;
    FONT-SIZE: 14px;
    font-weight: bold;
}
.titleTd {
    padding-bottom: 3px;
}
#subTitleText, .subTitleText {
    color: #000;
    FONT-SIZE: 12px;
    font-weight: bold;
}
TABLE#tblReport {
    background-color: #fff;
    padding: 5px;
}
TABLE#tblReport>tbody>tr>td, TABLE#tblReport>thead>tr>td, .tblReport>tbody>tr>td {
    border-width: 1px;
    border-style: solid;
    border-color: #BBB;
}
#txtTableHeadNew, #headerRowText {
    color: #000;
    FONT-SIZE: 11px;
    font-weight: bold;
    background: #E6E6E6;
    background: -moz-linear-gradient(top,#E6E6E6 0,#D6D6D6 100%);
    background: -webkit-linear-gradient(top,#E6E6E6 0,#D6D6D6 100%);
    background: -ms-linear-gradient(top,#E6E6E6 0,#D6D6D6 100%);
    background: linear-gradient(to bottom,#E6E6E6 0,#D6D6D6 100%);
    vertical-align: top;
}
#totalRowText {
    color: #444;
    FONT-SIZE: 11px;
    font-weight: bold;
}
#txtBlack8, .txtBlack8 {
    color: #444;
    FONT-SIZE: 11px;
    font-weight: normal;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="HeaderRow">
            <table>
                <tbody>
                    <tr>
                        <td><span>费用报表-报告</span></td>
                        <td align="right" class="helpLink"><a class="HelperLinkIcon" title=""></a></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="ButtonBar">
            <ul>
                <li onclick="PrintPage()"><a class="ImgLink">
                    <span class="icon" style="background-image: url(../Images/print.png); width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                </a></li>
                <li style="margin-left:10px;">
                    <select id="chooseDate" style="height:26px;">
                        <% if (dateList.Count > 0)
                            {
                                foreach (var tdate in dateList)
                                {%>
                        <option value="<%=tdate.val %>" <%=tdate.select==1?"selected='selected'":"" %>><%=tdate.show %></option>
                        <%}
                            } %>
                    </select>
                </li>
            </ul>
        </div>
        <% if (expList != null && expList.Count > 0 && payTypeList != null && payTypeList.Count > 0)
            { %>
        <div style="margin-left: 10px; margin-right: 10px">
            <!-- 报表相关数据 -->
            <table width="100%" border="0" cellspacing="0" cellpadding="3" id="tblOutlineBox">
                <tbody>
                    <tr>
                        <td id="titleText" class="titleTd" valign="top" align="left">费用报表名称:&nbsp;<span style="font-weight: normal"><%=thisReport.title %></span>
                        </td>
                        <td id="subTitleText" valign="top" nowrap="">&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td id="subTitleText" width="60%" valign="top" align="left">所属员工: <span style="font-weight: normal"><%=creRes == null ? "" : creRes.name %></span>
                        </td>
                        <td align="right" id="subTitleText" width="40%" valign="top">周期结束时间:&nbsp;<span style="font-weight: normal"><%=thisReport.end_date != null ? ((DateTime)thisReport.end_date).ToString("yyyy-MM-dd") : "" %></span>
                        </td>
                    </tr>
                    <tr>
                        <td id="subTitleText" valign="top" align="left">费用总额:&nbsp;<span style="font-weight: normal"><%=(thisReport.cash_advance_amount ?? 0).ToString("#0.00") %></span>
                        </td>
                        <td align="right" id="subTitleText" valign="top">费用报表 ID:&nbsp;<span style="font-weight: normal"><%=thisReport.oid %></span>
                        </td>
                    </tr>
                </tbody>
            </table>
            <%if (chooseStartDate != null)
                { %>
            <!-- 费用相关数据 -->
            <table width="100%" id="tblReport" cellspacing="0" cellpadding="3" border="0" style="border-collapse: collapse; margin: 10px 0px;">
                <tbody>
                    <tr height="21">
                        <td id="headerRowText" width="25%" style="padding-left: 10px;">&nbsp;</td>
                        <%for (int i = 0; i < 7; i++)
                            {%>
                        <td id="headerRowText" width="10%" align="center"><%=((DateTime)chooseStartDate).AddDays(i).ToString("yyyy-MM-dd") %></td>
                        <%} %>
                        <td id="headerRowText" width="15%" align="right">&nbsp;汇总</td>
                    </tr>

                    <%
                        foreach (var thisPayType in payTypeList)
                        {%>
                    <tr height="21">
                        <% decimal thisPayMoney = 0; %>
                        <td id="txtBlack8"  style="padding-left: 10px;"><%=thisPayType.name %></td>
                        <%for (int i = 0; i < 7; i++)
                            {
                                var thisDay = ((DateTime)chooseStartDate).AddDays(i);
                                var thisDayExpList = expList.Where(_ => _.add_date == thisDay && _.payment_type_id == thisPayType.id).ToList();
                                decimal sumAmount = thisDayExpList != null && thisDayExpList.Count > 0 ? thisDayExpList.Sum(_ => _.amount) : 0;
                                thisPayMoney += sumAmount;
                        %>
                        <td id="txtBlack8"  align="right" style="padding-right: 5px;"><%=sumAmount.ToString("#0.00") %></td>
                        <%} %>
                        <td id="txtBlack8"  align="right" style="padding-right: 5px;"><%=thisPayMoney.ToString("#0.00") %></td>
                    </tr>

                    <% }

                    %>


                    <tr height="21">
                        <td id="totalRowText" align="right" style="padding-right: 5px;">每天的汇总：</td>
                        <% decimal totalMoney = 0;
                            for (int i = 0; i < 7; i++)
                            {
                                var thisDay = ((DateTime)chooseStartDate).AddDays(i);
                                var thisDayList = expList.Where(_ => _.add_date == thisDay).ToList();
                                var thisDayTotal = thisDayList != null && thisDayList.Count > 0 ? thisDayList.Sum(_ => _.amount) : 0;
                                totalMoney += thisDayTotal;
                        %>
                        <td id="totalRowText" align="right" style="padding-right: 5px;"><%=thisDayTotal.ToString("#0.00") %></td>
                        <%} %>
                        <td id="totalRowText" align="right" style="padding-right: 5px;"><%=totalMoney.ToString("#0.00") %></td>
                    </tr>
                </tbody>
            </table>


            <div>费用详情</div>
            <table width="100%" id="tblReport" cellspacing="0" cellpadding="3" border="0" style="border-collapse: collapse; margin: 0px 0px 10px 0px;">
                <tbody>
                    <tr height="20">
                        <td id="headerRowText" width="15%" align="center">日期</td>
                        <td id="headerRowText" width="50%" style="padding-left: 10px;">说明或上级</td>
                        <td id="headerRowText" width="15%" align="center">是否有收据</td>
                        <td id="headerRowText" width="20%" align="right">金额</td>
                    </tr>
                    <% 
                        if (noEntertainList != null && noEntertainList.Count > 0)
                        {


                        foreach (var thisExp in noEntertainList)
                        {%>
                    <tr height="21">
                        <td id="txtBlack8" align="center"><%=thisExp.add_date.ToString("yyyy-MM-dd") %></td>
                        <td id="txtBlack8" style="padding-left: 10px;"><%=thisExp.description %></td>

                        <td id="txtBlack8" align="center"><%=thisExp.has_receipt==1?"✓":"" %></td>

                        <td id="txtBlack8" align="right" style="padding-right: 5px;"><%=thisExp.amount.ToString("#0.00") %></td>
                    </tr>
                    <%}
                        } %>
                </tbody>
            </table>

            <div>招待费用详情</div>
            <table width="100%" id="tblReport" cellspacing="0" cellpadding="3" border="0" style="border-collapse: collapse; margin: 0px 0px 10px 0px;">
                <tbody>
                    <tr height="20">
                        <td id="headerRowText" width="15%" align="center">日期</td>
                        <td id="headerRowText" width="50%" style="padding-left: 10px;">说明（目的、参与人等）</td>
                        <td id="headerRowText" width="15%" align="center">是否有收据</td>
                        <td id="headerRowText" width="20%" align="right">金额</td>
                    </tr>
                    <% 
                        if (entertainList != null && entertainList.Count > 0)
                        {
                        foreach (var thisExp in expList)
                        {%>
                    <tr height="21">
                        <td id="txtBlack8" align="center"><%=thisExp.add_date.ToString("yyyy-MM-dd") %></td>
                        <td id="txtBlack8" style="padding-left: 10px;"><%=thisExp.description %></td>

                        <td id="txtBlack8" align="center"><%=thisExp.has_receipt==1?"✓":"" %></td>

                        <td id="txtBlack8" align="right" style="padding-right: 5px;"><%=thisExp.amount.ToString("#0.00") %></td>
                    </tr>
                    <%}
                        }%>
                </tbody>
            </table>


            <div>
                <br />
                <br />
                <br />
                <br />
                <br />
                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                    <tbody>
                        <tr>
                            <td id="txtBlack8" width="11%" align="left" nowrap="">员工签字:</td>
                            <td id="txtBlack8" width="40%"><span>________________________________________________</span></td>
                            <td id="txtBlack8" width="10%" align="right">日期:</td>
                            <td id="txtBlack8" width="18%"><span>______________________</span></td>
                            <td id="txtBlack8" width="21%"></td>
                        </tr>

                        <tr>
                            <td></td>
                            <td id="txtBlack8" colspan="4" style="padding-left: 5px;"><%=subRes==null?"":subRes.name+"提交于"+(thisReport.submit_time!=null?(EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisReport.submit_time)).ToString("yyyy-MM-dd"):"") %></td>
                        </tr>

                    </tbody>
                </table>
                <br />
                <br />
                <br />
                <br />
                <br />
                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                    <tbody>
                        <tr>
                            <td id="txtBlack8" width="11%" align="left" nowrap="">审批人签字:</td>
                            <td id="txtBlack8" width="40%"><span>________________________________________________</span></td>
                            <td id="txtBlack8" width="10%" align="right">日期:</td>
                            <td id="txtBlack8" width="18%"><span>______________________</span></td>
                            <td id="txtBlack8" width="21%"></td>
                        </tr>

                        <tr>
                            <td></td>
                            <td id="txtBlack8" colspan="4" style="padding-left: 5px;">通过<%=LoginUser.name %>审批</td>
                        </tr>

                    </tbody>
                </table>
                <br />
                <br />
            </div>

            <%} %>
        </div>
        <%}
            else
            { %>
        <div style="text-align: center; width: 100%; color: red;">未查询到相关数据</div>
        <%} %>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    $("#chooseDate").change(function () {
        var thisDate = $(this).val();

        location.href = "ReportView?id=<%=thisReport.id %>&startDate=" + thisDate;

    })

    function PrintPage() {
        $(".HeaderRow").hide();
        $(".ButtonBar").hide();
        window.print();
        $(".HeaderRow").show();
        $(".ButtonBar").show();
    }
</script>
