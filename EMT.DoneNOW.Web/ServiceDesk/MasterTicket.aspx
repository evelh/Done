<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MasterTicket.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.MasterTicket" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %>定期主工单</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/index.css" />
    <link rel="stylesheet" href="../Content/style.css" />
    <link href="../Content/MasterTicket.css" rel="stylesheet" />
    <style>
        .content label {
            width: 120px;
        }

        .CloseButton {
            background-image: url(../Images/delete.png);
            width: 16px;
            height: 16px;
            float: left;
        }

        .mytitle {
            margin-left: -620px;
        }

        .grid thead tr td {
            background-color: #cbd9e4;
            border-color: #98b4ca;
            color: #64727a;
        }

        .grid {
            font-size: 12px;
            background-color: #FFF;
        }

            .grid thead td {
                border-width: 1px;
                border-style: solid;
                font-size: 13px;
                font-weight: bold;
                height: 19px;
                padding: 4px 4px 4px 4px;
                word-wrap: break-word;
                vertical-align: top;
            }

            .grid table {
                border-collapse: collapse;
                width: 100%;
                border-bottom-width: 1px;
                /*border-bottom-style: solid;*/
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

        .CkTitle {
            margin-left: 40px;
            float: left;
            margin-top: 5px;
        }

        .AddItemToTicketTopSection {
            color: #4F4F4F;
            padding: 10px;
            background-repeat: no-repeat;
            background-position: left;
            padding-left: 40px;
            border: none;
        }

        .AddNoteTitleImage {
            background-image: url(../Images/TicketNoteIcon.png);
        }

        .Popup_TitleCell {
            height: 30px;
        }

        .AddItemToTicketTopSection td[class="Popup_TitleCell"] span {
            font-size: 16px;
            font-weight: Bold;
        }

        .Popup_Title {
            font-size: 19px;
            color: #4F4F4F;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增":"编辑" %>定期主工单</div>
        <div class="header-title">
            <ul>
                <li id="SaveNew">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save" runat="server" Text="保存" OnClick="save_Click" />
                </li>
                <li id="SaveClose">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" />
                </li>
                <li id="Close">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <input type="button" id="CloseButton" value="取消" />
                </li>
            </ul>
        </div>
        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="">默认</li>
                <li id="">周期</li>
                <li id="">备注</li>
                <li id="">附件</li>
                <li id="">自定义字段</li>
                <li id="">服务预定</li>
                <li id="">通知</li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 132px;">
            <div class="content clear">
                <div id="pnlTab_1" style="height: 100%; width: 100%;">
                    <div style="height: 447px; position: static; overflow-y: auto; overflow-x: hidden;">
                        <div id="Panel2" style="margin-top: 10px; padding-bottom: 10px;">
                            <table cellspacing="0" cellpadding="0" border="0" style="margin-left: 10px; width: 766px;">
                                <tbody>
                                    <tr valign="bottom">
                                        <td style="width: 300px; padding: 10px,0px,0px,0px;"><span class="lblNormalClass" style="font-weight: bold;">客户名称</span><span class="lblNormalClass" style="color: Red; font-weight: bold;"> *</span></td>
                                        <td colspan="2" style="padding: 10px,0px,0px,0px;"><span class="lblNormalClass" style="font-weight: bold;">工单标题</span><span class="lblNormalClass" style="color: Red; font-weight: bold;"> *</span></td>
                                    </tr>
                                    <tr valign="top">
                                        <td style="padding-bottom: 10px; padding-right: 35px;">
                                            <input name="account_id" type="hidden" id="accountIdHidden" value="<%=thisAccount==null?"":thisAccount.id.ToString() %>" /><nobr><span id="AcdataSelector"  style="display:inline-block;"><input name="" type="text" value="<%=thisAccount==null?"":thisAccount.name %>" id="accountId" class="txtBlack8Class" autocomplete="off" style="width:200px;" /></span>&nbsp;<a href="#" id="AcdataSelector_anchor" class="DataSelectorLinkIcon" onclick="CallBackAccount()" ><img id="AcdataSelector_image" src="../Images/data-selector.png" align="top" border="0" style="cursor:pointer;" /></a></nobr></td>
                                        <td colspan="2" style="padding-bottom: 10px;"><span id="txtTicketTitle" style="display: inline-block;">
                                            <input name="title" type="text" maxlength="255" id="title" class="txtBlack8Class" style="width: 480px;" value="<%=thisTicket!=null?thisTicket.title:"" %>" /></span></td>
                                    </tr>
                                    <tr>
                                        <td valign="bottom" style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">地址</span></td>
                                        <td valign="bottom" style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">描述</span></td>
                                    </tr>
                                    <tr>
                                        <td valign="top" style="padding-bottom: 10px;"><span id="accountAddress" class="lblNormalClass" style="font-weight: normal;"></span></td>
                                        <td valign="top" colspan="2" style="padding-bottom: 10px;"><span id="txtDescription" style="display: inline-block;">
                                            <textarea name="description" id="description" class="txtBlack8Class" maxlength="4000" style="height: 50px; width: 480px; behavior: url(/autotask/Behaviors/TextAreaMaxLength.htc?v=45785);"><%=thisTicket!=null?thisTicket.description:"" %></textarea></span><%--<img id="imgSearch" src="../Images/data-selector.png" align="top" border="0" style="cursor: pointer; padding-left: 4px;" />--%></td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">联系人</span></td>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">队列</span></td>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">负责人</span></td>
                                    </tr>
                                    <tr>
                                        <td id="_ctl162" style="padding-bottom: 10px;">
                                            <div id="accountContact_ContactSelectorPanel">

                                                <table id="accountContact_hybridControlTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                    <tbody>
                                                        <tr>
                                                            <td id="accountContact_ContactDropdownCell"><span id="accountContact_ContactDropDown" style="display: inline-block;">
                                                                <select name="contact_id" id="contact_id" class="txtBlack8Class" style="width: 200px;">
                                                                </select></span></td>
                                                            <td id="accountContact_DataSeletorCell" style="display: none;"></td>
                                                            <td id="accountContact_AdditionalControlCell"></td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                            </div>
                                        </td>
                                        <td style="padding-bottom: 10px; padding-right: 84px;">
                                            <span id="ddlQueue" style="display: inline-block;">
                                                <asp:DropDownList ID="department_id" runat="server" CssClass="txtBlack8Class" Width="200px"></asp:DropDownList>
                                            </span>
                                        </td>
                                        <td style="padding-bottom: 10px;">
                                            <input name="resDepId" type="hidden" id="resDepIdHidden" value="" /><nobr><span  style="display:inline-block;"><input name="" type="text" value="" id="resDepId" class="txtBlack8Class" style="width:200px;" /></span>&nbsp;<a href="#" id="" class="DataSelectorLinkIcon" onclick="ChoosePriRes()" ><img src="../Images/data-selector.png" align="top" border="0" style="cursor:pointer;" /></a></nobr>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">工单来源</span><span class="lblNormalClass" style="color: Red; font-weight: bold;"> *</span></td>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">问题类型</span></td>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">子问题类型</span></td>
                                    </tr>
                                    <tr>
                                        <td valign="top" style="padding-bottom: 10px;">
                                            <span id="ddlSource" style="display: inline-block;">
                                                <asp:DropDownList ID="source_type_id" runat="server" CssClass="txtBlack8Class" Width="200px"></asp:DropDownList>
                                            </span></td>
                                        <td style="padding-bottom: 10px;"><span id="IssueType" style="display: inline-block;">
                                            <asp:DropDownList ID="issue_type_id" runat="server" CssClass="txtBlack8Class" Width="200px"></asp:DropDownList></span></td>
                                        <td style="padding-bottom: 10px;">
                                            <span id="SubIssueType" style="display: inline-block;">
                                                <select name="sub_issue_type_id" id="sub_issue_type_id" class="txtBlack8Class" style="width: 200px;">
                                                </select>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 0px;">
                                            <table cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td style="padding-right: 45px;"><span class="lblNormalClass" style="font-weight: bold;">截止时间</span><span class="lblNormalClass" style="color: Red; font-weight: bold;"> *</span></td>
                                                        <td><span class="lblNormalClass" style="font-weight: bold;">预估时间（小时）</span></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">状态</span><span class="lblNormalClass" style="color: Red; font-weight: bold;"> *</span></td>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">优先级</span><span class="lblNormalClass" style="color: Red; font-weight: bold;"> *</span></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-bottom: 10px;">
                                            <table cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td style="padding-right: 15px;"><span id="txtDueTime" style="display: inline-block;">
                                                            <input name="dueTime" type="text" id="dueTime" class="txtBlack8Class" style="width: 80px;" onclick="WdatePicker({ dateFmt: 'HH:mm' })" />&nbsp;</span></td>
                                                        <td><span id="EstimatedHours" style="display: inline-block;">
                                                            <input name="estimated_hours" type="text" id="estimated_hours" class="txtBlack8Class" style="width: 90px;" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" /></span></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td style="padding-bottom: 10px;"><span id="ddlStatus" style="display: inline-block;">
                                            <asp:DropDownList ID="status_id" runat="server" CssClass="txtBlack8Class" Width="200px"></asp:DropDownList>
                                        </span></td>
                                        <td style="padding-bottom: 10px;"><span id="ddlPriority" style="display: inline-block;">
                                            <asp:DropDownList ID="priority_type_id" runat="server" CssClass="txtBlack8Class" Width="200px"></asp:DropDownList>
                                        </span></td>
                                    </tr>

                                    <tr>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">合同</span></td>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">工作类型</span></td>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">工单种类</span></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-bottom: 10px;">
                                            <input name="contract_id" type="hidden" id="contractIdHidden" /><nobr><span id="ContractdataSelector" style="display:inline-block;"><input  type="text" id="contractId" class="txtBlack8Class" style="width:204px;" /></span>&nbsp;<a href="#" id="ContractdataSelector_anchor" class="DataSelectorLinkIcon" align="top" border="0" style="cursor:pointer;" onclick="ContractCallBack()"><img src="../Images/data-selector.png" align="top" border="0" style="cursor:pointer;" /></a></nobr></td>
                                        <td style="padding-bottom: 10px;">
                                            <span id="ddlAllocationCode" style="display: inline-block;">
                                                <asp:DropDownList ID="cost_code_id" runat="server" CssClass="txtBlack8Class" Width="200px"></asp:DropDownList>
                                            </span>
                                        </td>
                                        <td style="padding-bottom: 10px;">
                                            <span id="ddlTicketCategory" style="display: inline-block;">
                                                <asp:DropDownList ID="cate_id" runat="server" CssClass="txtBlack8Class" Width="200px"></asp:DropDownList>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">配置项</span></td>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;">采购订单号</span></td>
                                        <td style="padding: 0px;"><span class="lblNormalClass" style="font-weight: bold;"></span></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-bottom: 10px;">
                                            <input name="installed_product_id" type="hidden" id="InsProIdHidden" /><nobr><span id="DataSelectorIP"  style="display:inline-block;"><input name="" type="text" id="InsProId" class="txtBlack8Class" style="width:204px;" /></span>&nbsp;<a href="#" id="DataSelectorIP_anchor" class="DataSelectorLinkIcon" onclick="InsProCallBack()"><img id="DataSelectorIP_image" src="../Images/data-selector.png" align="top" border="0" style="cursor:pointer;" /></a></nobr></td>

                                        <td style="padding: 0px;"><span id="txtPurchaseOrderNumber" title="" style="display: inline-block;">
                                            <input name="purchase_order_no" type="text" maxlength="50" id="purchase_order_no" class="txtBlack8Class" style="width: 204px;" /></span></td>
                                        <td style="padding-bottom: 10px;"></td>
                                    </tr>

                                </tbody>
                            </table>
                        </div>
                        <div id="panelDesc" style="height: 360px; display: none; top: 110px;">
                            <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                <tbody>
                                    <tr valign="middle">
                                        <td style="width: 2px;"><span class="lblNormalClass" style="font-weight: bold;">
                                            <img src="/autotask/images/clearpixel.gif?v=1"></span></td>
                                        <td style="width: 260px;"><span class="lblNormalClass" style="font-weight: bold;">Large Text View - Description</span></td>
                                        <td style="width: 260px;">&nbsp;</td>
                                        <td align="right" style="width: 260px;"></td>
                                        <td style="width: 2px;"><span class="lblNormalClass" style="font-weight: bold;">
                                            <img src="/autotask/images/clearpixel.gif?v=1"></span></td>
                                    </tr>
                                    <tr valign="top">
                                        <td style="width: 4px;"></td>
                                        <td colspan="3"><span id="txtLargeDesc" style="display: inline-block; display: block;">
                                            <textarea name="txtLargeDesc:ATTextEdit" id="txtLargeDesc_ATTextEdit" class="txtBlack8Class" maxlength="4000" style="height: 250px; width: 100%; behavior: url(/autotask/Behaviors/TextAreaMaxLength.htc?v=45785);"></textarea></span></td>
                                        <td style="text-align: right; width: 30px;">
                                            <img onclick="ViewSmallText()" src="/autotask/images/icons/zoom-out.png?v=45785" align="middle" border="0" style="cursor: pointer;"></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="content clear">
                <div id="pnlTab_2" style="height: 100%; width: 100%;">
                    <div id="Page2Panel" style="height: 324px; position: static; min-height: 412px;">
                        <div class="DivSectionWithHeader" style="margin-top: 10px; height: 180px;">
                            <div class="HeaderRow">
                                <span class="lblNormalClass" style="font-weight: bold;">持续时间<font style="color: Red;">*</font></span>
                            </div>
                            <div class="Content">
                                <div class="TabLevelInstruction" style="display: none;">
                                    <span class="lblNormalClass" style="font-weight: normal;">Service calls have already been created for this recurrence master. If you extend the duration, new service calls will not be created.</span>
                                </div>
                                <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td><span class="lblNormalClass" style="font-weight: bold; padding-left: 8px;">开始时间</span></td>
                                            <td style="padding-bottom: 10px;"><span id="txtStartDate">
                                                <input name="recurring_start_date" type="text" id="recurring_start_date" class="txtBlack8Class" onclick="WdatePicker()" />&nbsp;</span><span id="chkActive" style="padding-left: 212px;"><span class="txtBlack8Class"><input id="ckActive" type="checkbox" name="ckActive" checked="checked" style="vertical-align: middle;" /><label style="vertical-align: middle; width: 150px;">激活(只影响主工单的搜索)</label></span></span><span class="FieldLevelInstruction" style="font-weight: normal;"></span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table id="endDurationRadio" class="txtBlack8Class" cellpadding="6" border="0">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <input id="ckEndTime" type="radio" name="ckEndTime" value="ckEndTime" checked="checked" />
                                                                <label>结束时间</label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <input id="ckEndNumber" type="radio" name="ckEndTime" value="ckEndNumber" />
                                                                <label>实例数</label>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                            <td valign="top" style="padding-bottom: 10px;">
                                                <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                    <tbody>
                                                        <tr>
                                                            <td style="padding-bottom: 10px;"><span id="txtEndDate">
                                                                <input name="recurring_end_date" type="text" id="recurring_end_date" class="txtBlack8Class" onclick="WdatePicker()" />
                                                                &nbsp;</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-top: 3px;"><span id="txtEndAfterInstances" style="display: inline-block;">
                                                                <input name="recurring_instances" type="text" maxlength="3" id="recurring_instances" disabled="disabled" class="txtBlack8Class" style="width: 60px; text-align: right; margin-top: 6px;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" /></span><span class="txtBlack8Class" style="font-weight: normal;">&nbsp;实例</span></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="DivSectionWithHeader" style="margin-top: 10px; height: 215px;">
                            <div class="HeaderRow">
                                <span class="lblNormalClass" style="font-weight: bold;">频次<font style="color: Red;">*</font></span>
                            </div>
                            <div class="Content">
                                <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse; margin-top: -2px; width: 550px;">
                                    <tbody>
                                        <tr>
                                            <td style="height: 94px; padding-bottom: 10px; max-width: 110px; width: 100px;">
                                                <table id="rdoFreq" class="txtBlack8Class" border="0">
                                                    <tbody>
                                                        <tr>
                                                            <td><span style="white-space: nowrap;">
                                                                <input id="rdoFreq_0" type="radio" name="rdoFreq" value="Daily" /><label for="rdoFreq_0">天</label></span></td>
                                                        </tr>
                                                        <tr>
                                                            <td><span style="white-space: nowrap;">
                                                                <input id="rdoFreq_1" type="radio" name="rdoFreq" value="Weekly" /><label for="rdoFreq_1">周</label></span></td>
                                                        </tr>
                                                        <tr>
                                                            <td><span style="white-space: nowrap;">
                                                                <input id="rdoFreq_2" type="radio" name="rdoFreq" value="Monthly" checked="checked" /><label>月</label></span></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <input id="rdoFreq_3" type="radio" name="rdoFreq" value="Yearly" /><label for="rdoFreq_3">年</label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                            <td style="padding-top: 0px; padding-left: 50px;">
                                                <div id="pnlDaily" style="display: none;" class="FrequencyClass">
                                                    <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                        <tbody>
                                                            <tr>
                                                                <td><span class="lblNormalClass" style="font-weight: bold;">每</span><span id="dailyTxtNumOfDays" style="display: inline-block; padding-top: 15px; height: 32px;">
                                                                    <input name="day_eve_day" type="text" value="1" maxlength="2" id="day_eve_day" class="txtBlack8Class" style="width: 40px; text-align: right;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" /></span><span class="lblNormalClass" style="font-weight: bold;">天</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="padding: 0px,0px,0px,85px;"><span id="chkDoNotCreateSat"><span class="txtBlack8Class">
                                                                    <input id="ckNotInSat" type="checkbox" name="ckNotInSat" style="vertical-align: middle;" /><label style="vertical-align: middle;width: 100px;">周六不生成工单</label></span></span></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="padding: 0px,0px,0px,85px;"><span id="chkDoNotCreateSun"><span class="txtBlack8Class">
                                                                    <input id="ckNotInSun" type="checkbox" name="ckNotInSun" style="vertical-align: middle;" /><label style="vertical-align: middle;width: 100px;">周日不生成工单</label></span></span></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <div id="pnlWeekly" style="display: none;" class="FrequencyClass">
                                                    <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="3" style="padding: 0px,0px,0px,90px;"><span class="lblNormalClass" style="font-weight: bold;">每</span><span id="weeklyNumOfWeeks" style="display: inline-block; height: 18px;">
                                                                    <input name="week_eve_week" type="text" value="1" maxlength="2" id="week_eve_week" class="txtBlack8Class" style="width: 40px; text-align: right;" /></span><span class="lblNormalClass" style="font-weight: bold;">周</span></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="width: 100px; padding: 0px,0px,0px,85px;"><span id="chkSunday"><span class="txtBlack8Class">
                                                                    <input id="ckWeekSun" type="checkbox" name="ckWeekSun" style="vertical-align: middle;" /><label style="vertical-align: middle;">星期天</label></span></span></td>
                                                                <td style="width: 100px;"><span id="chkWednesday"><span class="txtBlack8Class">
                                                                    <input id="ckWeekWed" type="checkbox" name="ckWeekWed" style="vertical-align: middle;" /><label style="vertical-align: middle;">星期三</label></span></span></td>
                                                                <td style="width: 100px;"><span id="chkSaturday"><span class="txtBlack8Class">
                                                                    <input id="ckWeekSat" type="checkbox" name="ckWeekSat" style="vertical-align: middle;" /><label style="vertical-align: middle;">星期六</label></span></span></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="padding: 0px,0px,0px,85px;"><span id="chkMonday"><span class="txtBlack8Class">
                                                                    <input id="ckWeekMon" type="checkbox" name="ckWeekMon" style="vertical-align: middle;" /><label style="vertical-align: middle;">星期一</label></span></span></td>
                                                                <td><span id="chkThursday"><span class="txtBlack8Class">
                                                                    <input id="ckWeekThu" type="checkbox" name="ckWeekThu" style="vertical-align: middle;" /><label style="vertical-align: middle;">星期四</label></span></span></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="padding: 0px,0px,0px,85px;"><span id="chkTuesday"><span class="txtBlack8Class">
                                                                    <input id="ckWeekTus" type="checkbox" name="ckWeekTus" style="vertical-align: middle;" /><label style="vertical-align: middle;">星期二</label></span></span></td>
                                                                <td><span id="chkFriday"><span class="txtBlack8Class">
                                                                    <input id="ckWeekFri" type="checkbox" name="ckWeekFri" style="vertical-align: middle;" /><label style="vertical-align: middle;">星期五</label></span></span></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <div id="pnlMonthly" style="display: inline;" class="FrequencyClass">
                                                    <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="2" style="text-align: left; padding-left: 2px;"><span class="lblNormalClass" style="font-weight: bold;"><%--Due on--%></span></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="padding: 0px,0px,0px,80px;">
                                                                    <table id="radioMonthly" class="txtBlack8Class" cellpadding="6" border="0" style="width:43px;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <input id="radioMonthly_0" type="radio" name="radioMonthly" value="Day" checked="checked" />
                                                                                    <label style="width:12px;">每</label>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <input id="radioMonthly_1" type="radio" name="radioMonthly" value="The" />
                                                                                    <label  style="width:12px;">每</label>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                                <td style="padding: 0px;">
                                                                    <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td valign="top">
                                                                                    <span id="txtDayOfMonth" style="display: inline-block; height: 18px;">
                                                                                        <input name="month_month_num" type="text" value="1" maxlength="2" id="month_day_num" class="txtBlack8Class" style="width: 40px; text-align: right;" /></span><span class="lblNormalClass" style="font-weight: normal;">月</span>
                                                                                    <span id="txtMonthInternal" style="display: inline-block; height: 18px;">
                                                                                        <input name="month_month_day" type="text" maxlength="2" id="month_month_day" class="txtBlack8Class" style="width: 40px; text-align: right;" /></span><span class="lblNormalClass" style="font-weight: normal;">号</span>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <span id="txtDueOnMonths" disabled="disabled" style="display: inline-block; height: 15px;">
                                                                                        <input name="month_month_eve_num" type="text" value="1" maxlength="2" id="month_month_eve_num" class="txtBlack8Class" style="width: 40px; text-align: right;" /></span><span class="lblNormalClass" style="font-weight: normal;">月 </span>
                                                                                    <span id="ddlOccurance" style="display: inline-block; height: 18px;">
                                                                                        <select name="ddlOccurance:ATDropDown" id="ddlOccurance_ATDropDown" disabled="disabled" class="txtBlack8Class" style="width: 100px;">
                                                                                            <option selected="selected" value="1">第一个</option>
                                                                                            <option value="2">第二个</option>
                                                                                            <option value="3">第三个</option>
                                                                                            <option value="4">第四个</option>
                                                                                            <option value="5">最后一个</option>
                                                                                        </select></span>
                                                                                    &nbsp;<span id="ddlDayofweeks" style="display: inline-block; height: 18px;"><select name="ddlDayofweeks:ATDropDown" id="ddlDayofweeks_ATDropDown" disabled="disabled" class="txtBlack8Class" style="width: 125px;">
                                                                                        <option selected="selected" value="1">星期一</option>
                                                                                        <option value="2">星期二</option>
                                                                                        <option value="4">星期三</option>
                                                                                        <option value="8">星期四</option>
                                                                                        <option value="16">星期五</option>
                                                                                        <option value="32">星期六</option>
                                                                                        <option value="64">星期日</option>
                                                                                        <option value="128">Day</option>
                                                                                        <option value="256">Weekday</option>

                                                                                    </select></span><span class="lblNormalClass" style="font-weight: normal;"></span></td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <div id="pnlYearly" style="display: none;" class="FrequencyClass">
                                                    <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                        <tbody>
                                                            <tr>
                                                                <td style="padding: 0px,0px,0px,80px;">
                                                                    <table id="rdoYearlyDue" class="txtBlack8Class" cellpadding="6" border="0" style="width: 56px;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <input id="rdoYearlyDue_0" type="radio" name="rdoYearlyDue" value="Due every" checked="checked" /><label style="width:25px;">每年</label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <input id="rdoYearlyDue_1" type="radio" name="rdoYearlyDue" value="The " /><label  style="width:25px;">每年</label>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                                <td style="padding: 0px;">
                                                                    <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td valign="top">
                                                                                    <span id="yearlySpecificMonth" style="display: inline-block; height: 18px;">
                                                                                    <select name="year_every_month" id="year_every_month" class="txtBlack8Class" style="width: 125px;">
                                                                                        <option selected="selected" value="1">一月</option>
                                                                                        <option value="2">二月</option>
                                                                                        <option value="3">三月</option>
                                                                                        <option value="4">四月</option>
                                                                                        <option value="5">五月</option>
                                                                                        <option value="6">六月</option>
                                                                                        <option value="7">七月</option>
                                                                                        <option value="8">八月</option>
                                                                                        <option value="9">九月</option>
                                                                                        <option value="10">十月</option>
                                                                                        <option value="11">十一月</option>
                                                                                        <option value="12">十二月</option>
                                                                                    </select>
                                                                                </span>
                                                                                    <span class="lblNormalClass" style="font-weight: bold;">&nbsp;&nbsp;月</span>
                                                                                    <span id="yearlySpecificDay" style="display: inline-block;height:15px;">
                                                                                        <input name="yearlySpecificDay:ATTextEdit" type="text" maxlength="2" id="yearlySpecificDay_ATTextEdit" class="txtBlack8Class" style="width: 40px; text-align: right;" /></span>号</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><span id="yearlyRelativeOccurence" disabled="disabled" style="display: inline-block; height: 18px;"> <select name="year_the_month" id="year_the_month" disabled="disabled" class="txtBlack8Class" style="width: 80px;">
                                                                                            <option selected="selected" value="1">January</option>
                                                                                            <option value="2">February</option>
                                                                                            <option value="3">March</option>
                                                                                            <option value="4">April</option>
                                                                                            <option value="5">May</option>
                                                                                            <option value="6">June</option>
                                                                                            <option value="7">July</option>
                                                                                            <option value="8">August</option>
                                                                                            <option value="9">September</option>
                                                                                            <option value="10">October</option>
                                                                                            <option value="11">November</option>
                                                                                            <option value="12">December</option>

                                                                                        </select>
                                                                                    </span>月第
                                                                                    &nbsp;<span id="" disabled="disabled" style="display: inline-block; height: 18px;"><select name="yearlyRelativeOccurence:ATDropDown" id="yearlyRelativeOccurence_ATDropDown" disabled="disabled" class="txtBlack8Class" style="width: 60px;">
                                                                                        <option selected="selected" value="1">First</option>
                                                                                        <option value="2">Second</option>
                                                                                        <option value="3">Third</option>
                                                                                        <option value="4">Fourth</option>
                                                                                        <option value="5">Last</option>

                                                                                    </select></span><span class="lblNormalClass" style="font-weight: normal;">个周 </span><span id="yearlyRelativeMonth" style="display: inline-block; height: 18px;"><select name="year_the_week" id="year_the_week" disabled="disabled" class="txtBlack8Class" style="width: 85px;">
                                                                                        <option selected="selected" value="1">Monday</option>
                                                                                        <option value="2">Tuesday</option>
                                                                                        <option value="4">Wednesday</option>
                                                                                        <option value="8">Thursday</option>
                                                                                        <option value="16">Friday</option>
                                                                                        <option value="32">Saturday</option>
                                                                                        <option value="64">Sunday</option>
                                                                                        <option value="128">Day</option>
                                                                                        <option value="256">Weekday</option>

                                                                                    </select>
                                                                                       </span></td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
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
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/index.js"></script>
<script type="text/javascript" src="../Scripts/common.js"></script>
<script src="../Scripts/NewContact.js"></script>
<script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $("#Close").click(function () {
        window.close();
    })

    function CallBackAccount() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=accountId&callBack=GetDataByAccount", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }

    function GetDataByAccount() {
        // 获取客户地址
        // 填充联系人下拉框
        var accountId = $("#accountIdHidden").val();
        var conHtml = "<option></option>";
        if (accountId != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=GetAccDetail&account_id=" + accountId,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        var AddHtml = "";
                        if (data.address1 != "") {
                            AddHtml += data.address1 + "<br />";
                        }
                        if (data.provice != "" || data.city != "" || data.postalCode != "") {
                            if (data.provice != "") {
                                AddHtml += data.provice + " ";
                            }
                            if (data.city != "") {
                                AddHtml += data.city + " ";
                            }
                            if (data.postalCode != "" && data.postalCode != null) {
                                AddHtml += data.postalCode + " ";
                            }
                            AddHtml += "<br />";
                        }
                        $("#accountAddress").html(AddHtml);
                    }
                },
            });

            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContactAjax.ashx?act=GetConByAccount&account_id=" + accountId,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            conHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                },
            });
        } else {
            $("#accountAddress").html("");
        }
        $("#contact_id").html(conHtml);
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
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&field=resDepId&callBack=GetResByCallBack";
        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 主负责人查找带回事件 - 当带回的主负责人在其他负责人中出现的时候-从其他负责人中删除，然后带回主负责人
    function GetResByCallBack() {
        var owner_resource_id = $("#resDepIdHidden").val();
        if (owner_resource_id != "") {

        } else {
            $("#resDepId").val("");
        }
    }

    function ContractCallBack() {
        var accountId = $("#accountIdHidden").val();
        if (accountId != "") {

            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACTMANAGE_CALLBACK %>&con626=1&con627=" + accountId + "&field=contractId&callBack=GetDataByContract", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>", 'left=200,top=200,width=600,height=800', false);
        }
    }
    function GetDataByContract() {
        var contractIdHidden = $("#contractIdHidden").val();
        if (contractIdHidden != "") {
            // 获取采购订单号
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContractAjax.ashx?act=property&contract_id=" + contractIdHidden + "&property=purchase_order_no",
                //dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#purchase_order_no").val(data);
                    }
                },
            });
        }
    }

    // 配置项的查找带回
    function InsProCallBack() {
        var accountId = $("#accountIdHidden").val();
        if (accountId != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INSPRODUCT_CALLBACK %>&con1247=" + accountId + "&field=InsProId", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>", 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择客户");
        }

    }
</script>
<!-- 工单定期相关JS 处理 -->
<script>
    $("#ckEndTime").click(function () {
        $("#recurring_end_date").prop("disabled", false);
        $("#recurring_instances").prop("disabled", true);
    })
    $("#ckEndNumber").click(function () {
        $("#recurring_end_date").prop("disabled", true);
        $("#recurring_instances").prop("disabled", false);
    })
    $("#rdoFreq_0").click(function () {
        $(".FrequencyClass").hide();
        $("#pnlDaily").show();
    })
    $("#rdoFreq_1").click(function () {
        $(".FrequencyClass").hide();
        $("#pnlWeekly").show();
    })
    $("#rdoFreq_2").click(function () {
        $(".FrequencyClass").hide();
        $("#pnlMonthly").show();
    })
    $("#rdoFreq_3").click(function () {
        $(".FrequencyClass").hide();
        $("#pnlYearly").show();
    })
</script>
