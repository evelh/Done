$(function () {
    $(".General").hide();
    $("#SelectLi").show();
    $(".page.fl").hide();
    $("#RefreshLi").show();
})

// 新增待办
function AddTodo() {
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId != "") {
        window.open("../Activity/Todos.aspx?ticketId=" + ticketId, windowObj.todos + windowType.add, 'left=200,top=200,width=800,height=800', false);
    }
}
// 新增服务预定
function AddServiceCall() {
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId != "") {
        window.open("../ServiceDesk/TaskServiceCall.aspx?ticketId=" + ticketId, windowObj.serviceCall + windowType.add, 'left=200,top=200,width=800,height=800', false);
    }
}

function Refresh() {
    history.go(0);
}

function EditToDo() {
    window.open("../Activity/Todos.aspx?id=" + entityid, windowObj.todos + windowType.edit, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}
function ViewToDo() {

}
function DoneToDo() {
    requestData("../Tools/ActivityAjax.ashx?act=TodoComplete&id=" + entityid, null, function (data) {
        window.location.reload();
    })
}
function ViewAccountTo() {
    window.open('../Company/ViewCompany.aspx?src=com_activity&id=' + entityid, '_blank', 'left=200,top=200,width=1200,height=1000', false);
}
function ViewOppo() {
    var oppID = "";
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ActivityAjax.ashx?act=GetActivity&id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                oppID = data.opportunity_id;
            }
        },
    });

    if (oppID != "") {
        window.open('../Opportunity/ViewOpportunity.aspx?id=' + entityid, '_blank', 'left=200,top=200,width=1200,height=1000', false);
    } else {

    }
}
function DeleteToDo() {
    LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/ActivityAjax.ashx?act=Delete&id=" + entityid, null, function (data) {
            if (data == true) {
                LayerAlert("删除成功", "确定", function () {
                    window.location.reload();
                })
            }
            else {
                LayerMsg("删除失败");
            }
        })
    }, function () { })
}


function EditCall() {
    var thisId = GetCallTicketIds(entityid);
    var ticketId = parent.$("#ticket_id").val();
    if ( ticketId != "") {
        window.open("../ServiceDesk/TaskServiceCall.aspx?ticketId=" + ticketId + "&callId=" + entityid, windowObj.serviceCall + windowType.edit, 'left=200,top=200,width=800,height=800', false);
    }
}
function AddLabourForCall() {
    var thisId = GetCallTicketIds(entityid);
    var ticketId = parent.$("#ticket_id").val();
    if (thisId != "" && ticketId!="") {
        window.open("../ServiceDesk/TicketLabour?ticket_id=" + ticketId + "&service_id=" + thisId, windowType.workEntry + windowType.add, 'left=200,top=200,width=1280,height=800', false);
    }
}
function DoneCall() {
  
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=DoneCall&callId=" + entityid,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("完成成功！");
                }
                else {
                    LayerMsg("完成失败！");
                }
                setTimeout(function () { history.go(0); }, 800);
            },
        });
    
}
function CopyCall() {
    window.open("../ServiceDesk/ServiceCall?copy=1&id=" + entityid, windowType.serviceCall + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}

function ViewAccount() {
    // GetCall
    var accountId = "";
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=GetCall&callId=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                accountId = data.account_id;
            }
        },
    });

    if (accountId != "") {
        window.open('../Company/ViewCompany.aspx?src=com_activity&id=' + entityid, '_blank', 'left=200,top=200,width=1200,height=1000', false);
    }
}
function RemoveTicket() {
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId != "") {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=DeleteTicketCall&callId=" + entityid + "&ticketId=" + ticketId,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("移除成功！");
                }
                else {
                    LayerMsg("移除失败！");
                }
                setTimeout(function () { history.go(0); }, 800);
            },
        });
    }
    
}
function AddNoteForItem() {
    window.open("../Project/TaskNote?call_id=" + entityid, windowType.notes + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}
function ForwardTicet() {
    var ids = "";
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=GetCallTicketIds&callId=" + entityid,
        //dataType: "json",
        success: function (data) {
            if (data != "" && data != null && data != undefined) {
                ids = data;
            }
        },
    });
    if (ids != "") {
        window.open("../ServiceDesk/TicketModify?ticketIds=" + ids, windowObj.masterTicket + windowType.manage, 'left=200,top=200,width=1280,height=800', false);
    }
    else {
        LayerMsg("为获取到相关工单信息");
    }
}
function GetWorkBook() {

}
function DeleteCall() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=DeleteCall&callId=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("删除成功！");
            }
            else {
                LayerMsg("删除失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}
// 判断是否 是待办-  待办返回 1  ，服务预定返回 2，都不是返回 ""
function isTodo() {
    var isTo = "";
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ActivityAjax.ashx?act=IsTodo&objetcId=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                isTo = data;
            }
        },
    });
    return isTo;
}

function RightClickFunc() {

    var isTo = isTodo();
    if (isTo == "1") {
        $(".ToDo").show();
        $(".Call").hide();
    }
    else if (isTo == "2") {
        $(".ToDo").hide();
        $(".Call").show();
    }
    else {
        $(".ToDo").hide();
        $(".Call").hide();
    }

    ShowContextMenu();
}

function GetCallTicketIds(callId) {
    var callTicketId = "";
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId != "") {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=GetCallTicket&callId=" + callId + "&ticketId=" + ticketId,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    callTicketId = data.id;
                }
            },
        });
    }
    return callTicketId;
}
