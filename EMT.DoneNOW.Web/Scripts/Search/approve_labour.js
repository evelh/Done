$(function () {
    $(".General").hide();
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
 
}
function View(id) {
  
}

// 审批并提交 单条数据
function PostSin() {
    var typeId = $("#type").val();
    OpenWindow('../Contract/ApproveChargeSelect.aspx?type=' + typeId + '&id=' + entityid, windowObj.workEntry + windowType.manage);
}
// 编辑工时
function EditWorkEntry() {
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=GetLabourInfo&id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                OpenWindow("../Project/WorkEntry.aspx?id=" + entityid, windowObj.workEntry + windowType.edit);
            }

        }
    });

}
// 编辑工单
function EditTicket() {

}
// 工时详情
function EntryDetail() {
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=GetLabourInfo&id=" + entityid,
        dataType:"json",
        success: function (data) {
            if (data != "") {

                OpenWindow("../Project/EntryDetail.aspx?id=" + entityid, windowObj.workEntry + windowType.blank);
            }

        }
    });
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
// 工单详情
function TicketDetail() {

}
// 恢复初始值
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
// 右键菜单相关事件
function RightClickFunc() {



    ShowContextMenu();
}