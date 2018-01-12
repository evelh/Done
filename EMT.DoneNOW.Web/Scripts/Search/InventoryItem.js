function Add() {
    if ($("#param1").val() == "") {
        window.open('../Inventory/InventoryItem.aspx', windowObj.inventoryItem + windowType.add, 'left=0,top=0,location=no,status=no,width=450,height=600', false);
    } else {
        window.open('../Inventory/InventoryItem.aspx?pdtId=' + $("#param1").val(), windowObj.inventoryItem + windowType.add, 'left=0,top=0,location=no,status=no,width=450,height=600', false);
    }
}
function Edit() {
    window.open('../Inventory/InventoryItem.aspx?id=' + entityid, windowObj.inventoryItem + windowType.add, 'left=0,top=0,location=no,status=no,width=450,height=600', false);
}
function Transfer() {
    window.open('../Inventory/TransferItem.aspx?id=' + entityid, windowObj.inventoryItem + windowType.manage, 'left=0,top=0,location=no,status=no,width=400,height=500', false);
}
function Order() {
    window.open('../Inventory/AddPurchaseOrder.aspx?act=add&ids=' + entityid, windowObj.inventoryOrder + windowType.manage, 'left=0,top=0,location=no,status=no,width=900,height=1020', false);
}
function Delete() {
    LayerConfirm("删除不可恢复，请确认", "确定", "取消", function () {
        requestData("../Tools/InventoryAjax.ashx?act=deleteProduct&id=" + entityid, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("删除失败。采购中、拣货中库存产品不能删除！");
            }
        })
    }, function () { })
}