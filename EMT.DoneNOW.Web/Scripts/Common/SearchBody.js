
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
    
    return false;
});

document.onclick = function () {
    menu.style.display = "none";
}

function OpenWindow(winname,target) {
    window.open(winname, target, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
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
//在合同审批时，弹出日期选择窗口
var postdate;
var postcancel;
function Post_date() {
    var mask = $('<div id="BackgroundOverLay">' + '</div>');
    var AddText = $(
        '<div class="addText">' +
        '<div>' +
        '<div class="CancelDialogButton"></div>' +
        '<div class="TitleBar">' +
        '<div class="Title">' +
        '<span class="text1">提交日期</span>' +
        '</div>' +
        '</div>' +
        '<form action="" method="post" >' +
        '<div class="ButtonContainer">' +
        '<ul>' +
        '<li class="Button addButtonIcon Okey" id="approvePostButton" tabindex="0">' +
        '<span class="Icon" style="width: 0;margin: 0;"></span>' +
        '<span class="Text">审批并提交</span>' +
        '</li>' +
        '</ul>' +
        '</div>' +
        '<div class="DivSection" style="border:none;padding-left:0;">' +
        '<table width="100%" border="0" cellspacing="0" cellpadding="0">' +
        '<tbody>' +
        '<tr>' +
        '<td width="30%" class="FieldLabels">' +
        '<div style="padding-bottom: 10px;">' +
        '请选择提交日期' +
        '</div>' +
        '</td>' +
        '</tr>' +
        '<tr>' +
        '<td width="30%" class="FieldLabels">' +
        'Posted Date' + '<span class="errorSmall">*</span>' +
        '<div>' +
        '<input id="post_datett" type="text" onclick="WdatePicker()" class="Wdate" style="width:150px;">' +
        '</div>' +
        '</td>' +
        '</tr>' +
        '</tbody>' +
        '</table>' +
        '</div>' +
        '</form>' +
        '</div>' +
        '</div>');
    $('body').prepend(AddText).prepend(mask);
    //提交
    $("#approvePostButton").on("click", function () {
        var k = $("#post_datett").val();
        if (k == null || k == '') {
            alert("请选择提交日期！");
            return false;
        }
        k = k.replace(/[^0-9]+/g, '');
        postdate = k;
        postcancel = 0;
        AddText.remove();
        mask.remove();
        return postdate;
    })
    //关闭
    $(".CancelDialogButton").on("click", function () {
        postcancel =1;
        AddText.remove();
        mask.remove();
        return postcancel;
    })
}