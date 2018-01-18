
$(function () {
    $(".General").hide();
    $("#appSel").css("color", "grey");
    $("#appSel").removeAttr("click");
    $("#rejSel").css("color", "grey");
    $("#rejSel").removeAttr("click");
    $(".IsChecked").click(function (event) {
        event.stopPropagation(); // 不执行上一元素的事件，阻止冒泡事件
    });
})
$("#CheckAll").click(function () {
    if ($(this).is(":checked")) {
        $(".IsChecked").prop("checked", true);
        $(".IsChecked").css("checked", "checked");
        $("#appSel").css("color", "black");
        $("#appSel").click(function () {
            ApprovalSelect();
        });
        $("#rejSel").css("color", "black");
        $("#rejSel").click(function () {
            ShowRefuseDiv();
        });
    }
    else {
        $(".IsChecked").prop("checked", false);
        $(".IsChecked").css("checked", "");
        $("#appSel").css("color", "grey");
        $("#appSel").removeAttr("click");
        $("#rejSel").css("color", "grey");
        $("#rejSel").removeAttr("click");
    }
})

$(".IsChecked").click(function () {
    if ($(this).is(":checked")) {
        $("#appSel").css("color", "black");
        $("#appSel").click(function () {
            ApprovalSelect();
        })
        $("#rejSel").css("color", "black");
        $("#rejSel").click(function () {
            ShowRefuseDiv();
        })
    }
    else {
        var id = GetSelectId();
        if (id == "")
        {
            $("#appSel").css("color", "grey");
            $("#appSel").removeAttr("click");
            $("#rejSel").css("color", "grey");
            $("#rejSel").removeAttr("click");
        }
    }
})

// 审批选中费用报表
function ApprovalSelect() {
    var ids = GetSelectId();
    if (ids != "") {
        $("#BackgroundOverLay").show();
        $("#LoadingIndicator").show();
        $.ajax({
            type: "GET",
            url: "../Tools/ExpenseAjax.ashx?act=Approval&ids=" + ids,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result) {
                        LayerMsg("审批成功！");
                    } else {
                        LayerMsg("部分费用审批失败！" + data.reason);
                    }
                }
                setTimeout(function () {
                    history.go();
                }, 1000);
            }
        })
    } else {
        LayerMsg("请先选择相关费用");
    }
}
// 拒绝选中费用报表
function RejectSelect() {
    var ids = GetSelectId();
    if (ids != "") {
        $("#RefuseExpenseReport").hide();
        $("#LoadingIndicator").show();
        var rejectReason = $("#rejectReason").val();
        $.ajax({
            type: "GET",
            url: "../Tools/ExpenseAjax.ashx?act=Refuse&ids=" + ids + "&reason=" + rejectReason,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result) {
                        LayerMsg("拒绝成功！");
                    } else {
                        LayerMsg("部分费用拒绝失败！" + data.reason);
                    }
                }
                setTimeout(function () {
                    history.go();
                }, 1000);
            }
        })
    } else {
        LayerMsg("请先选择相关费用");
        $("#BackgroundOverLay").hide();
        $("#RefuseExpenseReport").hide();
    }
}
$("#rejectButton").click(function () {
    var rejectReason = $("#rejectReason").val();
    if ($.trim(rejectReason) == "") {
        LayerMsg("请填写拒绝原因");
    } else {
        RejectSelect();
    }
})
// 展示提示输入拒绝理由
function ShowRefuseDiv() {
    var ids = GetSelectId();
    if (ids != "") {
        $("#BackgroundOverLay").show();
        $("#RefuseExpenseReport").show();
    } else {
        LayerMsg("请先选择相关费用");
    }
   
}
$("#CloseButton").click(function () {
    $("#BackgroundOverLay").hide();
    $("#RefuseExpenseReport").hide();
})

// 点击行 查看
function View(id) {
    OpenWindow("../TimeSheet/ReportOperation.aspx?id=" + id, windowObj.expenseReport + windowType.manage);
}
// 右键查看信息
function ShowDetail() {
    OpenWindow("../TimeSheet/ReportOperation.aspx?id=" + entityid, windowObj.expenseReport + windowType.manage);
}
// 编辑
function Edit() {
    OpenWindow("../Project/ExpenseReportManage.aspx?id=" + entityid, windowObj.expenseReport + windowType.edit);
}

// 删除
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/ExpenseAjax.ashx?act=DeleteExpenseReport&report_id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    alert('删除成功');
                } else {
                    alert('删除失败' + data.reason);
                }

            }
            setTimeout(function () {
                history.go();
            }, 1000);
        }
    })
}
// 获取到选中的Id 集合
function GetSelectId() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            var thisValue = $(this).val();
            ids += thisValue + ",";
        }
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length-1);
    }
    return ids;
}




