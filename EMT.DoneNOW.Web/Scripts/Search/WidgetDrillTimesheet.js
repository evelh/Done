$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();




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
function ApproveSelect() {
    var cnt = 0;
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            if ($(this).val() != "") {
                ids += $(this).val() + ',';
                cnt++;
            }
        }
    });
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
        requestData("../Tools/TimesheetAjax.ashx?act=approve&ids=" + ids, null, function (data) {
            if (data == cnt) {
                window.location.reload();
                LayerMsg("审批成功！");
            } else if (data == 0) {
                LayerMsg("审批失败，请重新查看待审批数据！");
            } else {
                window.location.reload();
                LayerMsg("部分审批成功！");
            }
        })
    } else {
        alert("请选择需要审批的数据！");
    }
}

function ApproveSingle() {
    requestData("../Tools/TimesheetAjax.ashx?act=approve&ids=" + entityid, null, function (data) {
        if (data==1) {
            window.location.reload();
            LayerMsg("审批成功！");
        } else if (data == 0) {
            LayerMsg("审批失败，请重新查看待审批数据！");
        } else {
            window.location.reload();
            LayerMsg("部分审批成功！");
        }
    })
}
var isSingle = "1";
function RejectSelect() {
    isSingle = "";
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            if ($(this).val() != "") {
                ids += $(this).val() + ',';
            }
        }
    });
    if (ids != "") {
        $("#BackgroundOverLay").show();
        $("#RefuseExpenseReport").show();
    } else {
        alert("请选择需要审批的数据！");
    }
}

function RejectSingle() {
    isSingle = "1";
    $("#BackgroundOverLay").show();
    $("#RefuseExpenseReport").show();
}



$("#rejectButton").click(function () {
    var rejectReason = $("#rejectReason").val();
    if ($.trim(rejectReason) == "") {
        LayerMsg("请填写拒绝原因");
    } else {
        Reject();
    }
})
$("#CloseButton").click(function () {
    $("#BackgroundOverLay").hide();
    $("#RefuseExpenseReport").hide();
})
function Reject() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            if ($(this).val() != "") {
                ids += $(this).val() + ',';
            }
        }
    });
    if (ids != "" || entityid != "") {
        $("#RefuseExpenseReport").hide();
        $("#LoadingIndicator").show();
        var rejectReason = $("#rejectReason").val();
        if (isSingle == "") {
            ids = ids.substring(0, ids.length - 1);
        }
        else if (isSingle == "1") {
            ids = entityid;
        }


        requestData("../Tools/TimesheetAjax.ashx?act=reject&ids=" + ids + "&reason=" + rejectReason, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("拒绝失败！");
                $("#BackgroundOverLay").hide();
                $("#RefuseExpenseReport").hide();
                $("#LoadingIndicator").hide();
            }
        })
    } else {
        LayerMsg("请先选择工时报表");
        $("#BackgroundOverLay").hide();
        $("#RefuseExpenseReport").hide();
    }
}

function ShowDetail() {
    if (entityid != "") {
        requestData("../Tools/TimesheetAjax.ashx?act=timesheetInfo&id=" + entityid, null, function (data) {
            window.location.href = "SearchBodyFrame.aspx?cat=1633&type=219&con2738=" + data[0] + "&con2739=" + data[1] + "&param1=" + data[2];
        })
    }
}

function SubmitSingle() {
    if (resId != "" && startDate != "") {
        requestData("../Tools/TimesheetAjax.ashx?act=submit&resId=" + resId + "&startDate=" + startDate, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                 
                LayerMsg("已审批和已提交工时表不能提交");
            }
        })
    }
    else {
        LayerMsg("未获取到相关信息！");
    }
}

function SubmitSelect() {
    var myArray = new Array();
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            if ($(this).val() == "") {
                var thisResId = $(this).parent().parent().find(".9285").eq(0).val();
                var thisSatrtDate = $(this).parent().parent().find(".9286").eq(0).val();
                if (thisResId != "" && thisSatrtDate != "") {
                    myArray.push(thisResId + "_" + thisSatrtDate);
                }
            }
        }
    });
    if (myArray.length > 0) {
        requestData("../Tools/TimesheetAjax.ashx?act=SubmitManySheet&Array=" + JSON.stringify(myArray)  , null, function (data) {
            if (data == true) {
                LayerMsg("提交成功！");
                setTimeout(function () { window.location.reload(); }, 800);
            } else {
                //LayerMsg("部分工时表提交失败");
                setTimeout(function () { window.location.reload(); }, 800);
            }
        })
    }
    
}


var entityid;
var menu = document.getElementById("menu");
var menu_i2_right = document.getElementById("menu-i2-right");
var Times = 0;
var resId = "";
var startDate = "";

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

    $("#AppSinMenu").hide();
    $("#RejSinMenu").hide();
    $("#SubSinMenu").hide();
    $("#SinDetailMenu").hide();
    //$("#AppSelMenu").hide();
    //$("#RejSelMenu").hide();
    //$("#SubSelMenu").hide();
    resId = $(this).find(".9285").eq(0).val();
    startDate = $(this).find(".9286").eq(0).val();
    


    if (entityid != "") {
        $("#AppSinMenu").show();
        $("#RejSinMenu").show();
        $("#SinDetailMenu").show();
        //$("#AppSelMenu").show();
        //$("#RejSelMenu").show();
    }
    else {
        $("#SubSinMenu").show();
        //$("#SubSelMenu").show();
    }

    return false;
});

