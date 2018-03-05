<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketLabour.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.TicketLabour" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增工时":"编辑工时" %></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link href="../Content/style.css" rel="stylesheet" />
    <link href="../Content/TicketLabour.css" rel="stylesheet" />
    <style>
        .stretchTextArea TEXTAREA {
            WIDTH: 100%;
        }

        #TE_NS_mainPanel,
        #ticketNoteControl_NS_mainPanel {
            padding-bottom: 5px;
        }

        #STE_mainPanel {
            padding-bottom: 0px;
        }

        .checkboxPadding {
            padding-bottom: 10px;
        }

        .checkboxExtraPadding {
            padding-bottom: 20px;
        }

        .PaddingBottomForTd tr:last-of-type td {
            padding-bottom: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增":"修改" %>工时</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_new" runat="server" Text="保存并新建" BorderStyle="None" OnClick="save_new_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_modify" runat="server" Text="保存并修改" BorderStyle="None" OnClick="save_modify_Click" />
                </li>

                <li id="ClosePage"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    关闭</li>
            </ul>
        </div>
        <div class="DivScrollingContainer General" style="overflow: auto; height: 850px;">
            <div class="DivSection AddItemToTicketTopSection AddNoteTitleImage" style="margin-left: 10px; float: left; border: 0px solid #d3d3d3; padding-left: 34px;">
                <table cellspacing="0" cellpadding="0" border="0" style="height: 44px; border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td class="Popup_TitleCell" style="text-align: left;"><span class="Popup_Title" style="width: 750px; margin-left: 6px;"><%=thisTicket == null ? "" : thisTicket.no + " - " + thisTicket.title %></span></td>
                        </tr>
                        <tr>
                            <td class="Popup_SubtitleCell" style="text-align: left;"><span title="<%=thisAccount == null ? "" : thisAccount.name %>" class="Popup_Subtitle" style="width: 765px; margin-left: 6px;"><%=thisAccount == null ? "" : thisAccount.name %></span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div id="TE_alertPanel" style="margin-bottom: 5px; padding-left: 10px; padding-right: 10px;">
                <table border="0" style="border-collapse: collapse; width: 100%">
                    <tbody>
                        <tr>
                            <td class="accountAlertImage">
                                <img src="" border="0"></td>
                            <td class="accountAlertText"><%=accAlert==null?"":accAlert.alert_text %></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="DivSectionOnly">
                <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse; margin: 0px 5px;">
                    <tbody>
                        <% if (isAllowAgentRes)
                            { %>
                        <tr>
                            <td style="padding-top: 0px;">
                                <table cellspacing="0" cellpadding="0" width="100%" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td style="padding-top: 0px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">员工<font style="color: Red;"> *</font></span><span id="TE_resourceDropDownList" style="display: inline-block;">
                                                <asp:DropDownList ID="resource_id" runat="server" Width="183px"></asp:DropDownList>
                                            </span></td>
                                            <td style="padding-top: 0px;"></td>
                                            <td style="padding-top: 0px;"></td>
                                            <td style="padding-top: 0px;"></td>
                                            <td style="padding-top: 0px;"></td>
                                            <td style="padding-top: 0px;"></td>
                                            <td style="padding-top: 0px;"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <%} %>
                        <tr>
                            <td style="padding-top: 6px;">
                                <table cellspacing="0" cellpadding="0" width="" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td style="width: 214px; padding-top: 6px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">合同</span>
                                                <input name="contract_id" type="hidden" id="contract_idHidden" value="<%=thisContract==null?"":thisContract.id.ToString() %>" />
                                                <span id="TE_contractDataSelector" style="display: inline-block;">
                                                    <input name="" type="text" value="<%=thisContract==null?"":thisContract.name %>" id="contract_id" class="txtBlack8Class" style="width: 169px;" title="" tabindex="0" />
                                                </span>
                                                <a href="" id="" class="DataSelectorLinkIcon" tabindex="0" onclick="ContractCallBack()">
                                                    <img src="../Images/data-selector.png" align="top" border="0" style="cursor: pointer;" />
                                                </a>
                                            </td>
                                            <td style="width: 199px; padding-top: 6px; padding-left: 8px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">服务/服务包</span><span id="TE_serviceOrServiceBundleDropDownList" disabled="disabled" style="display: inline-block;">
                                                <select id="service_id" name="service_id" class="txtBlack8Class" style="width: 183px;">
                                                </select>
                                            </span></td>
                                            <td style="width: 80px; padding-top: 6px;"></td>
                                            <td style="width: 120px; padding-top: 6px;"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 6px;">
                                <table cellspacing="0" cellpadding="0" width="" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td style="width: 214px; padding-top: 6px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">工作类型<font style="color: Red;"> *</font></span><span id="TE_allocationCodeDropDownList" style="display: inline-block;">
                                                <asp:DropDownList ID="cost_code_id" runat="server" CssClass="txtBlack8Class" Width="183px"></asp:DropDownList>
                                            </span></td>
                                            <td style="width: 120px; padding-top: 6px; padding-left: 8px;"><span class="lblNormalClass" style="font-weight: bold; display: block;"></span><span id="TE_nonBillableCheckBox" style="display: inline-block; padding-top: 10px;"><span class="txtBlack8Class" validationcaption="" style="width: 80px;">
                                                <input id="ckIsBilled" type="checkbox" name="ckIsBilled" style="vertical-align: middle;" tabindex="0" /><label style="vertical-align: middle;">不计费</label></span></span></td>
                                            <td style="width: 120px; padding-top: 6px; padding-left: 8px;"><span class="lblNormalClass" style="font-weight: bold; display: block;"></span><span id="TE_showOnInvoiceCheckBox" style="display: inline-block; padding-top: 10px;"><span class="txtBlack8Class" style="width: 120px;">
                                                <input id="ckShowOnInv" type="checkbox" name="ckShowOnInv" style="vertical-align: middle;" disabled="" tabindex="0"><label style="vertical-align: middle;">在发票上显示</label></span></span></td>
                                            <td style="width: 185px; padding-top: 6px;"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 6px;">
                                <table cellspacing="0" cellpadding="0" width="" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td valign="top" style="width: 214px; padding-top: 6px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">角色<font style="color: Red;"> *</font></span>
                                                <span id="TE_roleDropDownList" style="display: inline-block;">
                                                    <asp:DropDownList ID="role_id" CssClass="txtBlack8Class" Width="183px" runat="server"></asp:DropDownList>
                                                </span></td>
                                            <td style="padding-top: 6px; padding-left: 8px;">
                                                <span class="lblNormalClass" style="font-weight: bold; display: block;">状态</span><span id="TE_statusDropDownList" style="display: inline-block;">
                                                    <asp:DropDownList ID="status_id" CssClass="txtBlack8Class" Width="183px" runat="server"></asp:DropDownList>
                                                </span>
                                            </td>
                                            <td style="padding-top: 6px;"></td>
                                            <td style="padding-top: 6px;"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 6px;">
                                <table cellspacing="0" cellpadding="0" width="" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td valign="bottom" style="width: 113px; padding-top: 6px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">日期<font style="color: Red;"> *</font></span><span>
                                                <input name="LabourDate" type="text" id="LabourDate" class="txtBlack8Class" onclick="WdatePicker()" style="width: 70px;" tabindex="0" value="<%=ticketLabour!=null&&ticketLabour.end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)ticketLabour.end_time).ToString("yyyy-MM-dd"):DateTime.Now.ToString("yyyy-MM-dd") %>" />
                                            </span></td>
                                            <td valign="bottom" style="width: 110px; padding-top: 6px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">开始时间<font style="color: Red;"> *</font></span><span>
                                                <input type="text" size="8" name="startTime" id="startTime" class="txtBlack8Class" style="width: 70px;" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=ticketLabour!=null&&ticketLabour.end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)ticketLabour.start_time).ToString("HH:mm"):DateTime.Now.ToString("HH:mm") %>" />&nbsp;<img src="../Images/time.png" border="0" style="vertical-align: middle; margin-bottom: 2px;" />
                                            </span></td>
                                            <td valign="bottom" style="width: 114px; padding-top: 6px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">结束时间<font style="color: Red;"> *</font></span><span>
                                                <input type="text" name="endTime" id="endTime" size="8" class="txtBlack8Class" style="width: 70px;" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=ticketLabour!=null&&ticketLabour.end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)ticketLabour.end_time).ToString("HH:mm"):DateTime.Now.ToString("HH:mm") %>" />&nbsp;<img src="../Images/time.png" border="0" style="vertical-align: middle; margin-bottom: 2px;" />
                                            </span></td>
                                            <td valign="bottom" style="width: 120px; padding-top: 6px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">工作时间<font style="color: Red;"> *</font></span><span id="TE_hours">
                                                <input name="hours_worked" type="text" value="<%=ticketLabour==null?"0.00":(ticketLabour.hours_worked??0).ToString("#0.00") %>" id="hours_worked" class="txtBlack8Class" style="width: 100px; text-align: right;" tabindex="0"  />
                                            </span></td>
                                            <td valign="bottom" style="width: 80px; padding-top: 6px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">偏移量</span><span id="TE_offsetRealBox"><input name="offset_hours" type="text" id="bill_offset" class="txtBlack8Class" style="width: 90px; text-align: right;" tabindex="0" value="<%=ticketLabour==null?"":ticketLabour.offset_hours.ToString("#0.00") %>" /></span></td>
                                            <td valign="bottom" style="width: 45px; padding-top: 6px; padding-left: 10px; min-width: 100px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">计费时长</span>
                                                <span class="lblNormalClass" id="bill_Hours" style="font-weight: bold; height: 21px; font-weight: normal; padding-top: 3px;"><%=ticketLabour==null?"":((ticketLabour.hours_worked??0)+ticketLabour.offset_hours).ToString() %></span>

                                            </td>
                                            <td style="height: 1px; width: 1px; padding-top: 6px;"><span class="lblNormalClass" style="font-weight: bold;"></span>
                                            </td>
                                            <td style="padding-top: 18px;">
                                                <div id="StopwatchContainer" class="StopwatchContainer" style="width: 140px; margin-left: 0px;">
                                                    <div id="StopwatchTime" class="StopwatchTime" style="width: 65px;"></div>
                                                    <div class="VerticalSeparator"></div>
                                                    <div id="PlayButton" class="Button Play Pause" title="Start/Pause">
                                                        <div id="PlayButtonImage" class="Icon"></div>
                                                    </div>
                                                    <div class="VerticalSeparator"></div>
                                                    <div id="RecordButton" class="Button Record" title="Record" style="display: none;">
                                                        <div id="RecordButtonImage" class="Icon"></div>
                                                    </div>
                                                    <div class="VerticalSeparator" style="display: none;"></div>
                                                    <div id="StopButton" class="Button Stop" title="Clear">
                                                        <div id="StopButtonImage" class="Icon"></div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-top: 6px;">
                                <table cellspacing="0" cellpadding="0" width="660px" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td style="width: 600px; padding-top: 6px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">工单说明<font style="color: Red;"> *</font></span><span id="TE_summaryNoteTextEdit"><textarea name="summary_notes" id="summary_note" class="txtBlack8Class" style="width: 619px; height: 150px;" tabindex="0"><%=ticketLabour==null?"":ticketLabour.summary_notes %></textarea></span></td>
                                            <td valign="top" style="width: 20px; padding-top: 6px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">&nbsp;</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding-top: 10px;">
                                                <span id="TE_chkAppendToResolution"><span class="txtBlack8Class">
                                                <input id="ckAppThisResou" type="checkbox" name="ckAppThisResou" style="vertical-align: middle;" tabindex="0" /><label style="vertical-align: middle;">附加到解决方案</label></span></span>
                                                <% if (thisTicket != null && thisTicket.ticket_type_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.PROBLEM)
                                                    { %>
                                                <span id="TE_chkAppendToIncidentsResolution" style="padding-left:18px;">
                                                    <span class="txtBlack8Class">
                                                        <input id="ckAppOtherResou" type="checkbox" name="ckAppOtherResou" style="vertical-align:middle;" /><label style="vertical-align:middle;">附件到相关事故（n个事故）的解决方案</label></span></span>
                                                <%} %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 600px; padding-top: 10px; padding-bottom: 10px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">内部说明</span><span>
                                                <textarea name="internal_notes" id="internal_notes" class="txtBlack8Class" style="width: 619px; height: 150px;" ><%=ticketLabour==null?"":ticketLabour.internal_notes %></textarea>
                                            </span></td>
                                            <td valign="top" style="width: 20px; padding-top: 10px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">&nbsp;</span>
                                            </td>
                                        </tr>
                                        <% if (isAdd)
                                            {if (thisTicket != null && thisTicket.ticket_type_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.PROBLEM)
                                                {%>
                                        <tr>
                                            <td style="padding-top: 0px;">
                                                <span id="TE_chkCreateNoteOnIncidents">
                                                    <span class="txtBlack8Class">
                                                <input id="CkNoteCreat" type="checkbox" name="CkNoteCreat" style="vertical-align: middle;" />
                                                        <label style="vertical-align: middle;">为相关事故（n个事故）创建备注，并更新状态</label>
                                                    </span>
                                                </span>
                                            </td>
                                        </tr>
                                         <tr>
                                            <td style="padding-top: -3px; padding-bottom: 8px;"><span class="lblNormalClass" style="font-weight: normal; padding-left: 16px; font-size: 11px; color: #666666;">如果相关事故状态不是完成，则更新为工时当前状态.</span></td>
                                        </tr>
                                         <%}
                                             }
                                             else
                                             { %>
                                          <tr>
                                            <td style="padding-top: -3px; padding-bottom: 8px;"><span class="lblNormalClass" style="font-weight: normal; padding-left: 16px; font-size: 11px; color: #666666;">上次更新通过<%=createUser==null?"":createUser.name %>在<%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisTicket.update_time).ToString("yyyy-MM-dd HH:mm:dd") %></span></td>
                                        </tr>
                                        <%} %>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold;">增加成本</span>
                </div>
                <div class="Content">
                    <div id="TE_QC_mainPanel">
                        <table class="quickCostMainTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse; max-width: 900px;">
                            <tbody>
                                <tr>
                                    <td colspan="8" style="padding: 15px,0px,10px,0px;"></td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="width: 180px; padding-top: 0px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">物料代码</span><span id="TE_QC_costCodeDropDown">
                                        <asp:DropDownList ID="charge_cost_code_id" CssClass="txtBlack8Class" Width="180px" runat="server"></asp:DropDownList>
                                    </span></td>
                                    <td style="padding-top: 0px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">描述</span><span id="TE_QC_costDescription">
                                        <input name="description" type="text" id="description" class="txtBlack8Class" style="width: 120px;" disabled="" />
                                    </span></td>
                                    <td style="padding-top: 0px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">数量</span><span id="TE_QC_costQuantity">
                                        <input name="quantity" type="text" value="1" id="quantity" class="txtBlack8Class" style="width: 60px; text-align: right;" disabled="" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" /></span></td>
                                    <td style="padding-top: 0px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">&nbsp;</span><span class="lblNormalClass" style="font-weight: bold;">x&nbsp;</span></td>
                                    <td style="padding-top: 0px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">单位价格</span><span id="TE_QC_costUnitPrice">
                                        <input name="unit_price" type="text" value="0.0000" id="unit_price" class="txtBlack8Class" style="width: 60px; text-align: right;" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                    </span></td>
                                    <td style="padding-top: 0px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">&nbsp;</span><span class="lblNormalClass" style="font-weight: bold;">=&nbsp;</span></td>
                                    <td style="padding-top: 0px;"><span class="lblNormalClass" style="font-weight: bold; display: block;">总价</span><span id="TE_QC_billableAmount">
                                        <input name="mount" type="text" value="0.00" id="mount" class="txtBlack8Class" style="width: 70px; text-align: right;" />
                                    </span></td>
                                    <td style="padding-top: 0px;"></td>
                                </tr>
                                <tr>
                                    <td colspan="7" style="padding-top: 8px;"><span class="SectionLevelInstruction" style="font-weight: normal; margin-left: 0px;">成本日期与工时日期相同</span></td>
                                    <td style="padding-top: 8px;"><span class="lblNormalClass" style="font-weight: bold;"></span><span id="TE_QC_billableToAccount"><span class="txtBlack8Class">
                                        <input id="ckBillToAccount" type="checkbox" name="ckBillToAccount" checked="checked" style="vertical-align: middle;" disabled="" /><label style="vertical-align: middle;">Billable to Company</label></span></span></td>
                                </tr>
                                <tr>
                                    <td colspan="8" style="padding: 10px,0px,10px,0px;"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold;">Notification</span>
                </div>
                <div class="Content">


                    
                </div>
            </div>
        </div>


    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    var hour, minute, second;//时 分 秒
    hour = minute = second = 0;//初始化

    
    //var millisecond = 0;//毫秒
    var int;
    function Reset()//重置
    {
        window.clearInterval(int);
        hour = minute = second = 0;
        //document.getElementById('timetext').value = '00时00分00秒000毫秒';
        $("#StopwatchTime").html("00:00:00");
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
        $("#StopwatchTime").html(Return2(hour) + ":" + Return2(minute) + ":" + Return2(second));
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

    $("#PlayButton").click(function () {
        // 
        // 
        if ($(this).hasClass("Pause")) {
            $(this).removeClass("Pause");
            stop();
        } else {
            $(this).addClass("Pause");
            start();
        }
    })

    $("#StopButton").click(function () {
        Reset();
        if ($("#PlayButton").hasClass("Pause")) {
            $("#PlayButton").removeClass("Pause");
            stop();
        }
    })

    $("#startTime").blur(function () {
        var thisValue = JiSuanBillHour();
        if (thisValue == "0") {
            $(thisValue).val("");
        } else {
            JiSuanWorkHours();
        }
    })

    $("#endTime").blur(function () {
        var thisValue = JiSuanBillHour();
        if (thisValue == "0") {
            $(thisValue).val("");
        } else {
            JiSuanWorkHours();
        }
    })
    $("#bill_offset").blur(function () {
        GetBillHours();
    })

    function GetBillHours() {
        var hours_worked = $("#hours_worked").val();
        var bill_offset = $("#bill_offset").val();
        if (hours_worked == "" || hours_worked == null || hours_worked == undefined) {
            $("#hours_worked").val("0.00");
            hours_worked = 0;
        }
        if (bill_offset == "" || bill_offset == null || bill_offset == undefined) {
            $("#bill_offset").val("");
            bill_offset = 0;
        }
        var billHours = Number(hours_worked) + Number(bill_offset);
        $("#bill_Hours").html(toDecimal2(billHours));
    }


    $("#hours_worked").blur(function () {
        Reset();
        if ($("#PlayButton").hasClass("Pause")) {
            $("#PlayButton").removeClass("Pause");
            stop();
        }
        var hours_worked = $(this).val();
        // todo 对工作时间进行取整操作，同时修改相关开始时间

        $("#hours_worked").val(toDecimal2(hours_worked));
        GetBillHours();
        
    })

    // 计算计费时间  0代表时间不对  1代表执行成功
    function JiSuanBillHour() {
        // hours_billed
        // 根据系统设置进行判断如何取整

        var startDate = $("#startTime").val();
        var endDate = $("#endTime").val();
        var dayDate = $("#LabourDate").val();
        if (startDate != "" && endDate != "" && dayDate != "") {
            startDate = dayDate + " " + startDate;
            endDate = dayDate + " " + endDate;
            var starString = startDate.replace(/\-/g, "/");
            var endString = endDate.replace(/\-/g, "/");
            var sdDate = new Date(starString);
            var edDate = new Date(endString);
            var diffMin = parseInt(edDate - sdDate) / 1000 / 60;
            if (diffMin < 0) {
                <% var idCrosNight = new EMT.DoneNOW.BLL.SysSettingBLL().GetValueById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_ALLOW_CROSS_NIGHT);
    if (idCrosNight != "1")
    {%>
                LayerMsg("开始时间要早于结束时间");
                return "0";
                 <%}
                 %>
            }
            // 
            var minValue = '<%=new EMT.DoneNOW.BLL.SysSettingBLL().GetValueById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_WORKENTRY_BILL_ROUND) %>';

            var mins = Math.ceil(diffMin / Number(minValue));
            var bills = mins * (Number(minValue) / 60);
            if (bills < 0) {
                bills = 24 + bills;
            }
            if (bills == 0) {
                if (diffMin < 0) {
                    bills = 24;
                }
            }

            var billOff = $("#bill_offset").val();
            if (billOff != "" && (!isNaN(billOff))) {
                bills = bills + Number(billOff);
            }
            $("#bill_Hours").html(toDecimal2(bills));


            return "1";
        } else {
            $("#bill_Hours").html("0.00");
            return "";
        }
    }

    function JiSuanWorkHours() {
        var startDate = $("#startTime").val();
        var endDate = $("#endTime").val();
        var dayDate = $("#LabourDate").val();
        if (startDate != "" && endDate != "" && dayDate != "") {
            startDate = dayDate + " " + startDate;
            endDate = dayDate + " " + endDate;
            var starString = startDate.replace(/\-/g, "/");
            var endString = endDate.replace(/\-/g, "/");
            var sdDate = new Date(starString);
            var edDate = new Date(endString);
            var diffMin = parseInt(edDate - sdDate) / 1000 / 60;
            var minValue = '<%=new EMT.DoneNOW.BLL.SysSettingBLL().GetValueById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_WORKENTRY_WORK_ROUND) %>';

            var mins = Math.ceil(diffMin / Number(minValue));
            var bills = mins * (Number(minValue) / 60);
            if (bills < 0) {
                bills = 24 + bills;
            }
            if (bills == 0) {
                if (diffMin < 0) {
                    bills = 24;
                }
            }
            $("#hours_worked").val(toDecimal2(bills));
        } else {
            $("#hours_worked").val("0.00");
        }
        var billOff = $("#bill_offset").val();
        if (billOff != "" && (!isNaN(billOff))) {
            bills = bills + Number(billOff);
        }
        $("#bill_Hours").html(toDecimal2(bills));
        Reset();
        if ($("#PlayButton").hasClass("Pause")) {
            $("#PlayButton").removeClass("Pause");
            stop();
        }
    }



