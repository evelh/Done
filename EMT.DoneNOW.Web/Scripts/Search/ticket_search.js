$(function () {

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

// 新增工单
function AddTicket(status_id) {
    if (status_id == "") {

    }
    else {
        OpenWindow("../ServiceDesk/TicketManage?status_id=" + status_id, windowObj.ticket + windowType.add, );
    }
    
}
// 工单详情
function ViewTicket() {
    window.open("../ServiceDesk/TicketView?id=" + entityid, windowType.blank,  'left=200,top=200,width=1280,height=800', false);
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
                            //var failHtml = "";
                            //var failArr = data.reason.split(';');
                            //for (var i = 0; i < failArr.length; i++) {
                            //    if (failArr[i] != "") {
                            //        failHtml += "<li>" + failArr[i] + "</li>";
                            //    }
                            //}
                            //$("#DeletTicketReasonUl").html(failHtml);
                            //$("#DeleteTicketDialog").show();
                        }
                    }
                }
            }
        })
        history.go(0);
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