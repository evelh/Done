$(function () {
    $(".General").hide();
    $("#PrintLi").show();
    $(".OrderTh").removeAttr("onclick");
    $("#menuUl").css("width", "280px");
    //$(".IsChecked").removeAttr("onclick");
    $(".CheckTd").click(function (event) {
        //debugger;
        //if ($(this).is(":checked")) {
        //    $(this).prop("checked",false);
        //}
        //else {
        //    $(this).prop("checked", true);
        //}
        //return false;
        event.stopPropagation(); // 不执行上一元素的事件，阻止冒泡事件
    });
    $(".CheckTd :last").remove();
})
// 新增成本
function AddCost() {
    var project_id = $("#id").val();
    if (project_id != "") {
        OpenWindow("../Contract/AddCharges.aspx?project_id=" + project_id, windowObj.contractCost + windowType.add);
    }
}
// 新增费用
function AddExpense() {
    var project_id = $("#id").val();
    if (project_id != "") {
        OpenWindow("../Project/ExpenseManage.aspx?project_id=" + project_id, windowObj.expense + windowType.add);
    }
}
// 检查是成本还是费用
function CheckIsCost(id) {
    var IsCost = "";
    $.ajax({
        type: "GET",
        url: "../Tools/ContractAjax.ashx?act=GetSinCost&cost_id=" + id,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                IsCost = "1";
            }
        }
    })
    if (IsCost != "") {
        return true;
    } else {
        return false;
    }
}
// 特殊命名，view代表修改
function View(id) {
    if (id != "" && id != undefined) {
        if (CheckIsCost(id)) {
            OpenWindow("../Contract/AddCharges.aspx?id=" + id, windowObj.contractCost + windowType.edit);

        } else {
            OpenWindow("../Project/ExpenseManage.aspx?id=" + id, windowObj.expense + windowType.edit);
        }
    }
   
}
function Edit() {
    if (CheckIsCost(entityid)) {
        OpenWindow("../Contract/AddCharges.aspx?id=" + entityid, windowObj.contractCost + windowType.edit);

    } else {
        OpenWindow("../Project/ExpenseManage.aspx?id=" + entityid, windowObj.expense + windowType.edit);
    }
}
// 查看详情
function ShowDetailes(){
    if (CheckIsCost(entityid)) {
        OpenWindow("../Contract/ChargeDetails.aspx?id=" + entityid, windowObj.contractCost + windowType.view);
    } else {
        OpenWindow("../Project/ExpenseDetail.aspx?id=" + entityid, windowObj.expense + windowType.view);
    }
}
// 获取当前页面中选中的id
function GetCheckIds(){
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ",";
        }
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length-1);
    }
    return ids;
}
// CheckAll
// IsChecked
$("#CheckAll").click(function () {
    if ($(this).is(":checked")) {
        $(".IsChecked").prop("checked",true);
    } else {
        $(".IsChecked").prop("checked", false);
    }
})
// 当前成本/费用设置为可计费
function SingBill() {
    if (CheckIsCost(entityid)) {
        ChangeIsbilled(1);
    } else {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=BillSingExp&isbill=1&exp_id=" + entityid,
            async: false,
            dataType:"json",
            success: function (data) {
                if (data != "") {
                    if (data.result == "False") {
                        LayerMsg(data.reason);
                    }
                }
                history.go(0);
            }
        })
    }
}
// 选中成本/费用设置为可计费
function ChooseBill() {
    var ids = GetCheckIds();
    if (ids != "") {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=BillExpense&isbill=1&ids=" + ids,
            async: false,
            //dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data == "True") {
                        LayerMsg("批量计费成功");
                    } else {
                        LayerMsg("批量计费失败");
                    }
                }
                history.go(0);
            }
        })
    }
  
}
// 当前成本/费用设置为不可计费
function SingNonBill() {
    if (CheckIsCost(entityid)) {
        ChangeIsbilled(0);
    } else {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=BillSingExp&cost_id=" + entityid,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result == "False") {
                        LayerMsg(data.reason);
                    }
                }
                history.go(0);
            }
        })
    }
}
// 选中成本/费用设置为不可计费
function ChooseNonBill() {
    var ids = GetCheckIds();
    if (ids != "") {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=BillExpense&ids=" + ids,
            async: false,
            //dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data == "True") {
                        LayerMsg("批量取消计费成功");
                    } else {
                        LayerMsg("批量取消计费失败");
                    }
                }
                history.go(0);
            }
        })
    }
}
// 删除当期成本/费用
function SingDelete() {
    debugger;
    if (CheckIsCost(entityid)) {
        $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=deleteCost&cost_id=" + entityid,
            async: false,
            success: function (data) {
                if (data == "True") {
                    alert('删除成功');
                } else if (data == "False") {
                    alert('删除失败');
                }
                history.go(0);
            }
        })
    } else {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=DeleteSinExp&exp_id=" + entityid,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result == "False") {
                        LayerMsg("删除失败" + data.reason);
                    } else {
                        LayerMsg("删除成功");
                    }
                }
                history.go(0);
            }
        })
    }

}
// 删除选中成本/费用
function ChooseDelete() {
    var ids = GetCheckIds();
    if (ids != "") {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=DeleteManyExp&ids=" + ids,
            async: false,
            //dataType: "json",
            success: function (data) {
                if (data != "True") {
                    LayerMsg("批量删除成功");
                } else {
                    LayerMsg("批量删除失败");
                }
                history.go(0);
            }
        })
    }
  
}

