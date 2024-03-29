﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GeneralManage.aspx.cs" Inherits="EMT.DoneNOW.Web.General.GeneralManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title><%=thisTable!=null?thisTable.name:"" %></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1"><%=thisTable!=null?thisTable.name:"" %></span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />

                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    取消
                </li>
            </ul>
        </div>
        <div class="DivSection" style="border: none; padding-left: 10px;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                     <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PRODUCT_CATE) {%>  
                    
                    <tr>
                        <td width="30%" class="FieldLabels"><span>父产品种类名称</span><span style="color: red;"></span>
                            <div>
                                <input type="text" id="parentId" style="width: 220px;" maxlength="11" value="<%=parentGeneral?.name %>" />
                                <img src="../Images/data-selector.png" style="width:15px;height:15px;" onclick="GetParentCate()"/>
                                <input type="hidden" id="parentIdHidden" name="parent_id" value="<%=parentGeneral?.id %>"/>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    <tr id="NameTr">
                        <td width="30%" class="FieldLabels"><span id="SpanName">名称</span><span style="color: red;">*</span>
                            <div>
                                <input type="text" id="name" name="name" style="width: 220px;" maxlength="11" value="<%=thisGeneral!=null?thisGeneral.name:"" %>" />
                            </div>
                        </td>
                    </tr>
                    <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.TASK_LIBRARY_CATE || tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.ACTION_TYPE||tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PROJECT_LINE_OF_BUSINESS||tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PRODUCT_CATE||tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PAYMENT_TERM||tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PAYMENT_TYPE||tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PAYMENT_SHIP_TYPE)
                        { %>
                    <tr>
                        <td width="30%" class="FieldLabels">说明<span style="color: red; display: none;" id="RemarkDiv">*</span>
                            <div>
                                <textarea id="remark" name="remark" style="width:220px;"><%=thisGeneral!=null?thisGeneral.remark:"" %></textarea>
                            </div>
                        </td>
                    </tr>
                    <%} %>
                    <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.SYS_TICKET_RESOLUTION_METRICS)
                        { %>

                    <tr>
                        <td width="30%" class="FieldLabels">目标 
                        <div>
                            <input type="text" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" id="ext1" name="ext1" style="width: 220px;" maxlength="5" value="<%=thisGeneral?.ext1 %>" />
                        </div>
                        </td>
                    </tr>
                    <%} %>

                    <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.TASK_SOURCE_TYPES || tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.TASK_LIBRARY_CATE || tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.ACTION_TYPE||tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PROJECT_LINE_OF_BUSINESS||tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.SYS_TICKET_RESOLUTION_METRICS)
                        { %>
                    <tr>
                        <td width="30%" class="FieldLabels">排序值 
                        <div>
                            <input type="text" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" id="sort_order" name="sort_order" style="width: 220px;" maxlength="5" value="<%=thisGeneral != null && thisGeneral.sort_order != null ? ((decimal)thisGeneral.sort_order).ToString("#0") : "" %>" />
                        </div>
                        </td>
                    </tr>
                    <%} %>
                    <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.TICKET_STATUS)
                        { %>
                    <tr>
                        <td width="30%" class="FieldLabels">SLA事件
                        <div>
                            <select name="ext1" id="ext1" style="width: 232px;">
                                <option></option>
                                <%if (tempList != null && tempList.Count > 0)
                                    {
                                        foreach (var temp in tempList)
                                        {%>
                                <option value="<%=temp.id %>" <%if (thisGeneral != null && thisGeneral.ext1 == temp.id.ToString())
                                    {%> selected="selected" <%} %>><%=temp.name %></option>
                                <% }
                                    } %>
                            </select>
                        </div>
                        </td>
                    </tr>
                    <%} %>
                    <%if (tableId != (int)EMT.DoneNOW.DTO.GeneralTableEnum.TASK_LIBRARY_CATE && tableId != (int)EMT.DoneNOW.DTO.GeneralTableEnum.ACTION_TYPE&&tableId != (int)EMT.DoneNOW.DTO.GeneralTableEnum.PROJECT_LINE_OF_BUSINESS&&tableId != (int)EMT.DoneNOW.DTO.GeneralTableEnum.SYSTEM_SUPPORT_EMAIL&&tableId != (int)EMT.DoneNOW.DTO.GeneralTableEnum.PRODUCT_CATE)
                        {%>

                    <tr>
                        <td width="30%" class="FieldLabels">
                            <div>
                                激活 
                                <input type="checkbox" id="isActive" name="isActive" <%if (isAdd || (thisGeneral != null && thisGeneral.is_active == 1))
                                    {%>
                                    checked="checked" <%} %> />
                            </div>
                        </td>
                    </tr>
                    <%} %>
                    <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.ACTION_TYPE)
                        { %>
                    <tr>
                        <td width="30%" class="FieldLabels">类别
                        <div>
                            <select name="ext2" id="ext2" style="width: 232px;">
                                <%if (tempList != null && tempList.Count > 0)
                                    {
                                        foreach (var temp in tempList)
                                        {%>
                                <option value="<%=temp.id %>" <%if (thisGeneral?.ext2 == temp.id.ToString())
                                    {%> selected="selected" <%} %>><%=temp.name %></option>
                                <% }
                                    } %>
                            </select>
                        </div>
                        </td>
                    </tr>
                    <%} %>

                    <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.TASK_LIBRARY_CATE || tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.ACTION_TYPE)
                        {%>
                    <tr>
                        <td width="30%" class="FieldLabels">状态
                        <div>
                            <select id="status_id" name="status_id">
                                <option value="1">激活</option>
                                <option value="0" <% if (thisGeneral != null && thisGeneral.status_id == 0)
                                    {%> selected="selected" <% } %>>不激活</option>
                            </select>
                        </div>
                        </td>
                    </tr>
                    <%} %>
                    <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PAYMENT_TYPE)
                        {%>

                    <tr>
                        <td width="30%" class="FieldLabels">
                            <div>
                                报销 
                                <input type="checkbox" id="isRei" name="isRei" <%if ((thisGeneral != null && thisGeneral.ext1 == "1"))
                                    {%>
                                    checked="checked" <%} %> />
                            </div>
                        </td>
                    </tr>
                    <%} %>
                    <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PAYMENT_TERM)
                        {%>

                    <tr>
                        <td width="30%" class="FieldLabels">付款期限
                        <div>
                            <input type="text" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" id="ext1" name="ext1" style="width: 220px;" maxlength="3" value="<%=thisGeneral != null && !string.IsNullOrEmpty(thisGeneral.ext1)? thisGeneral.ext1: "" %>" />
                        </div>
                        </td>
                    </tr>
                    <%} %>
                    <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PAYMENT_SHIP_TYPE)
                        { %>
                    <tr>
                        <td width="30%" class="FieldLabels">物料代码
                        <div>
                            <select name="ext1" id="ext1" style="width: 232px;">
                                <option></option>
                                <%if (codeList != null && codeList.Count > 0)
                                    {
                                        foreach (var temp in codeList)
                                        {%>
                                <option value="<%=temp.id %>" <%if (thisGeneral != null && thisGeneral.ext1 == temp.id.ToString())
                                    {%> selected="selected" <%} %>><%=temp.name %></option>
                                <% }
                                    } %>
                            </select>
                        </div>
                        </td>
                    </tr>
                    <%} %>
                    <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.TAX_REGION)
                        {%>

                    <tr>
                        <td width="30%" class="FieldLabels">
                            <div>
                                默认税区 
                                <input type="checkbox" id="isDef" name="isDef" <%if ((thisGeneral != null && thisGeneral.ext1 == "1"))
                                    {%>
                                    checked="checked" <%} %> />
                            </div>
                        </td>
                    </tr>
                    <%} %>
                         <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.SYSTEM_SUPPORT_EMAIL)
                        {%>
                     <tr>
                        <td width="30%" class="FieldLabels">发送名称<span style="color: red;"></span>
                            <div>
                                <input type="text" id="ext1" name="ext1" style="width: 220px;" maxlength="11" value="<%=thisGeneral?.ext1 %>" />
                            </div>
                        </td>
                    </tr>
                    <%} %>
                    <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PRODUCT_CATE)
                        { %>
                        <tr>
                        <td width="30%" class="FieldLabels">简称<span style="color: red;"></span>
                            <div>
                                <input type="text" id="code" name="code" style="width: 220px;" maxlength="11" value="<%=thisGeneral?.code %>" />
                            </div>
                        </td>
                    </tr>
                     <tr>
                        <td width="30%" class="FieldLabels">默认配置项类型
                        <div>
                            <select name="ext1" id="ext1" style="width: 232px;">
                                <option></option>
                                <%if (tempList != null && tempList.Count > 0)
                                    {
                                        foreach (var temp in tempList)
                                        {%>
                                <option value="<%=temp.id %>" <%if (thisGeneral != null && thisGeneral.ext1 == temp.id.ToString())
                                    {%> selected="selected" <%} %>><%=temp.name %></option>
                                <% }
                                    } %>
                            </select>
                        </div>
                        </td>
                    </tr>
                    <%} %>
                </tbody>
            </table>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>

    $(function () {
         <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.ACTION_TYPE)
    {%> 
        $("#RemarkDiv").show();
        <%if (thisGeneral?.is_system == 1)
    { %>
        $("#name").prop("disabled", true);
        $("#ext2").prop("disabled", true);
        $("#status_id").prop("disabled", true);
        <%} %>
        <%}
    else if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.SYSTEM_SUPPORT_EMAIL)
    { %>
        $("#SpanName").text("邮箱支持地址");
        
        <%}
    else if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.SYS_TICKET_RESOLUTION_METRICS)
    { %>
        $("#NameTr").hide();
        <%} %>
    })

    $("#save_close").click(function () {
        var name = $("#name").val();
        if (name == "") {
            LayerMsg("请填写名称！");
            return false;
        }
        <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.TASK_LIBRARY_CATE)
    {%> 
        var sort_order = $("#sort_order").val();
        if (sort_order == "") {
            LayerMsg("请填写排序值！");
            return false;
        }
        <%}%>

         <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.ACTION_TYPE)
    {%> 
        var remark = $("#remark").val();
        if (remark == "") {
            LayerMsg("请填写说明！");
            return false;
        }
        $("input").prop("disabled", false);
        $("select").prop("disabled", false);
        <%}%>
        <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PROJECT_LINE_OF_BUSINESS||tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PRODUCT_CATE)
    {%> 
        var isRepeat = "";
        $.ajax({
            type: "GET",
            async: false,
            dataType: "json",
            url: "../Tools/GeneralAjax.ashx?act=CheckExist&name=" + name + "&tableId=<%=tableId %>&id=<%=thisGeneral?.id %>",
            success: function (data) {
                if (!data) {
                    isRepeat = "1";
                }
            }
        });
        if (isRepeat == "1") {
            LayerMsg("名称已经使用，请重新填写！");
            return false;
        }
        <%}%>
        return true;
    })
      <%if (tableId == (int)EMT.DoneNOW.DTO.GeneralTableEnum.PRODUCT_CATE)
    {%> 
    function GetParentCate() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CATE_CALLBACK %>&field=parentId&con5060=<%=thisGeneral?.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductCata %>', 'left=200,top=200,width=600,height=800', false);
    }
       <%}%>
</script>
