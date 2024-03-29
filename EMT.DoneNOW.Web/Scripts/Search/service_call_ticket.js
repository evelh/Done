﻿$(function () {
    $(".General").hide();
    $("#SelectLi").show();
    var serviceId = parent.$("#SerivceCallId").val();
    if (serviceId != "") {
        //$("#isFenPei").val("1");
    }
    //$(".page.fl").hide();
    if ($("input[name = 'con2125']").val() != undefined) {
        //$("#isFenPei").val($("input[name = 'con2125']").eq(0).val());
    }
    if ($("input[name = 'con2126']").val() != undefined) {
        //$("#dueTime").val($("input[name = 'con2126']").eq(0).val());
    }
    else {
        //$("#dueTime").val("");
    }
    parent.CheckTicket();
})

function AddTicket(){
    var accountId = parent.$("#accountIdHidden").val();
    if (accountId == undefined || accountId == null) {
        accountId = "";
    }
    window.open("../ServiceDesk/TicketManage?isServiceCall=1&account_id=" + accountId +"&CallBack=AddTicketId", windowType.ticket + windowType.add, 'left=200,top=200,width=1280,height=800', false);

}
function AddTicketId(ticketId) {
    parent.$("#AppTicketIdsHidden").val(ticketId);
    parent.GetDataByChooseIds();
}

// 关联相应的工单
function ApplyTicket() {
    parent.ApplyChooseTicket();
}

$("#isFenPei").change(function () {
    ChangeLocation();
})

$("#dueTime").change(function () {
    ChangeLocation();
})

function ChangeLocation() {
    var accountId = parent.$("#accountIdHidden").val();
    if (accountId == undefined || accountId == null) {
        accountId = "";
    }
    var fenPei = $("#isFenPei").val();
    var dueTime = $("#dueTime").val();
    var url = "../Common/SearchBodyFrame?cat=1603&type=188&isCheck=1&con2125=" + fenPei;
    if (dueTime == "1") {
        url += "&con2126=1";
    }
    var serviceId = parent.$("#SerivceCallId").val();
    if (serviceId != "") {
        url += "&con2127=" + serviceId;
    }
    else {
        url += "&con2681=" + accountId;
    }
    parent.$("#TicketSearch").attr("src", url);
}
$("#CheckAll").click(function () {
    if ($(this).is(":checked")) {
        $(".IsChecked").prop("checked", true);
    }
    else {
        $(".IsChecked").prop("checked", false);
    }
    parent.$("#ChooseIds").val(GetCkIds());
})
$(".IsChecked").click(function () {
    parent.$("#ChooseIds").val(GetCkIds());
})

function GetCkIds()
{
    var ids = "";
    $(".IsChecked").each(function () {
        var thisValue = $(this).val();
        if ($(this).is(":checked") && thisValue != "" && thisValue != undefined) {
            ids += thisValue + ',';
        }
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length-1);
    }
    return ids;
}
// 选中已有的工单
function CheckPageTicket(ticketIds) {
    if (ticketIds != "") {
        var ticketArr = ticketIds.split(',');
        $(".IsChecked").each(function () {
            var thisValue = $(this).val();
            if (ticketArr.indexOf(thisValue) >= 0) {
                $(this).prop("checked", true);
            }
        })
    }
}

// 添加服务工时
function AddServiceLabour() {
    var serviceId = parent.$("#SerivceCallId").val();
    if (serviceId != "") {
        // 获取时间是否超过24小时
        var isMore = "";
       
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=GetCall&callId=" + serviceId,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    var hours = (Number(data.end_time) - Number(data.start_time)) / 1000 / 60 / 60;
                    if (Number(hours) >= 24) {
                        isMore = "1";
                    }
                }
            },
        });
        
        if (isMore == "") {
            window.open("../ServiceDesk/TicketLabour?ticket_id=" + entityid + "&service_id=" + serviceId, windowType.workEntry + windowType.add, 'left=200,top=200,width=1280,height=800', false);
        }
        else {
            LayerMsg("服务预定总时长等于或超出24小时，超出了工时的最长实现，不能创建。");
        }
    }
    else {
        LayerMsg("请先保存服务预定信息");
    }
}

function AddLabour() {
    window.open("../ServiceDesk/TicketLabour?ticket_id=" + entityid , windowType.workEntry + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}

function ManageRes() {
    var serviceId = parent.$("#SerivceCallId").val();
    if (serviceId == "") {
        LayerMsg("请先进行保存操作");
        return;
    }
    window.open("../ServiceDesk/TicketCallResManage?callId=" + serviceId + "&ticketId=" + entityid,'_blank', 'left=200,top=200,width=1280,height=800', false);

}

function RightClickFunc() {

    // 获取状态-是否激活 控制显示隐藏
    var serviceId = parent.$("#SerivceCallId").val();
    if (serviceId == "") {
        $(".NeedSave").hide();
    }

    $.ajax({
        type: "GET",
        async: false,
        //dataType: "json",
        url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + entityid,
        success: function (data) {
            if (data == "1") {
                $(".ticket").show();
                $(".task").hide();
            }
            else if (data == "2") {
                $(".ticket").hide();
                $(".task").show();
            }
            else {
                $(".ticket").hide();
                $(".task").hide();
            }
        },
        error: function () {
            $(".ticket").hide();
            $(".task").hide();
        },
    });

    ShowContextMenu();
}

function RemoveTicket() {
    var serviceId = parent.$("#SerivceCallId").val();
    if (serviceId == "") {
        LayerMsg("请先进行保存操作");
        return;
    } 
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=DeleteTicketCall&callId=" + serviceId + "&ticketId=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("移除成功！");
            }
            else {
                LayerMsg("移除失败！");
            }
            setTimeout(function () {  history.go(0); }, 800);
        },
    });

}

function EditTicket() {
    window.open("../ServiceDesk/TicketManage?id=" + entityid, windowObj.ticket + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
}

function ViewTicket(){
    window.open("../ServiceDesk/TicketView?id=" + entityid, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
}


function AddTicketNote() {
    window.open("../Project/TaskNote.aspx?ticket_id=" + entityid, windowObj.notes + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}

function ViewTask() {
    window.open("../Project/TaskView.aspx?id=" + entityid, windowType.blank, 'left=200,top=200,width=1080,height=800', false);
}


function AddTask(){
    window.open("../Project/TaskNote.aspx?task_id=" + entityid, windowObj.notes + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}
function EditTask() {
    window.open("../Project/TaskAddOrEdit.aspx?id=" + entityid, windowObj.task + windowType.edit, 'left=200,top=200,width=1080,height=800', false);
}

function AddTaskLabour() {
    window.open("../Project/WorkEntry.aspx?task_id=" + entityid + "&NoTime=1", windowObj.workEntry + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}

function AddTaskTimeLabour() {
    window.open("../Project/WorkEntry.aspx?task_id=" + entityid , windowObj.workEntry + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}

function AddTaskServiceLabour() {
    var serviceId = parent.$("#SerivceCallId").val();
    if (serviceId != "") {
        window.open("../Project/WorkEntry.aspx?task_id=" + entityid + "&callId=" + serviceId, windowObj.workEntry + windowType.add, 'left=200,top=200,width=1080,height=800', false);
    }
    else {
        LayerMsg("未获取到服务预定信息！");
    }
    
} 