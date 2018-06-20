function Add() {
    window.parent.parent.AddSharedDashboard();
}
function Edit() {
    window.parent.parent.EditSharedDashboard(entityid);
}
function Share() {
    window.open("../System/ShareDashboard?id=" + entityid, windowObj.shareDashboard, 'left=0,top=0,location=no,status=no,width=910,height=920', false);
}
function Copy() {
    window.parent.parent.CopySharedDashboard(entityid);
}

function Delete() {
    LayerConfirmOk("删除操作将不能恢复，是否继续?", "确定", "取消", function () {
        requestData("/Tools/DashboardAjax.ashx?act=DeleteShareDashboard&id=" + entityid, null, function (data) {
            window.location.reload();
        })
    })
}
$(function () {
    $("#goBack").parent().hide();
})