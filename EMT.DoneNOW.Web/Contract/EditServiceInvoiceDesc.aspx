<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditServiceInvoiceDesc.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.EditServiceInvoiceDesc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>编辑发票描述-<%=serviceName %></title>
  <link rel="stylesheet" href="../Content/reset.css" />
  <link rel="stylesheet" href="../Content/Roles.css" />
</head>
<body>
  <div class="TitleBar">
    <div class="Title">
      <span class="text1">编辑发票描述-<%=serviceName %></span>
    </div>
  </div>
  <div class="ButtonContainer">
    <ul id="btn">
      <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton">
        <span class="Icon SaveAndClone"></span>
        <span class="Text">保存 & 关闭</span>
      </li>
      <li class="Button ButtonIcon NormalState" id="CancelButton">
        <span class="Icon Cancel"></span>
        <span class="Text">取消</span>
      </li>
    </ul>
  </div>
  <form id="form1" runat="server">
    <div class="DivSection" style="border: none; padding-left: 0;">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tbody>
          <tr>
            <td width="30%" class="FieldLabels">服务名称
              <div>
                <%=serviceName %>
              </div>
            </td>
          </tr>
          <tr>
            <td width="30%" class="FieldLabels">
              <div>
                <input type="radio" value="1" name="is_invoice_description_customized" style="vertical-align: middle;" checked="checked" id="First" />
                使用标准发票描述
              </div>
            </td>
          </tr>
          <tr>
            <td width="30%" class="FieldLabels">
              <div style="padding-bottom: 10px;">
                <input type="radio" value="0" name="is_invoice_description_customized" style="vertical-align: middle;" id="Second" />
                自定义描述信息
              </div>
              <span style="margin-left: 10px;">自定义发票描述信息</span>
              <div style="margin-left: 10px;">
                <textarea style="width: 300px; min-height: 50px;" disabled="disabled" id="Textarea" name="invoice_description"></textarea>
                <br />
                <a onclick="copyDesc()">复制标准发票描述</a>
              </div>
            </td>
          </tr>
          <tr>
            <td width="30%" class="FieldLabels">
              <div>
                内部描述将显示在已选择合同的服务和服务包选择器中。这可以用来区分和区分服务/服务包，特别是在同一个合同内服务/服务包超过一次的情况下。
              </div>
            </td>
          </tr>
          <tr>
            <td width="30%" class="FieldLabels">内部描述
              <div>
                <input type="text" style="width: 300px;" name="internal_description" />
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      <input type="hidden" name="id" value="<%=service.id %>" />
    </div>
  </form>
  <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
  <script type="text/javascript" src="../Scripts/Roles.js"></script>
  <script>
    $("#First").on("click", function () {
      $("#Textarea").prop("disabled", true);
    });
    $("#Second").on("click", function () {
      $("#Textarea").prop("disabled", false);
    });
    $("#SaveAndCloneButton").on("click", function () {
      $("#form1").submit();
    });
    $("#CancelButton").on("click", function () {
      window.close();
    });
    function copyDesc() {
      $("#Textarea").text("<%=description%>");
    }
  </script>
</body>
</html>
