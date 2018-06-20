<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LedgerAccountManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.LedgerAccountManage" %>

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
        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="general">政策</li>
                <%if (!isAdd)
                    { %>
                <li id="ruleLi">规则</li>
                <%} %>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 116px;">
            <div class="content clear" id="GeneralDiv">
                <div class="information clear">
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left: 15px;">名称</span><span style="color: red;">*</span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" id="name" name="name" style="width: 220px;" maxlength="11" value="<%=ledger!=null?ledger.name:"" %>" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left: 15px;">描述</span><span style="color: red;">*</span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <textarea id="remark" name="remark"><%=ledger!=null?ledger.remark:"" %></textarea>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="content clear" style="display: none;" id="RuleDiv">
                <div class="header-title">
                    <input type="hidden" id="codeId" />
                    <input type="hidden" id="codeIdHidden" />
                    <ul>
                        <li onclick="RelaWorkType()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>新增</li>
                    </ul>
                </div>
                <div class="GridContainer">
                    <div style="height: 832px; width: 100%; overflow: auto; z-index: 0;">
                        <table class="dataGridBody" style="width: 100%; border-collapse: collapse;">
                            <tbody>
                                <tr class="dataGridHeader">

                                    <td align="center" style="width: 50%;">代码</td>
                                    <td align="center" style="width: 50%;">部门</td>
                                </tr>

                                <% if (codeList != null && codeList.Count > 0 && depList != null && depList.Count > 0)
                                    {
                                        foreach (var code in codeList)
                                        {
                                            var thisDep = depList.FirstOrDefault(_ => _.id == code.department_id);
                                %>
                                <tr class="dataGridBody" style="cursor: pointer;" data-val="<%=code.id %>">
                                    <td align="center"><a onclick="ShowCode('<%=code.id %>')"><%=code.name %></a></td>
                                    <td align="center"><%=thisDep!=null?thisDep.name:"" %></td>

                                </tr>
                                <% }
                                    } %>
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
         <% if (Request.QueryString["type"] == "rule")
    {%> $("#ruleLi").trigger("click"); <% }
    %>
    })


    $("#ruleLi").click(function () {
        $("#GeneralDiv").hide();
        $("#RuleDiv").show();
        if (!$(this).hasClass("boders")) {
            $(this).addClass("boders");
        }
        $("#general").removeClass("boders");
    })
    $("#general").click(function () {
        $("#GeneralDiv").show();
        $("#RuleDiv").hide();
        if (!$(this).hasClass("boders")) {
            $(this).addClass("boders");
        }
        $("#ruleLi").removeClass("boders");
    })

    function RelaWorkType() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE %>&field=codeId&callBack=CallBack", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function CallBack() {
        var codeId = $("#codeIdHidden").val();
        if (codeId != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/CostCodeAjax.ashx?act=ChangeCodeLedger&id=" + codeId + "&ledId=<%=ledger!=null?ledger.id.ToString():"" %>",
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data) {
                        LayerMsg("关联成功");
                    }
                    setTimeout(function () {
                        location.href = "LedgerAccountManage?id=<%=ledger!=null?ledger.id.ToString():"" %>&type=rule";
                    }, 800);
                }
            })
        }
    }

    function ShowCode(id) {
        window.open("../SysSetting/CostCodeManage.aspx?id=" + id, windowObj.costCode + windowType.edit, 'left=200,top=200,width=600,height=800', false);
    }
</script>
