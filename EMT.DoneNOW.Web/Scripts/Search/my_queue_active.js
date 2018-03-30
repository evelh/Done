$(function () {
    $("#RefreshLi").show();
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

}
function ViewAccountTaskHistory() {

}
function CopyTask() {

}
function CopyToProject() {

}
function MergeOtherTicket() {

}
function AbsorbOther() {

}
function AddCall() {

}
function AddNote() {

}
function TicketModify() {

}
function DeleteTicket() {

}
function RemoveProject() {

}
