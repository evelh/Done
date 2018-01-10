<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RoleRate.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.RoleRate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link href="../Content/reset.css" rel="stylesheet" />
  <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
  <link rel="stylesheet" type="text/css" href="../Content/style.css" />
  <title><%if (rateId == 0) { %>新增<%} else { %>编辑<%} %>费率</title>
</head>
<body>
  <form id="form1" runat="server">
    <div>
      <!--顶部-->
      <div class="TitleBar">
        <div class="Title">
          <span class="text1"><%if (rateId == 0) { %>新增<%} else { %>编辑<%} %>费率</span>
          <a href="###" class="help"></a>
        </div>
      </div>
      <!--按钮-->
      <div class="ButtonContainer header-title">
        <ul id="btn">
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
            <asp:Button ID="SaveClose" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="SaveClose_Click" />
          </li>
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
            <asp:Button ID="SaveNew" runat="server" Text="保存并新建" BorderStyle="None" OnClick="SaveNew_Click" />
          </li>
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
            <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClientClick="javascript:window.close();" />
          </li>
        </ul>
      </div>
      <div class="DivSection" style="border: none; padding-left: 0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <td width="30%" class="FieldLabels">角色名称
                <div>
                  <asp:DropDownList ID="role_id" runat="server" OnSelectedIndexChanged="role_id_SelectedIndexChanged"></asp:DropDownList>
                </div>
              </td>
            </tr>
            <tr>
              <td width="30%" class="FieldLabels">角色小时费率
                <div>
                  <asp:TextBox ID="role_rate" Enabled="false" runat="server"></asp:TextBox>
                </div>
              </td>
            </tr>
            <tr>
              <td width="30%" class="FieldLabels">合同角色小时费率
                <div>
                  <asp:TextBox ID="rate" runat="server"></asp:TextBox>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <asp:HiddenField ID="id" runat="server" />
        <asp:HiddenField ID="contract_id" runat="server" />
      </div>
    </div>
  </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        GetDataByRole();
    })

    $("#role_id").change(function () {
        GetDataByRole();
    });

    function GetDataByRole() {
        var role_id = $("#role_id").val();
        if (role_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/RoleAjax.ashx?act=role&role_id=" + role_id,
                success: function (data) {
                    if (data != "") {
                        // hourly_rate
                        if (data.hourly_rate != undefined && data.hourly_rate != undefined != "") {
                            $("#role_rate").val(toDecimal2(data.hourly_rate));
                        }
                        else {
                            $("#role_rate").val("0.00");
                        }
                    }
                },
            });
        }
    }
</script>
