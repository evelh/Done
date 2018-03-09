<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketModify.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.TicketModify" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/multipleList.css" />
    <title>转发/修改</title>
    <style>
        .red {
            color: red;
        }

        td {
            text-align: left;
        }

        .content input {
            margin-left: 0px;
            width: 215px;
        }

        .content textarea {
            margin-left: 0px;
        }

        .content select {
            margin-left: 0px;
        }

        .content input[type=checkbox] {
            margin-left: 0px;
            margin-top: 0px;
        }

        .information .FieldLabels {
            padding-left: 42px;
        }

        .AddItemToTicketTopSection {
            color: #4F4F4F;
            padding: 10px;
            background-repeat: no-repeat;
            background-position: left;
            padding-left: 40px;
            border: none;
            background-image: url(../Images/ico_ticket_modify.png);
        }
        span.CkTitle {
            margin-top: 0px;
            margin-left:12px;
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

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="TitleBar">
                <div class="header">
                    <span class="text1">转发/修改 工单</span>
                </div>
            </div>
            <div class="header-title">
                <ul id="btn">
                    <li id="saveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <input type="submit" value="保存并关闭" style="width: 72px;" />
                    </li>
                    <li id="Close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <input type="button" value="取消" style="width: 30px;" />
                    </li>
                </ul>
            </div>
            <div class="DivSection AddItemToTicketTopSection AddNoteTitleImage" style="margin-left: 10px; float: left; border: 0px solid #d3d3d3; padding-left: 34px;">
                <table cellspacing="0" cellpadding="0" border="0" style="height: 44px; border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td class="Popup_TitleCell" style="text-align: left;">
                                <span class="Popup_Title" style="width: 750px; margin-left: 6px;font-size: 16px;font-weight: Bold;">
                                    <%if (isSingle)
                                        { %>
                                    <%=thisTicket.no + " - " + thisTicket.title %>
                                    <%}
                                    else
                                    { %>
                                    <%="多重选择" %>
                                    <%} %>
                                </span></td>
                        </tr>
                        <tr>
                            <td class="Popup_SubtitleCell" style="text-align: left;">
                                <span title="九月" class="Popup_Subtitle" style="width: 765px; margin-left: 6px;">
                                    <%if (isSingle)
                                        { %>
                                    <%=thisAccount==null?"":thisAccount.name %>
                                    <%}
                                    else
                                    { %>
                                    <%="多重选择" %>
                                    <%} %>
                                </span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="nav-title" style="clear: both;">
                <ul class="clear">
                    <li class="boders" id="general">常规</li>
                    <li id="notify">通知</li>
                </ul>
            </div>
            <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 200px;">
                <div class="content clear" id="generalDiv">
                    <div class="information clear">
                        <%--<p class="informationTitle"><i></i>常规信息</p>--%>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">标题<span class="red">*</span></span>
                                        <br />
                                        <input type="text" name="title" id="title" value="<%=isManyTitle?"多个值-保持不变":thisTicket.title %>" style="width: 460px;" <%=isManyTitle?"readonly=''":"" %> />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">描述</span>
                                        <br />
                                        <textarea id="description" name="description" style="width: 460px; margin-bottom: 8px; resize: vertical; padding: 6px;" <%=isManydesc?"readonly=''":"" %>><%=isManydesc?"多个值-保持不变":thisTicket.description %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="information clear">
                        <p class="informationTitle"><i></i>指派给</p>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <div class="FieldLabels">
                                        <span>队列</span>
                                        <br />
                                        <select id="department_id" name="department_id" style="width: 215px;">
                                            <option></option>
                                            <% if (depList != null && depList.Count > 0)
                                                {
                                                    if (isManyDep)
                                                    {%>
                                            <option value="0" selected="selected">多个值-保持不变</option>
                                            <%}
                                                foreach (var dep in depList)
                                                {%>
                                            <option value="<%=dep.id %>" <%=!isManyDep&&thisTicket.department_id==dep.id?"selected='selected'":"" %>><%=dep.name %></option>
                                            <% }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">主负责人</span>
                                        <br />
                                        <div style="display: inline-flex;">
                                            <input type="text" id="pri_res" value="<%=isManyPri?"多个值-保持不变":(proResDep!=null&&thisPriRes!=null&&thisRole!=null?thisPriRes.name+$"({thisRole.name})":"" ) %>" />
                                            <a onclick="ChoosePriRes()" style="display: flex; float: left;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px; width: 18px; height: 18px; margin-left: 5px;"></span></a>
                                            <a onclick="DownPriRes()" style="display: flex; float: left;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -47px -16px; width: 18px; height: 16px; margin-left: 5px; margin-top: 3px;"></span></a>
                                        </div>
                                        <input type="hidden" id="pri_resHidden" name="pri_res" value="<%=isManyPri?"0":(proResDep!=null&&thisPriRes!=null?proResDep.id.ToString():"" ) %>" />
                                        <br />
                                        <div style="margin-bottom: 22px;"></div>
                                        <input type="checkbox" id="ckAddPriWork" name="ckAddPriWork" />
                                        <span>加入主负责人工作列表</span>
                                        <br />
                                        <input type="checkbox" id="ckDelPriWork" name="ckAddPriWork" />
                                        <span>从原主负责人工作列表中删除</span>
                                        <% if (isSingle)
                                            { %>
                                        <br />
                                        <span class="filed">其他负责人</span>
                                        <br />
                                        <select id="otherPriRes" name="otherPriRes" multiple="multiple" style="height: 47px;">
                                        </select>
                                        <a onclick="OtherResCallBack()" style="display: flex; float: left;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px; width: 18px; height: 18px; margin-left: 5px;"></span></a>
                                        <input type="hidden" id="OtherResId" />
                                        <input type="hidden" id="OtherResIdHidden" name="OtherResId" value="<%=ticketResIds %>" />
                                        <%} %>
                                    </div>
                                </td>
                            </tr>

                        </table>
                    </div>
                    <div class="information clear">
                        <p class="informationTitle"><i></i>编辑工单详情</p>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">工单种类<span class="red">*</span></span>
                                        <br />
                                        <select id="ticket_cate" name="ticket_cate" style="width: 215px;">
                                            <% if (ticketCateList != null && ticketCateList.Count > 0)
                                                {
                                                    if (isManyTicketCate)
                                                    {%>
                                            <option value="0" selected="selected">多个值-保持不变</option>
                                            <%}
                                                foreach (var ticketCate in ticketCateList)
                                                {%>
                                            <option value="<%=ticketCate.id %>" <%=!isManyTicketCate&&thisTicket.cate_id==ticketCate.id?"selected='selected'":"" %>><%=ticketCate.name %></option>
                                            <% }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">预估时间</span>
                                        <br />
                                        <input type="text" id="est_hours" name="est_hours" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=isManyEstHour?"多个值-保持不变":thisTicket.estimated_hours.ToString("#0.00") %>" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">工单到期时间<span class="red">*</span></span>
                                        <br />
                                        <input type="text" id="due_time" name="due_time" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" value="<%=isManyDueTime?"多个值-保持不变":(thisTicket.estimated_end_time==null?"":EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.estimated_end_time).ToString("yyyy-MM-dd HH:mm:ss")) %>" />
                                    </div>
                                </td>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">合同名称</span>
                                        <br />
                                        <div style="display: inline-flex;">
                                            <input type="text" id="contractName" name="" value="<%=isManyContract?"多个值-保持不变":(thisContract==null?"多个值-保持不变":thisContract.name) %>" /><a onclick="CallBackContract()" style="display: flex; float: left;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px; width: 18px; height: 18px; margin-left: 5px;"></span></a>
                                        </div>
                                        <input type="hidden" id="contractNameHidden" name="contractName" value="<%=isManyContract?"0":(thisContract==null?"0":thisContract.id.ToString()) %>" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">状态<span class="red">*</span></span>
                                        <br />
                                        <select id="statusId" name="statusId" style="width: 215px;">
                                            <option></option>
                                            <% if (ticStaList != null && ticStaList.Count > 0)
                                                {
                                                    if (isManyStatus)
                                                    {%>
                                            <option value="0" selected="selected">多个值-保持不变</option>
                                            <%}
                                                foreach (var ticSta in ticStaList)
                                                {%>
                                            <option value="<%=ticSta.id %>" <%=!isManyStatus&&thisTicket.status_id==ticSta.id?"selected='selected'":"" %>><%=ticSta.name %></option>
                                            <% }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">服务/服务包</span>
                                        <br />
                                        <select id="serviceId" name="serviceId" style="width: 215px;"></select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">优先级<span class="red">*</span></span>
                                        <br />
                                        <select id="priorityId" name="priorityId" style="width: 215px;">
                                            <option></option>
                                            <% if (priorityList != null && priorityList.Count > 0)
                                                {
                                                    if (isManyPrio)
                                                    {%>
                                            <option value="0" selected="selected">多个值-保持不变</option>
                                            <%}
                                                foreach (var priority in priorityList)
                                                {%>
                                            <option value="<%=priority.id %>" <%=!isManyPrio&&thisTicket.priority_type_id==priority.id?"selected='selected'":"" %>><%=priority.name %></option>
                                            <% }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">工作类型<span class="red">*</span></span>
                                        <br />
                                        <div style="display: inline-flex;">
                                            <input type="text" id="workTypeId" name="" value="<%=isManyWork?"多个值-保持不变":(thisWorkType==null?"多个值-保持不变":thisWorkType.name) %>" /><a onclick="WorkTypeCallBack()" style="display: flex; float: left;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px; width: 18px; height: 18px; margin-left: 5px;"></span></a>
                                        </div>
                                        <input type="hidden" id="workTypeIdHidden" name="workTypeId" value="<%=isManyWork?"0":(thisWorkType==null?"0":thisWorkType.id.ToString()) %>" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">问题类型<span class="red">*</span></span>
                                        <br />
                                        <select id="IssueType" name="IssueType" style="width: 215px;">
                                            <option></option>
                                            <% if (issueTypeList != null && issueTypeList.Count > 0)
                                                {
                                                    if (isManyissType)
                                                    {%>
                                            <option value="0" selected="selected">多个值-保持不变</option>
                                            <%}
                                                foreach (var issueType in issueTypeList)
                                                {%>
                                            <option value="<%=issueType.id %>" <%=!isManyissType&&thisTicket.issue_type_id==issueType.id?"selected='selected'":"" %>><%=issueType.name %></option>
                                            <% }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed">子问题类型<span class="red">*</span></span>
                                        <br />
                                        <select id="SubIssueType" name="SubIssueType" style="width: 215px;"></select>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="information clear">
                        <p class="informationTitle"><i></i>用户自定义字段</p>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <%if (udfTaskPara != null && udfTaskPara.Count > 0)
                                {
                                    foreach (var udf in udfTaskPara)
                                    {

                                        if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                        {%>
                            <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <span class="filed"><%=udf.name %></span>
                                        <br />
                                        <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=udfValue.FirstOrDefault(_ => _.id == udf.id)==null?"": udfValue.FirstOrDefault(_ => _.id == udf.id).value.ToString() %>" />
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
                                        <textarea name="<%=udf.id %>" rows="2" cols="20"><%=udfValue.FirstOrDefault(_ => _.id == udf.id).value  %></textarea>
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
                                            if (udfValue.FirstOrDefault(_ => _.id == udf.id) != null)
                                            {
                                                object value = udfValue.FirstOrDefault(_ => _.id == udf.id).value;
                                                if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                                {
                                                    if (value.ToString() != "多个值-保持不变")
                                                    {
                                                        val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                                    }
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
                                            if (udfValue.FirstOrDefault(_ => _.id == udf.id) != null)
                                            {
                                                object value = udfValue.FirstOrDefault(_ => _.id == udf.id).value;
                                                if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                                {
                                                    if (value.ToString() != "多个值-保持不变")
                                                    {
                                                        val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                                    }
                                                }
                                            }
                                        %>
                                        <input type="text" name="<%=udf.id %>" class="sl_cdt" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=udfValue.FirstOrDefault(_ => _.id == udf.id).value %>" />
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
                                        <select>
                                            <%if (udf.required != 1)
                                            { %>
                                            <option></option>
                                            <%} %>
                                            <% if (udf.value_list != null && udf.value_list.Count > 0)
                                                {
                                                    var thisValue = "";
                                                    if (udfValue.FirstOrDefault(_ => _.id == udf.id) != null)
                                                    {
                                                        thisValue = udfValue.FirstOrDefault(_ => _.id == udf.id).value.ToString();
                                                    }
                                                    if (thisValue == "多个值保持不变")
                                                    {%>
                                            <option value="0">多个值保持不变</option>
                                            <%}
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
                <div class="content clear" id="notifyDiv" style="display:none;">
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

                                                        <table class="searchareaborder" width="738px" cellspacing="0" cellpadding="0" border="0" style="width: 500px;">
                                                            <tbody>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <table cellspacing="0" cellpadding="0" border="0" style="margin-left: 0px; width: 75%;">
                                                                            <tbody>
                                                                                <tr>

                                                                                    <td width="369px" class="fieldLabels">
                                                                                        <div class="CheckBoxList">
                                                                                             <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="CCMe" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">抄送给我<%=thisUser != null?"("+thisUser.name+")":"" %></span>
                                                                                            </div>
                                                                                             <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="Cksys" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">使用<%=sys_email!=null?sys_email.remark:"" %> 发送</span>
                                                                                            </div>
                                                                                            
                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="CkPriRes" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">主负责人</span>
                                                                                            </div>
                                                                                        </div>
                                                                                    </td>

                                                                                    <td class="fieldLabels" width="357px" style="padding-left: 10px">
                                                                                        <div class="CheckBoxList">

                                                                                            <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="CKcreate" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">条目创建人</span>
                                                                                            </div>
                                                                                           <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                <asp:CheckBox ID="CKaccMan" runat="server" />
                                                                                                &nbsp;<span style="cursor: default;" class="CkTitle">客户经理</span>
                                                                                            </div>
                                                                                            
                                                                                        </div>
                                                                                    </td>

                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>

                                                                    <td class="FieldLabels" width="369px" style="padding-left: 30px;"><span style="margin-left: -300px;">联系人<%if (isSingle) { %><a onclick="loadCon()">(加载联系人)</a><%} %></span>
                                                                        <div style="margin-left: -18px;">
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
                                                                    <td class="FieldLabels"><span>员工</span>
                                                                        <span class="FieldLevelInstructions">(<a style="color: #376597; cursor: pointer;" onclick="LoadRes()">加载员工</a>)</span>
                                                                        <div id="reshtml" style="width: 350px; height: 170px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                                                                        </div>
                                                                    </td>

                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" colspan="2" style="padding-top: 9px;"><span class="mytitle">其他邮件地址</span>
                                                                        <div>
                                                                            <input type="text" style="width: 726px;" name="otherEmail" id="otherEmail" />
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" colspan="2" style="padding-top: 9px;"><span class="mytitle" >通知模板</span>
                                                                        <div>
                                                                            <asp:DropDownList ID="notify_id" runat="server" Width="727px"></asp:DropDownList>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" colspan="2" style="padding-top: 9px;"><span class="mytitle">主题</span>
                                                                        <div>
                                                                            <input type="text" id="subjects" name="subjects" value="" style="width: 726px" />
                                                                            <input type="hidden" name="contact_ids" id="contact_ids" />
                                                                            <input type="hidden" name="resIds" id="resIds" />
                                                                            <input type="hidden" name="workGropIds" id="workGropIds" />
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabels" width="369px" style="padding-top: 9px;"><span class="mytitle">附加信息</span></td>

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
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $(".informationTitle i").click(function () {
        $(this).toggleClass("jia");
        $(this).parent().next().toggle();
    })
    $(function () {
        $("#IssueType").trigger("change");
        GetServiceByContract();
        <%if (isManySerivce)
    { %>
        var isHasTas = $("#serviceId option[value='0']").val();
        if (isHasTas == undefined) {
            $("#serviceId").append("<option value='0'>多个值-保持不变</option>");
        }
        $("#serviceId").val("0");
        <%}
    else
    {%>
        <%if (thisTicket.service_id != null)
    { %>
        $("#serviceId").val('<%=thisTicket.service_id.ToString() %>');
        <%}%>

        <%}%>

        <%if (isManySubIssType)
    { %>
        var isHasTas = $("#SubIssueType option[value='0']").val();
        if (isHasTas == undefined) {
            $("#SubIssueType").append("<option value='0'>多个值-保持不变</option>");
        }
        $("#SubIssueType").val("0");
        <%}
    else
    { %>
        $("#SubIssueType").val('<%=thisTicket.sub_issue_type_id.ToString() %>');
        <%}%>

        <%if (isSingle && !string.IsNullOrEmpty(ticketResIds))
    { %>
        GetResDepByIds();
        <% }%>

    })
    $("#IssueType").change(function () {
        GetSubIssueType();
    })

    // 根据 问题类型，返回相应的子问题类型
    function GetSubIssueType() {
        var issue_type_id = $("#IssueType").val();
        var subIssTypeHtml = "";
        if (issue_type_id == "0") {
            subIssTypeHtml = "<option value='0'>多个值-保持不变</option>";
        }
        else {
            subIssTypeHtml = "<option value=''> </option>";
        }
        if (issue_type_id != "" && issue_type_id != null && issue_type_id != undefined && issue_type_id != "0") {
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
        $("#SubIssueType").html(subIssTypeHtml);
    }

    function CallBackContract() {
        <%if (isManyContract)
    { %>
        LayerMsg("合同不能被修改，因为选择的工单有不同的合同。");
        <%}
    else if (isManyAccount)
    {%>
        LayerMsg("合同不能被修改，因为选择的工单属于不同的客户。");
        <%}
    else
    {%>
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACTMANAGE_CALLBACK %>&con626=1&con627=<%=thisTicket.account_id %>&field=contractName&callBack=GetDataByContract", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>", 'left=200,top=200,width=600,height=800', false);
        <%}%>
    }

    function GetDataByContract() {
        GetServiceByContract();
    }

    function GetServiceByContract() {
        var serviceHtml = "";
        var contractHidden = $("#contractNameHidden").val();
        if (contractHidden == "0") {
            serviceHtml = "<option value='0'>多个值-保持不变</option>";
        }
        else {
            serviceHtml = "<option value=''> </option>";
        }
        if (contractHidden != "" && contractHidden != null && contractHidden != undefined && contractHidden != "0") {
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

        $("#serviceId").html(serviceHtml);

    }

    function WorkTypeCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE %>&field=workTypeId&callBack=GetDataByCostCode", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByCostCode() {

    }
    $("#saveClose").click(function () {
        var title = $("#title").val();
        if (title == "" || title == undefined || title == null) {
            LayerMsg("请填写工单标题！");
            return false;
        }

        var department_id = $("#department_id").val();
        var priRes = $("#pri_resHidden").val();
        if (department_id == "" && priRes == "") {
            LayerMsg("队列和主负责人，请选择其中一个进行填写！");
            return false;
        }
        var ticket_cate = $("#ticket_cate").val();
        if (ticket_cate == "") {
            LayerMsg("请选择工单种类！");
            return false
        }
        var due_time = $("#due_time").val();
        if (due_time == "") {
            LayerMsg("请填写工单到期时间！");
            return false
        }
        var statusId = $("#statusId").val();
        if (statusId == "") {
            LayerMsg("请选择状态！");
            return false
        }
        var priorityId = $("#priorityId").val();
        if (priorityId == "") {
            LayerMsg("请选择优先级！");
            return false
        }
        var workTypeIdHidden = $("#workTypeIdHidden").val();
        if (workTypeIdHidden == "") {
            LayerMsg("请选择工作类型！");
            return false
        }
        var SubIssueType = $("#SubIssueType").val();
        if (SubIssueType == "") {
            LayerMsg("请选择子问题类型！");
            return false
        }
        GetResID();
        GetContratID();
        return true;
    })

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
            var owner_resource_id = $("#pri_resHidden").val();
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ResourceAjax.ashx?act=CheckResInResDepIds&resDepIds=" + OtherResId + "&resDepId=" + owner_resource_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#OtherResIdHidden").val(data.newDepResIds);
                        if (data.isRepeat) {
                            LayerConfirm("选择员工已经是主负责人，是否将其置为其他负责人", "是", "否", function () { $("#pri_res").val(""); $("#pri_resHidden").val(""); }, function () { GetResByCallBack(); });
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
                    if (data != "") {
                        $("#otherPriRes").html(data);
                        $("#otherPriRes option").dblclick(function () {
                            RemoveResDep(this);
                        })
                    }
                }
            })
        } else {
            $("#otherPriRes").html("");
        }

    }
    function RemoveResDep(val) {
        $(val).remove();
        var ids = "";
        $("#otherPriRes option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#OtherResIdHidden").val(ids);
    }
    // 主负责人查找带回
    function ChoosePriRes() {
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&field=pri_res&callBack=GetResByCallBack";
        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 主负责人查找带回事件 - 当带回的主负责人在其他负责人中出现的时候-从其他负责人中删除，然后带回主负责人
    function GetResByCallBack() {
        var owner_resource_id = $("#pri_resHidden").val();
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
            $("#pri_res").val("");
        }
    }

    function DownPriRes() {
        var owner_resource_id = $("#pri_resHidden").val();
        if (owner_resource_id != "") {
            $("#pri_res").val("");
            $("#pri_resHidden").val("");
            var OtherResId = $("#OtherResIdHidden").val();
            if (OtherResId != "") {
                OtherResId = OtherResId + "," + owner_resource_id;
            }
            else {
                OtherResId = owner_resource_id;
            }
            $("#OtherResIdHidden").val(OtherResId);
            GetResDepByIds();
        }
    }

    $("#general").click(function () {
        $(".content").hide();
        $("#generalDiv").show();
        $(".clear li").removeClass("boders");
        $("#general").addClass("boders");

    })

    $("#notify").click(function () {
        $(".content").hide();
        $("#notifyDiv").show();
        $(".clear li").removeClass("boders");
        $("#notify").addClass("boders");
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

    function  loadCon() {
        
        <%if (isSingle && thisAccount != null){ %>
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ContactAjax.ashx?act=GetContacts&account_id=<%=thisAccount.id %>",
            success: function (data) {
                if (data != "") {
                    $("#conhtml").html(data);
                }
            },
        });
        <%}%>
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
    $("#Close").click(function () {
        window.close();
    })
</script>
