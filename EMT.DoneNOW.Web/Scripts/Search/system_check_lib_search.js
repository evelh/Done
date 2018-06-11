$(function () {
    $(".General").hide();
})
function Add() {
    window.open('../SysSetting/CheckListLibrary', windowObj.CheckListLibrary + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=700', false);
}

function Edit() {
    window.open("../SysSetting/CheckListLibrary.aspx?id=" + entityid, windowObj.CheckListLibrary + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=700', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/GeneralAjax.ashx?act=DeleteCheckLib&id=" + entityid,
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
function Copy() {
    $.ajax({
        type: "GET",
        url: "../Tools/GeneralAjax.ashx?act=CopyCheckLib&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("复制成功！");
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
        url: "../Tools/GeneralAjax.ashx?act=ActiveCheckLib&isActive=1&id=" + entityid,
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
        url: "../Tools/GeneralAjax.ashx?act=ActiveCheckLib&id=" + entityid,
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
        url: "../Tools/GeneralAjax.ashx?act=CheckLibInfo&id=" + entityid,
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