$(function () {
    if ($("input[name = 'con2545']").val() != undefined) {
        $("#isDiaodu").val($("input[name = 'con2545']").eq(0).val());
    }
    if ($("input[name = 'con2745']").val() != undefined) {
        $("#con2745").val($("input[name = 'con2745']").eq(0).val());
    }
    $("#PrintLi").hide();
    $("#ExportLi").hide();
})

function SearchTicket() {
    var isDiaodu = $("#isDiaodu").val();
    var name = $("#con2745").val();
    var url = "";
    var cat = $("#cat").val();
    var type = $("#type").val();
    var group = $("#group").val();
    var url = "../Common/SearchBodyFrame?cat=" + cat + "&type=" + type + "&group=" + group;
    if (isDiaodu != "") {
        url += "&con2545=" + isDiaodu;
    }
    if (name != "") {
        url += "&con2745=" + name;

    }
    location.href = url;
}

function EditTicket() {
    $.ajax({
        type: "GET",
        async: false,
        //dataType: "json",
        url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + entityid,
        success: function (data) {
            if (data == "1") {
                window.open("../ServiceDesk/TicketManage?id=" + entityid, windowObj.ticket + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
            }
            else if (data == "2") {
                window.open("../Project/TaskAddOrEdit.aspx?id=" + entityid, windowObj.task + windowType.add, 'left=200,top=200,width=1080,height=800', false);
            }
           
        }
    });

}

function ViewTicket() {
    $.ajax({
        type: "GET",
        async: false,
        //dataType: "json",
        url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + entityid,
        success: function (data) {
            if (data == "1") {
                window.open("../ServiceDesk/TicketView?id=" + entityid, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
            }
            else if (data == "2") {
                window.open("../Project/TaskView.aspx?id=" + entityid, '_blank', 'left=200,top=200,width=1080,height=800', false);
            }

        }
    });
    

   
}

function AddNewCall() {

}

function AddAlreadyCall() {

}

function RightClickFunc() {
    $.ajax({
        type: "GET",
        async: false,
        //dataType: "json",
        url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + entityid,
        success: function (data) {
            if (data == "1") {
                $("#MenuEditTicket").text("编辑工单");
                $("#MenuViewTicket").text("查看工单");
            }
            else if (data == "2") {
                $("#MenuEditTicket").text("编辑任务");
                $("#MenuViewTicket").text("查看任务");
            }
            else {
                
            }
        }
    });
    ShowContextMenu();
}
