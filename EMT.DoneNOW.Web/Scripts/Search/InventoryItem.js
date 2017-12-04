function Add() {
    window.open('../Inventory/InventoryItem.aspx', windowObj.inventoryItem + windowType.add, 'left=0,top=0,location=no,status=no,width=400,height=500', false);
}
function Edit() {
    window.open('../Inventory/InventoryItem.aspx?id=' + entityid, windowObj.inventoryItem + windowType.add, 'left=0,top=0,location=no,status=no,width=400,height=500', false);
}
function Transfer() {

}
function Order() {

}
function Delete() {

}