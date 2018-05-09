$(function () {
    $("#RefreshLi").show();
    $("#menuUl").css("width","250px");
})

$("#options").on("mouseover", function () {
    $(this).css("background", "white");
    $(this).css("border-bottom", "none");
    $("#D1").show();
});
$("#options").on("mouseout", function () {
    $("#D1").hide();
    $(this).css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("border-bottom", "1px solid #BCBCBC");
});
$("#D1").on("mouseover", function () {
    $(this).show();
    $("#options").css("background", "white");
    $("#options").css("border-bottom", "none");
});
$("#D1").on("mouseout", function () {
    $(this).hide();
    $("#options").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#options").css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#options").css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#options").css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $("#options").css("border-bottom", "1px solid #BCBCBC");
});
function Refresh() {
    history.go(0);
}
// 新增工单
function AddTicket(ticket_type_id) {
    if (ticket_type_id == "") {
        OpenWindow("../ServiceDesk/TicketManage", windowObj.ticket + windowType.add, );
    }
    else {
        OpenWindow("../ServiceDesk/TicketManage?ticket_type_id=" + ticket_type_id, windowObj.ticket + windowType.add, );
    }
}
function RightClickFunc() {
    $("#btnAddLab").hide();
    $("#btnEditMaster").hide();
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=GetTicket&ticket_id=" + entityid,
        dataType:"json",
        success: function (data) {
            if (data != "") {
                if (data.status_id != "1894") {
                    $("#btnAddLab").show();
                }
                if (data.recurring_ticket_id != "" && data.recurring_ticket_id != null && data.recurring_ticket_id != undefined) {
                    $("#btnEditMaster").show();
                }
            }
        },
    });

    ShowContextMenu();
}

function AddLabour() {
    window.open("../ServiceDesk/TicketLabour.aspx?ticket_id=" + entityid, windowObj.workEntry + windowType.add, 'left=200,top=200,width=1000,height=800', false);
}
function AddServiceLabour() {

}
function EditTicket() {
    window.open("../ServiceDesk/TicketManage?id=" + entityid, windowObj.ticket + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
}
function EditMasterTicket() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=GetTicket&ticket_id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.recurring_ticket_id != "" && data.recurring_ticket_id != null && data.recurring_ticket_id != undefined) {
                    window.open("../ServiceDesk/MasterTicket?id=" + entityid, windowType.masterTicket + windowType.add, 'left=200,top=200,width=1280,height=800', false);
                }
            }
        },
    });
}
function ViewTask() {
    window.open("../ServiceDesk/TicketView?id=" + entityid, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
}
function ViewTaskHistory() {
    window.open("../ServiceDesk/TicketHistory?ticket_id=" + entityid, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
}
function ViewAccountTaskHistory() {

}
function CopyTask() {
    window.open("../ServiceDesk/TicketManage?isCopy=1&id=" + entityid, windowObj.ticket + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}
function CopyToProject() {
    window.open("../ServiceDesk/CopyToProject.aspx?ticketIds=" + entityid, windowType.blank, 'left=200,top=200,width=600,height=800', false);
}
// 合并
function MergeOtherTicket() {
    var accountId = "";
    var isPro = "";
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=GetTicket&ticket_id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.account_id != "") {
                    accountId = data.account_id;
                }
                if (data.ticket_type_id == "1802" || data.ticket_type_id == "1803") {
                    isPro = "1";
                }
            }
        },
    });
    if (isPro != "") {
        LayerMsg("");
        return;
    }
    window.open("../Common/SelectCallBack.aspx?cat=1606&field=toTicketId&callBack=MergeTicket&con2252=" + accountId + "&con2253=" + entityid + "&con2262=1", windowObj.select, 'left=200,top=200,width=600,height=800', false);
}
// 合并查找带回事件
function MergeTicket() {
  
    var toTicketId = $("#toTicketIdHidden").val();
    if (toTicketId != "") {
        LayerConfirm("您将要将此工单合并到另一工单中，此工单的状态将被设置为完成。\其备注、工时、成本、服务预定、待办、费用等仍将与此工单保持关联。此工单的联系人和其他联系人，将作为另一个工单上的其他联系人。此外，您正在合并工单与合并目标的工单有不同的联系人。工单变更时，正在合并的工单的联系人将不再会收到相关通知。你确定要合并此工单吗？", "确定", "取消", function () {
            $.ajax({
                type: "GET",
                url: "../Tools/TicketAjax.ashx?act=MergeTicket&from_ticket_id=" + entityid + "&to_ticket_id=" + toTicketId,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.result) {
                            LayerMsg("合并成功！");
                        }
                        else {
                            LayerMsg("合并失败！" + data.reason);
                        }
                    }
                }
            })
            setTimeout(function () { history.go(0); }, 1000);
        }, function () { });
    }
}
// 吸收
function AbsorbOther() {
    var accountId = "";
    var isPro = "";
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=GetTicket&ticket_id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.account_id != "") {
                    accountId = data.account_id;
                }
                
            }
        },
    });
    window.open("../Common/SelectCallBack.aspx?cat=1606&field=AbsorbTicketIds&callBack=AbsorbTicket&con2252=" + accountId + "&con2253=" + entityid + "&muilt=1&&con2262=2", windowObj.select, 'left=200,top=200,width=600,height=800', false);
}
// 吸收查找带回事件
function AbsorbTicket() {
    var AbsorbTicketIds = $("#AbsorbTicketIdsHidden").val();
    if (AbsorbTicketIds != null && AbsorbTicketIds != "") {
        var absIdsArr = AbsorbTicketIds.split(',');
        LayerConfirm("您将要吸收合并其他" + absIdsArr.length + "个工单。 如果您这样做，被吸收合并的工单的状态将被设置为完成，其备注、工时、成本、服务预定、待办、费用等仍将与此工单保持关联，其联系人和其他联系人，将作为当前工单上的其他联系人。你确定要吸收合并这些工单吗", "确定", "取消", function () {
            $.ajax({
                type: "GET",
                url: "../Tools/TicketAjax.ashx?act=AbsorbTicket&to_ticket_id=" + entityid + "&from_ticket_ids=" + AbsorbTicketIds,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data) {
                        LayerMsg("吸收其他工单成功！");
                    }
                    else {
                        LayerMsg("吸收其他工单失败！");
                    }
                }
            })
            setTimeout(function () { history.go(0); }, 1000);
        }, function () { });
    }
}

