$('.contenttitle ul li').eq(0).before('<li style="text-align:center;padding:0 8px;" onclick="Reject()">拒绝</li>');
$('.contenttitle ul li').eq(0).before('<li style="text-align:center;padding:0 8px;" onclick="Approve()">批准</li>');
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
function Approve(){
    var ids = "";
    var cnt = 0;
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
            cnt++;
        }
    });
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
        requestData("../Tools/TimesheetAjax.ashx?act=approve&ids=" + ids, null, function (data) {
            if (data == cnt) {
                window.location.reload();
                LayerMsg("审批成功！");
            } else if (data == 0) {
                LayerMsg("审批失败，请重新查看待审批数据！");
            } else {
                window.location.reload();
                LayerMsg("部分审批成功！");
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
        requestData("../Tools/TimesheetAjax.ashx?act=reject&ids=" + ids + "&reason=" + rejectReason, null, function (data) {
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
function Detail() {
    requestData("../Tools/TimesheetAjax.ashx?act=timesheetInfo&id=" + entityid, null, function (data) {
        window.location.href = "SearchBodyFrame.aspx?cat=1633&type=219&con2738=" + data[0] + "&con2739=" + data[1] + "&param1=" + data[2];
    })
}
