<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractEdit" EnableEventValidation="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>合同编辑</title>
  <link rel="stylesheet" href="../Content/reset.css" />
  <link rel="stylesheet" href="../Content/NewConfigurationItem.css" />
  <link rel="stylesheet" href="../Content/LostOpp.css"/>
</head>
<body style="overflow:auto;">
    <%="" %>
  <form id="form1" runat="server">
    <!--顶部-->
    <div class="TitleBar">
      <div class="Title">
        <span class="text1">合同编辑</span>
      </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
      <ul id="btn">
        <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
          <span class="Icon SaveAndClone"></span>
          <span class="Text">
            <asp:Button ID="SaveClose" runat="server" Text="保存并关闭" style="background: transparent;cursor: pointer;border: none;outline:none;"/></span>
        </li>
        <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
          <span class="Icon Cancel"></span>
          <span class="Text">取消</span>
        </li>
      </ul>
    </div>
    <!--切换按钮-->
    <div class="TabBar">
      <a class="Button ButtonIcon SelectedState">
        <span class="Text">常规信息</span>
      </a>
      <a class="Button ButtonIcon">
        <span class="Text">自定义信息</span>
      </a>
    </div>
    <!--切换项-->
    <div class="TabContainer">
        <div style="left: 0;overflow-x: auto;overflow-y: auto;position: fixed;right: 0;bottom: 0;top:120px;">
            <div class="DivScrollingContainer Tab" style="bottom:auto;">
        <div class="DivSectionWithHeader">
          <!--头部-->
          <div class="HeaderRow">
            <div class="Toggle Collapse Toggle1">
              <div class="Vertical"></div>
              <div class="Horizontal"></div>
            </div>
            <span class="lblNormalClass">常规信息</span>
          </div>
          <div class="Content">
            <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
              <tbody>
                <tr>
                  <td>
                    <div>
                      <table cellpadding="0" cellspacing="0" style="width: 100%;">
                        <tbody>
                          <tr>
                            <td class="FieldLabel">客户名称
                              <div>
                                <a class="ButtonIcon Link NormalState" style="cursor:pointer;" <%if (CheckAuth("CTT_CONTRACT_EDIT_VIEW_COMPANY")) { %> onclick="javascript:window.open('../Company/ViewCompany.aspx?type=todo&id=' + <%=contract.contract.account_id %>, '_blank', 'left=0,top=0,location=no,status=no,width=900,height=750', false);"<%} %> ><%=contract.accountName %></a>
                              </div>
                              <input type="hidden" name="id" value="<%=contract.contract.id %>" />
                            </td>
                            <td class="FieldLabel">合同状态
                              <div>
                                <span style="display: inline-block;">
                                  <select name="status_id" class="txtBlack8Class" style="width: 265px;">
                                    <option <%if (contract.contract.status_id == 1)
                                        { %>
                                      selected="selected" <%} %> value="1">激活</option>
                                    <option <%if (contract.contract.status_id == 0)
                                        { %>
                                      selected="selected" <%} %> value="0">未激活</option>
                                  </select>
                                </span>
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">合同类型
                              <div>
                                <%=contractTypeName %>
                              </div>
                            </td>
                            <td class="FieldLabel" style="width: 330px;">合同种类
                              <div>
                                <span style="display: inline-block;">
                                  <select name="cate_id" class="txtBlack8Class" style="width: 265px;">
                                    <option value=""></option>
                                    <%foreach (var cate in contractCate)
                                        {
                                    %>
                                    <option <%if (contract.contract.cate_id.ToString().Equals(cate.val))
                                        { %>
                                      selected="selected" <%} %> value="<%=cate.val %>"><%=cate.show %></option>
                                    <%
                                        } %>
                                  </select>
                                </span>
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">合同名称<span style="color: Red;">*</span>
                              <div>
                                <input type="text" id="name" name="name" style="width: 265px;" value="<%=contract.contract.name %>" />
                              </div>
                            </td>
                            <td class="FieldLabel" style="margin-left: 2px; margin-bottom: -3px;">联系人
                              <div>
                                <span style="display: inline-block;">
                                  <asp:DropDownList ID="contact_id" CssClass="txtBlack8Class" Width="265" runat="server"></asp:DropDownList>
                                </span>
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">合同描述
                              <div>
                                <textarea name="description" style="height: 90px; width: 265px; resize: vertical;"><%=contract.contract.description %></textarea>
                              </div>
                            </td>
                            <td class="FieldLabel" style="margin-left: 2px; margin-bottom: -3px;">商机
                              <div style="margin-bottom: 15px">
                                <span style="display: inline-block;">
                                  <asp:DropDownList ID="opportunity_id" CssClass="txtBlack8Class" Width="265" runat="server"></asp:DropDownList>
                                </span>
                              </div>
                              工时计费设置
                              <div>
                                <span style="display: inline-block;">
                                  <select name="bill_post_type_id" class="txtBlack8Class" style="width: 265px;">
                                    <%foreach (var bill in billPostType)
                                        {
                                    %>
                                    <option <%if (contract.contract.bill_post_type_id != null && contract.contract.bill_post_type_id.ToString().Equals(bill.val))
                                        { %>
                                      selected="selected" <%} %> value="<%=bill.val %>"><%=bill.show %></option>
                                    <%
                                        } %>
                                  </select>
                                </span>
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">外部合同号
                              <div>
                                <input type="text" name="external_no" style="width: 265px;" value="<%=contract.contract.external_no %>" />
                              </div>
                            </td>
                            <td class="FieldLabel">&nbsp;
                              <div>
                                <span style="display: inline-block;">
                                  <span class="txtBlack8Class">
                                    <input name="MastInput" type="checkbox" <%if (contract.contract.timeentry_need_begin_end == 1) { %> checked="checked" <% } %> style="vertical-align: middle;" />
                                    <label>要求工时输入开始/结束时间</label>
                                  </span>
                                </span>
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">服务等级协议
                              <div>
                                <span style="display: inline-block;">
                                  <select class="txtBlack8Class" name="sla_id" style="width: 280px;">
                                    <option value=""></option>
                                    <%foreach (var sla in slaList)
                                        {
                                    %>
                                    <option <%if (contract.contract.sla_id != null && contract.contract.sla_id.ToString().Equals(sla.id.ToString()))
                                        { %>
                                      selected="selected" <%} %> value="<%=sla.id %>"><%=sla.name %></option>
                                    <%
                                        } %>
                                  </select>
                                </span>
                              </div>
                            </td>
                            <td class="FieldLabel">&nbsp;
                              <div>
                                <span style="display: inline-block;">
                                  <span class="txtBlack8Class">
                                    <input type="checkbox" name="isSdtDefault" <%if (contract.contract.is_sdt_default == 1) { %> checked="checked" <% } %> style="vertical-align: middle;" />
                                    <label>默认服务台合同</label>
                                  </span>
                                </span>
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
          </div>
        </div>
        <div class="DivSectionWithHeader">
          <!--头部-->
          <div class="HeaderRow">
            <div class="Toggle Collapse Toggle2">
              <div class="Vertical"></div>
              <div class="Horizontal"></div>
            </div>
            <span class="lblNormalClass">日期和计费</span>
          </div>
          <%if (contract.contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) { %>
          <div class="Content">
            <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
              <tbody>
                <tr>
                  <td>
                    <div>
                      <table cellpadding="0" cellspacing="0" style="width: 100%;">
                        <tbody>
                          <tr>
                            <td class="FieldLabel">合同周期类型
                              <div>
                                <%if (contract.contract.period_type != null)
                                    { %><%=periodType.First(p=>p.val.Equals(contract.contract.period_type.ToString())).show %><%} %>
                              </div>
                            </td>
                            <td class="FieldLabel">初始费用
                              <div>
                                <span style="display: inline-block;">
                                  <input type="text" id="setup_fee" name="setup_fee" value="<%=contract.contract.setup_fee==null?"":decimal.Round((decimal)contract.contract.setup_fee,2).ToString() %>" />
                                </span>
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">开始日期
                              <div>
                                <input type="text" disabled="disabled" value="<%=contract.contract.start_date.ToString("yyyy-MM-dd") %>" onclick="WdatePicker()" class="Wdate" />
                              </div>
                            </td>
                            <td class="FieldLabel">初始费用计费代码
                              <div>
                                <input type="hidden" id="SetupCodeHidden" value="<%=contract.contract.setup_fee_cost_code_id %>" name="setup_fee_cost_code_id" />
                                <input type="text" id="SetupCode" readonly="readonly" <%if (contract.contract.setup_fee == null || contract.contract.setup_fee <= 0) { %> disabled="disabled" <%} %> value="<%=contract.costCode %>" style="width:265px;" />
                                <span style="display: inline-block">
                                  <img src="../Images/data-selector.png" id="CodeSelectImg" style="cursor: pointer; vertical-align: middle;" />
                                </span>
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">
                              <span style="display: inline-block; float: left; padding: 26px 0 0 0;">
                                <div style="vertical-align: middle">
                                  <input type="radio" onclick="getRadio(1)" value="1" name="date" <%if (contract.contract.occurrences == null) { %> checked="checked" <%} %> />
                                  结束日期
                                </div>
                              </span>
                              <span style="display: inline-block; float: left; padding-left: 90px; padding-top: 18px;">
                                <div>
                                  <input type="text" id="end_date" name="end_date" <%if (contract.contract.occurrences == null) { %> value="<%=contract.contract.end_date.ToString("yyyy-MM-dd") %>" <%}else{ %> disabled="disabled" <%} %> onclick="WdatePicker()" class="Wdate" />
                                </div>
                              </span>
                            </td>
                            <td class="FieldLabel">计费客户
                              <div>
                                <input type="hidden" id="companyNameHidden" name="bill_to_account_id" value="<%=contract.contract.bill_to_account_id %>" />
                                <input type="text" style="width: 265px;" id="companyName" disabled="disabled" value="<%=contract.billToAccount %>" />
                                <span style="display: inline-block">
                                  <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=companyName&callBack=InitContact', '<%=EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false)" style="cursor: pointer; vertical-align: middle;" /></span>
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">
                              <span style="display: inline-block; float: left; padding: 26px 0 0 0;">
                                <div style="vertical-align: middle">
                                  <input type="radio" onclick="getRadio(2)" value="0" name="date" <%if (contract.contract.occurrences != null) { %> checked="checked" <%} %> />
                                  结束于(服务周期)
                                </div>
                              </span>
                              <span style="display: inline-block; float: left; padding-left: 45px; padding-top: 18px;">
                                <div>
                                  <input type="text" id="occurrences" name="occurrences" <%if (contract.contract.occurrences != null) { %> value="<%=contract.contract.occurrences %>" <%} else{%>  disabled="disabled" <%} %> />
                                </div>
                              </span>
                            </td>
                            <td class="FieldLabel">合同通知联系人
                              <div>
                                <asp:DropDownList ID="bill_to_contact_id" CssClass="txtBlack8Class" Width="265" runat="server"></asp:DropDownList>
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">采购订单号
                              <div>
                                <input type="text" name="purchase_order_no" style="width: 265px;" value="<%=contract.contract.purchase_order_no %>" />
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">预估收入
                              <div>
                                <input type="text" style="width: 130px;" disabled="disabled" value="<%=contract.contract.dollars %>" />
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
          </div>
          <%} else { %>
          <div class="Content">
            <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
              <tbody>
                <tr>
                  <td>
                    <div>
                      <table cellpadding="0" cellspacing="0" style="width: 100%;">
                        <tbody>
                          <tr>
                            <td class="FieldLabel">开始日期<span style="color: Red;">*</span>
                              <div>
                                <input type="text" name="start_date" value="<%=contract.contract.start_date.ToString("yyyy-MM-dd") %>" onclick="WdatePicker()" class="Wdate" />
                              </div>
                            </td>
                            <td class="FieldLabel">结束日期<span style="color: Red;">*</span>
                              <div>
                                <input type="text" name="end_date" id="endDate" value="<%=contract.contract.end_date.ToString("yyyy-MM-dd") %>" onclick="WdatePicker()" class="Wdate" />
                              </div>
                            </td>
                            <td class="FieldLabel">计费客户
                              <div>
                                <input type="hidden" id="companyNameHidden" name="bill_to_account_id" value="<%=contract.contract.bill_to_account_id %>" />
                                <input type="text" style="width: 265px;" id="companyName" disabled="disabled" value="<%=contract.billToAccount %>" />
                                <span style="display: inline-block">
                                  <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=companyName&callBack=InitContact', '<%=EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false)" style="cursor: pointer; vertical-align: middle;" /></span>
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">采购订单号
                              <div>
                                <input type="text" name="purchase_order_no" style="width: 265px;" value="<%=contract.contract.purchase_order_no %>" />
                              </div>
                            </td>
                            <td class="FieldLabel">合同通知联系人
                              <div>
                                <asp:DropDownList ID="bill_to_contact_id1" CssClass="txtBlack8Class" Width="265" runat="server"></asp:DropDownList>
                              </div>
                            </td>
                          </tr>
                          <tr>
                            <td class="FieldLabel">预估收入
                              <div>
                                <input type="text" style="width: 130px;" name="dollars" value="<%=contract.contract.dollars %>" />
                              </div>
                            </td>
                            <td class="FieldLabel">预估成本
                              <div>
                                <input type="text" style="width: 130px;" name="cost" value="<%=contract.contract.cost %>" />
                              </div>
                            </td>
                            <%if (contract.contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS) { %>
                            <td class="FieldLabel">&nbsp;
                              <div>
                                <span style="display: inline-block;">
                                  <span class="txtBlack8Class">
                                    <input type="checkbox" name="isEnableOrverage" <%if (contract.contract.enable_overage_billing_rate != null && contract.contract.enable_overage_billing_rate == 1) { %> checked="checked" <%} %> style="vertical-align: middle;" />
                                    <label>支持超支费率</label>
                                  </span>
                                </span>
                              </div>
                            </td>
                            <%} else if (contract.contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) { %>
                            <td class="FieldLabel">超额计费率
                              <div>
                                <input type="text" style="width: 130px;" name="overage_billing_rate" value="<%=contract.contract.overage_billing_rate %>" />
                              </div>
                            </td>
                            <%}%>
                          </tr>
                          <tr>
                            <td class="FieldLabel">预估工时
                              <div>
                                <input type="text" style="width: 130px;" name="hours" value="<%=contract.contract.hours %>" />
                              </div>
                            </td>
                            <%if (contract.contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS) { %>
                            <td class="FieldLabel">超额计费率
                              <div>
                                <input type="text" style="width: 130px;" name="overage_billing_rate" value="<%=contract.contract.overage_billing_rate %>" />
                              </div>
                            </td>
                            <%} %>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <%} %>
        </div>
      </div>
        </div>
    </div>
    <div class="TabContainer" style="display: none;">
        <div style="left: 0;overflow-x: auto;overflow-y: auto;position: fixed;right: 0;bottom: 0;top:120px;">
            <div class="DivScrollingContainer Tab" style="position:initial;">
        <div class="DivSectionWithHeader">
          <!--头部-->
          <div class="HeaderRow">
            <div class="Toggle Collapse Toggle1">
              <div class="Vertical"></div>
              <div class="Horizontal"></div>
            </div>
            <span class="lblNormalClass">用户自定义</span>
          </div>
          <div class="WizardSection">
              <table cellspacing="0" cellpadding="0" width="100%" class="Searchareaborder">
                  <tbody>
                      <tr>
                          <td align="center">
                              <table  cellspacing="1" cellpadding="0" width="100%">
                                  <tbody>
                                    <%
                                        bool canEdit = false;
                                        bool canView = false;
                                        bool editP = CheckAuth("EDIT_CONTRACT_PROTECT_UDF");
                                        bool editUP = CheckAuth("EDIT_CONTRACT_UNPROTECT_UDF");
                                        bool viewP = CheckAuth("VIEW_CONTRACT_PROTECT_UDF");
                                        bool viewUP = CheckAuth("VIEW_CONTRACT_UNPROTECT_UDF");
                                            %>
                                      <% if (udfList != null && udfList.Count > 0)
                                          {
                                              foreach (var udf in udfList)
                                              {
                                                  if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                                  {%>
                                      <tr>
                                          <td valign="top" class="FieldLabels">
                                              <%=udf.name %>
                                              <div>
                                                <%
                                              canEdit = false;
                                              canView = false;
                                              if (udf.is_protected==1 && editP)
                                                canEdit = true;
                                              if (udf.is_protected==1 && viewP)
                                                canView = true;
                                              if (udf.is_protected==0 && editUP)
                                                canEdit = true;
                                              if (udf.is_protected==0 && viewUP)
                                                canView = true;
                                              %>
                                                <%if (!canView) { %>
                                              <input type="hidden" name="<%=udf.id %>" value="<%=udfValues.FirstOrDefault(_ => _.id == udf.id).value %>" />
                                              <input type="text" readonly="readonly" value="****" />
                                              <%} else { %>
                                              <input type="text" name="<%=udf.id %>" class="sl_cdt" <%if (!canEdit) { %> readonly="readonly" <%} %> value="<%=udfValues.FirstOrDefault(_=>_.id==udf.id).value %>" />
                                              <%} %>
                                              </div>
                                          </td>
                                      </tr>
                                      <%}
                                          else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                                          {%>
                                      <tr>
                                          <td valign="top" class="FieldLabels">
                                              <label><%=udf.name %></label>
                                            <%
                                            canEdit = false;
                                            canView = false;
                                            if (udf.is_protected==1 && editP)
                                              canEdit = true;
                                            if (udf.is_protected==1 && viewP)
                                              canView = true;
                                            if (udf.is_protected==0 && editUP)
                                              canEdit = true;
                                            if (udf.is_protected==0 && viewUP)
                                              canView = true;
                                            %>
                                            <%if (!canView) { %>
                                              <input type="hidden" name="<%=udf.id %>" value="<%=udfValues.FirstOrDefault(_ => _.id == udf.id).value %>" />
                                            <textarea readonly="readonly" rows="2" cols="20">****</textarea>
                                              <%} else { %>
                                            <textarea name="<%=udf.id %>" rows="2" <%if (!canEdit) { %> readonly="readonly" <%} %> cols="20"><%=udfValues.FirstOrDefault(_=>_.id==udf.id).value %></textarea>
                                              <%} %>
                                          </td>
                                      </tr>
                                      <%}
                                          else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                                          {%><tr>
                                              <td valign="top" class="FieldLabels">
                                                  <label><%=udf.name %></label>
                                                  <div>
                                                    <%
                                                    canEdit = false;
                                                    canView = false;
                                                    if (udf.is_protected==1 && editP)
                                                      canEdit = true;
                                                    if (udf.is_protected==1 && viewP)
                                                      canView = true;
                                                    if (udf.is_protected==0 && editUP)
                                                      canEdit = true;
                                                    if (udf.is_protected==0 && viewUP)
                                                      canView = true;
                                                    %>
                                                    <%
                                                        object value = udfValues.FirstOrDefault(_ => _.id == udf.id).value;
                                                        string val = "";
                                                        if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                                            val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                                        %>
                                                    <%if (!canView) { %>
                                              <input type="hidden" name="<%=udf.id %>" value="<%=udfValues.FirstOrDefault(_ => _.id == udf.id).value %>" />
                                              <input type="text" class="sl_cdt Wdate" readonly="readonly" value="****" />
                                              <%} else { %>
                                              <input type="text" name="<%=udf.id %>" class="sl_cdt Wdate" <%if (!canEdit) { %> readonly="readonly" <%} else { %> onclick="WdatePicker()" <%} %> value="<%=val %>" />
                                              <%} %>
                                                  </div>
                                              </td>
                                          </tr>
                                      <%}
                                          else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                                          {%>
                                      <tr>
                                          <td valign="top" class="FieldLabels">
                                              <label><%=udf.name %></label>
                                            <%
                                            canEdit = false;
                                            canView = false;
                                            if (udf.is_protected==1 && editP)
                                              canEdit = true;
                                            if (udf.is_protected==1 && viewP)
                                              canView = true;
                                            if (udf.is_protected==0 && editUP)
                                              canEdit = true;
                                            if (udf.is_protected==0 && viewUP)
                                              canView = true;
                                            %>
                                            <%if (!canView) { %>
                                              <input type="hidden" name="<%=udf.id %>" value="<%=udfValues.FirstOrDefault(_ => _.id == udf.id).value %>" />
                                              <input type="text" readonly="readonly" value="****" />
                                              <%} else { %>
                                              <input type="text" name="<%=udf.id %>" class="sl_cdt" <%if (!canEdit) { %> readonly="readonly" <%} else { %>  maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" <%} %> value="<%=udfValues.FirstOrDefault(_=>_.id==udf.id).value %>" />
                                              <%} %>
                                          </td>
                                      </tr>
                                      <%}
                                          else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                                          {%>

                                      <%}
                                              }
                                          } %>
                                  </tbody>
                              </table>
                          </td>
                      </tr>
                  </tbody>
              </table>
          </div>
          
        </div>
      </div>
        </div>
    </div>
  </form>
  <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
  <script src="../Scripts/common.js"></script>
  <script type="text/javascript" src="../Scripts/NewConfigurationItem.js"></script>
  <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
  <script type="text/javascript">
      $("#SaveAndCloneButton").click(function () {
          if ($("#name").val() == "") {
              alert("请输入合同名称");
              return;
          }
          <%if (contract.contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) {
          if (!string.IsNullOrEmpty(endTimeCheck)) { %>
          if ($("#endDate").val() != "" && compareTime('<%=contract.contract.end_date.ToString("yyyy-MM-dd") %>', $("#endDate").val())) {
              alert("结束时间不能早于已审批并提交的服务结束时间");
              return;
          }
      <%}
      }%>
          <%if (contract.contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) { %>
          if (compareTime('<%=contract.contract.end_date.ToString("yyyy-MM-dd") %>', $("#endDate").val())) {
              alert("结束时间不能向前修改");
              return;
          }
      <%}%>
          $("#form1").submit();
      })
    $("#CancelButton").on("click", function () {
      window.close();
    });
    function getRadio(index) {
      if (index == 1) {
        $("#occurrences").attr("disabled", "disabled");
        $("#end_date").removeAttr("disabled");
      } else if (index == 2) {
        $("#end_date").attr("disabled", "disabled");
        $("#occurrences").removeAttr("disabled");
      }
    }
    function InitContact() {
      $.ajax({
        type: "GET",
        url: "../Tools/CompanyAjax.ashx?act=contactList&account_id=" + $("#companyNameHidden").val(),
        success: function (data) {
          if (data != "") {
            if ($("#bill_to_contact_id").length != 0)
              $("#bill_to_contact_id").html(data).removeAttr("disabled");
            else if ($("#bill_to_contact_id1").length != 0)
              $("#bill_to_contact_id1").html(data).removeAttr("disabled");
          }
        },
      });
    }

    <% if (contract.contract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) { %>
    window.onload = function () {
      var fee = parseFloat($("#setup_fee").val());
      if (!(isNaN($("#setup_fee").val()) || fee <= 0)) {
        $("#CodeSelectImg").click(function () {
          window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&field=SetupCode&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RECURRING_CONTRACT_SERVICE_CODE %>', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.BillCodeCallback %>', 'left=200,top=200,width=600,height=800', false)
        })
      }
    }
    $("#setup_fee").change(function () {
      var fee = parseFloat($("#setup_fee").val());
      if (isNaN($("#setup_fee").val()) || fee <= 0) {
        $("#CodeSelectImg").unbind('click');
        $("#SetupCode").attr("disabled", true);
      } else {
        $("#SetupCode").attr("disabled", false);
        $("#CodeSelectImg").click(function () {
          window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&field=SetupCode&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RECURRING_CONTRACT_SERVICE_CODE %>', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.BillCodeCallback %>', 'left=200,top=200,width=600,height=800', false)
            })
          }
    })
    <%}%>
  </script>
</body>
</html>