</script>
<script>
    $(function () {
        start();
        GetServiceByContract();
        <%if (ticketLabour != null)
        { %>

        <%if (ticketLabour.service_id != null){ %>
        $("#service_id").val('<%=ticketLabour.service_id.ToString() %>');
        <%}%>

        <%if (ticketLabour.is_billable == 1)
    { %>
        $("#ckIsBilled").prop("checked", true);
        <%}
    else
    {%>
        $("#ckIsBilled").prop("checked", false);
        <%}%>

          <%if (ticketLabour.show_on_invoice == 1)
         { %>
        $("#ckShowOnInv").prop("checked", true);
        <%}
        else
        {%>
        $("#ckShowOnInv").prop("checked", false);
        <%}%>

        <%}%>

    })

    function ContractCallBack() {
        var account_idHidden = '<%=thisTicket==null?"":thisTicket.account_id.ToString() %>';
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
        // GetPurChaseOrderByContract();
    }

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

    $("#ckIsBilled").click(function () {
        if ($(this).is(":checked")) {
            $("#ckShowOnInv").prop("disabled", false);
        } else {
            $("#ckShowOnInv").prop("checked", true);
            $("#ckShowOnInv").prop("disabled", true);
        }
    })
    $("#charge_cost_code_id").change(function () {
        GetDataByChargeCost();
    })
    // 返回物料代码的单价
    function GetDataByChargeCost() {
        var charge_cost_code_id = $("#charge_cost_code_id").val();
        if (charge_cost_code_id == "" || isNaN(charge_cost_code_id)) {
            $("#description").prop("disabled", true);
            $("#quantity").prop("disabled", true);
        }
        else {
            $("#description").prop("disabled", false);
            $("#quantity").prop("disabled", false);

            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/QuoteAjax.ashx?act=costCode&id=" + charge_cost_code_id,
                success: function (data) {
                    if (data != "") {
                        $("#unit_price").val(toDecimal2(data.unit_price));
                    }
                },
            });

        }
        GetAmount();
    }
    // 获取到总价
    function GetAmount() {
        var quantity = $("#quantity").val();
        var unit_price = $("#unit_price").val();
        if (quantity == "" || isNaN(quantity)) {
            $("#quantity").val("0");
            quantity = 0;
        }
        if (unit_price == "" || isNaN(unit_price)) {
            $("#unit_price").val("0.00");
            unit_price = 0;
        }
        var amount = Number(quantity) * Number(unit_price);
        $("#mount").val(toDecimal2(amount));
    }
    $("#quantity").blur(function () {
        var thisValue = $(this).val();
        if (thisValue == "" || isNaN(thisValue)) {
            $("#quantity").val("0");
        }
        else {
            thisValue = Math.ceil(Number(thisValue));
            $("#quantity").val(thisValue);
        }

        GetAmount();
    })
    $("#unit_price").blur(function () {
        var thisValue = $(this).val();
        if (thisValue == "" || isNaN(thisValue)) {
            $(this).val("0.00");
        }
        GetAmount();
    })

    function SubmitCheck() {
        <%if (isAllowAgentRes)
    {%>
        var resource_id = $("#resource_id").val();
        if (resource_id == "") {
            LayerMsg("请选择员工！");
            return false;
        }
        <%}%>

        var cost_code_id = $("#cost_code_id").val();
        if (cost_code_id == "") {
            LayerMsg("请选择工作类型！");
            return false;
        }
        var LabourDate = $("#LabourDate").val();
        if (LabourDate == "") {
            LayerMsg("请填写日期！");
            return false;
        }
        var startTime = $("#startTime").val();
        if (startTime == "") {
            LayerMsg("请填写开始时间！");
            return false;
        }
        var endTime = $("#endTime").val();
        if (endTime == "") {
            LayerMsg("请填写结束时间！");
            return false;
        }
        var hours_worked = $("#hours_worked").val();
        if (hours_worked == "") {
            LayerMsg("请填写工作类型！");
            return false;
        }

        var ticketStatus = '<%=new EMT.DoneNOW.BLL.SysSettingBLL().GetValueById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_TICKET_STATUS_LABOUR) %>';
        var status_id = $("#status_id").val();
        if (status_id == '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW %>' && ticketStatus == '1') {
            LayerMsg("工单状态不能是新建！");
            return false;
        }



        var summary_note = $("#summary_note").val();
        if (summary_note == "") {
            LayerMsg("请填写工单说明！");
            return false;
        }

        return true;
    }

    $("#save_close").click(function () {
        return SubmitCheck();
    })

    $("#save_new").click(function () {
        return SubmitCheck();
    })

    $("#save_modify").click(function () {
        return SubmitCheck();
    })
    $("#ClosePage").click(function () {
        window.close();
    })
</script>
