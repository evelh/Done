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

// 审批并提交 单条数据
function PostSin() {
    var typeId = $("#type").val();
    OpenWindow('../Contract/ApproveChargeSelect.aspx?type=' + typeId + '&id=' + entityid, windowObj.workEntry + windowType.manage);
}
// 编辑工时
function EditWorkEntry() {
    var taskId = "";
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=GetLabourInfo&id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                // todo 获取taskId 判断是工时还是工单
                taskId = data.task_id;
            }
        }
    });
    if (taskId != "" && taskId != undefined) {
        $.ajax({
            type: "GET",
            async: false,
            //dataType: "json",
            url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + taskId,
            success: function (data) {
                if (data == "1") {
                    window.open("../ServiceDesk/TicketLabour.aspx?id=" + entityid, windowObj.workEntry + windowType.edit, 'left=0,top=0,location=no,status=no,width=1000,height=943', false);
                }
                else if (data == "2") {
                    OpenWindow("../Project/WorkEntry.aspx?id=" + entityid, windowObj.workEntry + windowType.edit);
                }
                
            },
           
        });
    }
    
}
// 编辑工单
function EditTicket() {
    var taskId = "";
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=GetLabourInfo&id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                // todo 获取taskId 判断是工时还是工单
                taskId = data.task_id;
            }
        }
    });
    if (taskId != "" && taskId != undefined) {
        $.ajax({
            type: "GET",
            async: false,
            //dataType: "json",
            url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + taskId,
            success: function (data) {
                if (data == "1") {
                    window.open("../ServiceDesk/TicketManage?id=" + taskId, windowObj.ticket + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
                }
            },

        });
    }
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
function ProjectDetail() {
    var typeId = $("#type").val();
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=GetProjectId&id=" + entityid + "&type=" + typeId,
        success: function (data) {
            if (data != "") {
                window.open('../Project/ProjectView.aspx?&id=' + data, windowObj.project + windowType.blank, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            }

        }
    });
}
// 工单详情
function TicketDetail() {
    var taskId = "";
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=GetLabourInfo&id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                // todo 获取taskId 判断是工时还是工单
                taskId = data.task_id;
            }
        }
    });
    if (taskId != "" && taskId != undefined) {
        $.ajax({
            type: "GET",
            async: false,
            //dataType: "json",
            url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + taskId,
            success: function (data) {
                if (data == "1") {
                    window.open("../ServiceDesk/TicketView?id=" + taskId, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
                }
            },

        });
    }
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

// 修改费用信息
function ChangePrice() {
    OpenWindow("../Contract/AdjustEntryPrice.aspx?id=" + entityid, windowObj.workEntry + windowType.edit);
}
