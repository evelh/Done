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

}
function EditNote() {

}
function Delete() {

}
