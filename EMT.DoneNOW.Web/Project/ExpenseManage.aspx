<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExpenseManage.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ExpenseManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <title><%=isAdd?"新增":"修改" %>费用 </title>
    <link rel="stylesheet" href="../Content/reset.css" />
    <link href="../Content/DynamicContent.css" rel="stylesheet" />
    <link rel="stylesheet" href="../Content/NewWorkType.css" />
    <style>
        .Medium {
            margin: 0 0 12px 0;
            padding: 4px 0 4px 0;
        }

        #save_close, #save_new {
            border: none;
            background-color: #fafafa;
            flex: 0 1 auto;
            font-size: 12px;
            font-weight: bold;
            overflow: hidden;
            padding: 0 3px;
            text-overflow: ellipsis;
            white-space: nowrap;
            color: #4F4F4F;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="Active ThemePrimaryColor TitleBar">
            <div class="Title"><span class="Text"><%=isAdd?"新增":"修改" %>费用 </span><span class="SecondaryText"></span></div>
            <div class="TitleBarButton Star" id="za129bcc0139b41ea8e2f627eb64b9cd3" title="Bookmark this page">
                <div class="TitleBarIcon Star"></div>
            </div>
            <div class="ContextHelpButton"></div>
        </div>
        <div class="PageContentContainer">
            <div class="PageHeadingContainer">
                <div class="ValidationSummary" id="za5428cdc14ae42d99d7dfb4b7578ff93">
                    <div class="CustomValidation Valid"></div>
                    <div class="FormValidation Valid">
                        <div class="ErrorContent">
                            <div class="TransitionContainer">
                                <div class="IconContainer">
                                    <div class="Icon"></div>
                                </div>
                                <div class="TextContainer"><span class="Count"></span><span class="Count Spacer"></span><span class="Message"></span></div>
                            </div>
                        </div>
                        <div class="ChevronContainer">
                            <div class="Up"></div>
                            <div class="Down"></div>
                        </div>
                    </div>
                </div>
                <div class="ButtonContainer">

                    <a class="NormalState Button ButtonIcon Save" id="" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">
                        <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" /></span></a>
                    <a class="NormalState Button ButtonIcon Save" id="" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></span><span class="Text">
                        <asp:Button ID="save_new" runat="server" Text="保存并新增" OnClick="save_new_Click" /></span></a>
                     <%if (CheckAuth("PRO_PROJECT_VIEW_EXPENSES_ADD_EXPENSES_POLICY"))
                         { %>
                    <a class="NormalState Button ButtonIcon Save" id="" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></span><span class="Text">客户策略</span></a>
                    <%} %>
                    <a class="NormalState Button ButtonIcon Cancel" id="CancelButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></span><span class="Text">关闭</span></a>
                </div>
            </div>
            <div class="ScrollingContentContainer">
                <div class="ScrollingContainer" id="za7dce764d22b4572aaf851391e3b7f6f" style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 85px;">
                    <div class="Normal Section" style="border: 1px solid #d3d3d3; margin: 0 10px 10px 10px; padding: 4px 0 4px 0;">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle1">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">费用报表</span><span class="SecondaryText"></span></div>
                            <div class="Spacer"></div>
                        </div>
                        <div class="Content" style="padding: 0 28px 35px 18px;">
                            <div class="Normal Column">
                                <div class="Medium Column">
                                    <div class="RadioButtonGroupContainer">
                                        <div class="RadioButtonGroupLabel">
                                            <div></div>
                                        </div>
                                        <div class="Editor RadioButton" data-editor-id="z42f84fba1459498cb7acf3a53199b2f1NewExpenseReport" data-rdp="z42f84fba1459498cb7acf3a53199b2f1NewExpenseReport">
                                            <div class="InputField">
                                                <div>
                                                    <asp:RadioButton ID="RDAddRep" runat="server" GroupName="ReportOption" />
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label for="z42f84fba1459498cb7acf3a53199b2f1NewExpenseReport">新建费用报表</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="Editor RadioButton" data-editor-id="z42f84fba1459498cb7acf3a53199b2f1ExistingReport" data-rdp="z42f84fba1459498cb7acf3a53199b2f1ExistingReport">
                                            <div class="InputField">
                                                <div>
                                                    <asp:RadioButton ID="RDAddExiRep" runat="server" GroupName="ReportOption" />
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label for="z42f84fba1459498cb7acf3a53199b2f1ExistingReport">使用现有费用报表</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="Medium Column">
                                    <div class="EditorLabelContainer AddExyRep">
                                        <div class="Label">
                                            <label for="z0c565a939f1a4167a5f0d0b523e0790b">费用报表</label><span class="Required">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor DataSelector AddExyRep">
                                        <div class="InputField">
                                            <input id="expense_report_id" type="text" value="<%=thisExpRep!=null?thisExpRep.title:"" %>" /><a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" tabindex="0" onclick="CallBackExpRep()"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a><input type="hidden" name="expense_report_id" id="expense_report_idHidden" value="<%=thisExpRep!=null?thisExpRep.id.ToString():"" %>" />
                                            <div class="ContextOverlayContainer" id="z0c565a939f1a4167a5f0d0b523e0790b_ContextOverlay">
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                    <div class="EditorLabelContainer AddNewRep ">
                                        <div class="Label">
                                            <label for="z1503a7addf804c9ebbe3cd8e0aceb996">新建报表名称</label><span class="Required Off">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor TextBox AddNewRep">
                                        <div class="InputField">
                                            <input id="title" type="text" value="" name="title" />
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer AddNewRep">
                                        <div class="Label">
                                            <label for="z1906d34dab1b44569fb54a3f44e61d7e">周期结束日期</label><span class="Required Off">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor DateBox AddNewRep">
                                        <div class="InputField">
                                            <div class="Container">
                                                <input id="end_date" type="text" value="" name="end_date" onclick="WdatePicker()" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer AddNewRep">
                                        <div class="Label">
                                            <label for="z946f733ed4cb432bb42ddbb14e969763">预付现金总额</label>
                                        </div>
                                    </div>
                                    <div class="Editor DecimalBox AddNewRep">
                                        <div class="InputField">
                                            <input id="report_amount" type="text" value="" name="report_amount" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="Normal Section" style="border: 1px solid #d3d3d3; margin: 0 10px 10px 10px; padding: 4px 0 4px 0;">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle2">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">费用</span></div>
                            <div class="Middle"></div>
                            <div class="Spacer"></div>
                            <div class="Right"></div>
                        </div>
                        <div class="Content">
                            <div class="Normal Column">
                                <div class="Medium Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="z0f4c0a66a6944107962752f015ce02b5">日期</label><span class="Required">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor DateBox">
                                        <div class="InputField">
                                            <div class="Container">
                                                <input id="add_date" type="text" value="<%=thisExpense!=null?thisExpense.add_date.ToString("yyyy-MM-dd"):DateTime.Now.ToString("yyyy-MM-dd") %>" onclick="WdatePicker()" name="add_date" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="Medium Column">
                                    <div class="Editor CheckBox" data-editor-id="z96ab5b743c0b4e2e885d618078d6308d" data-rdp="z96ab5b743c0b4e2e885d618078d6308d">
                                        <div class="InputField">
                                            <div>
                                                <asp:CheckBox ID="isBillable" runat="server" />
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="z96ab5b743c0b4e2e885d618078d6308d">计费的 <%=thisAccount!=null?thisAccount.name:"" %> </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Column" style="width: 420px;">
                                <div class="Medium Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="z9652980ff66c476d96a16662e0e1173f">类别</label><span class="Required">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor SingleSelect" data-editor-id="z9652980ff66c476d96a16662e0e1173f" data-rdp="z9652980ff66c476d96a16662e0e1173f">
                                        <div class="InputField">
                                            <asp:DropDownList ID="expense_cost_code_id" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <%if (isShowWorkType)
                                    { %>
                                <div class="Medium Column" style="margin-top: 10px;">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="z00ee4ebc56c74f898f8aa86b4d5c405d">工作类型</label>
                                        </div>
                                    </div>
                                    <div class="Editor SingleSelect">
                                        <div class="InputField">
                                            <asp:DropDownList ID="cost_code_id" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <%} %>
                            </div>
                            <div class="Normal Column" style="margin-top: -10px;">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="z9ca58e6a427f499e8314342b2cdedc75">描述</label><span class="Required">*</span>
                                    </div>
                                </div>
                                <div class="Editor TextBox" data-editor-id="z9ca58e6a427f499e8314342b2cdedc75" data-rdp="z9ca58e6a427f499e8314342b2cdedc75">
                                    <div class="InputField">
                                        <input id="description" type="text" value="<%=thisExpense!=null?thisExpense.description:"" %>" name="description" />
                                    </div>
                                </div>
                            </div>
                            <div class="ReplaceableColumnContainer" id="enterDiv" style="width: 500px;">
                                <div class="Normal Column">
                                    <div class="Medium Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="z68735c03ecdb44ad8d2738bfdb726ffe">起点</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor TextBox" data-editor-id="z68735c03ecdb44ad8d2738bfdb726ffe" data-rdp="z68735c03ecdb44ad8d2738bfdb726ffe">
                                            <div class="InputField">
                                                <input id="from_loc" type="text" value="<%=thisExpense==null?"":thisExpense.from_loc %>" name="from_loc" maxlength="128" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Medium Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="zcdad28bf379e43b592eb0f1d1ea06d25">终点</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor TextBox" data-editor-id="zcdad28bf379e43b592eb0f1d1ea06d25" data-rdp="zcdad28bf379e43b592eb0f1d1ea06d25">
                                            <div class="InputField">
                                                <input id="to_loc" type="text" value="<%=thisExpense==null?"":thisExpense.to_loc %>" name="to_loc" maxlength="128" />

                                            </div>
                                        </div>
                                    </div>
                                    <div class="Medium Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="ze872f87d233a429b9d39ed7588b67c2f">里程表开始读数</label>
                                            </div>
                                        </div>
                                        <div class="Editor DecimalBox">
                                            <div class="InputField">
                                                <input id="odometer_start" type="text" class="decimal2" value="<%=thisExpense!=null&&thisExpense.odometer_start!=null?((decimal)thisExpense.odometer_start).ToString("#0.00"):"" %>" name="odometer_start" maxlength="12" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Medium Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="z35f973405e9e4635a97dad7751977e6b">里程表结束读数</label>
                                            </div>
                                        </div>
                                        <div class="Editor DecimalBox">
                                            <div class="InputField">
                                                <input id="odometer_end" type="text" class="decimal2" value="<%=thisExpense!=null&&thisExpense.odometer_end!=null?((decimal)thisExpense.odometer_end).ToString("#0.00"):"" %>" name="odometer_end" maxlength="12" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Medium Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="zf6974ad1447f415c9722470e13426fc5">里程</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor DecimalBox" data-editor-id="zf6974ad1447f415c9722470e13426fc5" data-rdp="zf6974ad1447f415c9722470e13426fc5">
                                            <div class="InputField">
                                                <input id="miles" type="text" class="decimal2" value="<%=thisExpense!=null&&thisExpense.miles!=null?((decimal)thisExpense.miles).ToString("#0.00"):"" %>" name="miles" maxlength="12" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                            </div>
                                        </div>

                                    </div>
                                    <div class="Medium Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="z12e84dca52ec40e599a5d58454a6e950">每公里费率</label>
                                            </div>
                                        </div>
                                        <div class="Editor TextBox" data-editor-id="z12e84dca52ec40e599a5d58454a6e950" data-rdp="z12e84dca52ec40e599a5d58454a6e950">
                                            <div class="InputField">
                                                <input id="rate" type="text" value="" name="rate" disabled="" />
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                            <div class="Normal Column" style="width: 420px;" id="locationDiv">
                                <div class="Medium Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="z1e9e9ba049cc439384ab93a6245b1b59">地点</label>
                                        </div>
                                    </div>
                                    <div class="Editor TextBox" data-editor-id="z1e9e9ba049cc439384ab93a6245b1b59" data-rdp="z1e9e9ba049cc439384ab93a6245b1b59">
                                        <div class="InputField">
                                            <input id="location" type="text" value="<%=thisExpense!=null?thisExpense.location:"" %>" name="location" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="Normal Column" style="width: 420px;">
                                <div class="Medium Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="z97cae0d10d61467888854993e6ed993b">收据总额</label>
                                        </div>
                                    </div>
                                    <div class="Editor TextBox" data-editor-id="z97cae0d10d61467888854993e6ed993b" data-rdp="z97cae0d10d61467888854993e6ed993b">
                                        <div class="InputField">
                                            <input id="amount" type="text" class="decimal2" value="<%=thisExpense!=null?thisExpense.amount.ToString("#0.00"):"" %>" name="amount" readonly="" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                        </div>
                                    </div>
                                    <div class="StandardText LowImportance" id="moneyDiv">(费用类别最多<span id="money"></span>元)</div>
                                    <input type="hidden" id="moneyHidden" name="moneyHidden" />
                                    <input type="hidden" id="overdraft_policy_id" name="overdraft_policy_id" />
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="zf9e5ab672cd848fd955d5be6e6f9c7f6">付款类型</label>
                                        </div>
                                    </div>
                                    <div class="Editor SingleSelect" data-editor-id="zf9e5ab672cd848fd955d5be6e6f9c7f6" data-rdp="zf9e5ab672cd848fd955d5be6e6f9c7f6">
                                        <div class="InputField">
                                            <asp:DropDownList ID="payment_type_id" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="Medium Column" style="margin-top: 81px;">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="z1e9e9ba049cc439384ab93a6245b1b59">采购订单号</label>
                                        </div>
                                    </div>
                                    <div class="Editor TextBox" data-editor-id="z1e9e9ba049cc439384ab93a6245b1b59" data-rdp="z1e9e9ba049cc439384ab93a6245b1b59">
                                        <div class="InputField">
                                            <input id="purchase_order_no" type="text" value="<%=thisExpense!=null?thisExpense.purchase_order_no:"" %>" name="purchase_order_no" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Column" style="width: 420px;">
                                <div class="Medium Column">
                                    <div class="Editor CheckBox">
                                        <div class="InputField">
                                            <div>
                                                <asp:CheckBox ID="hasReceipt" runat="server" />
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="zf52cfa5cc72b4c8db112251ee5ca5f22">有收据</label>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <div class="Medium Column"></div>
                            </div>
                        </div>
                    </div>
                    <div class="Normal Section" style="border: 1px solid #d3d3d3; margin: 0 10px 10px 10px; padding: 4px 0 4px 0;">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle3">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">关联...</span></div>
                            <div class="Middle"></div>
                            <div class="Spacer"></div>
                            <div class="Right"></div>
                        </div>
                        <div class="Content">
                            <div class="Normal Column">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="z9c9fbfcd09c6499486a042b19bab87bb">关联客户</label><span class="Required">*</span>
                                    </div>
                                </div>
                                <div class="Editor DataSelector" data-editor-id="z9c9fbfcd09c6499486a042b19bab87bb" data-rdp="z9c9fbfcd09c6499486a042b19bab87bb">
                                    <div class="InputField">
                                        <input id="account_id" type="text" value="<%=thisAccount==null?"":thisAccount.name %>" name="" /><a class="Button ButtonIcon IconOnly DataSelector NormalState" id="z9c9fbfcd09c6499486a042b19bab87bb_Button" tabindex="0" onclick="CallBackAcc()"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a><input id="account_idHidden" name="account_id" type="hidden" value="<%=thisAccount==null?"":thisAccount.id.ToString() %>" /><div class="ContextOverlayContainer" id="z9c9fbfcd09c6499486a042b19bab87bb_ContextOverlay">
                                            <div class="AutoComplete ContextOverlay">
                                                <div class="Active LoadingIndicator"></div>
                                                <div class="Content"></div>
                                            </div>
                                            <div class="AutoComplete ContextOverlay">
                                                <div class="Active LoadingIndicator"></div>
                                                <div class="Content"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Column" style="width: 420px;">
                                <div class="Medium Column">
                                    <div class="RadioButtonGroupContainer">
                                        <div class="RadioButtonGroupLabel">
                                            <div></div>
                                        </div>
                                        <div class="Editor RadioButton" data-editor-id="z5204d5aaa2b04ef89c4af5fc576a439aTicket" data-rdp="z5204d5aaa2b04ef89c4af5fc576a439aTicket">
                                            <div class="InputField">
                                                <div>
                                                    <asp:RadioButton ID="rbAssTask" runat="server" GroupName="AssWithType" />
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label for="z5204d5aaa2b04ef89c4af5fc576a439aTicket">关联工单</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="Editor RadioButton" data-editor-id="z5204d5aaa2b04ef89c4af5fc576a439aProject" data-rdp="z5204d5aaa2b04ef89c4af5fc576a439aProject">
                                            <div class="InputField">
                                                <div>
                                                    <asp:RadioButton ID="rbAssProTask" runat="server" GroupName="AssWithType" />
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label for="z5204d5aaa2b04ef89c4af5fc576a439aProject">关联项目任务</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="Editor RadioButton" data-editor-id="z5204d5aaa2b04ef89c4af5fc576a439aNone" data-rdp="z5204d5aaa2b04ef89c4af5fc576a439aNone">
                                            <div class="InputField">
                                                <div>
                                                    <asp:RadioButton ID="rbAssNone" runat="server" GroupName="AssWithType" />
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label for="z5204d5aaa2b04ef89c4af5fc576a439aNone">不关联</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="Medium Column">
                                    <div class="EditorLabelContainer Inactive AssTicket">
                                        <div class="Label">
                                            <label for="z23a2329a1ce6401a87c17dd2c6cca73b">工单</label><span class="Required Off">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor DataSelector Inactive AssTicket" data-editor-id="z23a2329a1ce6401a87c17dd2c6cca73b" data-rdp="z23a2329a1ce6401a87c17dd2c6cca73b">
                                        <div class="InputField">
                                            <input id="ticket_id" type="text" value="" /><a class="Button ButtonIcon IconOnly DataSelector DisabledState" id="z23a2329a1ce6401a87c17dd2c6cca73b_Button" tabindex="0"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a><input id="ticket_idHidden" name="ticket_id" type="hidden" value="" /><div class="ContextOverlayContainer" id="z23a2329a1ce6401a87c17dd2c6cca73b_ContextOverlay">
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                    <div class="EditorLabelContainer AssProTask">
                                        <div class="Label">
                                            <label for="z3bf30fe543f4458188fa59026dfa9adb">项目</label><span class="Required">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor DataSelector field-validation-error AssProTask">
                                        <div class="InputField">
                                            <input id="project_id" type="text" value="" name="" /><a class="Button ButtonIcon IconOnly DataSelector NormalState" id="z3bf30fe543f4458188fa59026dfa9adb_Button" tabindex="0"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a><input id="project_idHidden" name="project_id" type="hidden" value="" />
                                            <div class="ContextOverlayContainer" id="z3bf30fe543f4458188fa59026dfa9adb_ContextOverlay">
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer AssProTask">
                                        <div class="Label">
                                            <label for="z0f3c5068b095471b853ce2aac2a5caaa">任务</label>
                                        </div>
                                    </div>
                                    <div class="Editor SingleSelect AssProTask">
                                        <div class="InputField">
                                            <select id="task_id" name="task_id">
                                                <option title="" value=""></option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../Scripts/common.js"></script>
