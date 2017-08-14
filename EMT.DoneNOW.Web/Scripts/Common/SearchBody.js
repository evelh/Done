
var entityid;
var menu = document.getElementById("menu");
var menu_i2_right = document.getElementById("menu-i2-right");
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
    var Top = $(document).scrollTop() + oEvent.clientY;
    var Left = $(document).scrollLeft() + oEvent.clientX;
    var winWidth = window.innerWidth;
    var winHeight = window.innerHeight;
    var menuWidth = menu.clientWidth; 
    var menuHeight = menu.clientHeight;
    var rightWidth = menu_i2_right.clientWidth;
    var rightHeight = menu_i2_right.clientHeight;
    var clientWidth = Left + menuWidth;
    var clientHeight = Top + menuHeight;
    var clientWidth_2 = Left + rightWidth;
    var clientHeight_2 = Top + rightHeight;
    if (winWidth < clientWidth) {
        menu.style.left = winWidth - menuWidth - 18 + "px";
        menu_i2_right.style.left =  - menuWidth + 70+ "px";
    } else {
        menu.style.left = Left + "px";
        menu_i2_right.style.left = "";
    }
    if (winHeight < clientHeight) {
        menu.style.top = winHeight - menuHeight - 18 + "px";
        menu_i2_right.style.top = winHeight - menuHeight*2 - 29 + "px";
    } else {
        menu.style.top = Top + "px";
        menu_i2_right.style.top = winHeight - menuHeight*2 +46 + "px";
    }
    
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

function ChangePageSize(num) {
    $("#page_size").val(num);
    $("#form1").submit();
}

function ChangePage(num) {
    $("#page_num").val(num);
    $("#form1").submit();
}

$(".page input").blur(function () {
    var page = $(this).val();
    var crtpage = $("#page_num").val();
    if (page == crtpage)
        return;
    ChangePage(page);
});

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
