var orderId;
$(document).ready(function () {
    $("#PrintLi").hide();
    $("#ExportLi").hide();
    orderId = window.parent.$("#orderId").val();
    var cost = $("#param1").val();
    if (cost!=0)
        $("#addDiv").html("<span>总费用:￥" + $("#param1").val() + "</span>");
})
function Add() {
    window.open("../Inventory/AddPurchaseItem.aspx?act=add&orderId=" + orderId, windowObj.inventoryOrderItem, 'left=0,top=0,location=no,status=no,width=450,height=400', false);
}
function Edit() {
    window.open("../Inventory/AddPurchaseItem.aspx?act=edit&orderId=" + orderId + "&productId=" + entityid, windowObj.inventoryOrderItem, 'left=0,top=0,location=no,status=no,width=450,height=400', false);
}
function EditCost() {
    requestData("/Tools/PurchaseOrderAjax.ashx?act=getItemCostId&itemId=" + entityid, null, function (data) {
        if (data != 0) {
            window.open("../Contract/ChargeDetails.aspx?id=" + data, windowObj.contractCost + windowType.view, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        } else {
            LayerMsg("采购项未关联成本");
        }
    })
}
function EditNote() {
    window.parent.editMemo(entityid);
}
function Delete() {
    LayerConfirm("删除不可恢复，请确认", "确定", "取消", function () {
        requestData("/Tools/PurchaseOrderAjax.ashx?act=deleteItem&id=" + entityid, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("新建和已提交状态的采购项才可以删除");
            }
        })
    }, function () { })
}
