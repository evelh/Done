function Add() {
    window.open('../Inventory/AddPurchaseOrder.aspx?act=add', windowObj.inventoryItem + windowType.manage, 'left=0,top=0,location=no,status=no,width=900,height=1020', false);
}
function Edit() {
    window.open('../Inventory/AddPurchaseOrder.aspx?act=edit&id=' + entityid, windowObj.inventoryItem + windowType.manage, 'left=0,top=0,location=no,status=no,width=900,height=1020', false);
}
function Delete() {

}