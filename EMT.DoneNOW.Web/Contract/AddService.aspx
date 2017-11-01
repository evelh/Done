<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddService.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.AddService" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link rel="stylesheet" href="../Content/reset.css" />
  <link rel="stylesheet" href="../Content/Roles.css" />
  <title>新增<%=serviceName %></title>
</head>
<body>
  <div class="TitleBar">
    <div class="Title">
      <span class="text1">新增<%=serviceName %></span>
    </div>
  </div>
  <form id="form1" runat="server">
    <div class="ButtonContainer">
      <ul>
        <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
          <span class="Icon SaveAndClone"></span>
          <span class="Text">保存并关闭</span>
        </li>
        <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
          <span class="Icon Cancel"></span>
          <span class="Text">取消</span>
        </li>
      </ul>
      <input type="hidden" id="contractId" name="contract_id" value="<%=contract.id %>" />
      <input type="hidden" id="object_type" name="object_type" value="<%=objType %>" />
      <input type="hidden" id="conBgDate" value="<%=contract.start_date.ToString("yyyy-MM-dd") %>" />
      <input type="hidden" id="conEndDate" value="<%=contract.end_date.ToString("yyyy-MM-dd") %>" />
    </div>
    <div class="DivSection" style="width: 622px;">
      <table border="0">
        <tbody>
          <tr>
            <td>
              <span class="FieldLabels" style="font-weight: bold;"><%=serviceName %>名称<span class="errorSmall">*</span></span>
              <div>
                <input type="hidden" id="ServiceIdHidden" name="object_id" />
                <input type="text" disabled="disabled" id="ServiceId" style="width: 260px;" />
                <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=objType==1?((int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALLBACK):((int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_BUNDLE_CALLBACK) %>&field=ServiceId&callBack=GetService', '<%=EMT.DoneNOW.DTO.OpenWindow.ServiceSelect %>', 'left=200,top=200,width=600,height=800', false)" style="vertical-align: middle; cursor: pointer;" />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <span class="FieldLabels" style="font-weight: bold;">日期<span class="errorSmall">*</span>
                <span style="font-weight: normal;">(输入一个<%=contract.start_date.ToString("yyyy-MM-dd")+" - "+contract.end_date.ToString("yyyy-MM-dd") %>之间的日期)</span>
              </span>
              <div>
                <input type="text" onclick="WdatePicker()" value="<%=effDate.ToString("yyyy-MM-dd") %>" id="effDate" name="effective_date" class="Wdate" style="width: 90px;" />
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
                <td style="width: 200px;"></td>
                <td align="right" style="width: 420px;">总数
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>单位数<span class="errorSmall">*</span></span>
                </td>
                <td align="right">
                  <input type="text" id="quantity" name="quantity" style="width: 320px;text-align: right;" value="1"/>
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>单价</span>
                </td>
                <td align="right">
                  <input type="text" id="unit_price" name="unit_price" style="width: 320px; text-align: right;"/>
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>总价</span>
                </td>
                <td align="right">
                  <input type="text" id="total_price" style="width: 320px; text-align: right;"/>
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>单位成本</span>
                </td>
                <td align="right">
                  <input type="text" id="unit_cost" name="unit_cost" style="width: 320px;text-align: right;"/>
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>总成本</span>
                </td>
                <td align="right">
                  <input type="text" id="total_cost" style="width: 320px; text-align: right;" />
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>按比例分配的总价</span>
                </td>
                <td align="right">
                  <input type="text" id="adjustPrice" disabled="disabled" style="width: 320px; text-align: right;"/>
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>按比例分配的总成本</span>
                </td>
                <td align="right">
                  <input type="text" id="adjustCost" name="adjustCost" style="width: 320px; text-align: right;"/>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </form>
  <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
  <script type="text/javascript" src="../Scripts/common.js"></script>
  <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
  <script type="text/javascript">
    var percent = 0;
    function GetService() {
      requestData("../Tools/ContractAjax.ashx?act=GetService&id=" + $("#ServiceIdHidden").val() + "&type=" + $("#object_type").val(), "", function (data) {
        $("#unit_price").val(data.unit_price);
        $("#total_price").val(data.unit_price * $("#quantity").val());
        $("#unit_cost").val(data.unit_cost);
        $("#total_cost").val(data.unit_cost * $("#quantity").val());
        requestData("../Tools/ContractAjax.ashx?act=CalcServiceAdjustPercent&contractId=" + $("#contractId").val() + "&date=" + $("#effDate").val(), null, function (data) {
          percent = data;
          calcAdjust();
        })
      })
    }

    $("#SaveAndCloneButton").click(function () {
      if ($("#ServiceIdHidden").val() == "") {
        alert("请选择<%=serviceName%>");
        return;
      }
      if ($("#effDate").val() == "") {
        alert("请选择生效日期");
        return;
      }
      if ($("#unit_price").val() == "") {
        alert("请输入单价");
        return;
      }
      if ($("#unit_cost").val() == "") {
        alert("请输入单位成本");
        return;
      }
      if (compareTime($("#conBgDate").val(), $("#effDate").val())) {
        alert("生效日期应不小于合同开始日期，请重新选择");
        return;
      }
      if (compareTime($("#effDate").val(), $("#conEndDate").val())) {
        alert("生效日期应不大于合同结束日期，请重新选择");
        return;
      }
      if ($("#adjustCost").val() == "") {
        alert("请输入按比例分配的总成本");
        return;
      }
      $("#form1").submit();
    })
    $("#quantity").change(function () {
      if (!checkNumInt($("#quantity").val())) {
        alert("请输入大于0的整数数字");
        $("#quantity").val('').focus();
        return;
      }
      if ($("#unit_price").val() != "") {
        $("#total_price").val($("#unit_price").val() * $("#quantity").val());
        $("#adjustPrice").val(($("#total_price").val() * percent).toFixed(2));
      }
      if ($("#unit_cost").val() != "") {
        $("#total_cost").val($("#unit_cost").val() * $("#quantity").val());
        $("#adjustCost").val(($("#total_cost").val() * percent).toFixed(2));
      }
    })
    $("#unit_price").change(function () {
      $("#total_price").val($("#unit_price").val() * $("#quantity").val());
      $("#adjustPrice").val(($("#total_price").val() * percent).toFixed(2));
    })
    $("#unit_cost").change(function () {
      $("#total_cost").val($("#unit_cost").val() * $("#quantity").val());
      $("#adjustCost").val(($("#total_cost").val() * percent).toFixed(2));
    })
    $("#effDate").blur(function () {
      if ($("#effDate").val() == "") {
        return;
      }
      if (compareTime($("#conBgDate").val(), $("#effDate").val())) {
        return;
      }
      if (compareTime($("#effDate").val(), $("#conEndDate").val())) {
        return;
      }
      requestData("../Tools/ContractAjax.ashx?act=CalcServiceAdjustPercent&contractId=" + $("#contractId").val() + "&date=" + $("#effDate").val(), null, function (data) {
        percent = data;
        calcAdjust();
      })
    })
    $("#CancelButton").click(function () {
      window.close();
    })
    function calcAdjust() {
      if ($("#unit_price").val() != "") {
        $("#adjustPrice").val(($("#total_price").val() * percent).toFixed(2));
      }
      if ($("#unit_cost").val() != "") {
        $("#adjustCost").val(($("#total_cost").val() * percent).toFixed(2));
      }
    }
    function checkNumInt(num) {
      var r = /^\+?[1-9][0-9]*$/;
      return r.test(num);
    }
    function checkNumFloat(num) {
      var r = /^(\d+)(\.\d+)?$/;
      return r.test(num);
    }
  </script>
</body>
</html>
