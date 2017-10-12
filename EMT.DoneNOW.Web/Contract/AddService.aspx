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
          <span class="Text">保存 & 关闭</span>
        </li>
        <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
          <span class="Icon Cancel"></span>
          <span class="Text">取消</span>
        </li>
      </ul>
      <input type="hidden" name="contract_id" value="<%=contract.id %>" />
      <input type="hidden" id="object_type" name="object_type" value="<%=objType %>" />
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
                <input type="text" onclick="WdatePicker()" value="<%=effDate.ToString("yyyy-MM-dd") %>" name="effective_date" class="Wdate" style="width: 90px;" />
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
                  <input type="text" disabled="disabled" style="width: 320px; text-align: right;"/>
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
  <script type="text/javascript">
    function GetService() {
      requestData("../Tools/ContractAjax.ashx?act=GetService&id=" + $("#ServiceIdHidden").val() + "&type=" + $("#object_type").val(), "", function (data) {
        $("#unit_price").val(data.unit_price);
        $("#total_price").val(data.unit_price * $("#quantity").val());
        $("#unit_cost").val(data.unit_cost);
        $("#total_cost").val(data.unit_cost * $("#quantity").val());
      })
    }

    $("#SaveAndCloneButton").click(function () {
      if ($("#ServiceIdHidden").val() == "") {
        alert("请选择<%=serviceName%>");
        return;
      }
      if ($("#adjustCost").val() == "") {
        alert("请输入按比例分配的总成本");
        return;
      }
      $("#form1").submit();
    })
    $("#CancelButton").click(function () {
      window.close();
    })
  </script>
</body>
</html>
