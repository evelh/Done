<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketManage.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.TicketManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/Ticket.css" rel="stylesheet" />
    <title><%=isAdd?"新增":"编辑" %>工单</title>
    <style>
        .clickBtn{
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
        <div class="PageHeadingContainer">
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
                                <asp:Button ID="save" runat="server" Text="保存" BorderStyle="None" CssClass="clickBtn"/></span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- 下左 快捷添加相应操作（编辑 查看会触发相应事件） -->
        <div class="QuickLaunchBar" style="top: 82px;">
            <div class="QuickLaunchButton TimeEntry DisabledState" id="z9fe7df7c73554370bb803272554c4b6e">
                <div class="Text">工时<span class="KeyCode"></span></div>
                <div class="Icon" style="background: url(../Images/time.png) no-repeat;"></div>
            </div>
            <div class="QuickLaunchButton Note DisabledState" id="z7dac027c9b0d48db9b267642c7993955">
                <div class="Text">备注<span class="KeyCode"></span></div>
                <div class="Icon"  style="background: url(../Images/imgGridEdit.png) no-repeat;"></div>
            </div>
            <div class="QuickLaunchButton Attachment DisabledState" id="z5fd3fd672b594b8ba1787cb9a60b8bf2">
                <div class="Text">附件<span class="KeyCode"></span></div>
                <div class="Icon"  style="background: url(../Images/attachment.png) no-repeat;"></div>
            </div>
            <div class="QuickLaunchButton Charge DisabledState" id="zf61d47be0a39484785114a5e4e4dbf7f">
                <div class="Text">成本<span class="KeyCode"></span></div>
                <div class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></div>
            </div>
            <div class="QuickLaunchButton Expense DisabledState" id="z6b3cf81bad8b45558474a3813c0f3ea3">
                <div class="Text">费用<span class="KeyCode"></span></div>
                <div class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></div>
            </div>
            <div class="QuickLaunchButton ServiceCall DisabledState" id="z82b4699d4b024e3280de758dad30d4d7">
                <div class="Text">服务<span class="KeyCode"></span></div>
                <div class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></div>
            </div>
            <div class="QuickLaunchButton ToDo DisabledState" id="z409ac334b1fb4a02b6ad33da1873766f">
                <div class="Text">待办<span class="KeyCode"></span></div>
                <div class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></div>
            </div>
        </div>

        <!-- 下右 管理相关 属性 字段 -->

        <div class="MainContainer InsightsEnabled" style="margin-left: 43px; margin-top: 82px;">
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
                                <div class="Editor DataSelector" data-editor-id="z6b3f668402414b6c9dcec97d43673dc3" data-rdp="z6b3f668402414b6c9dcec97d43673dc3">
                                    <div class="InputField">
                                        <input id="account_id" type="text" value="" style="width: 180px;" />
                                        <input type="hidden" id="account_idHidden" name="account_id" />
                                        <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="z6b3f668402414b6c9dcec97d43673dc3_Button" tabindex="0">
                                            <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span>
                                            <span class="Text"></span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="IconButtonContainer">
                                <a class="Button ButtonIcon IconOnly Ticket NormalState" id="z44012a6c67514279999e6f022e25aeea" tabindex="0" title="View open tickets for this company">
                                    <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span>
                                    <span class="Text"></span>
                                </a>
                            </div>
                            <div class="IconButtonContainer">
                                <a class="Button ButtonIcon IconOnly New NormalState" id="z59d1b4993e9f478d8324db51942e9dd3" tabindex="0">
                                    <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span>
                                    <span class="Text"></span>
                                </a>
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z128f4fa14fb440d78f139b5ea530d3b5">联系人</label>
                            </div>
                        </div>
                        <div class="BundleContainer">
                            <div class="EditorContainer">
                                <div class="Editor SingleDataSelector" >

                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a>

                                </div>
                            </div>
                            <div class="IconButtonContainer"><a class="Button ButtonIcon IconOnly New NormalState" id="zc0bb65ec6e9e4ee098eb0e7f06471f36" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a></div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z0f8233ca12844c0d90b956961965a9ec">状态</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor ItemSelector">
                            <select>
                            </select>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z16f867b9cc4948f284a9980f1414c663">优先级</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor ItemSelector DisplayMode">
                            <select>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="DetailsSection" id="z126f923d8fa64bdbb0c9a93b8ac065a0">
                    <div class="Title">
                        <div class="Text">工单信息</div>
                        <div class="Toggle">
                            <div class="InlineIcon ArrowUp"></div>
                        </div>
                    </div>
                    <div class="Content">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="zc7a692a1635b42808feff18dba9caa7e">问题类型</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor ItemSelector DisplayMode">
                            <select>
                            </select>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z970ee046c95848568070c908a1c5eabc">子问题类型</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor ItemSelector DisplayMode">
                            <select></select>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="zf7ea33e197234818a1b33f6fff22a359">工单来源</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor ItemSelector">
                            <select>
                            </select>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z3a5d8ff6988342a19e91f94cc6df9bac">截止日期</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="DateAndTimeEditor">
                            <div class="Editor DateBox" data-editor-id="z3a5d8ff6988342a19e91f94cc6df9bac" data-rdp="z3a5d8ff6988342a19e91f94cc6df9bac">
                                <div class="InputField">
                                    <div class="Container">
                                        <input id="" type="text" value="" name="DueDate" onclick="WdatePicker()" />
                                    </div>
                                </div>
                            </div>
                            <div class="Editor TimeBox" data-editor-id="za834510435cf4fbb8c06d1b3f10f31cc" data-rdp="za834510435cf4fbb8c06d1b3f10f31cc">
                                <div class="InputField">
                                    <div class="Container">
                                        <input id="" type="text" value="" name="DueTime" onclick="WdatePicker()" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z283b2a7191d944c0843336ed65d9061c">预估时间（小时）</label>
                            </div>
                        </div>
                        <div class="Editor DecimalBox" data-editor-id="z283b2a7191d944c0843336ed65d9061c" data-rdp="z283b2a7191d944c0843336ed65d9061c">
                            <div class="InputField">
                                <input id="" type="text" value="" name="EstimatedHours" maxlength="11" />
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="ze6e7daf6e28548f2988535357baf7c1c">服务等级协议</label>
                            </div>
                        </div>
                        <div class="Editor ItemSelector" id="">
                            <select>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="DetailsSection" id="zb708368cb08a4a639fca44332944c45c">
                    <div class="Title">
                        <div class="Text">分配信息</div>
                        <div class="Toggle">
                            <div class="InlineIcon ArrowUp"></div>
                        </div>
                    </div>
                    <div class="Content">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="zd9763e8d64b548898c071af2a2b1c1cf">队列</label>
                            </div>
                        </div>
                        <div class="Editor ItemSelector DisplayMode" id="">
                           <select>
                           </select>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z8b4cb883cf8148de94850b790e0a980a">主负责人</label>
                            </div>
                        </div>
                        <div class="BundleContainer">
                            <div class="EditorContainer">
                                <div class="Editor SingleDataSelector" id="z8b4cb883cf8148de94850b790e0a980a" data-rdp="z8b4cb883cf8148de94850b790e0a980a" data-editor-id="z8b4cb883cf8148de94850b790e0a980a">
                                    <div class="ContentContainer">
                                        <div class="ValueContainer">
                                            <div class="InputContainer">
                                                <input id="" type="text" value="" name="" />
                                            </div>
                                        </div>
                                    </div>
                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" tabindex="0"><span class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a>
                                </div>
                            </div>
                            <div class="IconButtonContainer">
                                <a class="Button ButtonIcon IconOnly Search NormalState" id="" tabindex="0" title="Find">
                                    <span class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span>
                                    <span class="Text"></span>
                                </a>
                            </div>

                            <div class="IconButtonContainer"><a class="Button ButtonIcon IconOnly Demote DisabledState" id="" tabindex="0" ><span class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a></div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z8895a466d9254112ba49f66bb57d862e">其他负责人</label>
                            </div>
                        </div>
                        <div class="BundleContainer">
                            <div class="EditorContainer">
                                <div class="Editor MultipleDataSelector" id="" >
                                    <div class="ContentContainer">
                                        <div class="ValueContainer">
                                            <div class="InputContainer">
                                                <input id="" type="text" value="" name="SecondaryResources" />
                                            </div>
                                        </div>
                                    </div>
                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" tabindex="0"><span class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a>
                                    <div class="BubbleList" id=""></div>
                                    <a class="Button ButtonIcon IconOnly Swap DisabledState" id="" tabindex="0"><span class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a>
                                </div>
                            </div>
                            <div class="IconButtonContainer"><a class="Button ButtonIcon IconOnly Search NormalState" id="" tabindex="0"><span class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a></div>
                        </div>
                    </div>
                </div>
                <div class="DetailsSection" id="">
                    <div class="Title">
                        <div class="Text">配置项信息</div>
                        <div class="Toggle">
                            <div class="InlineIcon ArrowUp"></div>
                        </div>
                    </div>
                    <div class="Content">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z9de4c50fef644c948218d3cc7eb4f81f">配置项</label>
                            </div>
                        </div>
                        <div class="BundleContainer">
                            <div class="EditorContainer">
                                <div class="Editor BrowseOnly SingleDataSelector">
                                    <div class="ContentContainer">
                                        <div class="ValueContainer">
                                            
                                            <div class="InputContainer">
                                                <input id="" type="text" value="" name="ConfigurationItem" />
                                            </div>
                                            <div class="BubbleList" id=""></div>
                                           
                                        </div>
                                    </div>
                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="zc1a959fa38b14ac3891a548728e6ca75" tabindex="0"><span class="Icon"></span><span class="Text"></span></a>
                                </div>
                            </div>
                            <div class="IconButtonContainer"><a class="Button ButtonIcon IconOnly ContactPhoto DisabledState" id="z390da0602ef943b491131bb902fcd07d" tabindex="0" title="Select a configuration item that belongs to this ticket's contact"><span class="Icon"></span><span class="Text"></span></a></div>
                        </div>
                    </div>
                </div>
                <div class="DetailsSection" id="z24e9e40a6c0c4a54ade24233ea14068e">
                    <div class="Title">
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
                                <input id="contract_id" type="text" value="" autocomplete="off" />
                                <a class="Button ButtonIcon IconOnly DataSelector NormalState" tabindex="0">
                                    <span class="Icon"></span><span class="Text"></span>
                                </a>
                                <input id="contract_idHidden" name="contract_id" type="hidden" value="" />
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z32ee2af4072248cb9d6c60c8fb53cd5a">服务/服务包</label>
                            </div>
                        </div>
                        <div class="Editor Disabled Locked ItemSelector">
                         <select></select>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z28a48ef181d6445e85de2401e5d425bd">工作类型</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor DataSelector">
                            <div class="InputField">
                                <input id="cost_code_id" type="text" value=""  class="" />
                                <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" tabindex="0"><span class="Icon"></span><span class="Text"></span></a>
                                <input id="cost_code_idHidden" name="cost_code_id" type="hidden" " />
                              
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="z49d6078ed4084c789292963936147550">采购订单号</label>
                            </div>
                        </div>
                        <div class="Editor TextBox">
                            <div class="InputField">
                                <input id="" type="text" value="" name="" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="PrimaryContainer">
                <div id="zab75e3ff7fff475eb2d964e48acca733">
                    <div class="HeadingContainer">
                        <div class="IdentificationContainer">
                            <div class="Left">
                                <div>
                                    <div class="CategoryEditorContainer">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="z756d411c072d4d3ca664635ea5153e76">工单种类</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor ItemSelector">
                                          <select></select>
                                        </div>
                                    </div>
                                    <div class="TypeEditorContainer">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="z53bf2f4e4a1c43eaa33c1b6fa84867ce">工单类型</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor ItemSelector">
                                            <select></select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Right">
                                <div class="StopwatchContainer" id="z5ee7a7916f704609bc740835fa09b403">
                                    <div class="StopwatchTime">00:09:27</div>
                                    <div class="StopwatchButton StopwatchIcon Normal Play Pause" title="Start/Pause"></div>
                                    <div class="StopwatchButton StopwatchIcon Normal Record" title="Record"></div>
                                    <div class="StopwatchButton StopwatchIcon Normal Stop" title="Clear"></div>
                                </div>
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="zf39e7633870b4694868c41a1fb226efd">工单标题</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor AdjustingTextBox" data-editor-id="zf39e7633870b4694868c41a1fb226efd" data-rdp="zf39e7633870b4694868c41a1fb226efd">
                            <div class="InputField">
                               <input type="text" id="title" name="title" value="" />
                            </div>
                        </div>
                    </div>
                    <div class="Divider">
                        <div class="Line"></div>
                    </div>
                    <div class="BodyContainer">
                        <div class="Normal Section" id="z65a6cc9453c84fcb82ba4d812b8e060f">
                            <div class="Heading" data-toggle-enabled="true">
                                <div class="Toggle Collapse">
                                    <div class="Vertical"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <div class="Left"><span class="Text">描述</span></div>
                                <div class="Middle"></div>
                                <div class="Spacer"></div>
                                <div class="Right"></div>
                            </div>
                            <div class="Content">
                                <div class="Editor TextArea">
                                    <div class="InputField">
                                        <textarea class="Medium" id="" name="Description"></textarea>
                                    </div>
                                    <div class="CharacterInformation"><span class="CurrentCount">0</span>/<span class="Maximum">8000</span></div>
                                </div>
                            </div>
                        </div>
                        <div class="Normal Section EntityBodyGridSection" id="z3f55565a3b6c4a8abc7ed706c437ea5b">
                            <div class="Heading" data-toggle-enabled="true">
                                <div class="Toggle Collapse">
                                    <div class="Vertical"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <div class="Left"><span class="Text">检查单</span></div>
                                <div class="Middle"></div>
                                <div class="Spacer"></div>
                                <div class="Right"></div>
                            </div>
                            <div class="DescriptionText">You may enter up to 20 total items (ad-hoc, from a saved Library checklist, or a mixture of both).</div>
                            <div class="Content">
                                <div class="ToolBar">
                                    <div class="ToolBarItem Left ButtonGroupStart"><a class="Button ButtonIcon New NormalState" id="z49cc7366e60d44359cd5f6ddac01257b" tabindex="0"><span class="Icon"></span><span class="Text">New Checklist Item</span></a></div>
                                    <div class="ToolBarItem Left"><a class="Button ButtonIcon NormalState" id="zd89e136d300f40dbabe0b2358a813481" tabindex="0"><span class="Icon"></span><span class="Text">Add from Library</span></a></div>
                                    <div class="ToolBarItem Left ButtonGroupEnd"><a class="Button ButtonIcon NormalState" id="ze2f8766a4301482d94a70315b3da0fc4" tabindex="0"><span class="Icon"></span><span class="Text">Save to Library</span></a></div>
                                    <div class="Spacer"></div>
                                </div>
                                <div class="Grid Small" id="TicketChecklistItemsGrid">
                                    <div class="HeaderContainer">
                                        <table cellpadding="0">
                                            <colgroup>
                                                <col class=" Interaction" data-drag-item-above-item-text="Move item above item {0}" data-drag-item-below-item-text="Move item below item {0}" data-drag-item-into-item-text="Move item into item {0}" data-drag-items-above-item-text="Move {1} items above item {0}" data-drag-items-below-item-text="Move {1} items below item {0}" data-drag-items-into-item-text="Move {1} items into item {0}">
                                                <col class=" Context">
                                                <col class="Width16 Image" data-persistence-key="">
                                                <col class=" Boolean" data-persistence-key="IsComplete" data-unique-css-class="U3">
                                                <col class=" Text DynamicSizing" data-persistence-key="Name" data-unique-css-class="U4" style="width: auto;">
                                                <col class=" Boolean" data-persistence-key="IsImportant" data-unique-css-class="U5">
                                            </colgroup>
                                            <tbody>
                                                <tr class="HeadingRow">
                                                    <td class=" Interaction DragEnabled">
                                                        <div class="Standard"></div>
                                                    </td>
                                                    <td class=" Context">
                                                        <div class="Standard">
                                                            <div></div>
                                                        </div>
                                                    </td>
                                                    <td class=" Image">
                                                        <div class="Standard">
                                                            <div class="BookOpen ButtonIcon">
                                                                <div class="Icon"></div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class=" Boolean">
                                                        <div class="Standard">
                                                            <div class="Heading">Completed</div>
                                                        </div>
                                                    </td>
                                                    <td class=" Text Dynamic">
                                                        <div class="Standard">
                                                            <div class="Heading">Item Name</div>
                                                        </div>
                                                    </td>
                                                    <td class=" Boolean">
                                                        <div class="Standard">
                                                            <div class="Heading">Important</div>
                                                        </div>
                                                    </td>
                                                    <td class="ScrollBarSpacer" style="width: 19px;"></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="ScrollingContentContainer">
                                        <div class="NoDataMessage">No items to display</div>
                                        <div class="RowContainer BodyContainer">
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
                                                    <tr class="D Selected" data-key-field-value="69b5972f-77cf-438b-8f76-c089a0c8788c_1__2" data-prevent-editing="true" id="TicketChecklistItemsGrid_69b5972f-77cf-438b-8f76-c089a0c8788c_1__2">
                                                        <td class="Interaction  U0">
                                                            <div>
                                                                <div class="Decoration Icon DragHandle"></div>
                                                                <div class="Text">1</div>
                                                            </div>
                                                        </td>
                                                        <td class="Context  U1"><a class="ButtonIcon Button ContextMenu NormalState">
                                                            <div class="Icon"></div>
                                                        </a></td>
                                                        <td class=" U2"></td>
                                                        <td class=" U3" data-bpn="IsComplete">
                                                            <div class="ChecklistIcon CheckBox Empty" id="TicketChecklistItemsGridIsComplete69b5972f-77cf-438b-8f76-c089a0c8788c_1__2">
                                                                <div class="Icon" tabindex="0"></div>
                                                            </div>
                                                        </td>
                                                        <td class=" U4" data-bpn="Name">
                                                            <div class="Editor TextBox" data-editor-id="TicketChecklistItemsGridName69b5972f-77cf-438b-8f76-c089a0c8788c_1__2">
                                                                <div class="InputField">
                                                                    <input id="TicketChecklistItemsGridName69b5972f-77cf-438b-8f76-c089a0c8788c_1__2" type="text" value="" data-val-ignoredrequired="Required" data-val-length="Character limit (255) exceeded" data-val-length-max="255" data-val-editor-id="TicketChecklistItemsGridName69b5972f-77cf-438b-8f76-c089a0c8788c_1__2" data-val-position="1" maxlength="255">
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="Boolean  U5" data-bpn="IsImportant">
                                                            <div class="Editor CheckBox" data-editor-id="TicketChecklistItemsGridIsImportant69b5972f-77cf-438b-8f76-c089a0c8788c_1__2">
                                                                <div class="InputField">
                                                                    <div>
                                                                        <input id="TicketChecklistItemsGridIsImportant69b5972f-77cf-438b-8f76-c089a0c8788c_1__2" type="checkbox" value="true">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="D" data-key-field-value="69b5972f-77cf-438b-8f76-c089a0c8788c_1__4" data-prevent-editing="true" id="TicketChecklistItemsGrid_69b5972f-77cf-438b-8f76-c089a0c8788c_1__4">
                                                        <td class="Interaction  U0">
                                                            <div>
                                                                <div class="Decoration Icon DragHandle"></div>
                                                                <div class="Text">2</div>
                                                            </div>
                                                        </td>
                                                        <td class="Context  U1"><a class="ButtonIcon Button ContextMenu NormalState">
                                                            <div class="Icon"></div>
                                                        </a></td>
                                                        <td class=" U2"></td>
                                                        <td class=" U3" data-bpn="IsComplete">
                                                            <div class="ChecklistIcon CheckBox Empty" id="TicketChecklistItemsGridIsComplete69b5972f-77cf-438b-8f76-c089a0c8788c_1__4">
                                                                <div class="Icon" tabindex="0"></div>
                                                            </div>
                                                        </td>
                                                        <td class=" U4" data-bpn="Name">
                                                            <div class="Editor TextBox" data-editor-id="TicketChecklistItemsGridName69b5972f-77cf-438b-8f76-c089a0c8788c_1__4">
                                                                <div class="InputField">
                                                                    <input id="TicketChecklistItemsGridName69b5972f-77cf-438b-8f76-c089a0c8788c_1__4" type="text" value="1346" data-val-ignoredrequired="Required" data-val-length="Character limit (255) exceeded" data-val-length-max="255" data-val-editor-id="TicketChecklistItemsGridName69b5972f-77cf-438b-8f76-c089a0c8788c_1__4" data-val-position="1" maxlength="255">
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="Boolean  U5" data-bpn="IsImportant">
                                                            <div class="Editor CheckBox" data-editor-id="TicketChecklistItemsGridIsImportant69b5972f-77cf-438b-8f76-c089a0c8788c_1__4">
                                                                <div class="InputField">
                                                                    <div>
                                                                        <input id="TicketChecklistItemsGridIsImportant69b5972f-77cf-438b-8f76-c089a0c8788c_1__4" type="checkbox" value="true">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr class="D" data-key-field-value="69b5972f-77cf-438b-8f76-c089a0c8788c_1__3" data-prevent-editing="true" id="TicketChecklistItemsGrid_69b5972f-77cf-438b-8f76-c089a0c8788c_1__3">
                                                        <td class="Interaction  U0">
                                                            <div>
                                                                <div class="Decoration Icon DragHandle"></div>
                                                                <div class="Text">3</div>
                                                            </div>
                                                        </td>
                                                        <td class="Context  U1"><a class="ButtonIcon Button ContextMenu NormalState">
                                                            <div class="Icon"></div>
                                                        </a></td>
                                                        <td class=" U2"></td>
                                                        <td class=" U3" data-bpn="IsComplete">
                                                            <div class="ChecklistIcon CheckBox Empty" id="TicketChecklistItemsGridIsComplete69b5972f-77cf-438b-8f76-c089a0c8788c_1__3">
                                                                <div class="Icon" tabindex="0"></div>
                                                            </div>
                                                        </td>
                                                        <td class=" U4" data-bpn="Name">
                                                            <div class="Editor TextBox" data-editor-id="TicketChecklistItemsGridName69b5972f-77cf-438b-8f76-c089a0c8788c_1__3">
                                                                <div class="InputField">
                                                                    <input id="TicketChecklistItemsGridName69b5972f-77cf-438b-8f76-c089a0c8788c_1__3" type="text" value="" data-val-ignoredrequired="Required" data-val-length="Character limit (255) exceeded" data-val-length-max="255" data-val-editor-id="TicketChecklistItemsGridName69b5972f-77cf-438b-8f76-c089a0c8788c_1__3" data-val-position="1" maxlength="255">
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="Boolean  U5" data-bpn="IsImportant">
                                                            <div class="Editor CheckBox" data-editor-id="TicketChecklistItemsGridIsImportant69b5972f-77cf-438b-8f76-c089a0c8788c_1__3">
                                                                <div class="InputField">
                                                                    <div>
                                                                        <input id="TicketChecklistItemsGridIsImportant69b5972f-77cf-438b-8f76-c089a0c8788c_1__3" type="checkbox" value="true">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <div class="ContextOverlayContainer" id="TicketChecklistItemsGrid_ContextOverlay">
                                                <div class="ContextOverlay" style="left: 521.198px; top: 401.958px;">
                                                    <div class="Bottom Arrow Outline" style="left: 1px;"></div>
                                                    <div class="Bottom Arrow" style="left: 1px;"></div>
                                                    <div class="LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                                <div class="ContextOverlay">
                                                    <div class="Outline Arrow"></div>
                                                    <div class="Arrow"></div>
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                            </div>
                                            <div class="DragIndicator">
                                                <div class="Bar"></div>
                                                <div class="LeftArrow"></div>
                                                <div class="RightArrow"></div>
                                            </div>
                                            <div class="DragStatus"></div>
                                        </div>
                                    </div>
                                    <div class="FooterContainer"></div>
                                </div>
                            </div>
                        </div>
                        <div class="Normal Section" id="z873ff391d2dd4c20b0943a02e97c4832">
                            <div class="Heading" data-toggle-enabled="true">
                                <div class="Toggle Collapse">
                                    <div class="Vertical"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <div class="Left"><span class="Text">Resolution</span></div>
                                <div class="Middle"></div>
                                <div class="Spacer"></div>
                                <div class="Right"></div>
                            </div>
                            <div class="Content">
                                <div class="Editor TextArea" data-editor-id="z171288ca4dbd49f9a339419806e531ad" data-rdp="z171288ca4dbd49f9a339419806e531ad">
                                    <div class="InputField">
                                        <textarea class="Medium" id="z171288ca4dbd49f9a339419806e531ad" name="Resolution" placeholder="" data-val-length="Character limit (32000) exceeded" data-val-length-max="32000" data-val-editor-id="z171288ca4dbd49f9a339419806e531ad" data-val-position="0"></textarea>
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
                        <div class="Title">
                            <div class="Text">Company/Contact </div>
                            <div class="Toggle">
                                <div class="InlineIcon ArrowUpSmall"></div>
                            </div>
                        </div>
                        <div class="ContentContainer">
                            <div class="LoadingIndicator"></div>
                            <div class="TransitionContainer Transition"></div>
                            <div class="Content" id="zb2c0b8f683a84e13849e34e1ab66831e">
                                <div class="LinkButton HighImportance"><a class="Button ButtonIcon Link NormalState" id="zc591c15e6bcb459a8622eca0066ed524" tabindex="0" title="Open Company Detail">AMATANTEN</a></div>
                                <div class="Bundle">
                                    <div class="LinkButton"><a class="Button ButtonIcon Link NormalState" id="ze631934e44804cebba8fe70667a37e49" tabindex="0" title="Open Site Configuration">Site Configuration</a></div>
                                </div>
                                <div class="NormalSpacer"></div>
                                <div class="Text Address">
                                    Australia<div class="InsightIconButton">
                                        <div class="InlineIconButton InlineIcon Map NormalState" id="z9d47ac591de44624ae8918f3d183f434" title="View Map"></div>
                                    </div>
                                </div>
                                <div class="NormalSpacer"></div>
                                <div class="Text">6327654</div>
                                <div class="Text"></div>
                                <div class="Text"></div>
                                <div class="NormalSpacer"></div>
                                <div class="LinkButton"><a class="Button ButtonIcon Link NormalState" id="z82d31d2023c048b7b79aa33ba81443c1" tabindex="0" title="1 non-recurring ticket(s) + 0 recurring ticket(s)">All Open Tickets (1)</a></div>
                                <div class="Text">Last 30 Days (0)</div>
                                <div class="NormalSpacer"></div>
                                <div class="Divider">
                                    <div class="Line"></div>
                                </div>
                                <div class="Text NoData VeryLowImportance">No Contact</div>
                            </div>
                        </div>
                    </div>
                    <div class="InsightShell Collapsed" id="z098c323f56ce4e8ba7e2c9ea933a47de">
                        <div class="Title">
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
                        <div class="Title">
                            <div class="Text">Configuration Item</div>
                            <div class="Toggle">
                                <div class="InlineIcon ArrowUpSmall"></div>
                            </div>
                        </div>
                        <div class="ContentContainer">
                            <div class="LoadingIndicator"></div>
                            <div class="TransitionContainer Transition"></div>
                            <div class="Content" id="z50db6349cd474a178337d0e566b07b05">
                                <div class="Text NoData VeryLowImportance">Nothing to display</div>
                            </div>
                        </div>
                    </div>
                    <div class="InsightShell Invisible" id="za4e05a3de99042b09d62b550b4b766bf">
                        <div class="Title">
                            <div class="Text">Opportunity</div>
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
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $(function () {

    })

    function ClosePage() {
        window.close();
    }

    setInterval(function () { },1000);
</script>
