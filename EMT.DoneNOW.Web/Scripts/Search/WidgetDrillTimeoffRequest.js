$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();


$("#CheckAll").click(function () {
    if ($(this).is(":checked")) {
        $(".IsChecked").prop("checked", true);
        $(".IsChecked").css("checked", "checked");
    }
    else {
        $(".IsChecked").prop("checked", false);
        $(".IsChecked").css("checked", "");
    }
})
function ApproveSelect() {
    var cnt = 0;
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
            cnt++;
        }
    });
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
        requestData("../Tools/TimeoffPolicyAjax.ashx?act=approveRequest&ids=" + ids, null, function (data) {
            if (data == 0) {
                LayerMsg("审批失败！其他人已审批或已生成工时表且提交，不能审批休假请求！");
            } else if (data == cnt) {
                window.location.reload();
                LayerMsg("审批成功！");
            } else {
                window.location.reload();
                LayerMsg("审批部分成功！其他人已审批或已生成工时表且提交，不能审批休假请求！");
            }
        })
    } else {
        alert("请选择需要审批的数据！");
    }
}

function ApproveSingle() {
    requestData("../Tools/TimeoffPolicyAjax.ashx?act=approveRequest&ids=" + entityid, null, function (data) {
        if (data == 0) {
            LayerMsg("审批失败！其他人已审批或已生成工时表且提交，不能审批休假请求！");
        } else if (data == cnt) {
            window.location.reload();
            LayerMsg("审批成功！");
        } else {
            window.location.reload();
            LayerMsg("审批部分成功！其他人已审批或已生成工时表且提交，不能审批休假请求！");
        }
    })
}
function RejectSelect() {
    isSingle = "";
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    });
    if (ids != "") {
        $("#BackgroundOverLay").show();
        $("#RefuseExpenseReport").show();
    } else {
        alert("请选择需要审批的数据！");
    }
}
var isSingle = "1";
function RejectSingle() {
    isSingle = "1";
    $("#BackgroundOverLay").show();
    $("#RefuseExpenseReport").show();
}



$("#rejectButton").click(function () {
    var rejectReason = $("#rejectReason").val();
    if ($.trim(rejectReason) == "") {
        LayerMsg("请填写拒绝原因");
    } else {
        Reject();
    }
})
$("#CloseButton").click(function () {
    $("#BackgroundOverLay").hide();
    $("#RefuseExpenseReport").hide();
})
function Reject() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    });
    if (ids != "" || entityid!="") {
        $("#RefuseExpenseReport").hide();
        $("#LoadingIndicator").show();
        var rejectReason = $("#rejectReason").val();
        if (isSingle == "") {
            ids = ids.substring(0, ids.length - 1);
        }
        else if (isSingle == "1") {
            ids = entityid;
        }
        

        requestData("../Tools/TimeoffPolicyAjax.ashx?act=rejectRequest&ids=" + ids + "&reason=" + rejectReason, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("拒绝失败！");
                $("#BackgroundOverLay").hide();
                $("#RefuseExpenseReport").hide();
                $("#LoadingIndicator").hide();
            }
        })
    } else {
        LayerMsg("请先选择工时报表");
        $("#BackgroundOverLay").hide();
        $("#RefuseExpenseReport").hide();
    }
}
