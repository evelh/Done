$(function () {
    $(".General").hide();
    $("#CheckAll").hide();
})

function Add() {
    var parentId = "";
    if ($("input[name = 'con4854']").val() != undefined) {
        parentId = $("input[name = 'con4854']").eq(0).val();
    }
    if (parentId != null) {
        window.open('../ServiceDesk/IssueTypeManage?parentId=' + parentId+'&tableId=133', 'AddSubIssue', 'left=0,top=0,location=no,status=no,width=700,height=550', false);
    }
    
}

function Edit() {
    window.open('../ServiceDesk/IssueTypeManage?id=' + entityid + '&tableId=133', 'AddSubIssue', 'left=0,top=0,location=no,status=no,width=700,height=550', false);
}

function Delete() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    });
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
        $.ajax({
            type: "GET",
            url: "../Tools/GeneralAjax.ashx?act=DeleteTicketSubIssue&ids=" + ids,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result) {
                        LayerMsg("删除成功！"+data.reason);
                    }
                }
                setTimeout(function () {
                    history.go(0);
                },800);
            }
        })
    }
    else {
        LayerMsg("请选择需要删除的子问题");
    }
}