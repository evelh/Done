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
        
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="ticket_id" value="<%=thisTicket!=null?thisTicket.id.ToString():"" %>" />
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
                <li id="cycle">周期</li>
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
                            <table cellspacing="0" cellpadding="0" border="0" style="margin-left: 25px; width: 766px;">
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
                                            <input name="resDepId" type="hidden" id="resDepIdHidden" value="" /><nobr><span  style="display:inline-block;"><input name="" type="text" value="" id="resDepId" class="txtBlack8Class" style="width:200px;" /></span>&nbsp;<a href="#" id="ChoosePriA" class="DataSelectorLinkIcon" onclick="ChoosePriRes()" ><img src="../Images/data-selector.png" align="top" border="0" style="cursor:pointer;" /></a></nobr>
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
                                                            <input name="dueTime" type="text" id="dueTime" class="txtBlack8Class" style="width: 80px;" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=thisTicket!=null&&thisTicket.estimated_end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.estimated_end_time).ToString("HH:mm"):"" %>" />&nbsp;</span></td>
                                                        <td><span id="EstimatedHours" style="display: inline-block;">
                                                            <input name="estimated_hours" type="text" id="estimated_hours" class="txtBlack8Class" style="width: 90px;" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=thisTicket!=null?thisTicket.estimated_hours.ToString("#0.00"):"" %>" /></span></td>
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
                                            <input name="contract_id" type="hidden" id="contractIdHidden" value="<%=thisContract!=null?thisContract.id.ToString():"" %>" /><nobr><span id="ContractdataSelector" style="display:inline-block;"><input  type="text" id="contractId" class="txtBlack8Class" style="width:204px;" value="<%=thisContract!=null?thisContract.name.ToString():"" %>" /></span>&nbsp;<a href="#" id="ContractdataSelector_anchor" class="DataSelectorLinkIcon" align="top" border="0" style="cursor:pointer;" onclick="ContractCallBack()"><img src="../Images/data-selector.png" align="top" border="0" style="cursor:pointer;" /></a></nobr></td>
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
                                            <input name="installed_product_id" type="hidden" id="InsProIdHidden" value="<%=insPro!=null?insPro.id.ToString():"" %>" /><nobr><span id="DataSelectorIP"  style="display:inline-block;"><input name="" type="text" id="InsProId" class="txtBlack8Class" style="width:204px;" value="<%=thisProduct!=null?thisProduct.name:"" %>"/></span>&nbsp;<a href="#" id="DataSelectorIP_anchor" class="DataSelectorLinkIcon" onclick="InsProCallBack()"><img id="DataSelectorIP_image" src="../Images/data-selector.png" align="top" border="0" style="cursor:pointer;" /></a></nobr></td>

                                        <td style="padding: 0px;"><span id="txtPurchaseOrderNumber" title="" style="display: inline-block;">
                                            <input name="purchase_order_no" type="text" maxlength="50" id="purchase_order_no" class="txtBlack8Class" style="width: 204px;" value="<%=thisTicket!=null?thisTicket.purchase_order_no:"" %>" /></span></td>
                                        <td style="padding-bottom: 10px;"></td>
                                    </tr>

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="content clear" style="display: none;">
                <div id="pnlTab_2" style="height: 100%; width: 100%;">
                    <div id="Page2Panel" style="height: 324px; position: static; min-height: 412px;">
                        <div class="DivSectionWithHeader" style="margin-top: 10px; height: 180px;">
                            <div class="HeaderRow">
                                <span class="lblNormalClass" style="font-weight: bold;">持续时间<font style="color: Red;">*</font></span>
                            </div>
                            <div class="Content" style="margin-top: 15px;">
                                <div class="TabLevelInstruction" style="display: none;">
                                    <span class="lblNormalClass" style="font-weight: normal;">Service calls have already been created for this recurrence master. If you extend the duration, new service calls will not be created.</span>
                                </div>
                                <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td><span class="lblNormalClass" style="font-weight: bold; padding-left: 8px;">开始时间</span></td>
                                            <td style="padding-bottom: 10px;"><span id="txtStartDate">
                                                <input name="recurring_start_date" type="text" id="recurring_start_date" class="txtBlack8Class" onclick="WdatePicker()" value="<%=thisticketRes!=null?thisticketRes.recurring_start_date.ToString("yyyy-MM-dd"):"" %>" />&nbsp;</span><span id="chkActive" style="padding-left: 212px;"><span class="txtBlack8Class"><input id="ckActive" type="checkbox" name="ckActive" <%=thisticketRes!=null&&(thisticketRes.is_active==null||thisticketRes.is_active==0)?"":"checked='checked'" %> style="vertical-align: middle;" /><label style="vertical-align: middle; width: 150px;">激活(只影响主工单的搜索)</label></span></span><span class="FieldLevelInstruction" style="font-weight: normal;"></span></td>
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
                                                                <input name="recurring_end_date" type="text" id="recurring_end_date" class="txtBlack8Class" onclick="WdatePicker()" value="<%=thisticketRes!=null&&thisticketRes.recurring_end_date!=null?((DateTime)thisticketRes.recurring_end_date).ToString("yyyy-MM-dd"):"" %>" />
                                                                &nbsp;</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-top: 3px;"><span id="txtEndAfterInstances" style="display: inline-block;">
                                                                <input name="recurring_instances" type="text" maxlength="3" id="recurring_instances" disabled="disabled" class="txtBlack8Class" style="width: 60px; text-align: right; margin-top: 6px;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" value="<%=thisticketRes!=null&&thisticketRes.recurring_instances!=null?thisticketRes.recurring_instances.ToString():"" %>" /></span><span class="txtBlack8Class" style="font-weight: normal;">&nbsp;实例</span></td>
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
                                                                    <input id="ckNotInSat" type="checkbox" name="ckNotInSat" style="vertical-align: middle;" /><label style="vertical-align: middle; width: 100px;">周六不生成工单</label></span></span></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="padding: 0px,0px,0px,85px;"><span id="chkDoNotCreateSun"><span class="txtBlack8Class">
                                                                    <input id="ckNotInSun" type="checkbox" name="ckNotInSun" style="vertical-align: middle;" /><label style="vertical-align: middle; width: 100px;">周日不生成工单</label></span></span></td>
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
                                                                    <table id="radioMonthly" class="txtBlack8Class" cellpadding="6" border="0" style="width: 43px;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <input id="radioMonthly_0" type="radio" name="radioMonthly" value="Day" checked="checked" />
                                                                                    <label style="width: 12px;">每</label>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <input id="radioMonthly_1" type="radio" name="radioMonthly" value="The" />
                                                                                    <label style="width: 12px;">每</label>
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
                                                                                        <input name="month_month_day" type="text" maxlength="2" id="month_month_day" class="txtBlack8Class MonthHao" style="width: 40px; text-align: right;" /></span><span class="lblNormalClass" style="font-weight: normal;">号</span>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <span id="txtDueOnMonths" disabled="disabled" style="display: inline-block; height: 15px;">
                                                                                        <input name="month_month_eve_num" type="text" value="1" maxlength="2" id="month_month_eve_num" class="txtBlack8Class" style="width: 40px; text-align: right;" /></span><span class="lblNormalClass" style="font-weight: normal;">月 </span>
                                                                                    <span id="ddlOccurance" style="display: inline-block; height: 18px;">
                                                                                        <select name="ddlOccurance_ATDropDown" id="ddlOccurance_ATDropDown" disabled="disabled" class="txtBlack8Class" style="width: 100px;">
                                                                                            <option selected="selected" value="1st">第一个</option>
                                                                                            <option value="2nd">第二个</option>
                                                                                            <option value="3rd">第三个</option>
                                                                                            <option value="4th">第四个</option>
                                                                                            <option value="last">最后一个</option>
                                                                                        </select></span>
                                                                                    &nbsp;<span id="ddlDayofweeks" style="display: inline-block; height: 18px;"><select name="ddlDayofweeks_ATDropDown" id="ddlDayofweeks_ATDropDown" disabled="disabled" class="txtBlack8Class" style="width: 125px;">
                                                                                        <option selected="selected" value="1">星期一</option>
                                                                                        <option value="2">星期二</option>
                                                                                        <option value="3">星期三</option>
                                                                                        <option value="4">星期四</option>
                                                                                        <option value="5">星期五</option>
                                                                                        <option value="6">星期六</option>
                                                                                        <option value="0">星期日</option>
                                                                                        <option value="7">天</option>
                                                                                        <option value="8">工作日</option>
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
                                                                                    <input id="rdoYearlyDue_0" type="radio" name="rdoYearlyDue" value="DueEvery" checked="checked" /><label style="width: 25px;">每年</label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <input id="rdoYearlyDue_1" type="radio" name="rdoYearlyDue" value="The" /><label style="width: 25px;">每年</label>
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
                                                                                    <span id="yearlySpecificDay" style="display: inline-block; height: 15px;">
                                                                                        <input name="year_month_day" type="text" maxlength="2" id="year_month_day" class="txtBlack8Class MonthHao" style="width: 40px; text-align: right;" /></span>号</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><span id="yearlyRelativeOccurence" disabled="disabled" style="display: inline-block; height: 18px;">
                                                                                    <select name="year_the_month" id="year_the_month" disabled="disabled" class="txtBlack8Class" style="width: 80px;">
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
                                                                                </span>月第
                                                                                    &nbsp;<span id="" disabled="disabled" style="display: inline-block; height: 18px;"><select name="year_month_week_num" id="year_month_week_num" disabled="disabled" class="txtBlack8Class" style="width: 60px;">
                                                                                        <option selected="selected" value="1st">第一个</option>
                                                                                        <option value="2nd">第二个</option>
                                                                                        <option value="3rd">第三个</option>
                                                                                        <option value="4th">第四个</option>
                                                                                        <option value="last">最后一个</option>
                                                                                    </select></span><span class="lblNormalClass" style="font-weight: normal;">个周 </span><span id="yearlyRelativeMonth" style="display: inline-block; height: 18px;">
                                                                                        <select name="year_the_week" id="year_the_week" disabled="disabled" class="txtBlack8Class" style="width: 85px;">
                                                                                            <option selected="selected" value="1">星期一</option>
                                                                                            <option value="2">星期二</option>
                                                                                            <option value="3">星期三</option>
                                                                                            <option value="4">星期四</option>
                                                                                            <option value="5">星期五</option>
                                                                                            <option value="6">星期六</option>
                                                                                            <option value="0">星期日</option>
                                                                                            <option value="7">天</option>
                                                                                            <option value="8">工作日</option>
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
            <div class="content clear" style="display: none;">
                <div id="pnlTab_3" style="height: 100%; width: 100%;">
                    <div id="Page3Panel" style="height: 324px; position: static; width: 90%;">
                        <table cellspacing="0" cellpadding="0" border="0" style="margin-left: 10px;">
                            <tbody>
                                <tr>
                                    <td valign="bottom" style="width: 300px; padding-top: 20px;"><span class="lblNormalClass" style="font-weight: bold;">发布范围</span></td>
                                    <td valign="bottom" style="width: 485px;"><span class="lblNormalClass" style="font-weight: bold;">标题</span>&nbsp;<span class="FieldLevelInstruction" style="font-weight: normal;">(新增备注时必填)</span></td>
                                </tr>
                                <tr>
                                    <td style="padding-bottom: 10px;">
                                        <span id="_ctl142" style="display: inline-block;">
                                            <select name="note_publish_id" id="note_publish_id" class="txtBlack8Class" style="width: 200px;">
                                                <%if (publishList != null && publishList.Count > 0)
                                                    {
                                                        foreach (var publish in publishList)
                                                        {%>
                                                <option value="<%=publish.id %>"><%=publish.name %></option>
                                                <%}
                                                    } %>
                                            </select>
                                        </span>
                                    </td>
                                    <td style="padding-bottom: 10px;">
                                        <span id="txtTitle" style="display: inline-block; display: block;">
                                            <input name="note_title" type="text" maxlength="255" id="note_title" class="txtBlack8Class" style="width: 100%;" />
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td><span class="lblNormalClass" style="font-weight: bold;">类型</span></td>
                                </tr>
                                <tr>
                                    <td style="padding-bottom: 10px;"><span id="_ctl144" style="display: inline-block;">
                                        <select name="note_type" id="note_type" class="txtBlack8Class" style="width: 200px;">
                                            <option value=""></option>
                                            <%if (noteTypeList != null && noteTypeList.Count > 0)
                                                {
                                                    foreach (var noteType in noteTypeList)
                                                    {%>
                                            <option value="<%=noteType.id %>"><%=noteType.name %></option>
                                            <%   }
                                                } %>
                                        </select></span></td>
                                </tr>
                                <tr>
                                    <td><span class="lblNormalClass" style="font-weight: bold;">描述</span>&nbsp;<span class="FieldLevelInstruction" style="font-weight: normal;">(新增备注时必填)</span></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><span id="" style="display: inline-block; display: block;">
                                        <textarea name="txtNotesDescription" id="txtNotesDescription" class="txtBlack8Class" maxlength="4000" style="height: 160px; width: 100%;"></textarea></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="content clear" style="display: none;">
                <div id="pnlTab_4" style="height: 100%; width: 100%;">
                    <table border="0" width="100%" cellpadding="3" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div style="padding-bottom: 10px; text-align: left; padding-left: 55px;">
                                        <a class="PrimaryLink" id="AddAttachmentLink" onclick="AddAttch()">
                                            <img src="../Images/ContentAttachment.png" style="height: 15px; width: 15px; display: unset;" alt="" />&nbsp;&nbsp;新增附件</a>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">
                                    <div id="AttachmentPanel" class="AttachmentContainer" style="padding-bottom: 10px; padding-left: 45px;">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="content clear" style="display: none;">
                <div id="pnlTab_5" style="height: 100%; width: 100%;">
                    <div class="Content" style="padding-left: 20px;">
                        <table border="none" cellspacing="" cellpadding="" style="">
                            <%if (tickUdfList != null && tickUdfList.Count > 0)
                                {
                                    foreach (var udf in tickUdfList)
                                    {

                                        if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                        {%>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed"><%=udf.name %></span>
                                        <br />
                                        <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=ticketUdfValueList!=null&&ticketUdfValueList.Count>0&& ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id)!=null?ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString():"" %>" />
                                    </div>
                                </td>
                            </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                                {
                            %>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed"><%=udf.name %></span>
                                        <br />
                                        <textarea name="<%=udf.id %>" rows="2" cols="20"><%=ticketUdfValueList!=null&&ticketUdfValueList.Count>0&& ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id)!=null?ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString():""  %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)
                                {
                            %>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed"><%=udf.name %></span>
                                        <br />
                                        <%string val = "";
                                            if (ticketUdfValueList != null && ticketUdfValueList.Count > 0 && ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                            {
                                                object value = ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value;
                                                if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                                {
                                                    val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                                }
                                            }
                                        %>
                                        <input type="text" onclick="WdatePicker()" name="<%=udf.id %>" class="sl_cdt" value="<%=val %>" />
                                    </div>
                                </td>
                            </tr>
                            <% }
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)
                                {
                            %>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed"><%=udf.name %></span>
                                        <br />
                                        <%string val = "";
                                            if (ticketUdfValueList != null && ticketUdfValueList.Count > 0 && ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                            {
                                                object value = ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value;
                                                if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                                {
                                                    val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                                }
                                            }
                                        %>
                                        <input type="text" name="<%=udf.id %>" class="sl_cdt" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value %>" />
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)
                                {%>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed"><%=udf.name %></span>
                                        <br />
                                        <select name="<%=udf.id %>">
                                            <%if (udf.required != 1)
                                                { %>
                                            <option></option>
                                            <%} %>
                                            <% if (udf.value_list != null && udf.value_list.Count > 0)
                                                {
                                                    var thisValue = "";
                                                    if (ticketUdfValueList != null && ticketUdfValueList.Count > 0 && ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                                    {
                                                        thisValue = ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString();
                                                    }

                                                    foreach (var thisValeList in udf.value_list)
                                                    {%>
                                            <option value="<%=thisValeList.val %>" <%=thisValue==thisValeList.val?"selected='selected'":"" %>><%=thisValeList.show %></option>
                                            <%
                                                    }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <%
                                        }
                                    }
                                } %>
                        </table>
                    </div>
                </div>
            </div>
            <div class="content clear" style="display: none;">
                <div id="pnlTab_6" style="height: 100%; width: 100%;">
                    <div id="Page6Panel" style="height: 324px; position: static;">

                        <div style="display: inline;">
                            <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse; margin-left: 10px;">
                                <tbody>
                                    <tr>
                                        <td colspan="2">
                                            <div class="TabLevelInstruction" style="margin-left: 0px;">
                                                <% if (!isAdd && thisTicketCall != null)
                                                    { %>
                                                <span class="lblNormalClass" style="font-weight: normal;">系统已经为该主工单生成了服务预定。如果延长了服务周期，新的服务预定不会生成.</span>
                                                <%}
                                                    else
                                                    { %>
                                                <span class="lblNormalClass" style="font-weight: normal;">系统可以自动为该主工单的每个实例创建服务预定。 服务预定的开始和结束日期将与每个实例的到期日相同.</span>
                                                <%} %>
                                            </div>
                                        </td>
                                    </tr>
                                    <% if (!isAdd && thisTicketCall != null)
                                        { %>
                                    <tr>
                                        <td colspan="2" style="padding-bottom: 11px;"><span id="chkSeriesOfSeriveCalls"><span class="txtBlack8Class">
                                            <input id="chkSeriesOfSeriveCalls_ATCheckBox" type="checkbox" name="chkSeriesOfSeriveCalls:ATCheckBox" style="vertical-align: middle;" /><label style="vertical-align: middle;">为每个子工单创建一个服务预定:</label></span></span></td>
                                    </tr>
                                    <tr>
                                        <td style="width: 600px; padding-bottom: 10px;"><span id="lblSerCallStartTime" class="lblNormalClass" style="color: gray; font-weight: bold;">服务预定开始时间</span>&nbsp;<span id="lblStartTimeRedStar" class="lblNormalClass" style="color: gray; font-weight: bold;">*</span><br>
                                            <span id="txtServiceStartTime" disabled="disabled" style="display: inline-block;">
                                                <input name="txtServiceStartTime:ATTextEdit" type="text" value="08:00 AM" id="txtServiceStartTime_ATTextEdit" class="txtBlack8Class" istime="1" dontvalidateonload="1" style="width: 80px;" disabled="">&nbsp;</span></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-bottom: 10px;"><span id="lblSerCallEndTime" class="lblNormalClass" style="color: gray; font-weight: bold;">服务预定结束时间</span>&nbsp;<span id="lblEndTimeRedStar" class="lblNormalClass" style="color: gray; font-weight: bold;">*</span><br>
                                            <span id="txtServiceEndTime" disabled="disabled" style="display: inline-block;">
                                                <input name="txtServiceEndTime:ATTextEdit" type="text" value="09:00 AM" id="txtServiceEndTime_ATTextEdit" class="txtBlack8Class" istime="1" dontvalidateonload="1" style="width: 80px;" disabled="">&nbsp;</span></td>
                                    </tr>
                                    <tr>
                                        <td style="padding-bottom: 10px;"><span id="lblSerCallDescription" class="lblNormalClass" style="color: gray; font-weight: bold;">描述</span><br>
                                            <span id="txtServiceDescription" disabled="disabled" style="display: inline-block;">
                                                <input name="txtServiceDescription:ATTextEdit" type="text" id="txtServiceDescription_ATTextEdit" class="txtBlack8Class" style="width: 400px;" disabled=""></span></td>
                                    </tr>
                                    <%} %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="content clear" style="display: none;">
                <div id="pnlTab_7" style="height: 100%; width: 100%;">
                    <div id="Page7Panel" style="height: 453px; position: static; vertical-align: top; overflow-y: auto; overflow-x: hidden;">
                        <div class="TabLevelInstruction">
                            <span class="lblNormalClass" style="font-weight: normal;">选择收件人将会发送邮件</span>
                        </div>
                        <div id="ctrlNotification_pnlAllElements" class="DivSection" style="border-width: 0px; padding-left: 0px; padding-top: 0px; margin-left: 0px;">
                            <div style="width: 780px; padding-left: 10px; padding-right: 10px;">
                                <div class="DivSection" style="margin-left: 0px; padding-left: 7px; margin-right: 23px; background-color: #F0F5FB; border: 1px solid #D3D3D3; height: 127px;">
                                    <div style="padding-left: 4px;">
                                        <a href="#">全选</a>
                                    </div>
                                    <table border="0" style="width: 100%;" id="ChooseList">
                                        <tbody>
                                            <tr>
                                                <td style="width: 374px;"><span id="ctrlNotification_chkccMe"><span class="txtBlack8Class">
                                                    <input id="ccMe" type="checkbox" name="ccMe" style="vertical-align: middle;" /><label style="vertical-align: middle;">抄送给我 </label>
                                                </span></span><span class="lblNormalClass" style="font-weight: normal;">&nbsp;(<%=LoginUser.name %>)</span></td>
                                                <td style="padding-left: 6px;"><span id="ctrlNotification_chkAcManager"><span class="txtBlack8Class">
                                                    <input id="ccAccMan" type="checkbox" name="ccAccMan" style="vertical-align: middle;" /><label  style="vertical-align: middle;">客户经理</label></span></span><span id="notify_account_manage" class="lblNormalClass" style="font-weight: normal;"></span></td>
                                            </tr>
                                            <tr valign="top">
                                                <td align="left"><span id="ctrlNotification_chkSendEmailFromHelpDesk"><span class="txtBlack8Class">
                                                    <input id="sendFromSys" type="checkbox" name="sendFromSys" style="vertical-align: middle;" /><label  style="vertical-align: middle;">Send email from </label>
                                                </span></span><span class="lblNormalClass" style="font-weight: normal;">&nbsp;hong.li@itcat.net.cn</span></td>
                                                <td style="padding-left: 6px;"><%if (thisTicket != null && thisTicket.owner_resource_id != null){ %><span id=""><span class="txtBlack8Class">
                                                    <input id="ccOwn" type="checkbox" name="ccOwn" style="vertical-align: middle;" /><label  style="vertical-align: middle;">主负责人</label></span></span><span id="" class="lblNormalClass" style="font-weight: normal;"></span><%} %></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <table cellspacing="0" cellpadding="0" border="0" style="width: 100%; border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td style="width: 380px;"><span class="lblNormalClass" style="font-weight: bold;">联系人</span></td>
                                            <td style="width: 380px; padding-right: 15px;"><span class="lblNormalClass" style="font-weight: bold;">员工 </span><a onclick="LoadRes()">(加载)</a></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="InnerGrid" style="background-color: White; height: 180px;">
                                                    <span id="" style="display: inline-block; height: 112px; width: 382px;">
                                                        <div id="" class="GridContainer">
                                                            
                                                            <div id="" style="height: 154px; width: 100%; overflow: auto; z-index: 0;">
                                                                <div class='grid' style='overflow: auto; height: 147px;'>
                                                                    <table width='100%' border='0' cellspacing='0' cellpadding='3'>
                                                                        <thead>
                                                                            <tr>
                                                                                <td width='1%'></td>
                                                                                <td width='33%'>联系人姓名</td>
                                                                                <td width='33%'>邮箱地址</td>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody id="conhtml">
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="InnerGrid" style="background-color: White; height: 180px; margin-right: -11px;">
                                                    <span id="ctrlNotification_dgEmployees" style="display: inline-block; height: 112px; width: 382px;"><span></span>
                                                        <div id="reshtml" style="width: 350px; height: 150px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                                                        </div>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="padding-top: 11px;"><span class="lblNormalClass" style="font-weight: bold;">其他邮件地址<br>
                                            </span><span id="ctrlNotification_otherEmails" style="display: inline-block; display: block;">
                                                <input name="notify_others" type="text" id="notify_others" class="txtBlack8Class" style="width: 95%;" /></span></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="padding-top: 11px;"><span class="lblNormalClass" style="font-weight: bold;">模板
                                                <br />
                                            </span><span id="ctrlNotification_ddlTemplate" style="display: inline-block;">
                                                <select name="notify_temp" id="notify_temp" class="txtBlack8Class" style="width: 100%;min-width: 500px;">
                                                    <%if (tempList != null && tempList.Count > 0)
                                                        {foreach (var temp in tempList)
                                                            {%>
                                                    <option value="<%=temp.id %>"><%=temp.name %></option>
                                                    <%} } %>
                                                </select></span></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="padding-top: 11px;"><span class="lblNormalClass" style="font-weight: bold;">主题<br>
                                            </span><span id="ctrlNotification_txtsubject" style="display: inline-block; display: block;">
                                                <input name="notify_title" type="text" value="" id="notify_title" class="txtBlack8Class" style="width: 95%;" /></span></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table cellspacing="0" cellpadding="0" border="0" style="width: 100%; margin-top: 11px;">
                                    <tbody>
                                        <tr style="padding: 0px;">
                                            <td valign="bottom" colspan="2" style="width: 392px;"><span class="lblNormalClass" style="font-weight: bold;">附加邮件文本</span></td>
                                        </tr>
                                        <tr style="padding: 0px;">
                                            <td valign="top" colspan="2"><span id="ctrlNotification_txtAddEmailText" style="display: inline-block; display: block;">
                                                <textarea name="notify_description" id="notify_description" class="txtBlack8Class" style="height: 30px; width: 95%; margin-bottom: 15px;"></textarea>&nbsp;<%--<img id="ctrlNotification_txtAddEmailText_imgAdditionalText" src="/autotask/images/icons/zoom-in.png?v=45785" align="top" border="0" style="cursor: pointer;" />--%></span></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <input type="hidden" id="notifyConIds" name="notifyConIds" />
                                <input type="hidden" id="notifyResIds" name="notifyResIds" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="header" style="left: 0; overflow-x: auto; overflow-y: hidden; position: fixed; right: 0; bottom: 0; top: 600px;">实例</div>
        <div style="left: 0; overflow-x: auto; overflow-y: hidden; position: fixed; right: 0; bottom: 0; top: 640px; height: auto;">
            <%if (!isAdd)
                { %>
            <iframe src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MASTER_SUB_TICKET_SEARCH %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MASTER_SUB_TICKET_SEARCH %>&con2114=<%=thisTicket != null ? thisTicket.id.ToString() : "" %>&isCheck=1" style="width: 100%; height: 100%;"></iframe>
            <% }%>
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


    $(function () {
        <%if (!isAdd)
    { %>
        $("#cycle").trigger("click");
        $("#pnlTab_1 input").prop("disabled", true);
        $("#pnlTab_1 select").prop("disabled", true);
        $("#pnlTab_1 textarea").prop("disabled", true);
        $("#AcdataSelector_anchor").removeAttr("onclick");
        $("#ChoosePriA").removeAttr("onclick");
        $("#ContractdataSelector_anchor").removeAttr("onclick");
        $("#DataSelectorIP_anchor").removeAttr("onclick");
        $("#pnlTab_5 input").prop("disabled", true);
        $("#pnlTab_5 select").prop("disabled", true);
        $("#pnlTab_5 textarea").prop("disabled", true);
            <%if (thisticketRes != null)
    { %>
        <%if (thisticketRes.recurring_end_date != null)
    {
        %>
        $("#ckEndTime").trigger("click");
        <%}
    else if (thisticketRes.recurring_instances != null)
    {%>
        $("#ckEndNumber").trigger("click");
        <%}%>
        <%if (thisticketRes.recurring_frequency == (int)EMT.DoneNOW.DTO.DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.DAY)
    {
        var dayDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrDayDto>(thisticketRes.recurring_define);
        if (dayDto != null)
        {%>
        $("#day_eve_day").val('<%=dayDto.every %>');
        $("#ckNotInSat").prop("checked",<%=dayDto.no_sat==1?"true":"false" %>);
        $("#ckNotInSun").prop("checked",<%=dayDto.no_sun==1?"true":"false" %>);
        <%}
        %>
        $("#rdoFreq_0").trigger("click");
        <%}
    else if (thisticketRes.recurring_frequency == (int)EMT.DoneNOW.DTO.DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.WEEK)
    {
        var weekDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrWeekDto>(thisticketRes.recurring_define);
        if (weekDto != null)
        {%>
        $("#week_eve_week").val('<%=weekDto.every %>');
        <%
    if (weekDto.dayofweek != null && weekDto.dayofweek.Count() > 0)
    {
        if (weekDto.dayofweek.Any(_ => _ == 1))
        {%>
        $("#ckWeekMon").prop("checked", true);
            <%}
    if (weekDto.dayofweek.Any(_ => _ == 2))
    {%>
        $("#ckWeekTus").prop("checked", true);
            <%
    }
    if (weekDto.dayofweek.Any(_ => _ == 3))
    { %>
        $("#ckWeekWed").prop("checked", true);
            <%
    }
    if (weekDto.dayofweek.Any(_ => _ == 4))
    {%>
        $("#ckWeekThu").prop("checked", true);
            <%
    }
    if (weekDto.dayofweek.Any(_ => _ == 5))
    { %>
        $("#ckWeekFri").prop("checked", true);
            <%
    }
    if (weekDto.dayofweek.Any(_ => _ == 6))
    {%>
        $("#ckWeekSat").prop("checked", true);
            <%
    }
    if (weekDto.dayofweek.Any(_ => _ == 7))
    {%>
        $("#ckWeekSun").prop("checked", true);
            <%
            }
        }
    }
        %>
        $("#rdoFreq_1").trigger("click");
        <%}
    else if (thisticketRes.recurring_frequency == (int)EMT.DoneNOW.DTO.DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.MONTH)
    {
        var monthDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrMonthDto>(thisticketRes.recurring_define);
        if (monthDto != null)
        {
            if (monthDto.day != 0)
            {%>
        $("#radioMonthly_0").trigger("click");
        $("#month_day_num").val('<%=monthDto.month %>');
        $("#month_month_day").val('<%=monthDto.day %>');
            <%}
    else
    {%>
        $("#radioMonthly_1").trigger("click");
        $("#month_month_eve_num").val('<%=monthDto.month %>');
        $("#ddlOccurance_ATDropDown").val("<%=monthDto.no %>");
        $("#ddlDayofweeks_ATDropDown").val("<%=monthDto.dayofweek %>");
            <%}
    }
        %>
        $("#rdoFreq_2").trigger("click");
        <% }
    else if (thisticketRes.recurring_frequency == (int)EMT.DoneNOW.DTO.DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.YEAR)
    {
        var yearDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrMonthDto>(thisticketRes.recurring_define);
        if (yearDto != null)
        {
            if (yearDto.day != 0)
            {%>
        $("#rdoYearlyDue_0").trigger("click");
        $("#year_every_month").val('<%=yearDto.month %>');
        $("#year_month_day").val('<%=yearDto.day %>');
            <%}
    else
    {%>
        $("#rdoYearlyDue_1").trigger("click");
        $("#year_the_month").val('<%=yearDto.month %>');
        $("#year_month_week_num").val("<%=yearDto.no %>");
        $("#year_the_week").val("<%=yearDto.dayofweek %>");
            <%}
    }
        %>
        $("#rdoFreq_3").trigger("click");
        <%} %>
        $("#pnlTab_2 input").prop("disabled", true);
        $("#pnlTab_2 select").prop("disabled", true);
        $("#pnlTab_2 radio").prop("disabled", true);
        $("#ckActive").prop("disabled", false);
            <%if (thisticketRes.recurring_end_date != null)
    {
        %>
        $("#recurring_end_date").prop("disabled", false);
        <%}
    else if (thisticketRes.recurring_instances != null)
    {%>
        $("#recurring_instances").prop("disabled", false);
        <%}%>
            <%}%>

        <%} %>
    })
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

        GetConByAccount();
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

    $("#save_close").click(function () {
        if (SubmitCheck()) {

        }
        else {
            return false;
        }
    })

    function SubmitCheck() {
        var accountIdHidden = $("#accountIdHidden").val();
        if (accountIdHidden == "" || accountIdHidden == null) {
            LayerMsg("请通过查找带回选择客户！");
            return false;
        }
        var title = $("#title").val();
        if ($.trim(title) == "" || title == null) {
            LayerMsg("请填写工单标题！");
            return false;
        }
        var department_id = $("#department_id").val();
        var resDepIdHidden = $("#resDepIdHidden").val();
        if (department_id == "" && resDepIdHidden == null) {
            LayerMsg("请选择工单队列或者工单的负责人！");
            return false;
        }
        var source_type_id = $("#source_type_id").val();
        if (source_type_id == "" || source_type_id == null) {
            LayerMsg("请选择工单来源！");
            return false;
        }
        var dueTime = $("#dueTime").val();
        if (dueTime == "" || dueTime == null) {
            LayerMsg("请填写工单截止时间！");
            return false;
        }
        var status_id = $("#status_id").val();
        if (status_id == "" || status_id == null) {
            LayerMsg("请选择工单状态！");
            return false;
        }
        var priority_type_id = $("#priority_type_id").val();
        if (priority_type_id == "" || priority_type_id == null) {
            LayerMsg("请选择工单优先级！");
            return false;
        }
        var cate_id = $("#cate_id").val();
        if (cate_id == "" || cate_id == null) {
            LayerMsg("请选择工单种类！");
            return false;
        }
        var recurring_start_date = $("#recurring_start_date").val();
        if (recurring_start_date == "") {
            LayerMsg("请填写开始时间！");
            return false;
        }
        if ($("#ckEndTime").is(":checked")) {
            var recurring_end_date = $("#recurring_end_date").val();
            if (recurring_end_date == "") {
                LayerMsg("请填写结束时间！");
                return false;
            }
            if (compareTime(recurring_start_date, recurring_end_date)) {
                LayerMsg("开始时间不能晚于结束时间！");
                return false;
            }
        }
        else if ($("#ckEndNumber").is(":checked")){
            var recurring_instances = $("#recurring_instances").val();
            if (recurring_instances == "" || isNaN(recurring_instances) || (Number(recurring_instances)<=0)){
                LayerMsg("请填写正确的实例数量！");
                return false;
            }
        } 
        else {
            LayerMsg("请选择结束时间或者实例数");
            return false;
        }
        if (!CheckAddTicket()) {
            return false;
        }

        GetConIds();
        GetResIds();
        return true;
    }
    // 检验是否可以生成工单
    function CheckAddTicket() {
        if ($("#rdoFreq_0").is(":checked")) {
            var day_eve_day = $("#day_eve_day").val();
            if (day_eve_day == "" || isNaN(day_eve_day) || (Number(day_eve_day) <= 0)) {
                LayerMsg("请填写正确的天数");
                return false;
            } 
            if ($("#ckEndTime").is(":checked")) {
                var recurring_end_date = $("#recurring_end_date").val();
                var recurring_start_date = $("#recurring_start_date").val();
                var DateDiffDay = DateDiff(recurring_end_date, recurring_start_date);
                var isNoSat = $("#ckNotInSat").is(":checked");
                var isNoSun = $("#ckNotInSun").is(":checked");
                var starArr = recurring_start_date.split("-");
                var startDate = new Date(starArr[0], parseInt(starArr[1]) - 1, starArr[2])
                if (isNoSat || isNoSun) {
                    if (startDate.getDay() == 6 && Number(DateDiffDay) < 2) {
                        LayerMsg("当前日期选择不足以生成子工单，请重新填写");
                        return false;
                    }
                    if (startDate.getDay() == 0 && Number(DateDiffDay) < 1) {
                        LayerMsg("当前日期选择不足以生成子工单，请重新填写");
                        return false;
                    }
                }
            }
            return true;
        }
        else if ($("#rdoFreq_1").is(":checked")) {
            var week_eve_week = $("#week_eve_week").val();
            if (week_eve_week == "" || isNaN(week_eve_week) || (Number(week_eve_week) <= 0)) {
                LayerMsg("请填写正确的周数");
                return false;
            }
            var weekArr = new Array();
            var ckWeekSun = $("#ckWeekSun").is(":checked");
            var ckWeekMon = $("#ckWeekMon").is(":checked");
            var ckWeekTus = $("#ckWeekTus").is(":checked");
            var ckWeekWed = $("#ckWeekWed").is(":checked");
            var ckWeekThu = $("#ckWeekThu").is(":checked");
            var ckWeekFri = $("#ckWeekFri").is(":checked");
            var ckWeekSat = $("#ckWeekSat").is(":checked");
            if (ckWeekSun) {
                weekArr.push("0");
            }
            if (ckWeekMon) {
                weekArr.push("1");
            }
            if (ckWeekTus) {
                weekArr.push("2");
            }
            if (ckWeekWed) {
                weekArr.push("3");
            }
            if (ckWeekThu) {
                weekArr.push("4");
            }
            if (ckWeekFri) {
                weekArr.push("5");
            }
            if (ckWeekSat) {
                weekArr.push("6");
            }
            if (weekArr.length == 0) {
                LayerMsg("请至少勾选一个周内天数");
                return false;
            }
            //if (!ckWeekSun && !ckWeekMon && !ckWeekTus && !ckWeekWed && !ckWeekThu && !ckWeekFri && !ckWeekSat) {
            //    LayerMsg("请至少勾选一个周内天数");
            //    return false;
            //}
            if ($("#ckEndTime").is(":checked")) {
                var recurring_end_date = $("#recurring_end_date").val();
                var recurring_start_date = $("#recurring_start_date").val();
                var DateDiffDay = DateDiff(recurring_end_date, recurring_start_date);
                if (DateDiffDay < (Number(week_eve_week)*7)) {
                    var starArr = recurring_start_date.split("-");
                    var startDate = new Date(starArr[0], parseInt(starArr[1]) - 1, starArr[2]);
                    var thisDay = startDate.getDay();
                    var diffArr = new Array();
                    for (var i = 0; i < DateDiffDay; i++) {
                        diffArr.push(Number(thisDay + i)%7);
                    }
                    var isHas = "";
                    for (var i = 0; i < weekArr.length; i++) {
                        for (var j = 0; j < diffArr.length; j++) {
                            if (weekArr[i] == diffArr[j]) {
                                isHas = "1";
                            }
                        }
                    }
                    if (isHas == "") {
                        LayerMsg("当前日期选择不足以生成子工单，请重新填写");
                        return false;
                    }

                }
            }
            return true;
        }
        else if ($("#rdoFreq_2").is(":checked")) {
            if ($("#ckEndTime").is(":checked")) {
                if ($("#radioMonthly_0").is(":checked")) {
                    var month_day_num = $("#month_day_num").val();
                    var month_month_day = $("#month_month_day").val();
                    if (month_day_num == "" || isNaN(month_day_num) || (Number(month_day_num) <= 0) || (Number(month_day_num) > 12)) {
                        LayerMsg("请填写正确的月数");
                        return false;
                    }
                    if (month_month_day == "" || isNaN(month_month_day) || (Number(month_month_day) <= 0) || (Number(month_month_day) > 31)) {
                        LayerMsg("请填写正确的天");
                        return false;
                    }
                    var recurring_end_date = $("#recurring_end_date").val();
                    var recurring_start_date = $("#recurring_start_date").val();
                    var starArr = recurring_start_date.split("-");
                    var endArr = recurring_end_date.split("-");
                    var monthDiff = MonthDiff(recurring_end_date, recurring_start_date);
                    if (Number(monthDiff) == 1) {
                        if (starArr[1] != endArr[1] && Number(starArr[2]) > Number(month_month_day) && Number(endArr[2]) < Number(month_month_day)) {
                            LayerMsg("当前日期选择不足以生成子工单，请重新填写");
                            return false;
                        }
                        else {
                            if (Number(starArr[2]) > Number(month_month_day) || Number(endArr[2]) < Number(month_month_day)) {
                                LayerMsg("当前日期选择不足以生成子工单，请重新填写");
                                return false;
                            }
                        }
                    }
                }
            }
            return true;
        }
        else if ($("#rdoFreq_3").is(":checked")) {
            var recurring_end_date = $("#recurring_end_date").val();
            var recurring_start_date = $("#recurring_start_date").val();
            var starArr = recurring_start_date.split("-");
            var endArr = recurring_end_date.split("-");
            var monthDiff = MonthDiff(recurring_end_date, recurring_start_date);

            if ($("#rdoYearlyDue_0").is(":checked")) {
                if ($("#ckEndTime").is(":checked")) {
                    var year_every_month = $("#year_every_month").val();
                    var year_month_day = $("#year_month_day").val();
                    if (year_every_month == "" || isNaN(year_every_month) || (Number(year_every_month) <= 0) || (Number(year_every_month) > 12)) {
                        LayerMsg("请选择正确的月数");
                        return false;
                    }
                    if (year_month_day == "" || isNaN(year_month_day) || (Number(year_month_day) <= 0) || (Number(year_month_day) > 31)) {
                        LayerMsg("请填写正确的天");
                        return false;
                    }
                    if (Number(monthDiff) < 12) {
                        if (starArr[0] != endArr[0]) {
                            if (Number(starArr[1]) > Number(year_every_month) && Number(endArr[1]) < Number(year_every_month)) {
                                LayerMsg("当前日期选择不足以生成子工单，请重新填写");
                                return false;
                            }
                        }
                        else {
                            if (Number(starArr[1]) > Number(year_every_month) || Number(endArr[1]) < Number(year_every_month)) {
                                LayerMsg("当前日期选择不足以生成子工单，请重新填写");
                                return false;
                            }
                        }
                        
                    }
                    
                }
                
            }
            return true;
        }
        LayerMsg("请至少选择一个周期方式");
        return false;
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
    $("#radioMonthly_0").click(function () {
        $("#month_day_num").prop("disabled", false);
        $("#month_month_day").prop("disabled", false);
        $("#month_month_eve_num").prop("disabled", true);
        $("#ddlOccurance_ATDropDown").prop("disabled", true);
        $("#ddlDayofweeks_ATDropDown").prop("disabled", true);
    })
    $("#radioMonthly_1").click(function () {
        $("#month_day_num").prop("disabled", true);
        $("#month_month_day").prop("disabled", true);
        $("#month_month_eve_num").prop("disabled", false);
        $("#ddlOccurance_ATDropDown").prop("disabled", false);
        $("#ddlDayofweeks_ATDropDown").prop("disabled", false);
    })

    $("#rdoYearlyDue_0").click(function () {
        $("#year_every_month").prop("disabled", false);
        $("#year_month_day").prop("disabled", false);
        $("#year_the_month").prop("disabled", true);
        $("#year_month_week_num").prop("disabled", true);
        $("#year_the_week").prop("disabled", true);
    })

    $("#rdoYearlyDue_1").click(function () {
        $("#year_every_month").prop("disabled", true);
        $("#year_month_day").prop("disabled", true);
        $("#year_the_month").prop("disabled", false);
        $("#year_month_week_num").prop("disabled", false);
        $("#year_the_week").prop("disabled", false);
    })
    $("#recurring_instances").blur(function () {
        var thisValue = $(this).val();
        if (!isNaN(thisValue)) {

        } else {
            $(this).val("");
        }

    })
    $(".MonthHao").blur(function () {
        var thisValue = $(this).val();
        var obj = $(this);
        if (isNaN(thisValue) || Number(thisValue) <= 0 || Number(thisValue) > 31) {
            $(this).val("");
        }
        else {
            if (Number(thisValue) <= 31 && Number(thisValue) >= 29) {
                LayerConfirm("当前选择天数在月底，若下一周期天数不足将自动补到月末，是否继续", "是", "否", function () { }, function () { obj.val(""); });
            }
        }
    })


</script>
<!-- 工单附件相关JS 处理 -->
<script>
    function AddAttch() {
        window.open("../Project/AddTaskAttach.aspx?object_id=<%=objectId %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_ATTACH %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 重新显示session文件内容
    function ReloadSession() {
        // 重新加载session，显示新增文件
        debugger;
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=GetTaskFileSes&object_id=<%=objectId %>",
            success: function (data) {
                if (data != "") {
                    $("#AttachmentPanel").html(data);
                }
            },
        });
    }
    // 移除session内容
    function RemoveSess(index) {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=RemoveSess&object_id=<%=objectId %>&index=" + index,
            success: function (data) {
                $("#AttachmentPanel").html(data);
            },
        });
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

    function GetConByAccount() {
        var html = "";
        var accountIdHidden = $("#accountIdHidden").val();
        if (accountIdHidden != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContactAjax.ashx?act=GetContacts&account_id=" + accountIdHidden,
                success: function (data) {
                    if (data != "") {
                        html = data;
                    }
                },
            });
        }
        $("#conhtml").html(html);
    }
    $("#notify_temp").change(function () {
        var thisTempId = $(this).val();
        if (thisTempId != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/GeneralAjax.ashx?act=GetNotiTempEmail&temp_id=" + thisTempId,
                dataType:"json",
                success: function (data) {
                    if (data != "") {
                        if (data.subject != "" && data.subject != null && data.subject != undefined) {
                            $("#notify_title").val(data.subject);
                        }
                    }
                },
            });
        }
    })

    function GetConIds() {
        var ids = "";
        $(".checkCon").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val()+','
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length-1);
        }
        $("#notifyConIds").val(ids);
    }
    
    function GetResIds() {
        var ids = "";
        $(".checkRes").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ','
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#notifyResIds").val(ids);
    }
</script>
