$(document).ready(function () {
    $("#SelectLi").hide();
})
function Disassociate() {
    LayerConfirm("您确定要解除此策略的员工吗？\r将此员工与该策略分离将导致系统重新计算员工姓名目前的假期余额（根据参加工作时间计算）。 你确定你要这么做吗？", "确定", "取消", function () {
        requestData("/Tools/TimeoffPolicyAjax.ashx?act=disassociateResource&id=" + entityid, null, function (data) {
            if (data == true) {
                window.location.reload();
            }
        })
    }, function () { })
}