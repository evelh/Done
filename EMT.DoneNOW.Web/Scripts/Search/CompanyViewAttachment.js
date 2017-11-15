function Add() {
    window.open('../Activity/AddAttachment?objId=' + $("#param2").val() + '&objType=' + $("#param1").val(), windowObj.attachment + windowType.add, 'left=200,top=200,width=730,height=750', false);
}
function Delete() {
    LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/AttachmentAjax.ashx?act=DeleteAttachment&id=" + entityid, null, function (data) {
            window.location.reload();
        })
    }, function () { })
}