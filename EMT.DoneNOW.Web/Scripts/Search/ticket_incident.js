$(function () {
    $(".General").hide();
    $("#RefreshLi").show();
    $(".page.fl").hide();
    $("#menu ul").each(function () {
        $(this).css("width", "250px");
    })
})

function Relation() {
    parent.SignManyAsIncident();
}

function Add() {
    var ticketId = parent.$("#ticket_id").val();
    window.open("../ServiceDesk/TicketManage?id=" + ticketId + "&isCopy=1&IsIncident=1&CallBack=PageAddInd", windowObj.ticket + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}

function PageAddInd(IndId) {
    parent.AddIndId(IndId);
} 
function Refresh() {
    history.go(0);
}

function DisRelationTicket() {
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId != "" && entityid != "") {
        // 
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=DisRelaTicket&ticket_id=" + entityid + "&rela_ticket_id=" + ticketId,
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