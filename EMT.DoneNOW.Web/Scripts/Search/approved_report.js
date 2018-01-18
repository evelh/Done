

$(function () {
    $(".page.fl").hide();
    $("#SelectLi").hide();
    $("#ExportLi").hide();
})

function View(id) {
    OpenWindow("../TimeSheet/ExpenseReportDetail.aspx?id=" + id, windowObj.expenseReport + windowType.view);
}

function ShowDetail() {
    OpenWindow("../TimeSheet/ExpenseReportDetail.aspx?id=" + entityid, windowObj.expenseReport + windowType.view);
}
// 编辑
function Edit() {
    OpenWindow("../Project/ExpenseReportManage.aspx?id=" + entityid, windowObj.expenseReport + windowType.edit);
}
// 删除
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/ExpenseAjax.ashx?act=DeleteExpenseReport&report_id=" + entityid,
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
}
// 标记为已支付
function PaidThis() {
    $.ajax({
        type: "GET",
        url: "../Tools/ExpenseAjax.ashx?act=Paid&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    alert('标记为已支付成功');
                } else {
                    alert('标记为已支付失败，' + data.reason);
                }
            }
            history.go(0);
        }
    })
}
// 全部标记为已支付
function PaidAll() {
    var ids = GetAllIds();
    if (ids != "") {
        $.ajax({
            type: "GET",
            url: "../Tools/ExpenseAjax.ashx?act=PaidAll&ids=" + ids,
            async: false,
            //dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data=="True") {
                        alert('标记成功');
                    } else {
                        alert('标记失败');
                    }
                }
                history.go(0);
            }
        })
    }
    else {
        LayerMsg("未获取到查询的相关数据！");
    }
}
// 标记为审批
function Approval() {
    $.ajax({
        type: "GET",
        url: "../Tools/ExpenseAjax.ashx?act=ReturnApproval&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    alert('标记为已审批成功');
                } else {
                    alert('标记已审批失败，' + data.reason);
                }
            }
            history.go(0);
        }
    })
}
// 审批全部
function ApprovalAll() {
    var ids = GetAllIds();
    if (ids != "") {
        $.ajax({
            type: "GET",
            url: "../Tools/ExpenseAjax.ashx?act=AllReturnApproval&ids=" + ids,
            async: false,
            //dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data == "True") {
                        alert('标记成功');
                    } else {
                        alert('标记失败');
                    }
                }
                history.go(0);
            }
        })
    }
    else
    {
        LayerMsg("未获取到查询的相关数据！");
    }
}
// 获取到页面上的查询到的所有的ID 集合
function GetAllIds() {
    var ids = "";
    $(".dn_tr").each(function () {
        var thisValue = $(this).data("val");
        if (thisValue != "" && thisValue != null && thisValue != undefined) {
            ids += thisValue + ',';
        }
    });

    if (ids != "") {
        ids = ids.substring(0, ids.length-1);
    }
    return ids;
}
