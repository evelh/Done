$('.contenttitle ul li').eq(0).after('<li style="text-align:center;padding:0 8px;" onclick="Reject()">拒绝</li>');
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
function Add() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    });
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
        requestData("../Tools/TimeoffPolicyAjax.ashx?act=approveRequest&ids=" + ids, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("审批失败！");
            }
        })
    } else {
        alert("请选择需要审批的数据！");
    }
}
function Reject() {
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
$("#rejectButton").click(function () {
    var rejectReason = $("#rejectReason").val();
    if ($.trim(rejectReason) == "") {
        LayerMsg("请填写拒绝原因");
    } else {
        RejectSelect();
    }
})
$("#CloseButton").click(function () {
    $("#BackgroundOverLay").hide();
    $("#RefuseExpenseReport").hide();
})
function RejectSelect() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    });
    if (ids != "") {
        $("#RefuseExpenseReport").hide();
        $("#LoadingIndicator").show();
        var rejectReason = $("#rejectReason").val();
        ids = ids.substring(0, ids.length - 1);
        requestData("../Tools/TimeoffPolicyAjax.ashx?act=rejectRequest&ids=" + ids + "&reason=" + rejectReason, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("拒绝失败！");
            }
        })
    } else {
        LayerMsg("请先选择工时报表");
        $("#BackgroundOverLay").hide();
        $("#RefuseExpenseReport").hide();
    }
}