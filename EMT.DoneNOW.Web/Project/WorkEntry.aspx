<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WorkEntry.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.WorkEntry" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style>
        .FieldLabels, .workspace .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
            padding-left: 30px;
        }

        .DivSection .FieldLabels div, .DivSection td[class="fieldLabels"] div, .DivSectionWithHeader td[class="fieldLabels"] div {
            margin-top: 1px;
            padding-bottom: 21px;
            font-weight: 100;
        }

        .DivSection {
            border: 1px solid #d3d3d3;
            margin: 0 10px 10px 10px;
            padding: 12px 28px 4px 28px;
        }

        .searchareaborder td {
            text-align: left;
        }

        #errorSmall {
            color: red;
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

        .CheckboxLabels, .workspace .CheckboxLabels, div[class="checkbox"] span, div[class="radio"] span {
            font-size: 12px;
            color: #333;
            font-weight: normal;
            vertical-align: middle;
        }

        .checkbox {
        }

        #AddEntryTable {
            margin-top: 10px;
            margin-bottom: 10px;
            width: 98%;
        }

        #AddEntryTable thead tr {
            height: 30px;
        }

        #AddEntryTable tbody tr {
            height: 25px;
        }
        #AddEntryTable tbody tr td{
                border-width: 1px;
    border-style: solid;
    border-left-color: #F8F8F8;
    border-right-color: #F8F8F8;
    border-top-color: #e8e8e8;
    border-bottom-width: 0;
    font-size: 12px;
    color: #333;
    text-decoration: none;
    vertical-align: top;
    padding: 4px;
    word-wrap: break-word;
        }

        #AddNewEntry {
            font-size: 10pt;
            font-weight: bold;
            width: 75px;
            height: 34px;
        }

        #PageAddNewEntry {
            font-weight: bold;
            width: 50px;
            height: 25px;
        }

        #PageCancelNewEntry {
            font-weight: bold;
            width: 50px;
            height: 25px;
        }
        #NewEntryAddDiv{
            background-color: #dedddd;
            width: 98%;
                padding-top: 17px;
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

                <li id="ClosePage"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    关闭</li>
            </ul>
        </div>
        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="general">常规信息</li>
                <li id="notifyLi">通知</li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 145px;">
            <div id="Summary">
                <div class="DivSection" style="margin-left: 0px; margin-right: 0px; width: 1080px; border: 1px solid #d3d3d3; margin: 0px 0px 22px 44px;">
                    <table class="searchareaborder" width="100%" border="0" cellspacing="0" cellpadding="0" id="Table3">
                        <tbody>
                            <tr>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td align="right" class="FieldLabels" style="width: 10%; text-align: left; padding-left: 15px;">员工<span id="errorSmall">*</span>
                                                    <div>
                                                        <asp:DropDownList ID="resource_id" runat="server" Width="300px"></asp:DropDownList>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="FieldLabels" width="200px" style="padding-left: 15px; text-align: left;">显示
				<div>
                    <select name="ShowTaskType" tabindex="2" id="ShowTaskType" size="1" style="width: 164px;">
                        <option value="showMe">我的任务</option>
                        <option value="showMeDep">我的任务和部门任务</option>
                        <option value="all">所有任务</option>

                    </select>
                </div>
                                </td>
                                <td align="left" style="vertical-align: middle; padding-bottom: 3px; text-align: center;">
                                    <input type="checkbox" tabindex="3" id="chkShowCompletedTasks" style="margin: 0 3px 0 -500px;" />显示完成的任务
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="DivSection" style="margin-left: 0px; margin-right: 0px; width: 1080px; border: 1px solid #d3d3d3; margin: 0px 0px 22px 44px; padding-left: 10px;">
                    <table class="searchareaborder" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td class="FieldLabels" width="398px">客户名称<span id="errorSmall">*</span>
                                    <div>
                                        <select name="account_id" size="1" style="width: 300px;" id="account_id" tabindex="4">
                                        </select>
                                    </div>
                                </td>
                                <td rowspan="6" valign="bottom" style="padding-left: 20px; padding-bottom: 19px;">
                                    <% if (!noTime)
                                        {%>
                                 <%--   <div id="tblStartStop" name="tblStartStop" style="position: relative; visibility: visible; display: block; background-color: rgb(240, 245, 251); border: 1px solid rgb(211, 211, 211); padding: 20px; width: 330px;">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tbody>
                                                <tr>
                                                    <td width="200px" class="FieldLabels" style="white-space: nowrap;">开始时间
                            <div>
                                <input type="text" size="8" name="startTime" id="startTime" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=thisWorkEntry!=null&&thisWorkEntry.end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisWorkEntry.start_time).ToString("HH:mm"):DateTime.Now.ToString("HH:mm") %>" />&nbsp;<img src="../Images/time.png" border="0" style="vertical-align: middle; margin-bottom: 2px;" />
                            </div>
                                                    </td>
                                                    <td class="FieldLabels" style="white-space: nowrap;">工作时长
							<div>
                                <input style="text-align: right; color: #6d6d6d; background-color: #dbdbdb;" type="text" name="hours_worked" id="hours_worked" readonly="" value="<%=thisWorkEntry!=null&&thisWorkEntry.hours_worked!=null?((long)thisWorkEntry.hours_worked).ToString("#0.00"):"0.00" %>" />
                            </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabels" style="white-space: nowrap;">结束时间
							<div>
                                <input type="text" name="endTime" id="endTime" size="8" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=thisWorkEntry!=null&&thisWorkEntry.end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisWorkEntry.end_time).ToString("HH:mm"):DateTime.Now.ToString("HH:mm") %>" />&nbsp;<img src="../Images/time.png" border="0" style="vertical-align: middle; margin-bottom: 2px;" />
                            </div>
                                                    </td>
                                                    <td class="FieldLabels" style="white-space: nowrap;">偏移量
							<div>
                                <input style="text-align: right;" type="text" name="offset_hours" id="offset_hours" value="<%=thisWorkEntry==null?"0.00":thisWorkEntry.offset_hours.ToString("#0.00") %>" class="decimal2" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                            </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabels">日期
							<div>
                                <input type="text" value="<%=thisWorkEntry!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisWorkEntry.start_time).ToString("yyyy-MM-dd"):DateTime.Now.ToString("yyyy-MM-dd") %>" name="tmeDate" id="tmeDate" style="color: #6d6d6d; width: 78px;" onclick="WdatePicker()" />
                            </div>
                                                    </td>
                                                    <td class="FieldLabels">计费时长
							<div>
                                <input style="text-align: right; color: #6d6d6d; background-color: #dbdbdb;" type="text" name="hours_billed" id="hours_billed" readonly="" value="<%=thisWorkEntry!=null&&thisWorkEntry.hours_billed!=null?((long)thisWorkEntry.hours_billed).ToString("#0.00"):"0.00" %>" />
                            </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabels" style="padding-right: 5px; vertical-align: middle; padding-bottom: 19px;">剩余时间
							<span id="errorSmall">*</span>
                                                    </td>
                                                    <td class="FieldLabels" style="vertical-align: middle;">
                                                        <div>
                                                            <input style="text-align: right;" type="text" name="remain_hours" id="remain_hours" class="decimal2" value="<%=v_task!=null&&v_task.remain_hours!=null?((decimal)v_task.remain_hours).ToString("#0.00"):"0.00" %>" />
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td name="offsetStartStopRow" class="FieldLabels" style="visibility: visible; padding-right: 5px;">估算差异: 
                                                    </td>
                                                    <td name="offsetStartStopRow" class="FieldLabels" id="startStopEstimatedHoursOffsetDisplay" style="visibility: visible; font-weight: normal; color: rgb(51, 51, 51); text-align: right; padding-right: 8px;"><%
                                                                                                                                                                                                                                                                     if (v_task != null)
                                                                                                                                                                                                                                                                     {
                                                                                                                                                                                                                                                                         var esHours = v_task.remain_hours == null ? 0 : (decimal)v_task.remain_hours + v_task.worked_hours == null ? 0 : (decimal)v_task.worked_hours - v_task.change_Order_Hours == null ? 0 : (decimal)v_task.change_Order_Hours - v_task.estimated_hours == null ? 0 : (decimal)v_task.estimated_hours;
                                                    %><%=esHours.ToString("#0.00") %><%                                                                                                                                                                                                                                            }


                                                    %></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>--%>
                                    <% }%>
                                </td>
                            </tr>
                            <tr>
                                <td class="FieldLabels">项目名称<span id="errorSmall">*</span>
                                    <div>
                                        <select name="project_id" tabindex="5" style="width: 300px;" id="project_id">
                                            <option value=""></option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="FieldLabels">任务标题<span id="errorSmall">*</span>
                                    <div>
                                        <select name="task_id" style="width: 300px;" id="task_id">
                                            <option value=""></option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="398px" border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>

                                                <td class="FieldLabels" nowrap="" width="200px">合同
					<div nowrap="">
                        <input type="text" id="contract_id" tabindex="7" style="width: 150px;" value="<%=thisContract==null?"":thisContract.name %>" readonly="">
                        <input type="hidden" name="contract_id" id="contract_idHidden" value="<%=thisContract==null?"":thisContract.id.ToString() %>" />
                        <a id="ChosCon" onclick="ChooseContract()">
                            <img tabindex="8" src="../Images/data-selector.png" border="0" style="vertical-align: middle"></a>

                    </div>
                                                </td>

                                                <td class="FieldLabels">服务/服务包<div>
                                                    <select id="service_id" tabindex="9" name="service_id" style="width: 100%;" disabled="disabled">
                                                    </select>
                                                </div>
                                                </td>

                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="398px" cellpadding="0" cellspacing="0" border="0">
                                        <tbody>
                                            <tr>

                                                <td class="FieldLabels" width="200px">工作类型<span id="errorSmall">*</span>
                                                    <div>
                                                        <asp:DropDownList ID="cost_code_id" runat="server" Width="164px">
                                                            <asp:ListItem Value="" Text=""></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </td>

                                                <td valign="middle" style="padding-bottom: 3px; padding-left: 33px;">
                                                    <asp:CheckBox ID="isBilled" runat="server" Checked="false" />不计费
                                                </td>

                                                <td valign="middle" style="padding-bottom: 3px">
                                                    <asp:CheckBox ID="ShowOnInv" runat="server" Checked="true" />显示在发票上
                                                </td>

                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="398px" cellpadding="0" cellspacing="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabels" width="200px">角色名称<span id="errorSmall">*</span>
                                                    <div>
                                                        <select name="role_id" id="role_id" style="width: 164px">
                                                        </select>
                                                    </div>
                                                </td>
                                                <!--draw status-->
                                                <td class="FieldLabels">状态
				<div>
                    <asp:DropDownList ID="status_id" runat="server"></asp:DropDownList>
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
                <div class="DivSection" style="margin-left: 0px; margin-right: 0px; width: 1080px; border: 1px solid #d3d3d3; margin: 0px 0px 22px 44px;padding-left:10px;" id="tblTextFields" name="tblTextFields">
                    <table class="searchareaborder" width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td valign="top" align="center">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" id="Table6">
                                        <tbody>
                                            

                                            <tr>
                                                <td colspan="2">
                                                    <div style="position: relative; visibility: visible; display: block; background-color: rgb(240, 245, 251); border: 1px solid rgb(211, 211, 211); padding: 20px; width: 95%; margin-left: 30px;">
                                                        <table border="0" cellspacing="0" cellpadding="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <div style="float: left; margin-left: 20px; min-width: 100px;">
                                                                            剩余时间
							<span id="errorSmall">*</span>
                                                                        </div>
                                                                        <div style="float: left; margin-left: -10px; min-width: 100px;">
                                                                            <input style="text-align: right;" type="text" name="remain_hours" id="remain_hours" class="decimal2" value="<%=v_task!=null&&v_task.remain_hours!=null?((decimal)v_task.remain_hours).ToString("#0.00"):"0.00" %>" /></div>
                                                                        <div style="float: left; margin-left: 20px; min-width: 100px; margin-left: 50px;">
                                                                            估算差异
							<span id="errorSmall">*</span>
                                                                        </div>
                                                                        <div style="float: left; margin-left: 20px; min-width: 100px;" id="yuguDiv">
                                                                            <%
                                                                                if (v_task != null)
                                                                                {
                                                                                    var esHours = v_task.remain_hours == null ? 0 : (decimal)v_task.remain_hours + v_task.worked_hours == null ? 0 : (decimal)v_task.worked_hours - v_task.change_Order_Hours == null ? 0 : (decimal)v_task.change_Order_Hours - v_task.estimated_hours == null ? 0 : (decimal)v_task.estimated_hours;
                                                                            %><%=esHours.ToString("#0.00") %>                                                                                                                                                                                                                                           <%} %>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                               
                                            <tr>
                                                <td width="50%" class="FieldLabels" colspan="2">
                                                    <div>
                                                        <input type="hidden" id="IsHasEntryAdd" value="" />
                                                        <input type="button" name="AddNewEntry" id="AddNewEntry" onclick="AddEntry()" value="新增日期" />
                                                        <table id="AddEntryTable">
                                                            <thead style="background-color: #428bc5; color: white;">
                                                                <tr>
                                                                    <th style="width: 20px;text-align:center;"></th>
                                                                    <th style="min-width: 100px;">日期</th>
                                                                    <%if (noTime)
                                                                        { %>
                                                                    <th style="min-width: 100px;">工作时长</th>
                                                                    <%}
                                                                    else
                                                                    { %>
                                                                    <th style="min-width: 100px;">开始时间</th>
                                                                    <th style="min-width: 100px;">结束时间</th>
                                                                     <th style="min-width: 100px;">工作时长</th>
                                                                    <th style="min-width: 100px;">偏移量</th>
                                                                    <th style="min-width: 100px;">计费时长</th>
                                                                   
                                                                    <%} %>
                                                                <%--    <th style="min-width: 100px;">工作说明</th>
                                                                    <th style="min-width: 100px;">内部说明</th>--%>
                                                                </tr>
                                                            </thead>
                                                            <tbody id="AddEntry">
                                                                <%if (entryList != null && entryList.Count > 0)
                                                                    {
                                                                        entryList = entryList.OrderBy(_ => _.start_time??0).ToList();
                                                                        foreach (var thisEnt in entryList)
                                                                        {%>
                                                                <tr data-val="<%=thisEnt.id %>" class="PageAddPage" id="entryAdd_<%=thisEnt.id %>" onclick="EditThis('<%=thisEnt.id %>')">
                                                                    <td>
                                                                        <input type='hidden' name='summ_<%=thisEnt.id %>' id='summ_<%=thisEnt.id %>' value='<%=thisEnt.summary_notes %>' /><input type='hidden' id='inter_<%=thisEnt.id %>' name='inter_<%=thisEnt.id %>' value='<%=thisEnt.internal_notes %>' />
                                                                       <a class='RemoveThisTr'><img src="../Images/delete.png"/></a></td>
                                                                    <td><span id='entry_date_span_<%=thisEnt.id %>'><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisEnt.start_time).ToString("yyyy-MM-dd") %></span><input type='hidden' name='entry_date_<%=thisEnt.id %>' id='entry_date_<%=thisEnt.id %>' value='<%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisEnt.start_time).ToString("yyyy-MM-dd") %>' /></td>
                                                                      <%if (noTime)
                                                                          { %>
                                                                    <td><span id='entry_work_span_<%=thisEnt.id %>'><%=thisEnt.hours_worked != null ? ((decimal)thisEnt.hours_worked).ToString("#0.00") : "" %></span><input type='hidden' name='entry_work_hour_<%=thisEnt.id %>' id='entry_work_hour_<%=thisEnt.id %>' value='<%=thisEnt.hours_worked != null ? ((decimal)thisEnt.hours_worked).ToString("#0.00") : "" %>' /></td>
                                                                    <%}
                                                                        else
                                                                        { %>
                                                                   <td><span id='entry_start_date_span_<%=thisEnt.id %>'><%=thisEnt.end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisEnt.start_time).ToString("HH:mm"):DateTime.Now.ToString("HH:mm") %></span><input type='hidden' name='entry_start_date_<%=thisEnt.id %>' id='entry_start_date_<%=thisEnt.id %>' value='<%=thisEnt.end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisEnt.start_time).ToString("HH:mm"):DateTime.Now.ToString("HH:mm") %>' /></td><td><span id='entry_end_date_span_<%=thisEnt.id %>'><%=thisEnt.end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisEnt.end_time).ToString("HH:mm"):DateTime.Now.ToString("HH:mm") %></span><input type='hidden' name='entry_end_date_<%=thisEnt.id %>' id='entry_end_date_<%=thisEnt.id %>' value='<%=thisEnt.end_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisEnt.end_time).ToString("HH:mm"):DateTime.Now.ToString("HH:mm") %>' /></td><td><span id='entry_worked_span_<%=thisEnt.id %>'><%=thisEnt.hours_worked==null?"0.00":((decimal)thisEnt.hours_worked).ToString("#0.00") %></span><input type='hidden' name='entry_worked_<%=thisEnt.id %>' id='entry_worked_<%=thisEnt.id %>' value='<%=thisEnt.hours_worked==null?"0.00":((decimal)thisEnt.hours_worked).ToString("#0.00") %>' /></td><td><span id='entry_offset_span_<%=thisEnt.id %>'><%=thisEnt.offset_hours.ToString("#0.00") %></span><input type='hidden' name='entry_offset_<%=thisEnt.id %>' id='entry_offset_<%=thisEnt.id %>' value='<%=thisEnt.offset_hours.ToString("#0.00") %>' /></td><td><span id='entry_billed_span_<%=thisEnt.id %>'><%=thisEnt.hours_billed==null?"0.00":((decimal)thisEnt.hours_billed).ToString("#0.00") %></span><input type='hidden' name='entry_billed_<%=thisEnt.id %>' id='entry_billed_<%=thisEnt.id %>' value='<%=thisEnt.hours_billed==null?"0.00":((decimal)thisEnt.hours_billed).ToString("#0.00") %>' /></td>
                                                                    <%} %>
                                                                 <%--   <td><span id='entry_sum_note_<%=thisEnt.id %>'><%=thisEnt.summary_notes %></span> </td>
                                                                    <td><span id='entry_ine_note_<%=thisEnt.id %>'><%=thisEnt.internal_notes %></span></td>--%>

                                                                </tr>
                                                                <%}
                                                                } %>
                                                            </tbody>

                                                        </table>
                                                        <div id="NewEntryAddDiv" style="display: none;">
                                                            <table>
                                                                <tr>
                                                                    <td style="min-width: 15px;"></td>
                                                                    <td style="min-width: 50px;"> 
                                                                        <input type="text" id="AddNewEntryDate" value="" onclick="WdatePicker()"  style="width:80px;"/></td>
                                                                    <%if (noTime)
                                                                        { %>
                                                                    <td style="min-width: 50px;">
                                                                        <input type="text" id="AddNewEntryWorkHour" value="" maxlength="5" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" /></td>
                                                                    <%}
                                                                    else
                                                                    {%>
                                                                    <td style="min-width: 50px;">
                                                                         <input type="text" size="8" id="AddNewEntryStartTime" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=DateTime.Now.ToString("HH:mm") %>" />&nbsp;<img src="../Images/time.png" border="0" style="vertical-align: middle; margin-bottom: 2px;" />
                                                                    </td>
                                                                    <td style="min-width: 50px;">
                                                                    <input type="text"  id="AddNewEntryEndTime" size="8" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=DateTime.Now.ToString("HH:mm") %>" />&nbsp;<img src="../Images/time.png" border="0" style="vertical-align: middle; margin-bottom: 2px;" />  </td>
                                                                    <td>
                                                                        <input style="text-align: right; color: #6d6d6d; background-color: #dbdbdb;" type="text"  id="AddNewEntryHoursWorked" readonly="" value="<%="0.00" %>" />
                                                                    </td>
                                                                    <td>
<input style="text-align: right;" type="text"  id="AddNewEntryOffsetHours" value="0.00" class="decimal2" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                                    </td>
                                                                    <td>
                                                                        <input style="text-align: right; color: #6d6d6d; background-color: #dbdbdb;" type="text" id="AddNewEntryHoursBilled" readonly="" value="0.00" />
                                                                    </td>
                                                                    <%} %>
                                                                <%--    <td style="min-width: 100px;">
                                                                        <textarea rows="3" id="AddNewEntrySumNote" style="resize: none;"></textarea> <img src="../Images/MagnifyPlus.png" id="img_AddNewEntrySumNote" class="ShowBigDiv" />
                                                                    </td>
                                                                    <td style="min-width: 100px;">
                                                                        <textarea rows="3" id="AddNewEntryIneNote" style="resize: none;"></textarea><img src="../Images/MagnifyPlus.png"  id="img_AddNewEntryIneNote" class="ShowBigDiv"/>
                                                                    </td>--%>
                                                                </tr>
                                                                <tr>
                                                                    <td></td>
                                                                    <td>
                                                                        <input type="button" id="PageAddNewEntry" onclick="SaveNewEntry()" value="保存" />
                                                                        <input type="button" id="PageCancelNewEntry" onclick="CancelEntry()" value="取消" style="margin-left: 10px;" />
                                                                    </td>
                                                                    <td><input type="hidden" name="BidDivId" id="BidDivId"/></td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                        <input type="hidden" id="PageMangeEntryId" value="" />
                                                    </div>
                                                    <input type="hidden" name="PageEntryIds" id="PageEntryIds" />
                                                </td>

                                            </tr>
                                       

                                 

                                            <tr>
                                                <td width="50%" class="FieldLabels">工时说明&nbsp;<span id="sumNotes1" class="FieldLabels"></span><span id="errorSmall">*</span></td>
                                                <td width="50%" style="text-align: right"><span title="Click to Expand" style="cursor: pointer;">
                                                    <img style="vertical-align: middle;" src="../Images/MagnifyPlus.png" id="img_summary_notes"  class="ShowBigDiv"/></span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" class="FieldLabels">
                                                    <div>
                                                        <textarea name="summary_notes" tabindex="19" maxlength="1000" rows="9" style="width: 98%" id="summary_notes"></textarea>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="50%" class="FieldLabels">内部说明&nbsp;<span id="intNotes1"></span></td>
                                                <td width="50%" style="text-align: right"><span title="Click to Expand" style="cursor: pointer;">
                                                    <img style="vertical-align: middle;" src="../Images/MagnifyPlus.png" class="ShowBigDiv" id="img_internal_notes"/></span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" class="FieldLabels">
                                                    <div>
                                                        <textarea name="internal_notes" tabindex="20" maxlength="1000" rows="6" style="width: 98%;" id="internal_notes"></textarea>
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
                <div id="noTimeAddManyEntryDiv" style="display: none;">
                </div>
            </div>
            <div id="BigTextDiv" style="display:none;min-width:900px;min-height:800px;margin-left: 20px;
    width: 95%;">
                <div style="text-align: right;margin-right: -20px;"><img src="../Images/MagnifyMinus.png" id="CloseBigTextDiv"/></div>
                <textarea id="BigTextArea" style="width:100%;height:100%;min-height: 600px;">

                </textarea>
          
            </div>

            <div id="notification" style="display: none;">
                <div id="FormContent" class="DivSection NoneBorder" style="padding-left: 0px; padding-right: 12px; margin-left: 44px;">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div id="mnuNotify" style="position: relative; top: 0px; left: 0px; visibility: visible; display: block;">
                                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                            <tbody>
                                                <tr>
                                                    <td>

                                                        <table class="searchareaborder" width="738px" cellspacing="0" cellpadding="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin-left: 50px;">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="369px" class="fieldLabels">
                                                                                        <div class="CheckBoxList">
                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="CCMe" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;">抄送给我<%=thisUser != null?"("+thisUser.name+")":"" %></span>
                                                                                            </div>

                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <input type="CHECKBOX" name="chkResAssigned" id="chkResAssigned" origchecked="true">&nbsp;<span style="cursor: default;" onclick="document.form1.chkResAssigned.checked=!document.form1.chkResAssigned.checked">任务员工</span>
                                                                                            </div>
                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="CCProRes" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;">项目负责人</span>
                                                                                            </div>

                                                                                        </div>
                                                                                    </td>

                                                                                    <td class="fieldLabels" width="357px" style="padding-left: 10px">
                                                                                        <div class="CheckBoxList">

                                                                                            <div class="checkbox" style="padding-bottom: 0px;display: none;">
                                                                                                <input type="checkbox" name="ccDetail" id="ccDetail" checked="" origchecked="true">&nbsp;<span style="cursor: default;" onclick="document.form1.ccDetail.checked=!document.form1.ccDetail.checked">Include  Details from Summary tab</span>
                                                                                            </div>
                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <input type="checkbox" name="ccNext" id="ccNext" checked="" origchecked="true">&nbsp;<span style="cursor: default;" onclick="document.form1.ccNext.checked=!document.form1.ccNext.checked">任务负责人</span>
                                                                                            </div>
                                                                                            <div class="checkbox" style="padding-bottom: 0px;display: none;">
                                                                                                <input type="checkbox" name="ccForResource" id="ccForResource" style="visibility: visible;" disabled="" origchecked="true">&nbsp;<span style="cursor: default;" id="ForResourceName" onclick="if(!this.disabled) document.form1.ccForResource.checked=!document.form1.ccForResource.checked">li, li</span>
                                                                                            </div>

                                                                                        </div>
                                                                                    </td>

                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>

                                                                    <td class="FieldLabels" width="369px" style="padding-left: 30px;">联系人
				 <div>
                     <div id="" style="width: 350px; height: 170px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                         <div class='grid' style='overflow: auto; height: 147px;'>
                             <table width='100%' border='0' cellspacing='0' cellpadding='3'>
                                 <thead>
                                     <tr>
                                         <td width='1%'>
                                             <%--<input type='checkbox' id='checkAll' />--%>
                                         </td>
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

                                                                    </td>
                                                                    <td class="FieldLabels">员工
                                            <span class="FieldLevelInstructions">(<a style="color: #376597; cursor: pointer;" onclick="LoadRes()">Load</a>)</span>
                                                                        <div id="reshtml" style="width: 350px; height: 170px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                                                                        </div>
                                                                    </td>

                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" colspan="2">其他邮件地址
					<div>
                        <input type="text" style="width: 726px;" name="otherEmail" id="otherEmail" />
                    </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" colspan="2">通知模板
				<div>
                    <asp:DropDownList ID="notify_id" runat="server" Width="740px"></asp:DropDownList>
                </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" colspan="2">主题
			<div>
                <input type="text" id="subjects" name="subjects" value="" style="width: 726px" />
                <input type="hidden" name="contact_ids" id="contact_ids" />
                <input type="hidden" name="resIds" id="resIds" />
                <input type="hidden" name="workGropIds" id="workGropIds" />
            </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" width="369px">附加信息</td>
                                                                    <td width="357px" style="text-align: right; padding-right: 1px;"><span title="Click to Expand" style="cursor: pointer;">
                                                                        <img style="vertical-align: middle" src="/graphics/icons/content/zoom-in.png?v=41154"></span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2" class="FieldLabels">
                                                                        <div>
                                                                            <textarea rows="6" style="width: 726px" name="AdditionalText" id="AdditionalText"></textarea>
                                                                        </div>
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                    <td colspan="2" style="text-align: right;"><a href="#" class="PrimaryLink" onclick="defaultSettings();">修改默认设置</a>&nbsp;&nbsp;</td>
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
        <input type="hidden" id="shijiTime" value=""/>
        <input type="hidden" id="yuguTime" value=""/>
        <input type="hidden" id="bianTime" value=""/>
        <input type="hidden" id="" value=""/>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>

    $(function () {

        GetCompanyList();
     <%if (thisProjetc != null)
    { %>
        var isHasAcc = $("#account_id option[value='<%=thisProjetc.account_id %>']").val();
        if (isHasAcc == undefined) {
            <% if (thisAccount != null)
    {%>
            $("#account_id").append("<option value='<%=thisAccount.id.ToString() %>'><%=thisAccount.name %></option>");
            <%}%>
        }

        //alert($("#account_id option[value=''").val());
        $("#account_id").val(<%=thisProjetc.account_id %>);
        GetProByAccount();
        var isHasPro = $("#project_id option[value='<%=thisProjetc.id %>']").val();
        if (isHasPro == undefined) {
            <% if (thisProjetc != null)
    {%>
            $("#project_id").append("<option value='<%=thisProjetc.id.ToString() %>'><%=thisProjetc.name %></option>");
            <%}%>
        }

        $("#project_id").val(<%=thisProjetc.id %>);
        GetTaskByProject();
          <%if (thisTask != null)
    {%>
        var isHasTas = $("#task_id option[value='<%=thisTask.id %>']").val();
        if (isHasTas == undefined) {

            $("#task_id").append("<option value='<%=thisTask.id.ToString() %>'><%=thisTask.title %></option>");

        }

        $("#task_id").val(<%=thisTask.id %>);
        <%}%>

     <%}%>
        GetRoleByRes();

       <% if (!isAdd)
    {
        if (thisWorkEntry.role_id != null)
        {
        %>
        $("#role_id").val(<%=thisWorkEntry.role_id %>);
        <%}
    if (thisWorkEntry.service_id != null)
    {%>
        GetServiceByContractID();
        $("#service_id").val(<%=thisWorkEntry.service_id %>);
        <%}
        // 工时权限过滤 部分字段不可以更改
        if (GetLimitValue(EMT.DoneNOW.DTO.AuthLimitEnum.PROCanModifyContract) == EMT.DoneNOW.DTO.DicEnum.LIMIT_TYPE_VALUE.NO960)
        {%>
        // ChooseContract() contract_id
        $("#ChosCon").removeAttr("onclick");
        $("#contract_id").prop("disabled", true);
       <% }
         if (GetLimitValue(EMT.DoneNOW.DTO.AuthLimitEnum.PROCanModifyNonBillable) == EMT.DoneNOW.DTO.DicEnum.LIMIT_TYPE_VALUE.NO960)
        {%>
        // ChooseContract() contract_id
        $("#isBilled").removeAttr("onclick");
        $("#isBilled").prop("disabled", true);
       <% }
          if (GetLimitValue(EMT.DoneNOW.DTO.AuthLimitEnum.PROCanModifyShow) == EMT.DoneNOW.DTO.DicEnum.LIMIT_TYPE_VALUE.NO960)
        {%>
        // ChooseContract() contract_id
        $("#ShowOnInv").removeAttr("onclick");
        $("#ShowOnInv").prop("disabled", true);
       <% }
           if (GetLimitValue(EMT.DoneNOW.DTO.AuthLimitEnum.PROCanModifyWorkType) == EMT.DoneNOW.DTO.DicEnum.LIMIT_TYPE_VALUE.NO960)
        {%>
        // ChooseContract() contract_id
       // $("#cost_code_id").removeAttr("onclick");
        $("#cost_code_id").prop("disabled", true);
       <% }
           if (GetLimitValue(EMT.DoneNOW.DTO.AuthLimitEnum.PROCanModifyService) == EMT.DoneNOW.DTO.DicEnum.LIMIT_TYPE_VALUE.NO960)
        {%>
        // ChooseContract() contract_id
        // $("#cost_code_id").removeAttr("onclick");
        $("#service_id").prop("disabled", true);
       <% }


    }%>
    })

    $("#resource_id").change(function () {
        GetRoleByRes();
        GetCompanyList();
    })

    $("#ShowTaskType").change(function () {
        GetCompanyList();
    })
    $("#chkShowCompletedTasks").click(function () {
        GetCompanyList();
    })
    // 根据选择的权限查找相应的客户信息
    function GetCompanyList() {

        // GetAccByRes
        var resId = $("#resource_id").val();
        var showType = $("#ShowTaskType").val();
        var isShowCom = $("#chkShowCompletedTasks").is(":checked");
        if (resId != null && resId != "" && resId != "0") {
            var url = "../Tools/CompanyAjax.ashx?act=GetAccByRes&resource_id=" + resId + "&showType=" + showType;
            if (isShowCom == "true") {
                url = url + "&isShowCom=1";
            }
            var accSelect = "<option value=''> </option>";
            $.ajax({
                type: "GET",
                url: url,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {

                        // var obj = JSON.parse(data);
                        for (var i = 0; i < data.length; i++) {
                            accSelect += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
            $("#account_id").html(accSelect);
        }

        GetProByAccount();
    }

    $("#account_id").change(function () {
        GetProByAccount();    // 获取项目信息
        ChangeConByAccount();  // 获取联系人信息
    })
    // 根据客户获取对应项目
    function GetProByAccount() {
        var account_id = $("#account_id").val();
        var proSelectHtml = "<option value=''> </option>";
        if (account_id != "" && account_id != "0") {
            var resId = $("#resource_id").val();
            var showType = $("#ShowTaskType").val();
            var isShowCom = $("#chkShowCompletedTasks").is(":checked");
            var url = "../Tools/ProjectAjax.ashx?act=GetProByRes&resource_id=" + resId + "&showType=" + showType + "&account_id=" + account_id;
            if (isShowCom == "true") {
                url = url + "&isShowCom=1";
            }
            $.ajax({
                type: "GET",
                url: url,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            proSelectHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
        }
        $("#project_id").html(proSelectHtml);
        GetTaskByProject();
    }

    $("#project_id").change(function () {
        GetTaskByProject();
        ChooseContractByProject();
    })
    // 根据项目获取相应任务
    function GetTaskByProject() {
        var project_id = $("#project_id").val();
        var taskSelectHtml = "<option value=''> </option>";
        if (project_id != "" && project_id != "0") {
            var resId = $("#resource_id").val();
            var showType = $("#ShowTaskType").val();
            var isShowCom = $("#chkShowCompletedTasks").is(":checked");
            var url = "../Tools/ProjectAjax.ashx?act=GetTaskByRes&resource_id=" + resId + "&showType=" + showType + "&project_id=" + project_id;
            if (isShowCom == "true") {
                url = url + "&isShowCom=1";
            }
            $.ajax({
                type: "GET",
                url: url,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            taskSelectHtml += "<option value='" + data[i].id + "'>" + data[i].title + "</option>";
                        }
                    }
                }
            })
        }
        $("#task_id").html(taskSelectHtml);
    }
    // 合同的查找带回
    function ChooseContract() {
        // contract_idHidden
        // con626 合同状态 1 激活 0 未激活
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACTMANAGE_CALLBACK %>&con626=1&field=contract_id&callBack=GetServiceByContractID";
           <%if (!isAdd && GetLimitValue(EMT.DoneNOW.DTO.AuthLimitEnum.PROCanModifyService) == EMT.DoneNOW.DTO.DicEnum.LIMIT_TYPE_VALUE.NO960)
        { %>
        url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACTMANAGE_CALLBACK %>&con626=1&field=contract_id";
        <%}%>
        var account_id = $("#account_id").val();
        if (account_id != "" && account_id != "0") {
            url += "&con627=" + account_id;
        }
        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 通过项目关联合同信息
    function ChooseContractByProject() {
        var project_id = $("#project_id").val();
        if (project_id != "" && project_id != "0") {
            var contract_id = "";
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=GetSinProject&project_id=" + project_id,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        contract_id = data.contract_id;
                    }
                }
            })

            if (contract_id != "" && contract_id != undefined && contract_id != null) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=property&property=name&contract_id=" + contract_id,
                    async: false,
                    //dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            $("#contract_idHidden").val(contract_id);
                            $("#contract_id").val(data);
                            // 
                        }
                    }
                })
                GetServiceByContractID();
            }
        }
    }
    // 通过合同，生成服务包信息
    function GetServiceByContractID() {
     
        var serHtml = "<option value=''> </option>";
        var contract_id = $("#contract_idHidden").val();
        if (contract_id != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ServiceAjax.ashx?act=GetSerList&contract_id=" + contract_id,
                async: false,
                //dataType: "json",
                success: function (data) {
                    if (data != "") {
                        serHtml += data;
                        $("#service_id").prop("disabled", false);
                    }
                }
            })
        } else {
            $("#service_id").prop("disabled", true);
        }
        $("#service_id").html(serHtml);
    }
    $("#isBilled").click(function () {
        if ($(this).is(":checked")) {
            // $("#ShowOnInv").prop("checked", false);
            <%if (GetLimitValue(EMT.DoneNOW.DTO.AuthLimitEnum.PROCanModifyShow) == EMT.DoneNOW.DTO.DicEnum.LIMIT_TYPE_VALUE.HAVE960) {%>
            $("#ShowOnInv").prop("disabled", false);
            <%}%>
            
        } else {
            <%if (GetLimitValue(EMT.DoneNOW.DTO.AuthLimitEnum.PROCanModifyShow) == EMT.DoneNOW.DTO.DicEnum.LIMIT_TYPE_VALUE.HAVE960) {%>
            $("#ShowOnInv").prop("checked", true);
            $("#ShowOnInv").prop("disabled", true);
            <%}%>
           
        }
    })

    function GetRoleByRes() {
        var resId = $("#resource_id").val();
        if (resId != "" && resId != "0" && resId != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=GetRoleList&source_id=" + resId,
                async: false,
                success: function (data) {
                    if (data != "") {
                        $("#role_id").html(data);
                    } else {
                        $("#role_id").html("<option value=''>  </option>");
                    }
                }
            })
        } else {
            $("#role_id").html("<option value=''>  </option>");
        }
    }

    $("#AddNewEntryDate").blur(function () {
        var thisValue = $(this).val();
        if (thisValue == "") {
            thisValue = '<%=DateTime.Now.ToString("yyyy-MM-dd") %>';
        }
        $("#sumNotes1").html(thisValue);
        $("#intNotes1").html(thisValue);

    })

    $(".decimal2").blur(function () {
        var value = $(this).val();
        if (!isNaN(value) && value != "") {
            $(this).val(toDecimal2(value));
        } else {
            $(this).val("");
        }
    })

    $("#AddNewEntryStartTime").blur(function () {
        var thisValue = JiSuanBillHour();
        if (thisValue == "0") {
            $(thisValue).val("");
        } else {
            JiSuanWorkHours();
        }
    })
    $("#AddNewEntryEndTime").blur(function () {
        var thisValue = JiSuanBillHour();
        if (thisValue == "0") {
            $(thisValue).val("");
        } else {
            JiSuanWorkHours();
        }
    })
    $("#AddNewEntryOffsetHours").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && (!isNaN(thisValue))) {
            var bills = $("#AddNewEntryHoursWorked").val();
            if (bills != "" && (!isNaN(bills))) {
                var newBills = Number(bills) + Number(thisValue);
                $("#AddNewEntryHoursBilled").val(toDecimal2(newBills));
            } else {
                $("#AddNewEntryHoursBilled").val(toDecimal2(thisValue));
            }
        }
    })

    // 计算计费时间  0代表时间不对  1代表执行成功
    function JiSuanBillHour() {
        // hours_billed
        // 根据系统设置进行判断如何取整

        var startDate = $("#AddNewEntryStartTime").val();
        var endDate = $("#AddNewEntryEndTime").val();
        var dayDate = $("#AddNewEntryDate").val();
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

            var billOff = $("#AddNewEntryOffsetHours").val();
            if (billOff != "" && (!isNaN(billOff))) {
                bills = bills + Number(billOff);
            }
            $("#AddNewEntryHoursBilled").val(toDecimal2(bills));


            return "1";
        } else {
            $("#AddNewEntryHoursBilled").val("0.00");
            return "";
        }
    }


    function JiSuanWorkHours() {
        var startDate = $("#AddNewEntryStartTime").val();
        var endDate = $("#AddNewEntryEndTime").val();
        var dayDate = $("#AddNewEntryDate").val();
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
            $("#AddNewEntryHoursWorked").val(toDecimal2(bills));
        } else {
            $("#AddNewEntryHoursWorked").val("0.00");
        }
    }

    function SubmitCheck() {
        // account_id
        var resource_id = $("#resource_id").val();
        if (resource_id == "" || resource_id == null || resource_id == "0") {
            LayerMsg("请选择员工！");
            return false;
        }
        var account_id = $("#account_id").val();
        if (account_id == "" || account_id == null || account_id == "0") {
            LayerMsg("请选择客户！");
            return false;
        }
        var project_id = $("#project_id").val();
        if (project_id == "" || project_id == null || project_id == "0") {
            LayerMsg("请选择项目！");
            return false;
        }
        var task_id = $("#task_id").val();
        if (task_id == "" || task_id == null || task_id == "0") {
            LayerMsg("请选择任务！");
            return false;
        }
        var cost_code_id = $("#cost_code_id").val();
        if (cost_code_id == "" || cost_code_id == null || cost_code_id == "0") {
            LayerMsg("请选择工作类型！");
            return false;
        }
        var role_id = $("#role_id").val();
        if (role_id == "" || role_id == null || role_id == "0") {
            LayerMsg("请选择角色！");
            return false;
        }
        <% if (!noTime)
    { %>
        //var startTime = $("#startTime").val();
        //if (startTime == "" || startTime == null) {
        //    LayerMsg("请填写开始时间！");
        //    return false;
        //}// tmeDate
        //var endTime = $("#endTime").val();
        //if (endTime == "" || endTime == null) {
        //    LayerMsg("请填写结束时间！");
        //    return false;
        //}
        //var tmeDate = $("#tmeDate").val();
        //if (tmeDate == "" || tmeDate == null)
        //{
        //    LayerMsg("请填写日期！");
        //    return false;
        //}

        //var hours_worked = $("#hours_worked").val();
        //if (hours_worked == "") {
        //    LayerMsg("请填写工作时长！");
        //    return false;
        //}
        //if (isNaN(hours_worked) || Number(hours_worked) <= 0) {
        //    LayerMsg("工作时长要大于0！");
        //    return false;
        //}
        <%}%>
        var remain_hours = $("#remain_hours").val();
        if (remain_hours == "" || remain_hours == null || remain_hours == undefined) {
            LayerMsg("请填写剩余时间！");
            return false;
        }
     <%--   var workSummary1 = $("#summary_notes").val();
        if (workSummary1 == "" || workSummary1 == null) {
            var noteValue = '<%=new EMT.DoneNOW.BLL.SysSettingBLL().GetValueById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_REQUIRED_SUMMAY_NOTE) %>';
            if (noteValue == "1") {
                  <%if(!noTime){ %>
                LayerMsg("请填写工时说明！");
                return false;
                <%}%>
            }
        }--%>



        // 
        // PageAddPage
   
        // 判断是否有新增工时
        var ids = "";
        $(".PageAddPage").each(function () {
            ids += $(this).data("val") + ',';
        })
        if (ids == "") {
            <%if (isAdd)
    { %>
            LayerMsg("请添加工时日期！");
            return false;
            <%}%>
        }
        $("#PageEntryIds").val(ids);
       

        return true;
    }

    $("#save_close").click(function () {
        if (!SubmitCheck()) {

            return false;
        }
        GetContratID();
        GetResID();
        return true;
    })
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

    function ChangeConByAccount() {
        // conhtml
        var account_id = $("#account_id").val();
        if (account_id != "" && account_id != "0") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContactAjax.ashx?act=GetContacts&account_id=" + account_id,
                success: function (data) {
                    if (data != "") {
                        $("#conhtml").html(data);
                    }
                },
            });
        } else {
            $("#conhtml").html("");
        }
    }
