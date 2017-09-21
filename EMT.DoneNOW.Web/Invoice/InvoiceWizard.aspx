<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceWizard.aspx.cs" Inherits="EMT.DoneNOW.Web.Invoice.InvoiceWizard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>生成发票向导</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/LostOpp.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">发票向导</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <!--第一页-->
        <div class="Workspace Workspace1">
            <div class="WizardSection" style="padding-bottom: 10px;">
                <span class="FieldLabels">发票模板 
                </span><span class="errorSmall">*</span>
                <div>
                    <asp:DropDownList ID="invoice_tmpl_id" runat="server" Width="185px"></asp:DropDownList>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="Heading">
                    <span class="Text">发票客户，项目和日期选项</span>
                </div>
                <div class="Content">
                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                        <tbody>
                            <tr>
                                <td class="FieldLabels" width="50%">
                                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabels" width="50%">客户名称 <span class="errorSmall">*</span>
                                                    <div>
                                                        <input type="text" style="width: 196px;" id="account_id" value="<%=account!=null?account.name:"" %>" />
                                                        <input type="hidden" name="account_id" id="account_idHidden" value="" runat="server" />
                                                        <img src="../Images/data-selector.png" style="vertical-align: middle;" onclick="chooseAccount()" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" valign="top">
                                                    <div>
                                                        <span style="padding-bottom: 10px; display: block;">
                                                            <asp:CheckBox ID="ckchildAccounts" runat="server" />
                                                            
                                                            <label style="font-weight: 100;" for="ckchildAccounts">显示子客户条目</label>
                                                        </span>
                                                        <span style="padding-bottom: 10px; display: block;">
                                                            <input type="checkbox" id="ckserviceContract" runat="server" />
                                                            <label style="font-weight: 100;">显示定期服务合同工时</label>
                                                        </span>
                                                        <span style="padding-bottom: 10px; display: block;">
                                                            <input type="checkbox" id="ckFixPrice" runat="server" />
                                                            <label style="font-weight: 100;">显示固定价格合同工时</label>
                                                        </span>
                                                        <span>
                                                            <input type="checkbox" id="ckPirceZero" checked="checked" runat="server" />
                                                            <label style="font-weight: 100;">不显示定期服务/服务包价格为0的条目</label>
                                                        </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels">项目名称
                                                <div>
                                                    <input type="text" style="width: 196px;" id="project_id" />
                                                    <input type="hidden" name="project_id" id="project_idHidden" runat="server" />
                                                    <img src="../Images/data-selector.png" alt="" onclick="ChooseProject()" />
                                                </div>
                                                    部门名称
                                                <div>
                                                    <asp:DropDownList ID="department_id" runat="server" Width="212px"></asp:DropDownList>
                                                </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                                <td class="FieldLabels" style="vertical-align: top;">
                                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabels" width="30%">条目日期 >=<span class="errorSmall">*</span>
                                                    <div>
                                                        <input type="text" onclick="WdatePicker()" id="itemStartDate" class="Wdate" runat="server" value="" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels">条目日期 <=<span class="errorSmall">*</span>
                                                    <div>
                                                        <input type="text" onclick="WdatePicker()" id="itemEndDate" class="Wdate" runat="server" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels">条目类型
                                                <div>
                                                    <select multiple style="width: 156px; height: 70px;" id="type_id">
                                                        <%
                                                            var itemType = dic.FirstOrDefault(_ => _.Key == "account_deduction_type").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                                                            if (itemType != null && itemType.Count > 0)
                                                            {
                                                                foreach (var item in itemType)
                                                                {
                                                        %>
                                                        <option value="<%=item.val %>"><%=item.show %></option>
                                                        <%
                                                                }
                                                            }
                                                        %>
                                                    </select>
                                                    <input type="hidden" name="thisItemTypeId" id="thisItemTypeId" runat="server"/>
                                                </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                                <td class="FieldLabels" style="vertical-align: top;">
                                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabels" width="30%">合同类型
                                                <div>
                                                    <asp:DropDownList ID="contract_type_id" runat="server"></asp:DropDownList>
                                                </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels">合同类别 
                                                <div>
                                                    <asp:DropDownList ID="contract_cate_id" runat="server" Width="166px"></asp:DropDownList>

                                                </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels">项目条目
                                                <div>
                                                    <asp:DropDownList ID="projectItem" runat="server">
                                                                 <asp:ListItem Value="">全部</asp:ListItem>
                                                        <asp:ListItem Value="onlyProject">只显示项目条目</asp:ListItem>
                                                        <asp:ListItem Value="onlyNoProject">只显示非项目条目</asp:ListItem>
                                                    </asp:DropDownList>
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
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a1">
                        <a class="ImgLink disabledLink">
                            <img class="ButtonImg" src="../Images/move-left.png" />
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b1">
                      
                                <asp:LinkButton ID="lbnext" runat="server" OnClick="lbnext_Click">下一页 <img class="ButtonRightImg" src="../Images/move-right.png" /></asp:LinkButton>
                            
                          <%--  <img class="ButtonRightImg" src="../Images/move-right.png" />--%>
                   
                    </li>
                    <!--完成-->
                    <li class="right" id="c1">
                        <a class="ImgLink disabledLink">
                            <span class="Text">现在完成</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d1">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">关闭</span>
                        </a>
                    </li>
                    <!--打印预览-->
                    <li class="right" id="e1">
                        <a class="ImgLink disabledLink">
                            <span class="Text">打印预览</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!--第二页-->
        <div class="Workspace Workspace2" style="display: none;">
            <div class="PageInstructions">请选择发票条目，至少选择一条。</div>
            <div class="WizardSection" style="overflow: auto; height: 520px;">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr>
                            <td colspan="9" valign="top">
                                <table cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td colspan="1" id="txtBlack8">
                                                <div class="DivScrollingContainer" style="top: 1px; margin-right: 10px;">
                                                    <div class="grid" style="overflow: auto;">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
                                                            <thead>
                                                                <tr>
                                                                    <td align="center" style="width: 20px;">
                                                                        <input type="checkbox" style="margin: 0;" id="checkAll">
                                                                    </td>
                                                                    <td width="20" align="center">计费项类型</td>
                                                                    <td width="20" align="center">条目创建时间</td>
                                                                    <td>条目名称</td>
                                                                    <td>客户名称</td>
                                                                    <td>合同名称</td>
                                                                    <td>部门名称</td>
                                                                    <td>计费代码名称</td>
                                                                    <td>员工姓名</td>
                                                                    <td>角色名称</td>
                                                                    <td align="right">项目名称</td>
                                                                    <td align="right">角色费率</td>
                                                                    <td align="right">计费时间/数量</td>
                                                                    <td align="right">金额</td>
                                                                    <td align="center">税收种类</td>
                                                                    <td align="center">计费到父客户</td>
                                                                    <td align="center">计费到子客户</td>
                                                                </tr>
                                                            </thead>
                                                            <tbody id="showAccountDed">
                                                            
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
                    <li class="right" id="c2">
                        <a class="ImgLink disabledLink">
                            <span class="Text">现在完成</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d2">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">关闭</span>
                        </a>
                    </li>
                    <!--打印预览-->
                    <li class="right" id="e2">
                        <a class="ImgLink disabledLink">
                            <span class="Text">打印预览</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- 第二页选择的条目的id的集合 -->
        <input type="hidden" name="accDedIds" id="accDedIds" value=""/>


        <!--第三页-->
        <div class="Workspace Workspace3" style="display: none;">
            <div class="PageInstructions">请填写发票相关信息、选择发票输出方式。</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr>
                            <td valign="top" width="60%">
                                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top">
                                                <div class="DivSectionWithHeader">
                                                    <div class="Heading">
                                                        <span class="Text">发票选项</span>
                                                    </div>
                                                    <div class="Content">
                                                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td class="FieldLabels" width="50%">发票编号 
                                                                    <div>
                                                      <%--=accDedDal.GetNextIdInvNo()--%>
                                                                        <input type="text" disabled style="width: 104px;" value="<%=accDedDal.GetNextIdInvNo() %>" />
                                                                    </div>
                                                                    </td>
                                                                    <td class="FieldLabels" width="50%">发票日期 <span class="errorSmall">*</span>
                                                                        <div>
                                                                            <input type="text" style="width: 104px;" onclick="WdatePicker()" class="Wdate" name="invoice_date" id="invoice_date" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" width="50%">发票开始日期   <span class="errorSmall">*</span>
                                                                    <div>
                                                                        <input type="text" style="width: 104px;" onclick="WdatePicker()" class="Wdate" name="date_range_from" id="date_range_from" />
                                                                    </div>
                                                                    </td>
                                                                    <td class="FieldLabels" width="50%">发票结束时间<span class="errorSmall">*</span>
                                                                    <div>
                                                                        <input type="text" style="width: 104px;" onclick="WdatePicker()" class="Wdate" name="date_range_to" id="date_range_to">
                                                                    </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" width="50%">订单号  
                                                                    <div>
                                                                        <input type="text" style="width: 104px;" name="purchase_order_no" id="purchase_order_no" />
                                                                    </div>
                                                                    </td>
                                                                    <td class="FieldLabels" width="50%">支付条款 
         <div>
             <asp:DropDownList ID="payment_term_id" runat="server" Width="120px"></asp:DropDownList>
         </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels">发票备注
                                                                    <div>
                                                                        <textarea style="width: 100%;" rows="7" name="notes" id="notes"></textarea>
                                                                    </div>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td valign="top" width="8"></td>
                            <td valign="top">
                                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top">
                                                <div class="DivSectionWithHeader">
                                                    <div class="Heading">
                                                        <span class="Text">输出方式</span>
                                                    </div>
                                                    <div class="Content">
                                                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td class="FieldLabels">
                                                                        <div>
                                                                            <input type="checkbox" style="vertical-align: middle;" id="invShow" checked="checked" runat="server" />
                                                                            <label for="invShow" style="font-weight: normal; cursor: pointer;">打印预览</label>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels">
                                                                        <div>
                                                                            <input type="checkbox" style="vertical-align: middle;" disabled id="emailShow" runat="server">
                                                                            <label style="font-weight: normal; cursor: pointer;">邮件</label>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels">
                                                                        <div>
                                                                            <input type="checkbox" style="vertical-align: middle;" disabled id="quickBookShow" runat="server" />
                                                                            <label style="font-weight: normal; cursor: pointer;">Transfer Invoice to QuickBooks</label>
                                                                        </div>
                                                                    </td>
                                                                </tr>
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
                    <li class="right" id="c3">
                        <a class="ImgLink">
                            <span class="Text">
                                <asp:Button ID="finishNowC3" runat="server" Text="现在完成" OnClick="finishNowC3_Click"  BorderStyle="None"/></span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d3">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">关闭</span>
                        </a>
                    </li>
                    <!--打印预览-->
                    <li class="right" id="e3">
                        <a class="ImgLink">
                            <span class="Text">打印预览</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第四页-->
        <div class="Workspace Workspace4" style="display: none;">
            <div class="PageInstructions">notes</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%" border="0">
                    <tbody>
                        <tr>
                            <td valign="top" width="60%">
                                <div class="DivSectionWithHeader">
                                    <div class="Heading">
                                        <span class="Text">发票打印选项</span>
                                    </div>
                                    <div class="Content">
                                        <table cellspacing="0" cellpadding="0" width="100%" border="0">
                                            <tbody>
                                                <tr>
                                                    <td class="FieldLabels">税区                                                   
                                                        <div>
                                                            <asp:DropDownList ID="tax_region" runat="server" Width="300px"></asp:DropDownList>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabels">税额<span style="font-weight: normal;" id="taxMoney">0.00</span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                            <td valign="top" width="8"></td>
                            <td valign="top">
                                <div class="DivSectionWithHeader">
                                    <div class="Heading">
                                        <span class="Text">ADDITIONAL INVOICE FIELDS</span>
                                    </div>
                                    <div class="Content">
                                        <table cellspacing="0" cellpadding="0" width="100%" border="0">
                                            <tbody>
                                                <tr>
                                                    <td class="FieldLabels">
                                                        <div>
                                                            <table border="none" cellspacing="" cellpadding="" style="width: 400px;">

                                                                <% if (contract_udfList != null && contract_udfList.Count > 0)
                                                                {
                                                                    foreach (var udf in contract_udfList)
                                                                    {
                                                                        if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                                                        {%>
                                                                <tr>
                                                                    <td>
                                                                        <label><%=udf.name %></label>
                                                                        <input type="text" name="<%=udf.id %>" class="sl_cdt" />

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
                                                                        <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" />
                                                                    </td>
                                                                </tr>
                                                                <%}
                                                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                                                                {%>

                                                                <%}
                                                                        }
                                                                    }
                                                                    else
                                                                    {%>
                                                                发票还未设置自定义字段
                                                                    <%}
                                                                %>
                                                            </table>

                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a4">
                        <a class="ImgLink">

                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b4">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" id="c4">
                        <a class="ImgLink">
                            <span class="Text"> <asp:Button ID="FinishNowC4" runat="server" Text="现在完成" OnClick="FinishNowC4_Click" BorderStyle="None"/></span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d4">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                    <!--打印预览-->
                    <li class="right" id="e4">
                        <a class="ImgLink">
                            <span class="Text">打印预览</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第五页-->
        <div class="Workspace Workspace5" style="display: none;">
            <div class="PageInstructions">点击完成，将会执行以下操作</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%">
                                <div class="DivSectionWithHeader">
                                    <div class="Heading">
                                        <span class="Text">INVOICE WIZARD ACTION(S)</span>
                                    </div>
                                    <div class="Content">
                                        <table cellspacing="0" cellpadding="0" width="100%" border="0">
                                            <tbody>
                                                <tr>
                                                    <td class="FieldLabels">
                                                        <div>
                                                            <img src="../Images/check.png" style="vertical-align: middle;">
                                                            保存发票 
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabels">
                                                        <div id="divShowContractPrint">
                                                            <img src="../Images/check.png" style="vertical-align: middle;">
                                                               显示发票预览
                                                        </div>
                                                    </td>
                                                </tr>
                                                  <tr>
                                                    <td class="FieldLabels">
                                                        <div id="divShowEmail">
                                                            <img src="../Images/check.png" style="vertical-align: middle;">
                                                               显示邮件
                                                        </div>
                                                    </td>
                                                </tr>
                                                  <tr>
                                                    <td class="FieldLabels">
                                                        <div id="divShowQuickBooks">
                                                            <img src="../Images/check.png" style="vertical-align: middle;">
                                                               显示QuickBooks
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a5">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li style="display: none;" class="right" id="b5">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" id="c5">
                        <a class="ImgLink">
                            <span class="Text">
                                <asp:Button ID="finish" runat="server" Text="完成" OnClick="finish_Click" /></span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d5">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">关闭</span>
                        </a>
                    </li>
                    <!--打印预览-->
                    <li class="right" id="e5">
                        <a class="ImgLink">
                            <span class="Text">打印预览</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第六页-->
        <div class="Workspace Workspace6" style="display: none;">
            <div class="PageInstructions">
                向导完成
            </div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%">This window will automatically close once your invoice has been processed.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li style="display: none;" id="a6">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li style="display: none;" class="right" id="b6">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li style="display: none;" class="right" id="c6">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" id="d6">
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
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#lbnext").on("click", function () {
        var invoice_tmpl_id = $("#invoice_tmpl_id").val();
        if (invoice_tmpl_id == "" || invoice_tmpl_id == "0") {
            alert("请选择发票模板");
            return false;
        }
        var itemStartDate = $("#itemStartDate").val();
        if (itemStartDate == "") {
            alert("请选择条目开始时间");
            return false;
        }
        var itemEndDate = $("#itemEndDate").val();
        if (itemEndDate == "") {
            alert("请选择条目结束时间");
            return false;
        }
        if (!DateJudge(itemStartDate, itemEndDate)) {
            alert("条目结束时间必须晚于条目开始时间");
            return false;
        }
        var account_id = $("#account_idHidden").val();
        if (account_id == "") {
            alert("请通过查找带回选择客户");
            return false;
        }

        debugger;
        $("#date_range_from").val(itemStartDate);
        $("#date_range_to").val(itemEndDate);
          


        //$(".Workspace1").hide();
        //$(".Workspace2").show();
    });
    $("#a2").on("click", function () {
        $(".Workspace1").show();
        $(".Workspace2").hide();
    });
    $("#b2").on("click", function () {
        debugger;
        var ids = "";
        $(".thisDedCheck").each(function () {
            debugger;
            if ($(this).is(":checked")) {
                ids += $(this).val() + ',';
            }
        })
        if (ids == "") {
            alert("请至少选择一条条目");
            return false;
        }
        ids = ids.substring(0, ids.length - 1);
        $("#accDedIds").val(ids);
        GetTaxSum(ids, $("#tax_region").val());
        //$("#c2").find('a').removeClass("disabledLink");
        //$("#e2").find('a').removeClass("disabledLink");
        //$("#c1").find('a').removeClass("disabledLink");
        //$("#e1").find('a').removeClass("disabledLink");
        $(".Workspace2").hide();
        $(".Workspace3").show();
        // thisDedCheck
    });
    $("#a3").on("click", function () {
        $(".Workspace2").show();
        $(".Workspace3").hide();
        //$("#c2").find('a').addClass("disabledLink");
        //$("#c1").find('a').addClass("disabledLink");
    });
    $("#b3").on("click", function () {
        if ($("#invShow").is(":checked")) {
            $("#divShowContractPrint").show();
        } else {
            $("#divShowContractPrint").hide();
        }
        if ($("#emailShow").is(":checked")) {
            $("#divShowEmail").show();
        } else {
            $("#divShowEmail").hide();
        }
        if ($("#quickBookShow").is(":checked")) {
            $("#divShowQuickBooks").show();
        } else {
            $("#divShowQuickBooks").hide();
        }
        $(".Workspace3").hide();
        $(".Workspace4").show();
    });
    $("#a4").on("click", function () {
        $(".Workspace3").show();
        $(".Workspace4").hide();
    });
    $("#b4").on("click", function () {
        $(".Workspace4").hide();
        $(".Workspace5").show();
    });
    $("#a5").on("click", function () {
        $(".Workspace4").show();
        $(".Workspace5").hide();
    });
    $("#c5").on("click", function () {
        $(".Workspace5").hide();
        $(".Workspace6").show();
    });
    $("#d6").on("click", function () {
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

    $("#type_id").change(function () {
        var thisValue = $(this).val();
        $("#thisItemTypeId").val(thisValue);
    })


    $("#tax_region").change(function () {
        var thisValue = $(this).val();
        if (thisValue != undefined && thisValue != "0") {
            var accDedIds = $("#accDedIds").val();
            if (accDedIds != "") {
                GetTaxSum(accDedIds, thisValue);
            }
        }
    })

    $("#finishNowC3_Click").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    $("#FinishNowC4").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })

    $("#finish").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    $("#checkAll").click(function () {
        if ($(this).is(":checked")) {
            $(".thisDedCheck").prop("checked", true);
            // $(".IsChecked").css("checked", "checked");
        }
        else {
            $(".thisDedCheck").prop("checked", false);
            // $(".IsChecked").css("checked", "");
        }
    })
   


    function chooseAccount() {
        // 客户查找带回 account_idHidden
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=account_id", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function ChooseProject() {
        // 项目的查找带回 project_idHidden // PROJECTCALLBACK
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECTCALLBACK %>&field=project_id", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.PROJECTCALLBACK %>', 'left=200,top=200,width=600,height=800', false);
    } 
    // 计算出税额--条目的id的集合（accDedIds），税区id（thisValue）
    function GetTaxSum(accDedIds, thisValue) {
        $.ajax({
            type: "GET",
            async: false,
            // dataType: "json",
            url: "../Tools/GeneralAjax.ashx?act=GetTaxSum&ids=" + accDedIds + "&taxId=" + thisValue,
            success: function (data) {
                $("#taxMoney").text(data);
            },
        });

    }


    function SubmitCheck() {
        var invoice_tmpl_id = $("#invoice_tmpl_id").val();
        if (invoice_tmpl_id == "" || invoice_tmpl_id == "0") {
            alert("请选择发票模板");
            return false;
        }
        var account_id = $("#account_idHidden").val();
        if (account_id == "") {
            alert("请通过查找带回选择客户");
            return false;
        }// invoice_date
        var invoice_date = $("#invoice_date").val();
        if (invoice_date == "") {
            alert("请选择发票时间");
            return false;
        }
        var date_range_from = $("#date_range_from").val();
        if (date_range_from == "") {
            alert("请选择发票开始时间");
            return false;
        }
        var date_range_to = $("#date_range_to").val();
        if (date_range_to == "") {
            alert("请选择发票结束时间");
            return false;
        }
        if (!DateJudge(date_range_from, date_range_to)) {
            alert("发票结束时间必须晚于发票开始时间");
            return false;
        }


        return true;
    }

    // 比较两个时间的先后 相等返回true
    function DateJudge(beginDate, endDate) {
        debugger;
        var d1 = new Date(beginDate.replace(/\-/g, "\/"));
        var d2 = new Date(endDate.replace(/\-/g, "\/"));

        if (beginDate != "" && endDate != "" && d1 > d2) {
            return false;
        } else {
            return true;
        }
    }
</script>
