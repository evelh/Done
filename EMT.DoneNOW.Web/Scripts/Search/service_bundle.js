

// 新增
function Add() {
    window.open("../SysSetting/ServiceBundle.aspx", windowObj.serviceBundle + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
// 编辑
function Edit() {
    window.open("../SysSetting/ServiceBundle.aspx?id=" + entityid, windowObj.serviceBundle + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
// 点击行进行编辑
function View(id) {
    window.open("../SysSetting/ServiceBundle.aspx?id=" + id, windowObj.serviceBundle + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
// 激活服务
function Active() {
    $.ajax({
        type: "GET",
        async: false,
        dataType: "json",
        url: "../Tools/ServiceAjax.ashx?act=ActiveService&service_id=" + entityid + "&is_active=1&is_bundle=1",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    LayerMsg("激活服务包成功！");
                }
                else {
                    LayerMsg(data.reason);
                }
            }
        },
    });
    setTimeout(function () { history.go(0); }, 800)
}
// 停用相关服务
function InActive() {
    $.ajax({
        type: "GET",
        async: false,
        dataType: "json",
        url: "../Tools/ServiceAjax.ashx?act=ActiveService&service_id=" + entityid +"&is_bundle=1",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    LayerMsg("停用服务包成功！");
                }
                else {
                    LayerMsg(data.reason);
                }
            }
        },
    });
    setTimeout(function () { history.go(0); }, 800)
}
function DeleteServiceBundle() {

    if (confirm("删除后无法恢复，是否继续?")) {
        $.ajax({
            type: "GET",
            async: false,
            dataType: "json",
            url: "../Tools/ServiceAjax.ashx?act=DeleteService&service_id=" + entityid + "&is_bundle=1",
            success: function (data) {
                if (data != "") {
                    if (data.result) {
                        LayerMsg("删除服务包成功！");
                    }
                    else {
                        alert("服务包不能被删除，因为它被以下对象引用：\n" + data.reason);
                    }
                }
            },
        });
        setTimeout(function () { history.go(0); }, 800);

    }
    //LayerConfirm("删除后无法恢复，是否继续?", "是", "否", function () {
    //    $.ajax({
    //        type: "GET",
    //        async: false,
    //        dataType: "json",
    //        url: "../Tools/ServiceAjax.ashx?act=DeleteService&service_id=" + entityid +"&is_bundle=1",
    //        success: function (data) {
    //            if (data != "") {
    //                if (data.result) {
    //                    LayerMsg("删除服务包成功！");
    //                }
    //                else {
    //                    alert("服务包不能被删除，因为它被以下对象引用：\n" + data.reason);
    //                }
    //            }
    //        },
    //    });
    //    setTimeout(function () { history.go(0); }, 800);
    //}, function () { });
}

function RightClickFunc() {
    $.ajax({
        type: "GET",
        async: false,
        dataType: "json",
        url: "../Tools/ServiceAjax.ashx?act=service_bundle&service_bundle_id=" + entityid,
        success: function (data) {
            if (data != "") {
                if (data.is_active == "1") {
                    $("#InActSer").show();
                    $("#ActSer").hide();
                }
                else {
                    $("#ActSer").show();
                    $("#InActSer").hide();
                }
            }
        },
        error: function () {
            $("#ActSer").hide();
            $("#InActSer").hide();
        },
    });
    ShowContextMenu();
}



