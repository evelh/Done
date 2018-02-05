<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketManage.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.TicketManage" ValidateRequest="false"  %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/Ticket.css" rel="stylesheet" />
    <title><%=isAdd?"新增":"编辑" %>工单</title>
    <style>
        .clickBtn {
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            font-size: 12px;
            font-weight: bold;
            line-height: 24px;
            padding: 0 1px 0 3px;
            color: #4F4F4F;
            vertical-align: top;
        }
    </style>
</head>
<body class="Linen AutotaskBlueTheme FullScroll EntityPage EntityNew">
    <form id="form1" runat="server">
        <!-- 上方 标题 按钮等 -->
        <div class="PageHeadingContainer" style="z-index: 2;">
            <div class="HeaderRow">
                <table>
                    <tbody>
                        <tr>
                            <td><span><%=isAdd?"新增":"编辑" %>工单</span></td>
                            <td align="right" class="helpLink"><a class="HelperLinkIcon" title=""></a></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar">
                <ul>
                    <li style="margin-left: 14px;">
                        <a class="ImgLink">
                            <span class="icon" style="background-image: url(../Images/print.png); width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                            <span class="Text" style="line-height: 24px;">
                                <asp:Button ID="save" runat="server" Text="保存" BorderStyle="None" CssClass="clickBtn" OnClick="save_Click" /></span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- 下左 快捷添加相应操作（编辑 查看会触发相应事件） -->
        <div class="QuickLaunchBar" style="top: 82px;">
            <div class="QuickLaunchButton TimeEntry DisabledState" id="" onclick="AddTimeEntry()">
                <div class="Text">工时<span class="KeyCode"></span></div>
                <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -15px;"></div>
            </div>
            <div class="QuickLaunchButton Note DisabledState" onclick="AddTicketNote('')">
                <div class="Text">备注<span class="KeyCode"></span></div>
                <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -64px;"></div>
            </div>
            <div class="QuickLaunchButton Attachment DisabledState" onclick="AddTicketAttachment()">
                <div class="Text">附件<span class="KeyCode"></span></div>
                <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -113px;"></div>
            </div>
            <div class="QuickLaunchButton Charge DisabledState" onclick="AddTicketCharge()">
                <div class="Text">成本<span class="KeyCode"></span></div>
                <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -163px;"></div>
            </div>
            <div class="QuickLaunchButton Expense DisabledState" onclick="AddTicketExpense()">
                <div class="Text">费用<span class="KeyCode"></span></div>
                <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -212px;"></div>
            </div>
            <div class="QuickLaunchButton ServiceCall DisabledState">
                <div class="Text">服务<span class="KeyCode"></span></div>
                <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -260px;"></div>
            </div>
            <div class="QuickLaunchButton ToDo DisabledState">
                <div class="Text">待办<span class="KeyCode"></span></div>
                <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -309px;"></div>
            </div>
        </div>

        <!-- 下右 管理相关 属性 字段 -->
        <div class="MessageBarContainer" id="ShowAlert">
            <div class="MessageBar Alert">
                <div class="IconContainer">
                    <div class="MessageBarIcon Alert"></div>
                </div>
                <div class="Content FormatPreservation Left" id="ShowTicketAlert">
                </div>
            </div>
            <div class="MessageBar Alert">
                <div class="IconContainer">
                    <div class="MessageBarIcon Alert"></div>
                </div>
                <div class="Content FormatPreservation Left" id="ShowTicketDetail">
                </div>
            </div>
        </div>
        <div class="MainContainer InsightsEnabled" style="margin-left: 45px; z-index: 0;">
            <div class="SecondaryContainer Left Active" id="z91f4b4ab746e4bd4be9d1c4412a64c27">
                <div class="TabButtonContainer">
                    <div>
                        <div class="TabButton EntityPageTabIcon Details Active">
                            <div class="Icon"></div>
                            <div class="Text">详情</div>
                        </div>
                    </div>
                    <div>
                        <div class="TabButton EntityPageTabIcon Insights" onclick="autotask.findPage().__toggleSecondaryContainer();">
                            <div class="Icon"></div>
                            <div class="Text">Insights</div>
                        </div>
                    </div>
                </div>
                <div class="DetailsSection">
                    <div class="Content">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>客户</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="BundleContainer">
                            <div class="EditorContainer">
                                <div class="Editor DataSelector">
                                    <div class="InputField">
                                        <input id="account_id" type="text" value="<%=thisAccount==null?"":thisAccount.name %>" />
                                        <input type="hidden" id="account_idHidden" name="account_id" value="<%=thisAccount==null?"":thisAccount.id.ToString() %>" />
                                        <a class="Button ButtonIcon IconOnly New NormalState" id="" tabindex="0" style="display: inline-grid; width: 17px;" onclick="CallBackAccount()">
                                            <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span>
                                            <span class="Text"></span>
                                        </a>

                                        <a class="Button ButtonIcon IconOnly New NormalState" id="" tabindex="0" style="display: inline-grid; width: 17px;" onclick="ShowAccNoTicket()">
                                            <span class="Icon" style="background: url(../Images/Icons.png) no-repeat -149px -142px;"></span>
                                            <span class="Text"></span>
                                        </a>
                                        <a class="Button ButtonIcon IconOnly New NormalState" id="" tabindex="0" style="display: inline-grid; width: 17px;" onclick="AddAccount()">
                                            <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span>
                                            <span class="Text"></span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>联系人</label>
                            </div>
                        </div>
                        <div class="BundleContainer">
                            <div class="EditorContainer">
                                <div class="Editor SingleDataSelector">
                                    <div class="InputField">
                                        <input type="text" id="contact_id" style="width: 73%;" value="<%=thisContact==null?"":thisContact.name %>" />
                                        <input type="hidden" id="contact_idHidden" name="contact_id" value="<%=thisContact==null?"":thisContact.id.ToString() %>" />
                                        <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="SelectContact" tabindex="0" style="display: inline-grid; width: 17px;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                        <a class="Button ButtonIcon IconOnly New NormalState" id="AddContact" tabindex="0" style="display: inline-grid; width: 17px;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>状态</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor ItemSelector">
                            <asp:DropDownList ID="status_id" runat="server"></asp:DropDownList>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>优先级</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor ItemSelector DisplayMode">
                            <asp:DropDownList ID="priority_type_id" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="DetailsSection" id="">
                    <div class="Title Title1">
                        <div class="Text">工单信息</div>
                        <div class="Toggle">
                            <div class="InlineIcon ArrowUp"></div>
                        </div>
                    </div>
                    <div class="Content">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>问题类型</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor ItemSelector DisplayMode">
                            <asp:DropDownList ID="issue_type_id" runat="server"></asp:DropDownList>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>子问题类型</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor ItemSelector DisplayMode">
                            <select id="sub_issue_type_id" name="sub_issue_type_id"></select>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>工单来源</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor ItemSelector">
                            <asp:DropDownList ID="source_type_id" runat="server"></asp:DropDownList>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>截止日期</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="DateAndTimeEditor">
                            <div class="Editor DateBox" style="float: left;">
                                <div class="InputField">
                                    <div class="Container">
                                        <input id="DueDate" type="text" value="<%=thisTicket!=null&&thisTicket.estimated_end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.estimated_end_time).ToString("yyyy-MM-dd"):"" %>" name="DueDate" onclick="WdatePicker()" style="width: 100px;" />
                                    </div>
                                </div>
                            </div>
                            <div class="Editor TimeBox">
                                <div class="InputField">
                                    <div class="Container">
                                        <input id="DueTime" type="text" value="<%=thisTicket!=null&&thisTicket.estimated_end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.estimated_end_time).ToString("HH:mm:ss"):"" %>" name="DueTime" onclick="WdatePicker({ dateFmt: 'HH:mm:ss' })" style="width: 70px; margin-left: 10px;" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>预估时间（小时）</label>
                            </div>
                        </div>
                        <div class="Editor DecimalBox">
                            <div class="InputField">
                                <input id="estimated_hours" type="text" value="<%=thisTicket!=null?thisTicket.estimated_hours.ToString("#0.00"):"" %>" name="estimated_hours" maxlength="11" style="width: 90%;" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="">服务等级协议</label>
                            </div>
                        </div>
                        <div class="Editor ItemSelector" id="">
                            <asp:DropDownList ID="sla_id" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="DetailsSection" id="zb708368cb08a4a639fca44332944c45c">
                    <div class="Title Title2">
                        <div class="Text">分配信息</div>
                        <div class="Toggle">
                            <div class="InlineIcon ArrowUp"></div>
                        </div>
                    </div>
                    <div class="Content">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>队列</label>
                            </div>
                        </div>
                        <div class="Editor ItemSelector DisplayMode" id="">
                            <asp:DropDownList ID="department_id" runat="server"></asp:DropDownList>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>主负责人</label>
                            </div>
                        </div>
                        <div class="BundleContainer">
                            <div class="EditorContainer">
                                <div class="Editor SingleDataSelector">
                                    <div class="ContentContainer" style="float: left; width: 55%;">
                                        <div class="ValueContainer">
                                            <div class="InputContainer">
                                                <input id="owner_resource_id" type="text" value="<%=proResDep!=null&&priRes!=null?priRes.name:"" %>" name="" style="width: 100%;" />
                                                <input type="hidden" id="owner_resource_idHidden" name="owner_resource_id" value="<%=proResDep!=null&&priRes!=null?proResDep.id.ToString():"" %>" />
                                                <%--<input id="role_id" name="role_id" type="hidden" />--%>
                                            </div>
                                        </div>
                                    </div>
                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" tabindex="0" style="display: inline-grid; width: 17px; height: 32px; margin-left: 22px; margin-top: 4px;" onclick="ChoosePriRes()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                    <a class="Button ButtonIcon IconOnly Search NormalState" id="" tabindex="0" style="display: inline-grid; width: 17px;">
                                        <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span>
                                        <span class="Text"></span>
                                    </a>
                                    <a class="Button ButtonIcon IconOnly Demote DisabledState" id="" tabindex="0" style="display: inline-grid; width: 17px;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a>
                                </div>
                            </div>

                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>其他负责人</label>
                            </div>
                        </div>
                        <div class="BundleContainer" style="display: inline-block; width: 100%;">
                            <div class="EditorContainer">
                                <div class="Editor MultipleDataSelector" id="">
                                    <div class="ContentContainer" style="display: inline-grid; width: 80%;">
                                        <div class="ValueContainer">
                                            <div class="InputContainer">
                                                <input id="" type="text" value="" name="SecondaryResources" style="width: 100%;" />
                                            </div>
                                        </div>
                                    </div>
                                    <input id="OtherResId" type="hidden" />
                                    <input id="OtherResIdHidden" name="OtherResId" type="hidden" value="<%=ticketResIds %>" />
                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" tabindex="0" style="display: inline-grid; width: 17px; height: 31px; margin-top: 12px; margin-left: 6%;" onclick="OtherResCallBack()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                    <div class="BubbleList" id=""></div>
                                    <a class="Button ButtonIcon IconOnly Swap DisabledState" id="" tabindex="0" style="display: inline-grid; width: 17px;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a>
                                </div>
                            </div>
                            <select multiple="multiple" id="otherRes" style="height: 110px; width: 85%; float: left;">
                            </select>
                            <div class="IconButtonContainer" style="display: none;"><a class="Button ButtonIcon IconOnly Search NormalState" id="" tabindex="0" style="display: inline-grid; width: 17px; height: 30px;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a></div>
                        </div>
                    </div>
                </div>
                <div class="DetailsSection" id="">
                    <div class="Title Title3">
                        <div class="Text">配置项信息</div>
                        <div class="Toggle">
                            <div class="InlineIcon ArrowUp"></div>
                        </div>
                    </div>
                    <div class="Content">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>配置项</label>
                            </div>
                        </div>
                        <div class="BundleContainer">
                            <div class="EditorContainer">
                                <div class="Editor BrowseOnly SingleDataSelector">
                                    <div class="ContentContainer">
                                        <div class="ValueContainer">

                                            <div class="InputContainer">
                                                <% string proName = "";
                                                    if (insPro != null)
                                                    {
                                                        var produ = new EMT.DoneNOW.DAL.ivt_product_dal().FindNoDeleteById(insPro.product_id);
                                                        proName = produ == null ? "" : produ.name;
                                                    }%>
                                                <input id="installed_product_id" type="text" value="<%=proName %>" name="ConfigurationItem" style="width: 80%;" />
                                                <input id="installed_product_idHidden" name="installed_product_id" type="hidden" value="<%=insPro == null ? "" : insPro.id.ToString() %>" />
                                            </div>
                                        </div>
                                    </div>
                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                </div>
                            </div>
                            <div class="IconButtonContainer"><a class="Button ButtonIcon IconOnly ContactPhoto DisabledState" tabindex="0" style="display: inline-grid; width: 17px; height: 34px;" onclick="InsProCallBack()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a></div>
                        </div>
                    </div>
                </div>
                <div class="DetailsSection">
                    <div class="Title Title4">
                        <div class="Text">计费信息</div>
                        <div class="Toggle">
                            <div class="InlineIcon ArrowUp"></div>
                        </div>
                    </div>
                    <div class="Content">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>合同</label>
                            </div>
                        </div>
                        <div class="Editor DataSelector">
                            <div class="InputField">
                                <input id="contract_id" type="text" value="<%=thisContract==null?"":thisContract.name %>" style="width: 85%;" />
                                <a class="Button ButtonIcon IconOnly DataSelector NormalState" tabindex="0" style="display: inline-grid; width: 17px;" id="ContractBack">
                                    <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span>
                                </a>
                                <input id="contract_idHidden" name="contract_id" type="hidden" value="<%=thisContract==null?"":thisContract.id.ToString() %>" />
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>服务/服务包</label>
                            </div>
                        </div>
                        <div class="Editor Disabled Locked ItemSelector">
                            <select id="service_id" name="service_id"></select>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>工作类型</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor DataSelector">
                            <div class="InputField">
                                <input id="cost_code_id" type="text" value="<%=thisCostCode==null?"":thisCostCode.name %>" class="" />
                                <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" tabindex="0" style="display: inline-grid; width: 17px;" onclick="WorkTypeCallBack()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                <input id="cost_code_idHidden" name="cost_code_id" type="hidden" value="<%=thisCostCode==null?"":thisCostCode.id.ToString() %>" />

                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>采购订单号</label>
                            </div>
                        </div>
                        <div class="Editor TextBox">
                            <div class="InputField">
                                <input id="purchase_order_no" type="text" value="<%=thisTicket==null?"":thisTicket.purchase_order_no  %>" name="purchase_order_no" style="width: 90%;" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="PrimaryContainer" style="width: 50%; min-width: 500px; padding-left: 15px;">
                <div>
                    <div class="HeadingContainer">
                        <div class="IdentificationContainer">
                            <div class="Left">
                                <div>
                                    <div class="CategoryEditorContainer" style="float: left; width: 25%; padding-top: 20px;">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>工单种类</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor ItemSelector">
                                            <asp:DropDownList ID="cate_id" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="TypeEditorContainer" style="float: left; width: 25%; margin-left: 15px; padding-top: 20px;">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>工单类型</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor ItemSelector">
                                            <asp:DropDownList ID="ticket_type_id" runat="server"></asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Right" style="padding-top: 20px; margin-right: 10px;">
                                <div class="StopwatchContainer" id="z5ee7a7916f704609bc740835fa09b403">
                                    <div class="StopwatchTime"><span id="ShowWatchTime">00:00:00</span></div>
                                    <div class="StopwatchButton StopwatchIcon Normal noplay Pause" id="PlayTimeDiv"></div>
                                    <div class="StopwatchButton StopwatchIcon Normal Record" onclick="stop()" style="background: url(../Images/play.png) no-repeat -66px -1px;"></div>
                                    <div class="StopwatchButton StopwatchIcon Normal Stop" onclick="Reset()" style="background: url(../Images/play.png) no-repeat -101px -1px;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="EditorLabelContainer" style="clear: both;">
                            <div class="Label">
                                <label>工单标题</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor AdjustingTextBox">
                            <div class="InputField">
                                <input type="text" id="title" name="title" value="<%=thisTicket==null?"":thisTicket.title %>" style="width: 97%; margin-right: 15px;" />
                            </div>
                        </div>
                    </div>
                    <div class="Divider">
                        <div class="Line"></div>
                    </div>
                    <div class="BodyContainer" style="margin-left: -20px;">
                        <div class="Normal Section" id="z65a6cc9453c84fcb82ba4d812b8e060f">
                            <div class="Heading" data-toggle-enabled="true">
                                <div class="Toggle Collapse Toggle1">
                                    <div class="Vertical"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <div class="Left"><span class="Text">描述</span></div>
                                <div class="Middle"></div>
                                <div class="Spacer"></div>
                                <div class="Right"></div>
                            </div>
                            <div class="Content">
                                <div class="Editor TextArea" style="padding-left: 0px; padding-top: 10px;">
                                    <div class="InputField">
                                        <textarea class="Medium" id="description" name="description" style="width: 100%;"><%=thisTicket==null?"":thisTicket.description %></textarea>
                                    </div>
                                    <div class="CharacterInformation"><span class="CurrentCount">0</span>/<span class="Maximum">8000</span></div>
                                </div>
                            </div>
                        </div>
                        <div class="Normal Section EntityBodyGridSection" id="z3f55565a3b6c4a8abc7ed706c437ea5b">
                            <div class="Heading" data-toggle-enabled="true">
                                <div class="Toggle Collapse Toggle2">
                                    <div class="Vertical"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <div class="Left"><span class="Text">检查单</span></div>
                                <div class="Middle"></div>
                                <div class="Spacer"></div>
                                <div class="Right"></div>
                            </div>
                            <div class="DescriptionText"><%--You may enter up to 20 total items (ad-hoc, from a saved Library checklist, or a mixture of both).--%> 最多可以添加20个检查单。</div>
                            <div class="Content">
                                <div class="ToolBar">
                                    <div class="ToolBarItem Left ButtonGroupStart"><a class="Button ButtonIcon New NormalState" id="AddCheckListButton" tabindex="0"><span class="Icon"></span><span class="Text">新增检查单</span></a></div>
                                    <div class="ToolBarItem Left"><a class="Button ButtonIcon NormalState" id="AddCheckListFromLibraryButton" tabindex="0"><span class="Icon"></span><span class="Text">从知识库添加</span></a></div>
                                    <div class="ToolBarItem Left ButtonGroupEnd"><a class="Button ButtonIcon NormalState" id="SaveToLibraryButton" tabindex="0"><span class="Icon"></span><span class="Text">保存到知识库</span></a></div>
                                    <div class="Spacer"></div>
                                </div>
                                <div class="Grid Small" id="TicketChecklistItemsGrid">
                                    <div class="HeaderContainer">
                                        <table cellpadding="0">
                                            <thead class="HeaderContainer">
                                                <tr class="HeadingRow">
                                                    <td class=" Interaction DragEnabled" style="width: 60px;">
                                                        <div class="Standard"></div>
                                                    </td>
                                                    <td class=" Context" style="width: 20px;">
                                                        <div class="Standard">
                                                            <div></div>
                                                        </div>
                                                    </td>
                                                    <td class=" Image" style="width: 20px;">
                                                        <div class="Standard">
                                                            <div class="BookOpen ButtonIcon">
                                                                <div class="Icon"></div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class=" Boolean" style="text-align: center;">
                                                        <div class="Standard">
                                                            <div class="Heading">完成</div>
                                                        </div>
                                                    </td>
                                                    <td class=" Text Dynamic">
                                                        <div class="Standard">
                                                            <div class="Heading">条目</div>
                                                        </div>
                                                    </td>
                                                    <td class=" Boolean" style="text-align: center;">
                                                        <div class="Standard">
                                                            <div class="Heading">重要</div>
                                                        </div>
                                                    </td>
                                                    <%--<td class="ScrollBarSpacer" style="width: 19px;"></td>--%>
                                                </tr>
                                            </thead>
                                            <div class="cover"></div>
                                            <tbody id="Drap" class="Drap RowContainer BodyContainer">
                                                <div class="border_left">
                                                </div>
                                                <div class="border_right">
                                                </div>
                                                <div class="border-line"></div>
                                                <% if (ticketCheckList != null && ticketCheckList.Count > 0)
                                                    {
                                                        int num = 0;
                                                        foreach (var item in ticketCheckList)
                                                        {
                                                            num++;
                                                %>
                                                <tr data-val="<%=item.id %>" id="<%=item.id %>" class="HighImportance D" draggable="true">
                                                    <td class="Interaction">
                                                        <div>
                                                            <div class="Decoration Icon DragHandle">
                                                            </div>
                                                            <div class="Num"><%=item.sort_order==null?"":((decimal)item.sort_order).ToString("#0") %></div>
                                                            <input type="hidden" id="<%=item.id %>_sort_order" name="<%=item.id %>_sort_order" value="<%=item.sort_order==null?"":((decimal)item.sort_order).ToString("#0") %>" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <a class="ButtonIcon Button ContextMenu NormalState ">
                                                            <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px; width: 15px; height: 15px;">
                                                            </div>
                                                        </a>
                                                    </td>
                                                    <td></td>
                                                    <td>
                                                        <%if (item.is_competed == 1)
                                                            { %>
                                                        <input type="checkbox" id="<%=item.id %>_is_complete" name="<%=item.id %>_is_complete" checked="checked" />
                                                        <%}
                                                        else
                                                        { %>
                                                        <input type="checkbox" id="<%=item.id %>_is_complete" name="<%=item.id %>_is_complete" />
                                                        <%} %>
                                                     

                                                    </td>
                                                    <td>
                                                        <input type="text" id="<%=item.id %>_item_name" name="<%=item.id %>_item_name" value="<%=item.item_name %>" /></td>
                                                    <td>
                                                        <%if (item.is_important == 1)
                                                            { %>
                                                        <input type="checkbox" id="<%=item.id %>_is_import" name="<%=item.id %>_is_import" checked="checked" />
                                                        <%}
                                                        else
                                                        { %>
                                                        <input type="checkbox" id="<%=item.id %>_is_import" name="<%=item.id %>_is_import" />
                                                        <%} %>
                                                    </td>
                                                </tr>
                                                <%
                                                        }
                                                    }
                                                    else
                                                    { %>
                                                <tr data-val="-1" id="-1" class="HighImportance D" draggable="true">
                                                    <td class="Interaction">
                                                        <div>
                                                            <div class="Decoration Icon DragHandle">
                                                            </div>
                                                            <div class="Num">1</div>
                                                            <input type="hidden" id="-1_sort_order" name="-1_sort_order" value="1" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <a class="ButtonIcon Button ContextMenu NormalState ">
                                                            <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px; width: 15px; height: 15px;">
                                                            </div>
                                                        </a>
                                                    </td>
                                                    <td></td>
                                                    <td>
                                                        <input type="checkbox" id="-1_is_complete" name="-1_is_complete" /></td>
                                                    <td>
                                                        <input type="text" id="-1_item_name" name="-1_item_name" /></td>
                                                    <td>
                                                        <input type="checkbox" id="-1_is_import" name="-1_is_import" /></td>

                                                </tr>
                                                <%} %>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="ScrollingContentContainer">
                                        <div class="NoDataMessage">未查询到相关数据</div>
                                        <div class="RowContainer BodyContainer" style="padding: 0;">
                                            <table cellpadding="0">
                                                <colgroup>
                                                    <col class=" Interaction">
                                                    <col class=" Context">
                                                    <col class="Width16 Image">
                                                    <col class=" Boolean">
                                                    <col class=" Text DynamicSizing" style="width: auto;">
                                                    <col class=" Boolean">
                                                </colgroup>
                                                <tbody>
                                                </tbody>
                                            </table>
                                            <input type="hidden" id="CheckListIds" name="CheckListIds" />
                                        </div>
                                    </div>
                                    <div class="FooterContainer"></div>
                                </div>
                            </div>
                        </div>
                        <%if (!isAdd && thisTicket != null){ %>
                        <div class="Normal Section Timeline">
                            <div class="Heading" data-toggle-enabled="true">
                                <div class="Toggle Collapse Toggle2">
                                    <div class="Vertical"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <div class="Left"><span class="Text">时间轴</span></div>
                                <div class="Middle"></div>
                                <div class="Spacer"></div>
                                <div class="Right"></div>
                            </div>
                            <div class="Content">
                                <div class="Timeline">
                                    <div class="Bar Top VerticalSize3">
                                        <%if (thisTicket.first_activity_time != null)
                                { %>
                                        <div class="Dot" style="left: calc(0% - 6px);">
                                            <div class="Pole VerticalSize3">
                                                <div class="Flag TargetAchieved Normal" id="z79439d23ded94c029599a3d7dd28627f">
                                                    <div class="Banner">
                                                        <div class="Triangle"></div>
                                                    </div>
                                                    <div class="Text">初次响应</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ContextOverlayContainer">
                                            <div class="TimelineContextOverlay ContextOverlay">
                                                <div class="Content">
                                                    <div class="Label">
                                                        <div class="TimelineIcon OverlayEventMet" style="background-position: -101px -1px;"></div>
                                                        <div class="Text Achieved">初次响应</div>
                                                    </div>
                                                    <div class="DateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.first_activity_time).ToString("yyyy-MM-dd HH:mm:ss") %></div>
                                                </div>
                                            </div>
                                        </div>
                                        <%} %>
                                        <%if (thisTicket.resolution_plan_actual_time != null)
                                { %>
                                        <div class="Dot" style="left: calc(79% - 6px);">
                                            <div class="Pole VerticalSize2">
                                                <div class="Flag TargetAchieved Reverse" id="z084300357f8a4995a1d13e2ae0a6220b">
                                                    <div class="Banner">
                                                        <div class="Triangle"></div>
                                                    </div>
                                                    <div class="Text">解决方案提供时间</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ContextOverlayContainer" id="z7efe3f18ca5b4d3c83ca253200492b48">
                                            <div class="TimelineContextOverlay ContextOverlay">
                                                <div class="Outline Arrow"></div>
                                                <div class="Arrow"></div>
                                                <div class="Content">
                                                    <div class="Label">
                                                        <div class="TimelineIcon OverlayEventMet"></div>
                                                        <div class="Text Achieved">解决方案提供时间</div>
                                                    </div>
                                                    <div class="DateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.resolution_plan_actual_time).ToString("yyyy-MM-dd HH:mm:ss") %></div>
                                                </div>
                                            </div>
                                        </div>
                                        <%} %>
                                        <%if (thisTicket.resolution_actual_time != null)
                                { %>
                                        <div class="Dot" style="left: calc(79% - 6px);z-index:1;">
                                            <div class="Pole VerticalSize1">
                                                <div class="Flag TargetAchieved Reverse" id="z5bc5fff464e34e689cdacf4990114637">
                                                    <div class="Banner">
                                                        <div class="Triangle"></div>
                                                    </div>
                                                    <div class="Text">解决时间</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ContextOverlayContainer" id="z4f42c44b95244db284b0a5dd5f8709e9">
                                            <div class="TimelineContextOverlay ContextOverlay">
                                                <div class="Outline Arrow"></div>
                                                <div class="Arrow"></div>
                                                <div class="Content">
                                                    <div class="Label">
                                                        <div class="TimelineIcon OverlayEventMet"></div>
                                                        <div class="Text Achieved">解决时间</div>
                                                    </div>
                                                    <div class="DateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.resolution_actual_time).ToString("yyyy-MM-dd HH:mm:ss") %></div>
                                                </div>
                                            </div>
                                        </div>
                                        <%} %>

                                        <%if (thisTicket.date_completed != null)
                                { %>
                                        <div class="Dot" style="left: calc(79% - 6px);">
                                            <div class="Pole VerticalSize0">
                                                <div class="Flag TargetAchieved Reverse" id="z3af3911af8374cd8a93aa6d8c31ef64f">
                                                    <div class="Banner">
                                                        <div class="Triangle"></div>
                                                    </div>
                                                    <div class="Text">完成时间</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ContextOverlayContainer">
                                            <div class="TimelineContextOverlay ContextOverlay">
                                                <div class="Outline Arrow"></div>
                                                <div class="Arrow"></div>
                                                <div class="Content">
                                                    <div class="Label">
                                                        <div class="TimelineIcon OverlayEventMet"></div>
                                                        <div class="Text Achieved">完成时间</div>
                                                    </div>
                                                    <div class="DateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.date_completed).ToString("yyyy-MM-dd HH:mm:ss") %></div>
                                                </div>
                                            </div>
                                        </div>
                                        <%} %>

                                        <div class="OccurrenceProgress" style="width: 79%;"></div>
                                        <div class="SlaBarIndicator" style="width: 0%;"></div>
                                    </div>
                                    <div class="Divider"></div>
                                    <div class="Bar Bottom">
                                        <div class="TimelineIcon TargetPointer" style="left: calc(81% - 3px);">
                                            <div class="TimelineIcon Target" id="z85414a86487245f1b11077ad0e2efce0"></div>
                                        </div>
                                        <div class="ContextOverlayContainer" id="zf27d5431cf07427691d3372edca92c29">
                                            <div class="TimelineContextOverlay ContextOverlay">
                                                <div class="Outline Arrow"></div>
                                                <div class="Arrow"></div>
                                                <div class="Content">
                                                    <div class="Label">
                                                        <div class="TimelineIcon OverlayTargetMet"></div>
                                                        <div class="Text Achieved">First Response</div>
                                                    </div>
                                                    <div class="DateTime">30/01/2018 09:27 AM</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="TimelineIcon TargetPointer" style="left: calc(89% - 3px);">
                                            <div class="TimelineIcon Target" id="z554f2ecf460e4b6797ee7b5b38bebf80"></div>
                                        </div>
                                        <div class="ContextOverlayContainer" id="z18fc40437a9e4a3cad5bc80e461c37f8">
                                            <div class="TimelineContextOverlay ContextOverlay">
                                                <div class="Outline Arrow"></div>
                                                <div class="Arrow"></div>
                                                <div class="Content">
                                                    <div class="Label">
                                                        <div class="TimelineIcon OverlayTargetMet"></div>
                                                        <div class="Text Achieved">Resolution Plan</div>
                                                    </div>
                                                    <div class="DateTime">30/01/2018 11:27 AM</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="TimelineIcon TargetPointer" style="left: calc(98% - 3px);">
                                            <div class="TimelineIcon Target" id="z1c4c3ca136d0466c8582986c7eb839a5"></div>
                                        </div>
                                        <div class="ContextOverlayContainer" id="z22fcaf4e90e24ddab5975b2bee67ea0f">
                                            <div class="TimelineContextOverlay ContextOverlay">
                                                <div class="Outline Arrow"></div>
                                                <div class="Arrow"></div>
                                                <div class="Content">
                                                    <div class="Label">
                                                        <div class="TimelineIcon OverlayTargetMet"></div>
                                                        <div class="Text Achieved">Resolution</div>
                                                    </div>
                                                    <div class="DateTime">30/01/2018 01:27 PM</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="TimelineIcon TargetPointer" style="left: calc(100% - 3px);">
                                            <div class="TimelineIcon Target" id="z4b018c06499842449f9c2f0a5cdbb24b"></div>
                                        </div>
                                        <div class="ContextOverlayContainer" id="zf8d2cfcad1fd4700817f7fd7fedebb41">
                                            <div class="TimelineContextOverlay ContextOverlay">
                                                <div class="Outline Arrow"></div>
                                                <div class="Arrow"></div>
                                                <div class="Content">
                                                    <div class="Label">
                                                        <div class="TimelineIcon OverlayTargetMet"></div>
                                                        <div class="Text Achieved">Complete</div>
                                                    </div>
                                                    <div class="DateTime">30/01/2018 01:54 PM</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="TargetProgress" style="width: 100%;"></div>
                                    </div>
                                    <div class="TicketSlaTimelineStart" style="z-index:1;">
                                        <%if (thisTicket.sla_start_time != null)
                                            {  %>
                                              
                                        <div class="TimelineIcon SlaStartLabel" style="background-position: -39px 4px; height: 19px; width: 19px;"></div>
                                        <%}
                                        else
                                        { %>
                                        <div class="TimelineIcon SlaStartLabel" style="background-position: -167px -1px; height: 19px; width: 19px;"></div>
                                        <%} %>
                                        
                                    </div>
                                    <div class="ContextOverlayContainer">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayTicketStart" style=""></div>
                                                    <div class="Text Normal">工单创建</div>
                                                </div>
                                                <% if (thisTicket.sla_start_time != null && thisTicket.sla_start_time == thisTicket.create_time)
                                { %>
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlaySla"></div>
                                                    <div class="Text OverlaySla">SLA Start</div>
                                                </div>
                                                <%} %>
                                                <div class="DateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisTicket.create_time).ToString("yyyy-MM-dd HH:mm:ss") %></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%} %>
                        <div class="Normal Section" id="z873ff391d2dd4c20b0943a02e97c4832">
                            <div class="Heading" data-toggle-enabled="true">
                                <div class="Toggle Collapse Toggle3">
                                    <div class="Vertical"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <div class="Left"><span class="Text">解决方案</span></div>
                                <div class="Middle"></div>
                                <div class="Spacer"></div>
                                <div class="Right"></div>
                            </div>
                            <div class="Content">
                                <div class="Editor TextArea">
                                    <div class="InputField">
                                        <textarea class="Medium" id="resolution" name="resolution" style="width: 100%;"><%=thisTicket==null?"":thisTicket.resolution %></textarea>
                                    </div>
                                    <div class="CharacterInformation"><span class="CurrentCount">0</span>/<span class="Maximum">32000</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="SecondaryContainer Right">
                <div class="TabButtonContainer">
                    <div>
                        <div class="TabButton EntityPageTabIcon Details" onclick="autotask.findPage().__toggleSecondaryContainer();">
                            <div class="Icon"></div>
                            <div class="Text">Details</div>
                        </div>
                    </div>
                    <div>
                        <div class="TabButton EntityPageTabIcon Insights Active">
                            <div class="Icon"></div>
                            <div class="Text">Insights</div>
                        </div>
                    </div>
                </div>
                <div class="InsightContainer" id="z2f17c82a79b54ecf86b9d5d2999110b6">
                    <div class="LoadingIndicator Transition Fade">
                        <div class="Icon"></div>
                    </div>
                    <div class="InsightShell Collapsed" id="za732b4150b1147c19e730b3785638172">
                        <div class="Title Title5">
                            <div class="Text">客户/联系人 </div>
                            <div class="Toggle">
                                <div class="InlineIcon ArrowUpSmall"></div>
                            </div>
                        </div>
                        <div class="ContentContainer">
                            <div class="LoadingIndicator"></div>
                            <div class="TransitionContainer Transition"></div>
                            <div class="Content">
                                <div class="LinkButton HighImportance ShowAccInfo"><a class="Button ButtonIcon Link NormalState" id="TranAccount"></a></div>
                                <div class="Bundle ShowAccInfo">
                                    <div class="LinkButton ShowAccInfo">
                                        <a class="Button ButtonIcon Link NormalState" id="TranAccSit"></a>

                                    </div>
                                </div>
                                <div class="NormalSpacer"></div>
                                <div class="Text Address ShowAccInfo" id="ShowAccAddress">

                                    <div class="InsightIconButton">
                                        <div class="InlineIconButton InlineIcon Map NormalState"></div>
                                    </div>
                                </div>
                                <div class="NormalSpacer"></div>
                                <div class="Text ShowAccInfo" id="AccPhone"></div>
                                <div class="Text ShowAccInfo"></div>
                                <div class="Text ShowAccInfo"></div>
                                <div class="NormalSpacer"></div>
                                <div class="LinkButton ShowAccInfo"><a class="Button ButtonIcon Link NormalState" id="AccTicketHref" tabindex="0"></a></div>
                                <div class="LinkButton ShowAccInfo">
                                    <a class="Button ButtonIcon Link NormalState" id="ShowLastTicket" tabindex="0"></a>
                                </div>
                                <div class="Divider">
                                    <div class="Line"></div>
                                </div>
                                <div class="Bundle">
                                    <div class="LinkButton HighImportance ShowContactInfo"><a class="Button ButtonIcon Link NormalState" id="TranContact" tabindex="0"></a></div>
                                    <div class="InsightIconButton" style="display: none;">
                                        <div class="InlineIconButton InlineIcon Note NormalState" id="zc52f76470ea54233a6c504a044665bef" title="Notify Contact: "></div>
                                    </div>
                                </div>
                                <div class="Text"></div>
                                <div class="NormalSpacer"></div>
                                <div class="Text ShowContactInfo" id="ContactPhone"></div>
                                <div class="LinkButton ShowContactInfo"><a class="Button Mailto Link" href="mailto:"></a></div>
                                <div class="NormalSpacer"></div>
                                <div class="LinkButton ShowContactInfo"><a class="Button ButtonIcon Link NormalState" id="TranContactTicket" tabindex="0">All Open Tickets (11)</a></div>
                                <div class="LinkButton ShowContactInfo"><a class="Button ButtonIcon Link NormalState" id="z5e2301fad3194aebac208b89873bb85d" tabindex="0">Last 30 Days (2)</a></div>
                            </div>
                        </div>
                    </div>
                    <div class="InsightShell Collapsed">
                        <div class="Title Title6">
                            <div class="Text">Time Summary</div>
                            <div class="Toggle">
                                <div class="InlineIcon ArrowUpSmall"></div>
                            </div>
                        </div>
                        <div class="ContentContainer">
                            <div class="LoadingIndicator"></div>
                            <div class="TransitionContainer"></div>
                            <div class="Content" id="z10ebd30d7a264abda2151165081694b9">
                                <div class="Text NoData VeryLowImportance">Nothing to display</div>
                            </div>
                        </div>
                    </div>
                    <div class="InsightShell Collapsed" id="z48d3540e2e584765910e8058b1be991f">
                        <div class="Title Title7">
                            <div class="Text">配置项</div>
                            <div class="Toggle">
                                <div class="InlineIcon ArrowUpSmall"></div>
                            </div>
                        </div>
                        <div class="ContentContainer">
                            <div class="LoadingIndicator"></div>
                            <div class="TransitionContainer Transition"></div>
                            <div class="Content" id="InsProInfoDiv">
                                <div class="Text LowImportance">名称</div>
                                <div class="LinkButton HighImportance"><a class="Button ButtonIcon Link NormalState" id="InsProName" tabindex="0"></a></div>
                                <div class="NormalSpacer"></div>
                                <div class="Text LowImportance">联系人</div>
                                <div class="Bundle">
                                    <div class="LinkButton HighImportance"><a class="Button ButtonIcon Link NormalState" id="InsProContact" tabindex="0"></a></div>
                                </div>
                                <div class="NormalSpacer"></div>
                                <div class="Text LowImportance">安装</div>
                                <div class="Text HighImportance" id="InsProInstallTime"></div>
                                <div class="Bundle">
                                    <div class="Text HighImportance" id="InsProInstallUser"></div>
                                </div>
                                <div class="NormalSpacer"></div>
                                <div class="Text LowImportance">保修期</div>
                                <div class="Text HighImportance" id="InsProWarnTime"></div>
                                <div class="NormalSpacer"></div>
                                <div class="Text LowImportance">供应商</div>
                                <div class="LinkButton HighImportance"><a class="Button ButtonIcon Link NormalState" id="InsProVendor" tabindex="0"></a></div>
                                <div class="NormalSpacer"></div>
                                <div class="Text LowImportance">服务水平协议</div>
                                <div class="Text CriticalImportance" id="InsProService"></div>
                                <div class="NormalSpacer"></div>
                                <div class="Text LowImportance">相关配置项</div>
                                <div class="Text HighImportance" id="InsProRelated">0</div>
                                <div class="NormalSpacer"></div>
                                <div class="Text">All Open Tickets (0)</div>
                                <div class="Text">Total Tickets (0)</div>
                            </div>
                            <div class="Content" id="NoInsProShow">
                                <div class="Text NoData VeryLowImportance">暂无配置项信息</div>
                            </div>
                        </div>
                    </div>
                    <div class="InsightShell Invisible" id="za4e05a3de99042b09d62b550b4b766bf" style="display: none;">
                        <div class="Title">
                            <div class="Text">商机</div>
                            <div class="Toggle">
                                <div class="InlineIcon ArrowUpSmall"></div>
                            </div>
                        </div>
                        <div class="ContentContainer">
                            <div class="LoadingIndicator"></div>
                            <div class="TransitionContainer"></div>
                            <div class="Content" id="z9f356c8974c1409b855378914d4caef6"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>



        <!--工单状态更改为完成 -->
        <div class="Dialog Large" style="margin-left: 400px; margin-top: -1100px; z-index: 100; height: 350px; width: 350px; display: none;" id="CompletionReasonDialog">
            <div>
                <div class="CancelDialogButton" id="CloseStatusReson"></div>
                <div class="Active ThemePrimaryColor TitleBar">
                    <div class="Title"><span class="Text">完成工单</span><span class="SecondaryText"></span></div>
                </div>
                <div class="DialogHeadingContainer">
                    <div class="ValidationSummary" id="z3ce7f40373d04055865c00c8e1805891">
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
                        <a class="Button ButtonIcon Save NormalState" id="SaveAndCloseCompleteButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">
                            <asp:Button ID="btnComplete" runat="server" Text="保存" OnClick="btnComplete_Click" /></span></a>
                    </div>
                </div>

                <div class="ScrollingContentContainer">
                    <div class="ScrollingContainer" id="za40a15b2846a4b8a8cab26c764754801" style="position: unset;">
                        <div class="Medium NoHeading Section" style="margin-left: 10px; width: 250px;">
                            <div class="Content" style="padding-left: 16px;">
                                <div class="Normal Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>原因</label><span class="Required">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor TextArea">
                                        <div class="InputField">
                                            <textarea class="Medium" id="reason" name="reason" placeholder="" style="width: 200px; height: 100px;"></textarea>
                                        </div>
                                        <div>
                                            <input type="checkbox" id="AddSoule" name="AddSoule" /><span>追加到解决方案</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" id="SaveType" name="SaveType" value="" />
        <!--工单状态更改为重新打开 -->
        <div class="Dialog Large" style="margin-left: 400px; margin-top: -1100px; z-index: 100; height: 350px; width: 350px; display: none;" id="ReopenDialog">
            <div>
                <div class="CancelDialogButton" id="CloseRepeatReson"></div>
                <div class="Active ThemePrimaryColor TitleBar">
                    <div class="Title"><span class="Text">重新打开工单</span><span class="SecondaryText"></span></div>
                </div>
                <div class="DialogHeadingContainer">
                    <div class="ValidationSummary" id="">
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
                        <a class="Button ButtonIcon Save NormalState" id="SaveAndCloseRepeatButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">
                            <asp:Button ID="btnRepeat" runat="server" Text="保存" OnClick="btnRepeat_Click" /></span></a>
                    </div>
                </div>

                <div class="ScrollingContentContainer">
                    <div class="ScrollingContainer" id="" style="position: unset;">
                        <div class="Medium NoHeading Section" style="margin-left: 10px; width: 250px;">
                            <div class="Content" style="padding-left: 16px;">
                                <div class="Normal Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>原因</label><span class="Required">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor TextArea">
                                        <div class="InputField">
                                            <textarea class="Medium" id="RepeatReason" name="RepeatReason" placeholder="" style="width: 200px; height: 100px;"></textarea>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="BackgroundOverLay"></div>
        <div class="menu" id="menu" style="background-color: #f8f8f8;">
            <%--菜单--%>
            <ul style="width: 220px;" id="menuUl">
                <li id="AddToAbove" onclick="AddAbove()">添加到条目上面</li>
                <li id="AddToBelow" onclick="AddBelow()">添加到条目下面</li>
                <li id="CopyItem" onclick="CopyThisItem()">复制</li>
                <li id="AssKonw">关联知识库</li>
                <li id="DeleteItem" onclick="Delete()">删除</li>
            </ul>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<!--页面常规信息js操作 -->
<script>
    var backImg = ["up.png", "down.png"];
    var index1 = 0; var index2 = 0; var index3 = 0; var index4 = 0; var index5 = 0; var index6 = 0; var index7 = 0;
    $(".Title1").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index1 % 2] + ")");
        index1++;
    });
    $(".Title2").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index2 % 2] + ")");
        index2++;
    });
    $(".Title3").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index3 % 2] + ")");
        index3++;
    });
    $(".Title4").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index4 % 2] + ")");
        index4++;
    });
    $(".Title5").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index5 % 2] + ")");
        index5++;
    });
    $(".Title6").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index6 % 2] + ")");
        index6++;
    });
    $(".Title7").on("click", function () {
        $(this).next().toggle();
        $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index7 % 2] + ")");
        index7++;
    });

    var colors = ["#white", "white"];
    var color1 = 0; var color2 = 0; var color3 = 0;
    $(".Toggle1").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[color1 % 2]);
        color1++;
    });
    $(".Toggle2").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[color2 % 2]);
        color2++;
    });
    $(".Toggle3").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[color3 % 2]);
        color3++;
    });
    $(".Dot").mouseleave(function () {
        $(this).next().children().first().hide();
    })

    $(".Dot").mouseout(function () {
        $(this).next().children().first().hide();
    })

    $(".QuickLaunchButton").mouseover(function () {
        $(this).children().first().show();
    })
    $(".QuickLaunchButton").mouseleave(function () {
        $(this).children().first().hide();
    })



    var hour, minute, second;//时 分 秒
    hour = minute = second = 0;//初始化
    //var millisecond = 0;//毫秒
    var int;
    function Reset()//重置
    {
        window.clearInterval(int);
        hour = minute = second = 0;
        //document.getElementById('timetext').value = '00时00分00秒000毫秒';
        $("#ShowWatchTime").html("00:00:00");
        $("#PlayTimeDiv").removeClass("noplay");
        $("#PlayTimeDiv").addClass("Play");
        stop();
    }

    function start()//开始
    {
        int = setInterval(timer, 1000);
    }

    function timer()//计时
    {

        second = second + 1;

        if (second >= 60) {
            second = 0;
            minute = minute + 1;
        }

        if (minute >= 60) {
            minute = 0;
            hour = hour + 1;
        }
        if (hour >= 24) {
            hour = 0;
        }
        $("#ShowWatchTime").html(Return2(hour) + ":" + Return2(minute) + ":" + Return2(second));
    }

    function stop()//暂停
    {
        window.clearInterval(int);
    }

    function Return2(num) {
        if (Number(num) < 10) {
            return "0" + num;
        }
        else {
            return num;
        }
    }

    $("#PlayTimeDiv").click(function () {
        if ($(this).hasClass("Play")) {
            $(this).removeClass("Play");
            $(this).addClass("noplay");
            start();
        }
        else {
            $(this).removeClass("noplay");
            $(this).addClass("Play");
            stop();
        }
    })

    var toId = "";
    var type = "in";

    function drag() {

        // var obj = $('#Drap .HighImportance');
        var obj = $('#Drap .Interaction');
        obj.bind('mousedown', DragStart);
        function DragStart(e) {
            var ol = obj.parent().offset().left;
            var ot = obj.parent().offset().top;
            deltaX = e.pageX - ol;
            deltaY = e.pageY - ot;
            $(this).trigger("click");
            $(document).bind({
                'mousemove': move,
                'mouseup': DragStop
            });
            return false;
        }
        function move(e) {


            $.each(obj.parent().siblings(), function (i) {
                var mX = obj.parent().siblings().eq(i).offset().left;
                var mY = obj.parent().siblings().eq(i).offset().top;
                if (e.pageX > mX && e.pageX < mX + obj.parent().siblings().eq(i).width() && e.pageY > mY && e.pageY < mY + obj.parent().siblings().eq(i).height()) {
                    obj.parent().css('cursor', 'move')
                    obj.css('cursor', 'move')
                    $('.border_left').show()
                    $('.border_right').show()
                    type = "in";
                    $('.border-line').hide()
                    $('.border_left').css({
                        "left": 0,
                        "top": obj.parent().siblings().eq(i).children('.Interaction').offset().top - $('.RowContainer').offset().top + obj.parent().siblings().eq(i).height() / 2 - 8,
                    })
                    $('.border_right').css({
                        "right": 0,
                        "top": obj.parent().siblings().eq(i).children('.Interaction').offset().top - $('.RowContainer').offset().top + obj.parent().siblings().eq(i).height() / 2 - 8,
                    })
                    $('.cover').show()
                    $('.cover').css({
                        "left": (e.pageX + $('.cover').width() + 10) - $('.RowContainer').offset().left,
                        "top": (e.pageY - $('.RowContainer').offset().top),
                        "display": 'block'
                    })

                    $('.cover').html(obj.parent().siblings().eq(i).find('.Num').html());
                    toId = obj.parent().siblings().eq(i).data("val");  // 代表将要放的位置的id

                } else {
                    obj.parent().css('cursor', 'none')
                }
                if (e.pageY > mY - 5 && e.pageY < mY + 5) {
                    type = "above";
                    $('.border-line').show()
                    $('.border-line').css({
                        'top': mY - $('.RowContainer').offset().top
                    })
                    $('.border_left').css({
                        "left": 0,
                        "top": mY - $('.RowContainer').offset().top - 6
                    })
                    $('.border_right').css({
                        "right": 0,
                        "top": mY - $('.RowContainer').offset().top - 6
                    })
                    //obj.css('border-top','1px solid #346a95')
                    if (e.pageY < mY) {
                        $('.cover').html(obj.parent().siblings().eq(i).find('.Num').html());
                        // toId = obj.data("val");
                    }
                }
            })

            // obj.css({
            //     "left": (e.pageX - deltaX),
            //     "top": (e.pageY - deltaY),
            //     "cursor":'move'
            // });


            return false;
        }
        function DragStop() {

            $('.cover').hide()
            $('.border_right').hide()
            $('.border_left').hide()
            $('.border-line').hide()
            obj.parent().css('cursor', '')
            obj.parent().find('.Interaction').css('cursor', '')
            $(document).unbind({
                'mousemove': move,
                'mouseup': DragStop,
                "cursor": 'pointer'
            });
            //DragTask();
        }
    }
    drag();
    $(".IconContainer").on('click', function () {
        if ($(this).hasClass("Selected")) {
            $(this).removeClass('Selected');
        }
        else {
            $(this).addClass('Selected');
        }
        $(this).find('.Vertical').toggle();
        var _this = $(this).parent().parent().parent();
        var str = _this.find('.DataDepth').attr('data-depth');

    });

