$(function () {
    $(".General").hide();
})
function Add() {
    window.open('../General/GeneralManage?tableId=7', windowObj.general + windowType.add, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function Edit() {
    window.open("../General/GeneralManage.aspx?id=" + entityid, windowObj.general + windowType.edit, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&GT_id=7&id=" + entityid,
        async: false,
        //dataType: "json",
        success: function (data) {
            if (data == "success") {
                LayerMsg("删除成功！");
                setTimeout(function () { history.go(0); }, 800);
            }
            else if (data == "system") {
                LayerMsg("删除失败！系统字段不能删除");
            }
            else {
                LayerMsg("删除失败！" + data);
            }
        }
    })
}

function RightClickFunc() {
    $("#DeleteLi").hide();
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/GeneralAjax.ashx?act=general&id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data != "") {
                if (data.is_system == "1") {
                    $("#DeleteLi").hide();
                }
                else {
                    $("#DeleteLi").show();
                }
            }

        },
    });
    ShowContextMenu();
}