<script>
    var colors = ["#efefef", "white"];
    var index1 = 0; var index2 = 0; var index3 = 0;
    $(".Toggle1").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index1 % 2]);
        index1++;
    });
    $(".Toggle2").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index2 % 2]);
        index2++;
    });
    $(".Toggle3").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index3 % 2]);
        index3++;
    });

</script>
<script>
    $(function () {
        if ($("#RDAddRep").is(":checked")) {
            $(".AddNewRep").show();
            $(".AddExyRep").hide();
        } else {
            $(".AddExyRep").show();
            $(".AddNewRep").hide();
        }
        ShowDivByCostCode();

        if ($("#rbAssTask").is(":checked")) {
            $(".AssTicket").show();
            $(".AssProTask").hide();
        } else if ($("#rbAssProTask").is(":checked")) {
            $(".AssTicket").hide();
            $(".AssProTask").show();
        } else {
            $(".AssTicket").hide();
            $(".AssProTask").hide();
        }

        <%if (thisProject != null)
    { %>
        $("#project_idHidden").val('<%=thisProject.id %>');
        $("#project_id").val('<%=thisProject.name %>');
        GetTaskByProId();
        <%if (thisTask != null)
    { %>
        var isHasTas = $("#task_id option[value='<%=thisTask.id %>']").val();
        if (isHasTas == undefined) {
            $("#task_id").append("<option value='<%=thisTask.id.ToString() %>' selected><%=thisTask.title %></option>");
        } else {
            $("#task_id").val("<%=thisTask.id %>");
        }
        <%}%>
        <%} %>
    })

    $("#CancelButton").click(function () {
        window.close();
    })
    $("#RDAddRep").click(function () {
        $(".AddNewRep").show();
        $(".AddExyRep").hide();
    })
    $("#RDAddExiRep").click(function () {
        $(".AddExyRep").show();
        $(".AddNewRep").hide();
    })

    $("#expense_cost_code_id").change(function () {
        ShowDivByCostCode();
        // mileage_reimbursement_rate
        // d_cost_code_rule 金额从这里获取
        var thisCodeId = $(this).val();
        if (thisCodeId != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/GeneralAjax.ashx?act=costCodeRule&code_id=" + thisCodeId,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.max != "" && data.max != null) {
                            $("#moneyDiv").show();
                            $("#money").html(toDecimal2(data.max));
                            $("#moneyHidden").val(data.max);
                        } else {
                            $("#moneyDiv").hide();
                            $("#money").html("");
                            $("#moneyHidden").val("");
                        }
                        var overdraft_policy_id = data.overdraft_policy_id;  // 费用炒制政策
                        $("#overdraft_policy_id").val(overdraft_policy_id);

                    } else {
                        $("#moneyDiv").hide();
                        $("#money").html("");
                        $("#moneyHidden").val("");
                        $("#overdraft_policy_id").val("");
                    }
                },
            });
        }


    })

    function ShowDivByCostCode() {
        // ENTERTAINMENT_EXPENSE  MILEAGE
        var thisCodeId = $("#expense_cost_code_id").val();
        if (thisCodeId != "" && thisCodeId != "0") {
            if (thisCodeId == "<%=(int)EMT.DoneNOW.DTO.CostCode.MILEAGE %>") {

                $("#enterDiv").show();
                $("#locationDiv").hide();

                // 获取物料代码相关信息，返回费率
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/QuoteAjax.ashx?act=costCode&id=" + thisCodeId,
                    dataType: "json",
                    success: function (data) {
                        if (data != "" && data.mileage_reimbursement_rate != "" && data.mileage_reimbursement_rate != null) {
                            $("#rate").val(toDecimal2(data.mileage_reimbursement_rate));
                        } else {
                            $("#rate").val("0.00");
                        }
                    },
                });
                $("#amount").attr("readonly");
            } else {
                $("#amount").removeAttr("readonly");
                $("#enterDiv").hide();
                if (thisCodeId == "<%=(int)EMT.DoneNOW.DTO.CostCode.ENTERTAINMENT_EXPENSE %>") {
                    $("#locationDiv").show();
                } else {
                    $("#locationDiv").hide();
                }
            }
        }
    }

    $("#odometer_start").blur(function () {
        var odometer_end = $("#odometer_end").val();
        var odometer_start = $("#odometer_start").val();
        if (odometer_end != "" && odometer_start != "") {
            var miles = Number(odometer_end) - Number(odometer_start);
            $("#miles").val(toDecimal2(miles));
            JiSuanAmount();
        }
    })

    $("#miles").blur(function () {
        //var odometer_end = $("#odometer_end").val();
        var odometer_start = $("#odometer_start").val();
        var miles = $("#miles").val();
        if (miles != "" && odometer_start != "") {
            var odometer_end = Number(miles) + Number(odometer_start);
            $("#odometer_end").val(toDecimal2(odometer_end));
            JiSuanAmount();
        }
    })
    $(".decimal2").blur(function () {
        var value = $(this).val();
        if (!isNaN(value) && value != "") {
            $(this).val(toDecimal2(value));
        } else {
            $(this).val("");
        }
    })
    $("#odometer_end").blur(function () {
        var odometer_end = $("#odometer_end").val();
        var odometer_start = $("#odometer_start").val();
        //var miles = $("#miles").val();
        if (odometer_end != "" && odometer_start != "") {
            var miles = Number(odometer_end) - Number(odometer_start);
            $("#miles").val(toDecimal2(miles));
            JiSuanAmount();
        }
    })
    // 计算页面上的总额相关
    function JiSuanAmount() {
        var odometer_start = $("#odometer_start").val();
        var odometer_end = $("#odometer_end").val();
        var rate = $("#rate").val();
        if (odometer_start != "" && odometer_end != "") {
            var miles = Number(odometer_end) - Number(odometer_start);
            var amount = miles * rate;
            $("#miles").val(toDecimal2(miles));
            $("#amount").val(toDecimal2(amount));
        }
    }
    $("#rbAssTask").click(function () {
        $(".AssTicket").show();
        $(".AssProTask").hide();
    })
    $("#rbAssProTask").click(function () {
        $(".AssTicket").hide();
        $(".AssProTask").show();
    })
    $("#rbAssNone").click(function () {
        $(".AssTicket").hide();
        $(".AssProTask").hide();
    })
    // 报表查找带回 135,122，1543
    function CallBackExpRep() {
        // expense_report_id
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRO_EXPENSE_REPORT_CALLBACK %>&field=expense_report_id", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKPHASE_CALLBACK %>&con993=<%=GetLoginUserId() %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 提交校验
    function SubmitCheck() {
        if ($("#RDAddRep").is(":checked")) {
            var title = $("#title").val();
            if (title == "") {
                LayerMsg("请填写新建报表名称");
                return false;
            }
            var end_date = $("#end_date").val();
            if (end_date == "") {
                LayerMsg("请填写周期结束日期");
                return false;
            }
        } else if ($("#RDAddExiRep").is(":checked")) {
            var expense_report_idHidden = $("#expense_report_idHidden").val();
            if (expense_report_idHidden == "") {
                LayerMsg("请通过查找带回选择报表");
                return false;
            }
        } else {
            LayerMsg("请选择新增费用报表方式");
            return false;
        }
        var add_date = $("#add_date").val();
        if (add_date == "") {
            LayerMsg("请填写日期");
            return false;
        }
        var expense_cost_code_id = $("#expense_cost_code_id").val();
        if (expense_cost_code_id == "" || expense_cost_code_id == "0") {
            LayerMsg("请填写类别");
            return false;
        }
        if (expense_cost_code_id == "<%=(int)EMT.DoneNOW.DTO.CostCode.MILEAGE %>") {
            var from_loc = $("#from_loc").val();
            if (from_loc == "") {
                LayerMsg("请填写起点");
                return false;
            }
            var to_loc = $("#to_loc").val();
            if (to_loc == "") {
                LayerMsg("请填写终点");
                return false;
            }
            var miles = $("#miles").val();
            if (miles == "") {
                LayerMsg("请填写里程");
                return false;
            }
        }
        var amount = $("#amount").val();
        if (amount == "") {
            LayerMsg("请填写收据总额");
            return false;
        }
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden == "") {
            LayerMsg("请选择关联客户");
            return false;
        }
        if ($("#rbAssTask").is(":checked")) {
            var ticket_idHidden = $("#ticket_idHidden").val();
            if (ticket_idHidden == "") {
                LayerMsg("请选择工单");
                return false;
            }
        }
        else if ($("#rbAssProTask").is(":checked")) {
            var project_idHidden = $("#project_idHidden").val();
            if (project_idHidden == "") {
                LayerMsg("请选择项目");
                return false;
            }
        } else {
            if (!$("#rbAssNone").is(":checked")) {
                LayerMsg("请选择关联方式");
                return false;
            }
        }

        var overdraft_policy_id = $("#overdraft_policy_id").val();
        var hasReceipt = $("#hasReceipt").is(":checked");
        if (overdraft_policy_id != "" && overdraft_policy_id != null) {
            var moneyHidden = $("#moneyHidden").val();
            if (moneyHidden != "" && (!isNaN(moneyHidden))) {
                if (Number(amount) > Number(moneyHidden)) {
                    if (overdraft_policy_id == "<%=(int)EMT.DoneNOW.DTO.DicEnum.EXPENSE_OVERDRAFT_POLICY.ALLOW_ALL_WARNING %>") {
                        LayerMsg("费用超出限制");
                        LayerConfirm("费用超出限制,是否继续？", "是", "否", function () { }, function () { return false; });
                    }
                    else if (overdraft_policy_id == "<%=(int)EMT.DoneNOW.DTO.DicEnum.EXPENSE_OVERDRAFT_POLICY.ALLOW_WITH_RECEIPT %>") {
                        if (!hasReceipt) {
                            LayerMsg("费用超出限制，必须有收据");
                            return false;
                        }
                    }
                    else if (overdraft_policy_id == "<%=(int)EMT.DoneNOW.DTO.DicEnum.EXPENSE_OVERDRAFT_POLICY.NOT_OVERDRAFT %>") {
                        LayerConfirm("费用超出限制，将保存为最大限额，是否继续", "是", "否", function () { $("#amount").val(amount); }, function () { return false; });
                    }
                }
            }
            if (overdraft_policy_id == "<%=(int)EMT.DoneNOW.DTO.DicEnum.EXPENSE_OVERDRAFT_POLICY.RECEIPT_REQUIRED_ALWAYS %>") {
                if (!hasReceipt) {
                    LayerMsg("费用必须有收据");
                    return false;
                }
            }
        }
        return true;
    }

    $("#save_close").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    $("#save_new").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    // 项目查找带回 
    function CallBackPro() {
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_CALLBACK %>&field=project_id&con997=" + account_idHidden, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKPHASE_CALLBACK %>&con993=<%=GetLoginUserId() %>', 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择关联客户");
        }

    }
    // 客户查找带回
    function CallBackAcc() {
        window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=account_id', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKPHASE_CALLBACK %>&con993=<%=GetLoginUserId() %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 当前项目的客户是否是查找带回的客户
    function ProIsAcc() {
        var project_idHidden = $("#project_idHidden").val();
        var account_idHidden = $("#account_idHidden").val();
        if (project_idHidden != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=GetSinProject&project_id=" + project_idHidden,
                dataType: "json",
                success: function (data) {
                    if (data != "" && data.account_id == account_idHidden) {

                    } else {
                        $("#project_idHidden").val("");
                        $("#project_id").val("");
                        GetTaskByProId();
                    }
                },
            });
        }
    }

    function GetTaskByProId() {

        var project_idHidden = $("#project_idHidden").val();
        var taskHtml = "<option value=''> </option>";
        if (project_idHidden != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=GetProTaskList&project_id=" + project_idHidden,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            taskHtml += "<option value='" + data[i].id + "'>" + data[i].title + "</option>";
                        }
                    }
                },
            });
        }
        else {

        }
        $("#task_id").html(taskHtml);
    }

</script>


