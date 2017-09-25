<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractAdd.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractAdd" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>合同向导</title>
    <link rel="stylesheet" href="../Content/reset.css"/>
    <link rel="stylesheet" href="../Content/LostOpp.css"/>
</head>
<body>
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">合同向导<%if (!string.IsNullOrEmpty(contractTypeName)) { %>(<%=contractTypeName %>)<%} %></span>
        </div>
    </div>
    <form id="form1" runat="server">
        <!--第零页 选择合同类型-->
        <div class="Workspace Workspace0" style="display: none;">
            <div class="PageInstructions">Please provide type information for the new contract. The contract type cannot be changed once the contract is created.</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                    <tr height="85%">
                        <td width="90%">
                            <table cellspacing="1" cellpadding="0" width="100%">
                                <tr>
                                    <td class="FieldLabels">
                                        合同类型
                                        <div style="position:relative; visibility:visible; display:block;width:100%;">
                                            <select id="typeSelect" style="width:190px;">
                                                <option value="">--请选择--</option>
                                                <option value="1199">定期服务合同</option>
                                                <option value="1200">工时及物料合同</option>
                                                <option value="1201">固定价格合同</option>
                                                <option value="1202">预付时间合同</option>
                                                <option value="1203">预付费合同</option>
                                                <option value="1204">事件合同</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <!--第一页 填基本信息-->
        <div class="Workspace Workspace1" style="display: none;">
            <div class="PageInstructions">请为新合同录入开始日期和结束日期等信息。</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%" valign="top">
                                <!--第一页主体-->
                                <table cellspacing="0" cellpadding="0" width="100%" style="min-width: 722px;">
                                    <tbody>
                                        <tr>
                                            <td class="FieldLabels">
                                                合同名称<span class="errorSmall">*</span>
                                                <div>
                                                    <input type="text" id="name" name="name" style="width: 278px; margin-right: 4px;"/>
                                                </div>
                                            </td>
                                            <td class="FieldLabels">
                                                合同描述
                                                <div>
                                                    <input type="text" name="description" style="width: 342px;"/>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                公司名称<span class="errorSmall">*</span>
                                                <div>
                                                    <input type="text" id="companyName" disabled="disabled" style="width: 278px;" />
                                                    <input type="hidden" id="companyNameHidden" name="account_id" />
                                                    <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=companyName&callBack=InitContact', '<%=EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false)" style="vertical-align: middle;cursor: pointer;" />
                                                </div>
                                            </td>
                                            <td class="FieldLabels">
                                                合同种类
                                                <div>
                                                    <select id="cateSelect" name="cate_id" class="step2LeftSelectWidth" style="width:356px;">
                                                        <option value="">--请选择--</option>
                                                        <%foreach (var cate in contractCate) {
                                                                %>
                                                        <option value="<%=cate.val %>"><%=cate.show %></option>
                                                        <%
                                                            } %>
                                                    </select>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                <asp:CheckBox ID="is_sdt_default" runat="server" />
                                                <%--<input type="checkbox" name="is_sdt_default" />--%>
                                                <span>默认服务台合同</span>
                                            </td>
                                            <td class="FieldLabels">
                                                <div>
                                                    <table style="padding:0px;margin:0px; border:0px; border-spacing:0px;">
                                                        <tbody>
                                                            <tr>
                                                                <td class="FieldLabels">
                                                                    外部合同号
                                                                    <br/>
                                                                    <input type="text" name="external_no" style="width: 155px;"/>
                                                                </td>
                                                                <td class="FieldLabels" style=" padding-left :16px;">
                                                                    采购订单号
                                                                    <br/>
                                                                    <input type="text" name="purchase_order_no" style="width: 156px;"/>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                     </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                联系人
                                                <div>
                                                    <select id="contactSelect" name="contact_id" disabled="disabled" class="step2LeftSelectWidth" style="width:134px;">
                                                        <option value=""></option>
                                                    </select>
                                                </div>
                                            </td>
                                            <td class="FieldLabels">
                                                服务等级协议
                                                <div>
                                                    <select id="slaSelect" name="sla_id" style="width:356px;">
                                                        <option value=""></option>
                                                        <%foreach (var sla in slaList) {
                                                                %>
                                                        <option value="<%=sla.id %>"><%=sla.name %></option>
                                                        <%
                                                            } %>
                                                    </select>
                                                    <img src="../Images/add.png" style="vertical-align: middle;cursor: pointer;" />
                                                </div>
                                            </td>
                                        </tr>
                                      <%if (contractType == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE) {
                                              %>
                                        <tr>
                                            <td class="FieldLabels">
                                                合同周期类型
                                                <div>
                                                    <select name="period_type" class="step2LeftSelectWidth" style="width:134px;">
                                                        <%foreach (var period in periodType) {
                                                                %>
                                                        <option value="<%=period.val %>" <%if (period.val.Equals(((int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH).ToString())){%> selected="selected"<% } %>><%=period.show %></option>
                                                        <%
                                                            } %>
                                                    </select>
                                                </div>
                                            </td>
                                            <td class="FieldLabels">
                                                <div>
                                                    <table style="padding:0px;margin:0px; border:0px; border-spacing:0px;" cellspacing="0" cellpadding="0">
                                                        <tbody>
                                                            <tr>
                                                                <td class="FieldLabels">
                                                                    初始费用
                                                                    <div style="width: 88px;padding:0;">
                                                                        <input type="text" name="setup_fee" value="0.00" style="width: 88px;padding:0;text-align: right;" />
                                                                    </div>
                                                                </td>
                                                                <td class="FieldLabels" style="padding-left :16px">
                                                                    初始费用计费代码
                                                                    <div style="padding:0;">
                                                                        <input type="hidden" id="SetupCodeHidden" name="setup_fee_cost_code_id" />
                                                                        <input type="text" id="SetupCode" disabled="disabled" style="margin: 2px 0px; width:224px;" />
                                                                        <img src="../Images/add.png" style="vertical-align: middle;cursor: pointer;" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                开始日期<span class="errorSmall">*</span>
                                                <div>
                                                    <input type="text" id="start_date" name="start_date" style="width:120px;" onclick="WdatePicker()" class="Wdate"/>
                                                </div>
                                            </td>
                                            <td class="CheckboxLabels" id="endTd">
                                                <input type="radio" checked="checked" onclick="getRadio(1)" name="rEnd"/>
                                                <span>结束日期</span>
                                                <span class="errorSmall">*</span>
                                                <input type="text" id="end_date" name="end_date" onclick="WdatePicker()" class="Wdate"/>
                                            </td>
                                        </tr>
                                        <tr id="endTr">
                                            <td colspan="1"></td>
                                            <td class="CheckboxLabels" style="padding-top:10px">
                                                <input type="radio" name="rEnd" onclick="getRadio(2)"/>
                                                <span>结束于</span>
                                                <span class="errorSmall">*</span>
                                                <input type="text" disabled="disabled" id="occurrences" name="occurrences" style="margin-left: 2px;text-align:right;" size="3"/>个服务周期后
                                            </td>
                                        </tr>
                                      <%
                                          } else {
                                              %>
                                      <tr>
                                          <td class="FieldLabels">
                                              开始日期<span class="errorSmall">*</span>
                                              <div>
                                                  <input type="text" style="width:120px;" id="start_date" name="start_date" onclick="WdatePicker()" class="Wdate" />
                                              </div>
                                          </td>
                                      </tr>
                                      <tr>
                                          <td class="FieldLabels">
                                              结束日期<span class="errorSmall">*</span>
                                              <div>
                                                  <input type="text" style="width:120px;" id="end_date" name="end_date" onclick="WdatePicker()" class="Wdate" />
                                              </div>
                                          </td>
                                      </tr>
                                      <%
                                          } %>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <!--第二页-->
        <div class="Workspace Workspace2" style="display: none;">
            <div class="PageInstructions">Please provide information for the new contract. Be certain to include start and end dates for the contract.</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                    <tr height="85%">
                        <td width="90%" valign="top">
                            <!--第一页主体-->
                            <table cellspacing="0" cellpadding="0" width="100%" style="min-width: 722px;">
                                <tbody>
                                <tr>
                                    <td class="FieldLabels">
                                        公司<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text" style="width: 278px; margin-right: 4px;" />
                                        </div>
                                    </td>
                                    <td class="FieldLabels">
                                        Contract Description
                                        <div>
                                            <input type="text" style="width: 342px;" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        Company Name<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text"style="width: 278px;" />
                                            <img src="../Images/data-selector.png" style="vertical-align: middle;cursor: pointer;" />
                                        </div>
                                    </td>
                                    <td class="FieldLabels">
                                        Contract Category
                                        <div>
                                            <select class="step2LeftSelectWidth" style="width:356px;">
                                                <option value=""></option>
                                                <option value="">Need</option>
                                                <option value="">Timing</option>
                                                <option value="">Price</option>
                                                <option value="">Competition</option>
                                                <option value="">Feature</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        <input type="checkbox" origchecked="true" />
                                        <span>Default Service Desk Contract</span>
                                    </td>
                                    <td class="FieldLabels">
                                        <div>
                                            <table style="padding:0px;margin:0px; border:0px; border-spacing:0px;">
                                                <tbody>
                                                <tr>
                                                    <td class="FieldLabels">
                                                        External Contract Number
                                                        <br/>
                                                        <input type="text" style="width: 155px;"/>
                                                    </td>
                                                    <td class="FieldLabels" style=" padding-left :16px;">
                                                        Purchase Order Number
                                                        <br/>
                                                        <input type="text" style="width: 156px;"/>
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        Contact Name
                                        <div>
                                            <select class="step2LeftSelectWidth" style="width:134px;">
                                                <option value=""></option>
                                                <option value="">xiaodangjia</option>
                                                <option value="">asdsa</option>
                                                <option value="">fgdngjia</option>
                                            </select>
                                        </div>
                                    </td>
                                    <td class="FieldLabels">
                                        Service Level Agreement
                                        <div>
                                            <select style="width:356px;">
                                                <option value=""></option>
                                                <option value="">asdsad</option>
                                            </select>
                                            <img src="../Images/add.png" style="vertical-align: middle;cursor: pointer;"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        Start Date<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text" style="width:120px;" onclick="WdatePicker()" class="Wdate"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        End Date<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text" style="width:120px;" onclick="WdatePicker()" class="Wdate"/>
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
        </div>
        <!--第三页 自定义字段-->
        <div class="Workspace Workspace3" style="display: none;">
            <div class="PageInstructions" style="font-weight: bold;">自定义字段</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%" class="Searchareaborder">
                    <tbody>
                        <tr>
                            <td align="center">
                                <table  cellspacing="1" cellpadding="0" width="100%">
                                    <tbody>
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
                                                    <input type="text" name="<%=udf.id %>" style="width:300px;" />
                                                </div>
                                            </td>
                                        </tr>
                                        <%}
                                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                                            {%>
                                        <tr>
                                            <td>
                                                <label><%=udf.name %></label>
                                                <textarea name="<%=udf.id %>" rows="2" cols="20"></textarea>

                                            </td>
                                        </tr>
                                        <%}
                                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                                            {%><tr>
                                                <td>
                                                    <label><%=udf.name %></label>
                                                    <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" />
                                                </td>
                                            </tr>
                                        <%}
                                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                                            {%>
                                        <tr>
                                            <td>
                                                <label><%=udf.name %></label>
                                                <input type="text" name="<%=udf.id %>" class="sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" />
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
        <!--第四页 服务包-->
        <div class="Workspace Workspace4" style="display: none;">
            <div class="PageInstructions">选择要添加到定期合同中的服务或服务包，稍后可以通过打开合同进入服务页面对此合同的所有服务/包进行打折。</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr>
                            <td colspan="9" valign="top">
                                <table cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span class="contentButton">
                                                    <a class="ImgLink" onclick='window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALLBACK %>&field=ServiceName&callBack=AddService", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ServiceSelect %>", "left=200,top=200,width=600,height=800", false);'>
                                                        <img src="../Images/add.png" class="ButtonImg"/>
                                                        <span class="Text">新建服务</span>
                                                    </a>
                                                </span>
                                                <span class="contentButton">
                                                    <a class="ImgLink" onclick='window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_BUNDLE_CALLBACK %>&field=ServiceName&callBack=AddServiceBundle", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ServiceBundleSelect %>", "left=200,top=200,width=600,height=800", false);'>
                                                        <img src="../Images/add.png" class="ButtonImg"/>
                                                        <span class="Text">新建服务包</span>
                                                    </a>
                                                </span>
                                              <input type="hidden" id="ServiceName" />
                                              <input type="hidden" id="ServiceNameHidden" />
                                              <input type="hidden" id="AddServiceIds" name="AddServiceIds" />
                                              <input type="hidden" id="AddSerBunIds" name="AddSerBunIds" />
                                            </td>
                                        </tr>
                                        <tr height="10px;"></tr>
                                        <tr>
                                            <td colspan="1" id="txtBlack8">
                                                <div class="DivScrollingContainer" style="top:1px;margin-right:10px;">
                                                    <div class="grid" style="margin-right :1px;">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
                                                            <thead>
                                                                <tr>
                                                                    <td style="padding-left: 10px;"></td>
                                                                    <td style="text-align:left;padding-left: 5px; ">服务/包名称</td>
                                                                    <td style="padding-left: 5px; ">供应商名称</td>
                                                                    <td style="padding-left: 5px; ">周期类型</td>
                                                                    <td align="right">单元成本</td>
                                                                    <td align="right">单价</td>
                                                                    <td align="right">数量</td>
                                                                    <td align="right">总价</td>
                                                                </tr>
                                                            </thead>
                                                            <tbody id="ServiceBody">
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
                        <tr height="10px;"></tr>
                        <tr width="100%">
                            <td width="90%;" colspan="8" align="right">
                                <span class="FieldLabels">平均月度计费价格</span>
                            </td>
                            <td class="FieldLabels" width="10%" style="padding-right:15px;">
                                <div style="width:130px;height: 24px; padding:0 0 0 10px;">
                                    <input type="text" value="0.00" id="ServicePrice" style="text-align: right;"/>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <input type="hidden" id="serBd" />
                <input type="hidden" id="serBdHidden" />
            </div>
        </div>
        <!--第五页 工时计费设置-->
        <div class="Workspace Workspace5" style="display: none;">
            <div class="PageInstructions">请为新合同录入工时信息。</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%">
                                <table cellspacing="1" cellpadding="0" width="100%">
                                    <tr>
                                        <td class="FieldLabels">
                                            工时计费设置<span class="errorSmall">*</span>
                                            <div style="position:relative; visibility:visible; display:block;width:100%;">
                                                <select name="bill_post_type_id" id="bill_post_type_id" style="width:190px;">
                                                    <option value="">--请选择--</option>
                                                    <%foreach (var bill in billPostType) {
                                                            %>
                                                    <option value="<%=bill.val %>"><%=bill.show %></option>
                                                    <%
                                                        } %>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div>
                                                <input type="checkbox" style="vertical-align: middle;"/>
                                                <span class="CheckboxLabels">要求工时输入开始/结束时间</span>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <!--第六页 角色费率设置-->
        <div class="Workspace Workspace6" style="display: none;">
            <div class="PageInstructions">默认情况下，所有角色会使用默认计费费率。若要覆盖角色费率，请勾选角色复选框并输入新费率。</div>
            <div style="left: 0;overflow-x: auto;overflow-y: auto;position: fixed;right: 0;bottom: 82px;top:70px;">
                <div class="WizardSection">
                    <table cellspacing="0" cellpadding="0" width="100%">
                        <tbody>
                        <tr height="85%">
                            <td width="90%">
                                <div class="grid NoPagination">
                                    <table cellspacing="1" cellpadding="0" width="100%">
                                        <thead>
                                            <tr>
                                                <td style="width:20px; text-align:center;">
                                                    <input type="checkbox" style="vertical-align: middle;" />
                                                </td>
                                                <td>角色名称</td>
                                                <td align="right">角色小时计费费率</td>
                                                <td align="right">合同小时计费费率</td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                          <%foreach (var role in roleList) { %>
                                            <tr>
                                                <td style="width:20px; text-align:center;">
                                                    <input type="checkbox" name="cbRoleRate<%=role.id %>" onclick="CheckRoleRate(<%=role.id%>)" style="vertical-align: middle;"/>
                                                  <input type="hidden" id="roleRateCheck<%=role.id %>" name="roleRateCheck<%=role.id %>" />
                                                </td>
                                                <td><%=role.name %></td>
                                                <td align="right">
                                                    <input type="text" size="5" value="<%=role.hourly_rate %>" disabled="disabled" style="width: 97%;text-align: right;"/>
                                                </td>
                                                <td align="right">
                                                    <input type="text" size="5" name="txtRoleRate<%=role.id %>" value="<%=role.hourly_rate %>" style="text-align: right;"/>
                                                </td>
                                            </tr>
                                          <%} %>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <!--第七页 里程碑设置-->
        <div class="Workspace Workspace7" style="display: none;">
            <div class="PageInstructions">请为新合同输入里程碑信息。</div>
            <div class="WizardSection">
                <div style="position:relative;">
                    <div style="position:absolute;top:0px;left:0px;width:100%;" id="MilList">
                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                            <tbody>
                                <tr>
                                    <td colspan="2">
                                        <div style="height:400px;width:100%;">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
                                                <thead>
                                                    <tr>
                                                        <td style="padding-left: 10px;"></td>
                                                        <td style="text-align:left;padding-left: 5px; ">标题</td>
                                                        <td style="padding-left: 5px; ">总额</td>
                                                        <td style="padding-left: 5px; ">截止日期</td>
                                                        <td align="right">计费代码</td>
                                                    </tr>
                                                </thead>
                                                <tbody id="MilListBody">
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" cellspacing="0" cellpadding="0" border="0" style="padding-top:10px;">
                                            <tbody>
                                                <tr>
                                                    <td class="FieldLabels" align="right">
                                                        预估收入
                                                    </td>
                                                    <td align="left" style="padding-left:3px;">
                                                        <b>
                                                            <span>¥0.00</span>
                                                        </b>
                                                    </td>
                                                    <td class="FieldLabels" align="right">
                                                        里程碑总额
                                                    </td>
                                                    <td align="left" style="padding-left:3px;">
                                                        <b>
                                                            <span id="milAmountTotal">¥0.00</span>
                                                        </b>
                                                    </td>
                                                    <td align="right">
                                                        <div class="ButtonContainer">
                                                            <ul>
                                                                <li class="Button ButtonIcon NormalState" onclick="AddMil()" tabindex="0">
                                                                    <span class="Icon Add"></span>
                                                                    <span class="Text">新增里程碑</span>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                      <input type="hidden" name="milestoneAddList" id="milestoneAddList" />
                    </div>
                    <div style="position:absolute;top:0px;left:0px;display:none;" id="MilAdd">
                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                            <tbody>
                                <tr>
                                    <td class="FieldLabels" colspan="5">
                                        标题<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text" style="width:100%;" id="milName" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        总额
                                        <div>
                                            <input type="text" style="width:80px;" value="0.00" id="milAmout" />
                                        </div>
                                    </td>
                                    <td width="30px"></td>
                                    <td class="FieldLabels">
                                        计费代码
                                        <div>
                                            <input type="hidden" id="milAddCodeHidden" />
                                            <input type="text" id="milAddCode" style="width:200px;" disabled="disabled" />
                                            <a class="DataSelectorLinkIcon" onclick="window.open('../Common/SelectCallBack.aspx?cat=&field=milAddCode', '_blank', 'left=200,top=200,width=600,height=800', false);">
                                                <img src="../Images/data-selector.png" style="vertical-align: middle;"/>
                                            </a>
                                        </div>
                                    </td>
                                    <td width="10px"></td>
                                    <td class="FieldLabels">
                                        截止日期<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text" style="width:90px;" id="milDate" onclick="WdatePicker()" class="Wdate"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div>
                                            <input type="checkbox"/>
                                            <span>待计费</span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels" colspan="5">
                                        描述
                                        <div>
                                            <textarea rows="7" id="milDesc" style="width:100%;"></textarea>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="ButtonContainer">
                                            <ul>
                                                <li class="Button ButtonIcon Okey NormalState" onclick="AddMilOk()" tabindex="0">
                                                    <span class="Icon Ok"></span>
                                                    <span class="Text">确认</span>
                                                </li>
                                                <li class="Button ButtonIcon Cancel NormalState" onclick="AddMilCancle()" tabindex="0">
                                                    <span class="Icon Cancel"></span>
                                                    <span class="Text">取消</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!--第八页 通知设置-->
        <div class="Workspace Workspace8" style="display: none;">
            <div class="PageInstructions">选择要通知的人并创建通知信息。</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr>
                            <td width="50%" valign="top">
                                <table cellspacing="0" cellpadding="0" width="90%">
                                    <tr>
                                        <td class="sectionBluebg">
                                            员工
                                            <span style="font-weight: normal;">
                                                <a class="PrimaryLink" onclick="ShowResource()">(加载)</a>
                                            </span>
                                            <div id="ResourceDiv" style="display:none;max-height:300px;overflow:auto;" class="grid">
                                              <table cellspacing="1" cellpadding="0" width="100%">
                                                <thead>
                                                    <tr>
                                                        <td style="width:20px; text-align:center;">
                                                            <input type="checkbox" style="vertical-align: middle;" />
                                                        </td>
                                                        <td>姓名</td>
                                                        <td align="right">邮件地址</td>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                  <%foreach (var resource in resourceList) { %>
                                                  <tr>
                                                      <td style="width:20px; text-align:center;">
                                                          <input type="checkbox" name="notify<%=resource.id %>" style="vertical-align: middle;"/>
                                                      </td>
                                                      <td><%=resource.name %></td>
                                                      <td align="right">
                                                          <%=resource.email %>
                                                      </td>
                                                  </tr>
                                                  <%} %>
                                                </tbody>
                                              </table>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabels">
                                            其他邮件地址
                                            <span class="FieldLevelInstructions">
                                                （用半角逗号分隔）
                                            </span>
                                            <div style="margin-bottom:8px;">
                                                <input type="text" name="notifyEmails" style="width: 100%" />
                                            </div>
                                            <div>
                                                <input type="checkbox" />
                                                <span style="cursor:pointer;" class="CheckboxLabels">客户地域团队</span>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td width="50%" valign="top">
                                <table cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td class="FieldLabels">
                                                主题
                                                <div style="padding-right: 10px;">
                                                    <input type="text" name="notifyTitle" style="width:99%;" value="创建合同" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                信息
                                                <div style="padding-right: 10px;">
                                                    <textarea style="width: 99%; height: 291px;" name="notifyContent" rows="12"></textarea>
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
        </div>
        <!--第九页 完成-->
        <div class="Workspace Workspace9" style="display: none;">
            <div class="PageInstructions">向导已经完成，你可以执行以下操作</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%">
                                <a href="ContractView.aspx?id=<%=contractId %>">打开新创建合同</a>
                            </td>
                        </tr>
                        <tr height="85%">
                            <td width="90%">
                                <a href="ContractAdd.aspx?type=<%=contractType %>">创建另一个合同</a>
                            </td>
                        </tr>
                        <tr height="85%">
                            <td width="90%">
                                <a onclick="javascript:window.close();">关闭本窗口</a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <input type="hidden" name="type_id" id="contractType" value="<%=contractType %>" />
        <input type="hidden" id="isFinish" value="<%=isFinish %>" />
        <input type="hidden" id="currentPage" value="" />
        <input type="hidden" id="serviceBd" name="serviceBd" />
        <input type="hidden" id="cnt" <%if (udfList != null && udfList.Count != 0) { %> value="1" <%} else { %> value="0" <%} %> />
        <div class="ButtonBar WizardButtonBar" style="width:97%;">
            <ul>
                <li style="display: none;" id="a0">
                    <a class="ImgLink">
                        <img class="ButtonImg" src="../Images/move-left.png" />
                        <span class="Text">上一步</span>
                    </a>
                </li>
                <li class="right" id="b0">
                    <a class="ImgLink">
                        <span class="Text">下一步</span>
                        <img class="ButtonRightImg" src="../Images/move-right.png" />
                    </a>
                </li>
                <li style="display: none;" class="right" id="c0">
                    <a class="ImgLink">
                        <span class="Text">完成</span>
                    </a>
                </li>
                <li class="right" style="display: none;" id="d0">
                    <a class="ImgLink">
                        <img class="ButtonRightImg" src="../Images/cancel.png" />
                        <span class="Text">关闭</span>
                    </a>
                </li>
            </ul>
        </div>
    </form>
    <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
    <script type="text/javascript" src="../Scripts/common.js"></script>
    <script type="text/javascript" src="../Scripts/ContractWizard.js"></script>
    <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
</body>
</html>
