<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditRetainerPurchase.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.EditRetainerPurchase" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link href="../Content/reset.css" rel="stylesheet" />
  <link rel="stylesheet" href="../Content/Roles.css" />
  <title>编辑预付<%=blocktypeName %></title>
</head>
<body>
  <form id="form1" runat="server">
    <div class="TitleBar">
      <div class="Title">
        <span class="text1">编辑费率</span>
      </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
      <ul>
        <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
          <span class="Icon SaveAndClone"></span>
          <span class="Text">
            <asp:Button ID="SaveClose" runat="server" Text="保存并关闭" OnClick="SaveClose_Click" />
          </span>
        </li>
        <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
          <span class="Icon Cancel"></span>
          <span class="Text">取消</span>
        </li>
      </ul>
    </div>
    <!--主体内容-->
    <div class="DivScrollingContainer General">
      <div style="font-size: 12px; color: #666; padding: 0 10px 12px 10px;">
        每个预付<%=blocktypeName %>购买将创建合同成本。此成本分别经过审批、提交和生成发票，从而对客户的购买进行计费。
      </div>
      <div class="DivSection">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <td class="FieldLabels">合同开始/结束日期
                <div>
                  <%=contract.start_date.ToShortDateString() %> - <%=contract.end_date.ToShortDateString() %>
                </div>
              </td>
            </tr>
            <tr style="overflow: hidden;">
              <td class="FieldLabels" style="vertical-align: top; float: left;">开始日期<span class="errorSmall">*</span>
                <div>
                  <input type="text" value="<%=block.start_date.ToString("yyyy-MM-dd") %>" onclick="WdatePicker()" name="startDate" class="Wdate" style="width: 100px;" />
                </div>
              </td>
            </tr>
            <tr style="overflow: hidden;">
              <td class="FieldLabels" style="vertical-align: top; float: left;">结束日期<span class="errorSmall">*</span>
                <div>
                  <input type="text" value="<%=block.end_date.ToString("yyyy-MM-dd") %>" onclick="WdatePicker()" name="endDate" class="Wdate" style="width: 100px;" />
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="DivSection">
        <table width="80%" border="0" cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <td class="FieldLabels">
                <div>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="max-width: 404px;">
                    <tbody>
                      <tr>
                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS)
                            { %>
                        <td class="FieldLabels" colspan="2" nowrap>小时
                          <span class="FieldLevelInstructions">（每个预付<%=blocktypeName %>）</span>
                          <span class="errorSmall">*</span>
                        </td>
                        <td class="FieldLabels" colspan="2" nowrap>小时费率
                          <span class="errorSmall">*</span>
                        </td>
                        <td class="FieldLabels" nowrap>价格
                          <span class="FieldLevelInstructions">（每个预付<%=blocktypeName %>）</span>
                        </td>
                        <%} %>
                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER)
                            { %>
                        <td class="FieldLabels" colspan="2" nowrap>总额
                          <span class="FieldLevelInstructions">（每个预付<%=blocktypeName %>）</span>
                          <span class="errorSmall">*</span>
                        </td>
                        <%} %>
                      </tr>
                      <tr>
                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS)
                            { %>
                        <td class="FieldLabels">
                          <div style="padding-bottom: 0;">
                            <input type="text" name="hours" value="<%=block.quantity %>" style="width: 90px; text-align: right;" id="Text3" />
                          </div>
                        </td>
                        <td class="FieldLabels">
                          <div style="width: 20px; font-size: 16px; padding-bottom: 0;">x</div>
                        </td>
                        <td class="FieldLabels">
                          <div style="padding-bottom: 0;">
                            <input type="text" name="hourlyRate" value="<%=block.rate %>" style="width: 70px; text-align: right;" id="Text4" />
                          </div>
                        </td>
                        <td class="FieldLabels">
                          <div style="width: 20px; font-size: 16px; padding-bottom: 0;">=</div>
                        </td>
                        <td class="FieldLabels">
                          <div style="padding-bottom: 0;">
                            <input type="text" style="width: 80px; text-align: right;" value="<%=(block.quantity*block.rate) %>" disabled="disabled" id="Text5" />
                          </div>
                        </td>
                        <%} %>
                        <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER)
                            { %>
                        <td class="FieldLabels">
                          <div style="padding-bottom: 0;">
                            <input type="text" name="amount" value="<%=block.rate %>" style="width: 90px; text-align: right;" id="Text3" />
                          </div>
                        </td>
                        <%} %>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </td>
            </tr>
            <tr>
              <td class="FieldLabels">
                <div>
                  <input type="checkbox" disabled="disabled" />
                  已收费的
                </div>
              </td>
            </tr>
            <tr>
              <td class="FieldLabels">状态
                <div style="padding-bottom: 6px; padding-left: 10px;">
                  <input type="radio" style="vertical-align: middle;" value="1" <%if (block.status_id == 1) { %> checked="checked"<%} %> name="rdStatus" />
                  激活
                </div>
                <div style="padding-left: 10px;">
                  <input type="radio" style="vertical-align: middle;" value="0" <%if (block.status_id == 0) { %> checked="checked"<%} %> name="rdStatus" />
                  不激活
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="DivSection">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <td class="FieldLabels">购买日期<span class="errorSmall">*</span>
                <div>
                  <input type="text" value="<%=block.date_purchased.ToString("yyyy-MM-dd") %>" name="datePurchased" onclick="WdatePicker()" class="Wdate" id="DateField" />
                  <span id="SpanId" style="display: none;">使用预付时间开始时间</span>
                </div>
              </td>
            </tr>
            <tr>
              <td class="FieldLabels">付款总数
                <div>
                  <input type="text" value="<%=block.payment_number %>" name="paymentNum" />
                </div>
              </td>
            </tr>
            <tr>
              <td class="FieldLabels">付款类型
                <div>
                  <asp:DropDownList ID="paymentType" runat="server"></asp:DropDownList>
                </div>
              </td>
            </tr>
            <tr>
              <td class="FieldLabels">备注
                <div>
                  <input type="text" name="note" value="<%=block.description %>" style="width: 400px;" />
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <input type="hidden" name="id" value="<%=block.id %>" />
      </div>
    </div>
    <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
    <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
      <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS) { %>
      $("#Text3").change(function () {
        var k1 = $("#Text3").val();
        var k2 = $("#Text4").val();
        if ((/^\d{1,15}\.?\d{0,4}$/.test(k1)) == false) {
          alert('只能输入四位小数');
          $("#Text3").val('').focus();
          return false;
        }
        var f = Math.round(k1 * 10000) / 10000;
        var s = f.toString();
        var rs = s.indexOf('.');
        if (rs < 0) {
          rs = s.length;
          s += '.';
        }
        while (s.length <= rs + 4) {
          s += '0';
        }
        $("#Text3").val(s);
        $("#Text5").val(k2 * k1);
      });
      $("#Text4").change(function () {
        var k1 = $("#Text3").val();
        var k2 = $("#Text4").val();
        if ((/^\d{1,15}\.?\d{0,2}$/.test(k2)) == false) {
          alert('只能输入两位小数');
          $("#Text4").val('').focus();
          return false;
        }
        var f = parseFloat(k2);
        if (isNaN(f)) {
          return false;
        }
        var f = Math.round(k2 * 100) / 100;
        var s = f.toString();
        var rs = s.indexOf('.');
        if (rs < 0) {
          rs = s.length;
          s += '.';
        }
        while (s.length <= rs + 2) {
          s += '0';
        }
        $("#Text4").val(s);
        $("#Text5").val(k2 * k1);
      });
      <%} %>
      <%if (contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER) { %>
        $("#Text3").change(function () {
          var k1 = $("#Text3").val();
          if ((/^\d{1,15}\.?\d{0,2}$/.test(k1)) == false) {
            alert('只能输入两位小数');
            $("#Text3").val('').focus();
            return false;
          }
          var f = Math.round(k1 * 100) / 100;
          $("#Text3").val(f);
        });
      <%} %>
      $("#CancelButton").on("click", function () {
            window.close();
        });
    </script>
  </form>
</body>
</html>
