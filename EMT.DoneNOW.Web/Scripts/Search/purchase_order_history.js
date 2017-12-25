$(function () {
    $(".General").hide();
    $("#SelectLi").show();
})


function ViewDetail() {
    
}

function Edit() {
    OpenWindow("../Inventory/AddPurchaseOrder?id=" + entityid + "&act=edit", windowObj.inventoryOrder + windowType.edit);
}