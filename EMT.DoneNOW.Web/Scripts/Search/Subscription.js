$("#CheckAll").click(function () {
    if ($(this).is(":checked")) {
        $(".IsChecked").prop("checked", true);
        $(".IsChecked").css("checked", "checked");
    }
    else {
        $(".IsChecked").prop("checked", false);
        $(".IsChecked").css("checked", "");
    }
})
function Edit() {
    window.open("../ConfigurationItem/SubscriptionAddOrEdit.aspx?id=" + entityid, windowObj.subscription + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function CancelSubscription() {

    if (confirm("你选择取消此订阅,将导致该订阅的所有未计费项被立即取消,通常在该客户永久注销的前提下操作, 该操作无法恢复确定无论如何都要取消此订阅?")) {
        $.ajax({
            type: "GET",
            url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=2&sid=" + entityid,
            async: false,
            success: function (data) {
                if (data == "ok") {
                    alert('取消成功');
                    history.go(0);
                } else if (data == "Already") {
                    alert('已经取消');
                }
                else {
                    alert("取消失败");
                }

            }
        })
    }


}

function CancelSubscriptions() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
        $.ajax({
            type: "GET",
            url: "../Tools/SubscriptionAjax.ashx?act=activeSubscripts&status_id=2&sids=" + ids,
            async: false,
            success: function (data) {
                if (data == "True") {
                    alert("批量取消成功");
                }
                else {
                    alert("批量取消失败");
                }
                history.go(0);

            }
        })
    }

}

function ActiveSubscription() {
    $.ajax({
        type: "GET",
        url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=1&sid=" + entityid,
        async: false,
        success: function (data) {
            if (data == "ok") {
                alert('激活成功');
                history.go(0);
            } else if (data == "Already") {
                alert('已经激活');
            }
            else {
                alert("激活失败");
            }

        }
    })
}
function NoActiveSubscription() {

    if (confirm("你选择注销(搁置)此订阅,,该订阅的计费项将继续计费,该订阅的关联支持服务将被停止,该操作通常发生在客户发生欠费或者该客户的服务被暂停,你确定无法如何都要注销此订阅?")) {
        $.ajax({
            type: "GET",
            url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=0&sid=" + entityid,
            async: false,
            success: function (data) {
                if (data == "ok") {
                    alert('停用成功');
                    history.go(0);
                } else if (data == "Already") {
                    alert('已经停用');
                }
                else {
                    alert("停用失败");
                }

            }
        })
    }

}

function DeleteSubscription() {
    $.ajax({
        type: "GET",
        url: "../Tools/SubscriptionAjax.ashx?act=deleteSubscriprion&sid=" + entityid,
        async: false,
        success: function (data) {
            if (data == "True") {
                alert('删除成功');

            }
            else {
                alert("删除失败");
            }
            history.go(0);
        }
    })
}
function DeleteSubscriptions() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
        $.ajax({
            type: "GET",
            url: "../Tools/SubscriptionAjax.ashx?act=deleteSubscriprions&sids=" + ids,
            async: false,
            success: function (data) {
                if (data == "True") {
                    alert("批量删除成功");
                }
                else {
                    alert("批量删除失败");
                }

            }
        })
    }

}
function View(jdgshdfghsdfgsl) {

}
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

    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    })

    if (ids == "") {
        $("#CancelSubscriptions").css("color", "grey");
        $("#DeleteSubscriptions").css("color", "grey");
        $("#CancelSubscriptions").removeAttr('onclick');
        $("#DeleteSubscriptions").removeAttr('onclick');

    } else {
        $("#CancelSubscriptions").css("color", "");
        $("#DeleteSubscriptions").css("color", "");
        $("#CancelSubscriptions").click(function () {
            CancelSubscriptions();
        })
        $("#DeleteSubscriptions").click(function () {
            DeleteSubscriptions();
        })
    }

    $.ajax({
        type: "GET",
        url: "../Tools/SubscriptionAjax.ashx?act=property&property=status_id&sid=" + entityid,
        async: false,
        success: function (data) {
            debugger;
            if (data == "1") {
                $("#CancelSubscription").css("color", "");
                $("#CancelSubscription").click(function () {
                    CancelSubscription();
                });
                $("#ActiveSubscription").css("color", "grey");
                $("#ActiveSubscription").removeAttr('onclick');
                $("#NoActiveSubscription").css("color", "");
                $("#NoActiveSubscription").click(function () {
                    NoActiveSubscription();
                })

            } else if (data == "0") {
                $("#CancelSubscription").css("color", "");
                $("#CancelSubscription").click(function () {
                    CancelSubscription();
                });
                $("#NoActiveSubscription").css("color", "grey");
                $("#NoActiveSubscription").removeAttr('onclick');
                $("#ActiveSubscription").css("color", "");
                $("#ActiveSubscription").click(function () {
                    ActiveSubscription();
                })
            } else if (data == "2") {
                $("#CancelSubscription").css("color", "grey");
                $("#CancelSubscription").removeAttr('onclick');
                $("#ActiveSubscription").css("color", "grey");
                $("#ActiveSubscription").removeAttr('onclick');
                $("#NoActiveSubscription").css("color", "grey");
                $("#NoActiveSubscription").removeAttr('onclick');
            }

        }
    })



    return false;
});