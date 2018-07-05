$(function () {
    $(".General").hide();
})
function Add() {
    window.open('../SysSetting/ChangeBoardManage', windowObj.board + windowType.add, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function Edit() {
    window.open("../SysSetting/ChangeBoardManage.aspx?id=" + entityid, windowObj.board + windowType.edit, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/GeneralAjax.ashx?act=DeleteBoard&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    LayerMsg("删除成功！");
                }
            }
            setTimeout(function () {
                history.go(0);
            }, 800);
        }
    })
}


function Active() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/GeneralAjax.ashx?act=ActiveBoard&isActive=1&id=" + entityid,
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
        url: "../Tools/GeneralAjax.ashx?act=ActiveBoard&id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data) {
                LayerMsg("停用成功");
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
        url: "../Tools/GeneralAjax.ashx?act=BoardInfo&id=" + entityid,
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