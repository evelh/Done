function RightClickFunc() {
    requestData("../Tools/InventoryLocationAjax.ashx?act=getInfo&id=" + entityid, null, function (data) {
        if (data[2] == "1") {
            $("#activeBtn").hide();
            $("#inactiveBtn").show().css("color", "");
            $("#inactiveBtn").unbind('click').click(function () {
                SetInactive();
            });
        } else {
            $("#inactiveBtn").hide();
            $("#activeBtn").show().css("color", "");
            $("#activeBtn").unbind('click').click(function () {
                SetActive();
            });
        }
        if (data[0] == "1") {
            $("#defaultBtn").css("color", "grey").unbind('click');
        } else {
            $("#defaultBtn").css("color", "").unbind('click').click(function () {
                SetDefault();
            });
        }
        if (data[1] == "1") {
            $("#activeBtn").css("color", "grey").unbind('click');
            $("#inactiveBtn").css("color", "grey").unbind('click');
            $("#deleteBtn").css("color", "grey").unbind('click');
        } else {
            $("#deleteBtn").css("color", "").unbind('click').click(function () {
                Delete();
            });
        }
        ShowContextMenu();
    })
}
function Add() {
    window.open('../Inventory/InventoryLocation.aspx', windowObj.inventoryLocation + windowType.add, 'left=0,top=0,location=no,status=no,width=400,height=500', false);
}
function Edit() {
    window.open('../Inventory/InventoryLocation.aspx?id=' + entityid, windowObj.inventoryLocation + windowType.add, 'left=0,top=0,location=no,status=no,width=400,height=500', false);
}
function SetActive() {
    requestData("../Tools/InventoryLocationAjax.ashx?act=setActive&id=" + entityid, null, function (data) {
        window.location.reload();
    })
}
function SetInactive() {
    requestData("../Tools/InventoryLocationAjax.ashx?act=setInactive&id=" + entityid, null, function (data) {
        window.location.reload();
    })
}
function SetDefault() {
    requestData("../Tools/InventoryLocationAjax.ashx?act=setDefault&id=" + entityid, null, function (data) {
        window.location.reload();
    })
}
function Delete() {
    LayerConfirm("删除不可恢复，请确认", "确定", "取消", function () {
        requestData("../Tools/InventoryLocationAjax.ashx?act=delete&id=" + entityid, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("删除失败。该仓库有产品或未完成的采购订单不能删除！");
            }
        })
    }, function () { })
}