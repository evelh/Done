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
        window.open('../Inventory/AddPurchaseOrder.aspx?act=add&ids=' + ids, windowObj.inventoryOrder + windowType.manage, 'left=0,top=0,location=no,status=no,width=900,height=1020', false);
    } else {
        LayerMsg("请选择待采购产品！");
    }
}