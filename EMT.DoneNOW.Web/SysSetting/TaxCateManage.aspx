<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaxCateManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.TaxCateManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %></title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/index.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1"><%=isAdd?"新增":"编辑" %></span>
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
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 90px;">
            <div class="content clear" id="GeneralDiv">
                <div class="information clear">
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left: 15px;">名称</span><span style="color: red;">*</span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" id="name" name="name" style="width: 220px;" maxlength="11" value="<%=thisTaxCate!=null?thisTaxCate.name:"" %>" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left: 15px;">说明</span><span style="color: red;"></span>
                                        <div>
                                            <textarea id="remark" name="remark"><%=thisTaxCate!=null?thisTaxCate.remark:"" %></textarea>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <div>
                                            <span style="margin-left: 15px;">激活</span>
                                            <input type="checkbox" id="isActive" style="margin-top:0px;" name="isActive" <%if (isAdd || (thisTaxCate != null && thisTaxCate.is_active == 1))
                                                {%>
                                                checked="checked" <%} %> />
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="information clear">
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">工作类型</span>
                                        <div>
                                            <input type="hidden" id="workTypeIdsHidden" name="workTypeIds" value="<%=workTypeIds %>"/>
                                            <input type="hidden" id="workTypeIds"/>
                                            <select id="workTypeSelect" style="width: 232px;height:100px;" multiple="multiple">
                                            </select>
                                            <a onclick="CodeCallBack('<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE %>')"><img src="../Images/data-selector.png" style="height: 20px;width: 20px;float: left;margin-left: 10px;"/></a>
                                        </div>
                                    </td>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">费用</span>
                                        <div>
                                            <input type="hidden" id="expenseIdsHidden" name="expenseIds" value="<%=expenseIds %>"/>
                                            <input type="hidden" id="expenseIds"/>
                                            <select id="expenseSelect" style="width: 232px;height:100px;" multiple="multiple">
                                            </select>
                                            <a onclick="CodeCallBack('<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY %>')"><img src="../Images/data-selector.png" style="height: 20px;width: 20px;float: left;margin-left: 10px;"/></a>
                                        </div>
                                    </td>
                                </tr>
                                 <tr>
                                   
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">物料代码</span>
                                        <div>
                                            <input type="hidden" id="materialIdsHidden" name="expenseIds" value="<%=materialIds %>"/>
                                            <input type="hidden" id="materialIds"/>
                                            <select id="materiaSelect" style="width: 232px;height:100px;" multiple="multiple">
                                            </select>
                                            <a onclick="CodeCallBack('<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE %>')"><img src="../Images/data-selector.png" style="height: 20px;width: 20px;float: left;margin-left: 10px;"/></a>
                                        </div>
                                    </td>
                                       <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">里程碑</span>
                                        <div>
                                            <input type="hidden" id="milestoneIdsHidden" name="expenseIds" value="<%=milestoneIds %>"/>
                                            <input type="hidden" id="milestoneIds"/>
                                            <select id="milestoneSelect" style="width: 232px;height:100px;" multiple="multiple">
                                            </select>
                                            <a onclick="CodeCallBack('<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MILESTONE_CODE %>')"><img src="../Images/data-selector.png" style="height: 20px;width: 20px;float: left;margin-left: 10px;"/></a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                     <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">服务</span>
                                        <div>
                                            <input type="hidden" id="serviceIdsHidden" name="workTypeIds" value="<%=serviceIds %>"/>
                                            <input type="hidden" id="serviceIds"/>
                                            <select id="serviceSelect" style="width: 232px;height:100px;" multiple="multiple">
                                            </select>
                                            <a onclick="CodeCallBack('<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RECURRING_CONTRACT_SERVICE_CODE %>')"><img src="../Images/data-selector.png" style="height: 20px;width: 20px;float: left;margin-left: 10px;"/></a>
                                        </div>
                                    </td>
                                  
                                    <td></td>
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
<script>

    $(function () {
        GetWorkType();
        GetExpense();
        GetMaterial();
        GetMilestone();
        GetService();
    })


    function CodeCallBack(cateId) {
        if (cateId == '<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE %>') {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE %>&muilt=1&field=workTypeIds&callBack=GetWorkType", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
        }
        else if (cateId == '<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY %>') {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY %>&muilt=1&field=expenseIds&callBack=GetExpense", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
        }
        else if (cateId == '<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE %>') {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE %>&muilt=1&field=materialIds&callBack=GetMaterial", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
        }
        else if (cateId == '<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RECURRING_CONTRACT_SERVICE_CODE %>') {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RECURRING_CONTRACT_SERVICE_CODE %>&muilt=1&field=serviceIds&callBack=GetService", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
        }
        else if (cateId == '<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MILESTONE_CODE %>') {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MILESTONE_CODE %>&muilt=1&field=milestoneIds&callBack=GetMilestone", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
        }
    }


    function GetWorkType() {
        var codeIds = $("#workTypeIdsHidden").val();
        var html = "";
        if (codeIds != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/CostCodeAjax.ashx?act=GetCodeByIds&ids=" + codeIds,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            html += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
        }
        $("#workTypeSelect").html(html);
        $("#workTypeSelect option").dblclick(function () {
            RemoveCode(this, 'workTypeSelect','workTypeIdsHidden');
        })
    }
    function GetExpense() {
        var codeIds = $("#expenseIdsHidden").val();
        var html = "";
        if (codeIds != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/CostCodeAjax.ashx?act=GetCodeByIds&ids=" + codeIds,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            html += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
        }
        $("#expenseSelect").html(html);
        $("#expenseSelect option").dblclick(function () {
            RemoveCode(this, 'expenseSelect', 'expenseIdsHidden');
        })
    }
    function GetMaterial() {
        var codeIds = $("#materialIdsHidden").val();
        var html = "";
        if (codeIds != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/CostCodeAjax.ashx?act=GetCodeByIds&ids=" + codeIds,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            html += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
        }
        $("#materiaSelect").html(html);
        $("#materiaSelect option").dblclick(function () {
            RemoveCode(this, 'materiaSelect', 'materialIdsHidden');
        })
    }
    function GetMilestone() {
        var codeIds = $("#milestoneIdsHidden").val();
        var html = "";
        if (codeIds != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/CostCodeAjax.ashx?act=GetCodeByIds&ids=" + codeIds,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            html += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
        }
        $("#milestoneSelect").html(html);
        $("#milestoneSelect option").dblclick(function () {
            RemoveCode(this, 'milestoneSelect', 'milestoneIdsHidden');
        })
    }
    function GetService() {
        var codeIds = $("#serviceIdsHidden").val();
        var html = "";
        if (codeIds != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/CostCodeAjax.ashx?act=GetCodeByIds&ids=" + codeIds,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            html += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
        }
        $("#serviceSelect").html(html);
        $("#serviceSelect option").dblclick(function () {
            RemoveCode(this, 'serviceSelect', 'serviceIdsHidden');
        })
    }

    function RemoveCode(val,select,hidden) {
        $(val).remove();
        var ids = "";
        $("#" + select+" option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#" + hidden).val(ids);
    }

</script>
