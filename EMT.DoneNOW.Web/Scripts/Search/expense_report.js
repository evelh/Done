$(function () {
    debugger;
    $("#SelectLi").hide();
    $("#ExportLi").hide();
    $(".fl.page").hide();  
    $(".fl.clear").css("width", "100%");
    var isPay = $("input[name = 'con1237']").val();
    if (isPay != undefined && isPay != null && isPay != "") {
        if (isPay == "1") {
            $("#IsPay").val(isPay);
        } else if (isPay == "0") {
            $("#IsPay").val("2");
        }
        else {
            $("#IsPay").val(0);
        }

        
    } else {
        $("#IsPay").val(0);
    }
     
})
// 新增费用报表
function Add() {
    OpenWindow("../Project/ExpenseReportManage.aspx", windowObj.expenseReport + windowType.add);
}
// 查看费用报表
function View(id) {
    OpenWindow("../TimeSheet/ExpenseReportDetail.aspx?id=" + id, windowObj.expenseReport + windowType.view);
}
// 查看费用报表
function ViewReport() {
    OpenWindow("../TimeSheet/ExpenseReportDetail.aspx?id=" + entityid, windowObj.expenseReport + windowType.view);
}
// 编辑费用报表
function EditReport() {
    OpenWindow("../Project/ExpenseReportManage.aspx?id=" + entityid, windowObj.expenseReport + windowType.edit);
}
// 复制费用报表
function CopyReport() {
    OpenWindow("../Project/ExpenseReportManage.aspx?id=" + entityid +"&isCopy=1", windowObj.expenseReport + windowType.add);
}
// 删除费用报表
function DeleteReport() {
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
            setTimeout(function () { history.go(0); }, 1000);
        }
    })
}
 // 
$("#IsPay").change(function () {
    debugger;
    var userId = $("input[name = 'con1236']").val();
    var thisValue = $(this).val();
    
    var url = "SearchBodyFrame.aspx?cat=1578&type=157&group=170";
    if (userId != "" && userId != null && userId != undefined) {
        url += "&con1236=" + userId;
    }
    if (thisValue == "1") {
        url += "&con1237=1";
    }
    else if (thisValue == "2") {
        url += "&con1237=0";
    }
    location.href = url;
    //
})