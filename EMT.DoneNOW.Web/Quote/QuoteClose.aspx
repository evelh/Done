<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteClose.aspx.cs" Inherits="EMT.DoneNOW.Web.Quote.QuoteClose" ValidateRequest="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>关闭报价</title>
  <style>
    body {
      overflow: hidden;
    }
    /*顶部内容和帮助*/
    .TitleBar {
      color: #fff;
      background-color: #346a95;
      display: block;
      font-size: 15px;
      font-weight: bold;
      height: 36px;
      line-height: 38px;
      margin: 0 0 10px 0;
    }

      .TitleBar > .Title {
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

    .help {
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
    .ButtonContainer {
      padding: 0 10px 10px 10px;
      width: auto;
      height: 26px;
    }

      .ButtonContainer ul li .Button {
        margin-right: 5px;
        vertical-align: top;
      }

    li.Button {
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

    .Button > .Icon {
      display: inline-block;
      flex: 0 0 auto;
      height: 16px;
      margin: 0 3px;
      width: 16px;
    }

    .Save, .SaveAndClone, .SaveAndNew {
      background-image: url("../Images/save.png");
    }

    .Ok {
      background-image: url("../Images/ok.png");
    }

    .Cancel {
      background-image: url("../Images/cancel.png");
    }

    .Tools {
      background-image: url("../Images/dropdown.png");
    }

    .Add {
      background-image: url("../Images/add.png");
    }

    .Print {
      background-image: url("../Images/print.png");
    }

    .Button > .Text {
      flex: 0 1 auto;
      font-size: 12px;
      font-weight: bold;
      overflow: hidden;
      padding: 0 3px;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    /*每一页*/
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

      .FieldLabels img {
        cursor: pointer;
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

    input[type=checkbox] {
      vertical-align: middle;
      cursor: pointer;
      padding: 0;
      margin: 0 3px 0 0;
    }

    #txtBlack8 {
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
      bottom: 10px;
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

    .contentButton {
      line-height: 22px;
    }

      .ButtonBar ul li a, .ButtonBar ul li a:visited, .contentButton a, .contentButton a:link, .contentButton a:visited, a.buttons, input.button, .ButtonBar ul li a:visited {
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

      .grid tbody tr td:last-child, .grid tfoot tr td:last-child {
        border-right-color: #98b4ca;
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

    .sectionBluebg {
      color: #4F4F4F;
      font-weight: bold;
      padding-left: 0;
      height: 20px;
      vertical-align: middle;
      width: auto;
      margin-bottom: 0;
      font-size: 12px;
    }

    a.PrimaryLink {
      color: #376597;
      text-decoration: none;
      font-size: 12px;
      cursor: pointer;
    }
    /*第二页*/
    .DivSectionWithHeader {
      border: 1px solid #d3d3d3;
      margin: 0 10px 10px 10px;
      padding: 4px 0 4px 0;
    }

      .DivSectionWithHeader > .Heading {
        overflow: hidden;
        padding: 2px 4px 8px 6px;
        position: relative;
        text-overflow: ellipsis;
        white-space: nowrap;
      }

        .DivSectionWithHeader > .Heading > .Text {
          color: #666;
          height: 16px;
          font-size: 12px;
          font-weight: bold;
          line-height: 17px;
          text-transform: uppercase;
        }

      .DivSectionWithHeader .Content {
        padding: 12px 28px 4px 28px;
      }

      .DivSectionWithHeader td {
        padding: 0;
        text-align: left;
      }

    .CheckboxLabels, .workspace .CheckboxLabels, div[class="checkbox"] span, div[class="radio"] span {
      font-size: 12px;
      color: #333;
      font-weight: normal;
      vertical-align: middle;
    }

    .NoSection {
      padding-left: 10px;
    }

      .NoSection div {
        padding-bottom: 21px;
      }

    .FieldLevelInstructions {
      font-size: 11px;
      color: #666;
      line-height: 16px;
      font-weight: normal;
    }
  </style>
</head>
<body>
  <form id="form1" runat="server">
    <div class="TitleBar">
      <div class="Title">
        <span class="text1">关闭报价</span>
        <a href="###" class="help"></a>
      </div>
    </div>
    <!--第一页-->
    <div class="Workspace Workspace1">
      <div class="PageInstructions" style="padding-bottom: 10px;">
        此向导将会把产品、一次性折扣、配送、成本转为计费项。可选项和费用不会被转换。如果有产品，会生成销售订单。报价中如果有服务/包或初始费用，将不会被转换为计费项，也不会创建定期服务合同。如果商机状态已经是“关闭”或“已实施”，将会为此商机生成重复的计费项。
      </div>
      <%if (serviceItem != null && serviceItem.Count > 0)
          { %>
      <div class="PageInstructions" style="padding-bottom: 10px;">
        此报价包含服务、服务包或初始费用。如果继续，则不会转换这些报价项，也不会创建定期服务合同。如果您想将服务、服务包或初始费用转换为定期服务合同，请使用
            <a onclick="window.open('../Opportunity/CloseOpportunity.aspx?id=<%=opportunity.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityClose %>','left=200,top=200,width=900,height=750', false);">关闭商机向导</a>
      </div>
      <%} %>
      <%  if (wonSetting.setting_value != ((int)EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE).ToString())
          { %>
      <div class="PageInstructions">请选择关闭商机的原因.</div>
      <%} %>
      <div class="WizardSection">
        <table cellspacing="0" cellpadding="0" width="100%">
          <tbody>
            <tr height="85%">
              <td width="90%" valign="top">
                <!--第一页主体-->
                <table cellspacing="0" cellpadding="0" width="100%">
                  <tbody>
                    <%if (wonSetting.setting_value != ((int)EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_NONE).ToString())
                        {%>
                    <tr>
                      <td width="55%" class="FieldLabels">赢得商机原因<span class="errorSmall">*</span>
                        <div>
                          <asp:DropDownList ID="win_reason_type_id" runat="server" Width="320px"></asp:DropDownList>
                        </div>
                      </td>
                    </tr>
                    <%  if (wonSetting.setting_value != ((int)EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE).ToString())
                        { %>
                    <tr>
                      <td rowspan="3" class="FieldLabels" style="vertical-align: top;">原因描述  <span class="errorSmall">*</span>
                        <div>
                          <textarea style="width: 278px; height: 160px;" name="win_reason" id="win_reason"><%=opportunity==null?"":opportunity.win_reason %></textarea>
                        </div>
                      </td>

                    </tr>

                    <%}
                        } %>
                  </tbody>
                </table>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="ButtonBar WizardButtonBar" style="width: 97%;">
        <ul>
          <!--上一层-->
          <li style="display: none;" id="a1">
            <a class="ImgLink">
              <img class="ButtonImg" src="../Images/move-left.png">
              <span class="Text">上一页</span>
            </a>
          </li>
          <!--下一层-->
          <li class="right" id="b1">
            <a class="ImgLink">
              <span class="Text">下一页</span>
              <img class="ButtonRightImg" src="../Images/move-right.png">
            </a>
          </li>
          <!--完成-->
          <li class="right" style="display: none;" id="c1">
            <a class="ImgLink">
              <span class="Text">Finish</span>
            </a>
          </li>
          <!--关闭-->
          <li class="right" style="display: none;" id="d1">
            <a class="ImgLink">
              <img class="ButtonRightImg" src="../Images/cancel.png">
              <span class="Text">Close</span>
            </a>
          </li>
        </ul>
      </div>
    </div>
    <input type="hidden" id="codeSelect" runat="server" />
    <input type="hidden" id="disCodeSelct" runat="server" />
    <input type="hidden" id="jqueryCode" runat="server" />
    <!--第二页-->
    <div class="Workspace Workspace2" style="display: none;">
      <div class="PageInstructions">请将这些配置项与下面的物料代码相匹配。</div>
      <div class="WizardSection">
        <table cellspacing="0" cellpadding="0" width="100%">
          <tbody>
            <tr>
              <td colspan="9" valign="top">
                <table cellspacing="0" cellpadding="0" width="100%">
                  <tbody>
                    <tr>
                      <td colspan="1" id="txtBlack8">
                        <div class="DivScrollingContainer" style="top: 1px; margin-right: 10px;">
                          <div class="grid" style="margin-right: 1px;">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
                              <thead>
                                <tr>
                                  <td style="text-align: left; padding-left: 5px;">Quote Item Name</td>
                                  <td align="right" style="width: 100px;">Quantity</td>
                                  <td align="left" style="width: 150px;">Material Code</td>
                                </tr>
                              </thead>
                              <tbody>
                                <%
                                    if (quoteItemList != null && quoteItemList.Count > 0)
                                    {
                                      foreach (var item in quoteItemList)
                                      {%>
                                <tr>

                                  <td nowrap><%=item.name %></td>
                                  <td nowrap align="right"><%=item.quantity %></td>
                                  <td nowrap align="left">
                                    <%if (item.type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT)
                                        { %>
                                    <select class="ChooseCostCoseSelect" name="<%=item.id %>_select" id="<%=item.id %>_select" style="width: 120px;">
                                    </select>
                                    <%}
                                        else
                                        { %>
                                    <select class="ChooseDiscountCostCoseSelect" name="<%=item.id %>_select" id="<%=item.id %>_select" style="width: 120px;">
                                    </select>
                                    <%} %>
                                  </td>
                                </tr>
                                <%}
                                    }
                                %>
                              </tbody>
                            </table>
                          </div>
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
      <div class="ButtonBar WizardButtonBar" style="width: 97%;">
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
              <span class="Text">Finish</span>
            </a>
          </li>
          <!--关闭-->
          <li class="right" style="display: none;" id="d2">
            <a class="ImgLink">
              <img class="ButtonRightImg" src="../Images/cancel.png">
              <span class="Text">Close</span>
            </a>
          </li>
        </ul>
      </div>
    </div>
    <!--第三页-->
    <div class="Workspace Workspace3" style="display: none;">
      <div class="PageInstructions">计费项将会生成，是否需要创建发票</div>
      <div class="WizardSection">
        <table cellspacing="0" cellpadding="0" width="100%">
          <tbody>
            <tr height="85%">
              <td width="90%">
                <table cellspacing="1" cellpadding="0" width="100%">
                  <tbody>
                    <tr>
                      <td class="FieldLabels">
                        <div>
                          <asp:RadioButton ID="add" GroupName="ApproveAndPostType" Checked="true" runat="server" />
                        <%--  <input type="radio" checked name="ApproveAndPostType" runat="server" id="add" />--%>
                          <label style="font-weight: normal">
                            是的，创建发票
                          </label>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td class="FieldLabels">
                        <div>
                          <asp:RadioButton ID="No" runat="server" GroupName="ApproveAndPostType"  />
                          <%--<input type="radio" name="ApproveAndPostType" runat="server" id="No" />--%>
                          <label style="font-weight: normal">
                            否，不用创建发票
                          </label>
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
      <div class="ButtonBar WizardButtonBar" style="width: 97%;">
        <ul>
          <!--上一层-->
          <li id="a3">
            <a class="ImgLink">
              <img class="ButtonImg" src="../Images/move-left.png">
              <span class="Text">上一页</span>
            </a>
          </li>
          <!--下一层-->
          <li class="right" style="display: none;" id="b3">
            <a class="ImgLink">
              <span class="Text">下一页</span>
              <img class="ButtonRightImg" src="../Images/move-right.png">
            </a>
          </li>
          <!--完成-->
          <li class="right" id="c3">
            <a class="ImgLink">
              <span class="Text">
                <asp:Button ID="finish" runat="server" Text="完成" OnClick="finish_Click" BorderStyle="None" /></span>
            </a>
          </li>
          <!--关闭-->
          <li class="right" style="display: none;" id="d3">
            <a class="ImgLink">
              <img class="ButtonRightImg" src="../Images/cancel.png">
              <span class="Text">Close</span>
            </a>
          </li>
        </ul>
      </div>
    </div>
    <!--第四页-->
    <div class="Workspace Workspace4" style="display: none;">
      <div class="PageInstructions">向导已完成，计费项已生成</div>
      <div class="WizardSection">
        <table cellspacing="0" cellpadding="0" width="100%">
          <tbody>
            <tr height="85%">
              <td width="90%">
                <div class="ShowSaleOrder" style="display:none;">
                   <a id="OpenSaleOrder" onclick="OpenSaleOrder()">打开新建的销售订单</a>
                  <input type="hidden" id="newSaleOrderId"/>
                </div>
               
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="ButtonBar WizardButtonBar" style="width: 97%;">
        <ul>
          <!--上一层-->
          <li style="display: none;" id="a4">
            <a class="ImgLink">
              <img class="ButtonImg" src="../Images/move-left.png">
              <span class="Text">Back</span>
            </a>
          </li>
          <!--下一层-->
          <li style="display: none;" class="right" id="b4">
            <a class="ImgLink">
              <span class="Text">Next</span>
              <img class="ButtonRightImg" src="../Images/move-right.png">
            </a>
          </li>
          <!--完成-->
          <li style="display: none;" class="right" id="c4">
            <a class="ImgLink">
              <span class="Text">Finish</span>
            </a>
          </li>
          <!--关闭-->
          <li class="right" id="d4">
            <a class="ImgLink">
              <img class="ButtonRightImg" src="../Images/cancel.png">
              <span class="Text">关闭</span>
            </a>
          </li>
        </ul>
      </div>
    </div>

  </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
  $("#b1").on("click", function () {

    if (<%=wonSetting.setting_value %> == <%=(int)EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE_DETAIL %>) // 根据系统设置决定是否校验
    {

      var win_reason_type_id = $("#win_reason_type_id").val();
      if (win_reason_type_id == 0) {
        alert("请选择关闭商机原因");
        return false;
      }

      var win_reason = $("#win_reason").val();
      if (win_reason == "") {
        alert("请填写关闭商机描述");
        return false;
      }
    }
    else if (<%=wonSetting.setting_value %> == <%=(int)EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE %>){
    var win_reason_type_id = $("#win_reason_type_id").val();
    if (win_reason_type_id == 0) {
      alert("请选择关闭商机原因");
      return false;
    }
  }


    $(".Workspace1").hide();
    <% if (quoteItemList != null && quoteItemList.Count > 0)
    { %>
    $(".Workspace2").show();
    <%}
    else
    {%>
    $(".Workspace3").show();
    <%}%>
  
   
  });
  $("#a2").on("click", function () {
    $(".Workspace1").show();
    $(".Workspace2").hide();
  });
  $("#b2").on("click", function () {
    var isTrans = "";
    $(".ChooseCostCoseSelect").each(function () {
      // debugger;
      //if ($(this).parent().parent().css('display') == 'none') {
      //  return true;
      //}
      var thisValue = $(this).val();
      if (thisValue == 0) {
        isTrans += thisValue;
      }
    })

    $(".ChooseDiscountCostCoseSelect").each(function () {
      //debugger;
      //if ($(this).parent().parent().css('display') == 'none') {
      //  return true;
      //}
      var thisValue = $(this).val();
      if (thisValue == 0) {
        isTrans += thisValue;
      }
    })

    if (isTrans != "") {
      alert("你还有报价项未选择物料代码");

      return false;
    }
    $(".Workspace2").hide();
    $(".Workspace3").show();
  });
  $("#a3").on("click", function () {
      <% if (quoteItemList != null && quoteItemList.Count > 0)
    { %>
    $(".Workspace2").show();
    <%}
    else
    {%>
    $(".Workspace1").show();
    <%}%>
   
    $(".Workspace3").hide();
  });
  $("#c3").on("click", function () {

    //$(".Workspace3").hide();
    //$(".Workspace4").show();
  });
  $("#d4").on("click", function () {
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
  $(function () {
    $(".ChooseCostCoseSelect").html($("#codeSelect").val());
    eval($("#jqueryCode").val());
    $(".ChooseDiscountCostCoseSelect").html($("#disCodeSelct").val());
  })

  function OpenSaleOrder() {
    var newSaleOrderId = $("#newSaleOrderId").val();
    if (newSaleOrderId != "") {
      window.open("../SaleOrder/SaleOrderView.aspx?id=" + newSaleOrderId, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SaleOrderView %>', 'left=200,top=200,width=600,height=800', false);
    }
  }
</script>
