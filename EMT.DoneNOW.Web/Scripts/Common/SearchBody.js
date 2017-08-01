
var entityid;
var menu = document.getElementById("menu");
var Times = 0;

$(".dn_tr").bind("contextmenu", function (event) {
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
    var Top = $(document).scrollTop() + oEvent.clientY
    var Left = $(document).scrollLeft() + oEvent.clientX
    menu.style.top = Top + "px";
    menu.style.left = Left + "px";
    return false;
});

document.onclick = function () {
    menu.style.display = "none";
}

function OpenWindow(winname) {
    window.open(winname, 'new', 'left=200,top=200,width=900,height=750', false);
    //window.open(winname, "_blank", "toolbar=yes, location=yes,directories=no,status=no, menubar=yes, scrollbars=yes,resizable=no, copyhistory=yes, width=600, height=600,top=150,left=300")
}

//实现点击document，自定义菜单消失
document.onclick = function () {
    menu.style.display = "none";
}

// 修改排序列
function ChangeOrder(para) {
    var order = $("#order").val();
    var orderStr = order.split(" ");
    if (para == orderStr[0]) {
        if (orderStr[1] == "asc")
            $("#order").val(para + " desc");
        else
            $("#order").val(para + " asc");
    } else {
        $("#order").val(para + " asc");
    }
    $("#form1").submit();
}
