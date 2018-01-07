$(function () {
    $(".General").hide();
    $("#SelectLi").show();
})


function ViewDetail() {
    window.open('../Inventory/ViewPurchaseOrder.aspx?id=' + entityid, windowType.blank, 'left=0,top=0,location=no,status=no,width=900,height=800', false);
}

function Edit() {
    // 状态校验-- 150   --2150 全部接收，2151 已取消 不可以编辑
    debugger;
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/PurchaseOrderAjax.ashx?act=isEditOrder&id=" + entityid,
        //dataType: "json",
        success: function (data) {
            debugger;
            if (data != "" && data == "True") {
                window.open("../Inventory/AddPurchaseOrder?id=" + entityid + "&act=edit", windowObj.inventoryOrder + windowType.edit, 'left=0,top=0,width=1080,height=850,resizable=yes', false);
               
            } else if (data == "False") {
                LayerMsg("全部接收或者取消状态的采购单不能编辑");
            }

        },
    });
   
}

function View(id) {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/PurchaseOrderAjax.ashx?act=isEditOrder&id=" + id,
        //dataType: "json",
        success: function (data) {
            debugger;
            if (data != "" && data == "True") {
                window.open("../Inventory/AddPurchaseOrder?id=" + id + "&act=edit", windowObj.inventoryOrder + windowType.edit, 'left=0,top=0,width=1080,height=850,resizable=yes', false);
                
            } else if (data == "False") {
                LayerMsg("全部接收或者取消状态的采购单不能编辑");
            }

        },
    });
}