function Add() {
    window.open("../Activity/Todos.aspx", windowObj.todos + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function Edit() {
    window.open("../Activity/Todos.aspx?id=" + entityid, windowObj.todos + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function SetScheduled() {

}
function ViewCompany() {
    window.open('../Company/ViewCompany.aspx?src=com_activity&id=' + entityid, '_blank', 'left=200,top=200,width=1200,height=1000', false);
}
function Delete() {
    LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/ActivityAjax.ashx?act=Delete&id=" + entityid, null, function (data) {
            if (data == true) {
                LayerAlert("删除成功", "确定", function () {
                    window.location.reload();
                })
            }
            else {
                LayerMsg("删除失败");
            }
        })
    }, function () { })
}
function FinishTodo() {

}

$(".dn_tr").unbind('contextmenu').bind("contextmenu", function (event) {
    clearInterval(Times);
    var oEvent = event;
    entityid = $(this).data("val");
    (function () {
        menu.style.display = "block";
        Times = setTimeout(function () {
            menu.style.display = "none";
        }, 1000);
    }());
    menu.onmouseenter = function () {
        clearInterval(Times);
        menu.style.display = "block";
    };
    menu.onmouseleave = function () {
        Times = setTimeout(function () {
            menu.style.display = "none";
        }, 1000);
    };
    var Top = $(document).scrollTop() + oEvent.clientY;
    var Left = $(document).scrollLeft() + oEvent.clientX;
    var winWidth = window.innerWidth;
    var winHeight = window.innerHeight;
    var menuWidth = menu.clientWidth;
    var menuHeight = menu.clientHeight;
    var scrLeft = $(document).scrollLeft();
    var scrTop = $(document).scrollTop();
    var clientWidth = Left + menuWidth;
    var clientHeight = Top + menuHeight;
    if (winWidth < clientWidth) {
        menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
    } else {
        menu.style.left = Left + "px";
    }
    if (winHeight < clientHeight) {
        menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
    } else {
        menu.style.top = Top + "px";
    }

    requestData("../Tools/ActivityAjax.ashx?act=CheckIsNote&id=" + entityid, null, function (data) {
        if (data == true) {
            var txt = "<ul style='width:220px;'>";
            txt += "<li onclick='Edit()'><i class='menu-i1'></i>修改待办（备注）</li>";
            txt += "<li onclick='SetScheduled()'><i class='menu-i1'></i>set scheduled</li>";
            txt += "<li onclick='ViewCompany()'><i class='menu-i1'></i>查看客户</li>";
            txt += "<li onclick='Delete()'><i class='menu-i1'></i>删除待办（备注）</li>";
            $("#menu").html(txt);
        } else {
            var txt = "<ul style='width:220px;'>";
            txt += "<li onclick='Edit()'><i class='menu-i1'></i>修改待办</li>";
            txt += "<li onclick='FinishTodo()'><i class='menu-i1'></i>完成待办</li>";
            txt += "<li onclick='ViewCompany()'><i class='menu-i1'></i>查看客户</li>";
            txt += "<li onclick='Delete()'><i class='menu-i1'></i>删除待办</li>";
            $("#menu").html(txt);
        }
    });

    return false;
});