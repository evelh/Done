<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddQuickCall.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.AddQuickCall" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/index.css" />
    <link rel="stylesheet" href="../Content/style.css" />
    <title>快速新增服务预定</title>
    <style>
        td {
            text-align: left;
        }

        .errorSmallClass {
            color: red;
        }

        span.FieldLabel {
            margin-left: 17px;
        }

        .content td img {
            width: 16px;
            height: 17px;
        }

        span.lblNormalClass {
            margin-left: 17px;
        }
        .content input[type=checkbox]{
            margin-top:2px;
        }
        .filed{
            margin-left:15px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">快速新增服务预定</div>
        <div class="header-title">
            <ul>
                <li>
                    <img src="../Images/save.png" alt="" />
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClientClick="return SubmitCheck();" OnClick="save_close_Click" />
                </li>
                <li>
                    <img src="../Images/save.png" alt="" />
                    <asp:Button ID="save_add" runat="server" Text="保存并编辑工单" OnClientClick="return SubmitCheck();" OnClick="save_add_Click" />
                </li>
                <li onclick="javascript:window.close();">
                    <img src="../Images/cancel.png" alt="" />
                    关闭
                </li>
                <li style="float:right;background: white;border: 0px;display:block;">
                    <select style="width:200px;" id="fromTmplId" name="fromTmplId">
                        <option></option>
                        <%if (tmplList != null && tmplList.Count > 0) {
                                foreach (var tmpl in tmplList)
                                {%>
                                <option value="<%=tmpl.id %>"><%=tmpl.tmpl_name %></option>
                               <% }
                            } %>
                    </select>
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 80px;">
            <div class="content clear">
                <div class="information clear">
                    <p class="informationTitle"><i></i>常规</p>
                    <div>
                        <table border="0" style="width: 740px;">
                            <tbody>
                                <tr valign="middle">
                                    <td class="FieldLabel" valign="middle" style="text-align: left;"><span class="FieldLabel" style="font-weight: bold;">客户名称</span><span class="lblNormalClass" style="font-weight: bold; color: red;margin: 0;"> *</span>
                                        <div style="display: flex;">
                                            <input name="account_id" type="hidden" id="accountNameHidden" value="" />
                                            <span id="dslAccountName" style="display: inline-block;">
                                                <input name="" type="text" id="accountName" class="txtBlack8Class" style="width: 540px;" value="<%=thisAccount!=null?thisAccount.name:"" %>" />

                                            </span>
                                            <a href="#" id="dslAccountName_anchor" class="DataSelectorLinkIcon" style="margin-left: 7px;"  onclick="CallBackAccount()">
                                                <img src="../Images/data-selector.png" /></a>
                                            <%--<span class="Icon" style="background: url(../Images/Icons.png) no-repeat -149px -142px;"  onclick="ShowAccNoTicket()"></span>--%>
                                            <img style="background: url(../Images/Icons.png) no-repeat -149px -143px;margin-left:6px;" onclick="ShowAccNoTicket()" />
                                            <img src="../Images/add.png" style="margin-left: -108px;" onclick="AddAccount()"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr valign="middle">
                                    <td id="_ctl98" class="FieldLabel" valign="middle" style="text-align: left;"><span class="FieldLabel" style="font-weight: bold;">联系人</span><div>
                                        <table id="" border="0" style="border-collapse: collapse;">
                                            <tbody>
                                                <tr>
                                                    <td id=""><span id="" style="display: flex;">
                                                        <select name="contact_id" id="contact_id" class="txtBlack8Class" style="width: 540px;" disabled="">
                                                        </select>
                                                        <a id="" style="color: grey;" onclick="AddContact()">
                                                            <img src="../Images/add.png" style="margin-left: 6px; margin-top: 5px;" /></a></span></td>
                                                    <td id="accountContact_DataSeletorCell" style="display: none;"></td>
                                                    <td id=""></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    </td>
                                </tr>
                                <tr valign="middle">
                                    <td class="FieldLabel" style="text-align: left;"><span class="FieldLabel" style="font-weight: bold;">工单标题</span><span class="lblNormalClass" style="font-weight: bold; color: red;margin: 0;"> *</span><div>
                                        <span id="txtTicketTitle" style="display: inline-block;">
                                            <input name="title" type="text" id="title" class="txtBlack8Class" style="width: 540px;" /></span>
                                    </div>
                                    </td>
                                </tr>
                                <tr valign="middle">
                                    <td class="FieldLabel" valign="middle" style="text-align: left;"><span class="FieldLabel" style="font-weight: bold;">工单描述</span><div>
                                        <span id="txtTicketDescription" style="display: inline-block;">
                                            <textarea name="description" id="description" class="txtBlack8Class" maxlength="4000" style="height: 45px; width: 540px;"></textarea></span>
                                    </div>
                                    </td>
                                </tr>
                                <tr valign="middle">
                                    <td>
                                        <div>
                                            <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                <tbody>
                                                    <tr valign="middle">
                                                        <td style="align: left;"><span class="lblNormalClass" style="font-weight: bold;">优先级</span><span class="lblNormalClass" style="color: Red; font-weight: bold;margin: 0;"> *</span><div>
                                                            <span id="ddlPriority" style="display: inline-block;">
                                                                <select name="priority_type_id" id="priority_type_id" class="txtBlack8Class" style="width: 215px;">
                                                                    <% if (priorityList != null && priorityList.Count > 0)
                                                                        {
                                                                            foreach (var priority in priorityList)
                                                                            {    %>
                                                                    <option value="<%=priority.id %>"><%=priority.name %></option>
                                                                    <% }
                                                                        } %>
                                                                </select></span>
                                                        </div>
                                                        </td>
                                                        <td style="padding-left: 3px; padding-right: 3px; text-align: right;">&nbsp;</td>
                                                        <td style="padding-left: 3px; padding-right: 3px; text-align: left;"><span class="lblNormalClass" style="font-weight: bold;">工单种类</span><div>
                                                            <span id="ddlTicketCategory" style="display: inline-block;">
                                                                <select name="cate_id" id="cate_id" class="txtBlack8Class" style="width: 215px;">
                                                                    <% if (ticketCateList != null && ticketCateList.Count > 0)
                                                                        {
                                                                            foreach (var ticketCate in ticketCateList)
                                                                            {    %>
                                                                    <option value="<%=ticketCate.id %>"><%=ticketCate.name %></option>
                                                                    <% }
                                                                        } %>
                                                                </select></span>
                                                        </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr valign="middle">
                                    <td valign="middle">
                                        <div style="padding-bottom: 0px;">
                                            <span>
                                                <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                    <tbody>
                                                        <tr>
                                                            <td style="align: left;"><span class="FieldLabel" style="font-weight: bold;">问题类型</span><span class="lblNormalClass" style="color: Red; font-weight: bold;margin: 0;"> *</span><div>
                                                                <span id="ATCompositeDropDownList_MainList" style="display: inline-block;">
                                                                    <select name="issue_type_id" id="issue_type_id" class="txtBlack8Class" style="width: 215px;">
                                                                        <option></option>
                                                                        <% if (issueTypeList != null && issueTypeList.Count > 0)
                                                                            {
                                                                                foreach (var issueType in issueTypeList)
                                                                                {    %>
                                                                        <option value="<%=issueType.id %>"><%=issueType.name %></option>
                                                                        <% }
                                                                            } %>
                                                                    </select></span>
                                                            </div>
                                                            </td>
                                                            <td style="padding-left: 3px; padding-right: 3px; text-align: right;">&nbsp;</td>
                                                            <td style="padding-left: 3px; padding-right: 3px; text-align: left;"><span class="FieldLabel" style="font-weight: bold;">子问题类型</span><span class="lblNormalClass" style="color: Red; font-weight: bold;margin: 0;"> *</span><div>
                                                                <span id="ATCompositeDropDownList_SubList" style="display: inline-block;">
                                                                    <select name="sub_issue_type_id" id="sub_issue_type_id" class="txtBlack8Class" style="width: 215px;">
                                                                    </select></span>
                                                            </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="content clear">
                <div class="information clear">
                    <p class="informationTitle"><i></i>计费</p>
                    <div>
                        <table border="0" style="width: 740px;">
                            <tbody>
                                <tr valign="middle">
                                    <td class="FieldLabel" valign="middle" style="text-align: left;"><span class="FieldLabel" style="font-weight: bold;">合同</span><div>
                                        <input name="contract_id" type="hidden" id="contractIdHidden" value="" />
                                        <span id="dslContract" disabled="disabled" style="display: flex;">
                                            <input name="" type="text" id="contractId" disabled="" class="txtBlack8Class" style="width: 540px;" readonly="" />
                                            <a id="dslContract_anchor" class="DataSelectorLinkIcon" style="margin-left: 5px;padding-top: 5px;" onclick="ContractCallBack()">
                                                <img id="dslContract_image" src="../Images/data-selector.png" style="cursor: default;" /></a>
                                        </span>

                                    </div>
                                    </td>
                                </tr>
                                <tr valign="middle">
                                    <td class="FieldLabel" valign="middle" style="text-align: left;"><span class="FieldLabel" style="font-weight: bold;">工作类型</span><span class="lblNormalClass" style="font-weight: bold; color: red;margin: 0;"> *</span><div>
                                        <span id="ddlAllocationCode" style="display: inline-block;">
                                            <select name="cost_code_id" id="cost_code_id" class="txtBlack8Class" style="width: 540px;">
                                                <% if (codeList != null && codeList.Count > 0)
                                                    {
                                                        foreach (var code in codeList)
                                                        {    %>
                                                <option value="<%=code.id %>"><%=code.name %></option>
                                                <% }
                                                    } %>
                                            </select>
                                        </span>
                                    </div>
                                    </td>
                                </tr>
                                <tr valign="middle">
                                    <td class="FieldLabel" valign="middle" style="text-align: left;"><span class="FieldLabel" style="font-weight: bold;">采购订单</span><div>
                                        <span id="txtPurchaseOrderNumber" style="display: inline-block;">
                                            <input name="purchase_order_no" type="text" maxlength="50" id="purchase_order_no" class="txtBlack8Class" style="width: 210px;" /></span>
                                    </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="content clear">
                <div class="information clear">
                    <p class="informationTitle"><i></i>分配</p>
                    <div>
                        <table border="0" style="width: 740px;">
                            <tbody>
                                <tr>
                                    <td colspan="3">
                                        <div style="margin-left: 0px; padding-bottom: 0px;">
                                            <div id="divAssignment" style="padding-bottom: 0px;">
                                                <div id="ucResourceAssignment_pnlMain" style="width: 705px; padding-bottom: 0px;">
                                                    <table border="0" style="width: 705px;">
                                                        <tbody>
                                                            <tr>
                                                                <td class="Assignment_tablecell_label_left" colspan="3"><span class="lblNormalClass" style="font-weight: bold;">分配队列 </span><span style="color: Red;">*</span><div>
                                                                    <span id="ucResourceAssignment_ddlQueue" class="ResourceAssignment_ddlQueue" style="display: inline-block;">
                                                                        <select name="department_id" id="department_id" class="ResourceAssignment_ddlQueue" style="height: 22px; width: 553px;">
                                                                            <option></option>
                                                                            <% if (depList != null && depList.Count > 0)
                                                                                {
                                                                                    foreach (var dep in depList)
                                                                                    {    %>
                                                                            <option value="<%=dep.id %>"><%=dep.name %></option>
                                                                            <% }
                                                                                } %>
                                                                        </select>
                                                                    </span>
                                                                </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="Assignment_tablecell_label_left" style="width: 48%;"><span class="lblNormalClass" style="font-weight: bold;">主负责人</span><div>
                                                                    <table border="0" style="border-collapse: collapse; border-spacing: 0;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td><span id="" style="display: inline-block;">
                                                                                    <select name="owner_resource_id" id="owner_resource_id" class="" style="height: 22px; width: 209px;">
                                                                                        <option></option>
                                                                                        <% if (resList != null && resList.Count > 0)
                                                                                            {
                                                                                                foreach (var res in resList)
                                                                                                {    %>
                                                                                        <option value="<%=res.id %>"><%=res.name %></option>
                                                                                        <% }
                                                                                            } %>
                                                                                    </select></span></td>
                                                                                <td></td>
                                                                                <td></td>
                                                                                <td style="padding-left: 2px;"></td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                                </td>
                                                                <td class="Assignment_tablecell_contentsLeft" style="width: 50%;"><span class="lblNormalClass" style="font-weight: bold;">角色</span><div>
                                                                    <span id="ucResourceAssignment_ddlRole" style="display: inline-block;">
                                                                        <select name="role_id" id="role_id" class="ResourceAssignment_ddlRole" style="height: 22px; width: 209px;">
                                                                        </select></span>
                                                                </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="Assignment_tablecell_label_left" valign="top" colspan="3" style="width: 100px;"><span class="lblNormalClass" style="font-weight: bold;">其他负责人</span><div>
                                                                    <table id="" class="" cellspacing="0px" cellpadding="0px" border="0" style="width: 85%;">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="Assignment_secondaryResListBoxCell">
                                                                                    <input type="hidden" id="OtherResId" />
                                                                                    <input type="hidden" id="OtherResIdHidden" name="OtherResId" />
                                                                                    <span id="" class="" style="display: inline-block;">
                                                                                        <select size="4" name="" id="otherRes" class="txtBlack8Class" style="height: 84px; width: 553px;">
                                                                                        </select></span></td>
                                                                                <td class="Assignment_secondaryResLinkBtnCell" style="vertical-align: top;">
                                                                                    <a href="javascript:void(0);" class="SecondaryResourceSelecter" onclick="OtherResCallBack()">
                                                                                        <img src="../Images/data-selector.png" style="border-width: 0px;" />
                                                                                    </a>
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
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span id="lblDateStart" class="FieldLabel" style="font-weight: bold;">开始时间</span><span id="lblDateStartReq" class="errorSmallClass" style="font-weight: bold;">*</span>
                                        <div>
                                            <span id="dtStart" style="display: inline-block;">
                                                <input name="startTime" type="text" id="start_time" class="txtBlack8Class" style="width: 140px;" value="" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm' })" /></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div>
                                            <span id="timStart" style="display: inline-block;"></span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span id="lblDateEnd" class="FieldLabel" style="font-weight: bold;">结束时间</span><span id="lblDateEndReq" class="errorSmallClass" style="font-weight: bold;">*</span>
                                        <div>
                                            <span id="dtEnd" style="display: inline-block;">
                                                <input name="endTime" type="text" id="end_time" class="txtBlack8Class" style="width: 140px;" value="" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm' })" />
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <div>
                                            <span id="timEnd" style="display: inline-block;"></span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="content clear">
                <div class="information clear">
                    <p class="informationTitle"><i></i>通知</p>
                    <div>
                        <table border="0" style="width:740px;">
				<tbody><tr>
					<td style="width:200px;"><div style="padding-bottom:0px;">
						<div class="checkbox">
							<span id="chkPrimaryResource" class="FieldLabel"><span class="txtBlack8Class"><input id="ckPriRes" type="checkbox" name="ckPriRes" style="vertical-align:middle;margin-top:-16px;" /></span></span><span class="txtBlack8Class" style="font-weight:normal;margin-left: 40px;">主负责人</span>
						</div><div>
							<span id="chkSecondaryResource" class="FieldLabel"><span class="txtBlack8Class"><input id="ckOther" type="checkbox" name="ckOther" style="vertical-align:middle;" /></span></span><span class="txtBlack8Class" style="font-weight:normal;margin-left: 8px;">其他负责人</span>
						</div>
					</div></td><td style="width:480px;"><div style="padding-bottom:0px;">
						<div class="checkbox">
							<span id="chk_ccmanager"><span class="txtBlack8Class"><input id="ckAccMan" type="checkbox" name="ckAccMan" style="vertical-align:middle;" /></span></span><span class="txtBlack8Class" style="font-weight:normal;margin-left: 40px;">客户经理</span>
						</div><div>
							<span id="chkContact"><span class="txtBlack8Class"><input id="ckCon" type="checkbox" name="ckCon" style="vertical-align:middle;" /></span></span><span class="txtBlack8Class" style="font-weight:normal;margin-left: 8px;">联系人</span>
						</div>
					</div></td>
				</tr><tr valign="middle">
					<td class="FieldLabel" valign="middle" colspan="2" style="text-align:left;"><span class="FieldLabel" style="font-weight:bold;">通知模板</span><div>
						<span id="notificationTemplateID" style="display:inline-block;">
                            <select name="template_id" id="template_id" class="txtBlack8Class" style="width:554px;">
						</select></span>
					</div></td>
				</tr>
			</tbody></table>
                    </div>
                </div>
            </div>
             <div class="content clear">
                <div class="information clear">
                    <p class="informationTitle"><i></i>用户自定义字段</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="border: 0px;">
                            <%if (tickUdfList != null && tickUdfList.Count > 0)
                                {
                                    foreach (var udf in tickUdfList)
                                    {

                                        if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                        {%>
                            <tr>
                                <td style="border:0px;">
                                    <div class="FieldLabels">
                                        <span class="filed"><%=udf.name %></span>
                                        <br />
                                        <input type="text" name="<%=udf.id %>" class="sl_cdt" value="" />
                                    </div>
                                </td>
                            </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                                {
                            %>
                            <tr>
                                <td style="border:0px;">
                                    <div class="FieldLabels">
                                        <span class="filed"><%=udf.name %></span>
                                        <br />
                                        <textarea name="<%=udf.id %>" rows="2" cols="20"></textarea>
                                    </div>
                                </td>
                            </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)
                                {
                            %>
                            <tr>
                                <td style="border:0px;">
                                    <div class="FieldLabels">
                                        <span class="filed"><%=udf.name %></span>
                                        <br />
                                        <input type="text" onclick="WdatePicker()" name="<%=udf.id %>" class="sl_cdt" value="" />
                                    </div>
                                </td>
                            </tr>
                            <% }
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)
                                {
                            %>
                            <tr>
                                <td style="border:0px;">
                                    <div class="FieldLabels">
                                        <span class="filed"><%=udf.name %></span>
                                        <br />
                                        <input type="text" name="<%=udf.id %>" class="sl_cdt" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="" />
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)
                                {%>
                            <tr>
                                <td style="border:0px;">
                                    <div class="FieldLabels">
                                        <span class="filed"><%=udf.name %></span>
                                        <br />
                                        <select>
                                            <%if (udf.required != 1)
                                            { %>
                                            <option></option>
                                            <%} %>
                                            <% if (udf.value_list != null && udf.value_list.Count > 0)
                                                {
                                                    var thisValue = "";
                                                    if (ticketUdfValueList!=null&&ticketUdfValueList.Count>0&&ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                                    {
                                                        thisValue = ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString();
                                                    }
                                                   
                                                foreach (var thisValeList in udf.value_list)
                                                {%>
                                            <option value="<%=thisValeList.val %>"><%=thisValeList.show %></option>
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
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/index.js"></script>
<script>

    function SubmitCheck() {
        var account_id = $("#accountNameHidden").val();
        if (account_id == "") {
            LayerMsg("请通过查找带回选择客户！");
            return false;
        }
        var title = $("#title").val();
        if (title == "") {
            LayerMsg("请填写标题！");
            return false;
        }
        var priority_type_id = $("#priority_type_id").val();
        if (priority_type_id == "") {
            LayerMsg("请选择优先级！");
            return false;
        }
        var issue_type_id = $("#issue_type_id").val();
        if (issue_type_id == "") {
            LayerMsg("请选择问题类型！");
            return false;
        }
        var sub_issue_type_id = $("#sub_issue_type_id").val();
        if (sub_issue_type_id == "") {
            LayerMsg("请选择子问题类型！");
            return false;
        }
        var cost_code_id = $("#cost_code_id").val();
        if (cost_code_id == "") {
            LayerMsg("请通过查找带回选择工作类型！");
            return false;
        }
        var start_time = $("#start_time").val();
        if (start_time == "") {
            LayerMsg("请选择开始时间！");
            return false;
        }
        var end_time = $("#end_time").val();
        if (end_time == "") {
            LayerMsg("请选择结束时间！");
            return false;
        }
        if (compareTime(start_time, end_time)) {
            LayerMsg("开始时间不能大于结束时间！");
            return false;
        }
        var starArr = start_time.split(' ');
        var endArr = end_time.split(' ');
        var star = starArr[1].split(":");
        var end = endArr[1].split(":");
        if (Number(star[0] + star[1]) > Number(end[0] + end[1])) {
            LayerMsg("开始时间不能大于结束时间！");
            return false;
        }
        var department_id = $("#department_id").val();
        var owner_resource_id = $("#owner_resource_id").val();
        var role_id = $("#role_id").val();
        if (owner_resource_id != "" && role_id=="") {
            LayerMsg("请选择负责人角色！");
            return false;
        }
        if (owner_resource_id == "" && role_id != "") {
            LayerMsg("请选择主负责人！");
            return false;
        }
        if (department_id == "" && owner_resource_id == "") {
            LayerMsg("请选择队列或者主负责人！");
            return false;
        }

        return true;
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
    $("#owner_resource_id").change(function () {
        GetRoleByRes();
        CheckOthers();
    })
    // 检查其他负责人是否已经包含主负责人，如果有，清除
    function CheckOthers() {
        var owner_resource_id = $("#owner_resource_id").val();
        var OtherResId = $("#OtherResIdHidden").val();
        if (owner_resource_id != "" && OtherResId != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ResourceAjax.ashx?act=CheckResInResDepIds&resDepIds=" + OtherResId + "&priRes=" + owner_resource_id +"&isDelete=1",
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.isRepeat) {

                        }
                        $("#OtherResIdHidden").val(data.newDepResIds);
                        GetResDepByIds();
                    }
                },
            });
        }
    }

    // 根据 问题类型，返回相应的子问题类型
    function GetRoleByRes() {
        var roleHtml = "<option value=''> </option>";
        var resId = $("#owner_resource_id").val();
        if (resId != "" && resId != null && resId != undefined) {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/RoleAjax.ashx?act=GetRoleList&source_id=" + resId +"&showNull=1",
                //dataType: "json",
                success: function (data) {
                    if (data != "") {
                        roleHtml += data;
                    }
                },
            });
        }
        $("#role_id").html(roleHtml);
    }
    function OtherResCallBack() {
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&muilt=1&field=OtherResId&callBack=GetOtherResData";
        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 获取到其他负责人的相应信息
    function GetOtherResData() {
        // 检查是否有重复员工
        // 检查带回员工是否与主负责人有冲突
        var OtherResId = $("#OtherResIdHidden").val();
        if (OtherResId != "") {
            //var owner_resource_id = $("#owner_resource_idHidden").val();
            //$.ajax({
            //    type: "GET",
            //    async: false,
            //    url: "../Tools/ResourceAjax.ashx?act=CheckResInResDepIds&resDepIds=" + OtherResId + "&resDepId=" + owner_resource_id,
            //    dataType: "json",
            //    success: function (data) {
            //        if (data != "") {
            //            $("#OtherResIdHidden").val(data.newDepResIds);
            //            if (data.isRepeat) {
            //                LayerConfirm("选择员工已经是主负责人，是否将其置为其他负责人", "是", "否", function () { $("#owner_resource_idHidden").val(""); $("#owner_resource_id").val(""); }, function () { GetResByCallBack(); });
            //            }

            //        }
            //    },
            //});
            var owner_resource_id = $("#owner_resource_id").val();
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ResourceAjax.ashx?act=CheckResInResDepIds&resDepIds=" + OtherResId + "&isDelete=1" + "&priRes=" + owner_resource_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#OtherResIdHidden").val(data.newDepResIds);
                    }
                },
            });
            GetResDepByIds();
        }
    }
    function GetResDepByIds() {
        var resDepIds = $("#OtherResIdHidden").val();
        if (resDepIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=GetResDepList&resDepIds=" + resDepIds,
                async: false,
                //dataType:"json",
                success: function (data) {
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

    function CallBackAccount() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=accountName&callBack=GetDataByAccount", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }

    function GetDataByAccount() {
        var accountName = $("#accountNameHidden").val();
        if (accountName != "") {
            $("#contact_id").prop("disabled", false);
            GetContactList();
        } else {
            $("#contact_id").prop("disabled", true);
        }
    }

  
    // 显示客户的未关闭工单的列表
    function ShowAccNoTicket() {
        var account_idHidden = $("#accountNameHidden").val();
        if (account_idHidden != "") {
            window.open("../ServiceDesk/AccountTicketList.aspx?account_id=" + account_idHidden, "_blank", 'left=200,top=200,width=960,height=800', false);
        }
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
                        $("#accountName").val(data);
                        $("#accountNameHidden").val(id);
                    }
                },
            });
        }
    }

    function GetContactList() {
        var account_id = $("#accountNameHidden").val();
        $("#contact_id").html("");
        if (account_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=contact&account_id=" + account_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        $("#contact_id").html(data);
                    }
                },
            });
        }

    }

    // 新增联系人
    function AddContact() {
        var url = "../Contact/AddContact?callback=GetContact";
        var account_idHidden = $("#accountNameHidden").val();
        if (account_idHidden != "" && account_idHidden != null && account_idHidden != undefined) {
            url += "&account_id=" + account_idHidden;
            window.open(url, "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>", 'left=200,top=200,width=600,height=800', false);
        } else {
            LayerMsg("请先选择客户！");
        }
       
    }

    function GetContact(id) {
        if (id != "" && id != null && id != undefined) {
            GetContactList();
            $("#contact_id").val(id);
        }
    }

    function ContractCallBack() {
        var account_idHidden = $("#accountNameHidden").val();
        if (account_idHidden != "" && account_idHidden != null && account_idHidden != undefined) {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACTMANAGE_CALLBACK %>&con626=1&con627=" + account_idHidden + "&field=contractId&callBack=GetDataByContract", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>", 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择客户");
        }
    }
    function GetDataByContract() {

    }



    $("#fromTmplId").change(function () {
        var thisValue = $(this).val();
        if (thisValue != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/FormTempAjax.ashx?act=GetTempObj&id=" + thisValue,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#form1").populateForm(data);
                        // 客户，联系人。子问题类型，合同，主负责人角色，其他负责人，开始，结束时间
                        if (data.account_id != "") {
                            GetAccount(data.account_id);
                            GetContactList();
                            $("#contact_id").prop("disabled", false);
                            if (data.contact_id != "") {
                                $("#contact_id").val(data.contact_id);
                            }
                            else {
                                $("#contact_id").val("");
                            }
                        }
                        else {
                            $("#accountName").val("");
                            $("#accountNameHidden").val("");
                            GetContactList();
                            $("#contact_id").prop("disabled", true);
                        }
                        $("#issue_type_id").trigger("change");
                        if (data.sub_issue_type_id != "") {
                            $("#sub_issue_type_id").val(data.sub_issue_type_id);
                        }
                        GetContractById(data.contract_id);
                        GetRoleByRes();
                        if (data.role_id != "") {
                            $("#role_id").val(data.role_id);
                        }
                        $("#OtherResIdHidden").val(data.second_resource_ids);
                        GetOtherResData();
                        var dateNow = '<%=DateTime.Now.ToString("yyyy-MM-dd") %>';
                        if (data.estimated_begin_time != "") {
                            $("#start_time").val(dateNow + " " + data.estimated_begin_time);
                        }
                        if (data.estimated_end_time != "") {
                            $("#end_time").val(dateNow + " " + data.estimated_end_time);
                        }
                    }
                },
            });
        }
    })

    function GetContractById(id) {
        if (id != "" && id != undefined && id != null) {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContractAjax.ashx?act=property&contract_id=" + id +"&property=name",
                success: function (data) {
                    if (data != "") {
                        $("#contractId").val(data);
                        $("#contractIdHidden").val(id);
                    }
                    else {
                        $("#contractId").val("");
                        $("#contractIdHidden").val("");
                    }
                },
            });
        }
        else {
            $("#contractId").val("");
            $("#contractIdHidden").val("");
        }
    }

</script>
