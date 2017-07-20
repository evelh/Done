var menu = document.getElementById("menu");
$("#searchcontent td").bind("contextmenu", function (ev) {
    /*
    var oEvent = ev || event;
    //自定义的菜单显示
    menu.style.display = "block";
    //让自定义菜单随鼠标的箭头位置移动
    var Top = $(document).scrollTop() + oEvent.clientY
    var Left = $(document).scrollLeft() + oEvent.clientX
    menu.style.top = Top + "px";
    menu.style.left = Left + "px";
    //return false阻止系统自带的菜单，
    */
    return false;
});

//实现点击document，自定义菜单消失
document.onclick = function () {
    //menu.style.display = "none";
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