</script>
<script>
    $("#general").click(function () {
        $("#general").addClass("boders");
        $("#notifyLi").removeClass("boders");
        $("#Summary").show();
        $("#notification").hide();
    })

    $("#notifyLi").click(function () {
        $("#notifyLi").addClass("boders");
        $("#general").removeClass("boders");
        $("#notification").show();
        $("#Summary").hide();
    })
    function GetContratID() {
        var ids = "";
        $(".checkCon").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#contact_ids").val(ids);
    }
    function GetResID() {
        var ids = "";
        $(".checkRes").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#resIds").val(ids);
    }

    function GetWorkGroupIds() {
        var ids = "";
        $(".checkWork").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#workGropIds").val(ids);
    }
    $("#ClosePage").click(function () {
        window.close();
    })
</script>

<script>
    function AddEntry() {
        // 判断是否有新增
        var isHas = $("#IsHasEntryAdd").val();
        if (isHas != "") {
            LayerMsg("请关闭当前保存项");
            return false;
        }
        else {
            $("#IsHasEntryAdd").val("1");
            var AddNewEntryDate = $("#AddNewEntryDate").val();
            if (AddNewEntryDate != "")
            {
                debugger;
                var reg = /(\d{4})\-(\d{2})\-(\d{2})/;
                var date = AddNewEntryDate.replace(reg, "$1/$2/$3");
                var newDate = new Date(date);
                newDate.setDate(newDate.getDate()+1);
                $("#AddNewEntryDate").val(newDate.getFullYear() + "-" + Number(newDate.getMonth() + 1) + "-" + newDate.getDate());
            }
            else
            {
                $("#AddNewEntryDate").val("<%=DateTime.Now.ToString("yyyy-MM-dd") %>");
            }

            $("#NewEntryAddDiv").show();
            var AddNewEntryDate = $("#AddNewEntryDate").val();
            if (AddNewEntryDate != "") {
                $("#sumNotes1").html(AddNewEntryDate); 
                $("#intNotes1").html(AddNewEntryDate);
            }

        }
    }
    var entryAddNum = 0;
    function SaveNewEntry() {  // saveType 代表新增还是修改
        var saveType = "";
        var TrId = $("#PageMangeEntryId").val();
        if (TrId != "") {
            saveType = "Edit";
        }
        else {
            saveType = "Add";
        }
        var AddNewEntryDate = $("#AddNewEntryDate").val();
        if (AddNewEntryDate == "") {
            LayerMsg("请填写工时时间");
            return false;
        }
        var AddNewEntryWorkHour = $("#AddNewEntryWorkHour").val();
        <%if (noTime)
    { %>
        if (AddNewEntryWorkHour == "") {
            LayerMsg("请填写工作时长");
            return false;
        }
        <%}
    else
    {
        %>
        var AddNewEntryStartTime = $("#AddNewEntryStartTime").val();
        if (AddNewEntryStartTime == "") {
            LayerMsg("请填写开始时间");
            return false;
        }
        var AddNewEntryEndTime = $("#AddNewEntryEndTime").val();
        if (AddNewEntryEndTime == "") {
            LayerMsg("请填写结束时间");
            return false;
        }
        var AddNewEntryHoursWorked = $("#AddNewEntryHoursWorked").val();
        if (AddNewEntryHoursWorked == "") {
            LayerMsg("请填写工作时长");
            return false;
        }
        if (Number(AddNewEntryHoursWorked) <= 0) {
            LayerMsg("工作时长不能小于0 ");
            return false;
        }
        if (Number(AddNewEntryHoursWorked) >= 24) {
            LayerMsg("工作时长不能大于24");
            return false;
        }
        var AddNewEntryOffsetHours = $("#AddNewEntryOffsetHours").val();
        var AddNewEntryHoursBilled = $("#AddNewEntryHoursBilled").val();
        <%}%>
        if (Number(AddNewEntryWorkHour) <= 0 || Number(AddNewEntryWorkHour) >= 24) {
            LayerMsg("工作时长超出范围");
            return false;
        }
        
        var sumNoteVals = $("#summary_notes").val();

        if (sumNoteVals == "") {
            var noteValue = '<%=new EMT.DoneNOW.BLL.SysSettingBLL().GetValueById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_REQUIRED_SUMMAY_NOTE) %>';
            if (noteValue == "1") {
                LayerMsg("请填写工时说明");
                return false;
            }
        }// 


        //  保存需要对任务的剩余时间 进行的操作

        //
        //  当新增时 剩余时间 减少相应的工作时长
        //  当为修改时 剩余时间 添加 减少相应的变更的值
        //  当剩余时间为0 时不进行减少操作
        //  当剩余时间为0 进行删除工时操作时，剩余时间依然会增加
        var remain_hours = $("#remain_hours").val();

        var ineNoteVals = $("#internal_notes").val();
        if (saveType == "Add") {
            entryAddNum--;
            // onclick=\"RemoveThis('" + entryAddNum + "')\"
            var addNewHtml = "<tr data-val='" + entryAddNum + "' class='PageAddPage' id='entryAdd_" + entryAddNum + "' onclick=EditThis('" + entryAddNum + "') ><td><input type='hidden' name='summ_" + entryAddNum + "' id='summ_" + entryAddNum + "' value='" + sumNoteVals + "' /><input type='hidden' id='inter_" + entryAddNum + "' name='inter_" + entryAddNum + "' value='" + ineNoteVals + "' /> <a  class='RemoveThisTr' ><img src='../Images/delete.png' /></a></td><td> <span id='entry_date_span_" + entryAddNum + "'>" + AddNewEntryDate + "</span><input type='hidden' name='entry_date_" + entryAddNum + "' id='entry_date_" + entryAddNum + "' value='" + AddNewEntryDate + "' /></td>";
            <%if (noTime)
    { %>
            addNewHtml+= "<td><span id='entry_work_span_" + entryAddNum + "'>" + AddNewEntryWorkHour + " </span><input type='hidden' name='entry_work_hour_" + entryAddNum + "' id='entry_work_hour_" + entryAddNum + "' value='" + AddNewEntryWorkHour + "' /></td>";
            <%} else {%>
            addNewHtml += "<td><span id='entry_start_date_span_" + entryAddNum + "'>" + AddNewEntryStartTime + "</span><input type='hidden' name='entry_start_date_" + entryAddNum + "' id='entry_start_date_" + entryAddNum + "' value='" + AddNewEntryStartTime + "' /></td><td><span id='entry_end_date_span_" + entryAddNum + "'>" + AddNewEntryEndTime + "</span><input type='hidden' name='entry_end_date_" + entryAddNum + "' id='entry_end_date_" + entryAddNum + "' value='" + AddNewEntryEndTime + "' /></td><td><span id='entry_worked_span_" + entryAddNum + "'>" + AddNewEntryHoursWorked + "</span><input type='hidden' name='entry_worked_" + entryAddNum + "' id='entry_worked_" + entryAddNum + "' value='" + AddNewEntryHoursWorked + "' /></td><td><span id='entry_offset_span_" + entryAddNum + "'>" + AddNewEntryOffsetHours + "</span><input type='hidden' name='entry_offset_" + entryAddNum + "' id='entry_offset_" + entryAddNum + "' value='" + AddNewEntryOffsetHours + "' /></td><td><span id='entry_billed_span_" + entryAddNum + "'>" + AddNewEntryHoursBilled+"</span><input type='hidden' name='entry_billed_" + entryAddNum + "' id='entry_billed_" + entryAddNum + "' value='" + AddNewEntryHoursBilled +"' /></td>";
            <%}%>
            //<td><span id='entry_sum_note_" + entryAddNum + "'>" + sumNoteVals + "</span> </td > <td><span id='entry_ine_note_" + entryAddNum + "'>" + ineNoteVals + "</span></td>
            addNewHtml+= "</tr> ";
            $("#AddEntry").append(addNewHtml);
            $(".RemoveThisTr").click(function (event) {

                var TrId = $(this).parent().parent().data("val");
                RemoveThis(TrId);
                event.stopPropagation();
            })

            if (Number(remain_hours) != 0) {
                <%if (noTime)
    { %>
                var thisRemaTime = Number(remain_hours) - Number(AddNewEntryWorkHour);
                <%}
    else
    {%>
                var thisRemaTime = Number(remain_hours) - Number(AddNewEntryHoursWorked);
                <%}%>
                if (Number(thisRemaTime) <= 0) {
                    thisRemaTime = 0;
                }
                $("#remain_hours").val(toDecimal2(thisRemaTime));

            }
            
        }
        else {
            $("#summ_" + TrId).val(sumNoteVals);
            $("#inter_" + TrId).val(ineNoteVals);
            //$("#entry_sum_note_" + TrId).html(sumNoteVals);
            //$("#entry_ine_note_" + TrId).html(ineNoteVals);
            $("#entry_date_span_" + TrId).html(AddNewEntryDate);
            $("#entry_date_" + TrId).val(AddNewEntryDate);
            <%if (noTime)
    { %>
            $("#entry_work_span_" + TrId).html(AddNewEntryWorkHour);
            $("#entry_work_hour_" + TrId).val(AddNewEntryWorkHour);
            <%}%>
            $("#entryAdd_" + TrId).show();

            var oldEntry = $("#entry_worked_" + TrId).val();
                    <%if (noTime)
    { %>
            var thisRemaTime = Number(remain_hours) - (Number(oldEntry) - Number(AddNewEntryWorkHour));
                <%}
    else
    {%>
            var thisRemaTime = Number(remain_hours) - (Number(oldEntry) - Number(AddNewEntryHoursWorked));
                <%}%>

            if (Number(thisRemaTime) <= 0) {
                thisRemaTime = 0;
            }
            $("#remain_hours").val(toDecimal2(thisRemaTime));
        }
        $(".PageAddPage").show();
        $("#PageMangeEntryId").val("");
        $("#IsHasEntryAdd").val("");
        $("#NewEntryAddDiv").hide();

        $("#sumNotes1").html("");
        $("#intNotes1").html("");
        $("#summary_notes").val("");
        $("#internal_notes").val("");
        return true;
    }
    // 移除新增的工时
    function RemoveThis(TrId) {

           // 删除工时
           // 新增剩余时间相关处理
           // 获取到删除的工作时长
           // 删除后 剩余时间增加相应时长
        var thisWorke = "";
                  <%if (noTime)
    { %>
        thisWorke = $("#entry_work_hour_" + TrId).val();
                  <%}
    else
    { %>
        thisWorke = $("#entry_worked_" + TrId).val();
        <%}%>
        var remain_hours = $("#remain_hours").val();
        if (thisWorke != "") {
            remain_hours = Number(remain_hours) + Number(thisWorke);
            $("#remain_hours").val(toDecimal2(remain_hours));
        }


        var thisId = $("#PageMangeEntryId").val();
        if (thisId != "") {
            LayerMsg("请先完成当前保存操作");
           
        }
        else {
            if (Number(TrId) > 0) {
                LayerConfirm("删除不能恢复，是否继续？", "是", "否", function () { $("#entryAdd_" + TrId).remove();}, function () { });
            } else {
                $("#entryAdd_" + TrId).remove();
            }
        }
        return false;

    }
    $(".RemoveThisTr").click(function (event) {

        var TrId = $(this).parent().parent().data("val");
        RemoveThis(TrId);
        event.stopPropagation(); 
    })
    function EditThis(TrId) {
        $("#PageMangeEntryId").val(TrId);
        var isHas = $("#IsHasEntryAdd").val();
        if (isHas != "") {

        }
        else {
            var thisDate = $("#entry_date_" + TrId).val();
            $("#AddNewEntryDate").val(thisDate);
            <%if (noTime)
    { %>
            $("#AddNewEntryWorkHour").val($("#entry_work_hour_" + TrId).val());
            <%}
    else
    {%>
            $("#AddNewEntryStartTime").val($("#entry_start_date_" + TrId).val());
            $("#AddNewEntryEndTime").val($("#entry_end_date_" + TrId).val());
            $("#AddNewEntryHoursWorked").val($("#entry_worked_" + TrId).val());
            $("#AddNewEntryOffsetHours").val($("#entry_offset_" + TrId).val());
            $("#AddNewEntryHoursBilled").val($("#entry_billed_" + TrId).val());
            <%}%>
            //$("#AddNewEntrySumNote").val($("#summ_" + TrId).val());
            //$("#AddNewEntryIneNote").val($("#inter_" + TrId).val());

            $("#summary_notes").val($("#summ_" + TrId).val());
            $("#internal_notes").val($("#inter_" + TrId).val());

            $("#sumNotes1").html(thisDate);
            $("#intNotes1").html(thisDate);

            $("#entryAdd_" + TrId).hide();
            $("#IsHasEntryAdd").val("1");
            $("#NewEntryAddDiv").show();

        }
        return false;
    }
    // 取消显示保存工时的Div
    function CancelEntry() {
        $(".PageAddPage").show();
        $("#NewEntryAddDiv").hide(); 
        $("#IsHasEntryAdd").val("");
        $("#PageMangeEntryId").val("");
        $("#sumNotes1").html("");
        $("#intNotes1").html("");
        $("#summary_notes").val("");
        $("#internal_notes").val("");
        
    }
    //$("#SumOpenBigDiv").click(function () {
    //    $("#BidDivId").val("AddNewEntrySumNote");
    //    $("#Summary").hide();
    //    $("#BigTextDiv").show();
    //    $("#BigTextArea").val($("#AddNewEntrySumNote").val());
    //})
    $(".ShowBigDiv").click(function () {
        debugger;
        var thisID = $(this).eq(0).attr("id");

        thisID = thisID.substring(4, thisID.length);
        $("#BidDivId").val(thisID);
        $("#Summary").hide();
        $("#BigTextDiv").show();
        $("#BigTextArea").val($("#" + thisID).val());
    })

    $("#CloseBigTextDiv").click(function () {
        var txetId = $("#BidDivId").val();
        if (txetId != "" && txetId != undefined) {
            $("#" + txetId).val($("#BigTextArea").val());

            $("#BidDivId").val("");
        }
        $("#Summary").show();
        $("#BigTextDiv").hide();
    })

    // 根据改变的task的值，动态获取剩余时间
    $("#task_id").change(function () {
        var thisTaskId = $(this).val();
        if (thisTaskId != "" && thisTaskId != "0" && thisTaskId != undefined) {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=GetVTask&task_id=" + thisTaskId,
                dataType:"json",
                success: function (data) {
                    if (data != "" ) {
                        if (data.remain_hours != undefined && data.remain_hours != null) {
                            $("#remain_hours").val(toDecimal2(data.remain_hours));
                        } else {
                            $("#remain_hours").val("");
                        }
                        if (data.worked_hours != null) {
                            $("#shijiTime").val(toDecimal2(data.worked_hours));
                        } else {
                            $("#shijiTime").val("0");
                        }
                        // change_Order_Hours
                        if (data.estimated_hours != null) {
                            $("#yuguTime").val(toDecimal2(data.estimated_hours));
                        } else {
                            $("#yuguTime").val("0");
                        }
                        if (data.change_Order_Hours != null) {
                            $("#bianTime").val(toDecimal2(data.change_Order_Hours));
                        } else {
                            $("#bianTime").val("0");
                        }
                        $("#yuguDiv").html("");
                    }
                    else {
                        $("#remain_hours").val("");
                        $("#shijiTime").val("");
                        $("#yuguTime").val("");
                        $("#bianTime").val("");
                        $("#yuguDiv").html("");
                    }
                },
            });
        }
        else {
            $("#remain_hours").val("");
            $("#remain_hours").val("");
            $("#shijiTime").val("");
            $("#yuguTime").val("");
            $("#bianTime").val("");
            $("#yuguDiv").html("");
        }
        EsDiff();
    })
    $("#remain_hours").blur(function () {
        EsDiff();
    })

    function EsDiff() {
        var remain_hours = $("#remain_hours").val();
        var shijiTime = $("#shijiTime").val();
        var yuguTime = $("#yuguTime").val();
        var bianTime = $("#bianTime").val();

        if (remain_hours != "" && shijiTime != "" && yuguTime != "" && bianTime != "") {

            var total = Number(remain_hours) + Number(shijiTime) - Number(yuguTime) - Number(bianTime);
            $("#yuguDiv").html(toDecimal2(total));
        } else {
            $("#yuguDiv").html("");
        }
    }
</script>
