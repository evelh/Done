$(function () {
    if ($("input[name = 'con1732']").val() != undefined) {
        $("#DueType").val($("input[name = 'con1732']").eq(0).val());
    }
    // 
    if ($("input[name = 'con1759']").val() != undefined) {
        if ($("input[name = 'con1732']").eq(0).val() == "1") {
            $("#InclodeRec").prop("checked", true);
        }
        else {
            $("#InclodeRec").prop("checked", false);
        }
    }
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

$("#DueType").change(function () {
    GetData();
})
$("#InclodeRec").click(function () {
    GetData();
})

function GetData() {
    var url = "../Common/SearchBodyFrame.aspx?";
    var cat = $("#cat").val();
    var type = $("#type").val();
    url += "cat=" + cat + "&type=" + type;
    if ($("input[name = 'con1731']").val() != undefined) {
        url += "&con1731=" + $("input[name = 'con1731']").eq(0).val();
    }

    var DueType = $("#DueType").val();
    url += "&con1732=" + DueType;
    if ($("#InclodeRec").is(":checked")) {
        url += "&con1759=1";
    }
    else {
        url += "&con1759=0";
    }
    location.href = url;
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
