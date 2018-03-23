$(function () {
    $(".General").hide();
    $("#SelectLi").show();
    if ($("input[name = 'con2463']").val() != undefined) {
        $("#location").val($("input[name = 'con2463']").eq(0).val());
    }
})

function Forward() {
    var ids = GetIds();
    if (ids != "") {
        window.open("../ServiceDesk/TicketModify?ticketIds=" + ids, windowObj.masterTicket + windowType.manage, 'left=200,top=200,width=1280,height=800', false);
    }
    else {
        LayerMsg("请选择相关子工单！");
    }
}

function DeleteChoose() {
    var ids = GetIds();
    if (ids != "") {
        LayerConfirm("确认删除该工单吗？", "是", "否", function () {
            $.ajax({
                type: "GET",
                url: "../Tools/TicketAjax.ashx?act=DeleteTicketByIds&ids=" + ids,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data) {
                            LayerMsg("删除成功！");
                        }
                        else {
                            LayerMsg("部分工单删除失败！");
                        }
                        setTimeout(function () { history.go(0); }, 800);
                    }
                }
            })
        }, function () { });
    }
    else {
        LayerMsg("请选择相关子工单！");
    }
}

function ViewTicket() {
    window.open("../ServiceDesk/TicketView?id=" + entityid, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
}

function EditTicket() {
    window.open("../ServiceDesk/TicketManage?id=" + entityid, windowObj.ticket + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
}

function DeletSinge() {
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
                    }
                    else {
                        if (data.reason != "") {
                            LayerMsg(data.reason);
                        }
                    }
                }
            }
        })
        setTimeout(function () { history.go(0); }, 800);
    }, function () {

    });
}

function DeleteAll() {
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId == "") {
        return;
    }
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?not_delete=1&act=DeleteMasterTicket&ticket_id=" + ticketId + "&delete_future=",
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    LayerMsg(data.dic["delete"] + "个子工单被删除<br />" + data.dic["no_delete"] + "个子工单不能删除<br />定期主工单被删除");
                }
                else {
                    LayerMsg(data.dic["delete"] + "个子工单被删除<br />" + data.dic["no_delete"] + "个子工单不能删除<br />定期主工单未被删除");
                }
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}

function DeleteInFuture() {
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId == "") {
        return;
    }
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?not_delete=1&act=DeleteMasterTicket&ticket_id=" + ticketId + "&delete_future=1",
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    LayerMsg(data.dic["delete"] + "个子工单被删除<br />" + data.dic["no_delete"] + "个子工单不能删除<br />定期主工单被删除");
                }
                else {
                    LayerMsg(data.dic["delete"] + "个子工单被删除<br />" + data.dic["no_delete"] + "个子工单不能删除<br />定期主工单未被删除");
                }
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}

function ForwardSingle() {
    window.open("../ServiceDesk/TicketModify?ticketIds=" + entityid, windowObj.masterTicket + windowType.manage, 'left=200,top=200,width=1280,height=800', false);
}

function ForwardFuture() {
    var ids = GetFutureIds();
    if (ids != "") {
        window.open("../ServiceDesk/TicketModify?ticketIds=" + ids, windowObj.masterTicket + windowType.manage, 'left=200,top=200,width=1280,height=800', false);
    }
}
function ForwardAll() {
    var ids = GetAllIds();
    if (ids != "") {
        window.open("../ServiceDesk/TicketModify?ticketIds=" + ids, windowObj.masterTicket + windowType.manage, 'left=200,top=200,width=1280,height=800', false);
    }
}
function EditService() {

}

$("#location").change(function () {
    var thisValue = $(this).val();
    var ticketId = "";
    if ($("input[name = 'con2114']").val() != undefined) {
        ticketId = $("input[name = 'con2114']").eq(0).val();
    }
    
    location.href = "../Common/SearchBodyFrame?cat=1601&type=186&con2114=" + ticketId + "&isCheck=1&con2463=" + thisValue;
})

function GetIds() {
    var ids = "";
    $(".IsChecked").each(function () {
        var thisValue = $(this).val();
        if ($(this).is(":checked")&&thisValue != "") {
            ids += thisValue + ",";
        }
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length-1);
    }
    return ids;
}

function GetAllIds() {
    var ids = "";
    $(".IsChecked").each(function () {
        var thisValue = $(this).val();
        if (thisValue != "") {
            ids += thisValue + ",";
        }
    })
    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
    }
    return ids;
}

function GetFutureIds() {
    var ids = "";
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId != "") {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=GetFutureIds&ticket_id=" + ticketId,
            success: function (data) {
                if (data != "") {
                    ids = data;
                }
            },
        });
    }
    return ids;
   
}

$("#CheckAll").click(function () {
    if ($(this).is(":checked")) {
        $(".IsChecked").prop("checked", true);
    }
    else {
        $(".IsChecked").prop("checked", false);
    }
})