</script>
<!--工单常规信息js操作 -->
<script>
    $(function () {
        start();
        $(".ShowAccInfo").hide(); // 隐藏客户信息
        $(".ShowContactInfo").hide(); // 隐藏联系人信息
        $("#InsProInfoDiv").hide();   // 隐藏配置项信息
        GetSubIssueType();
        <%if (thisTicket != null && thisTicket.sub_issue_type_id != null)
    { %>
        $("#sub_issue_type_id").val('<%=thisTicket.sub_issue_type_id.ToString() %>');
        <%}%>

        <%if (!string.IsNullOrEmpty(ticketResIds))
    { %>
        GetOtherResData();
        <%}%>
        <%if (thisContract != null)
    { %>
        GetServiceByContract();
        <%}%>
        <%if (thisTicket != null && thisTicket.service_id != null)
    { %>
        $("#service_id").val('<%=thisTicket.service_id %>');
        <%}%>

        GetDataByInsPro();
        GetDataByAccount();
        GetDataByContact();

    })

    function ClosePage() {
        window.close();
    }
    // 客户查找带回
    function CallBackAccount() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=account_id&callBack=GetDataByAccount", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 客户查找带回 数据处理
    function GetDataByAccount() {
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "") {
            // 显示客户提醒

            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=GetAccAlert&account_id=" + account_idHidden,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#ShowAlert").show();
                        if (data.hasTicketAlert) {
                            $("#ShowTicketAlert").html("工单提醒:" + data.ticketAlert);
                        }
                        else {
                            $("#ShowTicketAlert").html("");
                        }

                        if (data.hasTicketDetail) {
                            $("#ShowTicketDetail").html("工单详情提醒:" + data.ticketDetail);
                        }
                        else {
                            $("#ShowTicketDetail").html("");
                        }
                    } else {
                        $("#ShowAlert").hide();
                        $("#ShowTicketAlert").html("");
                        $("#ShowTicketDetail").html("");
                    }
                },
            });
            // 联系人可以查找带回
            $("#SelectContact").click(function () {
                CallBackContact();
            })
            $("#AddContact").click(function () {
                AddContact();
            })

            // 合同可以查找带回
            $("#ContractBack").click(function () {
                ContractCallBack();
            })

            // 显示客户相关信息

            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=GetAccDetail&account_id=" + account_idHidden,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $(".ShowAccInfo").show();

                        $("#TranAccount").click(function () {
                            OpenAccount(account_idHidden);
                        })
                        $("#TranAccount").text(data.name);

                        $("#TranAccSit").click(function () {
                            OpenAccountSite(account_idHidden);
                        });
                        $("#TranAccSit").text("站点配置");
                        $("#ShowAccAddress").html(data.address2 + "<br />" + data.provice + "&nbsp;" + data.city + "&nbsp;" + data.quXian + "&nbsp;" + "<br />" + data.address1);
                        $("#AccPhone").text(data.phone);
                        if (data.ticketNum != "" && Number(data.ticketNum) > 0) {
                            $("#AccTicketHref").click(function () {
                                OpenAccountTicket(account_idHidden);
                            });

                        }
                        $("#AccTicketHref").text("打开工单（" + data.ticketNum + "）");
                        if (data.monthNum != "" && Number(monthNum) > 0) {
                            $("#ShowLastTicket").click(function () {
                                // OpenAccountTicket(account_idHidden);
                            });
                        }
                        // 

                    } else {
                        $(".ShowAccInfo").hide();
                        $("#TranAccount").removeAttr("onclcik");
                        $("#TranAccount").text("");
                        $("#TranAccSit").removeAttr("onclcik");
                        $("#AccPhone").text("");
                        $("#AccTicketHref").removeAttr("onclcik");
                        $("#ShowLastTicket").removeAttr("onclcik");
                    }
                },
            });

            // 如果配置项不属于该客户 清除配置项信息
            var installed_product_idHidden = $("#installed_product_idHidden").val();
            if (installed_product_idHidden != "") {
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/ProductAjax.ashx?act=GetInsProInfo&insProId=" + installed_product_idHidden,
                    dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            if (data.account_id != account_idHidden) {

                                $("#installed_product_id").val("");
                                $("#installed_product_idHidden").val("");
                                // todo 隐藏配置项详情Div
                                GetDataByInsPro();
                            }

                        } else {

                        }
                    },
                });

            }
            else {
                $("#installed_product_id").val("");
                GetDataByInsPro();
            }

        }
        else {
            $("#ShowAlert").hide();
            $("#ShowTicketAlert").html("");
            $("#ShowTicketDetail").html("");
            $("#SelectContact").removeAttr("onclick");
            $("#AddContact").removeAttr("onclick");
            $("#ContractBack").removeAttr("onclick");
            $(".ShowAccInfo").hide();
            $("#TranAccount").removeAttr("onclcik");
            $("#TranAccount").text("");
            $("#TranAccSit").removeAttr("onclcik");
            $("#AccPhone").text("");
            $("#AccTicketHref").removeAttr("onclcik");
            $("#ShowLastTicket").removeAttr("onclcik");
            //  隐藏配置项详情Div
            $("#installed_product_id").val("");
            $("#installed_product_idHidden").val("");
            GetDataByInsPro();
        }
    }
    // 显示客户的未关闭工单的列表
    function ShowAccNoTicket() {

    }
    // 新增客户操作 新增成功后，将客户名称和Id 带回
    function AddAccount() {
        window.open("../Company/AddCompany.aspx?CallBack=GetAccount", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyAdd %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 根据客户Id 为页面上客户信息赋值
    function GetAccount(id) {
        if (id != "" && id != null && id != undefined) {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=property&account_id=" + id + "&property=name",
                //dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#account_id").val(data);
                        $("#account_idHidden").val(id);
                        GetDataByAccount();
                    }
                },
            });
        }
    }
    // 查看客户
    function OpenAccount(id) {
        window.open("../Company/ViewCompany.aspx?id=" + id, "_blank", 'left=200,top=200,width=800,height=800', false);
    }
    // 打开客户站点
    function OpenAccountSite(id) {
        window.open("../Company/CompanySiteManage.aspx?id=" + id, "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySiteConfiguration %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 打开客户的工单
    function OpenAccountTicket(id) {

    }
    // 联系人的查找带回
    function CallBackContact() {
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "" && account_idHidden != null && account_idHidden != undefined) {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_CALLBACK %>&con628=" + account_idHidden + "&field=contact_id&callBack=GetDataByContact", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择客户");
        }

    }
    //  联系人查找带回处理相关数据
    function GetDataByContact() {
        var contact_id = $("#contact_idHidden").val();
        if (contact_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContactAjax.ashx?act=GetContactDetail&contact_id=" + contact_id,
                dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        $(".ShowContactInfo").show();

                        $("#TranContact").click(function () {
                            OpenContact(contact_id);
                        })
                        $("#TranContact").text(data.name);

                        $("#ContactPhone").text(data.phone);

                        if (data.ticketNum != "" && Number(data.ticketNum) > 0) {
                            $("#TranContactTicket").click(function () {
                                OpenContactTicket(contact_id);
                            });
                        }
                        $("#TranContactTicket").text("打开工单（" + data.ticketNum + "）");
                        if (data.monthNum != "" && Number(monthNum) > 0) {

                        }
                        // 

                    } else {
                        $(".ShowContactInfo").hide();
                        $("#ContactPhone").text("");

                        $("#TranContactTicket").removeAttr("onclcik");

                    }
                },
            });
        }
        else {
            // 隐藏联系人相关信息
            $(".ShowContactInfo").hide();
        }
    }
    function OpenContact(id) {
        window.open("../Contact/ViewContact.aspx?id=" + id, "_blank", 'left=200,top=200,width=600,height=800', false);
    }
    // 新增联系人
    function AddContact() {
        var url = "../Contact/AddContact?callback=GetContact";
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "" && account_idHidden != null && account_idHidden != undefined) {
            url += "&account_id=" + account_idHidden;
        }
        window.open(url, "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 根据联系人Id 为页面的联系人信息赋值
    function GetContact(id) {
        if (id != "" && id != null && id != undefined) {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContactAjax.ashx?act=GetContactInfo&contact_id=" + id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#contact_id").val(data.name);
                        $("#contact_idHidden").val(id);
                    }
                },
            });
        }
    }
    // 根据联系人打开工单
    function OpenContactTicket(contact_id) {

    }
    $("#issue_type_id").change(function () {
        GetSubIssueType();
    })

    // 根据 问题类型，返回相应的子问题类型
    function GetSubIssueType() {
        var subIssTypeHtml = "<option value=''> </option>";
        var issue_type_id = $("#issue_type_id").val();
        if (issue_type_id != "" && issue_type_id != null && issue_type_id != undefined) {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/GeneralAjax.ashx?act=GetGeneralByParentId&parent_id=" + issue_type_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            subIssTypeHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                },
            });
        }
        $("#sub_issue_type_id").html(subIssTypeHtml);
    }

    // 主负责人查找带回
    function ChoosePriRes() {
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&field=owner_resource_id&callBack=GetResByCallBack";
        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 主负责人查找带回事件 - 当带回的主负责人在其他负责人中出现的时候-从其他负责人中删除，然后带回主负责人
    function GetResByCallBack() {
        var owner_resource_id = $("#owner_resource_idHidden").val();
        if (owner_resource_id != "") {
            var OtherResId = $("#OtherResIdHidden").val();
            if (OtherResId != "") {  //
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/ResourceAjax.ashx?act=CheckResInResDepIds&isDelete=1&resDepIds=" + OtherResId + "&resDepId=" + owner_resource_id,
                    dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            if (data.isRepeat) {
                                $("#OtherResIdHidden").val(data.newDepResIds);
                                GetResDepByIds();
                            }
                        }
                    },
                });
            }  // 检查主负责人是否与其他负责人冲突

        } else {
            $("#owner_resource_id").val("");
        }
    }
    // 其他负责人的查找带回- 带回的其他负责人包含主负责人时，提示 主负责人已经包含该员工 是 删除主负责人信息，否 从其他负责人中删除该联系人
    function OtherResCallBack() {
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&muilt=1&field=OtherResId&callBack=GetOtherResData";
        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 获取到其他负责人的相应信息
    function GetOtherResData() {
        // 检查是否有重复员工
        // 检查带回员工是否与主负责人有冲突
        // 
        var OtherResId = $("#OtherResIdHidden").val();
        if (OtherResId != "") {
            var owner_resource_id = $("#owner_resource_idHidden").val();
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ResourceAjax.ashx?act=CheckResInResDepIds&resDepIds=" + OtherResId + "&resDepId=" + owner_resource_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#OtherResIdHidden").val(data.newDepResIds);
                        if (data.isRepeat) {
                            LayerConfirm("选择员工已经是主负责人，是否将其置为其他负责人", "是", "否", function () { $("#owner_resource_idHidden").val(""); $("#owner_resource_id").val(""); }, function () { GetResByCallBack(); });
                        }

                    }
                },
            });
            GetResDepByIds();
        }
    }

    // 其他负责人的数据返回（此方法不做员工重复校验）
    function GetResDepByIds() {
        var resDepIds = $("#OtherResIdHidden").val();
        if (resDepIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=GetResDepList&resDepIds=" + resDepIds,
                async: false,
                //dataType:"json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        $("#otherRes").html(data);
                        $("#otherRes option").dblclick(function () {
                            RemoveResDep(this);
                        })
                    }
                }

            })
        } else {
            $("#otherRes").html("");
        }

    }
    function RemoveResDep(val) {
        $(val).remove();
        var ids = "";
        $("#otherRes option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#OtherResIdHidden").val(ids);
    }

    $("#estimated_hours").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && !isNaN(thisValue)) {
            $(this).val(toDecimal2(thisValue));
        }
        else {
            $(this).val("");
        }

    })
    // 配置项的查找带回
    function InsProCallBack() {
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INSPRODUCT_CALLBACK %>&con1247=" + account_idHidden + "&field=installed_product_id&callBack=GetDataByInsPro", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>", 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择客户");
        }

    }

    function GetDataByInsPro() {
        // 显示配置项详情
        var installed_product_id = $("#installed_product_idHidden").val();
        if (installed_product_id != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ProductAjax.ashx?act=GetInsProDetail&insProId=" + installed_product_id,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#InsProInfoDiv").show();
                        $("#NoInsProShow").hide();
                        $("#InsProName").text(data.name);
                        $("#InsProName").click(function () {
                            EditInsPro(installed_product_id);
                        })

                        $("#InsProContact").text(data.contactName);
                        $("#InsProContact").click(function () {
                            OpenContact(data.contactId);
                        })
                        $("#InsProInstallTime").val(data.insTime);
                        $("#InsProInstallUser").val(data.insUser);
                        $("#InsProWarnTime").val(data.insWarnTime);
                        // InsProVendor
                        $("#InsProVendor").text(data.name);
                        $("#InsProVendor").click(function () {
                            OpenAccount(data.vendorId);
                        })

                    }
                    else {
                        $("#InsProInfoDiv").hide();
                        $("#NoInsProShow").show();
                        $("#InsProName").removeAttr("onclick");
                        $("#InsProContact").removeAttr("onclick");
                        $("#InsProName").text("");
                        $("#InsProContact").text("");
                        $("#InsProInstallTime").val("");
                        $("#InsProInstallUser").val("");
                        $("#InsProWarnTime").val("");
                        $("#InsProVendor").removeAttr("onclick");
                        $("#InsProVendor").text("");
                    }
                }
            })
        }
        else {
            $("#InsProInfoDiv").hide();
            $("#NoInsProShow").show();
            $("#InsProName").removeAttr("onclick");
            $("#InsProContact").removeAttr("onclick");
            $("#InsProName").text("");
            $("#InsProContact").text("");
            $("#InsProInstallTime").val("");
            $("#InsProInstallUser").val("");
            $("#InsProWarnTime").val("");
            $("#InsProVendor").removeAttr("onclick");
            $("#InsProVendor").text("");
        }
    }
    // 跳转到修改配置项页面
    function EditInsPro(id) {

    }
    var oldContractId = 0;
    var oldServiceId = 0;
    // 合同的查找带回
    function ContractCallBack() {
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "" && account_idHidden != null && account_idHidden != undefined) {
            oldContractId = $("#contract_idHidden").val();
            oldServiceId = $("#service_id").val();
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACTMANAGE_CALLBACK %>&con626=1&con627=" + account_idHidden + "&field=contract_id&callBack=GetDataByContract", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>", 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择客户");
        }
    }
    // 根据合同带回相应的服务和服包信息
    function GetDataByContract() {

        // 采购订单信息处理
        // 选择的合同不在有效期内（开始到结束时间不包括今天） 提醒合同过期，是否关联
        var contractHidden = $("#contract_idHidden").val();
        if (contractHidden != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=CheckContractDate&contract_id=" + contractHidden,
                async: false,
                //dataType: "json",
                success: function (data) {
                    if (data != "") {

                        if (data == "True") {
                            LayerConfirm("合同已过期，确认要关联该合同吗？", "是", "否", function () { }, function () {
                                $("#contract_idHidden").val("");
                                $("#contract_id").val("");
                                GetServiceByContract();
                            });
                        }
                    }
                    else {

                    }
                }
            })
        }
        GetServiceByContract();
        GetPurChaseOrderByContract();
    }
    // 通过合同获取服务信息
    function GetServiceByContract() {
        var serviceHtml = "<option value=''> </option>";
        var contractHidden = $("#contract_idHidden").val();
        if (contractHidden != "" && contractHidden != null && contractHidden != undefined) {
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=GetContractService&contract_id=" + contractHidden,
                async: false,
                //dataType: "json",
                success: function (data) {
                    if (data != "") {
                        serviceHtml += data;
                    }
                    else {

                    }
                }
            })
        }
        $("#service_id").html(serviceHtml);

    }

    // 通过合同获取相关采购订单信息
    function GetPurChaseOrderByContract() {
        //  新增时：带回的合同有采购订单号，则替换工单的采购订单号
        //  编辑时：带回的合同有采购订单号，则提醒用户是否更新采购订单号，并显示未审批提交的成本数量
        var purchase_order_no = $("#purchase_order_no").val();
        var contractHidden = $("#contract_idHidden").val();
        <%if (isAdd)
    { %>
        if ($.trim(purchase_order_no) != "" && contractHidden != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=property&contract_id=" + contractHidden + "&property=purchase_order_no",
                async: false,
                //dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#purchase_order_no").val(data);
                    }
                }
            })
        }
        <%}
    else
    { %>
        if ($.trim(purchase_order_no) != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/TicketAjax.ashx?act=CheckContractPurchaseOrder&contract_id=" + contractHidden + "&purchase_order=" + purchase_order_no +"&ticket_id=<%=thisTicket==null?"":thisTicket.id.ToString() %>",
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.isUpdateOrder) {
                            if (contractHidden == "") {
                                LayerConfirm("本工单工单的采购订单号与合同相同，且本工单有" + data.count + "个为审批并提交的成本其采购订单号与合同相同，是否清空", "是", "否", function () {
                                    $("#contract_id").val("");
                                    $("#contract_idHidden").val("");
                                    GetServiceByContract();
                                }, function () {
                                    // oldContractId
                                    if (oldContractId != 0 && oldContractId != '0') {
                                        $.ajax({
                                            type: "GET",
                                            url: "../Tools/ContractAjax.ashx?act=property&contract_id=" + oldContractId + "&property=name",
                                            async: false,
                                            //dataType: "json",
                                            success: function (data) {
                                                if (data != "") {
                                                    $("#contract_id").val(data);
                                                    $("#contract_idHidden").val(oldContractId);
                                                    GetServiceByContract();
                                                    if (oldServiceId != "" && oldServiceId != '0' && oldServiceId != undefined && oldServiceId != null) {
                                                        $("#service_id").val(oldServiceId);
                                                    }
                                                }
                                            }
                                        })
                                    }

                                });
                            }
                            else {
                                LayerConfirm("是否将该合同有采购订单号更新为工单采购订单号；且本工单有" + data.count + "个未审批并提交的成本，是否更新其采购订单号", "是", "否", function () {
                                    $.ajax({
                                        type: "GET",
                                        url: "../Tools/ContractAjax.ashx?act=property&contract_id=" + contractHidden + "&property=purchase_order_no",
                                        async: false,
                                        //dataType: "json",
                                        success: function (data) {
                                            if (data != "") {
                                                $("#purchase_order_no").val(data);
                                            }
                                        }
                                    })
                                }, function () { });
                            }
                        }
                    }
                }
            })
        }
        else {
            if ($.trim(purchase_order_no) != "" && contractHidden != "") {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=property&contract_id=" + contractHidden + "&property=purchase_order_no",
                    async: false,
                    //dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            $("#purchase_order_no").val(data);
                        }
                    }
                })
            }
        }
        <% }%>
    }
    // 工作类型的查找带回
    function WorkTypeCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE %>&field=cost_code_id&callBack=GetDataByCostCode", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 预留-工作类型的查找带回
    function GetDataByCostCode() {

    }
    // 工单类型的更改校验- 
    // 1 新增不提示，没有验证
    // 2 从变更单变更到其他状态时，进行提醒
    // 3 部分状态关联问题时不能进行更改
    $("#ticket_type_id").change(function () {
        <%if (!isAdd)
    { %>
        return CanEditType();
        <%}%>
    })
    // 是否可以更改工单状态的
    function CanEditType() {
        // 这个工单关联的问题或者事故的工单Id
        var thisProTicId = '<%=thisTicket!=null&&thisTicket.problem_ticket_id!=null?thisTicket.problem_ticket_id.ToString():"" %>';
        var oldTicketType = '<%=thisTicket!=null&&thisTicket.ticket_type_id!=null?thisTicket.ticket_type_id.ToString():"" %>';
        var newTicketType = $("#ticket_type_id").val();
        var thisProTicType = "";
        if (thisProTicId != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/TicketAjax.ashx?act=property&ticket_id=" + thisProTicId + "&property=ticket_type_id",
                async: false,
                //dataType: "json",
                success: function (data) {
                    if (data != "") {
                        thisProTicType = data;
                    }
                }
            })
        }


        if (oldTicketType == '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.SERVICE_REQUEST %>' || oldTicketType == '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.ALARM %>') {
            return true;
        }
        else if (oldTicketType == '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.CHANGE_REQUEST %>') // 变更申请
        {
            if (thisProTicId != "") {
                LayerMsg("工单关联事故/问题不能修改！");
                return false;
            }
            else {
                if (newTicketType != '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.CHANGE_REQUEST %>') {
                    LayerConfirm("您即将更改变更申请的工单类型。 变更信息和批准人信息将保留在工单上，但除非将工单类型更改回来，否则不能查看。 你确定你要继续吗？", "是", "否", function () { }, function () { $("#ticket_type_id").val(oldTicketType); });
                    return true;
                }
            }

        }
        else if (oldTicketType == '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.INCIDENT %>') {
            if (thisProTicId != "" && thisProTicType =='<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.PROBLEM %>') {
                LayerMsg("工单关联问题不能修改！");
                return false;
            }

        }
        else if (oldTicketType == '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.PROBLEM %>') {
            if (thisProTicId != "" && thisProTicType == '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.INCIDENT %>') {
                LayerMsg("工单关联事故不能修改！");
                return false;
            }
        }
        return true;

    }

    $("#save").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })

    $("#btnComplete").click(function () {
        var reason = $("#reason").val();
         <%var thisDepSet = new EMT.DoneNOW.BLL.SysSettingBLL().GetSetById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_TICKET_COMPLETE_REASON);
    if (thisDepSet != null && thisDepSet.setting_value == "1")
    {
        %>
        if ($.trim(reason) == '') {
            LayerMsg("请填写完成原因");
            return false;
        }
    <%}
    %>
    })

    $("#btnRepeat").click(function () {
        var RepeatReason = $("#RepeatReason").val();
         <%var RepeatSet = new EMT.DoneNOW.BLL.SysSettingBLL().GetSetById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_TICKET_COMPLETE_REASON);
    if (RepeatSet != null && RepeatSet.setting_value == "1")
    {
        %>
        if ($.trim(RepeatReason) == '') {
            LayerMsg("请填写重新打开原因");
            return false;
        }
    <%}
    %>
    })

    function SubmitCheck() {
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden == "" || account_idHidden == null) {
            LayerMsg("请通过查找带回功能选择客户");
            return false;
        }
        var status_id = $("#status_id").val();
        if (status_id == "" || status_id == null) {
            LayerMsg("请选择状态");
            return false;
        }
        var priority_type_id = $("#priority_type_id").val();
        if (priority_type_id == "" || priority_type_id == null) {
            LayerMsg("请选择优先级");
            return false;
        }
        var issue_type_id = $("#issue_type_id").val();
        if (issue_type_id == "" || issue_type_id == null) {
            LayerMsg("请选择问题类型");
            return false;
        }
        var sub_issue_type_id = $("#sub_issue_type_id").val();
        if (sub_issue_type_id == "" || sub_issue_type_id == null) {
            LayerMsg("请选择子问题类型");
            return false;
        }
        var source_type_id = $("#source_type_id").val();
        if (source_type_id == "" || source_type_id == null) {
            LayerMsg("请选择工单来源");
            return false;
        }
        var DueDate = $("#DueDate").val();
        if (DueDate == "" || DueDate == null) {
            LayerMsg("请填写截止日期");
            return false;
        }
        var DueTime = $("#DueTime").val();
        if (DueTime == "" || DueTime == null) {
            LayerMsg("请填写截止时间");
            return false;
        }
        var department_id = $("#department_id").val();
        var owner_resource_id = $("#owner_resource_idHidden").val();
        if (department_id == "" && owner_resource_id == "") {
            LayerMsg("队列和主负责人，请选择其中一项进行填写！");
            return false;
        }
        var cost_code_idHidden = $("#cost_code_idHidden").val();
        if (cost_code_idHidden == "") {
            LayerMsg("请通过查找带回选择工作类型！");
            return false;
        }
        var cate_id = $("#cate_id").val();
        if (cate_id == "") {
            LayerMsg("请选择工单种类！");
            return false;
        }
        var ticket_type_id = $("#ticket_type_id").val();
        if (ticket_type_id == "") {
            LayerMsg("请选择工单类型！");
            return false;
        }
        var title = $("#title").val();
        if ($.trim(title) == "") {
            LayerMsg("请填写工单标题！");
            return false;
        }


        GetCheckIds();

        var oldStatus = '<%=thisTicket!=null?thisTicket.status_id.ToString():"" %>';
        if (status_id == '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE %>') {
            <%if (!isAdd)
    { %>
            $("#BackgroundOverLay").show();
            $("#CompletionReasonDialog").show();
            return false;
            <%}%>
        }
        // 状态是重新打开的时候需要输入原因 todo 重新打开类型
        else if (status_id != '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE %>' && oldStatus == '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE %>') {
             <%if (!isAdd)
    { %>
            // 状态从完成改为其他状态--打开重新打开，填写原因
            $("#BackgroundOverLay").show();
            $("#ReopenDialog").show();
            return false;
            <%}%>
        }




        return true;
    }
    $("#CloseStatusReson").click(function () {
        $("#CompletionReasonDialog").hide();
        $("#BackgroundOverLay").hide();
    })
    $("#CloseRepeatReson").click(function () {
        $("#ReopenDialog").hide();
        $("#BackgroundOverLay").hide();
    })
