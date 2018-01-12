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
// 新增
function Add() {
    window.open('../Contract/AddCharges.aspx?contract_id=' + $("#id").val(), windowObj.contractCharge + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
// 修改
function Edit() {
    window.open('../Contract/AddCharges.aspx?contract_id=' + $("#id").val() + '&id=' + entityid, windowObj.contractCharge + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
// 查看
function ViewCharge() {
    window.open('../Contract/ChargeDetails.aspx?id=' + entityid, windowObj.contractCharge + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
// 更改成本是否可计费
function ChangeIsbilled(isBilled) {
    $.ajax({
        type: "GET",
        url: "../Tools/ContractAjax.ashx?act=updateCost&isbill=" + isBilled + "&cost_id=" + entityid,
        async: false,
        success: function (data) {
            debugger;
            if (data == "ok") {
                alert('更改成功');
            } else if (data == "Already") {
                alert('计费无需更改');
            }
            else if (data == "404") {
                alert("成本丢失，请重新登陆查看");
            } else if (data == "billed") {
                alert("成本已经提交并审批，不可更改");
            }
            history.go(0);
        }
    })
}

function ChangeManyIsbilled(isBilled) {
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
            url: "../Tools/ContractAjax.ashx?act=updateCosts&isbill=" + isBilled + "&ids=" + ids,
            async: false,
            success: function (data) {
                if (data == "True") {
                    alert('批量更改成功');
                } else if (data == "False") {
                    alert('批量更改失败');
                }
                history.go(0);
            }
        })
    }
}

function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/ContractAjax.ashx?act=deleteCost&cost_id=" + entityid,
        async: false,
        dataType:"json",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    alert('删除成功');
                } else  {
                    alert('删除失败' + data.reason);
                }
               
            }
            history.go(0);
        }
    })
}

function ManyDelete() {
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
            url: "../Tools/ContractAjax.ashx?act=deleteCosts&ids=" + ids,
            async: false,
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
    debugger;
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    })
    
    if (ids == "") {
        $("#ChooseBilled").css("color", "grey");
        $("#ChooseNoBilled").css("color", "grey");
        $("#ChooseDelete").css("color", "grey");
        $("#ChooseBilled").removeAttr('onclick');
        $("#ChooseNoBilled").removeAttr('onclick');
        $("#ChooseDelete").removeAttr('onclick');

    } else {
        $("#ChooseBilled").css("color", "");
        $("#ChooseNoBilled").css("color", "");
        $("#ChooseDelete").css("color", "");
        $("#ChooseBilled").click(function () {
            ChangeManyIsbilled(1);
        })
        $("#ChooseNoBilled").click(function () {
            ChangeManyIsbilled(0);
        })
        $("#ChooseDelete").click(function () {
            ManyDelete();
        })
    }
    var isBillCharge = ""; // 判断这个成本是否是已经审批提交的成本
    var isBill = "";           // 这个成本是否可计费
    var costCodeId = "";         // 这个成本的物料代码
    $.ajax({
        type: "GET",
        url: "../Tools/ContractAjax.ashx?act=GetContractCost&cost_id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            isBillCharge = data.bill_status;
            isBill = data.is_billable;
            costCodeId = data.cost_code_id;
        }
    })
    debugger;
    if (isBillCharge == "1") {   // 代表成本时审批并提交
        $("#thisBilled").css("color", "grey");
        $("#thisBilled").removeAttr('onclick');
        $("#thisNoBilled").css("color", "grey");
        $("#thisNoBilled").removeAttr('onclick');
        $("#delete").css("color", "grey");
        $("#delete").removeAttr('onclick');
    } else {

        if (isBill == "1") {  // 代表成本已经是计费
            $("#thisBilled").css("color", "grey");
            $("#thisBilled").removeAttr('onclick');
            $("#thisNoBilled").css("color", "");
            $("#thisNoBilled").click(function () {
                ChangeIsbilled(0);
            });
        } else if (isBill == "0") {
            $("#thisNoBilled").css("color", "grey");
            $("#thisNoBilled").removeAttr('onclick');
            $("#thisBilled").css("color", "");
            $("#thisBilled").click(function () {
                ChangeIsbilled(1);
            });
        }

        if (costCodeId != "" && costCodeId != 1166 && costCodeId != 1167 && costCodeId != 1168) {
            $("#delete").css("color", "");
            $("#delete").click(function () {
                Delete();
            });
        }
        else {
            $("#delete").css("color", "grey");
            $("#delete").removeAttr('onclick');
        }

    }



    return false;
});
