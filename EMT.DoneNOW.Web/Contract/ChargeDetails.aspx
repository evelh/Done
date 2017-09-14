<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChargeDetails.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ChargeDetails" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>成本详情</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/Roles.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
        <div class="Title">
            <span class="text1">成本详情</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <span class="Icon Cancel"></span>
                <span class="Text">取消</span>
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                        成本名称
                        <div>
                            <%=conCost.name %>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        描述
                        <div>
                            <%=conCost.description %>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="50%" class="FieldLabels">
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td style="width:150px;">
                                        购买日期
                                        <div>
                                           <%=conCost.date_purchased.ToString("yyyy-MM-dd") %>
                                        </div>
                                    </td>
                                    <td>
                                        物料代码
                                        <div>
                                              <%
                                                      EMT.DoneNOW.Core.d_cost_code costCode  = new EMT.DoneNOW.DAL.d_cost_code_dal().FindNoDeleteById(conCost.cost_code_id);
                                                      %>
                                            <%=costCode!=null?costCode.name:"" %>
                                           
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="50%" class="FieldLabels">
                        <table border="0">
                            <tbody>
                            <tr>
                                <td style="width:150px;">
                                    数量
                                    <div>
                                        <%=conCost.quantity %>
                                    </div>
                                </td>
                                <td>
                                    总成本
                                    <div>
                                        <%=conCost.quantity!=null&&conCost.unit_cost!=null?((decimal)(conCost.quantity*conCost.unit_cost)).ToString("#0.00"):"" %>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="50%" class="FieldLabels">
                        <table border="0">
                            <tbody>
                            <tr>
                                <td style="width:150px;">
                                    计费总额
                                    <div>
                                        <%=conCost.quantity!=null&&conCost.unit_price!=null?((decimal)(conCost.quantity*conCost.unit_price)).ToString("#0.00"):"" %>
                                    </div>
                                </td>
                                <td>
                                    计费的
                                    <div>
                                        <%=conCost.is_billable==1?"计费":"不计费" %>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                     <tr>
                    <td width="50%" class="FieldLabels">
                        <table border="0">
                            <tbody>
                            <tr>
                                <td style="width:150px;">
                                    服务/包
                                    <div>
                                        <%if (conCost.service_id != null)
                                            { %>
                                        <%=new EMT.DoneNOW.BLL.OpportunityBLL().ReturnServiceName((long)conCost.service_id) %>
                                        <%} %>
                                    </div>
                                </td>
                                <td>
                                    成本类型 
                                    <div>
                                        <% if (conCost.cost_type_id != null) { 
                                            var dic = new EMT.DoneNOW.BLL.GeneralBLL().GetDicValues(EMT.DoneNOW.DTO.GeneralTableEnum.CHARGE_TYPE);
                                            if (dic != null && dic.Count > 0) {%>
                                                <%=dic.FirstOrDefault(_=>_.val == conCost.cost_type_id.ToString()).show %>
                                            <%}}
                                            %>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="50%" class="FieldLabels">
                        <table border="0">
                            <tbody>
                            <tr>
                                <td style="width:150px;">
                                    采购订单号
                                    <div>
                                        <%=conCost.date_purchased.ToString("yyyy-MM-dd") %>
                                    </div>
                                </td>
                                <td>
                                    内部订单号码 
                                    <div>
                                        <%=conCost.internal_po_no %>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="50%" class="FieldLabels">
                        <table border="0">
                            <tbody>
                            <tr>
                                <td style="width:150px;">
                                    内部发票号码
                                    <div>
                                        <%=conCost.invoice_no %>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    $("#CancelButton").click(function () {
        window.close();
    });
</script>