<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoseOpportunity.aspx.cs" Inherits="EMT.DoneNOW.Web.Opportunity.LoseOpportunity" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <title>丢失商机向导</title>
       <link rel="stylesheet" href="../Content/reset.css" />
     
    <style>
        body{
    overflow: hidden;
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
/*第一页*/
.PageInstructions {
    font-size: 12px;
    color: #666;
    padding: 0 16px 12px 16px;
    margin-top: -1px;
    line-height: 16px;
}
.WizardSection {
    padding-left: 16px;
    padding-right: 16px;
}
.Workspace table {
    border-right: 0;
    padding-right: 0;
    border-top: 0;
    padding-left: 0;
    margin: 0;
    border-left: 0;
    border-bottom: 0;
}
td {
    font-size: 12px;
}
.FieldLabels, .workspace .FieldLabels {
    font-size: 12px;
    color: #4F4F4F;
    font-weight: bold;
    line-height: 15px;
}
.errorSmall {
    font-size: 12px;
    color: #E51937;
    margin-left: 3px;
    text-align: center;
}
input[type=text] {
    height: 22px;
    padding: 0 6px;
}
input[type="text"]:disabled, select:disabled, textarea:disabled {
    background-color: #f0f0f0;
    color: #6d6d6d;
    margin-right: 1px;
}
input[type=text], select, textarea {
    border: solid 1px #D7D7D7;
    font-size: 12px;
    color: #333;
    margin: 0;
}
.WizardSection div {
    padding-bottom: 21px;
}
#opportunity_id {
    font-size: 12px;
    color: #333;
    font-weight: 100;
}
.step2LeftSelectWidth {
    width: 292px;
}
.WizardSection td[class="FieldLabels"] select {
    margin-right: 1px;
}
select {
    height: 24px;
    padding: 0;
}
textarea {
    padding: 6px;
    resize: vertical;
}
.WizardButtonBar {
    padding: 0 16px 12px 16px;
    position: absolute;
    bottom:10px;
}
/*下面按钮*/
.ButtonBar {
    font-size: 12px;
    padding: 0 16px 10px 16px;
    background-color: #FFF;
}
.ButtonBar ul {
    list-style-type: none;
    padding: 0;
    margin: 0;
    height: 26px;
    width: 100%;
}
.ButtonBar ul li {
    float: left;
}
#finish{
        /* border-style: None; */
    width: 80px;
    font-size: 12px;
    font-weight: bold;
    line-height: 26px;
    padding: 0 1px 0 3px;
    color: #4F4F4F;
    vertical-align: top;
}
.ButtonBar ul li a, .ButtonBar ul li a:visited, .contentButton a, .contentButton a:link, .contentButton a:visited, a.buttons, input.button, .ButtonBar ul li a:visited ,#finish{
    background: #d7d7d7;
    background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
    background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
    background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
    background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
    border: 1px solid #bcbcbc;
    display: inline-block;
    color: #4F4F4F;
    cursor: pointer;
    padding: 0 5px 0 3px;
    position: relative;
    text-decoration: none;
    vertical-align: middle;
    height: 24px;
}
div.ButtonBar img.ButtonImg, .contentButton img.ButtonImg {
    margin: 4px 3px 0 3px;
}
.ButtonBar ul li img {
    border: 0;
}
.ButtonBar ul li a span.Text, .contentButton a span.Text, a.buttons span.Text, input.button span.Text {
    font-size: 12px;
    font-weight: bold;
    line-height: 26px;
    padding: 0 1px 0 3px;
    color: #4F4F4F;
    vertical-align: top;
}
div.ButtonBar li.right {
    float: right;
}
div.ButtonBar img.ButtonRightImg {
    margin: 4px 1px 0 2px;
}
.DivSection td[class="fieldLabels"] input[type=radio], .DivSection td[class="FieldLabels"] input[type=radio], .DivSection td[class="fieldLabels"] input[type=checkbox], .DivSection td[class="FieldLabels"] input[type=checkbox], .WizardSection td[class="fieldLabels"] input[type=radio], .WizardSection td[class="FieldLabels"] input[type=radio], .WizardSection td[class="fieldLabels"] input[type=checkbox], .WizardSection td[class="FieldLabels"] input[type=checkbox] {
    margin-right: 0;
    vertical-align: middle;
    margin-top: -2px;
    margin-bottom: 1px;
}
a:link, a:visited, .dataGridBody a:link, .dataGridBody a:visited {
    color: #376597;
    font-size: 12px;
    text-decoration: none;
}
.grid {
    font-size: 12px;
    background-color: #FFF;
}
.grid table {
    border-bottom-color: #98b4ca;
    border-collapse: collapse;
    width: 100%;
    border-bottom-width: 1px;
    border-bottom-style: solid;
}
.grid thead {
    background-color: #cbd9e4;
}
.grid thead tr td {
    background-color: #cbd9e4;
    border-color: #98b4ca;
    color: #64727a;
}
.grid thead td {
    border-width: 1px;
    border-style: solid;
    font-size: 13px;
    font-weight: bold;
    height: 19px;
    padding: 4px 4px 4px 4px;
    word-wrap: break-word;
}
.grid .selected {
    background-color: #e9eeee;
}
.grid tbody tr td:first-child, .grid tfoot tr td:first-child {
    border-left-color: #98b4ca;
}
.grid tbody td {
    border-width: 1px;
    border-style: solid;
    border-left-color: #F8F8F8;
    border-right-color: #F8F8F8;
    border-top-color: #e8e8e8;
    border-bottom-width: 0;
    padding: 4px 4px 4px 4px;
    vertical-align: top;
    word-wrap: break-word;
    font-size: 12px;
    color: #333;
}
.Workspace div {
     padding-bottom: 21px;
}
textarea {
    padding: 6px;
    resize: none;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
     <div class="TitleBar">
        <div class="Title">
            <span class="text1">丢失商机</span>
            <a href="###" class="help"></a>
        </div>
    </div>
            <!--第一页-->
    <div class="Workspace Workspace1">
        <div class="PageInstructions">丢失的机会向导被用来指定一个激活的商机。该向导将在提供的日期中设置机会状态，并向客户添加一个备注。你也可以通知个人，这个商机已经丢失了。选择一个商机，一个阶段，一个商机的拥有者，失去的日期和数量。您也可以选择一个主要的竞争对手和实际的初级产品为这个商机，选择一个丢失的原因，并输入丢失的原因细节</div>
        <div class="WizardSection">
            <table cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr height="85%">
                        <td width="90%" valign="top">
                            <!--第一页主体-->
                            <table cellspacing="0" cellpadding="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td width="55%" class="FieldLabels">
                                            客户<span class="errorSmall">*</span>
                                            <div>
                                                <input type="text" disabled="disabled" style="width: 278px; margin-right: 4px;" value="<%=account.name %>">
                                                <img src="../Images/data-selector.png" style="vertical-align: middle;">
                                                <input type="hidden" name="account_id" id="account_id" value="<%=account.id %>"/>
                                            </div>
                                        </td>
                                        <td width="45%" class="FieldLabels">
                                            总收益
                                            <div>
                                                <input type="text" id="total_revneue" style="width: 278px;" value="<%= new EMT.DoneNOW.BLL.OpportunityBLL().ReturnOppoRevenue(opportunity.id).ToString("0.00") %>">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabels">
                                            商机<span class="errorSmall">*</span>
                                            <div>
                                                 <asp:DropDownList ID="opportunity_id" runat="server" CssClass="step2LeftSelectWidth" ></asp:DropDownList>
                                                <%--<select disabled="disabled" id="txtBlack8" class="step2LeftSelectWidth">
                                                    <option value="">xiaodangjia</option>
                                                </select>--%>
                                            </div>
                                        </td>
                                        <td class="FieldLabels">
                                           丢失时间
                                            <div>
                                                <input type="text" id="lostTime" name="lostTime" onclick="WdatePicker()" class="Wdate" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>"/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabels">
                                            阶段
                                            <div>
                                                <asp:DropDownList ID="stage_id" runat="server" CssClass="step2LeftSelectWidth"></asp:DropDownList>
                                               
                                            </div>
                                        </td>
                                        <td class="FieldLabels">
                                            丢单原因<span class="errorSmall">*</span>
                                            <div>
                                                <asp:DropDownList ID="loss_reason_type_id" CssClass="step2LeftSelectWidth" runat="server"></asp:DropDownList>
                                        
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabels">
                                            商机负责人
                                            <div>
                                                 <asp:DropDownList ID="resource_id" runat="server" CssClass="step2LeftSelectWidth"></asp:DropDownList>
                                              
                                            </div>
                                        </td>
                                        <td rowspan="3" class="FieldLabels" style="vertical-align: top;">
                                            丢单详情 <span class="errorSmall">*</span>
                                            <div>
                                                <textarea style="width:278px; height:160px;" name="loss_reason" id="loss_reason" ></textarea>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabels">
                                            <%
                                                var productname = "";
                                                if (opportunity.primary_product_id != null)
                                                {
                                                    var product = new EMT.DoneNOW.BLL.ProductBLL().GetProduct((long)opportunity.primary_product_id);
                                                    if (product != null)
                                                    {
                                                        productname = product.name;
                                                    }
                                                }

                                                %>
                                            主要产品
                                            <div>
                                                <input type="text" style="width: 278px; margin-right: 4px;" id="productName" value="<%=productname %>" />
                                                <img src="../Images/data-selector.png" style="vertical-align: middle;" />
                                                <input type="hidden" name="primary_product_id" id="productNameHidden" value="<%=opportunity.primary_product_id==null?"":opportunity.primary_product_id.ToString() %>"/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabels">
                                            竞争对手
                                            <div>
                                                <asp:DropDownList ID="competitor_id" runat="server" CssClass="step2LeftSelectWidth"></asp:DropDownList>                                              
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar WizardButtonBar" style="width:97%;">
            <ul>
                <!--上一层-->
                <li style="display: none;" id="a1">
                    <a class="ImgLink">
                        <img class="ButtonImg" src="../Images/move-left.png" />
                        <span class="Text">上一页</span>
                    </a>
                </li>
                <!--下一层-->
                <li class="right" id="b1">
                    <a class="ImgLink">
                        <span class="Text">下一页</span>
                        <img class="ButtonRightImg" src="../Images/move-right.png" />
                    </a>
                </li>
                <!--完成-->
                <li class="right" style="display: none;" id="c1">
                    <a class="ImgLink">
                        <span class="Text">完成</span>
                    </a>
                </li>
                <!--关闭-->
                <li class="right" style="display: none;" id="d1">
                    <a class="ImgLink">
                        <img class="ButtonRightImg" src="../Images/cancel.png" />
                        <span class="Text">关闭</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <!--第二页-->
    <div class="Workspace Workspace2" style="display: none;">
        <%--<div class="PageInstructions">Select the person(s) you would like to notify. Use "Other Email(s)" if you have a distribution list. Ex. distribution@yourcompany.com</div>--%>
        <div class="WizardSection">
            <table cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                <tr height="85%">
                    <td width="90%" valign="top">
                        <!--第二页主体-->
                        <table cellspacing="0" cellpadding="0" width="500px;">
                            <tbody>
                                <tr>
                                    <td>
                                        <div>
                                            <table cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                <tr>
                                                    <td width="1%" class="FieldLabels">
                                                       <input id="CkCCMe" type="checkbox" name="CkCCMe" style="vertical-align: middle;" />
                                                    </td>
                                                    <td width="65%" class="CheckboxLabels">
                                                        &nbsp;商机负责人 <span><b><%=ownRes?.name %></b></span>
                                                    </td>
                                                    <td width="1%" class="FieldLabels">
                                                       <input id="CkTerrTeam" type="checkbox" name="CkTerrTeam" style="vertical-align: middle;" />
                                                    </td>
                                                    <td width="34%" class="CheckboxLabels">
                                                        <span>区域团队</span>
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                       <span id="ServiceControlNotification_employeesLabel" class="lblNormalClass" style="font-weight: bold;">员工</span>
                                                                <span class="txtBlack8Class">(<a href="#" id="" onclick="LoadRes()">加载</a>)</span>
                                        <div>
                                                <input type="hidden" id="notifyResIds" name="notifyResIds" />
                                      <div class="InnerGrid" style="background-color: White; height: 180px; margin-right: -11px;">
                                                    <span id="ctrlNotification_dgEmployees" style="display: inline-block; height: 112px; width: 382px;float:left;"><span></span>
                                                        <div id="reshtml" style="width: 350px; height: 150px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                                                        </div>
                                                    </span>
                                                </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="pb">
                                    <td>
                                        <div>
                                            <table cellspacing="0" cellpadding="0" width="100%" class="FieldContainer">
                                                <tbody>
                                                <tr>
                                                    <td width="20%" class="FieldLabels">
                                                      其他邮件地址
                                                        <div>
                                                            <input name="notifyOthers" type="text" id="notifyOthers" class="txtBlack8Class" style="width: 523px;" />
                                                        </div>
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar WizardButtonBar" style="width:97%;">
            <ul>
                <!--上一层-->
                <li id="a2">
                    <a class="ImgLink">
                        <img class="ButtonImg" src="../Images/move-left.png">
                        <span class="Text">上一页</span>
                    </a>
                </li>
                <!--下一层-->
                <li class="right" id="b2">
                    <a class="ImgLink">
                        <span class="Text">下一页</span>
                        <img class="ButtonRightImg" src="../Images/move-right.png">
                    </a>
                </li>
                <!--完成-->
                <li class="right" style="display: none;" id="c2">
                    <a class="ImgLink">
                        <span class="Text">完成</span>
                    </a>
                </li>
                <!--关闭-->
                <li class="right" style="display: none;" id="d2">
                    <a class="ImgLink">
                        <img class="ButtonRightImg" src="../Images/cancel.png">
                        <span class="Text">关闭</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <!--第三页-->
    <div class="Workspace Workspace3" style="display: none;">
        <%--<div class="PageInstructions">Enter the subject and any additional message you would like for the notification.</div>--%>
        <div class="WizardSection">
            <table cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr height="85%">
                        <td width="90%">
                            <table cellspacing="1" cellpadding="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td class="FieldLabels">
                                            模板
                                            <div>
                                                <select name="notifyTempId" id="notifyTempId" class="txtBlack8Class" style="width: 524px;">
                                                                        <%if (tempList != null && tempList.Count > 0)
                                                                            {
                                                                                foreach (var temp in tempList)
                                                                                {  %>
                                                                        <option value="<%=temp.id %>"><%=temp.name %></option>
                                                                        <%
                                                                                }
                                                                            } %>
                                                                    </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabels">
                                            主题
                                            <div>
                                                  <span class="stretchTextBox" style="display: inline-block;">
                                                                    <input name="notifyTitle" type="text" value="" id="notifyTitle" class="txtBlack8Class" style="width: 523px;" /></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabels">
                                            其他文本
                                            <div>
                                                  <textarea name="notifyAppText" id="notifyAppText" class="txtBlack8Class" rows="3" style="width: 523px;"></textarea>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar WizardButtonBar" style="width:97%;">
            <ul>
                <!--上一层-->
                <li id="a3">
                    <a class="ImgLink">
                        <img class="ButtonImg" src="../Images/move-left.png">
                        <span class="Text">上一页</span>
                    </a>
                </li>
                <!--下一层-->
                <li class="right" id="b3">
                    <a class="ImgLink">
                        <span class="Text">下一页</span>
                        <img class="ButtonRightImg" src="../Images/move-right.png">
                    </a>
                </li>
                <!--完成-->
                <li class="right" style="display: none;" id="c3">
                    <a class="ImgLink">
                        <span class="Text">完成</span>
                    </a>
                </li>
                <!--关闭-->
                <li class="right" style="display: none;" id="d3">
                    <a class="ImgLink">
                        <img class="ButtonRightImg" src="../Images/cancel.png">
                        <span class="Text">关闭</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <!--第四页-->
    <div class="Workspace Workspace4" style="display: none;">
        <div class="PageInstructions">请回顾你在前面窗口做出的选择。如果一切都是正确的按下完成按钮或使用上一页按钮去做些改变.</div>
        <div class="WizardSection">
            <table cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr height="85%">
                        <td width="90%">
                            <table cellspacing="1" cellpadding="0" width="100%">
                                <tr>
                                    <td class="FieldLabels">
                                        即将进行的操作预览
                                        <div>
                                            <textarea rows="20" style="overflow-x:hidden; overflow-y: auto; width:98%; height: 480px; resize:none" id="ShowInformation" disabled="disabled"></textarea>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar WizardButtonBar" style="width:97%;">
            <ul>
                <!--上一层-->
                <li id="a4">
                    <a class="ImgLink">
                        <img class="ButtonImg" src="../Images/move-left.png">
                        <span class="Text">上一页</span>
                    </a>
                </li>
                <!--下一层-->
                <li style="display: none;" class="right" id="b4">
                    <a class="ImgLink">
                        <span class="Text">下一页</span>
                        <img class="ButtonRightImg" src="../Images/move-right.png">
                    </a>
                </li>
                <!--完成-->
                <li class="right" id="c4">
                    
                        <asp:Button ID="finish" runat="server" Text="结束" OnClick="finish_Click"  />
                 
                </li>
                <!--关闭-->
                <li class="right" style="display: none;" id="d4">
                    <a class="ImgLink">
                        <img class="ButtonRightImg" src="../Images/cancel.png">
                        <span class="Text">关闭</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <!--第五页-->
    <div class="Workspace Workspace5" style="display: none;">
      <div class="PageInstructions">您已成功丢失商机</div>
        <div class="WizardSection">
            <table cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                <tr height="85%">
                    <td width="90%">
                        <a onclick="window.open('OpportunityAddAndEdit.aspx?oppo_account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>','left=200,top=200,width=900,height=750', false);" >创建新商机</a>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar WizardButtonBar" style="width:97%;">
            <ul>
                <!--上一层-->
                <li style="display: none;" id="a5">
                    <a class="ImgLink">
                        <img class="ButtonImg" src="../Images/move-left.png">
                        <span class="Text">Back</span>
                    </a>
                </li>
                <!--下一层-->
                <li style="display: none;" class="right" id="b5">
                    <a class="ImgLink">
                        <span class="Text">Next</span>
                        <img class="ButtonRightImg" src="../Images/move-right.png">
                    </a>
                </li>
                <!--完成-->
                <li style="display: none;" class="right" id="c5">
                    <a class="ImgLink">
                        <span class="Text">Finish</span>
                    </a>
                </li>
                <!--关闭-->
                <li class="right" id="d5">
                    <a class="ImgLink">
                        <img class="ButtonRightImg" src="../Images/cancel.png">
                        <span class="Text">Close</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>





        

        
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<%--<script type="text/javascript" src="js/LostOpp.js"></script>--%>
<script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $("#opportunity_id").change(function () {
        var oid = $(this).val();
        var account_id = '<%=Request.QueryString["account_id"] %>';
        location.href = "LoseOpportunity?account_id=" + account_id + "&id=" + oid;
        });
    
    $("#b1").on("click", function () {

        var account_id = $("#account_id").val();
        if (account_id == "") {
            alert("客户信息丢失，请重新选择");
            return false;
        }
        // opportunity_id
        var opportunity_id = $("#opportunity_id").val();
        if (opportunity_id == 0) {
            alert("商机信息丢失，请重新选择");
            return false;
        }
        // stage_id
        var stage_id = $("#stage_id").val();
        if (stage_id == 0) {
            alert("请选择一个商机阶段");
            return false;
        }
        // resource_id
        var resource_id = $("#resource_id").val();
        if (resource_id == 0) {
            alert("请选择一个商机负责人");
            return false;
        }
        var lostTime = $("#lostTime").val();
        if (lostTime == "") {
            alert("请填写丢失时间");
            return false;
        }
        // 根据系统设置进行必填项校验
        if (<%=lostSetting.setting_value %> == <%=(int)EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE_DETAIL %>) // 根据系统设置决定是否校验
        {
           // loss_reason_type_id
            var loss_reason_type_id = $("#loss_reason_type_id").val();
            if (loss_reason_type_id == 0) {
                alert("请选择丢失商机原因");
                return false;
            }
            // loss_reason
            var loss_reason = $("#loss_reason").val();
            if (loss_reason == "") {
                alert("请填写丢失商机描述");
                return false;
            }
        }
        else if (<%=lostSetting.setting_value %> == <%=(int)EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE %>){
            var loss_reason_type_id = $("#loss_reason_type_id").val();
            if (loss_reason_type_id == 0) {
                alert("请选择丢失商机原因");
                return false;
            }
        }
        else {

        }
        $(".Workspace1").hide();
        $(".Workspace2").show();
    });
    $("#a2").on("click", function () {
        $(".Workspace1").show();
        $(".Workspace2").hide();
    });
    $("#b2").on("click", function () {
        $(".Workspace2").hide();
        $(".Workspace3").show();
        GetResIds();
    });
    $("#a3").on("click", function () {
        $(".Workspace2").show();
        $(".Workspace3").hide();
    });
    $("#b3").on("click", function () {
        $(".Workspace3").hide();
        $(".Workspace4").show();

        // $("#select_id").find("option:selected").text()
        var ShowInformation = "丢失商机时间:" + $("#lostTime").val() + "\r\n商机名称：" + $("#opportunity_id").find("option:selected").text() + "\r\n设置商机状态：" + $("#stage_id").find("option:selected").text() + "\r\n设置商机负责人：" + $("#resource_id").find("option:selected").text() + "\r\n设置主要产品：" + $("#productName").val() + "\r\n设置主要竞争对手：" + $("#competitor_id").find("option:selected").text() + "\r\n设计预计总收入：" + $("#total_revneue").val() + "\r\n商机状态设置为丢失\r\n通知对象：" ;
        $("#ShowInformation").html(ShowInformation);
    });
    $("#a4").on("click", function () {
        $(".Workspace3").show();
        $(".Workspace4").hide();
    });
    $("#c4").on("click", function () {
        //$(".Workspace4").hide();
        //$(".Workspace5").show();
    });
    $("#d5").on("click", function () {
        window.close();
    });
    $("#load111").on("click", function () {
        $(".grid").show();
    });
    $("#all").on("click", function () {
        if ($(this).is(":checked")) {
            $(".grid input[type=checkbox]").prop('checked', true);
        } else {
            $(".grid input[type=checkbox]").prop('checked', false);
        }
    });
</script>

<script>
    function chooseProduct() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CALLBACK %>&field=name", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function LoadRes() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ResourceAjax.ashx?act=GetResAndWorkGroup",
            success: function (data) {
                if (data != "") {
                    var resList = JSON.parse(data);
                    var resHtml = "";
                    resHtml += "<div class='grid' style='overflow: auto;height: 147px;'><table width='100%' border='0' cellspacing='0' cellpadding='3'><thead><tr><td width='1%'></td><td width='33%'>员工姓名</td ><td width='33%'>邮箱地址</td></tr ></thead ><tbody>";// <input type='checkbox' id='checkAll'/>
                    for (var i = 0; i < resList.length; i++) {
                        resHtml += "<tr><td><input type='checkbox' value='" + resList[i].id + "' class='" + resList[i].type + "' /></td><td>" + resList[i].name + "</td><td><a href='mailto:" + resList[i].email + "'>" + resList[i].email + "</a></td></tr>";
                    }
                    resHtml += "</tbody></table></div>";

                    $("#reshtml").html(resHtml);
                }
            },
        });
    }
    function GetResIds() {
        var ids = "";
        $(".checkRes").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ',';
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#notifyResIds").val(ids);
    }
</script>
