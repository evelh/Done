<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractSummary.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractSummary" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" href="../Content/reset.css">
    <link rel="stylesheet" href="../Content/NewWorkType.css">
</head>
<body>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul>
            <li class="Button ButtonIcon NormalState f1" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon" style="width: 0; margin: 0;"></span>
                <span class="Text">选项</span>
                <img src="../Images/dropdown.png" alt="" class="ButtonRightImg1">
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveButton" tabindex="0">
                <span class="Icon" style="width: 0; margin: 0;"></span>
                <span class="Text">标记</span>
            </li>
        </ul>
    </div>
    <!--下拉菜单-->
    <div class="DropDownMenu" id="D1" style="top:25px;">
        <ul>
            <li><span class="DropDownMenuItemText" onclick="CopyContract(<%=contract.id %>)">编辑合同</span></li>
          <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) { %>
            <li><span class="DropDownMenuItemText" onclick="RenewContract(<%=contract.id %>)">续约</span></li>
          <%} %>
            <li><span class="DropDownMenuItemText" style="color: dimgrey">增加备注</span></li>
            <li><span class="DropDownMenuItemText" onclick="DeleteContract(<%=contract.id %>)">删除合同</span></li>
        </ul>
    </div>
    <!--内容-->
    <div class="DivScrollingContainer General" style="top: 34px;">
        <div class="PageLevelInstructions">
            <%if (contract.end_date < DateTime.Now)
                { %>
            <span class="errorSmallClass" style="color: red;">重要: 合同已过期，如果想继续计费请修改合同结束日期。</span>
            <%} %>
        </div>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td style="vertical-align:top;">
                        <div class="DivSectionWithHeader">
                            <div class="Heading">
                                <span class="Text">合同摘要</span>
                            </div>
                            <div class="Content" style="padding-right: 8px;">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tbody>
                                        <tr height="21">
                                            <td class="FieldLabel" style="min-width: 200px;width:200px;">客户名称
                                            </td>
                                            <td>
                                                <a style="cursor:pointer;" onclick="window.open('../Company/ViewCompany.aspx?id=<%=contract.account_id %>', '_blank', 'left=200,top=200,width=600,height=800', false);"><%=summary.account_name %></a>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">客户经理
                                            </td>
                                            <td>
                                                <%=summary.account_manager_name %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">联系人姓名
                                            </td>
                                            <td>
                                                <%=summary.contact_name %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">合同描述
                                            </td>
                                            <td>
                                                <%=summary.description %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">服务等级协议
                                            </td>
                                            <td>
                                                <%=summary.sla %>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">默认服务台合同
                                            </td>
                                            <td><%=summary.is_sdt_default %></td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">采购订单号
                                            </td>
                                            <td><%=summary.purchase_order_no %></td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">工时计费设置
                                            </td>
                                            <td><%=summary.bill_post_type %></td>
                                        </tr>
                                        <tr>
                                            <td height="21" colspan="2">
                                                <hr>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">合同类型
                                            </td>
                                            <td><%=summary.contract_type %></td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">合同种类
                                            </td>
                                            <td><%=summary.contract_cate %></td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">合同状态
                                            </td>
                                            <td><%=summary.contract_status %></td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">外部合同号
                                            </td>
                                            <td><%=summary.external_no %></td>
                                        </tr>
                                        <tr>
                                            <td height="21" colspan="2">
                                                <hr>
                                            </td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">开始日期
                                            </td>
                                            <td><%=summary.start_date.ToString("yyyy-MM-dd") %></td>
                                        </tr>
                                        <tr height="21">
                                            <td class="FieldLabel">结束日期
                                            </td>
                                            <td><%=summary.end_date.ToString("yyyy-MM-dd") %></td>
                                        </tr>
                                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE)
                                            { %>
                                        <tr height="21">
                                            <td class="FieldLabel">合同周期类型
                                            </td>
                                            <td><%=summary.period_type %></td>
                                        </tr>
                                        <%}
                                        else
                                        { %>
                                        <tr height="21">
                                            <td class="FieldLabel">持续时间
                                            </td>
                                            <td><%=summary.duration %></td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabel">时间轴</td>
                                            <td>
                                                <table border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td>
                                                            <table width="200" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <%
                                                                        int percent = ((int)summary.timeline * 100) / (int)summary.duration;
                                                                        %>
                                                                    <td style="border: 1px solid black;"><div class="load" style="width: <%=percent%>%;padding:0;"><%=summary.timeline %></div></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td>
                                                            <span>&nbsp;&nbsp;天</span>
                                                        </td>
                                                    </tr>
                                                </table>   
                                            </td>
                                        </tr>
                                        <%} %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE)
                            { %>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td width="60%">
                                        <div class="DivSectionWithHeader">
                                            <div class="Heading">
                                                <span class="Text">利润率 (收入 - 成本)</span>
                                            </div>
                                            <div class="Content">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tbody>
                                                        <%
                                                            string title1, title2, title3, title4;
                                                            decimal per1, per2, per3, per4;
                                                            decimal prof1, prof2, prof3, prof4;
                                                            title1 = $"合同成本=￥{summary.current_period2},合同收入=￥{summary.current_period1}";
                                                            title2 = $"合同成本=￥{summary.previous_period2},合同收入=￥{summary.previous_period1}";
                                                            title3 = $"合同成本=￥{summary.previous_3_periods2},合同收入=￥{summary.previous_3_periods1}";
                                                            title4 = $"合同成本=￥{summary.contract_to_date2},合同收入=￥{summary.contract_to_date1}";
                                                            prof1 = summary.current_period1 - summary.current_period2;
                                                            prof2 = summary.previous_period1 - summary.previous_period2;
                                                            prof3 = summary.previous_3_periods1 - summary.previous_3_periods2;
                                                            prof4 = summary.contract_to_date1 - summary.contract_to_date2;
                                                            if (summary.current_period2 == 0)
                                                                per1 = 0;
                                                            else
                                                                per1 = (decimal)((int)(summary.current_period2 / (summary.current_period1 + summary.current_period2) * 10000)) / 100;
                                                            if (summary.previous_period2 == 0)
                                                                per2 = 0;
                                                            else
                                                                per2 = (decimal)((int)(summary.previous_period2 / (summary.previous_period1 + summary.previous_period2) * 10000)) / 100;
                                                            if (summary.previous_3_periods2 == 0)
                                                                per3 = 0;
                                                            else
                                                                per3 = (decimal)((int)(summary.previous_3_periods2 / (summary.previous_3_periods1 + summary.previous_3_periods2) * 10000)) / 100;
                                                            if (summary.contract_to_date2 == 0)
                                                                per4 = 0;
                                                            else
                                                                per4 = (decimal)((int)(summary.contract_to_date2 / (summary.contract_to_date1 + summary.contract_to_date2) * 10000)) / 100;
                                                            %>
                                                        <tr>
                                                            <td width="340px"></td>
                                                            <td width="5px"></td>
                                                            <td class="FieldLabels" style="padding: 5px 0;">
                                                                <span>利润</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table title="<%=title1 %>" width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td class="FieldLabels" width="135px" style="min-width:135px;">当前周期</td>
                                                                            <td style="border: 1px solid black;width:204px;min-width:204px;">
                                                                                <div class="load" style="width: <%=per1%>%;position:relative;">
                                                                                    <span style="width:1px;height:18px;background-color:black;position:absolute;left:102px;"></span>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                            <td></td>
                                                            <td class="FieldLabels" style="padding: 5px 0;">
                                                                <span>¥<%=prof1%></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table title="<%=title2 %>" width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td class="FieldLabels" width="135px">先前周期</td>
                                                                            <td style="border: 1px solid black;">
                                                                                <div class="load" style="width: <%=per2%>%;position:relative;">
                                                                                    <span style="width:1px;height:18px;background-color:black;position:absolute;left:102px;"></span>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                            <td></td>
                                                            <td class="FieldLabels" style="padding: 5px 0;">
                                                                <span>¥<%=prof2%></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table title="<%=title3 %>" width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td class="FieldLabels" width="135px">前三周期</td>
                                                                            <td style="border: 1px solid black;">
                                                                                <div class="load" style="width: <%=per3%>%;position:relative;">
                                                                                    <span style="width:1px;height:18px;background-color:black;position:absolute;left:102px;"></span>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                            <td></td>
                                                            <td class="FieldLabels" style="padding: 5px 0;">
                                                                <span>¥<%=prof3%></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <table title="<%=title4 %>" width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td class="FieldLabels" width="135px">截至目前</td>
                                                                            <td style="border: 1px solid black;">
                                                                                <div class="load" style="width: <%=per4%>%;position:relative;">
                                                                                    <span style="width:1px;height:18px;background-color:black;position:absolute;left:102px;"></span>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                            <td></td>
                                                            <td class="FieldLabels" style="padding: 5px 0;">
                                                                <span>¥<%=prof4%></span>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <%}%>
                    </td>
                    <td width="330px" align="left" valign="top" style="min-width:330px;">
                        <div class="DivSectionWithHeader DivSectionWithColor">
                            <div class="Heading">
                                <span class="Text">合同详情</span>
                            </div>
                            <div class="Content">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tbody>
                                        <%if (contract.type_id != (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE
                                && contract.type_id != (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.PER_TICKET)
                                            { %>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a style="cursor:pointer;" onclick="javascript:window.parent.location.href='ContractView.aspx?type=roleRate&id=<%=contract.id %>'">费率</a>
                                            </td>
                                            <td><%=summary.rate %></td>
                                        </tr>
                                        <%} %>
                                        <%if (contract.type_id != (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.PER_TICKET)
                                            { %>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a style="cursor:pointer;" onclick="javascript:window.parent.location.href='ContractView.aspx?type=item&id=<%=contract.id %>'">配置项</a>
                                            </td>
                                            <td><%=summary.ci %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">项目</a>
                                            </td>
                                            <td><%=summary.project %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">工单</a>
                                            </td>
                                            <td><%=summary.ticket %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">备注</a>
                                            </td>
                                            <td><%=summary.note %></td>
                                        </tr>
                                        <%} %>
                                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.FIXED_PRICE)
                                            { %>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a style="cursor:pointer;" onclick="javascript:window.parent.location.href='ContractView.aspx?type=milestone&id=<%=contract.id %>'">里程碑</a>
                                            </td>
                                            <td><%=summary.milestone %></td>
                                        </tr>
                                        <%} %>
                                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS)
                                            { %>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">激活的预付时间</a>
                                            </td>
                                            <td><%=summary.active_blocks %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">购买的预付时间总数（包括未激活）</a>
                                            </td>
                                            <td><%=summary.total_block_hours %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">剩余预付时间（包括未激活）</a>
                                            </td>
                                            <td><%=summary.total_block_hours_remain %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">当前剩余预付时间（激活状态）</a>
                                            </td>
                                            <td><%=summary.total_block_hours_remain_active %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">待审批计费时间</a>
                                            </td>
                                            <td><%=summary.billable_Hours_need_Approve %></td>
                                        </tr>
                                        <tr height="15px"></tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同总额（不包括关联预付时间购买费用的合同总额）
                                            </td>
                                            <td>¥<%=summary.contract_charge_price_total %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同总成本（不包括关联预付时间购买费用的合同总成本）
                                            </td>
                                            <td>¥<%=summary.contract_charge_cost_total %>
                                            </td>
                                        </tr>
                                        <%} %>
                                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER)
                                            { %>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">激活的购买费用</a>
                                            </td>
                                            <td><%=summary.active_purchases %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">购买费用总额（包括未激活）</a>
                                            </td>
                                            <td><%=summary.total_amount_purchase %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">余额（包括未激活）</a>
                                            </td>
                                            <td><%=summary.total_amount_purchase_remain %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">当前余额（已激活）</a>
                                            </td>
                                            <td></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">待审批计费金额</a>
                                            </td>
                                            <td><%=summary.billable_amount_need_Approve %></td>
                                        </tr>
                                        <tr height="15px"></tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同总额（不包括预付费）
                                            </td>
                                            <td>¥<%=summary.contract_charge_price_total %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同总成本（不包括预付费）
                                            </td>
                                            <td>¥<%=summary.contract_charge_cost_total %>
                                            </td>
                                        </tr>
                                        <%} %>
                                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.PER_TICKET)
                                            { %>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">已购事件总数</a>
                                            </td>
                                            <td><%=summary.total_Tickets_Purchase %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">已用事件总数</a>
                                            </td>
                                            <td><%=summary.ticket_used %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">过期事件总数</a>
                                            </td>
                                            <td><%=summary.ticked_expired %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">剩余事件总数（包括已过期）</a>
                                            </td>
                                            <td><%=summary.ticket_remaining %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">当前事件总数（未过期）</a>
                                            </td>
                                            <td><%=summary.totla_current_tickets %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">当前已用事件数量（未过期）</a>
                                            </td>
                                            <td><%=summary.current_ticket_used %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">当前剩余事件数量（未过期）</a>
                                            </td>
                                            <td><%=summary.current_ticket_remaining %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabels">
                                                <a href="##">活动的服务工单</a>
                                            </td>
                                            <td><%=summary.open_Ticket %></td>
                                        </tr>
                                        <tr height="15px"></tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同总额（不包括购买事件的总额）
                                            </td>
                                            <td>¥<%=summary.contract_charge_price_total %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同总成本（不包括购买事件的成本）
                                            </td>
                                            <td>¥<%=summary.contract_charge_cost_total %>
                                            </td>
                                        </tr>
                                        <%} %>
                                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE
                                                || contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.TIME_MATERIALS
                                                || contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.FIXED_PRICE)
                                            { %>
                                        <tr height="15px"></tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同总额
                                            </td>
                                            <td>¥<%=summary.contract_charge_price_total %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同总成本
                                            </td>
                                            <td>¥<%=summary.contract_charge_cost_total %>
                                            </td>
                                        </tr>
                                        <%} %>
                                        <tr height="24px">
                                            <td class="FieldLabel">项目和工单总额
                                            </td>
                                            <td>¥<%=summary.pt_charge_price_total %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">项目和工单总成本
                                            </td>
                                            <td>¥<%=summary.pt_charge_cost_total %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">工时成本
                                            </td>
                                            <td>¥<%=summary.labor_cost %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">已工作时间
                                            </td>
                                            <td><%=summary.hours_worked %>
                                            </td>
                                        </tr>
                                        <tr height="15px"></tr>
                                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.FIXED_PRICE
                                                || contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.TIME_MATERIALS
                                                || contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER)
                                            { %>
                                        <tr height="24px">
                                            <td class="FieldLabel">工时已计费时间
                                            </td>
                                            <td><%=summary.labor_hours_billed %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">工时计费总额
                                            </td>
                                            <td><%=summary.labor_amount_billed %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同首付
                                            </td>
                                            <td><%=summary.initial_pay %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同付款总额
                                            </td>
                                            <td><%=summary.total_pay %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">预估收入
                                            </td>
                                            <td><%=summary.estimated_revenue %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">预估收入余额
                                            </td>
                                            <td><%=summary.estimated_revenue_balance %>
                                            </td>
                                        </tr>
                                        <%} %>
                                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS)
                                            { %>
                                        <tr height="24px">
                                            <td class="FieldLabel">工时已计费时间
                                            </td>
                                            <td><%=summary.labor_hours_billed %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">工时计费总额
                                            </td>
                                            <td><%=summary.labor_amount_billed %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">已用预付时间总额
                                            </td>
                                            <td><%=summary.block_hours_used_amount %></td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同首付
                                            </td>
                                            <td><%=summary.initial_pay %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同付款总额
                                            </td>
                                            <td><%=summary.total_pay %>
                                            </td>
                                        </tr>
                                        <%} %>
                                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE)
                                            { %>
                                        <tr height="24px">
                                            <td class="FieldLabel">初始费用
                                            </td>
                                            <td>
                                              <%=summary.setup_fee %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">合同期
                                            </td>
                                            <td>
                                              <%=summary.contract_periods %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">初次计费日期
                                            </td>
                                            <td>
                                              <%=summary.first_billed_date == null ? "" : (((DateTime)(summary.first_billed_date)).ToString("yyyy-MM-dd")) %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">下一个计费日期
                                            </td>
                                            <td>
                                              <%=summary.second_billing_date == null ? "" : (((DateTime)(summary.second_billing_date)).ToString("yyyy-MM-dd")) %>
                                            </td>
                                        </tr>
                                        <tr height="24px">
                                            <td class="FieldLabel">最终计费日期
                                            </td>
                                            <td>
                                              <%=summary.final_billing_Date == null ? "" : (((DateTime)(summary.final_billing_Date)).ToString("yyyy-MM-dd")) %>
                                            </td>
                                        </tr>
                                        <%} %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
    <script type="text/javascript" src="../Scripts/NewWorkType.js"></script>
    <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script>
        $(".f1").on("mouseover", function () {
            $(this).css("background", "white");
            $(this).css("border-bottom", "none");
            $("#D1").show();
        });
        $(".f1").on("mouseout", function () {
            $("#D1").hide();
            $(this).css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
            $(this).css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
            $(this).css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
            $(this).css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
            $(this).css("border-bottom", "1px solid #BCBCBC");
        });
        $("#D1").on("mouseover", function () {
            $(this).show();
            $(".f1").css("background", "white");
            $(".f1").css("border-bottom", "none");
        });
        $("#D1").on("mouseout", function () {
            $(this).hide();
            $(".f1").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
            $(".f1").css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
            $(".f1").css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
            $(".f1").css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
            $(".f1").css("border-bottom", "1px solid #BCBCBC");
        });
        $(".DropDownMenuItemText").on("mouseover", function () {
            $(this).parent().css("background", "#E9F0F8");
        });
        $(".DropDownMenuItemText").on("mouseout", function () {
            $(this).parent().css("background", "#FFF");
        });

        function CopyContract(id) {
          window.open("ContractEdit.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=980', false);
        }
        function RenewContract(id) {
          window.open("ContractRenew.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=980', false);
        }

        function DeleteContract(id) {
            if (confirm('删除合同，是否继续?')) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=deleteContract&id=" + id,
                    success: function (data) {
                        alert("删除成功");
                        window.close();
                        window.parent.close();
                    }
                });
            }
        }
    </script>
</body>
</html>
