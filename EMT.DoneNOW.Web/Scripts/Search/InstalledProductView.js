function Edit() {
    window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + entityid, windowObj.configurationItem + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
// 激活单个配置项
function ActiveIProduct() {
    $.ajax({
        type: "GET",
        url: "../Tools/ProductAjax.ashx?act=ActivationIP&iProduct_id=" + entityid,
        async: false,
        success: function (data) {
            if (data == "ok") {
                alert('激活成功');
                history.go(0);
            } else if (data == "no") {
                alert('该报价项已经激活');
            }
            else {

            }

        }
    })
}
// 批量激活配置项
function ActiveIProducts() {

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
            url: "../Tools/ProductAjax.ashx?act=ActivationIPs&iProduct_ids=" + ids,
            success: function (data) {
                if (data == "ok") {
                    alert('批量激活成功！');
                }
                else if (data == "error") {
                    alert("批量激活失败！");
                }
                history.go(0);
            }
        })
    }

}
// 停用配置项
function NoActiveIProduct() {
    $.ajax({
        type: "GET",
        url: "../Tools/ProductAjax.ashx?act=NoActivationIP&iProduct_id=" + entityid,
        async: false,
        success: function (data) {
            if (data == "ok") {
                alert('停用成功');
                history.go(0);
            } else if (data == "no") {
                alert('该配置项已经停用');
            }
            else {

            }

        }
    })
}
// 批量停用配置项
function NoActiveIProducts() {

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
            url: "../Tools/ProductAjax.ashx?act=NoActivationIPs&iProduct_ids=" + ids,
            success: function (data) {
                if (data == "ok") {
                    alert('批量停用成功！');
                }
                else if (data == "error") {
                    alert("批量停用失败！");
                }
                history.go(0);
            }
        })
    }

}
// 删除配置项
function DeleteIProduct() {
    if (confirm("删除后无法恢复，是否继续?")) {
        $.ajax({
            type: "GET",
            url: "../Tools/ProductAjax.ashx?act=deleteIP&iProduct_id=" + entityid,
            success: function (data) {

                if (data == "True") {
                    alert('删除成功');
                } else if (data == "False") {
                    alert('删除失败');
                }
                history.go(0);
            }
        })
    }

}
// 批量删除配置项
function DeleteIProducts() {
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
            url: "../Tools/ProductAjax.ashx?act=deleteIPs&iProduct_ids=" + ids,
            success: function (data) {

                if (data == "True") {
                    alert('批量删除成功');
                } else if (data == "False") {
                    alert('批量删除失败');
                }
                history.go(0);
            }
        })
    }

}
// 全选/全不选
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

function View(jdgshdfghsdfgsl) {

}

function Add() {
    var url = "../ConfigurationItem/AddOrEditConfigItem.aspx";
    var account_id = $("input[name = 'con358']").val();
    if (account_id != undefined && account_id != "") {
        url += "?account_id=" + account_id;
    }
    window.open(url, windowObj.configurationItem + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
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
        $("#ActiveChoose").css("color", "grey");
        $("#NoActiveChoose").css("color", "grey");
        $("#ActiveChoose").removeAttr('onclick');
        $("#NoActiveChoose").removeAttr('onclick');

    } else {
        $("#ActiveChoose").css("color", "");
        $("#NoActiveChoose").css("color", "");
        $("#ActiveChoose").click(function () {
            ActiveIProducts();
        })
        $("#NoActiveChoose").click(function () {
            NoActiveIProducts();
        })
    }
    var isHasContract = "";  // 该配置项是否有合同
    var isReview = "";       // 该配置项是否需要合同审核
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=GetInsProInfo&insProId=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data != "") {
                if (data.contract_id != "" && data.contract_id != undefined && data.contract_id != null) {
                    isHasContract = "1";
                }
                if (data.reviewed_for_contract == "1") {
                    isReview = "1";
                }
                if (data.is_active =="1") {
                    $("#ActiveThis").css("color", "grey");
                    $("#NoActiveThis").css("color", "");
                    $("#ActiveThis").removeAttr('onclick');

                    $("#NoActiveThis").click(function () {
                        NoActiveIProduct();
                    })
                }
                else if (data.is_active == "0") {
                    $("#ActiveThis").css("color", "");
                    $("#NoActiveThis").css("color", "grey");

                    $("#NoActiveThis").removeAttr('onclick');

                    $("#ActiveThis").click(function () {
                        ActiveIProduct();
                    })
                }
            }
        },
    });

    if (isHasContract != "") {
        $("#ReViewByContractMenu").hide();
        $("#NoReViewByContractMenu").hide();
    }
    else {
        if (isReview == "1") {
            $("#NoReViewByContractMenu").show();
            $("#ReViewByContractMenu").hide();
        }
        else {
            $("#NoReViewByContractMenu").hide();
            $("#ReViewByContractMenu").show();
        }
    }

    return false;
});


function Copy() {
    window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + entityid + "&isCopy=1", windowObj.configurationItem + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}


function Swap() {
    window.open("../ConfigurationItem/SwapConfigItemWizard.aspx?insProId=" + entityid, 'SwapInsPro', 'left=200,top=200,width=1080,height=800', false);
}

function NewTicket() {
    window.open("../ServiceDesk/TicketManage?insProId=" + entityid, windowType.ticket + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}

function ReViewByContract() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=ReviewInsPro&insProId=" + entityid + "&isView=1",
        dataType: 'json',
        success: function (data) {
            history.go(0);
        },
    });
}

function NoReViewByContract() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=ReviewInsPro&insProId=" + entityid,
        dataType: 'json',
        success: function (data) {
            history.go(0);
        },
    });
}

function ReViewByContractSelect() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    })
    if (ids != "") {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProductAjax.ashx?act=ReviewInsPro&insProId=" + ids + "&isView=1",
            dataType: 'json',
            success: function (data) {
                history.go(0);
            },
        });
    }
}

function NoReViewByContractSelect() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    })
    if (ids != "") {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProductAjax.ashx?act=ReviewInsPro&insProId=" + ids,
            dataType: 'json',
            success: function (data) {
                history.go(0);
            },
        });
    }
}