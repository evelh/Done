$(function () {
    // $(".General").hide();
    $(".CheckTd").click(function (event) {
        event.stopPropagation(); // 不执行上一元素的事件，阻止冒泡事件
    });
})
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
// 审批并提交单个
function PostSin() {
    var typeId = $("#type").val();
    OpenWindow('../Contract/ContractPostDate.aspx?type=' + typeId + '&id=' + entityid, windowObj.expense + windowType.manage);

}
// 批量审批并提交
function Add() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    });
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
        var typeId = $("#type").val();
        OpenWindow('../Contract/ApproveChargeSelect.aspx?type=' + typeId + '&ids=' + ids, windowObj.workEntry + windowType.manage);

    }
    else {
        LayerMsg("请选择需要审批的数据！");
    }
}

function View(id) {

}
// 合同详情
function ContractDetail() {
    var typeId = $("#type").val();
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=ContractDetails&id=" + entityid + "&type=" + typeId,
        success: function (data) {
            if (data != "") {
                OpenWindow('../Contract/ContractView.aspx?&id=' + data, windowObj.contract + windowType.blank);
            }

        }
    });
}
// 项目详情
function ProjectDetail() {
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=GetExpInfo&id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.project_id != null && data.project_id != "" && data.project_id != undefined)
                    OpenWindow("../Project/ProjectView.aspx?id=" + data.project_id, windowObj.project + windowType.blank);
            }

        }
    });
}
// 工单详情
function TicketDetail() {
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=GetExpInfo&id=" + entityid,
        dataType: "json",
        success: function (data) {
            debugger;
            if (data != "") {
                if (data.task_id != null && data.task_id != "" && data.task_id != undefined)
                    OpenWindow("../Project/TaskView.aspx?id=" + data.task_id, windowObj.task + windowType.blank);
            }

        }
    });
}
function MakeBill() {
    var typeId = $("#type").val();
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=billing&id=" + entityid + "&type=" + typeId,
        success: function (data) {
            alert(data);
        }
    });
    window.location.reload();
}
function MakeUnBill() {
    var typeId = $("#type").val();
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=nobilling&id=" + entityid + "&type=" + typeId,
        async: false,
        success: function (data) {
            alert(data);
        }
    });
    window.location.reload();
}
function RestoreInitiall() {
    var typeId = $("#type").val();
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=init&id=" + entityid + "&type=" + typeId,
        async: false,
        success: function (data) {
            alert(data);
        }
    });
    window.location.reload();

}
// 修改费用信息
function ChangePrice() {
    OpenWindow("../Contract/AdjustExpensePrice.aspx?id=" + entityid, windowObj.expense + windowType.edit);
}
