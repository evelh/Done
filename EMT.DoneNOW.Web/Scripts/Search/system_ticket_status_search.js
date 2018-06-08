$(function () {
    $(".General").hide();
})
function Add() {
    window.open('../General/GeneralManage?tableId=135', windowObj.general + windowType.add, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function Edit() {
    window.open("../General/GeneralManage.aspx?id=" + entityid, windowObj.general + windowType.edit, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&GT_id=135&id=" + entityid,
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
                LayerMsg("失活成功");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}
function SetLogo() {
    window.open('../SysSetting/LogoManage?id=' + entityid, windowObj.logo + windowType.add, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function RightClickFunc() {
    
    $("#ActiveLi").hide();
    $("#InActiveLi").hide();
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
                if (data.is_system == "1") {
                    $("#DeleteLi").hide();
                }
            }

        },
    });
    ShowContextMenu();
}