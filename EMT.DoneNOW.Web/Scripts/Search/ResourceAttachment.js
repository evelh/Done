$("#noData").hide(); $("#SelectLi").hide();
function Add() {
    window.open('../Activity/AddAttachment?objId=' + $("input[name='con2680']").val() + '&objType=708', windowObj.attachment, 'left=200,top=200,width=730,height=750', false);
}
function Delete(id) {
    requestData("/Tools/ResourceAjax.ashx?act=DeleteAttachment&id=" + id, null, function (data) {
        if (data == true) {
            window.location.reload();
        }
    })
}