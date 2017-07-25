
var entityid;
var menu = document.getElementById("menu");

function OpenConMenu(event,id) {
    entityid = id;
    var oEvent = event;
    menu.style.display = "block";
    var Top = $(document).scrollTop() + oEvent.clientY
    var Left = $(document).scrollLeft() + oEvent.clientX
    menu.style.top = Top + "px";
    menu.style.left = Left + "px";
    return false;
}

$(".dn_tr").bind("contextmenu", function (event) {
    var oEvent = event;
    entityid = $(this).data("val");
    menu.style.display = "block";
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
    window.open(winname, "_blank", "toolbar=yes, location=yes,directories=no,status=no, menubar=yes, scrollbars=yes,resizable=no, copyhistory=yes, width=600, height=600,top=150,left=300")
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

// 打开窗口查看实体
function OpenNewWindow(id) {

}