</script>
<!--检查单信息js操作 -->
<script>
    var pageCheckId = -1;
    // 新增检查单
    function AddCheckList(copyNum, upOrDown, upOrDownId) {
        // copyNum 复制的Id 没有代表新增不复制--（复制不考虑其他，名称复制后名称加入‘复制’）
        pageCheckId--;
        var newCheckHtml = "<tr data-val='" + pageCheckId + "' id='" + pageCheckId + "'  class='HighImportance D' draggable='true'><td class='Interaction' ><div><div class='Decoration Icon DragHandle'></div><div class='Num'></div> <input type='hidden' id='" + pageCheckId + "_sort_order' name='" + pageCheckId + "_sort_order' value=''/></div></td ><td><a class='ButtonIcon Button ContextMenu NormalState'><div class='Icon' style='background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px; width: 15px;height:15px;'></div></a></td><td></td><td><input type='checkbox' id='" + pageCheckId + "_is_complete' name='" + pageCheckId + "_is_complete' /></td><td><input type='text' id='" + pageCheckId + "_item_name' name='" + pageCheckId + "_item_name' /></td><td><input type='checkbox' id='" + pageCheckId + "_is_import' name='" + pageCheckId + "_is_import' /></td></tr>";



        if (upOrDownId != "" && upOrDown != "") {
            if (upOrDown == "Up") {
                $("#" + upOrDownId).before(newCheckHtml);
            }
            else {
                $("#" + upOrDownId).after(newCheckHtml);
            }
        } else {
            $("#Drap").append(newCheckHtml);
        }

        SortNum();
        if (copyNum != "")  // 复制的  相关赋值  todo 关联的知识库的赋值
        {
            if ($("#" + copyNum + "_is_complete").is(":checked")) {
                $("#" + pageCheckId + "_is_complete").prop("checked", true);
            }
            if ($("#" + copyNum + "_is_import").is(":checked")) {
                $("#" + pageCheckId + "_is_import").prop("checked", true);
            }
            $("#" + pageCheckId + "_item_name").val($("#" + copyNum + "_item_name").val() + "(复制)");
        }
        BindMenu();

    }
    // 为页面的检查单数字排序
    function SortNum() {
        var sortNum = 1;
        $(".HighImportance").each(function () {
            $(this).find('.Num').text(sortNum);
            $(this).find('.Num').next().val(sortNum);
            sortNum++;
        })
    }

    $("#AddCheckListButton").click(function () {
        AddCheckList("", "", "");
    })
    var entityid = "";
    var Times = 0;
    function BindMenu() {
        $(".ContextMenu").bind("click", function (event) {
            clearInterval(Times);
            var oEvent = event;
            entityid = $(this).parent().parent().data("val");// data("val");
            var menu = document.getElementById("menu");
            (function () {
                menu.style.display = "block";
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 800);
            }());
            menu.onmouseenter = function () {
                clearInterval(Times);
                menu.style.display = "block";
            };
            menu.onmouseleave = function () {
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 800);
            };
            var Left = $(document).scrollLeft() + oEvent.clientX;
            var Top = $(document).scrollTop() + oEvent.clientY;
            var winWidth = window.innerWidth;
            var winHeight = window.innerHeight;
            var menuWidth = menu.clientWidth;
            var menuHeight = menu.clientHeight;
            var scrLeft = $(document).scrollLeft();
            var scrTop = $(document).scrollTop();
            var clientWidth = Left + menuWidth;
            var clientHeight = Top + menuHeight;
            var rightWidth = winWidth - oEvent.clientX;
            var bottomHeight = winHeight - oEvent.clientY;
            if (winWidth < clientWidth && rightWidth < menuWidth) {
                menu.style.left = winWidth - menuWidth - 18 + 103 + scrLeft + "px";
            } else {
                menu.style.left = Left + 13 + "px";
            }


            if (winHeight < clientHeight && bottomHeight < menuHeight) {
                menu.style.top = winHeight - menuHeight - 55 + scrTop + "px";
            } else {
                menu.style.top = Top - 85 + "px";
            }
            document.onclick = function () {
                menu.style.display = "none";
            }
            return false;
        });
    }

    BindMenu();

    // 添加到上面
    function AddAbove() {

        if (entityid != "") {
            AddCheckList("", "Up", entityid);
        }
    }
    // 添加到下面
    function AddBelow() {
        if (entityid != "") {
            AddCheckList("", "Down", entityid);
        }
    }
    // 复制操作
    function CopyThisItem() {
        if (entityid != "") {
            AddCheckList(entityid, "", "");
        }
    }
    // 删除任务单
    function Delete() {
        if (entityid != "") {
            LayerConfirm("删除不可恢复，是否继续删除？", "是", "否", function () { $("#" + entityid).remove(); }, function () { });
            SortNum();
        }
    }
    // 获取到页面的检查单的Id
    function GetCheckIds() {
        var ckIds = "";
        $(".HighImportance").each(function () {
            var thisVal = $(this).data("val");
            if (thisVal != "" && thisVal != null && thisVal != undefined) {
                ckIds += thisVal + ',';
            }
        })
        if (ckIds != "") {
            ckIds = ckIds.substring(0, ckIds.length - 1);
        }
        $("#CheckListIds").val(ckIds);
    }
</script>
