<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdjustEntryPrice.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.AdjustEntryPrice" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>工时调整</title>
    
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
                       任务或工单名称
                        <span class="errorSmall">*</span>
                        <div>
                           <label><%=thisTask.title %></label>
                        </div>
                    </td>
                </tr>
                <tr >
                    <td width="30%" class="FieldLabels">
                       计费时长
                        <div>
                            <input type="text" id="hours_billed_deduction" name="hours_billed_deduction" style="width:220px;"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=((decimal)(thisEntry.hours_billed_deduction??thisEntry.hours_billed)).ToString("#0.00") %>" class="ToDec2" />
                        </div>
                    </td>
                </tr>
                <tr >
                    <td width="30%" class="FieldLabels">
                        计费费率
                        <div>
                            <input type="text" id="hours_rate_deduction" name="hours_rate_deduction" style="width:220px;"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=thisEntry.hours_rate_deduction==null?(searchRate==null?"":((decimal)searchRate).ToString("#0.00")):((decimal)thisEntry.hours_rate_deduction).ToString("#0.00") %>" class="ToDec2" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        调整后总价
                        <div>
                            <input type="text" id="totalPrice"  style="width:220px;" disabled="disabled" />
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
    $(function () {
        GetPrice();
    })
    $("#Cancel").click(function () {
        window.close();
    })

    function GetPrice() {

        var hours_billed_deduction = $("#hours_billed_deduction").val();
        var hours_rate_deduction = $("#hours_rate_deduction").val();
        if (hours_billed_deduction != "" && hours_billed_deduction != "") {
            var totalPrice = Number(hours_billed_deduction) * Number(hours_rate_deduction);
            $("#totalPrice").val(toDecimal2(totalPrice));
        }
        else {
            $("#totalPrice").val("");
        }
    }

    $(".ToDec2").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && !isNaN(thisValue)) {
            $(this).val(toDecimal2(thisValue));
        }
        else {
            $(this).val("");
        }
        GetPrice();
    })

</script>
