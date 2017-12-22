<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdjustExpensePrice.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.AdjustExpensePrice" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
          <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>费用调整</title>
</head>
<body>
    <form id="form1" runat="server">
       <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">工时调整</span>
            <a href="###" class="help"></a>
        </div>
    </div>
     <!--按钮-->
    <div class="ButtonContainer header-title">
        <ul id="btn">
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <asp:Button ID="Save_Close" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click" />
            </li>
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" />
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                       客户名称
                        <span class="errorSmall">*</span>
                        <div>
                           <label><%=thisAcc.name %></label>
                        </div>
                    </td>
                </tr>
              
                <tr>
                    <td width="30%" class="FieldLabels">
                        调整后总价
                        <div>
                            <input type="text" id="amount_deduction" name="amount_deduction"  style="width:220px;"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=thisExp.amount_deduction==null?"":((decimal)thisExp.amount_deduction).ToString("#0.00") %>" class="ToDec2" />
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#Cancel").click(function () {
        window.close();
    })

    $(".ToDec2").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && !isNaN(thisValue)) {
            $(this).val(toDecimal2(thisValue));
        }
        else {
            $(this).val("");
        }
    })

    

</script>
