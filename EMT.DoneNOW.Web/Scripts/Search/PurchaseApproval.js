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
function Approval() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    });
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
        requestData("/Tools/PurchaseOrderAjax.ashx?act=approval&ids=" + ids, null, function (data) {
            window.location.reload();
        })
    } else {
        LayerMsg("请选择需要审批的数据！");
    }
}
function ApprovalReject() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    });
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
        requestData("/Tools/PurchaseOrderAjax.ashx?act=approvalReject&ids=" + ids, null, function (data) {
            window.location.reload();
        })
    } else {
        LayerMsg("请选择需要审批的数据！");
    }
}