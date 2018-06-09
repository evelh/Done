$(function () {
    $(".General").hide();
})
function Add() {
    window.open('../ServiceDesk/QueueManage', windowObj.queue + windowType.add, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function Edit() {
    window.open("../ServiceDesk/QueueManage.aspx?id=" + entityid, windowObj.queue + windowType.edit, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/DepartmentAjax.ashx?act=DeleteQueue&type=expense&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    LayerMsg("删除成功！");
                    setTimeout(function () { history.go(0); }, 800);
                }
                else {
                    LayerMsg("删除失败！"+data.reason);
                }
            }
        }
    })
}


function Active() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/DepartmentAjax.ashx?act=ActiveQueue&isActive=1&id=" + entityid ,
        dataType: 'json',
        success: function (data) {
            if (data) {
                LayerMsg("激活成功");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}

function InActive() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/DepartmentAjax.ashx?act=ActiveQueue&id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data) {
                LayerMsg("失活成功");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}
function RightClickFunc() {
    $("#ActiveLi").hide();
    $("#InActiveLi").hide();
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/DepartmentAjax.ashx?act=QueueInfo&id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data != "") {
                if (data.is_active == "1") {
                    $("#InActiveLi").show();
                }
                else {
                    $("#ActiveLi").show();
                }
            }
            
        },
    });
    ShowContextMenu();
}