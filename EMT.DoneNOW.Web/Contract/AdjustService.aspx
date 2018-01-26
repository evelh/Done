<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdjustService.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.AdjustService" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>调整<%=serviceTypeName %></title>
  <link rel="stylesheet" href="../Content/reset.css" />
  <link rel="stylesheet" href="../Content/Roles.css" />
</head>
<body>
  <form id="form1" runat="server">
    <div class="TitleBar">
      <div class="Title">
        <span class="text1">调整<%=serviceTypeName %></span>
      </div>
    </div>
    <div class="ButtonContainer">
      <ul>
        <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
          <span class="Icon SaveAndClone"></span>
          <span class="Text">保存 & 关闭</span>
        </li>
        <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
          <span class="Icon Cancel"></span>
          <span class="Text">取消</span>
        </li>
      </ul>
      <input type="hidden" id="units" value="<%=service.quantity %>" />
      <input type="hidden" id="price" value="<%=service.unit_price %>" />
      <input type="hidden" name="serId" value="<%=service.id %>" />
    </div>
    <div class="DivSection" style="width: 622px;">
      <table border="0">
        <tbody>
          <tr>
            <td>
              <span class="FieldLabels" style="font-weight: bold;"><%=serviceTypeName %>名称</span>
              <div>
                <span class="lblNormalClass" style="font-weight: normal;"><%=serviceName %></span>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <span class="FieldLabels" style="font-weight: bold;">日期<span class="errorSmall">*</span>
                <span style="font-weight: normal;">(输入一个<%=contract.start_date.ToString("yyyy-MM-dd")+" - "+contract.end_date.ToString("yyyy-MM-dd") %>之间的日期)</span>
              </span>
              <div>
                <input type="text" onclick="WdatePicker()" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" name="effective_date" class="Wdate" style="width: 90px;" />
                <label>注意：价格变动将对所有未提交的、开始日期在生效日期之后（包括生效日期）的服务周期生效</label>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div style="width: 100%; margin-bottom: 10px;">
      <div class="GridContainer" style="height: auto;">
        <div style="overflow: auto; z-index: 0; width: 680px;">
          <table class="dataGridBody" cellspacing="0" style="width: 100%; border-collapse: collapse;">
            <tbody>
              <tr class="dataGridHeader">
                <td style="width: 180px;"></td>
                <td align="right">当前（在生效日期内）
                </td>
                <td align="right" style="width: 220px;">已调整
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>单位（增加/减少）</span>
                </td>
                <td align="right">
                  <span style="vertical-align: middle;">-</span>
                </td>
                <td align="right">
                  <input type="text" id="num1" style="width: 180px; text-align: right;" value="0" />
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>单位数</span>
                </td>
                <td align="right">
                  <span style="vertical-align: middle;"><%=service.quantity %></span>
                </td>
                <td align="right">
                  <input type="text" name="serUnits" readonly="readonly" id="num2" style="width: 180px; text-align: right;" value="<%=service.quantity %>" />
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>单价</span>
                </td>
                <td align="right">
                  <span style="vertical-align: middle;">￥<%=service.unit_price %></span>
                </td>
                <td align="right">
                  <input type="text" id="num3" name="serPrice" style="width: 180px; text-align: right;" value="<%=service.unit_price %>" />
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>折扣（%）</span>
                </td>
                <td align="right">
                  <span style="vertical-align: middle;">-</span>
                </td>
                <td align="right">
                  <input type="text" id="num4" style="width: 180px; text-align: right;" value="0" />
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>总价</span>
                </td>
                <td align="right">
                  <span style="vertical-align: middle;">￥<%=service.quantity*service.unit_price %></span>
                </td>
                <td align="right">
                  <input type="text" id="num5" style="width: 180px; text-align: right;" value="<%=service.quantity*service.unit_price %>" />
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>单位成本</span>
                </td>
                <td align="right">
                  <span style="vertical-align: middle;">￥<%=service.unit_cost %></span>
                </td>
                <td align="right">
                  <input type="text" id="num6" name="serCost" style="width: 180px; text-align: right;" value="<%=service.unit_cost %>" />
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>总成本</span>
                </td>
                <td align="right">
                  <span style="vertical-align: middle;">￥<%=service.quantity*service.unit_cost %></span>
                </td>
                <td align="right">
                  <input type="text" id="num7" style="width: 180px; text-align: right;" value="<%=service.quantity*service.unit_cost %>" />
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>按比例分配的总价</span>
                </td>
                <td align="right">
                  <span style="vertical-align: middle;">-</span>
                </td>
                <td align="right">
                  <input type="text" id="num8" style="width: 180px; text-align: right;" value="0" />
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>按比例分配的总成本</span>
                </td>
                <td align="right">
                  <span style="vertical-align: middle;">-</span>
                </td>
                <td align="right">
                  <input type="text" id="num9" name="serAdjustCost" style="width: 180px; text-align: right;" value="0" />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </form>
  <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
  <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
  <script type="text/javascript">

    $("#SaveAndCloneButton").click(function () {
      var num = $("#num2").val();
      if (parseInt(num) <= 0) {
        alert("请输入单位数");
        return;
      }
      if ((/^\d{1,15}\.?\d{0,4}$/.test($("#num3").val())) == false) {
        alert('单价输入格式错误');
        return;
      }
      if ((/^\d{1,15}\.?\d{0,4}$/.test($("#num6").val())) == false) {
        alert('单位成本输入格式错误');
        return;
      }
      if ($("#num9").val() == "") {
        alert("请输入按比例分配的总成本");
        return;
      }
      $("#form1").submit();
    })
    $("#CancelButton").click(function () {
      window.close();
    })

    $("#num1").change(function () {
      var change = parseInt($("#num1").val());
      change = change + parseInt($("#units").val());
      $("#num2").val(change);
      if (change < 0) {
        alert("调整后的单位数应不小于0");
        $("#num1").val(0);
        return;
      }
      $("#num5").val(change * parseFloat($("#num3").val()));
      $("#num7").val(change * parseFloat($("#num6").val()));
    })

    $("#num3").change(function () {
      var k2 = $("#num3").val();
      if ((/^\d{1,15}\.?\d{0,4}$/.test(k2)) == false) {
        alert('只能输入四位小数');
      }
      var change = parseFloat($("#num3").val());
      var discount = parseInt((parseFloat($("#price").val()) - change) / parseFloat($("#price").val()) * 10000) / 100;
      if ($("#num4").val() != discount) {
        $("#num4").val(discount);
        $("#num5").val(change * parseInt($("#num2").val()));
      }
    })

    $("#num4").change(function () {
      var k2 = $("#num4").val();
      if ((/^\d{1,15}\.?\d{0,2}$/.test(k2)) == false) {
        alert('只能输入两位小数');
      }
      var change = parseFloat($("#num4").val());
      var price = parseInt((1 - change / 100) * $("#price").val() * 100) / 100;
      if ($("#num3").val() != price) {
        $("#num3").val(price);
        $("#num5").val(price * parseInt($("#num2").val()));
      }
    })

    $("#num5").change(function () {
      var k2 = $("#num5").val();
      if ((/^\d{1,15}\.?\d{0,4}$/.test(k2)) == false) {
        alert('只能输入四位小数');
      }
      var change = parseFloat($("#num5").val());
      var price = change / parseInt($("#num2").val());
      if ($("#num3").val() != price) {
        $("#num3").val(price);
        var discount = parseInt((parseFloat($("#price").val()) - price) / parseFloat($("#price").val()) * 10000) / 100;
        $("#num4").val(discount);
      }
    })

    $("#num6").change(function () {
      var k2 = $("#num6").val();
      if ((/^\d{1,15}\.?\d{0,4}$/.test(k2)) == false) {
        alert('只能输入四位小数');
      }
      var change = parseFloat($("#num6").val());
      var price = change * $("#num2").val();
      if ($("#num7").val() != price) {
        $("#num7").val(price);
      }
    })

    $("#num7").change(function () {
      var k2 = $("#num7").val();
      if ((/^\d{1,15}\.?\d{0,4}$/.test(k2)) == false) {
        alert('只能输入四位小数');
      }
      var change = parseFloat($("#num7").val());
      var price = parseInt(change / $("#num2").val() * 100) / 100;
      if ($("#num6").val() != price) {
        $("#num6").val(price);
      }
    })
      
  </script>
</body>
</html>
