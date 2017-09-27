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
  <!--顶部-->
  <%--<div class="TitleBar">
    <div class="Title">
      <span class="text1"><%=summary.contract_type %></span>
    </div>
  </div>--%>
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
  <div class="DropDownMenu" id="D1">
    <ul>
      <li><span class="DropDownMenuItemText">工时</span></li>
      <li><span class="DropDownMenuItemText">产品</span></li>
      <li><span class="DropDownMenuItemText">服务</span></li>
      <li><span class="DropDownMenuItemText">成本</span></li>
    </ul>
  </div>
  <!--内容-->
  <div class="DivScrollingContainer General" style="top:34px;">
    <div class="PageLevelInstructions">
      <%if (contract.end_date < DateTime.Now)
          { %>
      <span class="errorSmallClass">重要: 合同已过期，如果想继续计费请修改合同结束日期。</span>
      <%} %>
    </div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tbody>
        <tr>
          <td>
            <div class="DivSectionWithHeader">
              <div class="Heading">
                <span class="Text">合同摘要</span>
              </div>
              <div class="Content" style="padding-right: 8px;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tbody>
                    <tr height="21">
                      <td class="FieldLabel" style="width: 192px;">客户名称
                      </td>
                      <td>
                        <a href="../Company/ViewCompany.aspx?id=<%=contract.account_id %>"><%=summary.account_name %></a>
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
                      <td>Manually</td>
                    </tr>
                    <tr height="21" style="display:none;">
                      <td class="FieldLabel">Company to bill
                      </td>
                      <td>
                        <a href="##">asadsadsadsa</a>
                      </td>
                    </tr>
                    <tr height="21" style="display:none;">
                      <td class="FieldLabel">Contract Notification Contact
                      </td>
                      <td></td>
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
                      <td><%=summary.start_date %></td>
                    </tr>
                    <tr height="21">
                      <td class="FieldLabel">结束日期
                      </td>
                      <td><%=summary.end_date %></td>
                    </tr>
                    <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) { %>
                    <tr height="21">
                      <td class="FieldLabel">合同周期类型
                      </td>
                      <td>Monthly</td>
                    </tr>
                    <%} else if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.FIXED_PRICE
                            || contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.TIME_MATERIALS
                            || contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS) { %>
                    <tr height="21">
                      <td class="FieldLabel">持续时间
                      </td>
                      <td><%=summary.duration %></td>
                    </tr>
                    <tr>
                      <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tbody>
                            <tr>
                              <td class="FieldLabels" width="135px">时间轴</td>
                              <td style="border: 1px solid black;">
                                <div class="load" style="width: 20%;"></div>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                      <td></td>
                      <td class="FieldLabels" style="padding: 5px 0;">
                        <span>天</span>
                      </td>
                    </tr>
                    <%} %>
                  </tbody>
                </table>
              </div>
            </div>
            <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) { %>
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
                            <tr>
                              <td width="340px"></td>
                              <td width="5px"></td>
                              <td class="FieldLabels" style="padding: 5px 0;">
                                <span>利润</span>
                              </td>
                            </tr>
                            <tr>
                              <td>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tbody>
                                    <tr>
                                      <td class="FieldLabels" width="135px">Current Period </td>
                                      <td style="border: 1px solid black;">
                                        <div class="load" style="width: 20%;"></div>
                                      </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                              <td></td>
                              <td class="FieldLabels" style="padding: 5px 0;">
                                <span>¥13,060.00</span>
                              </td>
                            </tr>
                            <tr>
                              <td>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tbody>
                                    <tr>
                                      <td class="FieldLabels" width="135px">PreviousPeriods</td>
                                      <td style="border: 1px solid black;">
                                        <div class="load" style="width: 0%;"></div>
                                      </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                              <td></td>
                              <td class="FieldLabels" style="padding: 5px 0;">
                                <span>¥0.00</span>
                              </td>
                            </tr>
                            <tr>
                              <td>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tbody>
                                    <tr>
                                      <td class="FieldLabels" width="135px">Previous 3 Periods</td>
                                      <td style="border: 1px solid black;">
                                        <div class="load" style="width: 0%;"></div>
                                      </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                              <td></td>
                              <td class="FieldLabels" style="padding: 5px 0;">
                                <span>¥0.00</span>
                              </td>
                            </tr>
                            <tr>
                              <td>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tbody>
                                    <tr>
                                      <td class="FieldLabels" width="135px">Contract to Date</td>
                                      <td style="border: 1px solid black;">
                                        <div class="load" style="width: 40%;"></div>
                                      </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </td>
                              <td></td>
                              <td class="FieldLabels" style="padding: 5px 0;">
                                <span>¥37,373.34  </span>
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
          <td width="330px" align="left" valign="top">
            <div class="DivSectionWithHeader DivSectionWithColor">
              <div class="Heading">
                <span class="Text">合同详情</span>
              </div>
              <div class="Content">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tbody>
                    <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.FIXED_PRICE
                            || contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.TIME_MATERIALS
                            || contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS) { %>
                    <tr height="24px">
                      <td class="FieldLabels">
                        <a href="##">费率</a>
                      </td>
                      <td><%=summary.rate %></td>
                    </tr>
                    <%} %>
                    <tr height="24px">
                      <td class="FieldLabels">
                        <a href="##">配置项</a>
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
                    <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.FIXED_PRICE) { %>
                    <tr height="24px">
                      <td class="FieldLabels">
                        <a href="##">里程碑</a>
                      </td>
                      <td><%=summary.milestone %></td>
                    </tr>
                    <%} %>
                    <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS) { %>
                    <tr height="24px">
                      <td class="FieldLabels">
                        <a href="##">激活的预付时间</a>
                      </td>
                      <td></td>
                    </tr>
                    <tr height="24px">
                      <td class="FieldLabels">
                        <a href="##">购买的预付时间总数</a>
                      </td>
                      <td></td>
                    </tr>
                    <tr height="24px">
                      <td class="FieldLabels">
                        <a href="##">剩余预付时间</a>
                      </td>
                      <td></td>
                    </tr>
                    <tr height="24px">
                      <td class="FieldLabels">
                        <a href="##">当前剩余预付时间</a>
                      </td>
                      <td></td>
                    </tr>
                    <tr height="24px">
                      <td class="FieldLabels">
                        <a href="##">待审批计费时间</a>
                      </td>
                      <td></td>
                    </tr>
                    <%} %>
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
                            || contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.TIME_MATERIALS) { %>
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
                    <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS) { %>
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
                      <td>
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
                    <%} %>
                    <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) { %>
                    <tr height="24px">
                      <td class="FieldLabel">初始费用
                      </td>
                      <td>2.00
                      </td>
                    </tr>
                    <tr height="24px">
                      <td class="FieldLabel">合同期
                      </td>
                      <td>12
                      </td>
                    </tr>
                    <tr height="24px">
                      <td class="FieldLabel">初次计费日期
                      </td>
                      <td>24/16/2016
                      </td>
                    </tr>
                    <tr height="24px">
                      <td class="FieldLabel">下一个计费日期
                      </td>
                      <td>N/A
                      </td>
                    </tr>
                    <tr height="24px">
                      <td class="FieldLabel">最终计费日期
                      </td>
                      <td>01/16/2016
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
  </script>
</body>
</html>
