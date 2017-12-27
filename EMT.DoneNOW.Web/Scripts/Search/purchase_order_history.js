$(function () {
    $(".General").hide();
    $("#SelectLi").show();
})


function ViewDetail() {
    
}

function Edit() {
    // 状态校验-- 150   --2150 全部接收，2151 已取消 不可以编辑
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/PurchaseOrderAjax.ashx?act=isEditOrder&id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != ""&&data=="True") {
                OpenWindow("../Inventory/AddPurchaseOrder?id=" + entityid + "&act=edit", windowObj.inventoryOrder + windowType.edit);
            } else if (data == "False") {
                LayerMsg("全部接收或者取消状态的采购单不能编辑");
            }

        },
    });
   
}