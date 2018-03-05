$(function () {
    $(".General").hide();
    $("#SelectLi").show();
    $(".page.fl").hide();
    $("#RefreshLi").show();
})


function AddCharge() {
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId != "") {
        OpenWindow("../Contract/AddCharges.aspx?ticket_id=" + ticketId, windowObj.contractCost + windowType.add);
    }
}
// 新增费用
function AddExpense() {
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId != "") {
        OpenWindow("../Project/ExpenseManage.aspx?ticket_id=" + ticketId, windowObj.expense + windowType.add);
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
function Edit() {
    if (CheckIsCost(entityid)) {
        OpenWindow("../Contract/AddCharges.aspx?id=" + entityid, windowObj.contractCost + windowType.edit);

    } else {
        OpenWindow("../Project/ExpenseManage.aspx?id=" + entityid, windowObj.expense + windowType.edit);
    }
}

// 删除当期成本/费用
function Delete() {
    debugger;
    if (CheckIsCost(entityid)) {
        $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=deleteCost&cost_id=" + entityid,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result) {
                        alert('删除成功');
                    } else {
                        alert('删除失败' + data.reason);
                    }

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

function View(id) {

}

function Refresh() {
    history.go(0);
}
