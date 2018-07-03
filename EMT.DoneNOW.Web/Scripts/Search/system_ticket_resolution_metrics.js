$(function () {
    $(".General").hide();
})

function Edit() {
    window.open("../General/GeneralManage.aspx?id=" + entityid, windowObj.general + windowType.edit, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function Active() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/GeneralAjax.ashx?act=ActiveGeneral&isActive=1&id=" + entityid,
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
        url: "../Tools/GeneralAjax.ashx?act=ActiveGeneral&id=" + entityid,
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
    $("#DeleteLi").hide();
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/GeneralAjax.ashx?act=general&id=" + entityid,
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