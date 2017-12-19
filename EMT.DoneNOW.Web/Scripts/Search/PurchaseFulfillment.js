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
        requestData("/Tools/PurchaseOrderAjax.ashx?act=createPurchaseOrder&ids=" + ids, null, function (data) {
            window.location.reload();
        })
    } else {
        LayerMsg("请选择待采购产品！");
    }
}