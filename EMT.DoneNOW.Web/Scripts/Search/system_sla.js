$(function () {
    $(".General").hide();
})
function Add() {
    window.open('../SLA/SLAManage', windowObj.sla + windowType.add, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function Edit() {
    window.open("../SLA/SLAManage.aspx?id=" + entityid, windowObj.sla + windowType.edit, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/SLAAjax.ashx?act=DeleteSLA&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    LayerMsg("删除成功！");
                }
                else {
                    LayerMsg("删除失败！" + data.result);
                }
                setTimeout(function () { history.go(0); }, 800);
            }

        }
    })
}
function Active() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/SLAAjax.ashx?act=ActiveSLA&active=1&id=" + entityid,
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
        url: "../Tools/SLAAjax.ashx?act=ActiveSLA&id=" + entityid,
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
        url: "../Tools/SLAAjax.ashx?act=GetSLA&id=" + entityid,
        dataType: 'json',
        success: function (data) {

            if (data != "") {
                if (data.is_active == "1") {
                    $("#InActiveLi").show();
                }
                else {
                    $("#ActiveLi").show();
                }
                if (data.is_default == "1") {
                    $("#DeleteLi").hide();
                } else {
                    $("#DeleteLi").show();
                }
            }

        },
    });
    ShowContextMenu();
}

