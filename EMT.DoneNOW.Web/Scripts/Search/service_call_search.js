$(function () {
    $(".General").hide();
    $("#SelectLi").show();
})

function Add() {
    window.open("../ServiceDesk/ServiceCall", windowType.serviceCall + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}

function ViewEntity(id) {
    window.open("../ServiceDesk/ServiceCall?id=" + id, windowType.serviceCall + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
}
function Edit() {
    window.open("../ServiceDesk/ServiceCall?id=" + entityid, windowType.serviceCall + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
}

function ViewAccount() {
    var accountId = "";
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=GetCall&callId=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data!="") {
                accountId = data.account_id;
            }
        },
    });
    if (accountId != "" && accountId != null && accountId != undefined) {
        OpenWindow("../Company/ViewCompany.aspx?id=" + accountId, windowType.blank);
    }
}

function AddItemNote() {
    window.open("../Project/TaskNote?call_id=" + entityid, windowType.notes + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}

function GetWorkBook() {

}

function ModifyTicket() {
    
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

function DoneServiceCall() {
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
function CopyCall() {
    window.open("../ServiceDesk/ServiceCall?copy=1&id=" + entityid, windowType.serviceCall + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}