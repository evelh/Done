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
        window.open("../Inventory/ReceivePurchaseOrder.aspx?ids=" + ids, windowObj.inventoryOrder + windowType.add, 'left=200,top=200,width=1080,height=800', false);
    } else {
        LayerMsg("请选择待接收产品！");
    }
}