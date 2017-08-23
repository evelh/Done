<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SubscriptionAddOrEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigurationItem.SubscriptionAddOrEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
       <title>新建订阅</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <style>
body{
   /*overflow: hidden;*/
}
/*顶部内容和帮助*/
.TitleBar{
    color: #fff;
    background-color: #346a95;
    display: block;
    font-size: 15px;
    font-weight: bold;
    height: 36px;
    line-height: 38px;
    margin: 0 0 10px 0;
}
.TitleBar>.Title{
    top: 0;
    height: 36px;
    left: 10px;
    overflow: hidden;
    position: absolute;
    text-overflow: ellipsis;
    text-transform: uppercase;
    white-space: nowrap;
    width: 97%;
}
.text2{
    margin-left: 5px;
}
.help{
    background-image: url(../Images/help.png);
    cursor: pointer;
    display: inline-block;
    height: 16px;
    position: absolute;
    right: 10px;
    top: 10px;
    width: 16px;
    border-radius: 50%;
}
/*保存按钮*/
.ButtonContainer{
    padding: 0 10px 10px 10px;
    width: auto;
    height: 26px;
}
.ButtonContainer ul li .Button{
    margin-right: 5px;
    vertical-align: top;
}
li.Button{
    -ms-flex-align: center;
    align-items: center;
    background: #f0f0f0;
    background: -moz-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
    background: -webkit-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
    background: -ms-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
    background: linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%);
    border: 1px solid #d7d7d7;
    display: -ms-inline-flexbox;
    display: inline-flex;
    color: #4f4f4f;
    cursor: pointer;
    height: 24px;
    padding: 0 3px;
    position: relative;
    text-decoration: none;
}
.Button>.Icon{
    display: inline-block;
    flex: 0 0 auto;
    height: 16px;
    margin: 0 3px;
    width: 16px;
}
.Save,.SaveAndClone,.SaveAndNew{
    background-image: url("../Images/save.png");
}
.Cancel{
    background-image: url("../Images/cancel.png");
}
.Button>.Text{
    flex: 0 1 auto;
    font-size: 12px;
    font-weight: bold;
    overflow: hidden;
    padding: 0 3px;
    text-overflow: ellipsis;
    white-space: nowrap;
}
/*内容*/
.DivScrollingContainer.General {
    top: 82px;
}
.DivScrollingContainer {
    left: 0;
    overflow-x: auto;
    overflow-y: auto;
    position: fixed;
    right: 0;
    bottom: 0;
}
.DivSection {
    border: 1px solid #d3d3d3;
    margin: 0 10px 10px 10px;
    padding: 12px 28px 4px 28px;
}
.DivSection>table {
    border: 0;
    margin: 0;
    border-collapse: collapse;
}
.DivSection td[id="txtBlack8"], .DivSection td[class="FieldLabels"] {
    vertical-align: top;
}
.DivSection td {
    padding: 0;
    text-align: left;
}
.FieldLabels, .workspace .FieldLabels {
    font-size: 12px;
    color: #4F4F4F;
    font-weight: bold;
    line-height: 15px;
}
.DivSection td[class="fieldLabels"] input, .DivSection td[class="fieldLabels"] select, .DivSection td[class="FieldLabels"] input, .DivSection td[class="FieldLabels"] select, .WizardSection td[class="fieldLabels"] input, .WizardSection td[class="fieldLabels"] select, .WizardSection td[class="FieldLabels"] input, .WizardSection td[class="FieldLabels"] select {
    margin-right: 1px;
}
.DivSection .FieldLabels div, .DivSection td[class="fieldLabels"] div, .DivSectionWithHeader td[class="fieldLabels"] div {
    margin-top: 1px;
    padding-bottom: 11px;
    font-weight: 100;
}
input[type=text], select, textarea {
    border: solid 1px #D7D7D7;
    font-size: 12px;
    color: #333;
    margin: 0;
}
input[type=text] {
    height: 22px;
    padding: 0 6px;
}
select {
    height: 24px;
    padding: 0;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
     <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增订阅</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon SaveAndClone"></span>
                <span class="Text"><asp:Button ID="save_click" runat="server" Text="保存并关闭" /></span>
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                <span class="Icon SaveAndNew"></span>
                <span class="Text"><asp:Button ID="save_add" runat="server" Text="保存并新建" /></span>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <span class="Icon Cancel"></span>
                <span class="Text" id="close">取消</span>
            </li>
        </ul>
    </div>
    <!--内容-->
    <div class="DivScrollingContainer General">
        <div class="DivSection">
            <table width="95%" border="0" cellspacing="0" cellpadding="2">
                <tbody>
                    <tr>
                        <td class="FieldLabels">
                            名称
                            <span style="color:red;">*</span>
                            <div>
                                <input type="text" id="name" name="name" value="<%=isAdd?"":subscription.name %>" style="width:255px">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            描述
                            <div>
                                <input type="text" style="width:255px"  id="description" name="description" value="<%=isAdd?"":subscription.description %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            周期类型
                            <div>
                                <asp:DropDownList ID="period_type_id" runat="server" Width="270px"></asp:DropDownList>
                        
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            有效日期
                            <span style="color:red;">*</span>
                            <div>
                                <input type="text" style="width:255px" onclick="WdatePicker()" class="Wdate"  id="effective_date" name="effective_date" value="<%=isAdd?"":subscription.effective_date.ToString("yyyy-MM-dd") %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            过期日期
                            <span style="color:red;">*</span>
                            <div>
                                <input type="text" style="width:255px" onclick="WdatePicker()" class="Wdate" id="expiration_date" name="expiration_date" value="<%=isAdd?"":subscription.expiration_date.ToString("yyyy-MM-dd") %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            周期价格
                            <span style="color:red;">*</span>
                            <div>
                                <input type="text" style="width:255px;text-align: right;" id="period_price" name="period_price" value="<%=isAdd?"":subscription.period_price.ToString() %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            总价
                            <span style="color:red;">*</span>
                            <div>
                                <input type="text" style="width:255px;text-align: right;" id="total_price" name="total_price" value="<%=isAdd?"":subscription.total_price.ToString() %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            物料成本代码
                            <span style="color:red;">*</span>
                            <div> 
                                <!-- todo 物料代码名称的显示-->
                                <input type="text" style="width:255px;"  id="material_code_id" name="" value="" />
                                <img src="../Images/data-selector.png" style="vertical-align: middle;">
                                <input type="hidden" name="material_code_id" id="material_code_idHidden" value="<%=isAdd?"":subscription.material_code_id.ToString() %>"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            订单号
                            <div>
                                <input type="text" style="width:255px" name="purchase_order_number" id="purchase_order_number" value="<%=isAdd?"":subscription.purchase_order_number.ToString() %>"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            周期成本
                            <div>
                                <input type="text" style="width:255px;text-align: right;"  name="period_cost" id="period_cost" value="<%=(!isAdd)&&subscription.period_cost!=null?((decimal)subscription.period_cost).ToString("0.00"):"" %>"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            总成本
                            <div>
                                <input type="text" style="width:255px;text-align: right;" name="total_cost" id="total_cost" value="<%=(!isAdd)&&subscription.total_cost!=null?((decimal)subscription.total_cost).ToString("0.00"):"" %>"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            状态
                            <div>
                                <select style="width:270px">
                                    <option value="">Active</option>
                                    <option value="">Monthly</option>
                                    <option value="">Monthly</option>
                                    <option value="">Monthly</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="DivSection">
            <table width="95%" border="0" cellspacing="0" cellpadding="2">
                <tbody>
                    <tr>
                        <td class="FieldLabels">
                           客户名称
                            <% var account = new EMT.DoneNOW.BLL.CompanyBLL().GetCompany((long)iProduct.account_id); %>
                            <div>
                               <%=account!=null?account.name:"" %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            配置项名称
                            <% var ivtdProduct = new EMT.DoneNOW.BLL.IVT.ProductBLL().GetProduct(iProduct.product_id); %>
                            <div>
                               <%=ivtdProduct!=null?ivtdProduct.product_name:"" %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            配置项序列号
                            <div>
                                <%=iProduct.serial_number %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                           配置项参考号
                            <div>
                                <%=iProduct.reference_number %>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="DivSection">
            <table width="95%" border="0" cellspacing="0" cellpadding="2">
                <tbody>
                    <tr>
                        <td class="FieldLabels">
                            订阅期数
                            <div>
                                <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color:transparent; text-align:left">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            首期结算日
                            <div>
                                <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color:transparent; text-align:left">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            下期结算日
                            <div>
                                <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color:transparent; text-align:left">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            最后一期结算日期
                            <div>
                                <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color:transparent; text-align:left">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            已结算金额
                            <div>
                                <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color:transparent; text-align:left" value="¥0.00">
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
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script>
    $("#SaveAndCloneButton").on("mouseover", function () {
        $("#SaveAndCloneButton").css("background", "#fff");
    });
    $("#SaveAndCloneButton").on("mouseout", function () {
        $("#SaveAndCloneButton").css("background", "#f0f0f0");
    });
    $("#SaveAndNewButton").on("mouseover", function () {
        $("#SaveAndNewButton").css("background", "#fff");
    });
    $("#SaveAndNewButton").on("mouseout", function () {
        $("#SaveAndNewButton").css("background", "#f0f0f0");
    });
    $("#CancelButton").on("mouseover", function () {
        $("#CancelButton").css("background", "#fff");
    });
    $("#CancelButton").on("mouseout", function () {
        $("#CancelButton").css("background", "#f0f0f0");
    });
</script>
