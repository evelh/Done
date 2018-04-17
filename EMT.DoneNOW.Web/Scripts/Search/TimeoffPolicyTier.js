$(document).ready(function () {
    $("#SelectLi").hide();
})
function Edit() {
    window.parent.editTier(entityid);
}
function Delete() {
    if (entityid == 0) {
        LayerMsg("默认项不能删除");
        return;
    }
    LayerConfirm("删除不可恢复，请确认", "确定", "取消", function () {
        requestData("/Tools/TimeoffPolicyAjax.ashx?act=deleteItemTier&id=" + entityid, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("删除失败");
            }
        })
    }, function () { })
}