function AddCall() {
    window.open("../ServiceDesk/TaskServiceCall?ticketId=" + entityid, windowObj.serviceCall + windowType.add, 'left=200,top=200,width=750,height=800', false);
}

function AddNote() {
    window.open("../Project/TaskNote.aspx?ticket_id=" + entityid, windowObj.notes + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}

function TicketModify() {
    window.open("../ServiceDesk/TicketModify.aspx?ticketIds=" + entityid, windowObj.ticket + windowType.manage, 'left=200,top=200,width=1080,height=800', false);
}

function DeleteTicket() {
    LayerConfirm("确认删除该工单吗？", "是", "否", function () {
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=DeleteTicket&ticket_id=" + entityid,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result) {
                        LayerMsg("删除成功！");
                        history.go(0);
                    }
                    else {
                        if (data.reason != "") {
                            LayerMsg(data.reason);
                        }
                    }
                }
            }
        })

    }, function () {

    });
}

function RemoveProject() {
    $.ajax({
        type: "GET",
        url: "../Tools/TicketAjax.ashx?act=DisRelationProject&ticket_id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("取消成功！");
            }
            else {
                LayerMsg("取消失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        }
    })
}
// 添加到我的工作列表
function AddToMyWorkList() {
    debugger;
    var loginUserId = $("#loginUserId").val();
    if (entityid != "" && loginUserId != "") {
        AddToWorkList(loginUserId, entityid);
    }
}
// 添加到主负责人的工作列表
function AddToPriResWorkList() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProjectAjax.ashx?act=GetSinTask&task_id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.owner_resource_id != "" && data.owner_resource_id != null && data.owner_resource_id != undefined) {
                    AddToWorkList(data.owner_resource_id, entityid);
                } else {
                    LayerMsg("暂无主负责人");
                }
            }
        },
    });
}
// 添加到其他负责人的工作列表
function AddToOtherResWorkList() {
    debugger;
    parent.parent.$('#BackgroundOverLay').show();
    parent.parent.$('#ShowAddOtherDiv').show();

}
function AddToWorkList(resIds, taskId) {
    if (resIds == "" || taskId == "") {
        return;
    }
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/IndexAjax.ashx?act=AddWorkList&resIds=" + resIds + "&taskId=" + taskId,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("添加成功！");
            } else {
                LayerMsg("添加失败！");
            }
        },
    });
}
