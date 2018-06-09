$(function () {
    $(".General").hide();
})
function Add() {
    window.open('../SysSetting/TimeApproval', windowObj.resourceApproval + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=600', false);
}

function Edit() {
    window.open("../SysSetting/TimeApproval.aspx?resId=" + entityid, windowObj.resourceApproval + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=600', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/ResourceAjax.ashx?act=DeleteApproval&resId=" + entityid,
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