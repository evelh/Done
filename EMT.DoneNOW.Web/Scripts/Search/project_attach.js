$(function () {
    $(".General").hide();
    $("#PrintLi").show();
})

function Add() {
    var project_id = $("#id").val();
    if (project_id != "") {
        window.open("../Activity/AddAttachment.aspx?objId=" + project_id + "&objType=713", windowObj.projectAttach + windowType.add, 'left=200,top=200,width=1080,height=800', false);
    }
}

function View(id) {
    window.open("../Activity/OpenAttachment.aspx?id=" + entityid, windowObj.projectAttach + windowType.view, 'left=200,top=200,width=1080,height=800', false);
}

function Delete() {
    LayerConfirm("删除不能恢复，是否继续？", "是", "否", function () {
        $.ajax({
            type: "GET",
            url: "../Tools/AttachmentAjax.ashx?act=DeleteAttachment&id=" + entityid,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data == "true") {
                    LayerMsg("删除成功");
                }
                history.go(0);
            }
        })
    }, function () { });
}

