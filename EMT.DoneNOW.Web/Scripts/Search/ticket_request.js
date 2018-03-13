$(function () {
    $(".General").hide();
    $("#RefreshLi").show();
    $(".page.fl").hide();
    $("#menu ul").each(function () {
        $(this).css("width", "250px");
    })
})
// 关联已存在工单
function Relation() {
    parent.RelaRequests();
}
// 新增
function Add() {
    parent.SignInclidentNewRequestOpen();
}

// 工单详情
function ViewTicket() {
    var ticketIds = "";
    $(".dn_tr").each(function () {
        var thisId = $(this).data("val");
        if (thisId != "") {
            ticketIds += thisId + ",";
        }
    })
    if (ticketIds != "") {
        ticketIds = ticketIds.substring(0, ticketIds.length - 1);
    }
    window.open("../ServiceDesk/TicketView?id=" + entityid + "&ids=" + ticketIds, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
}
// 删除工单
function DeleteTicket() {
    LayerConfirm("确认删除该工单吗？", "是", "否", function () {
        //$("#BackgroundOverLay").show();
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=DeleteTicket&ticket_id=" + entityid,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result) {
                        LayerMsg("删除成功！");
                        //window.close();
                    }
                    else {
                        if (data.reason != "") {
                            LayerMsg(data.reason);
                           
                        }
                    }
                }
            }
        })
        setTimeout(function () { history.go(0); },800)
       
    }, function () {

    });
}
// 编辑工单
function EditTicket() {
    window.open("../ServiceDesk/TicketManage?id=" + entityid, windowObj.ticket + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
}

// 工单历史查询
function TicketHistory() {
    OpenWindow("../ServiceDesk/TicketHistory?ticket_id=" + entityid, "_blank", );
}
// 客户工单历史
function AccountTicketHistory() {
    // OpenWindow("../ServiceDesk/AccountTicketList?ticket_id=" + entityid, "_blank", ); 未关闭工单  
    // todo
}
// 解除和工单 的关联
function DisRelationTicket() {
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId != "" && entityid != "") {
        // 
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=DisRelaTicket&ticket_id=" + ticketId + "&rela_ticket_id=" + entityid,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("解除关联成功！");
                }
            }
        })
        setTimeout(function () { history.go(0); }, 800);
    }
}
function Refresh() {
    history.go(0);
}