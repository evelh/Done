$(function () {
    $(".General").hide();
})
function Add() {
    window.open('../Resource/Workgroup', windowObj.resourceWorkGroup + windowType.ad\, 'left=0,top=0,location=no,status=no,width=500,height=350', false);
}

function Edit() {
    window.open("../Resource/Workgroup.aspx?id=" + entityid, windowObj.resourceWorkGroup + windowType.edit, 'left=0,top=0,location=no,status=no,width=500,height=350', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/ResourceAjax.ashx?act=DeleteGroup&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("删除成功！");
            }
            setTimeout(function () { history.go(0); }, 800);
        }
    })

}