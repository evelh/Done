$(function () {
    $(".General").hide();
    $("#SelectLi").show();
})

function Add() {
    window.open("../ServiceDesk/ServiceCall", windowType.serviceCall + windowType.add, 'left=200,top=200,width=1280,height=800', false);
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

}

function GetWorkBook() {

}

function ModifyTicket() {

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

}