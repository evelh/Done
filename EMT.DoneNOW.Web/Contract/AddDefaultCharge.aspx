<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddDefaultCharge.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.AddDefaultCharge" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/Roles.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
         <div class="TitleBar">
        <div class="Title">
            <span class="text1">新的默认成本</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon SaveAndClone"></span>
                <span class="Text">
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" BorderStyle="None" /></span>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <span class="Icon Cancel"></span>
                <span class="Text">取消</span>
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                        物料代码 
                        <span class="errorSmall">*</span>
                        <div>
                               <%
                                                            EMT.DoneNOW.Core.d_cost_code costCode = null;
                                                            if (!isAdd)
                                                            {
                                                                costCode = new EMT.DoneNOW.DAL.d_cost_code_dal().FindNoDeleteById(conDefCost.cost_code_id);
                                                            }
                                                            %>
                            <input type="text" name="" id="cost_code_id" style="width:200px;" value="<%=costCode!=null?costCode.name:"" %>"/>
                            <input type="hidden" name="cost_code_id" id="cost_code_idHidden" style="width:200px;" value="<%=costCode!=null?costCode.id.ToString():"" %>"  />
                             <img src="../Images/data-selector.png" style="vertical-align: middle;" id="" onclick="CostCodeBack()" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        单位成本
                        <div>
                            <%--<input type="text" style="width:200px;text-align: right;">--%>
                            <label  id="cost_unit_cost"></label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                          合同单位成本
                        <div>
                            <input type="text" class="return2" name="unit_cost" id="unit_cost" style="width:200px;text-align: right;"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=(!isAdd)&&conDefCost.unit_cost!=null?((decimal)conDefCost.unit_cost).ToString("#0.00"):"" %>" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        单价 
                        <div>
                            <%--<input type="text" id="" style="width:200px;text-align: right;" />--%>
                            <label  id="cost_unit_price"></label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        合同单价  
                        <div>
                            <input type="text" class="return2" name="unit_price" id="unit_price" style="width:200px;text-align: right;" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=(!isAdd)&&conDefCost.unit_price!=null?((decimal)conDefCost.unit_price).ToString("#0.00"):"" %>" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div>
                            <asp:CheckBox ID="isbillable" runat="server" />
                            计费的
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>

    $(function () {
        <% if (!isAdd)
        { %>
        GetDataByCostCode();
        <%}%>
    })
    $("#save_close").click(function () {
        var costcodeid = $("#cost_code_idHidden").val();
        if (costcodeid == "") {
            alert("请通过查找带回功能选择物料代码");
            return false;
        }
        var unit_cost = $("#unit_cost").val();
        if (unit_cost == "") {
            alert("请填写成本信息");
            return false;
        }

        // unit_price
        var unit_price = $("#unit_price").val();
        if (unit_price == "") {
            alert("请填写单价信息");
            return false;
        }

        return true;
    })

    $(".return2").blur(function () {
        var value = $(this).val();
        if (!isNaN(value) && value != "") {
            $(this).val(toDecimal2(value));
        } else {
            $(this).val("");
        }
    })
    function CostCodeBack() {
        //MATERIALCODE_CALLBACK\ 
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&field=cost_code_id&callBack=GetDataByCostCode", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function GetDataByCostCode() {
        var cost_code_id = $("#cost_code_idHidden").val();
        if (cost_code_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/QuoteAjax.ashx?act=costCode&id=" + cost_code_id,
                success: function (data) {
                    if (data != "") {
                        if (data.unit_price != undefined) {
                            $("#cost_unit_price").text(data.unit_price); 
                        }
                        if (data.unit_cost != undefined) {
                            $("#cost_unit_cost").text(data.unit_cost);
                        }
                    }
                },
            });
        }
    }

   
</script>
