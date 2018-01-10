function Add() {
    window.open('../Inventory/AddPurchaseOrder.aspx?act=add', windowObj.inventoryOrder + windowType.manage, 'left=0,top=0,location=no,status=no,width=900,height=1020', false);
}
function Edit() {
    window.open('../Inventory/AddPurchaseOrder.aspx?act=edit&id=' + entityid, windowObj.inventoryOrder + windowType.manage, 'left=0,top=0,location=no,status=no,width=900,height=1020', false);
}
function Delete() {
    LayerConfirm("删除不可恢复，请确认", "确定", "取消", function () {
        requestData("/Tools/PurchaseOrderAjax.ashx?act=DeleteOrder&id=" + entityid, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("新建、已提交和已取消状态的采购订单才可以删除");
            }
        })
    }, function () { })
}
function Submit() {
    requestData("/Tools/PurchaseOrderAjax.ashx?act=SubmitOrder&id=" + entityid, null, function (data) {
        if (data == true) {
            window.location.reload();
        } else {
            LayerMsg("新建和已取消状态的采购订单才可以提交");
        }
    })
}
function Cancle() {
    requestData("/Tools/PurchaseOrderAjax.ashx?act=CancleOrder&id=" + entityid, null, function (data) {
        if (data == true) {
            window.location.reload();
        } else {
            LayerMsg("新建和已提交状态的采购订单才可以取消");
        }
    })
}
function Receive() {
    window.open('../Inventory/ReceivePurchaseOrder.aspx?id=' + entityid, windowObj.inventoryOrder + windowType.add, 'left=0,top=0,location=no,status=no,width=1000,height=800', false);
}
function ViewPrint() {
    window.open('../Inventory/ViewPurchaseOrder.aspx?id=' + entityid, windowType.blank, 'left=0,top=0,location=no,status=no,width=900,height=800', false);
}