$("#SingDeleteMenu").click(function () {
    SingDelete();
})

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


$(".dn_tr").bind("contextmenu", function (event) {
    clearInterval(Times);
    var oEvent = event;
    entityid = $(this).data("val");
  
    var choIds = GetCheckIds();
    if (choIds != "") {
        $("#ChooseBillMenu").click(function () {
            ChooseBill();
        })
        $("#ChooseNonBillMenu").click(function () {
            ChooseNonBill();
        })
        $("#ChooseDeleteMenu").click(function () {
            ChooseDelete();
        })
        $("#ChooseBillMenu").css("color", "");
        $("#ChooseNonBillMenu").css("color", "");
        $("#ChooseDeleteMenu").css("color", "");
    }
    else {
        $("#ChooseBillMenu").removeAttr("onclick");
        $("#ChooseNonBillMenu").removeAttr("onclick");
        $("#ChooseDeleteMenu").removeAttr("onclick");
        $("#ChooseBillMenu").css("color", "grey");
        $("#ChooseNonBillMenu").css("color", "grey");
        $("#ChooseDeleteMenu").css("color", "grey");
    }

    if (CheckIsCost(entityid)) {  // 对成本进行校验
        $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=GetSinCost&cost_id=" + entityid,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.is_billable == "1") {
                        $("#SingNonBillMenu").click(function () {
                            SingNonBill();
                        })
                        $("#SingNonBillMenu").css("color", "");
                        $("#SingBillMenu").removeAttr("onclick");
                        $("#SingBillMenu").css("color", "grey");
                    }
                    else {
                        $("#SingBillMenu").click(function () {
                            SingBill();
                        })
                        $("#SingBillMenu").css("color", "");
                        $("#SingNonBillMenu").removeAttr("onclick");
                        $("#SingNonBillMenu").css("color", "grey");
                    }

                }
            }
        })
    }
    else {             // 对费用进行校验
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=GetSinExpense&exp_id=" + entityid,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.is_billable == "1") {
                        $("#SingNonBillMenu").click(function () {
                            SingNonBill();
                        })
                        $("#SingNonBillMenu").css("color", "");
                        $("#SingBillMenu").removeAttr("onclick");
                        $("#SingBillMenu").css("color", "grey");
                    }
                    else {
                        $("#SingBillMenu").click(function () {
                            SingBill();
                        })
                        $("#SingBillMenu").css("color", "");
                        $("#SingNonBillMenu").removeAttr("onclick");
                        $("#SingNonBillMenu").css("color", "grey");
                    }

                }
            }
        })
    }

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
    if (entityid == null || entityid == undefined || entityid == "") {
        $("#menu").hide();
    }

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
