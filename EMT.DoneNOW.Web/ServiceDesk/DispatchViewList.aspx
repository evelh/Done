<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DispatchViewList.aspx.cs" Inherits="EMT.DoneNOW.Web.DispatchViewList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/index.css" />
    <link rel="stylesheet" href="../Content/style.css" />
    <title>调度视图管理</title>
    <style>
        .dataGridBody, .dataGridAlternating, .dataGridGroupBreak, .dataGridBodyHighlight {
            background-color: white;
            border-left-width: 0;
            border-bottom-width: 1px;
            border-bottom-style: solid;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: middle;
            padding: 10px 0 4px 0;
            vertical-align: top;
            word-wrap: break-word;
            border-right-width: 1px;
            border-right-style: solid;
        }

        .dataGridBody, .dataGridAlternating, .dataGridGroupBreak, .dataGridBodyHighlight {
            border-bottom-color: #98b4ca;
            border-right-color: #98b4ca;
        }

            .dataGridBody tr, .dataGridBodyHover tr, .dataGridAlternating tr, .dataGridAlternatingHover tr, .dataGridBodyHighlight tr, .dataGridGroupBreak tr {
                height: 22px;
            }

        .dataGridHeader {
            background-color: #cbd9e4;
        }

        tr.dataGridHeader td:first-child {
            width: 15px;
        }

        .dataGridBody .dataGridHeader td {
            border-bottom-style: solid;
            border-bottom-width: 1px;
        }

        .dataGridBody td:first-child, .dataGridAlternating td:first-child, .dataGridBodyHover td:first-child, .dataGridAlternatingHover td:first-child, .dataGridDisabled td:first-child, .dataGridDisabledHover td:first-child {
            border-left-color: #98b4ca;
        }

        .dataGridBody .dataGridHeader td {
            border-bottom-color: #98b4ca;
        }

        .dataGridHeader td, .dataGridHeader th, tr.dataGridHeader td, tr.dataGridHeader th {
            border-color: #98b4ca;
            background-color: #cbd9e4;
            color: #64727a;
                border-right-width: 1px;
    border-right-style: solid;
    font-size: 13px;
    font-weight: bold;
    height: 19px;
    padding: 4px;
    vertical-align: top;
    word-wrap: break-word;
    user-select: none;
        }
        .dataGridAlternating td{
            text-align:left;
        }
        .dataGridBody td:first-child, .dataGridAlternating td:first-child, .dataGridBodyHover td:first-child, .dataGridAlternatingHover td:first-child, .dataGridDisabled td:first-child, .dataGridDisabledHover td:first-child {
    border-left-color: #98b4ca;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">管理已保存视图</div>
        <div class="header-title">
            <ul>
                <li onclick="Save()">
                    <img src="../Images/save.png" alt="" />
                    保存
                </li>
                <li onclick="Cancel()">
                    <img src="../Images/save.png" alt="" />
                    取消                
                </li>
                <li onclick="javascript:window.close();">
                    <img src="../Images/cancel.png" alt="" />
                    关闭
                </li>
            </ul>
        </div>
        <div style="padding-left:10px;padding-right:10px;">

            <div id="datagrid_datagrid_divdata" style="width: 100%; overflow: auto; height: 345px; z-index: 0;">
                <table class="dataGridBody" cellspacing="0" rules="all" border="1" id="datagrid_datagrid_datagrid" style="width: 100%; border-collapse: collapse;">
                    <tbody>
                        <tr class="dataGridHeader">
                            <td align="center"></td>
                            <td style="text-align:left;"><span>视图名称</span>&nbsp;</td>
                        </tr>
                        <% if (viewList != null && viewList.Count > 0)
                            {
                                foreach (var view in viewList)
                                {%>
                        <tr id="" class="dataGridAlternating" style="cursor: pointer;">
                            <td align="center" style="width: 25px; padding-left: 5px; padding-right: 5px;">
                                <img id="" title="Delete Record" onclick="DeleteView('<%=view.id %>')" src="../Images/delete.png" border="0" />
                            </td>
                            <td style="text-align:left;"><span class="ChangeView" data-val="<%=view.id %>"><%=view.name %></span></td>
                        </tr>
                        <% }
                            } %>
                        <%if (isAdd)
                            { %>
                        <tr id="" data-val="0" class="dataGridAlternating" style="cursor: pointer;">
                            <td align="center" style="width: 25px; padding-left: 5px; padding-right: 5px;">
                                <img id="" title="Delete Record" onclick="DeleteView('0')" src="../Images/delete.png" border="0" />
                            </td>
                            <td style="text-align:left;"><input type="text" id="NewName" value=""/></td>
                        </tr>
                        <%} %>
                    </tbody>
                </table>
                <input type="hidden" id="workIds" value="<%=workIds %>" />
                <input type="hidden" id="resIds" value="<%=resIds %>" />
                <input type="hidden" id="isShowNoRes" value="<%=isShowNoRes?"1":"" %>" />
                <input type="hidden" id="isShowCalls" value="<%=isShowCalls?"1":"" %>" />
                <input type="hidden" id="modeId" value="<%=modeId %>" />
                <input type="hidden" id="EditId" />

            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    var isEdit = "";
    $(".ChangeView").click(function () {
        <%if (!isAdd)
    { %>
        if (isEdit == "") {
            var thisId = $(this).data("val");
            var thisName = $(this).text();
            $(this).hide();
            isEdit = thisId;
            $(this).after("<input type='text' id='tempValue' value='" + thisName + "' />");
        }
        <%} %>
    })

    function Cancel() {
        location.reload();
    }
    function Save() {
        <%if (isAdd)
    { %> 
        var workIds = $("#workIds").val();
        var resIds = $("#resIds").val();
        var isShowNoRes = $("#isShowNoRes").val();
        var isShowCalls = $("#isShowCalls").val();
        var name = $("#NewName").val();
        if (name == "") {
            LayerMsg("请填写名称！");
            return;
        }
        var modeId = $("#modeId").val();
        if (modeId == "" || modeId=="0") {
            LayerMsg("为获取到相关显示天数！");
            return;
        }
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/DispatchAjax.ashx?act=AddDispatch&workIds=" + workIds + "&resIds=" + resIds + "&isShowNoRes=" + isShowNoRes + "&isShowCalls=" + isShowCalls + "&name=" + name + "&modeId=" + modeId,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("保存成功！");
                }
                setTimeout(function () { history.go(0); }, 800);
            },
        });

        <%}
    else
    { %>
        if (isEdit != "") {
            var thisValue = $("#tempValue").val();
            if (thisValue != "") {
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/DispatchAjax.ashx?act=EditDispatch&id=" + isEdit + "&name=" + thisValue,
                    dataType: "json",
                    success: function (data) {
                        if (data) {
                            LayerMsg("保存成功！");
                        }
                        setTimeout(function () { history.go(0); }, 800);
                    },
                });
            }
            else {
                LayerMsg("请填写名称！");
            }
        }
        <%} %>
    }
    function DeleteView(viewId) {
        if (viewId == "0" || viewId == "") {
            LayerMsg("请先保存！");
            return;
        }
        LayerConfirm("删除操作不可恢复，是否继续？", "是", "否", function () {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/DispatchAjax.ashx?act=DeleteDispatch&id=" + viewId,
                dataType: "json",
                success: function (data) {
                    if (data) {
                        LayerMsg("删除成功！");
                    }
                    setTimeout(function () { history.go(0); }, 800);
                },
            });
        }, function () { });

    }
</script>
