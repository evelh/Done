function Add() {
    if ($("#param1").val() == "") {
        window.open("../Activity/Todos.aspx", windowObj.todos + windowType.add, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
    } else {
        window.open("../Activity/Todos.aspx?" + $("#param1").val() + "=" + $("#param2").val(), windowObj.todos + windowType.add, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
    }
}
function Edit() {
    window.open("../Activity/Todos.aspx?id=" + entityid, windowObj.todos + windowType.edit, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}
function EditNote() {
    window.open("../Activity/Notes.aspx?id=" + entityid, windowObj.notes + windowType.edit, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}
function ViewCompany() {
    window.open('../Company/ViewCompany.aspx?src=com_activity&id=' + entityid, '_blank', 'left=200,top=200,width=1200,height=1000', false);
}
function ViewOpportunity(id) {
    window.open('../Opportunity/ViewOpportunity.aspx?id=' + id, '_blank', 'left=200,top=200,width=1200,height=1000', false);
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
function SetScheduled() {
    requestData("../Tools/ActivityAjax.ashx?act=NoteSetScheduled&id=" + entityid, null, function (data) {
        window.location.reload();
    })
}
function FinishTodo() {
    requestData("../Tools/ActivityAjax.ashx?act=TodoComplete&id=" + entityid, null, function (data) {
        window.location.reload();
    })
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

    requestData("../Tools/ActivityAjax.ashx?act=CheckTodo&id=" + entityid, null, function (data) {
        var txt = "<ul style='width:220px;'>";
        if (data[0] == "1") {
            txt += "<li onclick='EditNote()'><i class='menu-i1'></i>修改待办（备注）</li>";
            txt += "<li onclick='SetScheduled()'><i class='menu-i1'></i>转为待办</li>";
            txt += "<li onclick='Delete()'><i class='menu-i1'></i>删除待办（备注）</li>";
        } else {
            txt += "<li onclick='Edit()'><i class='menu-i1'></i>修改待办</li>";
            txt += "<li onclick='FinishTodo()'><i class='menu-i1'></i>完成待办</li>";
            txt += "<li onclick='Delete()'><i class='menu-i1'></i>删除待办</li>";
        }
        txt += "<li onclick='ViewCompany()'><i class='menu-i1'></i>查看客户</li>";
        if (data[1] != "0")
            txt += "<li onclick='ViewOpportunity(" + data[1] + ")'><i class='menu-i1'></i>查看商机</li>";
        $("#menu").html(txt);
    });

    return false;
});